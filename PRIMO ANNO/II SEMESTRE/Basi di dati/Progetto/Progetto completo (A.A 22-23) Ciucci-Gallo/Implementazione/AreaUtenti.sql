-- ----------------------------
-- AREA UTENTI
-- ----------------------------

CREATE TABLE IF NOT EXISTS `Utente` (
	`Codice` VARCHAR(100) NOT NULL PRIMARY KEY,
	`Nome` VARCHAR(50),
	`Cognome` VARCHAR(50),
	`Email` VARCHAR(100) NOT NULL,
	`Password` VARCHAR(100) NOT NULL,
	`Abbonamento` VARCHAR(50),
	`DataInizioAbbonamento` DATE,

	CHECK(`Email` REGEXP '[A-Za-z0-9]{1,}[\.\-A-Za-z0-9]{0,}[a-zA-Z0-9]@[a-z]{1}[\.\-\_a-z0-9]{0,}\.[a-z]{1,10}')
) Engine=InnoDB;


CREATE TABLE IF NOT EXISTS `Recensione` (
	`Film` INT NOT NULL,
	`Utente` VARCHAR(100) NOT NULL, 
	`Voto` FLOAT,

	PRIMARY KEY(`Film`, `Utente`),
	FOREIGN KEY(`Film`) REFERENCES `Film` (`ID`)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(`Utente`) REFERENCES `Utente` (`Codice`)
		ON UPDATE CASCADE ON DELETE CASCADE,

	CHECK(`Voto` BETWEEN 0.0 AND 5.0)
) Engine=InnoDB;

DROP TRIGGER IF EXISTS `InserimentoRecensione`;
DROP TRIGGER IF EXISTS `CancellazioneRecensione`;
DROP TRIGGER IF EXISTS `ModificaRecensione`;

DROP PROCEDURE IF EXISTS `AggiungiRecensione`;
DROP PROCEDURE IF EXISTS `RimuoviRecensione`;

DELIMITER $$

CREATE TRIGGER `InserimentoRecensione`
AFTER INSERT ON `Recensione`
FOR EACH ROW
BEGIN
	CALL AggiungiRecensione(NEW.`Film`, NEW.`Voto`);
END ; $$

CREATE TRIGGER `CancellazioneRecensione`
AFTER DELETE ON `Recensione`
FOR EACH ROW
BEGIN
	CALL RimuoviRecensione(OLD.`Film`, OLD.`Voto`);
END ; $$

CREATE TRIGGER `ModificaRecensione`
AFTER UPDATE ON `Recensione`
FOR EACH ROW
BEGIN
	CALL AggiungiRecensione(NEW.`Film`, NEW.`Voto`);
	CALL RimuoviRecensione(OLD.`Film`, OLD.`Voto`);
END ; $$

CREATE PROCEDURE `AggiungiRecensione`(IN Film_ID INT, IN ValoreVoto FLOAT)
BEGIN
	UPDATE `Film`
	SET 
		`Film`.`NumeroRecensioni` = `Film`.`NumeroRecensioni` + 1,
		`Film`.`MediaRecensioni` = IF (
			`Film`.`MediaRecensioni` IS NULL,
			ValoreVoto,
			(`Film`.`MediaRecensioni` * `Film`.`NumeroRecensioni` + ValoreVoto) / (`Film`.`NumeroRecensioni` + 1))
	WHERE `Film`.`ID` = Film_ID;
END ; $$

CREATE PROCEDURE `RimuoviRecensione`(IN Film_ID INT, IN ValoreVoto FLOAT)
BEGIN
	UPDATE `Film`
	SET 
		`Film`.`NumeroRecensioni` = `Film`.`NumeroRecensioni` - 1,
		`Film`.`MediaRecensioni` = IF (
			`Film`.`NumeroRecensioni` = 1,
			NULL,
			(`Film`.`MediaRecensioni` * `Film`.`NumeroRecensioni` - ValoreVoto) / (`Film`.`NumeroRecensioni` - 1))
	WHERE `Film`.`ID` = Film_ID AND `Film`.`NumeroRecensioni` > 0;
