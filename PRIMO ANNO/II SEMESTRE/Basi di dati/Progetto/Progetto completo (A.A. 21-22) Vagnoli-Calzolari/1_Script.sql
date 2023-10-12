-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema progetto_bd_2223
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema progetto_bd_2223
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `progetto_bd_2223` DEFAULT CHARACTER SET utf8 ;
USE `progetto_bd_2223` ;

-- -----------------------------------------------------
-- Table `Tipologia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Tipologia` ;

CREATE TABLE IF NOT EXISTS `Tipologia` (
  `NomeTipologia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NomeTipologia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AreaGeografica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AreaGeografica` ;

CREATE TABLE IF NOT EXISTS `AreaGeografica` (
  `ID` INT UNSIGNED NOT NULL,
  `Citta` VARCHAR(45) NOT NULL,
  `Tipo` VARCHAR(45) NULL,
  `Superficie` INT UNSIGNED NOT NULL,
  `CoordinataXCentroGeografico` INT NOT NULL,
  `CoordinataYCentroGeografico` INT NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Edificio` ;

CREATE TABLE IF NOT EXISTS `Edificio` (
  `Codice` VARCHAR(16) NOT NULL,
  `DataAccatastamento` DATE NULL,
  `Stato` INT NULL,
  `CoordinataX` FLOAT NULL,
  `CoordinataY` FLOAT NULL,
  `Tipologia` VARCHAR(45) NOT NULL,
  `AreaGeografica` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_Edificio_Tipologia_idx` (`Tipologia` ASC),
  INDEX `fk_Edificio_AreaGeografica1_idx` (`AreaGeografica` ASC),
  CONSTRAINT `fk_Edificio_Tipologia`
    FOREIGN KEY (`Tipologia`)
    REFERENCES `Tipologia` (`NomeTipologia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Edificio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StoricoRischio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StoricoRischio` ;

CREATE TABLE IF NOT EXISTS `StoricoRischio` (
  `AreaGeografica` INT UNSIGNED NOT NULL,
  `Rischio` VARCHAR(45) NOT NULL,
  `DataAnalisi` DATE NOT NULL,
  `Coefficiente` INT NOT NULL,
  PRIMARY KEY (`AreaGeografica`, `Rischio`, `DataAnalisi`),
  INDEX `fk_AreaGeografica_has_Rischio_AreaGeografica1_idx` (`AreaGeografica` ASC),
  CONSTRAINT `fk_AreaGeografica_has_Rischio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EventoCalamitoso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EventoCalamitoso` ;

CREATE TABLE IF NOT EXISTS `EventoCalamitoso` (
  `NomeEventoCalamitoso` VARCHAR(45) NOT NULL,
  `Data` DATE NOT NULL,
  `Raggio` INT UNSIGNED NOT NULL,
  `CoordinataXEpicentro` INT NOT NULL,
  `CoordinataYEpicentro` INT NOT NULL,
  `LivelloDiGravita` INT NOT NULL,
  `AreaGeografica` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`NomeEventoCalamitoso`, `Data`, `AreaGeografica`),
  INDEX `fk_EventoCalamitoso_AreaGeografica1_idx` (`AreaGeografica` ASC),
  CONSTRAINT `fk_EventoCalamitoso_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pianta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Pianta` ;

CREATE TABLE IF NOT EXISTS `Pianta` (
  `Nome` VARCHAR(45) NOT NULL,
  `Perimetro` INT UNSIGNED NOT NULL,
  `Area` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Piano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Piano` ;

CREATE TABLE IF NOT EXISTS `Piano` (
  `ID` INT NOT NULL,
  `Edificio` VARCHAR(16) NOT NULL,
  `Pianta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Piano_Edificio1_idx` (`Edificio` ASC),
  INDEX `fk_Piano_Pianta1_idx` (`Pianta` ASC),
  CONSTRAINT `fk_Piano_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Piano_Pianta1`
    FOREIGN KEY (`Pianta`)
    REFERENCES `Pianta` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Vano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Vano` ;

CREATE TABLE IF NOT EXISTS `Vano` (
  `ID` INT NOT NULL,
  `Perimetro` INT UNSIGNED NOT NULL,
  `Area` INT UNSIGNED NOT NULL,
  `AltezzaMax` INT UNSIGNED NOT NULL,
  `LarghezzaMax` INT UNSIGNED NOT NULL,
  `LunghezzaMax` INT UNSIGNED NOT NULL,
  `Piano` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Vano_Piano1_idx` (`Piano` ASC),
  CONSTRAINT `fk_Vano_Piano1`
    FOREIGN KEY (`Piano`)
    REFERENCES `Piano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Funzione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Funzione` ;

CREATE TABLE IF NOT EXISTS `Funzione` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FunzioneVano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FunzioneVano` ;

CREATE TABLE IF NOT EXISTS `FunzioneVano` (
  `Vano` INT NOT NULL,
  `Funzione` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Vano`, `Funzione`),
  INDEX `fk_Vano_has_Funzione_Funzione1_idx` (`Funzione` ASC),
  INDEX `fk_Vano_has_Funzione_Vano1_idx` (`Vano` ASC),
  CONSTRAINT `fk_Vano_has_Funzione_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vano_has_Funzione_Funzione1`
    FOREIGN KEY (`Funzione`)
    REFERENCES `Funzione` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Finestra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Finestra` ;

CREATE TABLE IF NOT EXISTS `Finestra` (
  `ID` INT NOT NULL,
  `PuntoCardinale` VARCHAR(2) NULL,
  `Perimetro` INT UNSIGNED NULL,
  `Area` INT UNSIGNED NULL,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Finestra_Vano1_idx` (`Vano` ASC),
  CONSTRAINT `fk_Finestra_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TipologiaPuntoDiAccesso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TipologiaPuntoDiAccesso` ;

CREATE TABLE IF NOT EXISTS `TipologiaPuntoDiAccesso` (
  `NomeTipologia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NomeTipologia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PuntoDiAccesso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PuntoDiAccesso` ;

CREATE TABLE IF NOT EXISTS `PuntoDiAccesso` (
  `ID` INT NOT NULL,
  `PuntoCardinale` VARCHAR(2) NOT NULL,
  `Perimetro` INT UNSIGNED NULL,
  `Area` INT UNSIGNED NULL,
  `Collegamento` VARCHAR(45) NULL,
  `TipologiaPuntoDiAccesso` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_PuntoDiAccesso_TipologiaPuntoDiAccesso1_idx` (`TipologiaPuntoDiAccesso` ASC),
  CONSTRAINT `fk_PuntoDiAccesso_TipologiaPuntoDiAccesso1`
    FOREIGN KEY (`TipologiaPuntoDiAccesso`)
    REFERENCES `TipologiaPuntoDiAccesso` (`NomeTipologia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AccessoVano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AccessoVano` ;

CREATE TABLE IF NOT EXISTS `AccessoVano` (
  `PuntoDiAccesso` INT NOT NULL,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`PuntoDiAccesso`, `Vano`),
  INDEX `fk_PuntoDiAccesso_has_Vano_Vano1_idx` (`Vano` ASC),
  INDEX `fk_PuntoDiAccesso_has_Vano_PuntoDiAccesso1_idx` (`PuntoDiAccesso` ASC),
  CONSTRAINT `fk_PuntoDiAccesso_has_Vano_PuntoDiAccesso1`
    FOREIGN KEY (`PuntoDiAccesso`)
    REFERENCES `PuntoDiAccesso` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PuntoDiAccesso_has_Vano_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Muratura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Muratura` ;

CREATE TABLE IF NOT EXISTS `Muratura` (
  `ID` VARCHAR(45) NOT NULL,
  `Descrizione` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sensore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Sensore` ;

CREATE TABLE IF NOT EXISTS `Sensore` (
  `Codice` VARCHAR(45) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Grandezza` VARCHAR(45) NOT NULL,
  `UnitaDiMisura` VARCHAR(3) NOT NULL,
  `CoordinataX` FLOAT NULL,
  `CoordinataY` FLOAT NULL,
  `SogliaDiRischio` FLOAT NULL,
  `Muratura` VARCHAR(45) NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_Sensore_Muratura1_idx` (`Muratura` ASC),
  CONSTRAINT `fk_Sensore_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Misurazione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Misurazione` ;

CREATE TABLE IF NOT EXISTS `Misurazione` (
  `Codice` VARCHAR(20) NOT NULL,
  `Sensore` VARCHAR(45) NOT NULL,
  `Valore` FLOAT NULL,
  `Timestamp` TIMESTAMP(1) NOT NULL,
  `Edificio` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_Registrazione_has_Sensore_Sensore1_idx` (`Sensore` ASC),
  INDEX `fk_Misurazione_Edificio1_idx` (`Edificio` ASC),
  CONSTRAINT `fk_Registrazione_has_Sensore_Sensore1`
    FOREIGN KEY (`Sensore`)
    REFERENCES `Sensore` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Misurazione_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MisurazioneTriassiale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MisurazioneTriassiale` ;

CREATE TABLE IF NOT EXISTS `MisurazioneTriassiale` (
  `Codice` VARCHAR(20) NOT NULL,
  `Sensore` VARCHAR(45) NOT NULL,
  `ValoreX` FLOAT NOT NULL,
  `ValoreY` FLOAT NOT NULL,
  `ValoreZ` FLOAT NOT NULL,
  `Timestamp` TIMESTAMP(1) NOT NULL,
  `Edificio` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_Registrazione_has_Sensore1_Sensore1_idx` (`Sensore` ASC),
  INDEX `fk_MisurazioneTriassiale_Edificio1_idx` (`Edificio` ASC),
  CONSTRAINT `fk_Registrazione_has_Sensore1_Sensore1`
    FOREIGN KEY (`Sensore`)
    REFERENCES `Sensore` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MisurazioneTriassiale_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AlertTriassiale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AlertTriassiale` ;

CREATE TABLE IF NOT EXISTS `AlertTriassiale` (
  `Codice` INT NOT NULL,
  `Timestamp` TIMESTAMP(1) NOT NULL,
  `MisurazioneTriassiale` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_Alert_MisurazioneTriassiale1_idx` (`MisurazioneTriassiale` ASC),
  CONSTRAINT `fk_Alert_MisurazioneTriassiale1`
    FOREIGN KEY (`MisurazioneTriassiale`)
    REFERENCES `MisurazioneTriassiale` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MaterialeGenerico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MaterialeGenerico` ;

CREATE TABLE IF NOT EXISTS `MaterialeGenerico` (
  `CodiceLotto` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DataAcquisto` DATE NULL,
  `Costomq` FLOAT UNSIGNED NULL,
  `Costoquintale` FLOAT UNSIGNED NULL,
  `NomeFornitore` VARCHAR(45) NULL,
  `Quantita` INT UNSIGNED NULL,
  `Costituzione` VARCHAR(45) NULL,
  `Larghezza` FLOAT UNSIGNED NULL,
  `Lunghezza` FLOAT UNSIGNED NULL,
  `Spessore` FLOAT UNSIGNED NULL,
  PRIMARY KEY (`CodiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MaterialeGenericoEdificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MaterialeGenericoEdificio` ;

CREATE TABLE IF NOT EXISTS `MaterialeGenericoEdificio` (
  `Muratura` VARCHAR(45) NOT NULL,
  `MaterialeGenerico` INT NOT NULL,
  PRIMARY KEY (`Muratura`, `MaterialeGenerico`),
  INDEX `fk_Muratura_has_MaterialeGenerico_MaterialeGenerico1_idx` (`MaterialeGenerico` ASC),
  INDEX `fk_Muratura_has_MaterialeGenerico_Muratura1_idx` (`Muratura` ASC),
  CONSTRAINT `fk_Muratura_has_MaterialeGenerico_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Muratura_has_MaterialeGenerico_MaterialeGenerico1`
    FOREIGN KEY (`MaterialeGenerico`)
    REFERENCES `MaterialeGenerico` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Intonaco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Intonaco` ;

CREATE TABLE IF NOT EXISTS `Intonaco` (
  `CodiceLotto` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DataAcquisto` DATE NULL,
  `Costo` FLOAT UNSIGNED NULL,
  `NomeFornitore` VARCHAR(45) NULL,
  `Quantita` INT UNSIGNED NULL,
  `Costituzione` VARCHAR(45) NULL,
  `Larghezza` FLOAT UNSIGNED NULL,
  `Lunghezza` FLOAT UNSIGNED NULL,
  `Spessore` FLOAT UNSIGNED NULL,
  PRIMARY KEY (`CodiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mattone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Mattone` ;

CREATE TABLE IF NOT EXISTS `Mattone` (
  `CodiceLotto` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DataAcquisto` DATE NULL,
  `Costoquintale` FLOAT UNSIGNED NULL,
  `NomeFornitore` VARCHAR(45) NULL,
  `Quantita` INT UNSIGNED NULL,
  `Costituzione` VARCHAR(45) NULL,
  `Larghezza` FLOAT UNSIGNED NULL,
  `Lunghezza` FLOAT UNSIGNED NULL,
  `Spessore` FLOAT UNSIGNED NULL,
  `Alveolatura` VARCHAR(45) NULL,
  `Diametro` FLOAT UNSIGNED NULL,
  `Isolante` TINYINT(1) NULL,
  PRIMARY KEY (`CodiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Piastrella`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Piastrella` ;

CREATE TABLE IF NOT EXISTS `Piastrella` (
  `CodiceLotto` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DataAcquisto` DATE NULL,
  `Costo` FLOAT UNSIGNED NULL,
  `NomeFornitore` VARCHAR(45) NULL,
  `Quantita` INT UNSIGNED NULL,
  `Costituzione` VARCHAR(45) NULL,
  `Larghezza` FLOAT UNSIGNED NULL,
  `Lunghezza` FLOAT UNSIGNED NULL,
  `Spessore` FLOAT UNSIGNED NULL,
  `Disegno` VARCHAR(45) NULL,
  `Fuga` FLOAT UNSIGNED NULL,
  `NumeroLati` INT UNSIGNED NULL,
  PRIMARY KEY (`CodiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pietra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Pietra` ;

CREATE TABLE IF NOT EXISTS `Pietra` (
  `CodiceLotto` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DataAcquisto` DATE NULL,
  `Costo` FLOAT UNSIGNED NULL,
  `NomeFornitore` VARCHAR(45) NULL,
  `Quantita` INT UNSIGNED NULL,
  `Costituzione` VARCHAR(45) NULL,
  `Larghezza` FLOAT UNSIGNED NULL,
  `Lunghezza` FLOAT UNSIGNED NULL,
  `Spessore` FLOAT UNSIGNED NULL,
  `NumeroPietreLotto` VARCHAR(45) NULL,
  PRIMARY KEY (`CodiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MattoneEdificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MattoneEdificio` ;

CREATE TABLE IF NOT EXISTS `MattoneEdificio` (
  `Muratura` VARCHAR(45) NOT NULL,
  `Mattone` INT NOT NULL,
  PRIMARY KEY (`Muratura`, `Mattone`),
  INDEX `fk_Muratura_has_Mattone_Mattone1_idx` (`Mattone` ASC),
  INDEX `fk_Muratura_has_Mattone_Muratura1_idx` (`Muratura` ASC),
  CONSTRAINT `fk_Muratura_has_Mattone_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Muratura_has_Mattone_Mattone1`
    FOREIGN KEY (`Mattone`)
    REFERENCES `Mattone` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PietraEdificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PietraEdificio` ;

CREATE TABLE IF NOT EXISTS `PietraEdificio` (
  `Muratura` VARCHAR(45) NOT NULL,
  `Pietra` INT NOT NULL,
  `Disposizione` VARCHAR(45) NULL,
  `SuperficieMediamq` FLOAT UNSIGNED NULL,
  `PesoMedioKg` FLOAT UNSIGNED NULL,
  PRIMARY KEY (`Muratura`, `Pietra`),
  INDEX `fk_Muratura_has_Pietra_Pietra1_idx` (`Pietra` ASC),
  INDEX `fk_Muratura_has_Pietra_Muratura1_idx` (`Muratura` ASC),
  CONSTRAINT `fk_Muratura_has_Pietra_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Muratura_has_Pietra_Pietra1`
    FOREIGN KEY (`Pietra`)
    REFERENCES `Pietra` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PiastrellaEdificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PiastrellaEdificio` ;

CREATE TABLE IF NOT EXISTS `PiastrellaEdificio` (
  `Muratura` VARCHAR(45) NOT NULL,
  `Piastrella` INT NOT NULL,
  PRIMARY KEY (`Muratura`, `Piastrella`),
  INDEX `fk_Muratura_has_Piastrella_Piastrella1_idx` (`Piastrella` ASC),
  INDEX `fk_Muratura_has_Piastrella_Muratura1_idx` (`Muratura` ASC),
  CONSTRAINT `fk_Muratura_has_Piastrella_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Muratura_has_Piastrella_Piastrella1`
    FOREIGN KEY (`Piastrella`)
    REFERENCES `Piastrella` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IntonacoEdificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `IntonacoEdificio` ;

CREATE TABLE IF NOT EXISTS `IntonacoEdificio` (
  `Muratura` VARCHAR(45) NOT NULL,
  `Intonaco` INT NOT NULL,
  PRIMARY KEY (`Muratura`, `Intonaco`),
  INDEX `fk_Muratura_has_Intonaco_Intonaco1_idx` (`Intonaco` ASC),
  INDEX `fk_Muratura_has_Intonaco_Muratura1_idx` (`Muratura` ASC),
  CONSTRAINT `fk_Muratura_has_Intonaco_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Muratura_has_Intonaco_Intonaco1`
    FOREIGN KEY (`Intonaco`)
    REFERENCES `Intonaco` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ProgettoEdilizio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ProgettoEdilizio` ;

CREATE TABLE IF NOT EXISTS `ProgettoEdilizio` (
  `Codice` INT NOT NULL,
  `DataPresentazione` DATE NULL,
  `DataApprovazione` DATE NULL,
  `DataInizio` DATE NULL,
  `StimaDataFine` DATE NULL,
  `DataFine` DATE NULL,
  `Costo` FLOAT UNSIGNED NULL,
  `Edificio` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_ProgettoEdilizio_Edificio1_idx` (`Edificio` ASC),
  CONSTRAINT `fk_ProgettoEdilizio_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Responsabile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Responsabile` ;

CREATE TABLE IF NOT EXISTS `Responsabile` (
  `CodiceFiscale` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`CodiceFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StadioDiAvanzamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StadioDiAvanzamento` ;

CREATE TABLE IF NOT EXISTS `StadioDiAvanzamento` (
  `Codice` INT NOT NULL,
  `DataInizio` DATE NULL,
  `StimaDataFine` DATE NULL,
  `DataFine` DATE NULL,
  `ProgettoEdilizio` INT NOT NULL,
  `Responsabile` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_StadioDiAvanzamento_ProgettoEdilizio1_idx` (`ProgettoEdilizio` ASC),
  INDEX `fk_StadioDiAvanzamento_Responsabile1_idx` (`Responsabile` ASC),
  CONSTRAINT `fk_StadioDiAvanzamento_ProgettoEdilizio1`
    FOREIGN KEY (`ProgettoEdilizio`)
    REFERENCES `ProgettoEdilizio` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StadioDiAvanzamento_Responsabile1`
    FOREIGN KEY (`Responsabile`)
    REFERENCES `Responsabile` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Capocantiere`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Capocantiere` ;

CREATE TABLE IF NOT EXISTS `Capocantiere` (
  `CodiceFiscale` VARCHAR(16) NOT NULL,
  `PagaOraria` INT UNSIGNED NULL,
  `NumeroMaxPersone` INT UNSIGNED NULL,
  PRIMARY KEY (`CodiceFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lavoratore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lavoratore` ;

CREATE TABLE IF NOT EXISTS `Lavoratore` (
  `CodiceFiscale` VARCHAR(16) NOT NULL,
  `PagaOraria` INT UNSIGNED NULL,
  `Capocantiere` VARCHAR(16) NOT NULL,
  `TotaleOre` FLOAT UNSIGNED NULL,
  PRIMARY KEY (`CodiceFiscale`),
  INDEX `fk_Lavoratore_CapoCantiere1_idx` (`Capocantiere` ASC),
  CONSTRAINT `fk_Lavoratore_CapoCantiere1`
    FOREIGN KEY (`Capocantiere`)
    REFERENCES `Capocantiere` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TurnoLavoratore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TurnoLavoratore` ;

CREATE TABLE IF NOT EXISTS `TurnoLavoratore` (
  `Lavoratore` VARCHAR(16) NOT NULL,
  `Giorno` DATE NOT NULL,
  `OraInizio` TIME NOT NULL,
  `OraFine` TIME NOT NULL,
  `DataIncaricoTurno` DATE NOT NULL,
  `StadioDiAvanzamento` INT NOT NULL,
  PRIMARY KEY (`Lavoratore`, `Giorno`, `OraInizio`),
  INDEX `fk_StadioDiAvanzamento_has_Lavoratore_Lavoratore1_idx` (`Lavoratore` ASC),
  INDEX `fk_StadioDiAvanzamento_has_Lavoratore_StadioDiAvanzamento1_idx` (`StadioDiAvanzamento` ASC),
  CONSTRAINT `fk_StadioDiAvanzamento_has_Lavoratore_StadioDiAvanzamento1`
    FOREIGN KEY (`StadioDiAvanzamento`)
    REFERENCES `StadioDiAvanzamento` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StadioDiAvanzamento_has_Lavoratore_Lavoratore1`
    FOREIGN KEY (`Lavoratore`)
    REFERENCES `Lavoratore` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TurnoCapocantiere`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TurnoCapocantiere` ;

CREATE TABLE IF NOT EXISTS `TurnoCapocantiere` (
  `Capocantiere` VARCHAR(16) NOT NULL,
  `Giorno` DATE NOT NULL,
  `OraInizio` TIME NOT NULL,
  `OraFine` TIME NOT NULL,
  `DataIncaricoTurno` DATE NOT NULL,
  `StadioDiAvanzamento` INT NOT NULL,
  PRIMARY KEY (`Capocantiere`, `Giorno`, `OraInizio`),
  INDEX `fk_StadioDiAvanzamento_has_Responsabile_Responsabile1_idx` (`Capocantiere` ASC),
  INDEX `fk_StadioDiAvanzamento_has_Responsabile_StadioDiAvanzamento_idx` (`StadioDiAvanzamento` ASC),
  CONSTRAINT `fk_StadioDiAvanzamento_has_Responsabile_StadioDiAvanzamento1`
    FOREIGN KEY (`StadioDiAvanzamento`)
    REFERENCES `StadioDiAvanzamento` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StadioDiAvanzamento_has_Responsabile_Responsabile1`
    FOREIGN KEY (`Capocantiere`)
    REFERENCES `Capocantiere` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lavoro` ;

CREATE TABLE IF NOT EXISTS `Lavoro` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DivisioneLavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DivisioneLavoro` ;

CREATE TABLE IF NOT EXISTS `DivisioneLavoro` (
  `StadioDiAvanzamento` INT NOT NULL,
  `Lavoro` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`StadioDiAvanzamento`, `Lavoro`),
  INDEX `fk_StadioDiAvanzamento_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC),
  INDEX `fk_StadioDiAvanzamento_has_Lavoro_StadioDiAvanzamento1_idx` (`StadioDiAvanzamento` ASC),
  CONSTRAINT `fk_StadioDiAvanzamento_has_Lavoro_StadioDiAvanzamento1`
    FOREIGN KEY (`StadioDiAvanzamento`)
    REFERENCES `StadioDiAvanzamento` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StadioDiAvanzamento_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mansione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Mansione` ;

CREATE TABLE IF NOT EXISTS `Mansione` (
  `Lavoro` VARCHAR(45) NOT NULL,
  `Lavoratore` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Lavoro`, `Lavoratore`),
  INDEX `fk_Lavoro_has_Lavoratore_Lavoratore1_idx` (`Lavoratore` ASC),
  INDEX `fk_Lavoro_has_Lavoratore_Lavoro1_idx` (`Lavoro` ASC),
  CONSTRAINT `fk_Lavoro_has_Lavoratore_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lavoro_has_Lavoratore_Lavoratore1`
    FOREIGN KEY (`Lavoratore`)
    REFERENCES `Lavoratore` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UtilizzoMattone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UtilizzoMattone` ;

CREATE TABLE IF NOT EXISTS `UtilizzoMattone` (
  `Mattone` INT NOT NULL,
  `Lavoro` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Mattone`, `Lavoro`),
  INDEX `fk_Mattone_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC),
  INDEX `fk_Mattone_has_Lavoro_Mattone1_idx` (`Mattone` ASC),
  CONSTRAINT `fk_Mattone_has_Lavoro_Mattone1`
    FOREIGN KEY (`Mattone`)
    REFERENCES `Mattone` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Mattone_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UtilizzoPiastrella`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UtilizzoPiastrella` ;

CREATE TABLE IF NOT EXISTS `UtilizzoPiastrella` (
  `Piastrella` INT NOT NULL,
  `Lavoro` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Piastrella`, `Lavoro`),
  INDEX `fk_Piastrella_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC),
  INDEX `fk_Piastrella_has_Lavoro_Piastrella1_idx` (`Piastrella` ASC),
  CONSTRAINT `fk_Piastrella_has_Lavoro_Piastrella1`
    FOREIGN KEY (`Piastrella`)
    REFERENCES `Piastrella` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Piastrella_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UtilizzoIntonaco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UtilizzoIntonaco` ;

CREATE TABLE IF NOT EXISTS `UtilizzoIntonaco` (
  `Lavoro` VARCHAR(45) NOT NULL,
  `Intonaco` INT NOT NULL,
  PRIMARY KEY (`Lavoro`, `Intonaco`),
  INDEX `fk_Lavoro_has_Intonaco_Intonaco1_idx` (`Intonaco` ASC),
  INDEX `fk_Lavoro_has_Intonaco_Lavoro1_idx` (`Lavoro` ASC),
  CONSTRAINT `fk_Lavoro_has_Intonaco_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lavoro_has_Intonaco_Intonaco1`
    FOREIGN KEY (`Intonaco`)
    REFERENCES `Intonaco` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UtilizzoPietra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UtilizzoPietra` ;

CREATE TABLE IF NOT EXISTS `UtilizzoPietra` (
  `Pietra` INT NOT NULL,
  `Lavoro` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Pietra`, `Lavoro`),
  INDEX `fk_Pietra_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC),
  INDEX `fk_Pietra_has_Lavoro_Pietra1_idx` (`Pietra` ASC),
  CONSTRAINT `fk_Pietra_has_Lavoro_Pietra1`
    FOREIGN KEY (`Pietra`)
    REFERENCES `Pietra` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pietra_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UtilizzoMaterialeGenerico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UtilizzoMaterialeGenerico` ;

CREATE TABLE IF NOT EXISTS `UtilizzoMaterialeGenerico` (
  `MaterialeGenerico` INT NOT NULL,
  `Lavoro` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MaterialeGenerico`, `Lavoro`),
  INDEX `fk_MaterialeGenerico_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC),
  INDEX `fk_MaterialeGenerico_has_Lavoro_MaterialeGenerico1_idx` (`MaterialeGenerico` ASC),
  CONSTRAINT `fk_MaterialeGenerico_has_Lavoro_MaterialeGenerico1`
    FOREIGN KEY (`MaterialeGenerico`)
    REFERENCES `MaterialeGenerico` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MaterialeGenerico_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StrutturaVano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StrutturaVano` ;

CREATE TABLE IF NOT EXISTS `StrutturaVano` (
  `Vano` INT NOT NULL,
  `Muratura` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Vano`, `Muratura`),
  INDEX `fk_Vano_has_Muratura_Muratura1_idx` (`Muratura` ASC),
  INDEX `fk_Vano_has_Muratura_Vano1_idx` (`Vano` ASC),
  CONSTRAINT `fk_Vano_has_Muratura_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vano_has_Muratura_Muratura1`
    FOREIGN KEY (`Muratura`)
    REFERENCES `Muratura` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Alert`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Alert` ;

CREATE TABLE IF NOT EXISTS `Alert` (
  `Codice` INT NOT NULL,
  `Timestamp` TIMESTAMP(1) NOT NULL,
  `Misurazione` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_AlertTriassiale_Misurazione1_idx` (`Misurazione` ASC),
  CONSTRAINT `fk_AlertTriassiale_Misurazione1`
    FOREIGN KEY (`Misurazione`)
    REFERENCES `Misurazione` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
