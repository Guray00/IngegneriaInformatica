USE `FilmSphere`;

DROP FUNCTION IF EXISTS `MathMap`;
DROP FUNCTION IF EXISTS `StrListContains`;
DROP FUNCTION IF EXISTS `CalcolaDelta`;
DROP PROCEDURE IF EXISTS `MigliorServer`;
DROP PROCEDURE IF EXISTS `TrovaMigliorServer`;

DELIMITER $$

CREATE PROCEDURE `MigliorServer` (

    -- Dati sull'utente e la connessione
    IN id_utente VARCHAR(100), -- Codice di Utente
    IN id_edizione INT, -- ID di Edizione che si intende guardare
    IN ip_connessione INT UNSIGNED, -- Indirizzo IP4 della connessione
    
    -- Dati su capacita' dispositivo client e potenza della sua connessione
    IN MaxBitRate FLOAT,
    IN MaxRisoluz BIGINT,

    -- Liste di encoding video e audio supportati dal client, separati da ','
    IN ListaVideoEncodings VARCHAR(256), -- NULL significa qualunque encoding e' supportato
    IN ListaAudioEncodings VARCHAR(256), -- NULL significa qualunque encoding e' supportato

    -- Parametri restituiti
    OUT FileID INT, -- ID del File da guardare
    OUT ServerID INT -- Server dove tale File e' presente
) BEGIN
    DECLARE paese_utente CHAR(2) DEFAULT '??';
    DECLARE abbonamento_utente VARCHAR(50) DEFAULT NULL;
    DECLARE max_definizione BIGINT DEFAULT NULL;

    IF id_utente IS NULL OR id_edizione IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parametri NULL non consentiti';
    END IF;


    SELECT A.`Tipo`, A.`Definizione`
        INTO abbonamento_utente, max_definizione
    FROM `Abbonamento` A
        INNER JOIN `Utente` U ON `U`.`Abbonamento` = A.`Tipo`
    WHERE U.`Codice` = id_utente;

    IF abbonamento_utente IS NULL THEN
         SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;

    IF EXISTS (
        SELECT *
        FROM `Esclusione`
            INNER JOIN `GenereFilm` USING (`Genere`)
            INNER JOIN `Edizione` USING (`Film`)
        WHERE `ID` = id_edizione AND `Abbonamento` = abbonamento_utente) THEN
        
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Contenuto non disponibile nel tuo piano di abbonamento!';
    END IF;

    -- Calcolo il Paese dai Range
    SET paese_utente = Ip2Paese(ip_connessione);

    IF EXISTS (
        SELECT *
        FROM `Restrizione` r
        WHERE r.`Edizione` = id_edizione AND r.`Paese` = paese_utente) THEN
        
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Contenuto non disponibile nella tua regione!';
    END IF;

    CALL `TrovaMigliorServer` (
        id_edizione, paese_utente, 
        max_definizione, MaxBitRate, MaxRisoluz, 
        ListaVideoEncodings, ListaAudioEncodings, NULL, @File, @Server, @Score);
    SET FileID = @File;
    SET ServerID = @Server;
    -- SELECT @File, @Server, @Score, paese_utente, max_definizione;
    -- @Score non viene restituito
END $$