END ; $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `Connessione` (
	`IP` INT UNSIGNED NOT NULL,
	`Inizio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`Utente` VARCHAR(100) NOT NULL,
	`Fine` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Hardware` VARCHAR(256) NOT NULL DEFAULT 'Dispositivo sconosciuto',

	-- Chiavi
	PRIMARY KEY (`IP`, `Inizio`, `Utente`),
	FOREIGN KEY (`Utente`) REFERENCES `Utente` (`Codice`) ON UPDATE CASCADE ON DELETE CASCADE,

	-- Vincoli di dominio
	-- CHECK (`IP` >= 16777216), -- Un IP non puo' assumere tutti i valori di un intero
	CHECK (`Fine` >= `Inizio`)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Visualizzazione` (
    `IP` INT UNSIGNED NOT NULL,
    `InizioConnessione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `Utente` VARCHAR(100) NOT NULL,
    `Edizione` INT NOT NULL,
    `Timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY(`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`),
    FOREIGN KEY (`Utente`, `IP`, `InizioConnessione`) REFERENCES `Connessione` (`Utente`, `IP`, `Inizio`)
      ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`Edizione`) REFERENCES `Edizione` (`ID`)
      ON DELETE CASCADE ON UPDATE CASCADE,

	CHECK (`Timestamp` >= `InizioConnessione`)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Abbonamento` (
    `Tipo` VARCHAR(50) NOT NULL PRIMARY KEY,
    `Tariffa` FLOAT NOT NULL,
    `Durata` INT NOT NULL,
    `Definizione` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `Offline` BOOLEAN DEFAULT FALSE,
    `MaxOre` INT DEFAULT 28,
    `GBMensili` INT,
    CHECK (`Tariffa` >= 0),
    CHECK (`Durata` >= 0),
    CHECK (`Definizione` >= 0),
    CHECK (`GBMensili` >= 0)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Esclusione` (
    `Abbonamento` VARCHAR(50) NOT NULL,
    `Genere` VARCHAR(50) NOT NULL,

    PRIMARY KEY(`Abbonamento`, `Genere`),
    FOREIGN KEY (`Abbonamento`) REFERENCES `Abbonamento` (`Tipo`)
      ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`Genere`) REFERENCES `Genere` (`Nome`)
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `CartaDiCredito` (
    `PAN` BIGINT NOT NULL PRIMARY KEY,
    `Scadenza` DATE,
    `CVV` SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS `Fattura` (
    `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Utente` VARCHAR(100) NOT NULL,
    `DataEmissione` DATE NOT NULL,
    `DataPagamento` DATE,
    `CartaDiCredito` BIGINT DEFAULT NULL,

	FOREIGN KEY (`Utente`) REFERENCES `Utente`(`Codice`) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (`CartaDiCredito`) REFERENCES `CartaDiCredito`(`PAN`) ON UPDATE CASCADE ON DELETE CASCADE,

    CHECK (`DataPagamento` >= `DataEmissione`)
);

CREATE TABLE IF NOT EXISTS `VisualizzazioniGiornaliere` (
    `Film` INT NOT NULL,
	`Paese` CHAR(2) NOT NULL DEFAULT '??',
    `Data` DATE NOT NULL,

    `NumeroVisualizzazioni` INT DEFAULT 0,
    
	-- Chiavi
	PRIMARY KEY (`Film`, `Paese`, `Data`),
    FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`Paese`) REFERENCES `Paese` (`Codice`)
        ON DELETE CASCADE ON UPDATE CASCADE,

	-- Vincoli di dominio
    CHECK (`NumeroVisualizzazioni` >= 0)
);

DROP PROCEDURE IF EXISTS `VisualizzazoniGiornaliereBuild`;
DROP PROCEDURE IF EXISTS `VisualizzazoniGiornaliereFullReBuild`;
DROP EVENT IF EXISTS `VisualizzazioniGiornaliereEvent`;

DELIMITER $$

CREATE PROCEDURE `VisualizzazoniGiornaliereBuild` ()
proc_body:BEGIN

	DECLARE `data_target` DATE DEFAULT SUBDATE(CURRENT_DATE, 1);

	IF EXISTS (
		SELECT v.*
		FROM `VisualizzazioniGiornaliere` v
		WHERE v.`Data` = `data_target`
	) THEN

		SIGNAL SQLSTATE '01000'
			SET MESSAGE_TEXT = 'Procedura già lanciata oggi!';
		LEAVE proc_body;
	END IF;

	INSERT INTO `VisualizzazioniGiornaliere` (`Film`, `Paese`, `Data`, `NumeroVisualizzazioni`)
		WITH `VisFilmData` AS (
			SELECT V.`IP`, E.`Film`, DATE(V.`Timestamp`) AS "Data", V.`InizioConnessione`
			FROM `Visualizzazione` V
				INNER JOIN `Edizione` E ON E.`ID` = V.`Edizione`
		)
		SELECT V.`Film`, IFNULL(r.`Paese`, '??') AS "Paese", V.`Data`, COUNT(*)
		FROM `VisFilmData` V
			LEFT OUTER JOIN `IPRange` r ON     	
				(V.`IP` BETWEEN r.`Inizio` AND r.`Fine`) AND 
        		(V.`InizioConnessione` BETWEEN r.`DataInizio` AND IFNULL(r.`DataFine`, CURRENT_TIMESTAMP))
		WHERE V.`Data` = `data_target`
		GROUP BY V.`Film`, "Paese", V.`Data`;
END ; $$

CREATE PROCEDURE `VisualizzazoniGiornaliereFullReBuild` ()
BEGIN
	DECLARE `min_date` DATE DEFAULT SUBDATE(CURRENT_DATE, 32);

	REPLACE INTO `VisualizzazioniGiornaliere` (`Film`, `Paese`, `Data`, `NumeroVisualizzazioni`)
		WITH `VisFilmData` AS (
			SELECT V.`IP`, E.`Film`, DATE(V.`Timestamp`) AS "Data", V.`InizioConnessione`
			FROM `Visualizzazione` V
				INNER JOIN `Edizione` E ON E.`ID` = V.`Edizione`
		)
		SELECT V.`Film`, IFNULL(r.`Paese`, '??') AS "Paese", V.`Data`, COUNT(*)
		FROM `VisFilmData` V
			LEFT OUTER JOIN `IPRange` r ON     	
				(V.`IP` BETWEEN r.`Inizio` AND r.`Fine`) AND 
        		(V.`InizioConnessione` BETWEEN r.`DataInizio` AND IFNULL(r.`DataFine`, CURRENT_TIMESTAMP))
		WHERE `min_date` <= V.`Data`
		GROUP BY V.`Film`, "Paese", V.`Data`;
END ; $$

CREATE EVENT `VisualizzazioniGiornaliereEvent`
ON SCHEDULE EVERY 1 DAY
DO
	CALL `VisualizzazoniGiornaliereBuild`();
$$

DELIMITER ;

DROP EVENT IF EXISTS `GestioneVisualizzazioni`;
CREATE EVENT `GestioneVisualizzazioni`
ON SCHEDULE EVERY 1 DAY
COMMENT 'Elimina le visualizzazioni scadute'
DO
    DELETE 
	FROM `Visualizzazione`
    WHERE `InizioConnessione` + INTERVAL 1 MONTH < CURRENT_DATE();

DROP EVENT IF EXISTS `GestioneConnessioni`;
CREATE EVENT `GestioneConnessioni`
ON SCHEDULE EVERY 1 DAY
COMMENT 'Elimina le connessioni scadute'
DO
    DELETE 
	FROM `Connessione`
    WHERE `Inizio` + INTERVAL 1 MONTH < CURRENT_DATE();

DROP EVENT IF EXISTS `GestioneErogazioni`;
CREATE EVENT `GestioneErogazioni`
ON SCHEDULE EVERY 1 HOUR
COMMENT 'Elimina le erogazioni scadute non precedentemente rimosse, evita inconsistenze'
DO
    DELETE
        E.*
    FROM `Erogazione` E
    	INNER JOIN `Edizione` Ed ON Ed.ID = E.`Edizione`
    WHERE 
		Ed.`Lunghezza` < TIMESTAMPDIFF(SECOND, E.`TimeStamp`, CURRENT_TIMESTAMP) + 1800 AND -- Visualizzazioni che dovrebbero essere terminate da almeno 30 minuti
		TIMESTAMPDIFF(MINUTE, E.`InizioErogazione`, CURRENT_TIMESTAMP) > 29; -- Erogazioni che non sono iniziate negli ultimi 30'

DROP EVENT IF EXISTS `GestioneFattura`;
CREATE EVENT `GestioneFattura`
ON SCHEDULE EVERY 1 MONTH
COMMENT 'Elimina le fatture scadute'
DO
    DELETE 
	FROM `Fattura`
    WHERE `DataPagamento` + INTERVAL 1 YEAR < CURRENT_DATE();