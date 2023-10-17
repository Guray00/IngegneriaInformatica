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