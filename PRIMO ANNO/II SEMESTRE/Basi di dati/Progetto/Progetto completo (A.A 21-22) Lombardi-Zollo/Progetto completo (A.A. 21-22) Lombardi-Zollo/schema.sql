-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `AreaGeografica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AreaGeografica` ;

CREATE TABLE IF NOT EXISTS `AreaGeografica` (
  `Nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rischio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rischio` ;

CREATE TABLE IF NOT EXISTS `Rischio` (
  `Tipo` VARCHAR(100) NOT NULL,
  `Data` DATE NOT NULL,
  `Coefficiente` FLOAT NULL,
  `AreaGeografica` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Tipo`, `Data`, `AreaGeografica`),
  INDEX `fk_Rischio_AreaGeografica1_idx` (`AreaGeografica` ASC) VISIBLE,
  CONSTRAINT `fk_Rischio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Edificio` ;

CREATE TABLE IF NOT EXISTS `Edificio` (
  `CodEdificio` CHAR(5) NOT NULL,
  `Esistente` TINYINT NULL,
  `Tipo` VARCHAR(100) NULL,
  `AreaGeografica` VARCHAR(100) NOT NULL,
  `Latitudine` FLOAT NULL,
  `Longitudine` FLOAT NULL,
  PRIMARY KEY (`CodEdificio`),
  INDEX `fk_Edificio_AreaGeografica1_idx` (`AreaGeografica` ASC) VISIBLE,
  CONSTRAINT `fk_Edificio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Calamita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Calamita` ;

CREATE TABLE IF NOT EXISTS `Calamita` (
  `AreaGeografica` VARCHAR(100) NOT NULL,
  `Data` DATE NOT NULL,
  `Tipo` VARCHAR(100) NOT NULL,
  `LatEpicentro` FLOAT NULL,
  `LongEpicentro` FLOAT NULL,
  PRIMARY KEY (`AreaGeografica`, `Data`, `Tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Eventualita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Eventualita` ;

CREATE TABLE IF NOT EXISTS `Eventualita` (
  `Edificio` CHAR(5) NOT NULL,
  `AreaGeografica` VARCHAR(100) NOT NULL,
  `Data` DATE NOT NULL,
  `TipoCalamita` VARCHAR(100) NOT NULL,
  `Gravita` FLOAT NULL,
  PRIMARY KEY (`Edificio`, `AreaGeografica`, `Data`, `TipoCalamita`),
  INDEX `fk_Edificio_has_Calamita_Calamita1_idx` (`AreaGeografica` ASC, `Data` ASC, `TipoCalamita` ASC) VISIBLE,
  INDEX `fk_Edificio_has_Calamita_Edificio1_idx` (`Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Edificio_has_Calamita_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`CodEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Edificio_has_Calamita_Calamita1`
    FOREIGN KEY (`AreaGeografica` , `Data` , `TipoCalamita`)
    REFERENCES `Calamita` (`AreaGeografica` , `Data` , `Tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pianta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Pianta` ;

CREATE TABLE IF NOT EXISTS `Pianta` (
  `Piano` INT NOT NULL,
  `NLati` INT NULL,
  `Edificio` CHAR(5) NOT NULL,
  PRIMARY KEY (`Piano`, `Edificio`),
  INDEX `fk_Pianta_Edificio1_idx` (`Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Pianta_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`CodEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Vano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Vano` ;

CREATE TABLE IF NOT EXISTS `Vano` (
  `IDVano` CHAR(5) NOT NULL,
  `LungMax` FLOAT NULL,
  `HMax` FLOAT NULL,
  `LargMax` FLOAT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  `HMin` FLOAT NULL,
  PRIMARY KEY (`IDVano`, `Piano`, `Edificio`),
  INDEX `fk_Vano_Pianta1_idx` (`Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Vano_Pianta1`
    FOREIGN KEY (`Piano` , `Edificio`)
    REFERENCES `Pianta` (`Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Parte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parte` ;

CREATE TABLE IF NOT EXISTS `Parte` (
  `Nome` VARCHAR(100) NOT NULL,
  `Vano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  `Superficie` FLOAT NULL,
  `Ext` TINYINT NULL,
  PRIMARY KEY (`Nome`, `Vano`, `Piano`, `Edificio`),
  INDEX `fk_Parte_Vano1_idx` (`Vano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Parte_Vano1`
    FOREIGN KEY (`Vano` , `Piano` , `Edificio`)
    REFERENCES `Vano` (`IDVano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sensore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Sensore` ;

CREATE TABLE IF NOT EXISTS `Sensore` (
  `IDSensore` CHAR(50) NOT NULL,
  `Tipologia` VARCHAR(100) NULL,
  `XPos` FLOAT NULL,
  `YPos` FLOAT NULL,
  `Soglia` FLOAT NULL,
  `Parte` VARCHAR(100) NOT NULL,
  `Vano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  PRIMARY KEY (`IDSensore`),
  INDEX `fk_Sensore_Parte1_idx` (`Parte` ASC, `Vano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Sensore_Parte1`
    FOREIGN KEY (`Parte` , `Vano` , `Piano` , `Edificio`)
    REFERENCES `Parte` (`Nome` , `Vano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CapoCantiere`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CapoCantiere` ;

CREATE TABLE IF NOT EXISTS `CapoCantiere` (
  `CFisc` CHAR(16) NOT NULL,
  `Manodopera` FLOAT NULL,
  `OperaiMax` INT NULL,
  PRIMARY KEY (`CFisc`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Operaio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Operaio` ;

CREATE TABLE IF NOT EXISTS `Operaio` (
  `CFisc` CHAR(16) NOT NULL,
  `Manodopera` FLOAT NULL,
  `Capocantiere` CHAR(16) NOT NULL,
  `BustaPaga` FLOAT NULL,
  PRIMARY KEY (`CFisc`),
  INDEX `fk_Oparaio_Capocantiere1_idx` (`Capocantiere` ASC) VISIBLE,
  CONSTRAINT `fk_Operaio_Capocantiere1`
    FOREIGN KEY (`Capocantiere`)
    REFERENCES `CapoCantiere` (`CFisc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Responsabile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Responsabile` ;

CREATE TABLE IF NOT EXISTS `Responsabile` (
  `CFisc` CHAR(16) NOT NULL,
  `Costo` FLOAT NULL,
  PRIMARY KEY (`CFisc`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Progetto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Progetto` ;

CREATE TABLE IF NOT EXISTS `Progetto` (
  `CodProgetto` CHAR(5) NOT NULL,
  `Ristrutturazione` TINYINT NULL,
  `DataPresentazione` DATE NULL,
  `DataApprovazione` DATE NULL,
  `DataInizio` DATE NULL,
  `StimaDataFine` DATE NULL,
  `CodEdificio` CHAR(5) NOT NULL,
  PRIMARY KEY (`CodProgetto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Stadio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Stadio` ;

CREATE TABLE IF NOT EXISTS `Stadio` (
  `DataInizio` DATE NOT NULL,
  `StimaDataFine` DATE NULL,
  `DataFineEffettiva` DATE NULL,
  `CostoMateriali` FLOAT NULL,
  `CodProgetto` CHAR(5) NOT NULL,
  PRIMARY KEY (`DataInizio`, `CodProgetto`),
  INDEX `fk_Stadio_Progetto1_idx` (`CodProgetto` ASC) VISIBLE,
  CONSTRAINT `fk_Stadio_Progetto1`
    FOREIGN KEY (`CodProgetto`)
    REFERENCES `Progetto` (`CodProgetto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lavoro` ;

CREATE TABLE IF NOT EXISTS `Lavoro` (
  `CodLavoro` CHAR(5) NOT NULL,
  `Nome` VARCHAR(100) NULL,
  `Responsabile` CHAR(16) NOT NULL,
  `DataInizioStadio` DATE NOT NULL,
  `CodProgetto` CHAR(5) NOT NULL,
  PRIMARY KEY (`CodLavoro`),
  INDEX `fk_Lavoro_Responsabile1_idx` (`Responsabile` ASC) VISIBLE,
  INDEX `fk_Lavoro_Stadio1_idx` (`DataInizioStadio` ASC, `CodProgetto` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoro_Responsabile1`
    FOREIGN KEY (`Responsabile`)
    REFERENCES `Responsabile` (`CFisc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lavoro_Stadio1`
    FOREIGN KEY (`DataInizioStadio` , `CodProgetto`)
    REFERENCES `Stadio` (`DataInizio` , `CodProgetto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Controllo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Controllo` ;

CREATE TABLE IF NOT EXISTS `Controllo` (
  `CodLavoro` CHAR(5) NOT NULL,
  `Capocantiere` CHAR(16) NOT NULL,
  PRIMARY KEY (`CodLavoro`, `Capocantiere`),
  INDEX `fk_Lavoro_has_Capocantiere_Capocantiere1_idx` (`Capocantiere` ASC) VISIBLE,
  INDEX `fk_Lavoro_has_Capocantiere_Lavoro1_idx` (`CodLavoro` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoro_has_Capocantiere_Lavoro1`
    FOREIGN KEY (`CodLavoro`)
    REFERENCES `Lavoro` (`CodLavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lavoro_has_Capocantiere_Capocantiere1`
    FOREIGN KEY (`Capocantiere`)
    REFERENCES `CapoCantiere` (`CFisc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Turno` ;

CREATE TABLE IF NOT EXISTS `Turno` (
  `Data` DATE NOT NULL,
  `CFisc` CHAR(16) NOT NULL,
  `Orario` VARCHAR(11) NOT NULL,
  `DataInizioStadio` DATE NOT NULL,
  `CodProgetto` CHAR(5) NOT NULL,
  PRIMARY KEY (`Data`, `CFisc`, `Orario`),
  INDEX `fk_Turno_Stadio1_idx` (`DataInizioStadio` ASC, `CodProgetto` ASC) VISIBLE,
  CONSTRAINT `fk_Turno_Stadio1`
    FOREIGN KEY (`DataInizioStadio` , `CodProgetto`)
    REFERENCES `Stadio` (`DataInizio` , `CodProgetto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PuntoAccessoInterno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PuntoAccessoInterno` ;

CREATE TABLE IF NOT EXISTS `PuntoAccessoInterno` (
  `IDPuntoAccesso` CHAR(5) NOT NULL,
  `Tipo` VARCHAR(45) NULL,
  `Larghezza` FLOAT NULL,
  `Altezza` FLOAT NULL,
  PRIMARY KEY (`IDPuntoAccesso`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PuntoAccessoEsterno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PuntoAccessoEsterno` ;

CREATE TABLE IF NOT EXISTS `PuntoAccessoEsterno` (
  `IDPuntoAccesso` CHAR(5) NOT NULL,
  `Larghezza` FLOAT NULL,
  `Altezza` FLOAT NULL,
  `Orientamento` VARCHAR(6) NULL,
  `Tipo` VARCHAR(45) NULL,
  `IDVano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  PRIMARY KEY (`IDPuntoAccesso`),
  INDEX `fk_PuntoAccessoEsterno_Vano1_idx` (`IDVano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_PuntoAccessoEsterno_Vano1`
    FOREIGN KEY (`IDVano` , `Piano` , `Edificio`)
    REFERENCES `Vano` (`IDVano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Accelerometro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Accelerometro` ;

CREATE TABLE IF NOT EXISTS `Accelerometro` (
  `TimeStamp` TIMESTAMP(1) NOT NULL,
  `X` FLOAT NULL,
  `Y` FLOAT NULL,
  `Z` FLOAT NULL,
  `IDSensore` CHAR(5) NOT NULL,
  PRIMARY KEY (`TimeStamp`, `IDSensore`),
  INDEX `fk_Accelerometro_Sensore1_idx` (`IDSensore` ASC) VISIBLE,
  CONSTRAINT `fk_Accelerometro_Sensore1`
    FOREIGN KEY (`IDSensore`)
    REFERENCES `Sensore` (`IDSensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Giroscopio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Giroscopio` ;

CREATE TABLE IF NOT EXISTS `Giroscopio` (
  `TimeStamp` TIMESTAMP(1) NOT NULL,
  `Wx` FLOAT NULL,
  `Wy` FLOAT NULL,
  `Wz` FLOAT NULL,
  `IDSensore` CHAR(5) NOT NULL,
  PRIMARY KEY (`TimeStamp`, `IDSensore`),
  INDEX `fk_Giroscopio_Sensore1_idx` (`IDSensore` ASC) VISIBLE,
  CONSTRAINT `fk_Giroscopio_Sensore1`
    FOREIGN KEY (`IDSensore`)
    REFERENCES `Sensore` (`IDSensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Temperatura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Temperatura` ;

CREATE TABLE IF NOT EXISTS `Temperatura` (
  `TimeStamp` TIMESTAMP(1) NOT NULL,
  `TemperaturaRilevata` FLOAT NULL,
  `IDSensore` CHAR(5) NOT NULL,
  PRIMARY KEY (`TimeStamp`, `IDSensore`),
  INDEX `fk_Temperatura_Sensore1_idx` (`IDSensore` ASC) VISIBLE,
  CONSTRAINT `fk_Temperatura_Sensore1`
    FOREIGN KEY (`IDSensore`)
    REFERENCES `Sensore` (`IDSensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Posizione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Posizione` ;

CREATE TABLE IF NOT EXISTS `Posizione` (
  `TimeStamp` TIMESTAMP(1) NOT NULL,
  `Larghezza` FLOAT NULL,
  `IDSensore` CHAR(5) NOT NULL,
  PRIMARY KEY (`TimeStamp`, `IDSensore`),
  INDEX `fk_Posizione_Sensore1_idx` (`IDSensore` ASC) VISIBLE,
  CONSTRAINT `fk_Posizione_Sensore1`
    FOREIGN KEY (`IDSensore`)
    REFERENCES `Sensore` (`IDSensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '				';


-- -----------------------------------------------------
-- Table `Pluviometro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Pluviometro` ;

CREATE TABLE IF NOT EXISTS `Pluviometro` (
  `TimeStamp` TIMESTAMP(1) NOT NULL,
  `Precipitazione` FLOAT NULL,
  `IDSensore` CHAR(5) NOT NULL,
  PRIMARY KEY (`TimeStamp`, `IDSensore`),
  INDEX `fk_Pluviometro_Sensore1_idx` (`IDSensore` ASC) VISIBLE,
  CONSTRAINT `fk_Pluviometro_Sensore1`
    FOREIGN KEY (`IDSensore`)
    REFERENCES `Sensore` (`IDSensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Alert`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Alert` ;

CREATE TABLE IF NOT EXISTS `Alert` (
  `TimeStamp` TIMESTAMP(1) NOT NULL,
  `ValoreMisurato` FLOAT NULL,
  `IDSensore` CHAR(5) NOT NULL,
  PRIMARY KEY (`TimeStamp`, `IDSensore`),
  INDEX `fk_Alert_Sensore1_idx` (`IDSensore` ASC) VISIBLE,
  CONSTRAINT `fk_Alert_Sensore1`
    FOREIGN KEY (`IDSensore`)
    REFERENCES `Sensore` (`IDSensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Materiale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Materiale` ;

CREATE TABLE IF NOT EXISTS `Materiale` (
  `CodLotto` CHAR(5) NOT NULL,
  `NomeFornitore` VARCHAR(100) NOT NULL,
  `Tipo` VARCHAR(100) NULL,
  `Quantita` FLOAT NULL,
  `DataAcquisto` DATE NULL,
  `CodLavoro` CHAR(5) NOT NULL,
  `Parte` VARCHAR(100) NOT NULL,
  `Vano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  PRIMARY KEY (`CodLotto`, `NomeFornitore`),
  INDEX `fk_Materiale_Lavoro1_idx` (`CodLavoro` ASC) VISIBLE,
  INDEX `fk_Materiale_Parte1_idx` (`Parte` ASC, `Vano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Materiale_Lavoro1`
    FOREIGN KEY (`CodLavoro`)
    REFERENCES `Lavoro` (`CodLavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materiale_Parte1`
    FOREIGN KEY (`Parte` , `Vano` , `Piano` , `Edificio`)
    REFERENCES `Parte` (`Nome` , `Vano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pietra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Pietra` ;

CREATE TABLE IF NOT EXISTS `Pietra` (
  `CodLotto` CHAR(5) NOT NULL,
  `NomeFornitore` VARCHAR(100) NOT NULL,
  `SuperficieMedia` FLOAT NULL,
  `PesoMedio` FLOAT NULL,
  `Decorativa` TINYINT NULL,
  `Costo_kg` FLOAT NULL,
  `Disposizione` VARCHAR(11) NULL,
  `Tipo` VARCHAR(100) NULL,
  PRIMARY KEY (`CodLotto`, `NomeFornitore`),
  CONSTRAINT `fk_Pietra_Materiale1`
    FOREIGN KEY (`CodLotto` , `NomeFornitore`)
    REFERENCES `Materiale` (`CodLotto` , `NomeFornitore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Intonaco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Intonaco` ;

CREATE TABLE IF NOT EXISTS `Intonaco` (
  `CodLotto` CHAR(5) NOT NULL,
  `NomeFornitore` VARCHAR(100) NOT NULL,
  `Tipo` VARCHAR(100) NULL,
  `Spessore` FLOAT NULL,
  `Costo_kg` FLOAT NULL,
  PRIMARY KEY (`CodLotto`, `NomeFornitore`),
  INDEX `fk_Intonaco_Materiale1_idx` (`CodLotto` ASC, `NomeFornitore` ASC) VISIBLE,
  CONSTRAINT `fk_Intonaco_Materiale1`
    FOREIGN KEY (`CodLotto` , `NomeFornitore`)
    REFERENCES `Materiale` (`CodLotto` , `NomeFornitore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mattone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Mattone` ;

CREATE TABLE IF NOT EXISTS `Mattone` (
  `CodLotto` CHAR(5) NOT NULL,
  `NomeFornitore` VARCHAR(100) NOT NULL,
  `Costo_mq` FLOAT NULL,
  `Larghezza` FLOAT NULL,
  `Lunghezza` FLOAT NULL,
  `Altezza` FLOAT NULL,
  `Costituente` VARCHAR(100) NULL,
  `Alveolato` TINYINT NULL,
  `Isolante` TINYINT NULL,
  `TipoAlveolatura` VARCHAR(100) NULL,
  PRIMARY KEY (`CodLotto`, `NomeFornitore`),
  INDEX `fk_Mattone_Materiale1_idx` (`CodLotto` ASC, `NomeFornitore` ASC) VISIBLE,
  CONSTRAINT `fk_Mattone_Materiale1`
    FOREIGN KEY (`CodLotto` , `NomeFornitore`)
    REFERENCES `Materiale` (`CodLotto` , `NomeFornitore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Piastrella`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Piastrella` ;

CREATE TABLE IF NOT EXISTS `Piastrella` (
  `CodLotto` CHAR(5) NOT NULL,
  `NomeFornitore` VARCHAR(100) NOT NULL,
  `TipoDisegno` VARCHAR(100) NULL,
  `Costo_mq` FLOAT NULL,
  `Costituente` VARCHAR(100) NULL,
  `NumLati` INT NULL,
  `LungLato` FLOAT NULL,
  `Fuga` FLOAT NULL,
  `Adesivo` VARCHAR(100) NULL,
  PRIMARY KEY (`CodLotto`, `NomeFornitore`),
  INDEX `fk_Piastrella_Materiale1_idx` (`CodLotto` ASC, `NomeFornitore` ASC) VISIBLE,
  CONSTRAINT `fk_Piastrella_Materiale1`
    FOREIGN KEY (`CodLotto` , `NomeFornitore`)
    REFERENCES `Materiale` (`CodLotto` , `NomeFornitore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Altro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Altro` ;

CREATE TABLE IF NOT EXISTS `Altro` (
  `CodLotto` CHAR(5) NOT NULL,
  `NomeFornitore` VARCHAR(100) NOT NULL,
  `Tipo` VARCHAR(100) NULL,
  `Costo` FLOAT NULL,
  `Altezza` FLOAT NULL,
  `Lunghezza` FLOAT NULL,
  `Larghezza` FLOAT NULL,
  `Peso` FLOAT NULL,
  PRIMARY KEY (`CodLotto`, `NomeFornitore`),
  INDEX `fk_Altro_Materiale1_idx` (`CodLotto` ASC, `NomeFornitore` ASC) VISIBLE,
  CONSTRAINT `fk_Altro_Materiale1`
    FOREIGN KEY (`CodLotto` , `NomeFornitore`)
    REFERENCES `Materiale` (`CodLotto` , `NomeFornitore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Funzione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Funzione` ;

CREATE TABLE IF NOT EXISTS `Funzione` (
  `NomeFunz` VARCHAR(255) NOT NULL,
  `IDVano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  PRIMARY KEY (`NomeFunz`, `IDVano`, `Piano`, `Edificio`),
  INDEX `fk_Funzione_Vano1_idx` (`IDVano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Funzione_Vano1`
    FOREIGN KEY (`IDVano` , `Piano` , `Edificio`)
    REFERENCES `Vano` (`IDVano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LavoriTurno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LavoriTurno` ;

CREATE TABLE IF NOT EXISTS `LavoriTurno` (
  `OraInizio` INT NOT NULL,
  `NumeroOre` INT NULL,
  `CodLavoro` CHAR(5) NULL,
  `Capo` CHAR(16) NULL,
  `Data` DATE NOT NULL,
  `CFiscLavoratore` CHAR(16) NOT NULL,
  `Orario` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`OraInizio`, `Data`, `CFiscLavoratore`, `Orario`),
  INDEX `fk_LavoriTurno_Turno1_idx` (`Data` ASC, `CFiscLavoratore` ASC, `Orario` ASC) VISIBLE,
  CONSTRAINT `fk_LavoriTurno_Turno1`
    FOREIGN KEY (`Data` , `CFiscLavoratore` , `Orario`)
    REFERENCES `Turno` (`Data` , `CFisc` , `Orario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Finestra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Finestra` ;

CREATE TABLE IF NOT EXISTS `Finestra` (
  `IDFinestra` CHAR(5) NOT NULL,
  `IDVano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  `Larghezza` FLOAT NULL,
  `Altezza` FLOAT NULL,
  `Orientamento` VARCHAR(6) NULL,
  PRIMARY KEY (`IDFinestra`),
  INDEX `fk_Finestra_Vano1_idx` (`IDVano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Finestra_Vano1`
    FOREIGN KEY (`IDVano` , `Piano` , `Edificio`)
    REFERENCES `Vano` (`IDVano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AccessoI`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AccessoI` ;

CREATE TABLE IF NOT EXISTS `AccessoI` (
  `IDPuntoAccesso` CHAR(5) NOT NULL,
  `IDVano` CHAR(5) NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` CHAR(5) NOT NULL,
  `Orientamento` VARCHAR(5) NULL,
  PRIMARY KEY (`IDPuntoAccesso`, `IDVano`, `Piano`, `Edificio`),
  INDEX `fk_PuntoAccessoInterno_has_Vano_Vano1_idx` (`IDVano` ASC, `Piano` ASC, `Edificio` ASC) VISIBLE,
  INDEX `fk_PuntoAccessoInterno_has_Vano_PuntoAccessoInterno1_idx` (`IDPuntoAccesso` ASC) VISIBLE,
  CONSTRAINT `fk_PuntoAccessoInterno_has_Vano_PuntoAccessoInterno1`
    FOREIGN KEY (`IDPuntoAccesso`)
    REFERENCES `PuntoAccessoInterno` (`IDPuntoAccesso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PuntoAccessoInterno_has_Vano_Vano1`
    FOREIGN KEY (`IDVano` , `Piano` , `Edificio`)
    REFERENCES `Vano` (`IDVano` , `Piano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
