-- ----------------------------
-- CREAZIONE DB
-- ----------------------------

DROP DATABASE IF EXISTS `FilmSphere`;

CREATE DATABASE `FilmSphere`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;          -- UNICODE UTF-8 USED (https://dev.mysql.com/doc/refman/8.0/en/charset.html)

USE `FilmSphere`;

-- ----------------------------
-- AREA CONTENUTI
-- ----------------------------

CREATE TABLE IF NOT EXISTS `Paese` (
  `Codice` CHAR(2) NOT NULL PRIMARY KEY,
  `Nome` VARCHAR(50) NOT NULL,
  `Posizione` POINT DEFAULT NULL,

  CHECK (ST_X(`Posizione`) BETWEEN -180.00 AND 180.00), -- Contollo longitudine
  CHECK (ST_Y(`Posizione`) BETWEEN -90.00 AND 90.00) -- Controllo latitudine
) Engine=InnoDB;

-- Riga automatica necessaria per alcune funzionalita'
INSERT INTO `Paese` (`Codice`, `Nome`) VALUES ('??', 'Mondo');

CREATE TABLE IF NOT EXISTS `Artista` (
  `Nome` VARCHAR(50) NOT NULL,
  `Cognome` VARCHAR(50) NOT NULL,
  `Popolarita` FLOAT NOT NULL,    

  PRIMARY KEY(`Nome`, `Cognome`),
  CHECK(Popolarita BETWEEN 0.0 AND 10.0)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `CasaProduzione` (
  `Nome` VARCHAR(50) NOT NULL PRIMARY KEY,
  `Paese` CHAR(2) NOT NULL,
  FOREIGN KEY (`Paese`) REFERENCES `Paese` (`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
) Engine=InnoDB;


CREATE TABLE IF NOT EXISTS `Film` (
  `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Titolo` VARCHAR(100) NOT NULL,
  `Descrizione` VARCHAR(500) NOT NULL,
  `Anno` YEAR NOT NULL,
  `CasaProduzione` VARCHAR(50) NOT NULL,  
  `NomeRegista` VARCHAR(50) NOT NULL, 
  `CognomeRegista` VARCHAR(50) NOT NULL,  

  `MediaRecensioni` FLOAT DEFAULT NULL,
  `NumeroRecensioni` INT NOT NULL DEFAULT 0,
  
  
  FOREIGN KEY (`CasaProduzione`) REFERENCES `CasaProduzione` (`Nome`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`NomeRegista`, `CognomeRegista`) REFERENCES `Artista` (`Nome`, `Cognome`)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CHECK(`MediaRecensioni` BETWEEN 0.0 AND 5.0),
  CHECK(`NumeroRecensioni` >= 0)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `VincitaPremio` (
  `Macrotipo` VARCHAR(50) NOT NULL,
  `Microtipo` VARCHAR(50) NOT NULL,
  `Data` YEAR NOT NULL,
  `Film` INT NOT NULL,
  `NomeArtista` VARCHAR(50),
  `CognomeArtista` VARCHAR(50),

  PRIMARY KEY(`Macrotipo`, `Microtipo`, `Data`),
  FOREIGN KEY(`Film`) REFERENCES `Film` (`ID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`NomeArtista`, `CognomeArtista`) REFERENCES `Artista` (`Nome`, `Cognome`)
    ON UPDATE CASCADE ON DELETE CASCADE 
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Recitazione` (
  `Film` INT NOT NULL,
  `NomeAttore` VARCHAR(50) NOT NULL,
  `CognomeAttore` VARCHAR(50) NOT NULL,

  PRIMARY KEY(`Film`, `NomeAttore`, `CognomeAttore`),
  FOREIGN KEY(`Film`) REFERENCES `Film` (`ID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`NomeAttore`, `CognomeAttore`) REFERENCES `Artista` (`Nome`, `Cognome`)
    ON UPDATE CASCADE ON DELETE CASCADE 
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Critico` (
  `Codice` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nome` VARCHAR(50) NOT NULL,
  `Cognome` VARCHAR(50) NOT NULL
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Critica` (
  `Film` INT NOT NULL,
  `Critico` INT NOT NULL,

  `Testo` VARCHAR(512) NOT NULL,
  `Data` DATE NOT NULL,
  `Voto` FLOAT NOT NULL,

  PRIMARY KEY(`Film`, `Critico`),
  FOREIGN KEY(`Film`) REFERENCES `Film` (`ID`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(`Critico`) REFERENCES `Critico` (`Codice`)
    ON UPDATE CASCADE ON DELETE CASCADE, 

  CHECK(`Voto` BETWEEN 0.0 AND 5.0)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `Genere` (
  `Nome` VARCHAR(50) NOT NULL PRIMARY KEY
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `GenereFilm` (
  `Film` INT NOT NULL,
  `Genere` VARCHAR(50) NOT NULL,

  PRIMARY KEY(`Film`, `Genere`),
  FOREIGN KEY(`Film`) REFERENCES `Film` (`ID`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(`Genere`) REFERENCES `Genere` (`Nome`)
    ON UPDATE CASCADE ON DELETE CASCADE 
) Engine=InnoDB;

DROP TRIGGER IF EXISTS `CriticaDataValida`;

DELIMITER $$

CREATE TRIGGER `CriticaDataValida`
BEFORE INSERT ON `Critica` 
FOR EACH ROW
BEGIN
    DECLARE anno_film YEAR;
    
    SELECT F.`Anno` INTO anno_film
    FROM `Film` F
    WHERE F.`ID` = NEW.`Film`;

    IF anno_film > YEAR(NEW.`Data`) THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Data della Critica non valida!';
    END IF;

END $$

DELIMITER ;

-- ----------------------------
-- AREA FORMATO
-- ----------------------------

CREATE TABLE IF NOT EXISTS `Edizione` (
    -- Chiavi
    `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Film` INT NOT NULL,
    
    -- Anno di pubblicazione
    `Anno` YEAR NOT NULL DEFAULT 2023,
    
    -- Commento associato: Prima Edizone, Edizione Blu-Ray, ...
    `Tipo` VARCHAR(128),

    -- Durata in [s] del contenuto
    `Lunghezza` INT UNSIGNED NOT NULL DEFAULT 0,

    -- Rapporto d'aspetto, 16/9, 4/3, 1/1
    `RapportoAspetto` FLOAT NOT NULL DEFAULT 1.778,

    -- Vincolo referenziale
    FOREIGN KEY (`Film`) REFERENCES `Film`(`ID`) ON DELETE CASCADE ON UPDATE CASCADE,

    -- Vincolo di dominio
    CHECK (`RapportoAspetto` > 0.0)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `FormatoCodifica` (
    -- Chiave primaria
    `Famiglia` VARCHAR(10) NOT NULL,
    `Versione` VARCHAR(5) NOT NULL,

    -- Il metodo perde qualita' o no durante la compressione
    `Lossy` BOOLEAN NOT NULL DEFAULT TRUE,

    -- Massimo bitrate upportato dal metodo
    `MaxBitRate` FLOAT DEFAULT NULL,

    PRIMARY KEY (`Famiglia`, `Versione`),

    CHECK (INSTR(`Famiglia`, ',') = 0) -- Non puo' contenere virgole: saranno usate per concatenare i valori dal client
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `File` (
    `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Edizione` INT NOT NULL,

    -- Relativi allo streaming
    `Dimensione` BIGINT UNSIGNED NOT NULL,
    `BitRate` FLOAT NOT NULL,

    -- Formato Contentitore (MP4, MKV, ...)
    `FormatoContenitore` VARCHAR(16),

    -- Formato Codifica Video
    `FamigliaAudio` VARCHAR(10) NOT NULL,
    `VersioneAudio` VARCHAR(5) NOT NULL,

    -- Formato Codifica Audio
    `FamigliaVideo` VARCHAR(10) NOT NULL,
    `VersioneVideo` VARCHAR(5) NOT NULL,

    -- Segnale Video
    `Risoluzione` BIGINT UNSIGNED NOT NULL,
    `FPS` FLOAT NOT NULL DEFAULT 30.0,

    -- Campionamento segnale Audio
    `BitDepth` BIGINT UNSIGNED NOT NULL,
    `Frequenza` FLOAT NOT NULL,

    -- Chiavi esterne
    FOREIGN KEY (`Edizione`) REFERENCES `Edizione`(`ID`) ON DELETE CASCADE ON UPDATE CASCADE,

    -- Vincoli di dominio
    CHECK (`BitRate` > 0.0),
    CHECK (`FPS` > 0.0)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Lingua (
    Nome VARCHAR(32) NOT NULL PRIMARY KEY
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Doppiaggio (
    -- File e Lingua da associare
    `File` INT NOT NULL,
    `Lingua` VARCHAR(32) NOT NULL,

    -- Chiavi
    PRIMARY KEY (`File`, `Lingua`),
    FOREIGN KEY (`File`) REFERENCES `File`(`ID`),
    FOREIGN KEY (`Lingua`) REFERENCES `Lingua`(`Nome`)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Sottotitolaggio (
    -- File e Lingua da associare
    `File` INT NOT NULL,
    `Lingua` VARCHAR(32) NOT NULL,

    -- Chiavi
    PRIMARY KEY (`File`, `Lingua`),
    FOREIGN KEY (`File`) REFERENCES `File`(`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`Lingua`) REFERENCES `Lingua`(`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Restrizione (
    -- Edizione e Paese da associare
    `Edizione` INT NOT NULL,
    `Paese` CHAR(2) NOT NULL,

    -- Chiavi
    PRIMARY KEY (`Edizione`, `Paese`),
    FOREIGN KEY (`Edizione`) REFERENCES `Edizione`(`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`Paese`) REFERENCES `Paese`(`Codice`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine=InnoDB;

DROP TRIGGER IF EXISTS `InserimentoFile`;
DROP TRIGGER IF EXISTS `ModificaFile`;

DELIMITER $$

CREATE TRIGGER `InserimentoFile`
BEFORE INSERT ON `File`
FOR EACH ROW
BEGIN
    DECLARE valido INT;
    SET valido = (
        SELECT COUNT(*)
        FROM `FormatoCodifica` AS `Audio`, `FormatoCodifica` AS `Video`
        WHERE
            `Audio`.`Famiglia` = NEW.`FamigliaAudio` AND
            `Audio`.`Versione` = NEW.`VersioneAudio` AND
            `Video`.`Famiglia` = NEW.`FamigliaVideo` AND
            `Video`.`Versione` = NEW.`VersioneVideo` AND
            `Audio`.`MaxBitRate` + `Video`.`MaxBitRate` <= NEW.`BitRate`
    );

    IF valido > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'BitRate non valido!';
    END IF;
END ; $$

CREATE TRIGGER `ModificaFile`
BEFORE UPDATE ON `File`
FOR EACH ROW
BEGIN

    DECLARE valido INT;
    SET valido = (
        SELECT COUNT(*)
        FROM `FormatoCodifica` AS `Audio`, `FormatoCodifica` AS `Video`
        WHERE
            `Audio`.`Famiglia` = NEW.`FamigliaAudio` AND
            `Audio`.`Versione` = NEW.`VersioneAudio` AND
            `Video`.`Famiglia` = NEW.`FamigliaVideo` AND
            `Video`.`Versione` = NEW.`VersioneVideo` AND
            `Audio`.`MaxBitRate` + `Video`.`MaxBitRate` <= NEW.`BitRate`
    );

    IF valido > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'BitRate non valido!';
    END IF;
END ; $$

DROP TRIGGER IF EXISTS `AnnoEdizioneValido` $$

CREATE TRIGGER `AnnoEdizioneValido`
BEFORE INSERT ON `Edizione`
FOR EACH ROW
BEGIN

    DECLARE anno_film YEAR;

    SELECT F.`Anno` INTO anno_film
    FROM `Film` F
    WHERE F.`ID` = NEW.`Film`;

    IF anno_film > YEAR(NEW.`Anno`) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Anno dell\'Edizione non Valido';
    END IF;

END $$


DELIMITER ;

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

-- ----------------------------
-- AREA STREAMING
-- ----------------------------

CREATE TABLE IF NOT EXISTS `Server` (
    -- Chiave
    `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    `CaricoAttuale` INT NOT NULL DEFAULT 0,

    `MaxConnessioni` INT NOT NULL DEFAULT 10000,
    
    -- Lunghezza massima della banda
    `LunghezzaBanda` FLOAT NOT NULL,
    
    -- Maxinum Transfer Unit
    `MTU` FLOAT NOT NULL,

    -- Posizione del Server
    `Posizione` POINT,

    -- Vincoli di dominio
    CHECK (`MaxConnessioni` > 0),
    CHECK (`LunghezzaBanda` > 0.0),
    CHECK (`MTU` > 0.0),
    CHECK (ST_X(`Posizione`) BETWEEN -180.00 AND 180.00), -- Contollo longitudine
    CHECK (ST_Y(`Posizione`) BETWEEN -90.00 AND 90.00) -- Controllo latitudine
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `PoP` (
    -- Associazione tra File e Server
    `File` INT NOT NULL,
    `Server` INT NOT NULL,
    
    -- Chiavi
    PRIMARY KEY (`File`, `Server`),
    FOREIGN KEY (`File`) REFERENCES `File`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `DistanzaPrecalcolata` (
    -- Associazione tra Paese e Server
    `Paese` CHAR(2) NOT NULL,
    `Server` INT NOT NULL,

    `ValoreDistanza` FLOAT DEFAULT 0.0,

    -- Chiavi
    PRIMARY KEY (`Paese`, `Server`),
    FOREIGN KEY (`Paese`) REFERENCES `Paese`(`Codice`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Vincoli di dominio: controllo che una distanza sia non negativa e minore di un giro del mondo
    CHECK (`ValoreDistanza` BETWEEN 0.0 AND 40075.0)
) Engine=InnoDB;

DROP PROCEDURE IF EXISTS `CalcolaDistanzaPaese`;
DROP PROCEDURE IF EXISTS `CalcolaDistanzaServer`;

DROP TRIGGER IF EXISTS `InserimentoPaese`;
DROP TRIGGER IF EXISTS `ModificaPaese`;
DROP TRIGGER IF EXISTS `InserimentoServer`;
DROP TRIGGER IF EXISTS `ModificaServer`;
DELIMITER $$

CREATE PROCEDURE `CalcolaDistanzaPaese` (IN CodPaese CHAR(2))
BEGIN
    REPLACE INTO `DistanzaPrecalcolata` 
    (`Paese`, `Server`, `ValoreDistanza`)
        SELECT 
            `Paese`.`Codice`, `Server`.`ID`, 
            IF (
                `Paese`.`Codice` <> '??', 
                ST_DISTANCE_SPHERE(`Paese`.`Posizione`, `Server`.`Posizione`) / 1000,
                0)      
        FROM `Paese` CROSS JOIN `Server`
        WHERE `Paese`.`Codice` = CodPaese;
END ; $$

CREATE PROCEDURE `CalcolaDistanzaServer` (IN IDServer INT)
BEGIN
    REPLACE INTO `DistanzaPrecalcolata` (`Paese`, `Server`, `ValoreDistanza`)
        SELECT 
            `Paese`.`Codice`, `Server`.`ID`,
            IF (
                `Paese`.`Codice` <> '??', 
                ST_DISTANCE_SPHERE(`Paese`.`Posizione`, `Server`.`Posizione`) / 1000,
                0)            
        FROM `Server` CROSS JOIN `Paese`
        WHERE `Server`.`ID` = IDServer;
END ; $$

CREATE TRIGGER `InserimentoPaese`
AFTER INSERT ON `Paese`
FOR EACH ROW
BEGIN
    CALL CalcolaDistanzaPaese(NEW.`Codice`);
END ; $$

CREATE TRIGGER `ModificaPaese`
AFTER UPDATE ON `Paese`
FOR EACH ROW
BEGIN
    IF NEW.Posizione <> OLD.Posizione THEN
        CALL CalcolaDistanzaPaese(NEW.`Codice`);
    END IF;
END ; $$

CREATE TRIGGER `InserimentoServer`
AFTER INSERT ON `Server`
FOR EACH ROW
BEGIN
    CALL CalcolaDistanzaServer(NEW.`ID`);
END ; $$

CREATE TRIGGER `ModificaServer`
AFTER UPDATE ON `Server`
FOR EACH ROW
BEGIN
    IF NEW.Posizione <> OLD.Posizione THEN
        CALL CalcolaDistanzaServer(NEW.`ID`);
    END IF;
END ; $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `Erogazione` (
    -- Uguali a Visualizzazione
    `IP` INT UNSIGNED NOT NULL,
    `InizioConnessione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `Utente` VARCHAR(100) NOT NULL,
    `Edizione` INT NOT NULL,
    `Timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Quando il Server ha iniziato a essere usato
    `InizioErogazione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Il Server in uso
    `Server` INT NOT NULL,

    -- Chiavi
    PRIMARY KEY (`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`),
    FOREIGN KEY (`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`)
        REFERENCES `Visualizzazione`(`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Vincoli di dominio
    CHECK (`Timestamp` BETWEEN `InizioConnessione` AND `InizioErogazione`)
) Engine=InnoDB;

DROP PROCEDURE IF EXISTS AggiungiErogazioneServer;
DROP PROCEDURE IF EXISTS RimuoviErogazioneServer;

DROP TRIGGER IF EXISTS ModificaErogazione;
DROP TRIGGER IF EXISTS AggiungiErogazione;
DROP TRIGGER IF EXISTS RimuoviErogazione;

DELIMITER $$ 

CREATE PROCEDURE AggiungiErogazioneServer(IN ServerID INT)
BEGIN
    UPDATE `Server`
    SET `Server`.`CaricoAttuale` = `Server`.`CaricoAttuale` + 1
    WHERE `Server`.`ID` = ServerID;
END ; $$

CREATE PROCEDURE RimuoviErogazioneServer(IN ServerID INT)
BEGIN
    UPDATE `Server`
    SET `Server`.`CaricoAttuale` = GREATEST(`Server`.`CaricoAttuale` - 1, 0)
    WHERE `Server`.`ID` = ServerID;
END ; $$

CREATE TRIGGER `ModificaErogazione`
BEFORE UPDATE ON Erogazione
FOR EACH ROW     
BEGIN
    -- SET NEW.InizioErogazione = CURRENT_TIMESTAMP;
    IF NEW.`Server` <> OLD.`Server` THEN
        CALL AggiungiErogazioneServer(NEW.`Server`);
        CALL RimuoviErogazioneServer(OLD.`Server`);
    END IF;
END ; $$

CREATE TRIGGER `AggiungiErogazione` 
AFTER INSERT ON Erogazione
FOR EACH ROW     
BEGIN
    CALL AggiungiErogazioneServer(NEW.`Server`);
END ; $$

CREATE TRIGGER `RimuoviErogazione`
AFTER DELETE ON Erogazione
FOR EACH ROW     
BEGIN
    CALL RimuoviErogazioneServer(OLD.`Server`);
END ; $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `IPRange` (

    -- Range di IP4
    `Inizio` INT UNSIGNED NOT NULL,
    `Fine` INT UNSIGNED NOT NULL,

    -- Inizio e fine validita'
    `DataInizio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `DataFine` TIMESTAMP NULL DEFAULT NULL,

    -- Paese che possiede
    `Paese` CHAR(2) NOT NULL DEFAULT '??',
        
    -- Chiavi
    PRIMARY KEY (`Inizio`, `Fine`, `DataInizio`),
    FOREIGN KEY (`Paese`) REFERENCES `Paese`(`Codice`) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Vincoli di dominio
    CHECK (`Fine` >= `Inizio`),
    CHECK (`DataFine` >= `DataInizio`)
) Engine=InnoDB;


-- Rimuovo funzioni, trigger e schedule prima di riaggiungerli

DROP FUNCTION IF EXISTS `IpRangeCollidono`;
DROP FUNCTION IF EXISTS `IpRangeValidoInData`;
DROP FUNCTION IF EXISTS `IpAppartieneRangeInData`;

DROP FUNCTION IF EXISTS `Ip2Paese`;
DROP FUNCTION IF EXISTS `Ip2PaeseStorico`;

DROP FUNCTION IF EXISTS `IpRangePossoInserire`;

DROP PROCEDURE IF EXISTS `IpRangeInserisciFidato`;
DROP PROCEDURE IF EXISTS `IpRangeInserisciAdessoFidato`;

DROP PROCEDURE IF EXISTS `IpRangeProvaInserire`;
DROP PROCEDURE IF EXISTS `IpRangeProvaInserireAdesso`;

DROP TRIGGER IF EXISTS `IpRangeControlloAggiornamento`;

DELIMITER $$

-- ----------------------------------------------------
--
--         Funzioni di utilita' sui Range IP4
--
-- ----------------------------------------------------

CREATE FUNCTION `IpRangeCollidono`(
    Inizio1 INT UNSIGNED, Fine1 INT UNSIGNED, 
    Inizio2 INT UNSIGNED, Fine2 INT UNSIGNED)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Si assume che Fine1 >= Inizio1
    -- Si assume che Fine2 >= Inizio2

    IF Inizio1 > Inizio2 THEN
        RETURN Fine2 >= Inizio1;
    END IF;
    -- Dobbiamo controllare se Inizio1 <= Inizio2 <= Fine2
    -- Sappiamo gia' pero' che Inizio1 <= Inizio2
    -- Quindi dobbiamo solo controllare Inizio2 <= Fine1
    RETURN Inizio2 <= Fine1;
END ; $$

CREATE FUNCTION `IpRangeValidoInData`(
    InizioValidita TIMESTAMP, 
    FineValidita TIMESTAMP, 
    IstanteDaControllare TIMESTAMP)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    IF IstanteDaControllare IS NULL THEN
        RETURN FineValidita IS NULL;
    END IF;

    RETURN IstanteDaControllare BETWEEN InizioValidita AND IFNULL(FineValidita, CURRENT_TIMESTAMP);
END ; $$

CREATE FUNCTION `IpAppartieneRangeInData`(
    Inizio INT UNSIGNED,
    Fine INT UNSIGNED,
    DataInizio TIMESTAMP,
    DataFine TIMESTAMP,
    IP INT UNSIGNED,
    DataDaControllare TIMESTAMP)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN 
        (IP BETWEEN Inizio AND Fine) AND IpRangeValidoInData(DataInizio, DataFine, DataDaControllare);
END ; $$

CREATE FUNCTION `Ip2PaeseStorico`(ip INT UNSIGNED, DataDaControllare TIMESTAMP)
RETURNS CHAR(2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE Codice CHAR(2) DEFAULT '??';

    IF ip IS NULL THEN
        RETURN Codice;
    END IF;

    SELECT r.Paese INTO Codice
    FROM `IPRange` r
    WHERE IpAppartieneRangeInData(
        r.`Inizio`, r.`Fine`, 
        r.`DataInizio`, r.`DataFine`, 
        ip, DataDaControllare)
    LIMIT 1;

    IF Codice IS NULL THEN
        SET Codice = '??';
    END IF;

    RETURN Codice;
END ; $$

CREATE FUNCTION `Ip2Paese`(ip INT UNSIGNED)
RETURNS CHAR(2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN Ip2PaeseStorico(ip, CURRENT_TIMESTAMP);
END ; $$


-- -----------------------------------------------------------------
--
--  Procedure di inserimento per mantenere IPRanges consistenti
--
-- -----------------------------------------------------------------

CREATE FUNCTION `IpRangePossoInserire` (
    `NewInizio` INT UNSIGNED , `NewFine` INT UNSIGNED, 
    `NewDataInizio` TIMESTAMP, `NewPaese` CHAR(2))
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    -- Controlliamo se il record esiste gia' (ma con data diversa)
    IF EXISTS (
        SELECT * 
        FROM `IPRange` r
        WHERE 
            r.`Inizio` = `NewInizio` AND 
            r.`Fine` = `NewFine` AND 
            IpRangeValidoInData(r.`DataInizio`, r.`DataFine`, `NewDataInizio`) AND 
            -- Se puntano allo stesso paese vuol dire che e' il solito range non ancora scaduto
            r.`Paese` = `NewPaese`
        ) THEN
        
        RETURN FALSE;
    END IF;

    -- Un record gia' presente, con priorita' maggiori, "rompe" quello appena inserito
    IF EXISTS (
        SELECT * 
        FROM `IPRange` r
        WHERE 
            IpRangeCollidono(`NewInizio`, `NewFine`, r.`Inizio`, r.`Fine`) AND
            IpRangeValidoInData(r.`DataInizio`, r.`DataFine`, `NewDataInizio`) AND
            r.`Paese` <> '??'
        ) THEN
        
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END ; $$

-- Inserimento di range senza effettuare controlli

CREATE PROCEDURE `IpRangeInserisciFidato` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, 
    IN `NewDataInizio` TIMESTAMP, IN `NewDataFine` TIMESTAMP, 
    IN `NewPaese` CHAR(2), IN `InvalidaCollisioni` BOOLEAN
)
BEGIN
    IF `InvalidaCollisioni` THEN
        -- Se il record inserito "rompe" uno gia' presente, con meno piorita' si fa scadere quello gia' presente
        UPDATE `IPRange`
        SET `IPRange`.`DataFine` = `NewDataInizio` - INTERVAL 1 SECOND -- I timestamp vengono tenuti leggermente differenti
        WHERE
            IpRangeCollidono(`NewInizio`, `NewFine`, `IPRange`.`Inizio`, `IPRange`.`Fine`)  AND
            IpRangeValidoInData(`NewDataInizio`, `NewDataFine`, `IPRange`.`DataInizio`);
    END IF;
    
    -- Inserisco essendo sicuro di aver mantenuto coerenza tra gli ip
    INSERT INTO `IPRange` (`Inizio`, `Fine`, `DataInizio`, `DataFine`, `Paese`) VALUES
    (`NewInizio`, `NewFine`, `NewDataInizio`, `NewDataFine`, `NewPaese`);
END ; $$

-- Inserisce solo se passa controlli

CREATE PROCEDURE `IpRangeProvaInserire` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, 
    IN `NewDataInizio` TIMESTAMP, IN `NewDataFine` TIMESTAMP, 
    `NewPaese` CHAR(2)
)
insert_body:BEGIN

    -- Controllo sulla consistenza del range temporale
    IF `NewDataFine` IS NOT NULL AND `NewDataFine` < `NewDataInizio` THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = 'Range di date invertito: DataInizio > DataFine';
        LEAVE insert_body;
    END IF;

    -- Controllo sulla consistenza del range
    IF `NewFine` < `NewInizio` THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = 'Range invertito: Inizio > Fine';
        LEAVE insert_body;
    END IF;

    -- Controllo sull'esistenza del paese
    IF `NewPaese` = '??' OR NOT EXISTS (
        SELECT *
        FROM `Paese` P
        WHERE P.`Codice` = `NewPaese`
    ) THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = 'Paese non trovato!';
        LEAVE insert_body;
    END IF;

    CALL `IpRangeInserisciFidato`(`NewInizio`, `NewFine`, `NewDataInizio`, `NewDataFine`, `NewPaese`, TRUE);
END ; $$

-- Inserimenti di range validi dal momento stesso

CREATE PROCEDURE `IpRangeInserisciAdessoFidato` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, IN `NewPaese` CHAR(2), IN `InvalidaCollisioni` BOOLEAN)
BEGIN
    CALL `IpRangeInserisciFidato`(`NewInizio`, `NewFine`, CURRENT_TIMESTAMP, NULL, `NewPaese`, `InvalidaCollisioni`);
END ; $$

CREATE PROCEDURE `IpRangeProvaInserireAdesso` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, `NewPaese` CHAR(2))
BEGIN
    CALL `IpRangeProvaInserire`(`NewInizio`, `NewFine`, CURRENT_TIMESTAMP, NULL, `NewPaese`);
END ; $$


CREATE TRIGGER `IpRangeControlloAggiornamento`
BEFORE UPDATE ON `IPRange`
FOR EACH ROW
BEGIN

    IF NEW.`Inizio` <> OLD.`Inizio` OR NEW.`Fine` <> OLD.`Fine` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non si possono modificare i range! Cancellare il range e inserirne uno nuovo.';
    END IF;
    
END ; $$

DELIMITER ;

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `BilanciamentoDelCarico`;
DELIMITER //
CREATE PROCEDURE `BilanciamentoDelCarico`(
    M INT,
    N INT
)
BEGIN

    -- 1) Ottieni Tabella Visualizzazione + Colonna Paese
    -- 2) Ottieni Tabella T(Edizione, Paese, Visualizzazioni)
    -- 3) Per ogni Paese prendi le N Edizioni piu' visualizzate
    --      3.1) Fai un Ranking ordinato per Visualizzazioni e partizionato per Paese
    --      3.2) Seleziona solo i primi N per ogni Partizione
    -- 4) Per ogni Paese si individuano gli M server piu' vicini
    --      4.1) Fai un ranking di Server, Paese ordinato per distanza e partizionato per Paese
    --      4.2) Selezioni i primi M per ogni Paese
    -- 5) Creare una Tabella, senza duplicati, T(Edizione, Server) facendo il JOIN tra la 3 e la 4
    -- 6) Si crea una Tabella, partendo dalla precedente, T(File, Server) contenente ogni File di Edizione ma tale per cui non vi sia un P.o.P tra File e Server
    --      6.1) Fai il JOIN con File e ottieni T(File, Server)
    --      6.2) Imponi che non debba esistere un occorrenza di P.o.P avente stesso File e Server


    WITH
        -- 1) Ottieni Tabella Visualizzazione + Colonna Paese
        `VisualizzazionePaese` AS (
            SELECT
                V.*,
                IFNULL (R.`Paese`, '??') AS "Paese"
            FROM Visualizzazione V
                LEFT OUTER JOIN `IPRange` R ON 
                    (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                    (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
        ),

        -- 2) Ottieni Tabella T(Edizione, Paese, Visualizzazioni)
        `EdizionePaeseVisualizzazioni` AS (
            SELECT
                V.`Edizione`,
                V.`Paese`,
                COUNT(*) AS "Visualizzazioni"
            FROM `VisualizzazionePaese` V
            GROUP BY V.`Edizione`, V.`Paese`
        ),

        -- 3) Per ogni Paese prendi le N Edizioni piu' visualizzate
        `RankingVisualizzazioniPerPaese` AS (
            SELECT
                `Edizione`,
                `Paese`,
                RANK() OVER (
                    PARTITION BY `Paese`
                    ORDER BY `Visualizzazioni` DESC, `Edizione`) AS rk
            FROM `EdizionePaeseVisualizzazioni` 
        ),
        `EdizioniTargetPerPaese` AS (
            SELECT
                `Edizione`,
                `Paese`
            FROM `RankingVisualizzazioniPerPaese`
            WHERE rk <= N
        ),

        -- 4) Per ogni Paese si individuano gli M server piu' vicini
        `RankingPaeseServer` AS (
            SELECT
                `Server`,
                `Paese`,
                RANK() OVER(
                    PARTITION BY `Paese` 
                    ORDER BY `ValoreDistanza`, `Paese`) AS rk
            FROM `DistanzaPrecalcolata`
        ),
        `ServerTargetPerPaese` AS (
            SELECT
                `Server`,
                `Paese`
            FROM `RankingPaeseServer`
            WHERE rk <= M
        ),

        -- 5) Creare una Tabella, senza duplicati, T(Edizione, Server) facendo il JOIN tra la 3 e la 4
        `EdizionePaese` AS (
            SELECT DISTINCT
                `Edizione`,
                `Server`
            FROM `ServerTargetPerPaese` SP
            INNER JOIN `EdizioniTargetPerPaese` EP
                USING(`Paese`)
        )

    -- 6)  Si crea una Tabella, partendo dalla precedente, T(File, Server) contenente ogni File di Edizione ma tale per cui non vi sia un P.o.P tra File e Server
    SELECT
        F.`ID` AS File,
        EP.`Server`
    FROM `EdizionePaese` EP
    INNER JOIN `File` F USING (`Edizione`)
    WHERE NOT EXISTS (
        SELECT *
        FROM `PoP`
        WHERE `PoP`.`File` = F.`ID`
        AND `PoP`.`Server` = EP.`Server`
    );


