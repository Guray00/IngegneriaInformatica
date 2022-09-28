SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS PAS; -- ProgettoneArapiScarrone
CREATE SCHEMA IF NOT EXISTS PAS DEFAULT CHARACTER SET utf8;
USE PAS;

-- -----------------------------------------------------
-- Table PAS.`ZonaGeografica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`ZonaGeografica` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Edificio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Edificio` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Latitudine` DECIMAL(9,6) NOT NULL,
  `Longitudine` DECIMAL(9,6) NOT NULL,
  `ZonaGeografica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Edificio_ZonaGeografica1_idx` (`ZonaGeografica` ASC) VISIBLE,
  UNIQUE INDEX `SECONDARY_KEY` (`Latitudine` ASC, `Longitudine` ASC) VISIBLE,
  CONSTRAINT chk_coords CHECK (Latitudine between -90 and 90 and Longitudine between -180 and 180),
  CONSTRAINT `fk_Edificio_ZonaGeografica1`
    FOREIGN KEY (`ZonaGeografica`)
    REFERENCES PAS.`ZonaGeografica` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Piano`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Piano` (
  `Numero` INT NOT NULL,
  `Edificio` INT NOT NULL,
  PRIMARY KEY (`Numero`, `Edificio`),
  INDEX `fk_Piano_Edificio1_idx` (`Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Piano_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES PAS.`Edificio` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Vano`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Vano` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Piano` INT NOT NULL,
  `Edificio` INT NOT NULL,
  `Lunghezza` INT NOT NULL,
  `Larghezza` INT NOT NULL,
  `AltezzaMax` INT NULL,
  `Funzione` VARCHAR(42) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Vano_Piano1_idx` (`Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Vano_Piano1`
    FOREIGN KEY (`Piano` , `Edificio`)
    REFERENCES PAS.`Piano` (`Numero` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`ProgettoEdilizio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`ProgettoEdilizio` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CostoLavori_rid` DECIMAL(10,2) NULL,
  `Edificio_rid` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_ProgettoEdilizio_Edificio1_idx` (`Edificio_rid` ASC) VISIBLE,
  CONSTRAINT `fk_ProgettoEdilizio_Edificio1`
    FOREIGN KEY (`Edificio_rid`)
    REFERENCES PAS.`Edificio` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`StadioAvanzamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`StadioAvanzamento` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Progetto` INT NOT NULL,
  `DataInizio` DATE NOT NULL,
  `DataFineStimata` DATE NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_StadioAvanzamento_ProgettoEdilizio1_idx` (`Progetto` ASC) VISIBLE,
  CONSTRAINT `fk_StadioAvanzamento_ProgettoEdilizio1`
    FOREIGN KEY (`Progetto`)
    REFERENCES PAS.`ProgettoEdilizio` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`CapoCantiere`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`CapoCantiere` (
  `CodiceFiscale` CHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `MaxOperai` INT NOT NULL,
  PRIMARY KEY (`CodiceFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Lavoro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Lavoro` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CodiceStadio` INT NOT NULL,
  `DataInizio` DATETIME NOT NULL,
  `DataFine` DATETIME NULL,
  `Descrizione` VARCHAR(45) NOT NULL,
  `CapoCantiere` CHAR(16) NOT NULL,
  `CompensoCapoCantiere` DECIMAL(8,2) NOT NULL DEFAULT 0,
  `MaxOperaiInsieme` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Lavoro_StadioAvanzamento1_idx` (`CodiceStadio` ASC) VISIBLE,
  INDEX `fk_Lavoro_CapoCantiere1_idx` (`CapoCantiere` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoro_StadioAvanzamento1`
    FOREIGN KEY (`CodiceStadio`)
    REFERENCES PAS.`StadioAvanzamento` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lavoro_CapoCantiere1`
    FOREIGN KEY (`CapoCantiere`)
    REFERENCES PAS.`CapoCantiere` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Operaio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Operaio` (
  `CodiceFiscale` CHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `PagaOraria` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`CodiceFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Sensore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Sensore` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Vano` INT NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Soglia` FLOAT NULL,
  `x` INT NOT NULL,
  `y` INT NOT NULL,
  `z` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Sensore_Vano1_idx` (`Vano` ASC) VISIBLE,
  UNIQUE INDEX `SECONDARY_KEY` (`Vano` ASC, `Tipo` ASC, `x` ASC, `y` ASC, `z` ASC) VISIBLE,
  CONSTRAINT `fk_Sensore_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES PAS.`Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Misura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Misura` (
  `Timestamp` DATETIME(3) NOT NULL,
  `Sensore` INT NOT NULL,
  `xOppureUnico` FLOAT NOT NULL,
  `y` FLOAT NULL,
  `z` FLOAT NULL,
  PRIMARY KEY (`Sensore`, `Timestamp`),
  INDEX `fk_Misura_Sensore1_idx` (`Sensore` ASC) VISIBLE,
  CONSTRAINT `fk_Misura_Sensore1`
    FOREIGN KEY (`Sensore`)
    REFERENCES PAS.`Sensore` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Alert`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Alert` (
  `Timestamp` DATETIME(3) NOT NULL,
  `Sensore` INT NOT NULL,
  PRIMARY KEY (`Sensore`, `Timestamp`),
  CONSTRAINT `fk_Alert_Misura1`
    FOREIGN KEY (`Sensore` , `Timestamp`)
    REFERENCES PAS.`Misura` (`Sensore` , `Timestamp`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Muro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Muro` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `x0` INT NOT NULL,
  `y0` INT NOT NULL,
  `x1` INT NOT NULL,
  `y1` INT NOT NULL,
  `Vano1` INT NOT NULL,
  `Vano2` INT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Muro_Vano1_idx` (`Vano1` ASC) VISIBLE,
  INDEX `fk_Muro_Vano2_idx` (`Vano2` ASC) VISIBLE,
  UNIQUE INDEX `SECONDARY_KEY` (`x0` ASC, `y0` ASC, `x1` ASC, `y1` ASC, `Vano1` ASC) VISIBLE,
  CONSTRAINT `fk_Muro_Vano1`
    FOREIGN KEY (`Vano1`)
    REFERENCES PAS.`Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Muro_Vano2`
    FOREIGN KEY (`Vano2`)
    REFERENCES PAS.`Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Apertura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Apertura` (
  `Muro` INT NOT NULL,
  `Sopra` INT NOT NULL,
  `Sotto` INT NOT NULL,
  `Sinistra` INT NOT NULL,
  `Destra` INT NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Muro`, `Destra`, `Sinistra`, `Sopra`, `Sotto`),
  CONSTRAINT chk_altezza CHECK (sopra > sotto),
  CONSTRAINT `fk_Apertura_Muro1`
    FOREIGN KEY (`Muro`)
    REFERENCES PAS.`Muro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`RischioGeologico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`RischioGeologico` (
  `Zona` VARCHAR(45) NOT NULL,
  `Tipologia` VARCHAR(45) NOT NULL,
  `CoefficienteRischio` FLOAT NOT NULL,
  PRIMARY KEY (`Zona`, `Tipologia`),
  INDEX `fk_RischioGeologico_has_ZonaGeografica_ZonaGeografica1_idx` (`Zona` ASC) VISIBLE,
  CONSTRAINT chk_coeff CHECK (CoefficienteRischio >= 0),
  CONSTRAINT `fk_RischioGeologico_has_ZonaGeografica_ZonaGeografica1`
    FOREIGN KEY (`Zona`)
    REFERENCES PAS.`ZonaGeografica` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Calamita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Calamita` (
  `Data` DATETIME NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Latitudine` DECIMAL(9,6) NOT NULL,
  `Longitudine` DECIMAL(9,6) NOT NULL,
  `Intensita` FLOAT NOT NULL,
  PRIMARY KEY (`Data`, `Tipo`),
  CONSTRAINT chk_intensita CHECK (Intensita >= 0),
  CONSTRAINT chk_coords2 CHECK (Latitudine between -90 and 90 and Longitudine between -180 and 180))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Danneggiamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Danneggiamento` (
  `DataCalamita` DATETIME NOT NULL,
  `TipoCalamita` VARCHAR(45) NOT NULL,
  `ZonaGeografica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DataCalamita`, `TipoCalamita`, `ZonaGeografica`),
  INDEX `fk_Calamita_has_ZonaGeografica_ZonaGeografica1_idx` (`ZonaGeografica` ASC) VISIBLE,
  INDEX `fk_Calamita_has_ZonaGeografica_Calamita1_idx` (`DataCalamita` ASC, `TipoCalamita` ASC) VISIBLE,
  CONSTRAINT `fk_Calamita_has_ZonaGeografica_Calamita1`
    FOREIGN KEY (`DataCalamita` , `TipoCalamita`)
    REFERENCES PAS.`Calamita` (`Data` , `Tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Calamita_has_ZonaGeografica_ZonaGeografica1`
    FOREIGN KEY (`ZonaGeografica`)
    REFERENCES PAS.`ZonaGeografica` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Impiego`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Impiego` (
  `Inizio` DATETIME NOT NULL,
  `Operaio` CHAR(16) NOT NULL,
  `Lavoro` INT NOT NULL,
  PRIMARY KEY (`Inizio`, `Operaio`),
  INDEX `fk_FasciaOraria_has_Operaio_Operaio1_idx` (`Operaio` ASC) VISIBLE,
  INDEX `fk_Impiego_Lavoro1_idx` (`Lavoro` ASC) VISIBLE,
  CONSTRAINT `fk_FasciaOraria_has_Operaio_Operaio1`
    FOREIGN KEY (`Operaio`)
    REFERENCES PAS.`Operaio` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Impiego_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES PAS.`Lavoro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Materiale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Materiale` (
  `CodiceLotto` VARCHAR(20) NOT NULL,
  `QuantitaAcquistata` FLOAT NOT NULL,
  `CostoUnitario` DECIMAL(8,2) NULL,
  `DataAcquisto` DATE NULL,
  `Fornitore` VARCHAR(45) NULL,
  `QuantitaRimasta_rid` FLOAT NULL,
  `Copertura` TINYINT NOT NULL DEFAULT 0,
  `Pavimentabile` TINYINT NOT NULL DEFAULT 0,
  `Portante` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`CodiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`UtilizzoMateriale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`UtilizzoMateriale` (
  `Materiale` VARCHAR(20) NOT NULL,
  `Lavoro` INT NOT NULL,
  `Quantita` FLOAT NOT NULL,
  PRIMARY KEY (`Materiale`, `Lavoro`),
  INDEX `fk_Materiale_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC) VISIBLE,
  INDEX `fk_Materiale_has_Lavoro_Materiale1_idx` (`Materiale` ASC) VISIBLE,
  CONSTRAINT `fk_Materiale_has_Lavoro_Materiale1`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materiale_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES PAS.`Lavoro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Mattone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Mattone` (
  `Materiale` VARCHAR(20) NOT NULL,
  `Alveolatura` VARCHAR(45) NOT NULL,
  `Composizione` VARCHAR(45) NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `z` FLOAT NOT NULL,
  PRIMARY KEY (`Materiale`),
  CONSTRAINT `fk_MaterialeGenerico_Materiale1`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`MaterialeGenerico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`MaterialeGenerico` (
  `Materiale` VARCHAR(20) NOT NULL,
  `Descrizione` VARCHAR(45) NOT NULL,
  `Funzione` VARCHAR(45) NULL,
  `x` FLOAT NULL,
  `y` FLOAT NULL,
  `z` FLOAT NULL,
  PRIMARY KEY (`Materiale`),
  CONSTRAINT `fk_MaterialeGenerico_Materiale10`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Intonaco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Intonaco` (
  `Materiale` VARCHAR(20) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Colore` VARCHAR(45) NULL,
  PRIMARY KEY (`Materiale`),
  CONSTRAINT `fk_MaterialeGenerico_Materiale11`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Pietra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Pietra` (
  `Materiale` VARCHAR(20) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `z` FLOAT NOT NULL,
  PRIMARY KEY (`Materiale`),
  CONSTRAINT `fk_MaterialeGenerico_Materiale110`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Parquet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Parquet` (
  `Materiale` VARCHAR(20) NOT NULL,
  `TipoLegno` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Materiale`),
  CONSTRAINT `fk_MaterialeGenerico_Materiale1100`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`Piastrella`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`Piastrella` (
  `Materiale` VARCHAR(20) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Disegno` VARCHAR(45) NOT NULL,
  `Dimensione` FLOAT NOT NULL,
  `NumeroLati` INT NOT NULL,
  `Fuga` FLOAT NOT NULL,
  PRIMARY KEY (`Materiale`),
  CONSTRAINT chk_piastrella CHECK (NumeroLati >= 3 and Fuga >= 0 and Dimensione >= 0),
  CONSTRAINT `fk_MaterialeGenerico_Materiale11000`
    FOREIGN KEY (`Materiale`)
    REFERENCES PAS.`Materiale` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`LavoroSuEdificio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`LavoroSuEdificio` (
  `Lavoro` INT NOT NULL,
  `Edificio` INT NOT NULL,
  PRIMARY KEY (`Lavoro`),
  INDEX `fk_LavoroSuEdificio_Edificio1_idx` (`Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_LavoroSuEdificio_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES PAS.`Lavoro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LavoroSuEdificio_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES PAS.`Edificio` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`LavoroSuVano`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`LavoroSuVano` (
  `Lavoro` INT NOT NULL,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`Lavoro`),
  INDEX `fk_LavoroSuVano_Vano1_idx` (`Vano` ASC) VISIBLE,
  CONSTRAINT `fk_LavoroSuVano_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES PAS.`Lavoro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LavoroSuVano_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES PAS.`Vano` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PAS.`LavoroSuMuro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PAS.`LavoroSuMuro` (
  `Lavoro` INT NOT NULL,
  `Muro` INT NOT NULL,
  `Spessore` DECIMAL(3,2) NULL,
  `Lato` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Lavoro`),
  INDEX `fk_LavoroSuMuro_Muro1_idx` (`Muro` ASC) VISIBLE,
  CONSTRAINT chk_spessore CHECK (spessore is null or spessore >= 0),
  CONSTRAINT chk_lato CHECK (lato between 0 and 3),
  CONSTRAINT `fk_LavoroSuMuro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES PAS.`Lavoro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LavoroSuMuro_Muro1`
    FOREIGN KEY (`Muro`)
    REFERENCES PAS.`Muro` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
