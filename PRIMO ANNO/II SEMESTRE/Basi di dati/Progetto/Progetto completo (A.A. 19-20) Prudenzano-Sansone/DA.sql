-- ----------------
--    Sintomo    --
-- ----------------
DROP TABLE IF EXISTS Sintomo;
CREATE TABLE Sintomo
(
    IDSintomo   INT NOT NULL AUTO_INCREMENT,
    Descrizione VARCHAR(100) NOT NULL,
    IDProdotto  INT NOT NULL,

    PRIMARY KEY (IDSintomo),
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- -------------------------
--    BaseDiConoscenza    --
-- -------------------------
DROP TABLE IF EXISTS BaseDiConoscenza;
CREATE TABLE BaseDiConoscenza
(
    IDBase  INT NOT NULL AUTO_INCREMENT,

    PRIMARY KEY (IDBase)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ------------
--    CBR    --
-- ------------
DROP TABLE IF EXISTS CBR;
CREATE TABLE CBR
(
    IDBase      INT NOT NULL,
    IDSintomo   INT NOT NULL,

    FOREIGN KEY (IDBase) REFERENCES BaseDiConoscenza(IDBase),
    FOREIGN KEY (IDSintomo) REFERENCES Sintomo(IDSintomo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- -----------------
--    Proposta    --
-- -----------------
DROP TABLE IF EXISTS Proposta;
CREATE TABLE Proposta
(
    IDBase          INT NOT NULL,
    CodiceRimedio   INT NOT NULL,

    FOREIGN KEY (IDBase) REFERENCES BaseDiConoscenza(IDBase),
    FOREIGN KEY (CodiceRimedio) REFERENCES Rimedio(CodiceRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------
--    Evidenza    --
-- -----------------
DROP TABLE IF EXISTS Evidenza;
CREATE TABLE Evidenza
(
    IDSintomo   INT NOT NULL,
    IDDomanda   INT NOT NULL,
    Risposta    BOOLEAN NOT NULL,

    FOREIGN KEY (IDSintomo) REFERENCES Sintomo(IDSintomo),
    FOREIGN KEY (IDDomanda) REFERENCES Domanda(IDDomanda)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP PROCEDURE IF EXISTS CBR_retrieve;
DELIMITER $$
CREATE PROCEDURE CBR_retrieve()
BEGIN

    DECLARE flag INT DEFAULT 0;
    DECLARE _IDProdotto INT;
    DECLARE inputSize INT;

    -- Creo la temp table per i sintomi per evitare errori se non esiste
    CREATE TEMPORARY TABLE IF NOT EXISTS sintomiInput(
        IDSintomo   INT NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    -- Controllo che ci siano sintomi inseriti
    SELECT COUNT(*) INTO flag
    FROM sintomiInput;

    IF flag = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nessun sintomo inserito';
    END IF;

    -- Controllo che tutti i sintomi siano dello stesso prodotto
    SELECT COUNT(DISTINCT IDProdotto) INTO flag
    FROM sintomiInput
    NATURAL JOIN Sintomo;

    IF flag <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'I sintomi non sono tutti dello stesso prodotto';
    END IF;

    -- Conto quanti sintomi ci sono in input
    SELECT COUNT(*) INTO inputSize
    FROM sintomiInput;

    -- Prendo l'ID del prodotto in questione
    SELECT DISTINCT IDProdotto INTO _IDProdotto
    FROM sintomiInput
    NATURAL JOIN Sintomo;

    -- COUNT(*) conta tutte le righe del gruppo
    -- COUNT(DISTINCT I.IDSintomo) conta solo le righe che fanno join, e che quindi fanno parte dell'intersezione
    WITH BasiEScore AS (
        SELECT IDBase, COUNT(DISTINCT I.IDSintomo) / (inputSize + COUNT(*) - COUNT(DISTINCT I.IDSintomo)) as Score
        FROM (
            SELECT IDSintomo
            FROM Sintomo
            WHERE IDProdotto = _IDProdotto
        ) AS S
        NATURAL JOIN CBR
        NATURAL JOIN BaseDiConoscenza
        LEFT OUTER JOIN sintomiInput I ON I.IDSintomo = S.IDSintomo
        GROUP BY IDBase
    )
    SELECT IDBase, Score, Descrizione, CodiceRimedio
    FROM BasiEScore
    NATURAL JOIN Proposta
    NATURAL JOIN Rimedio
    ORDER BY Score DESC;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS CBR_retain;
DELIMITER $$
CREATE PROCEDURE CBR_retain()
BEGIN

    DECLARE flag INT DEFAULT 0;
    DECLARE _IDProdotto INT;
    DECLARE inputSintomiSize INT;
    DECLARE inputRimediSize INT;
    DECLARE maxScore FLOAT DEFAULT 1;
    DECLARE nuovoID INT;


    -- Creo la temp table per i sintomi per evitare errori se non esiste
    CREATE TEMPORARY TABLE IF NOT EXISTS sintomiInput(
        IDSintomo   INT NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    -- Controllo che ci siano sintomi inseriti
    SELECT COUNT(*) INTO flag
    FROM sintomiInput;

    IF flag = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nessun sintomo inserito';
    END IF;

    -- Creo la temp table per i rimedi per evitare errori se non esiste
    CREATE TEMPORARY TABLE IF NOT EXISTS rimediInput(
        CodiceRimedio INT NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    -- Controllo che ci siano rimedi inseriti
    SELECT COUNT(*) INTO flag
    FROM rimediInput;

    IF flag = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nessun rimedio inserito';
    END IF;

    -- Controllo che tutti i sintomi siano dello stesso prodotto
    SELECT COUNT(DISTINCT IDProdotto) INTO flag
    FROM sintomiInput
    NATURAL JOIN Sintomo;

    IF flag <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'I sintomi non sono tutti dello stesso prodotto';
    END IF;

    -- Conto quanti sintomi ci sono in input
    SELECT COUNT(*) INTO inputSintomiSize
    FROM sintomiInput;

    -- Conto quanti rimedi ci sono in input
    SELECT COUNT(*) INTO inputRimediSize
    FROM rimediInput;

    -- Prendo l'ID del prodotto in questione
    SELECT DISTINCT IDProdotto INTO _IDProdotto
    FROM sintomiInput
    NATURAL JOIN Sintomo;

    -- COUNT(*) conta tutte le righe del gruppo
    -- COUNT(DISTINCT I.IDSintomo) conta solo le righe che fanno join, e che quindi fanno parte dell'intersezione
    WITH BasiEScoreSintomi AS (
        SELECT IDBase, COUNT(DISTINCT I.IDSintomo) / (inputSintomiSize + COUNT(*) - COUNT(DISTINCT I.IDSintomo)) AS ScoreSintomi
        FROM (
            SELECT IDSintomo
            FROM Sintomo
            WHERE IDProdotto = _IDProdotto
        ) AS S
        NATURAL JOIN CBR
        NATURAL JOIN BaseDiConoscenza
        LEFT OUTER JOIN sintomiInput I ON I.IDSintomo = S.IDSintomo
        GROUP BY IDBase
    ), BasiEScoreRimedi AS (
        SELECT IDBase, ScoreSintomi, COUNT(DISTINCT R.CodiceRimedio) / (inputRimediSize + COUNT(*) - COUNT(DISTINCT R.CodiceRimedio)) AS ScoreRimedi
        FROM BasiEScoreSintomi
        NATURAL JOIN Proposta P
        LEFT OUTER JOIN rimediInput R ON R.CodiceRimedio = P.CodiceRimedio
        GROUP BY IDBase
    )
    SELECT IFNULL(MAX((ScoreSintomi + ScoreRimedi)/2), 0) INTO maxScore
    FROM BasiEScoreRimedi;

    -- Se non supera il threshold allora aggiungo il caso alla base di conoscenza
    IF maxScore <= 0.5 THEN
        -- Creo la nuova base di conoscenza
        INSERT INTO basediconoscenza
        VALUES (DEFAULT);

        --  Prendo l'ID della nuova base creata
        SELECT LAST_INSERT_ID() INTO nuovoID;

        -- Inserisco i sintomi nella nuova base
        INSERT INTO CBR
            SELECT nuovoID, IDSintomo
            FROM sintomiInput;

        -- Inserisco i rimedi nella nuova base
        INSERT INTO Proposta
            SELECT nuovoID, CodiceRimedio
            FROM rimediInput;
    END IF;

    SELECT IF(maxScore <= 0.5,
                'Inserimento avvenuto',
                'Non è stato necessario inserire la base di conoscenza') AS Risultato;

END $$
DELIMITER ;







DROP FUNCTION IF EXISTS indiceUnitaPerse;

DELIMITER $$
CREATE FUNCTION indiceUnitaPerse(_IDSequenza INT)
RETURNS FLOAT NOT DETERMINISTIC
BEGIN
    DECLARE indexValue FLOAT DEFAULT 0;
    DECLARE flag INT DEFAULT 0;
    DECLARE errorMessage VARCHAR(100) DEFAULT 'Non esiste nessuna sequenza con ID: ';

    SELECT COUNT(*) INTO flag
    FROM SequenzaDiOperazioni
    WHERE IDSequenza = _IDSequenza;

    IF flag = 0 THEN
        SET errorMessage = CONCAT(errorMessage, _IDSequenza);
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = errorMessage;
    END IF;

    WITH rapportoPerLotto AS (
        SELECT (SUM(UP.Quantita) / L.Quantita) as Li
        FROM Lotto L
        INNER JOIN unitaperse UP USING(CodiceLotto)
        WHERE L.IDSequenza = _IDSequenza
        GROUP BY L.CodiceLotto, L.Quantita
    )
    SELECT IFNULL(1 - AVG(Li), 1) INTO indexValue
    FROM rapportoPerLotto;

    RETURN indexValue;

END $$
DELIMITER ;

DROP FUNCTION IF EXISTS indiceDistrubuzioneOperazioni;

DELIMITER $$
CREATE FUNCTION indiceDistrubuzioneOperazioni(_IDSequenza INT)
RETURNS FLOAT NOT DETERMINISTIC
BEGIN
    DECLARE indexValue FLOAT DEFAULT 0;
    DECLARE average FLOAT DEFAULT 0;
    DECLARE epsilon FLOAT DEFAULT 1;
    DECLARE tau INT DEFAULT 0;
    DECLARE flag INT DEFAULT 0;
    DECLARE errorMessage VARCHAR(100) DEFAULT 'Non esiste nessuna sequenza con ID: ';

    SELECT COUNT(*) INTO flag
    FROM SequenzaDiOperazioni
    WHERE IDSequenza = _IDSequenza;

    IF flag = 0 THEN
        SET errorMessage = CONCAT(errorMessage, _IDSequenza);
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = errorMessage;
    END IF;

    WITH conteggioPerStazione AS (
        SELECT COUNT(*) AS Oi
        FROM stazione
        NATURAL JOIN Fase
        WHERE IDSequenza = _IDSequenza
        GROUP BY IDStazione
    )
    SELECT AVG(Oi) INTO average
    FROM conteggioPerStazione;

    SET epsilon = average / 5;

    WITH inRange AS (
        SELECT 1 as taui
        FROM stazione
        NATURAL JOIN Fase
        WHERE IDSequenza = _IDSequenza
        GROUP BY IDStazione
        HAVING COUNT(*) BETWEEN average - epsilon AND average + epsilon
    )
    SELECT IFNULL(SUM(taui), 0) INTO tau
    FROM inRange;

    SELECT tau / COUNT(DISTINCT IDStazione) INTO indexValue
    FROM stazione
    WHERE IDSequenza = _IDSequenza;

    RETURN indexValue;
END $$
DELIMITER ;

/*
DROP PROCEDURE IF EXISTS valutaSequenza;
DELIMITER $$
CREATE PROCEDURE valutaSequenza(_IDSequenza INT)
BEGIN
    SELECT 'Unità perse', indiceUnitaPerse(_IDSequenza) as Score
    UNION
    SELECT 'Distribuzioni operazione', indiceDistrubuzioneOperazioni(_IDSequenza) as Score;
END $$
DELIMITER ;
*/

-- Versione dinamica di valutaSequenza
DROP TABLE IF EXISTS IndiciAnalitici;
CREATE TABLE IndiciAnalitici
(
    Descrizione     VARCHAR(100) NOT NULL,
    NomeFunzione    VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO IndiciAnalitici
VALUES  ('Unità perse', 'indiceUnitaPerse'),
        ('Distribuzioni operazione', 'indiceDistrubuzioneOperazioni');

DROP PROCEDURE IF EXISTS valutaSequenza;

DELIMITER $$
CREATE PROCEDURE valutaSequenza(_IDSequenza INT)
BEGIN

    -- SELECT '<Descrizione>', NomeFunzione(_IDSequenza) AS Score

    SELECT GROUP_CONCAT(
    	CONCAT('SELECT "', Descrizione, '", ', NomeFunzione,'(', _IDSequenza, ') AS Score' )
        SEPARATOR ' UNION '
    ) INTO @p_query
    FROM IndiciAnalitici;

    PREPARE prepared FROM @p_query;
    EXECUTE prepared;

END $$
DELIMITER ;