END
//
DELIMITER ;

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `Classifica`;
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `Classifica`(
    N INT,
    codice_paese CHAR(2),
    tipo_abbonamento VARCHAR(50),
    P INT -- 1 -> Film   2 -> Edizioni
)
BEGIN

    IF p = 1 THEN

        WITH `FilmVisualizzazioni` AS (
                SELECT
                    E.`Film`,
                    COUNT(*) AS "Visualizzazioni"
                FROM `Visualizzazione` V
                INNER JOIN `Utente` U ON V.`Utente` = U.`Codice`
                INNER JOIN `Edizione` E ON E.`ID` = V.`Edizione`
                LEFT OUTER JOIN `IPRange` R ON 
                    (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                    (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
                WHERE U.`Abbonamento` = tipo_abbonamento AND IFNULL (R.`Paese`, '??') = codice_paese
                GROUP BY E.`Film`
            )
        SELECT `Film`
        FROM `FilmVisualizzazioni`
        ORDER BY `Visualizzazioni` DESC
        LIMIT N;

    ELSEIF p = 2 THEN

        WITH
            `EdizioneVisualizzazioni` AS (
                SELECT
                    V.`Edizione`,
                    COUNT(*) AS "Visualizzazioni"
                FROM `Visualizzazione` V
                INNER JOIN `Utente` U ON V.`Utente` = U.`Codice`
                LEFT OUTER JOIN `IPRange` R ON 
                    (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                    (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
                WHERE U.Abbonamento = tipo_abbonamento AND IFNULL (R.`Paese`, '??') = codice_paese
                GROUP BY V.`Edizione`
            )
        SELECT `Edizione`
        FROM `EdizioneVisualizzazioni`
        ORDER BY `Visualizzazioni` DESC
        LIMIT N;

    ELSE

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Parametro P non Valido';

    END IF;

END //

DELIMITER ;

DROP FUNCTION IF EXISTS `ValutazioneAttore`;
DELIMITER //
CREATE FUNCTION `ValutazioneAttore`(
    Nome VARCHAR(50),
    Cognome VARCHAR(50)
    )
RETURNS FLOAT 
NOT DETERMINISTIC
READS SQL DATA
BEGIN

    DECLARE sum_v FLOAT;
    DECLARE sum_p FLOAT;
    DECLARE n INT;

    SET sum_v := (
        SELECT
            SUM(IFNULL(F.MediaRecensioni, 0))
        FROM Artista A
        INNER JOIN Recitazione R
            ON R.NomeAttore = A.Nome AND R.CognomeAttore = A.Cognome
        INNER JOIN Film F
            ON F.ID = R.Film
        WHERE A.Nome = Nome AND A.Cognome = Cognome
    );

    SET sum_p := (
        SELECT
            COUNT(DISTINCT VP.Film)
        FROM Artista A
        INNER JOIN Recitazione R
            ON R.NomeAttore = A.Nome AND R.CognomeAttore = A.Cognome
        INNER JOIN VincitaPremio VP
            ON VP.Film = R.Film
        WHERE A.Nome = Nome AND A.Cognome = Cognome
    );

    SET n := (
        SELECT
            COUNT(*)
        FROM VincitaPremio
        WHERE NomeArtista = Nome AND CognomeArtista = CognomeArtista
    );

    RETURN sum_v + sum_p * 5 + n * 50.0;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `MiglioreAttore`;
DELIMITER //
CREATE PROCEDURE `MiglioreAttore`()
BEGIN

    WITH
        AttoreValutazione AS (
            SELECT
                Nome, Cognome,
                ValutazioneAttore(Nome, Cognome) AS Valutazione
            FROM Artista
            WHERE Popolarita <= 2.5
        )
    SELECT
        Nome, Cognome
    FROM AttoreValutazione
    WHERE Valutazione = (
        SELECT MAX(Valutazione)
        FROM AttoreValutazione
    );

END //
DELIMITER ;


DROP FUNCTION IF EXISTS `ValutazioneRegista`;
DELIMITER //
CREATE FUNCTION `ValutazioneRegista`(
    Nome VARCHAR(50),
    Cognome VARCHAR(50)
    )
RETURNS FLOAT 
NOT DETERMINISTIC
READS SQL DATA
BEGIN

    DECLARE sum_v FLOAT;
    DECLARE sum_p FLOAT;
    DECLARE n INT;

    SET sum_v := (
        SELECT
            SUM(IFNULL(MediaRecensioni, 0))
        FROM Film
        WHERE NomeRegista = Nome AND CognomeRegista = Cognome
    );

    SET sum_p := (
        SELECT
            COUNT(DISTINCT VP.Film)
        FROM Film F
        INNER JOIN VincitaPremio VP
            ON VP.Film = F.ID
        WHERE F.NomeRegista = Nome AND F.CognomeRegista = Cognome
    );

    SET n := (
        SELECT
            COUNT(*)
        FROM VincitaPremio
        WHERE NomeArtista = Nome AND CognomeArtista = CognomeArtista
    );

    RETURN sum_v + sum_p * 5 + n * 50.0;

END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS `MiglioreRegista`;
DELIMITER //
CREATE PROCEDURE `MiglioreRegista`()
BEGIN

    WITH
        RegistaValutazione AS (
            SELECT
                Nome, Cognome,
                ValutazioneRegista(Nome, Cognome) AS Valutazione
            FROM Artista
            WHERE Popolarita <= 2.5
        )
    SELECT
        Nome, Cognome
    FROM RegistaValutazione
    WHERE Valutazione = (
        SELECT MAX(Valutazione)
        FROM RegistaValutazione
    );

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `RaccomandazioneContenuti`;
DELIMITER //
CREATE PROCEDURE `RaccomandazioneContenuti`(
    IN codice_utente VARCHAR(100),
    IN numero_film INT
)
BEGIN

    WITH
        FilmRatingUtente AS (
            SELECT
                ID,
                RatingUtente(ID, codice_utente) AS Rating
            FROM Film
        )
    SELECT ID
    FROM FilmRatingUtente
    ORDER BY Rating DESC, ID
    LIMIT numero_film;


END
//
DELIMITER ;

USE `FilmSphere`;

DROP FUNCTION IF EXISTS `RatingFilm`;
DELIMITER //
CREATE FUNCTION IF NOT EXISTS `RatingFilm`(
    `id_film` INT
)
RETURNS FLOAT NOT DETERMINISTIC
    READS SQL DATA
BEGIN

    DECLARE RU FLOAT;
    DECLARE RC FLOAT;
    DECLARE PA FLOAT;
    DECLARE PR FLOAT;
    DECLARE PV FLOAT;
    DECLARE RMU FLOAT;

    SET RU := (
        SELECT
            IFNULL(MediaRecensioni, 0)
        FROM Film
        WHERE ID = id_film
    );

    SET RC := (
        SELECT
            IFNULL(AVG(Voto), 0)
        FROM Critica
        WHERE Film = id_film
    );

    SET PA := (
        SELECT
            IFNULL(AVG(Popolarita), 0)
        FROM Artista A
        INNER JOIN Recitazione R
        ON A.Nome = R.NomeAttore AND A.Cognome = R.CognomeAttore
        WHERE Film = id_film
    );

    SET PR := (
        SELECT
            IFNULL(Popolarita, 0)
        FROM Artista A
        INNER JOIN Film F
        ON F.NomeRegista = A.Nome AND F.CognomeRegista = A.Cognome
        WHERE ID = id_film
    );

    SET PV := (
        SELECT
            COUNT(*)
        FROM VincitaPremio
        WHERE Film = id_film
    );

    SET RMU := (
        SELECT
            IFNULL(MAX(F2.MediaRecensioni), 100000)
        FROM Film F1
        INNER JOIN GenereFilm GF1
        ON GF1.Film = F1.ID
        INNER JOIN GenereFilm GF2
        ON GF2.Genere = GF1.Genere
        INNER JOIN Film F2
        ON GF2.Film = F2.ID
        WHERE F1.ID = id_film
    );

    RETURN FLOOR(0.5 * (RU + RC) + 0.1 * (PA + PR) + 0.1 * PV + (RU/RMU)) / 2;

END
//
DELIMITER ;

USE `FilmSphere`;


DROP FUNCTION IF EXISTS `RatingUtente`;

DELIMITER //

CREATE FUNCTION `RatingUtente`(
    id_film INT,
    id_utente VARCHAR(100)
)
RETURNS FLOAT 
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE out_value FLOAT DEFAULT 0.0;

    WITH `VisualizzazioniUtente` AS (
        SELECT E.`Film`, V.`Edizione`, V.`Utente`, E.`RapportoAspetto`, F.`NomeRegista`, F.`CognomeRegista`
        FROM `Visualizzazione` V
            INNER JOIN `Edizione` E ON E.ID = V.`Edizione`
            INNER JOIN `Film` F ON F.`ID` = E.`Film`
        WHERE V.`Utente` = id_utente
    ), 
    
    `GenereVisualizzazioni` AS (
        SELECT
            GF.`Genere`,
            COUNT(*),
            RANK() OVER (
                ORDER BY COUNT(*) DESC, GF.`Genere`
            ) AS rk
        FROM `VisualizzazioniUtente` V
            INNER JOIN `GenereFilm` GF USING(`Film`)
        GROUP BY GF.`Genere`
    ), `PunteggiGeneri` AS (
        SELECT (3 - G.`rk`) AS Punteggio
        FROM `GenereVisualizzazioni` G
            INNER JOIN `GenereFilm` GF USING(`Genere`)
        WHERE GF.`Film` = id_film AND G.`rk` <= 2
        LIMIT 2
    ), 
    
    `AttoriVisualizzazioni` AS (
        SELECT
            R.`NomeAttore`,
            R.`CognomeAttore`,
            COUNT(*),
            RANK() OVER (
                ORDER BY COUNT(*) DESC, R.`NomeAttore`, R.`CognomeAttore`
            ) AS rk
        FROM `VisualizzazioniUtente` V
            INNER JOIN `Recitazione` R USING(`Film`)
        GROUP BY R.`NomeAttore`, R.`CognomeAttore`
    ), `PunteggiAttori` AS (
        SELECT (CASE
            WHEN A.`rk` = 1 THEN 1.5
            WHEN A.`rk` = 2 THEN 1.0
            WHEN A.`rk` = 3 THEN 0.5
            END) AS Punteggio
        FROM `AttoriVisualizzazioni` A
            INNER JOIN `Recitazione` R USING(`NomeAttore`, `CognomeAttore`)
        WHERE R.`Film` = id_film AND A.`rk` <= 3
        LIMIT 3
    ),
    
    `LinguaVisualizzazioni` AS (
        SELECT
            D.`Lingua`,
            COUNT(*),
            RANK() OVER(
                ORDER BY COUNT(*) DESC
            ) AS rk
        FROM `VisualizzazioniUtente` V
            INNER JOIN `File` F USING (`Edizione`)
            INNER JOIN `Doppiaggio` D ON D.`File` = F.`ID`
        GROUP BY D.`Lingua`
    ), `PunteggiLingue` AS (
        SELECT 1 AS Punteggio
        FROM `LinguaVisualizzazioni` L
            INNER JOIN `Doppiaggio` D USING(`Lingua`)
            INNER JOIN `File` F ON F.`ID` = D.`File`
            INNER JOIN `Edizione` E ON E.`ID` = F.`Edizione`
        WHERE E.`Film` = id_film AND L.`rk` <= 2
        LIMIT 2
    ),
    
    `RegistaVisualizzazioni` AS (
        SELECT
            V.`NomeRegista`,
            V.`CognomeRegista`,
            COUNT(*)
        FROM `VisualizzazioniUtente` V
        GROUP BY V.`NomeRegista`, V.`CognomeRegista`
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ), `PunteggioRegista` AS (
        SELECT 1 AS Punteggio
        FROM `RegistaVisualizzazioni` R
            INNER JOIN `Film` F USING(`NomeRegista`, `CognomeRegista`)
        WHERE F.`ID` = id_film
    ),


    `RapportoAspettoVisualizzazioni` AS (
        SELECT
            V.`RapportoAspetto`,
            COUNT(*)
        FROM `VisualizzazioniUtente` V
        GROUP BY V.`RapportoAspetto`
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ), `PunteggioRapportoAspetto` AS (
        SELECT 1 AS Punteggio
        FROM `RapportoAspettoVisualizzazioni` R
            INNER JOIN `Edizione` E USING(`RapportoAspetto`)
        WHERE E.`Film` = id_film
        LIMIT 1
    ),

    `Punteggi` AS (
        SELECT *
        FROM `PunteggiGeneri`

        UNION ALL

        SELECT *
        FROM `PunteggiAttori`

        UNION ALL

        SELECT *
        FROM `PunteggiLingue`

        UNION ALL

        SELECT *
        FROM `PunteggioRegista`

        UNION ALL

        SELECT *
        FROM `PunteggioRapportoAspetto`
    )
    SELECT (FLOOR(SUM(`Punteggio`)) / 2.0) INTO out_value 
    FROM `Punteggi`;

    RETURN IFNULL(out_value, 0.0);

END //

DELIMITER ;

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `CachingPrevisionale`;
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `CachingPrevisionale`(
    X INT,
    M INT,
    N INT
)
BEGIN

    -- 1) Per ogni Utente si considera il Paese dal quale si connette di piu' e dal Paese gli N Server piu' vicini
    -- 2) Per ogni coppia Utente, Paese si considerano gli M File con probabilità maggiore di essere guardati, ciascuno con la probabilità di essere guardato
    -- 3) Si raggruppa in base al Server e ad ogni File, sommando, per ogni Server-File la probabilit`a che sia guardato dall’Utente moltiplicata
    --    per un numero che scala in maniera decrescente in base al ValoreDistanza tra Paese e Server
    -- 4) Si restituiscono le prime X coppie Server-File con somma maggiore per le quali non esiste gi`a un P.o.P.
    WITH
        `UtentePaeseVolte` AS (
            SELECT
                V.`Utente`,
                IFNULL (R.`Paese`, '??') AS `Paese`,
                COUNT(*) AS `Volte`
            FROM `Visualizzazione` V
            
            LEFT OUTER JOIN `IPRange` R ON 
                (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
            GROUP BY `Utente`, `Paese`
        ),
        `UtentePaesePiuFrequente` AS (
            SELECT UPV.*
            FROM `UtentePaeseVolte` UPV
            WHERE UPV.`Volte` >= ALL(
                SELECT UPV2.`Volte`
                FROM `UtentePaeseVolte` UPV2
                WHERE UPV2.`Utente` = UPV.`Utente`
            )
        ),
        `ServerTargetPerPaese` AS (
            SELECT `Server`, `Paese`, `ValoreDistanza`,
                RANK() OVER(
                    PARTITION BY `Paese` 
                    ORDER BY `ValoreDistanza`) AS rk
            FROM `DistanzaPrecalcolata`
            -- WHERE `Paese` <> '??'
        ),
        `UtentePaeseServer` AS (
            SELECT
                UP.`Utente`,
                UP.`Paese`,
                S.`Server`,
                S.`ValoreDistanza`
            FROM `UtentePaesePiuFrequente` UP
                INNER JOIN `ServerTargetPerPaese` S USING(`Paese`)
            WHERE rk <= N
        ),

        -- 2) Per ogni coppia Utente, Paese si considerano gli M File con probabilità maggiore di essere guardati, ciascuno con la probabilità di essere guardato
        `FilmRatingUtente` AS (
            SELECT
                F.`ID`,
                U.`Codice`,
                RatingUtente(F.`ID`, U.`Codice`) AS Rating,
                RANK() OVER(
                    PARTITION BY U.`Codice` 
                    ORDER BY Rating DESC
                ) AS rk
            FROM `Film` F
                CROSS JOIN `Utente` U
            HAVING Rating > 0
        ),
        `10FilmUtente` AS (
            SELECT
                `ID` AS Film,
                `Codice` AS Utente,
                (CASE
                    WHEN rk = 1 THEN 30.0
                    WHEN rk = 2 THEN 22.0
                    WHEN rk = 3 THEN 11.0
                    WHEN rk = 4 THEN 9.0
                    WHEN rk = 5 THEN 8.0
                    WHEN rk = 6 THEN 6.0
                    WHEN rk = 7 THEN 5.0
                    WHEN rk = 8 THEN 4.0
                    WHEN rk = 9 THEN 3.0
                    WHEN rk = 10 THEN 2.0
                END) AS Probabilita
            FROM `FilmRatingUtente`
            WHERE rk <= 10
        ),
        `FilmFileAssociati` AS (
            SELECT
                F.`ID` AS Film,
                FI.`ID` AS File
            FROM `Film` F
                INNER JOIN `Edizione` E ON E.`Film` = F.ID
                INNER JOIN `File` FI ON FI.`Edizione` = E.ID
        ),
        `FilmFile` AS (
            SELECT
                F.*,
                F1.`NumeroFile`
            FROM `FilmFileAssociati` F
                INNER JOIN (
                    -- Tabella avente Film e numero di File ad esso associati
                    SELECT
                        F2.`Film`,
                        COUNT(*) AS NumeroFile
                    FROM `FilmFileAssociati` F2
                    GROUP BY F2.`Film`
                ) AS F1 USING (`Film`)
            WHERE F1.`NumeroFile` > 0
        ),
        `FileUtente` AS (
            SELECT
                U.`Utente`,
                F.`File`,
                U.`Probabilita` / F.`NumeroFile` AS Probabilita,
                RANK() OVER(
                    PARTITION BY U.`Utente`
                    ORDER BY U.`Probabilita` / F.`NumeroFile` DESC) AS rk
            FROM `10FilmUtente` U
                NATURAL JOIN `FilmFile` F
        ),
        `ServerFile` AS (
            SELECT
                `File`,
                `Server`,
                SUM(`Probabilita` * (1 + 1 / `ValoreDistanza`)) AS Importanza   -- MODIFICA VALORI PER QUESTA ESPRESSIONE
            FROM `FileUtente` FU
                INNER JOIN `UtentePaeseServer` SU USING(`Utente`)
            WHERE rk <= M
            GROUP BY FU.`File`, SU.`Server`
        )
    SELECT
        `File`,
        `Server`
    FROM `ServerFile` SF
    WHERE NOT EXISTS (
        SELECT *
        FROM `PoP`
        WHERE `PoP`.`Server` = SF.`Server` AND PoP.`File` = SF.`File`
    )
    ORDER BY Importanza DESC
    LIMIT X;

END //

DELIMITER ;

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

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `VinciteDiUnFilm`;
DELIMITER //
CREATE PROCEDURE `VinciteDiUnFilm`(IN film_id INT)
BEGIN

    SELECT
        GROUP_CONCAT(
            `Macrotipo`, ' ',
            `Microtipo`, ' ',
            `Data`
        ) AS ListaPremi,
        COUNT(*) AS NumeroPremiVinti
    FROM `VincitaPremio`
     WHERE `Film` = film_id
    GROUP BY `Film`;

END //

DELIMITER ;

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `GeneriDiUnFilm`;
DELIMITER //
CREATE PROCEDURE `GeneriDiUnFilm`(IN film_id INT, IN codice_utente VARCHAR(100))
BEGIN

    DECLARE lista_generi VARCHAR(400);
    DECLARE generi_disabilitati INT;

    SET lista_generi := (
        SELECT
            GROUP_CONCAT(`Genere`)
        FROM `GenereFilm`
        WHERE `Film` = film_id
        GROUP BY `Film`
    );

    SET generi_disabilitati := (
        SELECT
            COUNT(*)
        FROM GenereFilm GF
        INNER JOIN Esclusione E
        USING(Genere)
        INNER JOIN Utente U
        USING (Abbonamento)
        WHERE U.Codice = codice_utente
        AND GF.Film = film_id
    );


    IF generi_disabilitati > 0 THEN
        SELECT lista_generi, 'Non Abilitato' AS Abilitazione;
    ELSE
        SELECT lista_generi, 'Abilitato' AS Abilitazione;
    END IF;
END //
DELIMITER ;


USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FileMiglioreQualita`;

DELIMITER $$

CREATE PROCEDURE `FileMiglioreQualita`(IN film_id INT, IN codice_utente VARCHAR(100))
BEGIN

    DECLARE massima_risoluzione INT;
    SET massima_risoluzione := (
        SELECT
            A.Definizione
        FROM Abbonamento A
        INNER JOIN Utente U
        ON U.Abbonamento = A.Tipo
        WHERE U.Codice = codice_utente
    );

    WITH
        `FileRisoluzione` AS (
            SELECT `File`.`ID`, `Risoluzione`
            FROM `Edizione`
                INNER JOIN `File`
                ON `Edizione`.`ID` = `File`.`Edizione`
            WHERE `Film` = film_id
            AND `Risoluzione` <= massima_risoluzione
        )
    SELECT
        `ID`, `Risoluzione`
    FROM `FileRisoluzione`
    WHERE `Risoluzione` = (
        SELECT
            MAX(`Risoluzione`)
        FROM `FileRisoluzione`
    );

END ; $$

DELIMITER ;

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FilmEsclusiAbbonamento`;

DELIMITER //

CREATE PROCEDURE `FilmEsclusiAbbonamento`(
    IN TipoAbbonamento VARCHAR(50),
    OUT NumeroFilm INT)
BEGIN

    -- Film esclusi perche' il genere e' escluso
    WITH `FilmEsclusiGenere` AS (
        SELECT DISTINCT GF.`Film`
        FROM `Esclusione` E
            INNER JOIN `GenereFilm` GF USING(`Genere`)
        WHERE E.`Abbonamento` = TipoAbbonamento
    ), 
    
    -- La minor qualita' fruibile di un Film
    `FilmMinimaRisoluzione` AS (
        SELECT `Film`.`ID`, MIN(F.Risoluzione) AS "Risoluzione"
        FROM `File` F
            INNER JOIN `Edizione` E ON F.`Edizione` = E.`ID`
            INNER JOIN `Film` ON E.`Film` = `Film`.`ID`
        GROUP BY `Film`.`ID`
    ), 
    
    -- Film esclusi perche' presenti solo in qualita' maggiore dalla massima disponibile con l'abbonamento
    `FilmEsclusiRisoluzione` AS (
        SELECT F.`ID` AS "Film"
        FROM `FilmMinimaRisoluzione` F
            INNER JOIN `Abbonamento` A ON A.`Definizione` < F.`Risoluzione`
        WHERE A.`Definizione` > 0 AND A.`Tipo` = TipoAbbonamento
    )
    -- UNION senza ALL rimuovera' in automatico gli ID duplicati
    SELECT COUNT(*) INTO NumeroFilm
    FROM (
        SELECT * FROM `FilmEsclusiGenere`

        UNION

        SELECT * FROM `FilmEsclusiRisoluzione`
    ) AS T;
END ; //

DELIMITER ;


USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FilmDisponibiliInLinguaSpecifica`;
DELIMITER //
CREATE PROCEDURE `FilmDisponibiliInLinguaSpecifica`(IN lingua VARCHAR(50))
BEGIN


    SELECT DISTINCT
        FI.ID, FI.Titolo
    FROM Doppiaggio D
    INNER JOIN File F
        ON D.File = F.ID
    INNER JOIN Edizione E
        ON E.ID = F.Edizione
    INNER JOIN Film FI
        ON FI.ID = E.Film
    WHERE D.Lingua = lingua;

END
//
DELIMITER ;

USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FilmPiuVistiRecentemente`;

DELIMITER //

CREATE PROCEDURE `FilmPiuVistiRecentemente`(IN numero_film INT)
BEGIN
    IF numero_film <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Numero di Film non valido';
    END IF;

    WITH `VisualizzazioniFilm` AS (
        SELECT V.Film, SUM(V.`NumeroVisualizzazioni`) AS "Vis"
        FROM `VisualizzazioniGiornaliere` V
        GROUP BY V.`Film`
        HAVING SUM(V.`NumeroVisualizzazioni`) > 0
        LIMIT numero_film
    )
    SELECT F.`ID`, F.`Titolo`, V.`Vis`
    FROM `Film` F
        INNER JOIN `VisualizzazioniFilm` V ON V.`Film` = F.`ID`
    ORDER BY V.`Vis` DESC;

END // 
DELIMITER ;

USE `FilmSphere`;

    DROP PROCEDURE IF EXISTS `CambioAbbonamento`;
DELIMITER //
CREATE PROCEDURE `CambioAbbonamento`(IN codice_utente VARCHAR(100), IN tipo_abbonamento VARCHAR(50))
BEGIN

    DECLARE fatture_non_pagate INT;
    SET fatture_non_pagate := (
        SELECT
            COUNT(*)
        FROM Fattura
        WHERE Utente = codice_utente
        AND CartaDiCredito IS NULL
    );

    IF fatture_non_pagate > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Utente non in pari coi pagamenti';

    ELSE

        UPDATE Utente
        SET Abbonamento = tipo_abbonamento, DataInizioAbbonamento = CURRENT_DATE()
        WHERE Codice = codice_utente;

    END IF;

END
//
DELIMITER ;

USE `FilmSphere`;

CREATE OR REPLACE VIEW `FilmMiglioriRecensioni` AS
    SELECT f.`Titolo`, f.`ID`, f.`MediaRecensioni`
    FROM `Film` f
    WHERE f.`MediaRecensioni` > (
        SELECT AVG(f2.`MediaRecensioni`)
        FROM `Film` f2)
    ORDER BY f.`MediaRecensioni` DESC
    LIMIT 20;
    
-- SELECT * FROM `FilmMiglioriRecensioni`;

