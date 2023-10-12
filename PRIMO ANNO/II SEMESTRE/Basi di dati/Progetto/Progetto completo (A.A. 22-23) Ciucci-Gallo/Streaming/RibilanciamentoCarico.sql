USE `FilmSphere`;

CREATE OR REPLACE VIEW `ServerConCarico` AS
    SELECT S.*, (S.`CaricoAttuale` / S.`MaxConnessioni`) AS "CaricoPercentuale"
    FROM `Server` S;

-- Materialized view che contiene i suggerimenti di Erogazioni da spostare e dove spostarle
-- Non è presente nell'ER perché i suoi volumi sono talmente piccoli da essere insignificante in confronto alle altre
-- La tabella è vista più come un sistema di comunicazione tra il DBMS che individua i client da spostare e i server (fisici)\
-- che devono sapere chi spostare
CREATE TABLE IF NOT EXISTS `ModificaErogazioni`
(
    -- Riferimenti a Erogazione
    `Server` INT NOT NULL, 
    `IP` INT UNSIGNED NOT NULL,
    `InizioConnessione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `Utente` VARCHAR(100) NOT NULL,
    `Edizione` INT NOT NULL,
    `Timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Alternativa
    `Alternativa` INT NOT NULL, 
    `File` INT NOT NULL, 
    `Punteggio` FLOAT NOT NULL,

    PRIMARY KEY(`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`),
    FOREIGN KEY (`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`)
        REFERENCES `Erogazione`(`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`) 
            ON UPDATE CASCADE ON DELETE CASCADE,

    FOREIGN KEY(`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(`Alternativa`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(`File`) REFERENCES `File`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE
) Engine=InnoDB;


DROP PROCEDURE IF EXISTS `RibilanciamentoCarico`;
DROP EVENT IF EXISTS `RibilanciamentoCaricoEvent`;

DELIMITER $$

CREATE PROCEDURE `RibilanciamentoCarico` ()
ribilancia_body:BEGIN
    -- Variables declaration
    DECLARE `MaxCarichi` FLOAT DEFAULT 0.0;
    DECLARE `MediaCarichi` FLOAT DEFAULT NULL;
    DECLARE fetching BOOLEAN DEFAULT TRUE;

    -- Utente, Server e Visualizzazione
    DECLARE server_id INT DEFAULT NULL;
    DECLARE edizione_id INT DEFAULT NULL;
    DECLARE ip_utente INT UNSIGNED DEFAULT NULL;
    DECLARE paese_utente CHAR(2) DEFAULT '??';
    DECLARE codice_utente VARCHAR(100) DEFAULT NULL;
    DECLARE max_definiz BIGINT DEFAULT 0;
    DECLARE timestamp_vis TIMESTAMP DEFAULT NULL;
    DECLARE timestamp_conn TIMESTAMP DEFAULT NULL;

    -- Server da escludere (perche' carichi)
    DECLARE server_da_escludere VARCHAR(32) DEFAULT NULL;

    -- Cursor declaration
    DECLARE cur CURSOR FOR
        WITH `ServerPiuCarichi` AS (
            SELECT S.`ID`
            FROM `ServerConCarico` S
            WHERE S.`CaricoPercentuale` >= (SELECT AVG(`CaricoPercentuale`) FROM `ServerConCarico`)
            ORDER BY S.`CaricoPercentuale` DESC
            LIMIT 3
        ), `ServerErogazioni` AS (
            SELECT E.*, TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, E.`TimeStamp`) AS "TempoTrascorso"
            FROM `ServerPiuCarichi` S
                INNER JOIN `Erogazione` E ON S.`ID` = E.`Server`
            WHERE TIMESTAMPDIFF(MINUTE, E.`InizioErogazione`, CURRENT_TIMESTAMP) > 29
        ), `ErogazioniNonAlTermine` AS (
            SELECT E.*, E.`InizioConnessione` AS "Inizio", (Ed.`Lunghezza` - E.TempoTrascorso) AS "TempoMancante"
            FROM `ServerErogazioni` E
                INNER JOIN `Edizione` Ed ON E.`Edizione` = Ed.`ID`
                -- Calcolo quanto dovrebbe mancare al termine della visione e controllo che sia sotto i 10 min
            HAVING "TempoMancante" <= 600
        )
        SELECT 
            E.`Server`, E.`Edizione`, E.`IP`,
            E.`Utente`, A.`Definizione`,
            E.`TimeStamp`, E.`InizioConnessione`,
            GROUP_CONCAT(DISTINCT S.`ID` SEPARATOR ',') AS "ServerDaEscludere"
        FROM `ErogazioniNonAlTermine` E
            INNER JOIN `Utente` U ON U.`Codice` = E.`Utente`
            INNER JOIN `Abbonamento` A ON A.`Tipo` = U.`Abbonamento`
            CROSS JOIN `ServerPiuCarichi` S
        GROUP BY E.`Edizione`, E.`IP`, E.`Utente`, A.`Definizione`, E.`TimeStamp`, E.`InizioConnessione`;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET fetching = FALSE;

    CREATE TEMPORARY TABLE IF NOT EXISTS `AlternativaErogazioni`
    (
        -- Riferimenti a Erogazione
        `Server` INT NOT NULL, 
        `IP` INT UNSIGNED NOT NULL,
        `InizioConnessione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        `Utente` VARCHAR(100) NOT NULL,
        `Edizione` INT NOT NULL,
        `Timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        -- Alternativa
        `Alternativa` INT NOT NULL, 
        `File` INT NOT NULL, 
        `Punteggio` FLOAT NOT NULL,

        PRIMARY KEY(`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`)
    ) Engine=InnoDB;

    -- Actual operations
    SELECT MAX(`CaricoPercentuale`), AVG(`CaricoPercentuale`) INTO `MaxCarichi`, `MediaCarichi`
    FROM `ServerConCarico`;

    IF `MediaCarichi` IS NULL OR `MaxCarichi` < 0.7 THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = "Non c'è bisogno di ribilanciare le Erogazioni";
        LEAVE ribilancia_body;
    END IF;

    TRUNCATE `AlternativaErogazioni`;
    
    OPEN cur;

    ciclo:LOOP
        FETCH cur INTO 
            server_id, edizione_id, 
            ip_utente, codice_utente, max_definiz,
            timestamp_vis, timestamp_conn,
            server_da_escludere;
        
        IF NOT fetching THEN
            LEAVE ciclo;
        END IF;

        SET paese_utente = Ip2PaeseStorico(ip_utente, timestamp_conn);

        CALL `TrovaMigliorServer`(
            edizione_id, paese_utente, max_definiz, 
            0, 0,
            NULL, NULL,
            server_da_escludere,
            @FileID, @ServerID, @Punteggio);

        IF @FileID IS NOT NULL AND @ServerID IS NOT NULL THEN
            INSERT INTO `AlternativaErogazioni` (
                `Server`, `Utente`, `Edizione`,
                `Timestamp`, `InizioConnessione`, `IP`,
                `Alternativa`, `File`, `Punteggio`) VALUES (
                    server_id, codice_utente, edizione_id,
                    timestamp_vis, timestamp_conn, ip_utente,
                    @ServerID, @FileID, @Punteggio);
        END IF;
        
    END LOOP;

    CLOSE cur;

    -- Prepariamo la tabella per i nuovi suggerimenti
    DELETE
    FROM `ModificaErogazioni`;

    IF (SELECT COUNT(*) FROM `AlternativaErogazioni`) = 0 THEN
        -- Non ci sono opzioni, esco
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = "Non ci sono opzioni di ribilanciamento";
        LEAVE ribilancia_body;
    END IF;

    INSERT INTO `ModificaErogazioni`(
                `Server`, `Utente`, `Edizione`,
                `Timestamp`, `InizioConnessione`, `IP`,
                `Alternativa`, `File`, `Punteggio`)
                
        WITH `ConClassifica` AS (
            SELECT A.*, RANK() OVER (
                PARTITION BY A.`Server`
                ORDER BY A.`Punteggio` ASC
            ) Classifica
            FROM `AlternativaErogazioni` A
        ) 
        SELECT 
            A.`Server`, A.`Utente`, A.`Edizione`, 
            A.`Timestamp`, A.`InizioConnessione`, A.`IP`, 
            A.`Alternativa`, A.`File`, A.`Punteggio`
        FROM `ConClassifica` A
            INNER JOIN `Server` S ON A.`Server` = S.`ID`
        WHERE A.`Classifica` <= FLOOR(S.`MaxConnessioni` / 20) + 1; -- Per ogni Server sposto al massimo il 5% del suo MaxConnessioni

END ; $$

CREATE EVENT `RibilanciamentoCaricoEvent`
ON SCHEDULE EVERY 10 MINUTE
DO
    CALL `RibilanciamentoCarico`();
$$

DELIMITER ;