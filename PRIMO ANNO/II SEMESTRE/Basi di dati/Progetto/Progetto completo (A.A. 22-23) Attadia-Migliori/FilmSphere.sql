DROP DATABASE IF EXISTS filmsphere;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema FilmSphere
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema FilmSphere
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `FilmSphere` DEFAULT CHARACTER SET utf8 ;
USE `FilmSphere` ;

-- -----------------------------------------------------
-- Table `FilmSphere`.`Paesi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Paesi` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Film` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Descrizione` VARCHAR(350) NULL,
  `Titolo` VARCHAR(100) NOT NULL,
  `AnnoDiProduzione` INT NOT NULL,
  `PunteggioCritica` FLOAT NOT NULL DEFAULT 0,
  `PunteggioPubblico` FLOAT NOT NULL DEFAULT 0,
  `PaeseProduzione` VARCHAR(45) NOT NULL,
  `Durata` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Film_Paese1_idx` (`PaeseProduzione` ASC) VISIBLE,
  CONSTRAINT `fk_Film_Paese`
    FOREIGN KEY (`PaeseProduzione`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Persone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Persone` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NULL,
  `Nazionalità` VARCHAR(45) NOT NULL,
  `Popolarità` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`),
  INDEX `fk_Persona_Paese1_idx` (`Nazionalità` ASC) VISIBLE,
  CONSTRAINT `fk_Persona_Paese`
    FOREIGN KEY (`Nazionalità`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Generi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Generi` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`FormatiVideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`FormatiVideo` (
  `Codec` VARCHAR(45) NOT NULL,
  `Versione` VARCHAR(45) NOT NULL,
  `Bitrate` INT NOT NULL,
  `Risoluzione` VARCHAR(45) NOT NULL,
  `Qualità` VARCHAR(45) NOT NULL,
  `AspectRatio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codec`, `Versione`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`FileVideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`FileVideo` (
  `Nome` VARCHAR(45) NOT NULL,
  `Dimensione` DOUBLE NOT NULL,
  `FormatoVideo` VARCHAR(45) NOT NULL,
  `VersioneVideo` VARCHAR(45) NOT NULL,
  `Film` INT NOT NULL,
  PRIMARY KEY (`Nome`),
  INDEX `fk_File__FormatoVideo1_idx` (`FormatoVideo` ASC, `VersioneVideo` ASC) VISIBLE,
  INDEX `fk_FileVideo_Film1_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_File__FormatoVideo`
    FOREIGN KEY (`FormatoVideo` , `VersioneVideo`)
    REFERENCES `FilmSphere`.`FormatiVideo` (`Codec` , `Versione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FileVideo_Film1`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`FormatiAudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`FormatiAudio` (
  `Codec` VARCHAR(45) NOT NULL,
  `Versione` VARCHAR(45) NOT NULL,
  `Bitrate` INT NOT NULL,
  `Frequenza` INT NOT NULL,
  PRIMARY KEY (`Codec`, `Versione`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Server_`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Server_` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Bandwidth` INT NOT NULL,
  `CapacitàMassima` INT NOT NULL,
  `Sede` VARCHAR(45) NOT NULL,
  `Carico` DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  INDEX `fk_Server_Paese1_idx` (`Sede` ASC) VISIBLE,
  CONSTRAINT `fk_Server_Paese`
    FOREIGN KEY (`Sede`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Abbonamenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Abbonamenti` (
  `Nome` VARCHAR(45) NOT NULL,
  `Tariffa` FLOAT NOT NULL,
  `MassimoOre` INT NULL,
  `GBMensili` INT NULL,
  `Durata` INT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Utenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Utenti` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Nickname` VARCHAR(45) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Password_` VARCHAR(200) NOT NULL,
  `Verificato` TINYINT NOT NULL,
  `DataFine` DATE NULL,
  `Abbonamento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  INDEX `fk_Utente_Abbonamento1_idx` (`Abbonamento` ASC) INVISIBLE,
  UNIQUE INDEX `Nickname_UNIQUE` (`Nickname` ASC) INVISIBLE,
  INDEX `NicknameEmail_idx` (`Nickname` ASC, `Email` ASC) COMMENT 'Index creato per ottimizzare le query che richiedono un full scan della tabella.' VISIBLE,
  CONSTRAINT `fk_Utente_Abbonamento`
    FOREIGN KEY (`Abbonamento`)
    REFERENCES `FilmSphere`.`Abbonamenti` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`CarteDiCredito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`CarteDiCredito` (
  `Numero` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `CVC` VARCHAR(3) NOT NULL,
  `Utente` INT NOT NULL,
  `AnnoScadenza` INT NOT NULL,
  `MeseScadenza` INT NOT NULL,
  PRIMARY KEY (`Numero`),
  INDEX `fk_Carta Di Credito_Utente1_idx` (`Utente` ASC) VISIBLE,
  INDEX `NumeroUtente_IDX` (`Numero` ASC, `Utente` ASC) VISIBLE,
  CONSTRAINT `fk_Carta Di Credito_Utente`
    FOREIGN KEY (`Utente`)
    REFERENCES `FilmSphere`.`Utenti` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Recensioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Recensioni` (
  `Voto` INT NOT NULL,
  `Commento` VARCHAR(350) NULL,
  `Data_` DATE NOT NULL,
  `Utente` INT NOT NULL,
  `Film` INT NOT NULL,
  PRIMARY KEY (`Utente`, `Film`),
  INDEX `fk_Recensione_Utente1_idx` (`Utente` ASC) VISIBLE,
  INDEX `fk_Recensione_Film1_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_Recensione_Utente`
    FOREIGN KEY (`Utente`)
    REFERENCES `FilmSphere`.`Utenti` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recensione_Film`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Fatture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Fatture` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Data_` DATE NOT NULL,
  `Totale` FLOAT NOT NULL,
  `PagamentoCarta` VARCHAR(16) NOT NULL,
  `Utente` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Fattura_Carta Di Credito1_idx` (`PagamentoCarta` ASC) VISIBLE,
  INDEX `fk_Fattura_Utente1_idx` (`Utente` ASC) VISIBLE,
  CONSTRAINT `fk_Fattura_Carta Di Credito`
    FOREIGN KEY (`PagamentoCarta`)
    REFERENCES `FilmSphere`.`CarteDiCredito` (`Numero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fattura_Utente`
    FOREIGN KEY (`Utente`)
    REFERENCES `FilmSphere`.`Utenti` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Appartenenza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Appartenenza` (
  `Film` INT NOT NULL,
  `Genere` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Film`, `Genere`),
  INDEX `fk_Film_has_Genere_Genere1_idx` (`Genere` ASC) VISIBLE,
  INDEX `fk_Film_has_Genere_Film_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Genere_Film`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Genere_Genere1`
    FOREIGN KEY (`Genere`)
    REFERENCES `FilmSphere`.`Generi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Premi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Premi` (
  `Nome` VARCHAR(45) NOT NULL,
  `Edizione` VARCHAR(45) NOT NULL,
  `Film` INT NOT NULL,
  `Persona` INT NULL,
  PRIMARY KEY (`Nome`, `Edizione`),
  INDEX `fk_Premio_Film1_idx` (`Film` ASC) VISIBLE,
  INDEX `fk_Premio_Persona1_idx` (`Persona` ASC) VISIBLE,
  CONSTRAINT `fk_Premio_Film`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Premio_Persona`
    FOREIGN KEY (`Persona`)
    REFERENCES `FilmSphere`.`Persone` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Dispositivi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Dispositivi` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Connessioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Connessioni` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Utente` INT NOT NULL,
  `Inizio` DATETIME NOT NULL,
  `Fine` DATETIME NULL,
  `Paese` VARCHAR(45) NOT NULL,
  `Dispositivo` INT NOT NULL,
  INDEX `fk_Connessione_Utente1_idx` (`Utente` ASC) INVISIBLE,
  PRIMARY KEY (`ID`),
  INDEX `fk_Connessione_Inizio_idx` (`Inizio` ASC) INVISIBLE,
  INDEX `fk_Connessione_Paese1_idx` (`Paese` ASC) VISIBLE,
  INDEX `fk_Connessioni_Dispositivi1_idx` (`Dispositivo` ASC) VISIBLE,
  CONSTRAINT `fk_Connessione_Utente`
    FOREIGN KEY (`Utente`)
    REFERENCES `FilmSphere`.`Utenti` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Connessione_Paese`
    FOREIGN KEY (`Paese`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Connessioni_Dispositivi`
    FOREIGN KEY (`Dispositivo`)
    REFERENCES `FilmSphere`.`Dispositivi` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`RestAbbonamenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`RestAbbonamenti` (
  `Abbonamento` VARCHAR(45) NOT NULL,
  `Paese` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Abbonamento`, `Paese`),
  INDEX `fk_Abbonamento_has_Paese_Paese1_idx` (`Paese` ASC) VISIBLE,
  INDEX `fk_Abbonamento_has_Paese_Abbonamento1_idx` (`Abbonamento` ASC) VISIBLE,
  CONSTRAINT `fk_Abbonamento_has_Paese_Abbonamento`
    FOREIGN KEY (`Abbonamento`)
    REFERENCES `FilmSphere`.`Abbonamenti` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Abbonamento_has_Paese_Paese`
    FOREIGN KEY (`Paese`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`ArcFileVideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`ArcFileVideo` (
  `FileVideo` VARCHAR(45) NOT NULL,
  `Server_` INT NOT NULL,
  PRIMARY KEY (`FileVideo`, `Server_`),
  INDEX `fk_File_has_Server_Server1_idx` (`Server_` ASC) VISIBLE,
  INDEX `fk_File_has_Server_File1_idx` (`FileVideo` ASC) VISIBLE,
  CONSTRAINT `fk_File_has_Server_File`
    FOREIGN KEY (`FileVideo`)
    REFERENCES `FilmSphere`.`FileVideo` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_File_has_Server_Server`
    FOREIGN KEY (`Server_`)
    REFERENCES `FilmSphere`.`Server_` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Interpretazioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Interpretazioni` (
  `Film` INT NOT NULL,
  `Attore` INT NOT NULL,
  PRIMARY KEY (`Film`, `Attore`),
  INDEX `fk_Film_has_Persona_Persona1_idx` (`Attore` ASC) VISIBLE,
  INDEX `fk_Film_has_Persona_Film1_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Persona_Film`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Persona_Persona`
    FOREIGN KEY (`Attore`)
    REFERENCES `FilmSphere`.`Persone` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Lingue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Lingue` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Proiezioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Proiezioni` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `MarcaTemporale` DATETIME NOT NULL,
  `Server_` INT NOT NULL,
  `Film` INT NOT NULL,
  `Connessione` INT NOT NULL,
  PRIMARY KEY (`ID`, `Connessione`),
  INDEX `fk_Proiezione_Server1_idx` (`Server_` ASC) VISIBLE,
  INDEX `fk_Proiezione_Film1_idx` (`Film` ASC) INVISIBLE,
  INDEX `fk_Proiezione_Connessioni_idx` (`Connessione` ASC) VISIBLE,
  CONSTRAINT `fk_Proiezione_Server`
    FOREIGN KEY (`Server_`)
    REFERENCES `FilmSphere`.`Server_` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proiezione_Film`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proiezione_Connessioni`
    FOREIGN KEY (`Connessione`)
    REFERENCES `FilmSphere`.`Connessioni` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`Regie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`Regie` (
  `Film` INT NOT NULL,
  `Regista` INT NOT NULL,
  PRIMARY KEY (`Film`, `Regista`),
  INDEX `fk_Film_has_Persona_Persona2_idx` (`Regista` ASC) VISIBLE,
  INDEX `fk_Film_has_Persona_Film2_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Persona_Film0`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Persona_Persona0`
    FOREIGN KEY (`Regista`)
    REFERENCES `FilmSphere`.`Persone` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`RestFormatiVideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`RestFormatiVideo` (
  `Codec` VARCHAR(45) NOT NULL,
  `Versione` VARCHAR(45) NOT NULL,
  `Paese` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codec`, `Versione`, `Paese`),
  INDEX `fk_FormatoVideo_has_Paese_Paese1_idx` (`Paese` ASC) VISIBLE,
  INDEX `fk_FormatoVideo_has_Paese_FormatoVideo1_idx` (`Codec` ASC, `Versione` ASC) VISIBLE,
  CONSTRAINT `fk_FormatoVideo_has_Paese_FormatoVideo1`
    FOREIGN KEY (`Codec` , `Versione`)
    REFERENCES `FilmSphere`.`FormatiVideo` (`Codec` , `Versione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FormatoVideo_has_Paese_Paese1`
    FOREIGN KEY (`Paese`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`RestFormatiAudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`RestFormatiAudio` (
  `Codec` VARCHAR(45) NOT NULL,
  `Versione` VARCHAR(45) NOT NULL,
  `Paese` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codec`, `Versione`, `Paese`),
  INDEX `fk_FormatoAudio_has_Paese_Paese1_idx` (`Paese` ASC) VISIBLE,
  INDEX `fk_FormatoAudio_has_Paese_FormatoAudio1_idx` (`Codec` ASC, `Versione` ASC) VISIBLE,
  CONSTRAINT `fk_FormatoAudio_has_Paese_FormatoAudio1`
    FOREIGN KEY (`Codec` , `Versione`)
    REFERENCES `FilmSphere`.`FormatiAudio` (`Codec` , `Versione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FormatoAudio_has_Paese_Paese1`
    FOREIGN KEY (`Paese`)
    REFERENCES `FilmSphere`.`Paesi` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`FileSottotitoli`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`FileSottotitoli` (
  `Nome` VARCHAR(45) NOT NULL,
  `Dimensione` DOUBLE NOT NULL,
  `Lingua` VARCHAR(45) NOT NULL,
  `Film` INT NOT NULL,
  PRIMARY KEY (`Nome`),
  INDEX `fk_File__Lingua1_idx` (`Lingua` ASC) VISIBLE,
  INDEX `fk_FileSottotitoli_Film1_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_File__Lingua10`
    FOREIGN KEY (`Lingua`)
    REFERENCES `FilmSphere`.`Lingue` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FileSottotitoli_Film1`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`FileAudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`FileAudio` (
  `Nome` VARCHAR(45) NOT NULL,
  `Dimensione` DOUBLE NOT NULL,
  `Lingua` VARCHAR(45) NOT NULL,
  `FormatoAudio` VARCHAR(45) NOT NULL,
  `VersioneAudio` VARCHAR(45) NOT NULL,
  `Film` INT NOT NULL,
  PRIMARY KEY (`Nome`),
  INDEX `fk_File__Lingua1_idx` (`Lingua` ASC) VISIBLE,
  INDEX `fk_File__FormatoAudio1_idx` (`FormatoAudio` ASC, `VersioneAudio` ASC) VISIBLE,
  INDEX `fk_FileAudio_Film1_idx` (`Film` ASC) VISIBLE,
  CONSTRAINT `fk_File__Lingua11`
    FOREIGN KEY (`Lingua`)
    REFERENCES `FilmSphere`.`Lingue` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_File__FormatoAudio11`
    FOREIGN KEY (`FormatoAudio` , `VersioneAudio`)
    REFERENCES `FilmSphere`.`FormatiAudio` (`Codec` , `Versione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FileAudio_Film1`
    FOREIGN KEY (`Film`)
    REFERENCES `FilmSphere`.`Film` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`ArcFileSottotitoli`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`ArcFileSottotitoli` (
  `FileSottotitoli` VARCHAR(45) NOT NULL,
  `Server_` INT NOT NULL,
  PRIMARY KEY (`FileSottotitoli`, `Server_`),
  INDEX `fk_FileSottotitoli_has_Server__Server_1_idx` (`Server_` ASC) VISIBLE,
  INDEX `fk_FileSottotitoli_has_Server__FileSottotitoli1_idx` (`FileSottotitoli` ASC) VISIBLE,
  CONSTRAINT `fk_FileSottotitoli_has_Server__FileSottotitoli`
    FOREIGN KEY (`FileSottotitoli`)
    REFERENCES `FilmSphere`.`FileSottotitoli` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FileSottotitoli_has_Server__Server_`
    FOREIGN KEY (`Server_`)
    REFERENCES `FilmSphere`.`Server_` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `FilmSphere`.`ArcFileAudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FilmSphere`.`ArcFileAudio` (
  `FileAudio` VARCHAR(45) NOT NULL,
  `Server_` INT NOT NULL,
  PRIMARY KEY (`FileAudio`, `Server_`),
  INDEX `fk_FileAudio_has_Server__Server_1_idx` (`Server_` ASC) VISIBLE,
  INDEX `fk_FileAudio_has_Server__FileAudio1_idx` (`FileAudio` ASC) VISIBLE,
  CONSTRAINT `fk_FileAudio_has_Server__FileAudio`
    FOREIGN KEY (`FileAudio`)
    REFERENCES `FilmSphere`.`FileAudio` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FileAudio_has_Server__Server_`
    FOREIGN KEY (`Server_`)
    REFERENCES `FilmSphere`.`Server_` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
