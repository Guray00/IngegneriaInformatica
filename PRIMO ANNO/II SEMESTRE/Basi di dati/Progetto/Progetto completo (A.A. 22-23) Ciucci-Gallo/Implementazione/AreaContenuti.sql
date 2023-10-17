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