CREATE PROCEDURE `TrovaMigliorServer` (

    -- Dati sulla connessione
    IN id_edizione INT, -- ID di Edizione che si intende guardare
    IN paese_utente CHAR(2), -- Paese dell'Utente
    IN MaxRisoluzAbbonamento BIGINT,
    
    -- Dati su capacita' dispositivo client e potenza della sua connessione
    IN MaxBitRate FLOAT, -- NULL significa ricercare il minor BitRate possibile
    IN MaxRisoluz BIGINT, -- NULL significa ricercare la minor Risoluzione possibile

    -- Liste di encoding video e audio supportati dal client, separati da ','
    IN ListaVideoEncodings VARCHAR(256), -- NULL significa qualunque encoding e' supportato
    IN ListaAudioEncodings VARCHAR(256), -- NULL significa qualunque encoding e' supportato

    IN ServerDaEscludere VARCHAR(32), -- Lista di ID di Server che per vari motivi vanno esclusi

    -- Parametri restituiti
    OUT FileID INT, -- ID del File da guardare
    OUT ServerID INT, -- Server dove tale File e' presente
    OUT Score INT -- Punteggio della scelta
) BEGIN
    DECLARE max_definizione BIGINT DEFAULT NULL;
    DECLARE wRis FLOAT DEFAULT 5.0;
    DECLARE wRate FLOAT DEFAULT 3.0;
    DECLARE wPos FLOAT DEFAULT 12.0;
    DECLARE wCarico FLOAT DEFAULT 10.0;


    -- Prima di calcolare il Server migliore individuo le caratteristiche che deve avere il File
    
    SET max_definizione = IFNULL(
        LEAST(MaxRisoluz, IFNULL(MaxRisoluzAbbonamento, MaxRisoluz)), 
        0);

    -- SELECT max_definizione, MaxBitRate, ListaAudioEncodings, ListaVideoEncodings, ServerDaEscludere, paese_utente;

    WITH `FileDisponibili` AS (
        SELECT 
            F.`ID`, 
            CalcolaDelta(max_definizione, F.`Risoluzione`) AS "DeltaRis", 
            CalcolaDelta(MaxBitRate, F.`BitRate`) AS "DeltaRate"
        FROM `File` F
            INNER JOIN `Edizione` E ON E.`ID` = F.`Edizione`
        WHERE 
            E.`ID` = id_edizione AND 
            (ListaAudioEncodings IS NULL OR StrListContains(ListaAudioEncodings, F.`FamigliaAudio`)) AND
            (ListaVideoEncodings IS NULL OR StrListContains(ListaVideoEncodings, F.`FamigliaVideo`))
    ), `ServerDisponibili` AS (
        SELECT S.`ID`, S.`CaricoAttuale`, S.`MaxConnessioni`
        FROM `Server` S
        WHERE S.`CaricoAttuale` < 1 AND NOT StrListContains(ServerDaEscludere, S.`ID`) 
    ), `FileServerScore` AS (
        SELECT 
            F.`ID`,
            P.`Server`,
            MathMap(F.`DeltaRis`, 0.0, 16384, 0, wRis) AS "ScoreRis",
            MathMap(F.`DeltaRate`, 0.0, 1.4 * 1024 * 1024 * 1024, 0, wRate) AS "ScoreRate",
            MathMap(D.`ValoreDistanza`, 0.0, 40000, 0, wPos) AS "ScoreDistanza",
            MathMap(S.`CaricoAttuale`, 0.0, S.`MaxConnessioni`, 0, wCarico) AS "ScoreCarico"
        FROM `FileDisponibili` F
            INNER JOIN `PoP` P ON P.`File` = F.`ID`
            INNER JOIN `DistanzaPrecalcolata` D USING(`Server`)
            INNER JOIN `ServerDisponibili` S ON S.`ID` = P.`Server`
        WHERE D.`Paese` = paese_utente
    ), `Scelta` AS (
        SELECT 
            F.`ID`, F.`Server`,
            (F.ScoreRis + F.ScoreRate + F.ScoreDistanza + F.ScoreCarico) AS "Score"
        FROM `FileServerScore` F
        ORDER BY "Score" ASC -- Minore e' lo Score migliore e' la scelta
        LIMIT 1
    )
    SELECT S.`ID`, S.`Server`, S.`Score` INTO FileID, ServerID, Score
    FROM `Scelta` S;
END $$

CREATE FUNCTION `MathMap`(
    X FLOAT,
    inMin FLOAT,
    inMax FLOAT,
    outMin FLOAT,
    outMax FLOAT
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    RETURN outMin + (outMax - outMin) * (x - inMin) / (inMax - inMin);
END $$

CREATE FUNCTION `CalcolaDelta`(
    Max FLOAT,
    Valore FLOAT
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    IF Max IS NULL THEN
        RETURN IF (
            Valore < 0.0,
            Valore * (-1),
            2.0 * Valore
        );
    END IF;

    RETURN IF (
        Max > Valore,
        Max - Valore,
        2.0 * (Valore - Max)
    );
END $$

CREATE FUNCTION `StrListContains` (
    `Pagliaio` VARCHAR(256),
    `Ago` VARCHAR(10)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE PagliaioRidotto VARCHAR(256);
    SET PagliaioRidotto = Pagliaio;

    IF Pagliaio IS NULL OR LENGTH(Pagliaio) = 0 THEN
        RETURN FALSE;
    END IF;

    WHILE PagliaioRidotto <> '' DO

        IF TRIM(LOWER(SUBSTRING_INDEX(PagliaioRidotto, ',', 1))) = TRIM(LOWER(`Ago`)) THEN
            -- Ignoro gli spazi e il CASE della stringa: gli spazi creare dei falsi negativi, 
            -- mentre la stringa Ago potrebbe venire inviata con case dipendenti dalla piattaforma del client
            RETURN TRUE;
        END IF; 
        
        IF LOCATE(',', PagliaioRidotto) > 0 THEN
            SET PagliaioRidotto = SUBSTRING(PagliaioRidotto, LOCATE(',', PagliaioRidotto) + 1);
        ELSE
            SET PagliaioRidotto = '';
        END IF;
        
    END WHILE;

    RETURN FALSE;
END $$

DELIMITER ;