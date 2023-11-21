
-- creazione schema
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `Critico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Critico` (
  `Id_Critico` INT UNSIGNED NOT NULL,
  `Pseudonimo` VARCHAR(200) NULL,
  `Nome_Critico` VARCHAR(100) NOT NULL,
  `Cognome_Critico` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id_Critico`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Premio_Regista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premio_Regista` (
  `Nome` VARCHAR(200) NOT NULL,
  `Istituzione` VARCHAR(200) NOT NULL,
  `Anno_Premiazione_Regista` INT NOT NULL,
  `Peso` DOUBLE UNSIGNED NULL,
  `Paese` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Nome`, `Istituzione`, `Anno_Premiazione_Regista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Premio_Attore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premio_Attore` (
  `Nome` VARCHAR(200) NOT NULL,
  `Istituzione` VARCHAR(200) NOT NULL,
  `Anno_Premiazione_Attore` INT NOT NULL,
  `Peso` DOUBLE NOT NULL,
  `Paese` VARCHAR(100) NULL,
  PRIMARY KEY (`Nome`, `Istituzione`, `Anno_Premiazione_Attore`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Premio_Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premio_Film` (
  `Nome` VARCHAR(200) NOT NULL,
  `Istituzione` VARCHAR(200) NOT NULL,
  `Anno_Premiazione_Film` INT NOT NULL,
  `Peso` DOUBLE NOT NULL,
  `Paese` VARCHAR(100) NULL,
  PRIMARY KEY (`Nome`, `Istituzione`, `Anno_Premiazione_Film`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Regista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Regista` (
  `Id_Artista` INT UNSIGNED NOT NULL,
  `Nome` VARCHAR(100) NOT NULL,
  `Cognome` VARCHAR(100) NOT NULL,
  `Pseudonimo` VARCHAR(200) NULL,
  `Quanti_Premi` INT UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`Id_Artista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Attore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Attore` (
  `Id_Artista` INT UNSIGNED NOT NULL,
  `Nome` VARCHAR(100) NOT NULL,
  `Cognome` VARCHAR(100) NOT NULL,
  `Pseudonimo` VARCHAR(200) NULL,
  `Quanti_Premi` INT UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`Id_Artista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Film` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Anno_Produzione` INT UNSIGNED NOT NULL,
  `Titolo` TEXT NOT NULL,
  `Durata` INT UNSIGNED NOT NULL,
  `Paese_Produzione` VARCHAR(100) NOT NULL,
  `Quante_Lingue` INT ZEROFILL UNSIGNED NOT NULL,
  `Genere` VARCHAR(100) NOT NULL,
  `Quanti_Premi` INT ZEROFILL UNSIGNED NOT NULL,
  `Descrizione` TEXT NOT NULL,
  PRIMARY KEY (`Id_Film`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Voto_Critico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Voto_Critico` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Id_Critico` INT UNSIGNED NOT NULL,
  `Valutazione` DOUBLE NOT NULL,
  `Recensione` TEXT NOT NULL,
  PRIMARY KEY (`Id_Film`, `Id_Critico`),
  INDEX `fk_Film_has_Critico_Critico1_idx` (`Id_Critico` ASC) VISIBLE,
  INDEX `fk_Film_has_Critico_Film1_idx` (`Id_Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Critico_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Critico_Critico1`
    FOREIGN KEY (`Id_Critico`)
    REFERENCES `Critico` (`Id_Critico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Direzione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Direzione` (
  `Id_Artista` INT UNSIGNED NOT NULL,
  `Id_Film` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Id_Artista`, `Id_Film`),
  INDEX `fk_Regista_has_Film_Film1_idx` (`Id_Film` ASC) VISIBLE,
  INDEX `fk_Regista_has_Film_Regista1_idx` (`Id_Artista` ASC) VISIBLE,
  CONSTRAINT `fk_Regista_has_Film_Regista1`
    FOREIGN KEY (`Id_Artista`)
    REFERENCES `Regista` (`Id_Artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Regista_has_Film_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Interpretazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Interpretazione` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Id_Artista` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Id_Film`, `Id_Artista`),
  INDEX `fk_Film_has_Attore_Attore2_idx` (`Id_Artista` ASC) VISIBLE,
  INDEX `fk_Film_has_Attore_Film2_idx` (`Id_Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Attore_Film2`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Attore_Attore2`
    FOREIGN KEY (`Id_Artista`)
    REFERENCES `Attore` (`Id_Artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Doppiaggio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Doppiaggio` (
  `Lingua` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Lingua`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sottotitolo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Sottotitolo` (
  `Lingua` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Lingua`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Doppiaggio_Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Doppiaggio_Film` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Lingua` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id_Film`, `Lingua`),
  INDEX `fk_Film_has_Doppiaggio_Doppiaggio1_idx` (`Lingua` ASC) VISIBLE,
  INDEX `fk_Film_has_Doppiaggio_Film1_idx` (`Id_Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Doppiaggio_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Doppiaggio_Doppiaggio1`
    FOREIGN KEY (`Lingua`)
    REFERENCES `Doppiaggio` (`Lingua`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Disposizione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Disposizione` (
  `Lingua` VARCHAR(100) NOT NULL,
  `Id_Film` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Lingua`, `Id_Film`),
  INDEX `fk_Sottotitolo_has_Film_Film1_idx` (`Id_Film` ASC) VISIBLE,
  INDEX `fk_Sottotitolo_has_Film_Sottotitolo1_idx` (`Lingua` ASC) VISIBLE,
  CONSTRAINT `fk_Sottotitolo_has_Film_Sottotitolo1`
    FOREIGN KEY (`Lingua`)
    REFERENCES `Sottotitolo` (`Lingua`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sottotitolo_has_Film_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Formato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Formato` (
  `Id_Formato` INT UNSIGNED NOT NULL,
  `Data_Aggiornamento` TIMESTAMP NOT NULL,
  `Bitrate` DOUBLE UNSIGNED NOT NULL,
  `Tipo_Formato` VARCHAR(100) NOT NULL,
  `Durata` INT UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`Id_Formato`, `Data_Aggiornamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Codec`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Codec` (
  `File_Codec` VARCHAR(100) NOT NULL,
  `Specifiche` TEXT NOT NULL,
  PRIMARY KEY (`File_Codec`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aggiornamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Aggiornamento` (
  `Id_Formato` INT UNSIGNED NOT NULL,
  `Data_Aggiornamento` TIMESTAMP NOT NULL,
  `File_Codec` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id_Formato`, `Data_Aggiornamento`, `File_Codec`),
  INDEX `fk_Formato_has_Codec_Codec1_idx` (`File_Codec` ASC) VISIBLE,
  INDEX `fk_Formato_has_Codec_Formato1_idx` (`Id_Formato` ASC, `Data_Aggiornamento` ASC) VISIBLE,
  CONSTRAINT `fk_Formato_has_Codec_Formato1`
    FOREIGN KEY (`Id_Formato` , `Data_Aggiornamento`)
    REFERENCES `Formato` (`Id_Formato` , `Data_Aggiornamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Formato_has_Codec_Codec1`
    FOREIGN KEY (`File_Codec`)
    REFERENCES `Codec` (`File_Codec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Elenco_Stato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Elenco_Stato` (
  `Stato` VARCHAR(100) NOT NULL,
  `Federale` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`Stato`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ammissione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ammissione` (
  `Id_Formato` INT UNSIGNED NOT NULL,
  `Data_Aggiornamento` TIMESTAMP NOT NULL,
  `Stato` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id_Formato`, `Data_Aggiornamento`, `Stato`),
  INDEX `fk_Formato_has_Elenco_Stato_Elenco_Stato1_idx` (`Stato` ASC) VISIBLE,
  INDEX `fk_Formato_has_Elenco_Stato_Formato1_idx` (`Id_Formato` ASC, `Data_Aggiornamento` ASC) VISIBLE,
  CONSTRAINT `fk_Formato_has_Elenco_Stato_Formato1`
    FOREIGN KEY (`Id_Formato` , `Data_Aggiornamento`)
    REFERENCES `Formato` (`Id_Formato` , `Data_Aggiornamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Formato_has_Elenco_Stato_Elenco_Stato1`
    FOREIGN KEY (`Stato`)
    REFERENCES `Elenco_Stato` (`Stato`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Formato_Video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Formato_Video` (
  `Qualita_Video` DOUBLE UNSIGNED NOT NULL,
  `Risoluzione` INT UNSIGNED NOT NULL,
  `Larghezza` DOUBLE UNSIGNED NOT NULL,
  `Lunghezza` DOUBLE UNSIGNED NOT NULL,
  `Id_Formato` INT UNSIGNED NOT NULL,
  `Data_Aggiornamento` TIMESTAMP NOT NULL,
  INDEX `fk_Formato_Video_Formato1_idx` (`Id_Formato` ASC, `Data_Aggiornamento` ASC) VISIBLE,
  PRIMARY KEY (`Id_Formato`, `Data_Aggiornamento`),
  CONSTRAINT `fk_Formato_Video_Formato1`
    FOREIGN KEY (`Id_Formato` , `Data_Aggiornamento`)
    REFERENCES `Formato` (`Id_Formato` , `Data_Aggiornamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Formato_Audio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Formato_Audio` (
  `Qualita_Audio` DOUBLE UNSIGNED NOT NULL,
  `Id_Formato` INT UNSIGNED NOT NULL,
  `Data_Aggiornamento` TIMESTAMP NOT NULL,
  INDEX `fk_Audio_Formato1_idx` (`Id_Formato` ASC, `Data_Aggiornamento` ASC) VISIBLE,
  PRIMARY KEY (`Id_Formato`, `Data_Aggiornamento`),
  CONSTRAINT `fk_Audio_Formato1`
    FOREIGN KEY (`Id_Formato` , `Data_Aggiornamento`)
    REFERENCES `Formato` (`Id_Formato` , `Data_Aggiornamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Utente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Utente` (
  `Id_Cliente` INT UNSIGNED NOT NULL,
  `Nome` VARCHAR(100) NOT NULL,
  `Cognome` VARCHAR(100) NOT NULL,
  `Password` VARCHAR(200) NOT NULL,
  `Email` VARCHAR(200) NOT NULL,
  `Quanti_Dispositivi` INT UNSIGNED ZEROFILL NOT NULL,
  `Quanti_Ritardi` INT UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`Id_Cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Voto_Utente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Voto_Utente` (
  `Id_Cliente` INT UNSIGNED NOT NULL,
  `Id_Film` INT UNSIGNED NOT NULL,
  `Recensione_Cliente` TEXT NULL,
  `Valutazione_Cliente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Id_Cliente`, `Id_Film`),
  INDEX `fk_Utente_has_Film_Film1_idx` (`Id_Film` ASC) VISIBLE,
  INDEX `fk_Utente_has_Film_Utente1_idx` (`Id_Cliente` ASC) VISIBLE,
  CONSTRAINT `fk_Utente_has_Film_Utente1`
    FOREIGN KEY (`Id_Cliente`)
    REFERENCES `Utente` (`Id_Cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Utente_has_Film_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Posizione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Posizione` (
  `Longitudine` DOUBLE UNSIGNED NOT NULL,
  `Latitudine` DOUBLE UNSIGNED NOT NULL,
  `Stato` VARCHAR(100) NOT NULL,
  `Regione` VARCHAR(100) NOT NULL,
  `Provincia` VARCHAR(100) NOT NULL,
  `Comune` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Longitudine`, `Latitudine`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Dispositivo` (
  `IP` VARCHAR(21) NOT NULL,
  `Tipo_Dispositivo` VARCHAR(80) NOT NULL,
  `Longitudine` DOUBLE UNSIGNED NOT NULL,
  `Latitudine` DOUBLE UNSIGNED NOT NULL,
  `Inizio_Connessione` TIMESTAMP NOT NULL,
  `Fine_Connesione` TIMESTAMP NOT NULL,
  PRIMARY KEY (`IP`, `Inizio_Connessione`, `Fine_Connesione`),
  INDEX `fk_Dispositivo_Posizione1_idx` (`Longitudine` ASC, `Latitudine` ASC) VISIBLE,
  CONSTRAINT `fk_Dispositivo_Posizione1`
    FOREIGN KEY (`Longitudine` , `Latitudine`)
    REFERENCES `Posizione` (`Longitudine` , `Latitudine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Carta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Carta` (
  `CVV` CHAR(3) NOT NULL,
  `PAN` VARCHAR(19) NOT NULL,
  `Nome_Titolare` VARCHAR(100) NOT NULL,
  `Cognome_Titolare` VARCHAR(100) NOT NULL,
  `Circuito_Carta` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`CVV`, `PAN`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Fattura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fattura` (
  `Numero_Fattura` VARCHAR(45) NOT NULL,
  `Importo` DOUBLE NOT NULL,
  `Scadenza` DATE NOT NULL,
  `Data_Pagamento` DATE NULL,
  `CVV` CHAR(3) NOT NULL,
  `PAN` VARCHAR(19) NOT NULL,
  PRIMARY KEY (`Numero_Fattura`),
  INDEX `fk_Fattura_Carta1_idx` (`CVV` ASC, `PAN` ASC) VISIBLE,
  CONSTRAINT `fk_Fattura_Carta1`
    FOREIGN KEY (`CVV` , `PAN`)
    REFERENCES `Carta` (`CVV` , `PAN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Abbonamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Abbonamento` (
  `Durata_Abbonamento` INT UNSIGNED NOT NULL,
  `Tipo` VARCHAR(100) NOT NULL,
  `Caratterizzazione` TEXT NOT NULL,
  `Stato` TINYINT UNSIGNED NOT NULL,
  `Eta` TINYINT UNSIGNED NOT NULL,
  `Ore_Massime` INT UNSIGNED NULL,
  `Numero_Fattura` VARCHAR(45) NOT NULL,
  `Id_Cliente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Numero_Fattura`),
  INDEX `fk_Abbonamento_Utente1_idx` (`Id_Cliente` ASC) VISIBLE,
  CONSTRAINT `fk_Abbonamento_Fattura1`
    FOREIGN KEY (`Numero_Fattura`)
    REFERENCES `Fattura` (`Numero_Fattura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Abbonamento_Utente1`
    FOREIGN KEY (`Id_Cliente`)
    REFERENCES `Utente` (`Id_Cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Premiazione_Regista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premiazione_Regista` (
  `Nome` VARCHAR(200) NOT NULL,
  `Istituzione` VARCHAR(200) NOT NULL,
  `Anno_Premiazione_Regista` INT NOT NULL,
  `Id_Artista` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Nome`, `Istituzione`, `Anno_Premiazione_Regista`, `Id_Artista`),
  INDEX `fk_Premio_Regista_has_Regista_Regista1_idx` (`Id_Artista` ASC) VISIBLE,
  INDEX `fk_Premio_Regista_has_Regista_Premio_Regista1_idx` (`Nome` ASC, `Istituzione` ASC, `Anno_Premiazione_Regista` ASC) VISIBLE,
  CONSTRAINT `fk_Premio_Regista_has_Regista_Premio_Regista1`
    FOREIGN KEY (`Nome` , `Istituzione` , `Anno_Premiazione_Regista`)
    REFERENCES `Premio_Regista` (`Nome` , `Istituzione` , `Anno_Premiazione_Regista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Premio_Regista_has_Regista_Regista1`
    FOREIGN KEY (`Id_Artista`)
    REFERENCES `Regista` (`Id_Artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Premiazione_Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premiazione_Film` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Nome` VARCHAR(200) NOT NULL,
  `Istituzione` VARCHAR(200) NOT NULL,
  `Anno_Premiazione_Film` INT NOT NULL,
  PRIMARY KEY (`Id_Film`, `Nome`, `Istituzione`, `Anno_Premiazione_Film`),
  INDEX `fk_Film_has_Premio_Film_Premio_Film1_idx` (`Nome` ASC, `Istituzione` ASC, `Anno_Premiazione_Film` ASC) VISIBLE,
  INDEX `fk_Film_has_Premio_Film_Film1_idx` (`Id_Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Premio_Film_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Premio_Film_Premio_Film1`
    FOREIGN KEY (`Nome` , `Istituzione` , `Anno_Premiazione_Film`)
    REFERENCES `Premio_Film` (`Nome` , `Istituzione` , `Anno_Premiazione_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Film_Formato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Film_Formato` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Id_Formato` INT UNSIGNED NOT NULL,
  `Data_Aggiornamento` TIMESTAMP NOT NULL,
  `Data_Rilascio` DATE NOT NULL,
  PRIMARY KEY (`Id_Film`, `Id_Formato`, `Data_Aggiornamento`),
  INDEX `fk_Film_has_Formato_Formato1_idx` (`Id_Formato` ASC, `Data_Aggiornamento` ASC) VISIBLE,
  INDEX `fk_Film_has_Formato_Film1_idx` (`Id_Film` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_Formato_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Formato_Formato1`
    FOREIGN KEY (`Id_Formato` , `Data_Aggiornamento`)
    REFERENCES `Formato` (`Id_Formato` , `Data_Aggiornamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Premiazione_Attore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premiazione_Attore` (
  `Nome` VARCHAR(200) NOT NULL,
  `Istituzione` VARCHAR(200) NOT NULL,
  `Id_Artista` INT UNSIGNED NOT NULL,
  `Anno_Premiazione_Attore` INT NOT NULL,
  PRIMARY KEY (`Nome`, `Istituzione`, `Id_Artista`, `Anno_Premiazione_Attore`),
  INDEX `fk_Attore_has_Premio_Attore_Premio_Attore1_idx` (`Nome` ASC, `Istituzione` ASC, `Anno_Premiazione_Attore` ASC) VISIBLE,
  INDEX `fk_Attore_has_Premio_Attore_Attore1_idx` (`Id_Artista` ASC) VISIBLE,
  CONSTRAINT `fk_Attore_has_Premio_Attore_Attore1`
    FOREIGN KEY (`Id_Artista`)
    REFERENCES `Attore` (`Id_Artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Attore_has_Premio_Attore_Premio_Attore1`
    FOREIGN KEY (`Nome` , `Istituzione` , `Anno_Premiazione_Attore`)
    REFERENCES `Premio_Attore` (`Nome` , `Istituzione` , `Anno_Premiazione_Attore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Visualizzazioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Visualizzazioni` (
  `Ora_Visualizzazione` TIMESTAMP NOT NULL,
  PRIMARY KEY (`Ora_Visualizzazione`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Visualizzazioni_Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Visualizzazioni_Film` (
  `Id_Film` INT UNSIGNED NOT NULL,
  `Ora_Visualizzazione` TIMESTAMP NOT NULL,
  `Id_Cliente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Id_Film`, `Ora_Visualizzazione`, `Id_Cliente`),
  INDEX `fk_Film_has_Visualizzazioni_Visualizzazioni1_idx` (`Ora_Visualizzazione` ASC) INVISIBLE,
  INDEX `fk_Film_has_Visualizzazioni_Film1_idx` (`Id_Film` ASC) INVISIBLE,
  INDEX `fk_Utente_has_Visualizzazioni_Film_has_Visualizzazioni1` (`Id_Cliente` ASC) INVISIBLE,
  CONSTRAINT `fk_Film_has_Visualizzazioni_Film1`
    FOREIGN KEY (`Id_Film`)
    REFERENCES `Film` (`Id_Film`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_has_Visualizzazioni_Visualizzazioni1`
    FOREIGN KEY (`Ora_Visualizzazione`)
    REFERENCES `Visualizzazioni` (`Ora_Visualizzazione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Utente_has_Visualizzazioni_Film_has_Visualizzazioni1`
    FOREIGN KEY (`Id_Cliente`)
    REFERENCES `Utente` (`Id_Cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Connessione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Connessione` (
  `IP` VARCHAR(21) NOT NULL,
  `Id_Cliente` INT UNSIGNED NOT NULL,
  `Inizio_Connessione` TIMESTAMP NOT NULL,
  `Fine_Connesione` TIMESTAMP NOT NULL,
  PRIMARY KEY (`IP`, `Id_Cliente`, `Inizio_Connessione`, `Fine_Connesione`),
  INDEX `fk_Dispositivo_has_Utente_Utente2_idx` (`Id_Cliente` ASC) VISIBLE,
  INDEX `fk_Dispositivo_has_Utente_Dispositivo2_idx` (`IP` ASC, `Inizio_Connessione` ASC, `Fine_Connesione` ASC) VISIBLE,
  CONSTRAINT `fk_Dispositivo_has_Utente_Dispositivo2`
    FOREIGN KEY (`IP` , `Inizio_Connessione` , `Fine_Connesione`)
    REFERENCES `Dispositivo` (`IP` , `Inizio_Connessione` , `Fine_Connesione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dispositivo_has_Utente_Utente2`
    FOREIGN KEY (`Id_Cliente`)
    REFERENCES `Utente` (`Id_Cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- trigger per inserimenti sicuri
-- trigger inserimento sicuro, che mi assicura che ci siano 150 stati 
DROP TRIGGER IF EXISTS Trigger_Inserimento_Sicuro;

DELIMITER $$

CREATE TRIGGER Trigger_Inserimento_Sicuro BEFORE INSERT ON Posizione
FOR EACH ROW
BEGIN

    DECLARE Quanti_Stati_Diversi INT DEFAULT 0;

    SET Quanti_Stati_Diversi =  (
                                    SELECT  COUNT(DISTINCT Stato)
                                    FROM    Posizione P
                                );
    IF Quanti_Stati_Diversi = 150
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Troppi stati, non è possibile inserirne altri';

    END IF;

END $$

DELIMITER ;

-- trigger che mi assicura che il PAN sia di almeno 16 caratteri

DROP TRIGGER IF EXISTS Trigger_Inserimento_Carta;
DELIMITER $$
CREATE TRIGGER Trigger_Inserimento_Carta BEFORE INSERT ON Carta
FOR EACH ROW
BEGIN

DECLARE PAN_test VARCHAR(19) DEFAULT '';
DECLARE lunghezza_PAN INT DEFAULT 0;

SET PAN_test = NEW.Pan;
SET lunghezza_PAN = LENGTH(PAN_test);

IF lunghezza_PAN < 16 THEN

    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lunghezza del carattere PAN inferiore a 16. Inserire un PAN con lunghezza compresa fra 16 e 19';

END IF;

END $$

DELIMITER ;

-- vincolo generale: non possiamo mettere la recensione di un film che abbiamo già visto

DROP TRIGGER IF EXISTS Trigger_Voto_Utente;

DELIMITER $$

CREATE TRIGGER Trigger_Voto_Utente BEFORE INSERT ON Voto_Utente
FOR EACH ROW
BEGIN

DECLARE Film_Visualizzato TINYINT DEFAULT 0;

IF EXISTS   (
                SELECT  1
                FROM    Visualizzazioni_Film VF
                WHERE   VF.Id_Cliente = NEW.Id_Cliente AND VF.Id_Film = NEW.Id_Film
            )  
THEN SET Film_Visualizzato = 1;

END IF;

IF Film_Visualizzato = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Recensione su un film mai visualizzato.';

END IF;

END $$

DELIMITER ;

-- prevenzione abbonamenti

DROP TRIGGER IF EXISTS Trigger_Inserimento_Sicuro_Abbonamento;
DELIMITER $$
CREATE TRIGGER Trigger_Inserimento_Sicuro_Abbonamento BEFORE INSERT ON Abbonamento
FOR EACH ROW
BEGIN

IF(NEW.Tipo <> 'Basic' AND NEW.Tipo <> 'Premium' AND NEW.Tipo <> 'Special' AND NEW.Tipo <> 'Incredible' AND NEW.Tipo <> 'King') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo di abbonamento inesistente. Solamente possibile inserire i seguenti pacchetti: Basic,Premium,Special,Incredible,King.';
END IF;

END $$
DELIMITER ;

-- trigger per gli aggiornamenti delle rindondanze

-- contare il numero di dispositivi diversi in cui si è connesso l'utente finora

DROP TRIGGER IF EXISTS Trigger_Conta_Dispositivi_Diversi;
DELIMITER $$
CREATE TRIGGER Trigger_Conta_Dispositivi_Diversi AFTER INSERT ON Connessione
FOR EACH ROW
BEGIN

UPDATE Utente
SET Quanti_Dispositivi = Quanti_Dispositivi + 1
WHERE Id_Cliente = NEW.Id_Cliente;

END $$

-- Conta i pagamenti in ritardo

DROP TRIGGER IF EXISTS Trigger_Aggiorna_Quanti_Ritardi;
DELIMITER $$
CREATE TRIGGER Trigger_Aggiorna_Quanti_Ritardi AFTER INSERT ON Abbonamento FOR EACH ROW
BEGIN

DECLARE Ritardo_Giusto TINYINT DEFAULT 0;

IF EXISTS   (
                    -- gli abbonamenti con Id_Cliente che si sta inserendo e con fattura in ritardo
                    SELECT  1
                    FROM    Abbonamento A NATURAL JOIN Fattura F
                    WHERE   A.Id_Cliente = NEW.Id_Cliente AND A.Numero_Fattura = NEW.Numero_Fattura AND 
                            (
                                (F.Data_Pagamento > F.Scadenza AND F.Data_Pagamento IS NOT NULL) 
                                OR (F.Data_Pagamento IS NULL AND F.Scadenza < CURRENT_DATE) 
                            )
            )
THEN            
    
    SET Ritardo_Giusto = 1;

END IF;

IF Ritardo_Giusto = 1
THEN
    
    UPDATE  Utente U
    SET     U.Quanti_Ritardi = U.Quanti_Ritardi + 1
    WHERE   Id_Cliente = NEW.Id_Cliente;

END IF;

END $$

DELIMITER ;

-- Conta i premi degli attori

DROP TRIGGER IF EXISTS Trigger_Quanti_Premi_Attore;

DELIMITER $$

CREATE TRIGGER Trigger_Quanti_Premi_Attore AFTER INSERT ON Premiazione_Regista
FOR EACH ROW
BEGIN


    UPDATE Attore A
    SET A.Quanti_Premi = A.Quanti_Premi + 1 
    WHERE A.Id_Artista = NEW.Id_Artista;

END $$

DELIMITER $$

-- Conta i premi dei film

DROP TRIGGER IF EXISTS Trigger_Quanti_Premi_Film;
DELIMITER $$
CREATE TRIGGER Trigger_Quanti_Premi_Film AFTER INSERT ON Premiazione_Film
FOR EACH ROW
BEGIN

    UPDATE Film F
    SET F.Quanti_Premi = Quanti_Premi + 1
    WHERE F.Id_Film = NEW.Id_Film;

END $$
DELIMITER ;

-- Conta i premi dei registi

DROP TRIGGER IF EXISTS Trigger_Quanti_Premi_Regista;

DELIMITER $$

CREATE TRIGGER Trigger_Quanti_Premi_Regista AFTER INSERT ON Premiazione_Attore
FOR EACH ROW
BEGIN

    UPDATE Regista R
    SET R.Quanti_Premi = R.Quanti_Premi + 1
    WHERE R.Id_Artista = NEW.Id_Artista;

END $$

DELIMITER ;

-- Se il sottotitolo è disponibile, si aumenta il contatore

DROP TRIGGER IF EXISTS Trigger_Conta_Lingue_Doppiate;
DELIMITER $$
CREATE TRIGGER Trigger_Conta_Lingue_Doppiate AFTER INSERT ON Doppiaggio_Film
FOR EACH ROW
BEGIN

    DECLARE Presente_Lingua TINYINT DEFAULT 0;

    IF EXISTS   (
                    SELECT  1
                    FROM    Disposizione D
                    WHERE   D.Lingua = NEW.Lingua AND D.Id_Film = NEW.Id_Film
                ) 
	THEN
    
		SET Presente_Lingua = 1;       
	
    END IF;
    -- si aggiorna se la lingua per quel film è disponibile anche in disposizione

    IF Presente_Lingua = 1 THEN

    UPDATE  Film F
    SET     F.Quante_Lingue = F.Quante_Lingue + 1
    WHERE   F.Id_Film = NEW.Id_Film;

    END IF;

END $$

DELIMITER ;

-- -- Se il sottotitolo è disponibile, si aumenta il contatore

DROP TRIGGER IF EXISTS Trigger_Conta_Lingue;
DELIMITER $$
CREATE TRIGGER Trigger_Conta_Lingue AFTER INSERT ON Disposizione
FOR EACH ROW
BEGIN

    DECLARE Doppiaggio_Esistente TINYINT DEFAULT 0;

    IF EXISTS   ( 
                    SELECT  1
                    FROM    Doppiaggio_Film DF
                    WHERE   DF.Lingua = NEW.Lingua AND DF.Id_Film = NEW.Id_Film         
                )
    THEN

        SET Doppiaggio_Esistente = 1;     

    END IF;
    -- si aggiorna se la lingua per quel film è disponibile anche in doppiaggio

    IF Doppiaggio_Esistente = 1 THEN

        UPDATE  Film F
        SET     F.Quante_Lingue = F.Quante_Lingue + 1
        WHERE   F.Id_Film = NEW.Id_Film; 

    END IF;

END $$

DELIMITER ;

-- popolamento

-- utente 
INSERT INTO Utente VALUES
(1,"Luigi","De Falco","Bentornati Ovetti!","luigidefalco@gmail.com",0,0),
(2,"Maria","De Falco","33 trentini andarono a Trento tutti e 33 trottorellando","mariadefalco@outlook.it",0,0),
(3,"Mario","Nigiotti","CatiuMarsha","marionigiotti@libero.it",0,0),
(4,"Paolo","Cervi","3 tigri contro 3 tigri","paolocervi@yahoo.com",0,0),
(5,'Paola','Costa','Cavolfiore','paolacosta@gmail.com',0,0),
(6,'Alessio','Daini','Bentornati miei cari paguri!','alessiodaini@outlook.it',0,0),
(7,'Alessia','Costa','Dannata siepe!','alessiacosta@libero.it',0,0),
(8,'Viola','Bianchi','Voglio una vita con maggior colore!','violabianchi@yahoo.com',0,0),
(9,'Marco','Bruschi','Oh Paola!','marcobruschi@gmail.com',0,0),
(10,'Bianca','Castiglione','Nastiglione','biancacastiglione@yahoo.com',0,0);

-- film

INSERT INTO Attore VALUES
(1,'Vivien', 'Leigh','Scarlett O Hara', 0), -- Via Col Vento
(2,'Clark', 'Gable','Rhett Butler', 0), -- Via Col Vento
(3,'Humphrey', 'Bogart', NULL, 0),-- Casablanca
(4,'Ingrid', 'Bergman', NULL, 0), -- Casablanca
(5,'Tyrone', 'Power', NULL, 0), -- Testimone d'accusa 
(6,'Marlene', 'Dietrich', NULL, 0), -- Testimone d'accusa
(7,'Marcello', 'Mastroianni', NULL, 0), -- La Dolce Vita
(8,'Anita', 'Ekberg', NULL, 0), -- La Dolce Vita
(9,'Marlon', 'Brando', NULL, 0), -- Il Padrino
(10,'Al', 'Pacino', NULL, 0), -- Il Padrino
(11,'Mark', 'Hamill', NULL, 0), -- Guerre Stellari
(12,'Harrison', 'Ford', NULL,0), -- Guerre Stellari
(13,'Tom', 'Hanks', NULL,0), -- Titanic
(14,'Robin', 'Wright', NULL, 0), -- Titanic
(15,'Leonardo', 'Di Caprio', NULL, 0), -- Sesto Senso
(16,'Kate', 'Winslet', NULL, 0), -- Sesto Senso
(17,'Bruce', 'Willis', NULL, 0), -- Il Signore degli Anelli: Il Ritorno del Re
(18,'Haley', 'Joel Osment', NULL, 0), -- Il Signore degli Anelli: Il Ritorno del Re
(19,'Elijah','Wood',NULL,0),
(20,'Ian','McKellen',NULL,0);


INSERT INTO Regista VALUES
(1,'Victor', 'Fleming', NULL,0), -- Via Col Vento
(2,'Michael', 'Curtiz', 'Miska',0), -- Casablanca
(3,'Samuel Billy', 'Wilder', 'Billie Wilder',0), -- Testimone d'accusa
(4,'Federico', 'Fellini', NULL,0), -- La Dolce Vita
(5,'Francis Ford', 'Coppola', NULL,0), -- Il Padrino
(6,'George', 'Lucas', NULL,0), -- Guerre Stellari
(7,'Bruce', 'Willis', NULL,0), -- Forrest Gump
(8,'M. Night', 'Shyamalan', NULL,0), -- Titanic
(9,'Peter', 'Jackson', NULL,0), --  Sesto Senso
(10,'Haley Joel', 'Osment', NULL,0); -- Il Signore degli Anelli: Il Ritorno del Re


INSERT INTO Film VALUES
    (1,1939, 'Via col Vento', 238, 'Stati Uniti', 0, 'Drammatico/Romantico', 0, 'Il film segue la vita di Scarlett O Hara durante la Guerra Civile.'),
    (2,1942, 'Casablanca', 102, 'Stati Uniti', 0, 'Drammatico/Romantico', 0, 'La storia da amore tra Rick Blaine e Ilsa Lund durante la Seconda Guerra Mondiale.'),
    (3,1957, 'Testimone da accusa', 116, 'Stati Uniti', 0, 'Drammatico/Thriller', 0, 'Un avvocato difende un uomo accusato di omicidio, ma la verità è sfuggente.'),
    (4,1960, 'La dolce vita', 174, 'Italia', 0, 'Drammatico', 0, 'La vita di un giornalista a Roma, tra vita mondana e vuoto esistenziale.'),
    (5,1972, 'Il Padrino', 175, 'Stati Uniti', 0, 'Drammatico/Crimine', 0, 'La saga di una famiglia mafiosa italo-americana, guidata da Don Vito Corleone.'),
    (6,1977, 'Guerre stellari (Star Wars)', 121, 'Stati Uniti', 0, 'Fantascienza/Azione', 0, 'La lotta tra le forze ribelli e lo Impero Galattico, con Luke Skywalker.'),
    (7,1994, 'Forrest Gump', 142, 'Stati Uniti', 0, 'Drammatico/Commedia', 0, 'La vita straordinaria di Forrest Gump, attraverso gli eventi degli anni 60 e 70.'),
    (8,1997, 'Titanic', 195, 'Stati Uniti', 0, 'Drammatico/Romantico', 0, 'La tragica storia da amore tra Jack e Rose a bordo del transatlantico Titanic.'),
    (9,1999, 'Il sesto senso', 107, 'Stati Uniti', 0, 'Thriller/Supernaturale', 0, 'Un psicologo cerca di aiutare un giovane che afferma di vedere i morti.'),
    (10,2003, 'Il Signore degli Anelli: Il Ritorno del Re', 201, 'Stati Uniti/Nuova Zelanda', 0, 'Fantasia/Azione', 0, 'La conclusione epica della trilogia, con la battaglia per il dominio della Anello.');

INSERT INTO Direzione VALUES  
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

INSERT INTO Interpretazione VALUES
(1,1),
(1,2),
(2,3),
(2,4),
(3,5),
(3,6),
(4,7),
(4,8),
(5,9),
(5,10),
(6,11),
(6,12),
(7,13),
(7,14),
(8,15),
(8,16),
(9,17),
(9,18),
(10,19),
(10,20);

-- carta 
INSERT INTO Carta VALUES
('573', '9058599163577205','Luigi','De Falco','Visa'),
('335', '2019906743030489','Mario','Nigiotti','Mastercard'),
('269', '5805287072432984','Paolo','Cervi','Cirrus'),
('798', '7376164067688150','Paola','Costa','Maestro'),
('343', '0465667543797593','Alessio','Daini','American Express'),
('144', '1865331704158761','Viola','Bianchi','Visa Electron'),
('811', '7842208334889374','Marco','Bruschi','Diners Club International'),
('324', '1134752847339975','Paola','Costa','Postamat');


INSERT INTO Fattura VALUES -- `Numero_Fattura`,Importo,Scadenza,Data_Pagamento,CVV,PAN
('000902-22',10.9,'2022-09-10','2022-09-08','573','9058599163577205'), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000903-22',10.9,'2022-09-10','2022-09-08','573','9058599163577205'),-- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000702-18',3.27,'2018-07-23','2018-07-30','335','2019906743030489'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('000701-14',3.27,'2014-07-22','2014-07-20','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('000401-05',3.27,'2005-04-11','2005-04-11','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('001201-07',21.72,'2007-12-30','2007-12-23','798','7376164067688150'),-- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
('000501-22',12.2,'2022-05-03','2022-05-03','343','0465667543797593'), -- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
('001101-21',8,'2021-11-09','2021-11-04','144','1865331704158761'), -- pagamento special per un mese: 8
('000101-17',10.88,'2017-01-04','2017-01-04','811','7842208334889374'), -- pagamento special per 9 6 mesi: 8 + 8 *36/100
('001102-21',10.88,'2021-11-15','2021-11-15','324','1134752847339975'),-- pagamento special per 9 6 mesi: 8 + 8 *36/100
('000501-13',10.9,'2013-05-19','2013-05-22','573','9058599163577205'), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000101-10',10.9,'2010-01-08','2010-01-08','573','9058599163577205'),-- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000202-17',3.27,'2017-02-15','2017-02-15','335','2019906743030489'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('000202-10',3.27,'2010-02-12','2010-02-10','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('001003-10',3.27,'2010-10-18','2010-10-09','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('001001-23',21.72,'2023-10-19','2023-10-16','798','7376164067688150'),-- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
('000601-18',12.2,'2018-06-01','2018-06-05','343','0465667543797593'), -- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
('000502-05',8,'2010-05-05','2010-05-05','144','1865331704158761'), -- pagamento special per un mese: 8
('000701-06',10.88,'2006-07-22','2006-07-26','811','7842208334889374'); -- pagamento special per 9 6 mesi: 8 + 8 *36/100


INSERT INTO Abbonamento VALUES -- Durata_Abbonamento,Tipo,Caratterizzazione,Stato,Eta,Ore_Massime,Numero_Fattura,Id_Cliente
(3,'Incredible','Cartone Animato',0,0,3,'000902-22',1),-- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Incredible','Azione',0,0,4,'000903-22',2), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Basic','Avventura',1,0,3,'000702-18',3), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Romantico',1,0,4,'000701-14',4), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Film Di Avventura Non Animato',1,0,NULL,'000401-05',5), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(9,'King','Comico',0,0,5,'001201-07',6), -- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
(12,'Premium','Umorismo Nero',1,3,NULL,'000501-22',7),-- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
(1,'Special','Umorismo Bianco',0,0,5,'001101-21',8), -- pagamento special per un mese: 8
(6,'Special','Amatoriale',0,0,3,'000101-17',9), -- pagamento special per 6 mesi: 8 + 8 *36/100
(6,'Special','Film Fantasy Non Animato',0,0,4,'001102-21',10), -- pagamento special per 6 mesi: 8 + 8 *36/100
(3,'Incredible','Film Fantasy Animato',0,0,5,'000501-13',1), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Incredible','Serie Fantasy Non Animata',0,0,4,'000101-10',2), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Basic','Serie Fantasy Animata',1,0,4,'000202-17',3), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Live Action',1,0,3,'000202-10',4), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Serie Medica',1,0,3,'001003-10',5), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(9,'King','Serie Da Amore',0,0,6,'001001-23',6), -- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
(12,'Premium','Film Anime',1,0,3,'000601-18',7), -- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
(1,'Special','Serie Anime',0,0,4,'000502-05',8), -- pagamento special per un mese: 8
(6,'Special','Intrattenimento',0,0,4,'000701-06',9); -- pagamento special per 6 mesi: 8 + 8 *36/100

-- dispositivi

INSERT INTO Posizione VALUES
(43.54373436937224, 10.303498824157684, 'Italia', 'Toscana', 'Livorno', 'Livorno'),
(43.72267209679317, 10.389390982672612, 'Italia', 'Toscana', 'Pisa', 'San Rossore'),
(45.470773108021355, 9.192891875262365, 'Italia', 'Lombardia', 'Milano', 'Milano'),
(45.068394446543444, 7.66521280899329, 'Italia', 'Piemonte', 'Torino', 'Porta Nuova'),
(43.85843283620393, 11.1222581260965, 'Italia', 'Toscana', 'Prato', 'Prato'),
(43.52741621189143, 10.616235505048303, 'Italia', 'Toscana', 'Pisa', 'Casciana Terme'),
(43.346842879877585, 11.322670327341456, 'Italia', 'Toscana', 'Siena', 'Siena'),
(45.438763916908435, 11.886092947308365, 'Italia', 'Lombardia', 'Padova', 'Padova'),
(42.76623600464113, 11.082852895041562, 'Italia', 'Toscana', 'Grosseto', 'Grosseto'),
(42.72478712307374, 10.979559521626257, 'Italia', 'Toscana', 'Grosseto', 'Marina Di Grosseto'),
(43.66454813132292, 10.278624927024149, 'Italia', 'Toscana', 'Pisa', 'Marina Di Pisa'),
(40.47221373120492, 17.329636658293143, 'Italia', 'Puglia', 'Taranto', 'Taranto'),
(40.84916275730319, 14.253004645444294, 'Italia', 'Campania', 'Napoli', 'Napoli'),
(45.417032261776036, 10.73694852280654, 'Italia', 'Lombardia', 'Verona', 'Oliosi'),
(45.59468834371946, 10.458372624757557, 'Italia', 'Lombardia', 'Brescia', 'Legnano'),
(44.660595454418015, 12.254654481251277, 'Italia', 'Emilia Romagna', 'Ferrara', 'Lido Di Spine'),
(43.40390939693433, 10.40616323242766, 'Italia', 'Toscana', 'Livorno', 'Castiglioncello'),
(43.296626397780386, 10.504250496252306, 'Italia', 'Toscana', 'Livorno', 'Cecina'),
(43.49178459899524, 10.346883432864658, 'Italia', 'Toscana', 'Livorno', 'Montenero');

INSERT INTO Dispositivo VALUES
('5739.0585.9916.3577','Tablet Windows 11',43.54373436937224,10.303498824157684, '2022-09-11 21:00:35','2022-09-11 23:10:35'), -- porcavacca,Livorno,Livorno
('0304.8926.9580.5287','Notebook Windows 7',43.72267209679317,10.389390982672612, '2018-07-30 23:10:39','2018-07-31 01:19:50'), -- polo B San Rossore, Pisa
('0724.3298.4798.7376','Tablet Windows 8.1',45.470773108021355,9.192891875262365, '2014-07-22 18:15:04','2014-07-22 21:15:04'), -- Milano Milano BorgoNuovo
('2053.3520.1990.6743','Computer Fisso Windows XP',45.068394446543444,7.66521280899329, '2005-04-11 14:14:01','2005-04-11 14:14:01'), -- Torino Porta Nuova
('1640.6768.8150.3430','Computer Fisso Windows Vista',43.85843283620393,11.1222581260965, '2007-12-30 00:39:46','2007-12-30 05:56:49'), -- Prato Prato
('4656.6754.3797.5931','Tablet MacOS 11 Big Sur',43.52741621189143,10.616235505048303, '2022-05-03 08:00:24','2022-05-03 08:30:50'), -- Casciana Terme,Pisa
('4418.6533.1704.1587','Notebook MacOS 11 Big Sur',43.346842879877585,11.322670327341456, '2021-11-09 15:55:34','2021-11-09 19:10:34'), -- Siena Università di Siena, Siena
('6181.1784.2208.3348','Tablet Debian GNU/Linux 8 Jessie',45.438763916908435,11.886092947308365, '2017-01-04 06:53:43','2017-01-04 10:03:23'), -- Padova, Padova
('8937.4324.1134.7528','Computer Fisso Ubuntu 9.10 Karmic Koala',42.76623600464113,11.082852895041562, '1980-09-08 10:20:13','1980-09-08 12:23:30'), -- Grosseto, Grosseto
('4733.9975.1103.5755','Computer Fisso Windows 10',42.72478712307374,10.979559521626257, '2021-11-15 17:58:53','2021-11-15 20:08:03'), -- Marina Di Grosseto, Grosseto
('4843.0712.9412.4341','Tablet Windows 8.1',43.66454813132292,10.278624927024149, '2013-05-22 16:10:36','2013-05-22 17:30:50'), -- Marina Di Pisa, Pisa
('0755.7847.4969.0948','Tablet Windows 7',40.47221373120492,17.329636658293143, '2010-01-08 18:39:49','2010-01-08 18:39:49'), -- Taranto, Taranto
('2798.8393.1028.0646','Notebook Ubuntu 9.10 Karmic Koala',40.84916275730319,14.253004645444294, '2017-02-15 00:18:29','2017-02-15 03:30:29'), -- Napoli,Napoli
('2683.6593.8708.0530','Notebook Mac OS X Leopard',45.417032261776036,10.73694852280654, '2010-02-12 16:33:37','2010-02-12 18:50:49'), -- Oliosi, Verona
('6211.4342.8243.2315','Notebook TouchScreen Windows 7',45.59468834371946,10.458372624757557, '2010-10-18 11:19:46','2010-10-18 12:30:55'), -- Legnano, Brescia
('6867.4293.0943.5332','Computer Fisso Debian GNU/Linux 8 Jessie',44.660595454418015,12.254654481251277, '2023-10-19 23:23:10','2023-10-20 01:50:30'), -- Lido Di Spine,Ferrara
('3748.4464.1573.0051','Notebook Debian GNU/Linux 8 Jessie',43.40390939693433,10.40616323242766, '2018-06-05 20:38:34','2018-06-05 22:40:20'), -- Castiglioncello, Livorno
('7278.8915.8399.7651','Computer Fisso Ubuntu 8.10 Intrepid Ibex',43.296626397780386,10.504250496252306 , '2010-05-05 19:05:29','2010-05-05 21:50:45'), -- Cecina, Livorno
('5283.0737.5607.0349','Tablet Windows XP',43.49178459899524,10.346883432864658, '2006-07-26 17:37:07','2006-07-26 17:37:07'); -- Montenero, Livorno

INSERT INTO Connessione VALUES -- IP, Id_Cliente,Data_Inizio,Data_Fine
('5739.0585.9916.3577',1,'2022-09-11 21:00:35','2022-09-11 23:10:35'),
('0304.8926.9580.5287',2,'2018-07-30 23:10:39','2018-07-31 01:19:50'),
('0724.3298.4798.7376',3,'2014-07-22 18:15:04','2014-07-22 21:15:04'),
('2053.3520.1990.6743',4,'2005-04-11 14:14:01','2005-04-11 14:14:01'),
('1640.6768.8150.3430',5,'2007-12-30 00:39:46','2007-12-30 05:56:49'),
('4656.6754.3797.5931',6,'2022-05-03 08:00:24','2022-05-03 08:30:50'),
('4418.6533.1704.1587',7,'2021-11-09 15:55:34','2021-11-09 19:10:34'),
('6181.1784.2208.3348',8,'2017-01-04 06:53:43','2017-01-04 10:03:23'),
('8937.4324.1134.7528',9,'1980-09-08 10:20:13','1980-09-08 12:23:30'),
('4733.9975.1103.5755',1,'2021-11-15 17:58:53','2021-11-15 20:08:03'),
('4843.0712.9412.4341',2,'2013-05-22 16:10:36','2013-05-22 17:30:50'),
('0755.7847.4969.0948',3,'2010-01-08 18:39:49','2010-01-08 18:39:49'),
('2798.8393.1028.0646',4,'2017-02-15 00:18:29','2017-02-15 03:30:29'),
('2683.6593.8708.0530',5,'2010-02-12 16:33:37','2010-02-12 18:50:49'),
('6211.4342.8243.2315',6,'2010-10-18 11:19:46','2010-10-18 12:30:55'),
('6867.4293.0943.5332',7,'2023-10-19 23:23:10','2023-10-20 01:50:30'),
('3748.4464.1573.0051',8,'2018-06-05 20:38:34','2018-06-05 22:40:20'),
('7278.8915.8399.7651',3,'2010-05-05 19:05:29','2010-05-05 21:50:45'),
('5283.0737.5607.0349',4,'2006-07-26 17:37:07','2006-07-26 17:37:07');

-- doppiaggio_sottotitolo


INSERT INTO Doppiaggio VALUES   
("Italiano"),
("Francese"),
("Spagnolo"),
("Portoghese"),
("Tedesco"),
("Polacco"),
("Russo"),
("Cinese Mandarino"),
("Giapponese"),
("Coreano"),
("Afghano"),
("Australiano"),
("Inglese Britannico"),
("Inglese Americano"),
("Indiano"),
("Canadese"),
("Norvegese"),
("Filandese"),
("Svedese"),
("Romeno"),
("Greco"),
("Austriaco");

INSERT INTO Sottotitolo VALUES  
("Italiano"),
("Francese"),
("Spagnolo"),
("Portoghese"),
("Tedesco"),
("Polacco"),
("Russo"),
("Cinese Mandarino"),
("Giapponese"),
("Coreano"),
("Afghano"),
("Australiano"),
("Inglese Britannico"),
("Inglese Americano"),
("Indiano"),
("Canadese"),
("Norvegese"),
("Filandese"),
("Svedese"),
("Romeno"),
("Greco"),
("Austriaco");

INSERT INTO Doppiaggio_Film VALUES 
(1,"Italiano"),
(1,"Francese"),
(1,"Spagnolo"),
(1,"Portoghese"),
(1,"Tedesco"),
(1,"Polacco"),
(1,"Russo"),
(1,"Cinese Mandarino"),
(1,"Giapponese"),
(1,"Coreano"),
(1,"Afghano"),
(1,"Australiano"),
(1,"Inglese Britannico"),
(1,"Inglese Americano"),
(1,"Indiano"),
(1,"Canadese"),
(1,"Norvegese"),
(1,"Filandese"),
(1,"Svedese"),
(1,"Romeno"),
(1,"Greco"),
(1,"Austriaco"),
(2,"Italiano"),
(2,"Francese"),
(2,"Spagnolo"),
(2,"Portoghese"),
(2,"Tedesco"),
(2,"Polacco"),
(2,"Russo"),
(2,"Cinese Mandarino"),
(2,"Giapponese"),
(2,"Coreano"),
(2,"Afghano"),
(2,"Australiano"),
(2,"Inglese Britannico"),
(2,"Inglese Americano"),
(2,"Indiano"),
(2,"Canadese"),
(2,"Norvegese"),
(2,"Filandese"),
(2,"Svedese"),
(2,"Romeno"),
(2,"Greco"),
(2,"Austriaco"),
(3,"Italiano"),
(3,"Francese"),
(3,"Spagnolo"),
(3,"Portoghese"),
(3,"Tedesco"),
(3,"Polacco"),
(3,"Russo"),
(3,"Cinese Mandarino"),
(3,"Giapponese"),
(3,"Coreano"),
(3,"Afghano"),
(3,"Australiano"),
(3,"Inglese Britannico"),
(3,"Inglese Americano"),
(3,"Indiano"),
(3,"Canadese"),
(3,"Norvegese"),
(3,"Filandese"),
(3,"Svedese"),
(3,"Romeno"),
(3,"Greco"),
(3,"Austriaco"),
(4,"Italiano"),
(4,"Francese"),
(4,"Spagnolo"),
(4,"Portoghese"),
(4,"Tedesco"),
(4,"Polacco"),
(4,"Russo"),
(4,"Cinese Mandarino"),
(4,"Giapponese"),
(4,"Coreano"),
(4,"Afghano"),
(4,"Australiano"),
(4,"Inglese Britannico"),
(4,"Inglese Americano"),
(4,"Indiano"),
(4,"Canadese"),
(4,"Norvegese"),
(4,"Filandese"),
(4,"Svedese"),
(4,"Romeno"),
(4,"Greco"),
(4,"Austriaco"),
(5,"Italiano"),
(5,"Francese"),
(5,"Spagnolo"),
(5,"Portoghese"),
(5,"Tedesco"),
(5,"Polacco"),
(5,"Russo"),
(5,"Cinese Mandarino"),
(5,"Giapponese"),
(5,"Coreano"),
(5,"Afghano"),
(5,"Australiano"),
(5,"Inglese Britannico"),
(5,"Inglese Americano"),
(5,"Indiano"),
(5,"Canadese"),
(5,"Norvegese"),
(5,"Filandese"),
(5,"Svedese"),
(5,"Romeno"),
(5,"Greco"),
(5,"Austriaco"),
(6,"Italiano"),
(6,"Francese"),
(6,"Spagnolo"),
(6,"Portoghese"),
(6,"Tedesco"),
(6,"Polacco"),
(6,"Russo"),
(6,"Cinese Mandarino"),
(6,"Giapponese"),
(6,"Coreano"),
(6,"Afghano"),
(6,"Australiano"),
(6,"Inglese Britannico"),
(6,"Inglese Americano"),
(6,"Indiano"),
(6,"Canadese"),
(6,"Norvegese"),
(6,"Filandese"),
(6,"Svedese"),
(6,"Romeno"),
(6,"Greco"),
(6,"Austriaco"),
(7,"Italiano"),
(7,"Francese"),
(7,"Spagnolo"),
(7,"Portoghese"),
(7,"Tedesco"),
(7,"Polacco"),
(7,"Russo"),
(7,"Cinese Mandarino"),
(7,"Giapponese"),
(7,"Coreano"),
(7,"Afghano"),
(7,"Australiano"),
(7,"Inglese Britannico"),
(7,"Inglese Americano"),
(7,"Indiano"),
(7,"Canadese"),
(7,"Norvegese"),
(7,"Filandese"),
(7,"Svedese"),
(7,"Romeno"),
(7,"Greco"),
(7,"Austriaco"),
(8,"Italiano"),
(8,"Francese"),
(8,"Spagnolo"),
(8,"Portoghese"),
(8,"Tedesco"),
(8,"Polacco"),
(8,"Russo"),
(8,"Cinese Mandarino"),
(8,"Giapponese"),
(8,"Coreano"),
(8,"Afghano"),
(8,"Australiano"),
(8,"Inglese Britannico"),
(8,"Inglese Americano"),
(8,"Indiano"),
(8,"Canadese"),
(8,"Norvegese"),
(8,"Filandese"),
(8,"Svedese"),
(8,"Romeno"),
(8,"Greco"),
(8,"Austriaco"),
(9,"Italiano"),
(9,"Francese"),
(9,"Spagnolo"),
(9,"Portoghese"),
(9,"Tedesco"),
(9,"Polacco"),
(9,"Russo"),
(9,"Cinese Mandarino"),
(9,"Giapponese"),
(9,"Coreano"),
(9,"Afghano"),
(9,"Australiano"),
(9,"Inglese Britannico"),
(9,"Inglese Americano"),
(9,"Indiano"),
(9,"Canadese"),
(9,"Norvegese"),
(9,"Filandese"),
(9,"Svedese"),
(9,"Romeno"),
(9,"Greco"),
(9,"Austriaco"),
(10,"Italiano"),
(10,"Francese"),
(10,"Spagnolo"),
(10,"Portoghese"),
(10,"Tedesco"),
(10,"Polacco"),
(10,"Russo"),
(10,"Cinese Mandarino"),
(10,"Giapponese"),
(10,"Coreano"),
(10,"Afghano"),
(10,"Australiano"),
(10,"Inglese Britannico"),
(10,"Inglese Americano"),
(10,"Indiano"),
(10,"Canadese"),
(10,"Norvegese"),
(10,"Filandese"),
(10,"Svedese"),
(10,"Romeno"),
(10,"Greco"),
(10,"Austriaco");

INSERT INTO Disposizione VALUES 
("Italiano",1),
("Francese",1),
("Spagnolo",1),
("Portoghese",1),
("Tedesco",1),
("Polacco",1),
("Russo",1),
("Cinese Mandarino",1),
("Giapponese",1),
("Coreano",1),
("Afghano",1),
("Australiano",1),
("Inglese Britannico",1),
("Inglese Americano",1),
("Indiano",1),
("Canadese",1),
("Norvegese",1),
("Filandese",1),
("Svedese",1),
("Romeno",1),
("Greco",1),
("Austriaco",1),
("Italiano",2),
("Francese",2),
("Spagnolo",2),
("Portoghese",2),
("Tedesco",2),
("Polacco",2),
("Russo",2),
("Cinese Mandarino",2),
("Giapponese",2),
("Coreano",2),
("Afghano",2),
("Australiano",2),
("Inglese Britannico",2),
("Inglese Americano",2),
("Indiano",2),
("Canadese",2),
("Norvegese",2),
("Filandese",2),
("Svedese",2),
("Romeno",2),
("Greco",2),
("Austriaco",2),
("Italiano",3),
("Francese",3),
("Spagnolo",3),
("Portoghese",3),
("Tedesco",3),
("Polacco",3),
("Russo",3),
("Cinese Mandarino",3),
("Giapponese",3),
("Coreano",3),
("Afghano",3),
("Australiano",3),
("Inglese Britannico",3),
("Inglese Americano",3),
("Indiano",3),
("Canadese",3),
("Norvegese",3),
("Filandese",3),
("Svedese",3),
("Romeno",3),
("Greco",3),
("Austriaco",3),
("Italiano",4),
("Francese",4),
("Spagnolo",4),
("Portoghese",4),
("Tedesco",4),
("Polacco",4),
("Russo",4),
("Cinese Mandarino",4),
("Giapponese",4),
("Coreano",4),
("Afghano",4),
("Australiano",4),
("Inglese Britannico",4),
("Inglese Americano",4),
("Indiano",4),
("Canadese",4),
("Norvegese",4),
("Filandese",4),
("Svedese",4),
("Romeno",4),
("Greco",4),
("Austriaco",4),
("Italiano",5),
("Francese",5),
("Spagnolo",5),
("Portoghese",5),
("Tedesco",5),
("Polacco",5),
("Russo",5),
("Cinese Mandarino",5),
("Giapponese",5),
("Coreano",5),
("Afghano",5),
("Australiano",5),
("Inglese Britannico",5),
("Inglese Americano",5),
("Indiano",5),
("Canadese",5),
("Norvegese",5),
("Filandese",5),
("Svedese",5),
("Romeno",5),
("Greco",5),
("Austriaco",5),
("Italiano",6),
("Francese",6),
("Spagnolo",6),
("Portoghese",6),
("Tedesco",6),
("Polacco",6),
("Russo",6),
("Cinese Mandarino",6),
("Giapponese",6),
("Coreano",6),
("Afghano",6),
("Australiano",6),
("Inglese Britannico",6),
("Inglese Americano",6),
("Indiano",6),
("Canadese",6),
("Norvegese",6),
("Filandese",6),
("Svedese",6),
("Romeno",6),
("Greco",6),
("Austriaco",6),
("Italiano",7),
("Francese",7),
("Spagnolo",7),
("Portoghese",7),
("Tedesco",7),
("Polacco",7),
("Russo",7),
("Cinese Mandarino",7),
("Giapponese",7),
("Coreano",7),
("Afghano",7),
("Australiano",7),
("Inglese Britannico",7),
("Inglese Americano",7),
("Indiano",7),
("Canadese",7),
("Norvegese",7),
("Filandese",7),
("Svedese",7),
("Romeno",7),
("Greco",7),
("Austriaco",7),
("Italiano",8),
("Francese",8),
("Spagnolo",8),
("Portoghese",8),
("Tedesco",8),
("Polacco",8),
("Russo",8),
("Cinese Mandarino",8),
("Giapponese",8),
("Coreano",8),
("Afghano",8),
("Australiano",8),
("Inglese Britannico",8),
("Inglese Americano",8),
("Indiano",8),
("Canadese",8),
("Norvegese",8),
("Filandese",8),
("Svedese",8),
("Romeno",8),
("Greco",8),
("Austriaco",8),
("Italiano",9),
("Francese",9),
("Spagnolo",9),
("Portoghese",9),
("Tedesco",9),
("Polacco",9),
("Russo",9),
("Cinese Mandarino",9),
("Giapponese",9),
("Coreano",9),
("Afghano",9),
("Australiano",9),
("Inglese Britannico",9),
("Inglese Americano",9),
("Indiano",9),
("Canadese",9),
("Norvegese",9),
("Filandese",9),
("Svedese",9),
("Romeno",9),
("Greco",9),
("Austriaco",9),
("Italiano",10),
("Francese",10),
("Spagnolo",10),
("Portoghese",10),
("Tedesco",10),
("Polacco",10),
("Russo",10),
("Cinese Mandarino",10),
("Giapponese",10),
("Coreano",10),
("Afghano",10),
("Australiano",10),
("Inglese Britannico",10),
("Inglese Americano",10),
("Indiano",10),
("Canadese",10),
("Norvegese",10),
("Filandese",10),
("Svedese",10),
("Romeno",10),
("Greco",10),
("Austriaco",10);

-- critico

INSERT INTO Critico VALUES
(1,NULL,'Richard','Corliss'),
(2,NULL,'Edwars','Guthmann'),
(3,NULL,'Mike','Clark'),
(4,NULL,'Roger','Ebert'),
(5,NULL,'James','Beraldinelli'),
(6,NULL,'Owen','Gleiberman'),
(7,NULL,'Jonathan','Rosenbaum'),
(8,NULL,'John','Harti'),
(9,NULL,'Peter','Travers'),
(10,NULL,'Rita','Kempley'),
(11,NULL,'Mark','Johnson'),
(12,NULL,'Brian','Eggert'),
(13,NULL,'Wilson Ward','Marsh'),
(14,NULL,'Alex','Maidy'),
(15,NULL,'Tom','Meek'),
(16,NULL,'Joanne','Laurier'),
(17,NULL,'Mike','Massie'),
(18,NULL,'Otis','Stuart'),
(19,NULL,'Matt','Neal'),
(20,NULL,'Micheal','Wilmington'),
(21,NULL,'Lou','Lumenick'),
(22,NULL,'Kate','Cameron'),
(23,NULL,'Cath','Clarke'),
(24,NULL,'David','Denby'),
(25,NULL,'Jeremiah','Kipp'),
(26,NULL,'James','Beradinelli'),
(27,NULL,'Serena','Donadoni'),
(28,NULL,'Pauline','Kael'),
(29,NULL,'David','Parkinson'),
(30,NULL,'Martyn','Conterio'),
(31,NULL,'Kenneth','Turan'),
(32,NULL,'Peter','Brandshaw'),
(33,NULL,'Dave','Kehr'),
(34,NULL,'Shawn','Levy'),
(35,NULL,'David','Edelstein'),
(36,NULL,'David','Sterrit');


INSERT INTO Voto_Critico VALUES
(7,1,80,'A long drink of water at the fountain of pop-social memory.'),
(7,2,75,'At its best, Forrest Gump is a gentle, elegiac fantasy about love and trust.'),
(7,3,88,'It does not sound like a very prepossessing title, but prepare to be taken aback by -what is in a name-'),
(7,4,100,'What a magical movie'),
(7,5,100,'Passionate and magical, Forrest Gump is a tonic for the weary of spirit.'),
(7,6,50,'It is also glib, shallow, and monotonous, a movie that spends so much time sanctifying its hero that, despite his "innocence," he ends up seeming about as vulnerable as Superman'),
(7,7,90,'The results are skillful, highly affecting, and ultimately more than a little pernicious'),
(7,8,90,'This is an ambitious movie that attempts too much rather than too little'),
(7,9,90,'A movie heart-breaker of oddball wit and startling grace.'),
(7,10,90,'Zemeckis, an undisputed master of film technology, shows off an equal aptitude for vivid storytelling.'),
(7,11,70,'It is most successful when it is being off-center, a state of grace it does not quite have the nerve to maintain.'),
(1,12,80,'It remains the most seen film in cinema history, not only because Selznick produced a monumental motion picture of immaculate quality, but because he knew how to sell it as an event.'),
(1,13,65,' Dubbed the “Golden Year of Cinema,” 1939 is often cited as the greatest year in the history of film. Five movies from 1939 made the original American Film Institute’s Top 100 Films list. Many of these movies hold up extraordinarily well, but none more stunningly than Victor Fleming’s Gone with the Wind. Vivien Leigh and Clark Gable star as the southern belle and her wily and charismatic love interest, set amongst the backdrop of the antebellum South as the Confederacy meets its ruin. The performances, set designs, costumes, Technicolor photography, and Max Steiner’s exhilarating score keep this film as bewildering and extravagant a film today as it ever was.
What it beat: Dark Victory, Goodbye Mr. Chips, Love Affair, Mr. Smith Goes to Washington, Ninotchka, Of Mice and Men, Stagecoach, The Wizard of Oz, Wuthering Heights
Hindsight is a bitch: The lunacy of this era can be summarized with the way Gone with the Wind – long thought of as one of the two or three greatest American films – has attained a patina of disrepute for the way it depicted black characters and romanticized the South at the time. The time of the film, of course, being the Civil War, for Christ’s sake. But I digress from such asinine and irresponsible revisionist politics that choose to sterilize our history rather than take the complicated and nuanced approach of studying it for what it was. While I would not argue against The Wizard of Oz, the Academy got it correct.'),
(1,14,50,'Gone With The Wind is a woefully overrated film that takes a revisionist look at the Civil War as a romantic era rather than a violent and racist period of American history. Couple that with characters who are so poorly conceived and melodramatically acted and you are left with a film that never manages to be more than a curiosity from a bygone era. As a movie regarded as one of the greatest of all time, it is a painful reminder of how tone-deaf Hollywood can be in the pursuit of making popular films. Gone With The Wind is an expertly manufactured work that checks off every requirement of a studio executive rather than serving as an inspirational film worth any level of emotional investment. If you love it, then fiddle-dee-dee because I do not give a damn.'),
(1,15,75,'One of the early films that would make de Havilland a household name and even has an uncredited (and unused – or so it is said) early contribution from F. Scott Fitzgerald, is now under cultural scrutiny for its romanticizing of the slave-owning South. The film, directed by Victor Fleming (after George Cukor was fired) is a gorgeous production from an aesthetic and technical standpoint. One of the first technicolor films made by Hollywood, the panning shot of injured and dead soldiers littering a street remains unforgettable. The casting of Scarlett (Vivien Leigh) and Rhett (Clark Gable) remains iconic, even as the film comes under questions of intent and embrace. Context and reflection are necessary and important when sitting down to re-screen.'),
(1,16,75,'One of the early films that would make de Havilland a household name and even has an uncredited (and unused – or so it is said) early contribution from F. Scott Fitzgerald, is now under cultural scrutiny for its romanticizing of the slave-owning South. The film, directed by Victor Fleming (after George Cukor was fired) is a gorgeous production from an aesthetic and technical standpoint. One of the first technicolor films made by Hollywood, the panning shot of injured and dead soldiers littering a street remains unforgettable. The casting of Scarlett (Vivien Leigh) and Rhett (Clark Gable) remains iconic, even as the film comes under questions of intent and embrace. Context and reflection are necessary and important when sitting down to re-screen.'),
(1,17,100,'No other movie has had quite the impact, the influence, or the epic feel (perhaps as only a nearly four-hour-long production could create) of this unmistakable masterpiece'),
(1,18,80,'True to the book, the film of Gone With The Wind is held together by its heroine.'),
(1,19,100,'Hey kids, wanna watch a four-hour-long romantic melodrama, told from the sympathetic perspective of the racist slave owners who lost the Civil War?'),
(1,20,80,'"Gone With the Wind" offers the kind of big, rich, opulent experience the movies are in a unique position to offer but seldom do.'),
(1,21,50,'The film is subtle racism is insidious, going to great lengths to enshrine the myth that the Civil War was not fought over slavery - an institution the film unabashedly romanticizes.'),
(1,22,80,'There has never been a picture like David O. Selznicks production of Gone With the Wind.'),
(1,23,80,'No one watches Gone with the Wind for historical accuracy. What keeps us coming back is four-hours of epic romance in gorgeous Technicolor'),
(2,7,90,'Part of what makes this wartime Hollywood drama (1942) about love and political commitment so fondly remembered is its evocation of a time when the sentiment of this country about certain things appeared to be unified. (It is been suggested that communism is the political involvement that grizzled of Bogart casino owner Rick may be in retreat from at the beginning.) This hastily patched together picture, which started out as a B film, wound up getting an Oscar, and displays a cozy, studio-bound claustrophobia that Howard Hawks improved upon in his superior spin-off To Have and Have Not. '),
(2,24,100,'The most familiar movie in the world is still fresh; it has so many little busy corners to nestle in... Casablanca is the most sociable, the most companionable film ever made. Life as an endless party.'),
(2,25,100,'The film has a peculiar magic to it, and because of its pace the richness of its sense of detail often goes unnoticed.'),
(2,26,100,'Casablanca accomplishes that which only a truly great film can: enveloping the viewer in the story, forging an unbreakable link with the characters, and only letting go with the end credits.'),
(2,27,100,'Casablanca was filmed in the safety of the Warner Bros. lot, but the cast of immigrants and exiles who had fled the Third Reich conveyed their visceral fear. While the future was uncertain, the resolute characters of this exquisite wartime drama found peace through love and resistance.'),
(3,28,50,'Billy Wilder is inane yet moderately entertaining version of an Agatha Christie courtroom thriller, with Charles Laughton wiggling his wattles.'),
(3,29,80,'Marlene Dietrich tries not to give anything away as usual while Agatha Christie is whodunit plot whirs tidily about her expressionless beauty.'),
(3,30,80,'While not amongst the greater, more celebrated titles in Billy Wilder is acclaimed filmography, his big screen adaptation of Agatha Christie’s Witness for the Prosecution boasts a fine, scenery-chewing performance by Charles Laughton, here playing a cantankerous barrister defending a murder suspect.'),
(4,4,100,'The movie is made with boundless energy. Fellini stood here at the dividing point between the neorealism of his earlier films (like "La Strada") and the carnival visuals of his extravagant later ones ("Juliet of the Spirits,","Amarcord")'),
(4,20,100,'One of the true classics.'),
(5,31,100,'Overflowing with life, rich with all the grand emotions and vital juices of existence, up to and including blood. And its deaths, like that of Hotspur in "Henry IV, Part I," continue to shock no matter how often we have watched them coming'),
(5,32,100,'Coppola is epic storytelling sweep is magnificent: there is an electric charge in simply the shift from New York to California to Sicily and back to New York. This is the top-down approach to gangsters, the “great man” theory of organised crime. Later movies such as Scorsese’s Goodfellas will emphasise the more ragged lower ranks'),
(5,26,100,'The picture is a series of mini-climaxes, all building to the devastating, definitive conclusion... It was carefully and painstakingly crafted. Every major character - and more than a few minor ones - is molded into a distinct, complex individual.'),
(6,33,100,'An exhilarating update of "Flash Gordon," very much in the same half-jokey, half-earnest mood, but backed by special effects that, for once, really work and are intelligently integrated with the story.'),
(6,5,100,'Like all great craftsmen, Lucas has managed to fashion this material in a manner that not only honors the original sources, but makes it uniquely his own. Hacks rip off other movies; artists synthesize and pay homage to their inspirations.'),
(6,4,100,'If I were asked to say with certainty which movies will still be widely known a century or two from now, I would list "2001", "The Wizard of Oz", "Keaton and Chaplin", "Astaire and Rogers", and probably "Casablanca" ... and "Star Wars",for sure.'),
(6,10,80,'Star Wars had all the right stuff, and unlike its confounding progenitor, "2001: A Space Odyssey," it was fairy-tale simple: "A long time ago in a galaxy far, far away," good met evil.'),
(8,5,100,'You do not just watch Titanic, you experience it.'),
(8,6,100,'Titanic floods you with elemental passion in a way that invites comparison with the original movie spectacles of D.W. Griffith.'),
(8,3,100,'His (Cameron) movie may not be perfect, but visually and viscerally, it pretty well is.'),
(8,10,100,'A film that sweeps us away into a world of spectacle, beauty and excitement, a realm of fantasy unimaginable without the movies.'),
(8,34,100,'It is quite possible that Titanic is one of the greatest romantic epics ever filmed.'),
(8,7,90,'One hell of a movie.'),
(8,31,30,'What audiences end up with word-wise is a hackneyed, completely derivative copy of old Hollywood romances, a movie that reeks of phoniness and lacks even minimal originality.'),
(8,35,50,'Cameron has never been known for his dialogue, but Titanic carries some stinkers that would not make the final draft of a "Days of Our Lives" script.'),
(9,3,88,'The filmmaker keeps upping the ante with surprises until the plot-twist beaut that concludes the picture - a shocker that, upon reflection, is probably the one ending that would not have fallen a little flat.'),
(9,8,80,'The boy (Osment) has an uncanny ability to suggest secretive of Cole, haunted soul, and he seems to have inspired Willis to give perhaps his most self-effacing performance.'),
(9,4,75,'Has a kind of calm, sneaky self-confidence that allows it to take us down a strange path, intriguingly.'),
(9,35,70,'Ultimately, it has less in common with "Blair Witch" than with such quivering lumps of sentiment as "Ghost" and Field of Dreams."'),
(9,5,38,'An inferior product. It is not well written, well acted, or well directed.'),
(10,1,100,'The second half of the film elevates all the story elements to Beethovenian crescendo. Here is an epic with depth of literature and splendor of opera -- and one that could be achieved only in movies. What could be more terrific?'),
(10,5,100,'Labeling this as a "movie" is almost an injustice. This is an experience of epic scope and grandeur, amazing emotional power, and relentless momentum.'),
(10,31,100,'As completely real on the psychological level as its up-to-the-moment visual effects have on the physical.'),
(10,20,100,'Like all great fantasies and epics, this one leaves you with the sense that its wonders are real, its dreams are palpable.'),
(10,35,100,'It might be the cinema is most astonishing holy war film. The Lord of the Rings took seven years and an army of gifted artists to execute, and the striving of its makers is in every splendid frame. It is more than a movie--it is a gift.'),
(10,4,88,'There is little enough psychological depth anywhere in the films, actually, and they exist mostly as surface, gesture, archetype and spectacle. They do that magnificently well, but one feels at the end that nothing actual and human has been at stake.'),
(10,9,88,'This is a film in which ideas resonate as well as action. Gandalf’s words to Pippin about death have a muscular poetry.'),
(10,36,50,'Add a lot of dull acting -- except Sir Ian McKellen and Andy Serkis -- and you have an uneven movie with yawns aplenty.');

-- visualizzazioni
INSERT INTO Visualizzazioni VALUES
('1994-11-16 01:21:16'),
('2017-02-10 14:01:10'),
('2005-07-10 16:43:10'),
('2020-03-26 04:01:26'),
('2022-05-01 11:14:01'),
('2005-07-22 12:58:22'),
('2017-10-08 12:26:08'),
('1998-09-17 16:21:17'),
('2001-12-10 23:26:10'),
('2006-03-03 16:57:03'),
('2007-12-14 00:58:14'),
('2011-06-07 03:13:07'),
('2023-04-11 04:38:11'),
('1997-07-04 18:47:04'),
('1995-12-24 14:30:24'),
('2018-12-16 05:00:16'),
('2012-12-07 02:48:07'),
('2010-12-02 18:11:02'),
('2014-02-14 17:03:14'),
('2017-12-06 21:15:06'),
('1990-02-04 14:39:04'),
('2018-08-29 01:03:29'),
('2011-07-10 11:32:10'),
('1991-09-29 23:53:29'),
('1993-11-05 17:45:05'),
('2000-11-16 14:21:16'),
('2000-05-26 19:14:26'),
('1995-04-23 06:11:23'),
('2003-06-13 00:17:13'),
('2003-05-24 06:12:24'),
('2008-09-26 23:48:26'),
('1992-05-27 04:20:27'),
('1996-07-14 18:13:14'),
('2015-10-16 12:31:16'),
('2016-10-11 13:20:11'),
('1990-12-19 05:02:19'),
('2005-03-05 21:22:05'),
('2002-09-08 19:01:08'),
('2008-07-12 12:15:12'),
('1999-07-31 09:19:31'),
('1992-06-24 04:06:24'),
('2019-11-21 10:27:21'),
('2000-10-13 05:27:13'),
('2009-03-08 16:42:08'),
('1995-03-24 12:55:24'),
('1993-11-10 03:23:10'),
('2003-12-27 12:10:27'),
('2009-01-07 07:14:07'),
('2015-04-19 07:13:19'),
('2007-03-01 12:4:01'),
('2019-10-17 02:59:17'),
('1994-05-20 23:14:20'),
('1990-06-08 21:51:08'),
('2019-07-13 22:58:13'),
('2005-04-12 19:47:12'),
('2000-08-03 12:08:03'),
('2022-05-02 21:34:02'),
('2011-02-23 05:53:23'),
('2002-06-23 03:18:23'),
('2008-03-03 17:11:03'),
('2007-08-20 13:34:20'),
('1995-06-06 22:40:06'),
('2020-02-08 08:41:08'),
('1990-06-17 08:25:17'),
('2006-10-21 19:54:21'),
('1999-10-27 13:45:27'),
('2022-10-11 12:51:11'),
('1995-10-13 10:33:13'),
('2022-08-20 05:56:20'),
('1998-05-18 01:32:18'),
('2019-09-07 07:17:07'),
('2006-06-17 15:52:17'),
('2012-04-22 17:51:22'),
('1990-04-24 05:42:24'),
('1991-12-14 11:21:14'),
('2015-04-02 18:30:02'),
('2010-03-24 10:35:24'),
('1994-01-21 19:03:21'),
('1996-01-18 09:34:18'),
('2002-02-10 17:26:10'),
('2021-02-18 18:52:18'),
('2010-03-15 22:47:15'),
('2010-01-29 11:33:29'),
('2002-06-13 16:02:13'),
('2022-06-10 20:55:10'),
('2007-03-22 00:13:22'),
('2003-10-24 02:11:24'),
('2016-04-03 16:02:03'),
('2015-06-15 13:12:15'),
('2014-10-31 10:36:31'),
('2002-01-27 00:21:27'),
('2022-08-22 02:02:22'),
('2018-05-03 09:40:03'),
('1995-12-07 01:49:07'),
('2008-05-13 10:44:13'),
('2000-06-07 05:14:07'),
('2011-09-05 19:29:05'),
('1994-08-06 07:29:06'),
('1996-07-25 00:15:25'),
('2007-08-08 09:12:08');

INSERT INTO Visualizzazioni_Film VALUES
(1,'1994-11-16 01:21:16',1),
(2,'2017-02-10 14:01:10',1),
(3,'2005-07-10 16:43:10',1),
(4,'2020-03-26 04:01:26',1),
(5,'2022-05-01 11:14:01',1),
(6,'2005-07-22 12:58:22',1),
(7,'2017-10-08 12:26:08',1),
(8,'1998-09-17 16:21:17',1),
(9,'2001-12-10 23:26:10',1),
(10,'2006-03-03 16:57:03',1),
(1,'2007-12-14 00:58:14',2),
(2,'2011-06-07 03:13:07',2),
(3,'2023-04-11 04:38:11',2),
(4,'1997-07-04 18:47:04',2),
(5,'1995-12-24 14:30:24',2),
(6,'2018-12-16 05:00:16',2),
(7,'2012-12-07 02:48:07',2),
(8,'2010-12-02 18:11:02',2),
(9,'2014-02-14 17:03:14',2),
(10,'2017-12-06 21:15:06',2),
(1,'1990-02-04 14:39:04',3),
(2,'2018-08-29 01:03:29',3),
(3,'2011-07-10 11:32:10',3),
(4,'1991-09-29 23:53:29',3),
(5,'1993-11-05 17:45:05',3),
(6,'2000-11-16 14:21:16',3),
(7,'2000-05-26 19:14:26',3),
(8,'1995-04-23 06:11:23',3),
(9,'2003-06-13 00:17:13',3),
(10,'2003-05-24 06:12:24',3),
(1,'2008-09-26 23:48:26',4),
(2,'1992-05-27 04:20:27',4),
(3,'1996-07-14 18:13:14',4),
(4,'2015-10-16 12:31:16',4),
(5,'2016-10-11 13:20:11',4),
(6,'1990-12-19 05:02:19',4),
(7,'2005-03-05 21:22:05',4),
(8,'2002-09-08 19:01:08',4),
(9,'2008-07-12 12:15:12',4),
(10,'1999-07-31 09:19:31',4),
(1,'1992-06-24 04:06:24',5),
(2,'2019-11-21 10:27:21',5),
(3,'2000-10-13 05:27:13',5),
(4,'2009-03-08 16:42:08',5),
(5,'1995-03-24 12:55:24',5),
(6,'1993-11-10 03:23:10',5),
(7,'2003-12-27 12:10:27',5),
(8,'2009-01-07 07:14:07',5),
(9,'2015-04-19 07:13:19',5),
(10,'2007-03-01 12:4:01',5),
(1,'2019-10-17 02:59:17',6),
(2,'1994-05-20 23:14:20',6),
(3,'1990-06-08 21:51:08',6),
(4,'2019-07-13 22:58:13',6),
(5,'2005-04-12 19:47:12',6),
(6,'2000-08-03 12:08:03',6),
(7,'2022-05-02 21:34:02',6),
(8,'2011-02-23 05:53:23',6),
(9,'2002-06-23 03:18:23',6),
(10,'2008-03-03 17:11:03',6),
(1,'2007-08-20 13:34:20',7),
(2,'1995-06-06 22:40:06',7),
(3,'2020-02-08 08:41:08',7),
(4,'1990-06-17 08:25:17',7),
(5,'2006-10-21 19:54:21',7),
(6,'1999-10-27 13:45:27',7),
(7,'2022-10-11 12:51:11',7),
(8,'1995-10-13 10:33:13',7),
(9,'2022-08-20 05:56:20',7),
(10,'1998-05-18 01:32:18',7),
(1,'2019-09-07 07:17:07',8),
(2,'2006-06-17 15:52:17',8),
(3,'2012-04-22 17:51:22',8),
(4,'1990-04-24 05:42:24',8),
(5,'1991-12-14 11:21:14',8),
(6,'2015-04-02 18:30:02',8),
(7,'2010-03-24 10:35:24',8),
(8,'1994-01-21 19:03:21',8),
(9,'1996-01-18 09:34:18',8),
(10,'2002-02-10 17:26:10',8),
(1,'2021-02-18 18:52:18',9),
(2,'2010-03-15 22:47:15',9),
(3,'2010-01-29 11:33:29',9),
(4,'2002-06-13 16:02:13',9),
(5,'2022-06-10 20:55:10',9),
(6,'2007-03-22 00:13:22',9),
(7,'2003-10-24 02:11:24',9),
(8,'2016-04-03 16:02:03',9),
(9,'2015-06-15 13:12:15',9),
(10,'2014-10-31 10:36:31',9),
(1,'2002-01-27 00:21:27',10),
(2,'2022-08-22 02:02:22',10),
(3,'2018-05-03 09:40:03',10),
(4,'1995-12-07 01:49:07',10),
(5,'2008-05-13 10:44:13',10),
(6,'2000-06-07 05:14:07',10),
(7,'2011-09-05 19:29:05',10),
(8,'1994-08-06 07:29:06',10),
(9,'1996-07-25 00:15:25',10),
(10,'2007-08-08 09:12:08',10);

-- recensione utente
INSERT INTO Voto_Utente VALUES
(1,1,NULL,6),
(1,2,NULL,7),
(1,3,NULL,8),
(1,4,NULL,9),
(1,5,NULL,5),
(1,6,NULL,10),
(1,7,NULL,10),
(1,8,NULL,9),
(1,9,NULL,6),
(1,10,NULL,8),
(2,1,NULL,6),
(2,2,NULL,7),
(2,3,NULL,8),
(2,4,NULL,9),
(2,5,NULL,5),
(2,6,NULL,10),
(2,7,NULL,10),
(2,8,NULL,9),
(2,9,NULL,6),
(2,10,NULL,8),
(3,1,NULL,6),
(3,2,NULL,7),
(3,3,NULL,8),
(3,4,NULL,9),
(3,5,NULL,5),
(3,6,NULL,10),
(3,7,NULL,10),
(3,8,NULL,9),
(3,9,NULL,6),
(3,10,NULL,8),
(4,1,NULL,6),
(4,2,NULL,7),
(4,3,NULL,8),
(4,4,NULL,9),
(4,5,NULL,5),
(4,6,NULL,10),
(4,7,NULL,10),
(4,8,NULL,9),
(4,9,NULL,6),
(4,10,NULL,8),
(5,1,NULL,6),
(5,2,NULL,7),
(5,3,NULL,8),
(5,4,NULL,9),
(5,5,NULL,5),
(5,6,NULL,10),
(5,7,NULL,10),
(5,8,NULL,9),
(5,9,NULL,6),
(5,10,NULL,8),
(6,1,NULL,6),
(6,2,NULL,7),
(6,3,NULL,8),
(6,4,NULL,9),
(6,5,NULL,5),
(6,6,NULL,10),
(6,7,NULL,10),
(6,8,NULL,9),
(6,9,NULL,6),
(6,10,NULL,8),
(7,1,NULL,6),
(7,2,NULL,7),
(7,3,NULL,8),
(7,4,NULL,9),
(7,5,NULL,5),
(7,6,NULL,10),
(7,7,NULL,10),
(7,8,NULL,9),
(7,9,NULL,6),
(7,10,NULL,8),
(8,1,NULL,6),
(8,2,NULL,7),
(8,3,NULL,8),
(8,4,NULL,9),
(8,5,NULL,5),
(8,6,NULL,10),
(8,7,NULL,10),
(8,8,NULL,9),
(8,9,NULL,6),
(8,10,NULL,8),
(9,1,NULL,6),
(9,2,NULL,7),
(9,3,NULL,8),
(9,4,NULL,9),
(9,5,NULL,5),
(9,6,NULL,10),
(9,7,NULL,10),
(9,8,NULL,9),
(9,9,NULL,6),
(9,10,NULL,8),
(10,1,NULL,6),
(10,2,NULL,7),
(10,3,NULL,8),
(10,4,NULL,9),
(10,5,NULL,5),
(10,6,NULL,10),
(10,7,NULL,10),
(10,8,NULL,9),
(10,9,NULL,6),
(10,10,NULL,8);

-- premi

INSERT INTO Premio_Film VALUES
('Oscar Per Il Miglior Film','AMPAS',1940,100,'New York'),
('Oscar Per Il Miglior Film','AMPAS',1944,100,'New York'),
('Oscar Per Il Miglior Film','AMPAS',1973,100,'New York'),
('Oscar Per Il Miglior Film','AMPAS',1995,100,'New York'),
('Oscar Per Il Miglior Film','AMPAS',1998,100,'New York'),
('Oscar Per Il Miglior Film','AMPAS',2004,100,'New York'),
('Premio Alla Memoria Irving G.Thalberg','AMPAS',1940,100,'New York'),
('National Board Of Review Award Migliori Dieci Film','NBRA',1940,80,'New York'),
('National Board Of Review Award Migliori Dieci Film','NBRA',1972,80,'New York'),
('National Board Of Review Award Migliori Dieci Film','NBRA',1977,80,'New York'),
('National Board Of Review Award Migliori Dieci Film','NBRA',1997,80,'New York'),
('National Board Of Review Of Motion Pictures Awards Top Ten Films','NBRMPA',1943,80,'New York'),
('National Board Of Review Of Motion Pictures Awards Top Ten Films','NBRMPA',1972,80,'New York'),
('New York Film Critics Circle Awards Al Miglior Film In Lingua Straniera','NYFCC',1961,80,'New York'),
('New York Film Critics Circle Awards Al Miglior Film','NYFCC',2003,80,'New York'),
('Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',1973,100,'New York'),
('Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',1995,100,'New York'),
('Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',1998,100,'New York'),
('Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',2004,100,'New York'),
('Saturn Award Per Miglior Film Di Fantascienza','Academy Of Science Fiction, Fantasy & Horror Films',1978,100,'New York'),
('Saturn Award Premio Speciale Per Il 20-esimo Anniversario','Academy Of Science Fiction, Fantasy & Horror Films',1997,100,'New York'),
('Saturn Award Per Miglior Film Fantasy','Academy Of Science Fiction, Fantasy & Horror Films',1995,100,'New York'),
('Saturn Award Per Miglior Film Horror','Academy Of Science Fiction, Fantasy & Horror Films',2000,100,'New York'),
('Los Angeles Film Critics Association Awards Miglior Film','LAFCA',1977,80,'Los Angeles'),
('People Choice Awards Miglior Film','People Choice Awards',1978,60,'New York'),
('People Choice Awards Miglior Film Drammatico','People Choice Awards',1995,60,'New York'), -- va aggiunto
('People Choice Awards Miglior Film Drammatico','People Choice Awards',1999,60,'New York'), -- va aggiunto
('People Choice Awards Miglior Film Drammatico','People Choice Awards',2000,60,'New York'), -- va aggiunto
('People Choice Awards Miglior Film Di Tutti I Tempi','People Choice Awards',1989,60,'New York'),
('Webby Awards Premio Sociale','International Academy Of Digital Arts And Sciences',2020,70,NULL),
('Evening Standard British Film Awards Miglior Film','London Evening Standard',1979,80,'Londra'),
('Ciak Di Oro Miglior Film Straniero','Ciak',1995,50,'Italia'),
('Ciak Di Oro Miglior Film Straniero','Ciak',1998,50,'Italia'),
('Premio Amanda Miglior Film Straniero','Norwegian International Film Festival',1995,50,'Norvegia'),
('Premio Amanda Miglior Film Straniero','Norwegian International Film Festival',1998,50,'Norvegia'),
('Empire Awards Miglior Film','Empire',1998,60,'Britannia'),
('Empire Awards Miglior Film','Empire',2004,60,'Britannia'),
('Las Vegas Film Critics Society Awards Miglior Film','LVFCS',1997,80,'Nevada'),
('Hollywood Film Awards Miglior Film','CBS',1998,70,'Santa Monica'),
('Florida Film Critics Circle Awards Miglior Film','FFCA',1998,80,'Florida'), -- inserire
('Florida Film Critics Circle Awards Miglior Film','FFCA',2004,80,'Florida'),
('Premio BAFTA Miglior Film','BAFTA',2004,80,'Britannia'),
('Chicago Film Critics Association Miglior Film','CFCAM',2003,80,'Illnois'),
('Las Vegas Film Critics Society Miglior Film','LVFCS',2003,80,'Nevada'),
('Phoenix Film Critics Society Awards Al Miglior Film','PFCS',2003,80,'Arizona'),
('Washington DC Area Film Critics Association Awards Miglior Film','WAFCA',2003,80,'Maryland'),
('AFI Awards Film Dello Anno','AFI',2004,70,'USA'),
('Dallas-Fort Worth Film Critics Association Awards Miglior Film','DFWFCA',2004,70,'Texas'),
('Golden Trailer Awards Miglior Film Drammatico','GTA',2004,70,'USA'),
('Irish Film And Television Awards Miglior Film Internazionale','IFTA',2004,80,'Ireland'),
('Online Film Critics Society Awards Miglior Film','OFCS',2004,90,NULL),
('Premio Hugo Miglior Rappresentazione Drammatica (Forma Lunga)','Hugo Miglior Rappresentazione Drammatica',2004,80,'Internazionale'),
('SFX Awards Miglior Film','SFX',2004,50,'Britannia'),
('Critics Choice Of Movie Awards Miglior Film Affiliante','CCMA',2013,80,NULL),
('Critics Choice Of Movie Awards Miglior Film','CCMA',2004,80,NULL), -- va inserito
('Young Artist Award Miglior Film Drammatico Per La Famiglia','YAA',2004,80,NULL);

INSERT INTO Premiazione_Film VALUES
(1,'Oscar Per Il Miglior Film','AMPAS',1940), -- ok
(1,'Premio Alla Memoria Irving G.Thalberg','AMPAS',1940), -- ok
(1,'National Board Of Review Award Migliori Dieci Film','NBRA',1940), -- ok
(1,'People Choice Awards Miglior Film Di Tutti I Tempi','People Choice Awards',1989), -- ok
(2,'Oscar Per Il Miglior Film','AMPAS',1944), -- ok
(2,'National Board Of Review Of Motion Pictures Awards Top Ten Films','NBRMPA',1943), -- ok
(4,'New York Film Critics Circle Awards Al Miglior Film In Lingua Straniera','NYFCC',1961), -- ok
(5,'Oscar Per Il Miglior Film','AMPAS',1973), -- ok
(5,'Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',1973), -- ok
(5,'National Board Of Review Award Migliori Dieci Film','NBRA',1972), -- ok
(6,'Saturn Award Per Miglior Film Di Fantascienza','Academy Of Science Fiction, Fantasy & Horror Films',1978), -- ok
(6,'Saturn Award Premio Speciale Per Il 20-esimo Anniversario','Academy Of Science Fiction, Fantasy & Horror Films',1997), -- ok
(6,'Los Angeles Film Critics Association Awards Miglior Film','LAFCA',1977), -- ok
(6,'People Choice Awards Miglior Film','People Choice Awards',1978), -- ok
(6,'National Board Of Review Award Migliori Dieci Film','NBRA',1977), -- ok
(6,'Webby Awards Premio Sociale','International Academy Of Digital Arts And Sciences',2020), -- ok
(6,'Evening Standard British Film Awards Miglior Film','London Evening Standard',1979), -- ok
(7,'Oscar Per Il Miglior Film','AMPAS',1995), -- ok
(7,'Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',1995), -- ok
(7,'Ciak Di Oro Miglior Film Straniero','Ciak',1995), -- ok
(7,'Saturn Award Per Miglior Film Fantasy','Academy Of Science Fiction, Fantasy & Horror Films',1995), -- ok
(7,'Premio Amanda Miglior Film Straniero','Norwegian International Film Festival',1995), -- ok
(7,'People Choice Awards Miglior Film Drammatico','People Choice Awards',1995), -- ok
(8,'Oscar Per Il Miglior Film','AMPAS',1998), -- ok
(8,'Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',1998), -- ok
(8,'Empire Awards Miglior Film','Empire',1998), -- ok
(8,'Ciak Di Oro Miglior Film Straniero','Ciak',1998), -- ok
(8,'National Board Of Review Award Migliori Dieci Film','NBRA',1997), -- ok
(8,'Premio Amanda Miglior Film Straniero','Norwegian International Film Festival',1998), -- ok
(8,'Las Vegas Film Critics Society Awards Miglior Film','LVFCS',1997), -- ok
(8,'Hollywood Film Awards Miglior Film','CBS',1998), -- ok
(8,'People Choice Awards Miglior Film Drammatico','People Choice Awards',1999), -- ok
(8,'Florida Film Critics Circle Awards Miglior Film','FFCA',1998), -- ok
(9,'Saturn Award Per Miglior Film Horror','Academy Of Science Fiction, Fantasy & Horror Films',2000),
(9,'People Choice Awards Miglior Film Drammatico','People Choice Awards',2000), -- ok
(10,'Oscar Per Il Miglior Film','AMPAS',2004), -- ok
(10,'Golden Globe Per Miglior Film Drammatico','HFPA/Golden Globe Foundation',2004), -- ok
(10,'Premio BAFTA Miglior Film','BAFTA',2004), -- ok
(10,'Chicago Film Critics Association Miglior Film','CFCAM',2003), -- ok
(10,'Las Vegas Film Critics Society Miglior Film','LVFCS',2003), -- ok
(10,'New York Film Critics Circle Awards Al Miglior Film','NYFCC',2003), -- ok
(10,'Phoenix Film Critics Society Awards Al Miglior Film','PFCS',2003), -- ok
(10,'Washington DC Area Film Critics Association Awards Miglior Film','WAFCA',2003), -- ok
(10,'AFI Awards Film Dello Anno','AFI',2004), -- ok
(10,'Critics Choice Of Movie Awards Miglior Film','CCMA',2004), -- ok
(10,'Dallas-Fort Worth Film Critics Association Awards Miglior Film','DFWFCA',2004), -- ok
(10,'Empire Awards Miglior Film','Empire',2004), -- ok
(10,'Florida Film Critics Circle Awards Miglior Film','FFCA',2004), -- ok
(10,'Golden Trailer Awards Miglior Film Drammatico','GTA',2004),
(10,'Irish Film And Television Awards Miglior Film Internazionale','IFTA',2004), -- ok
(10,'Online Film Critics Society Awards Miglior Film','OFCS',2004), -- ok
(10,'Premio Hugo Miglior Rappresentazione Drammatica (Forma Lunga)','Hugo Miglior Rappresentazione Drammatica',2004), -- ok
(10,'SFX Awards Miglior Film','SFX',2004), -- ok
(10,'Young Artist Award Miglior Film Drammatico Per La Famiglia','YAA',2004), -- ok
(10,'Critics Choice Of Movie Awards Miglior Film Affiliante','CCMA',2013); -- ok

INSERT INTO Premio_Regista VALUES
('Oscar Per Miglior Regista','AMPAS',1940,100,'New York'),
('Oscar Per Miglior Regista','AMPAS',1944,100,'New York'),
('Oscar Per Miglior Regista','AMPAS',1946,100,'New York'),
('Oscar Per Miglior Regista','AMPAS',1961,100,'New York'),
('Oscar Per Miglior Regista','AMPAS',1975,100,'New York'),
('Oscar Per Miglior Regista','AMPAS',1995,100,'New York'),
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1946,100,'New York'),
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1951,100,'New York'),
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1973,100,'New York'),
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1980,100,'New York'),
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1995,100,'New York'),
('BAFTA Fellowship','Bafta',1995,100,'Britannia'),
('Leone Di Oro Alla Carriera','Biennale di Venezia',1992,100,'Italia'),
('Saturn Award Per Migliore Regista','Academy Of Science Fiction, Fantasy & Horror Films',1990,100,'New York'),
('Empire Awards Migliore Regista Vincitore/trice','Empire',2000,70,'Britannia'),
('Razzie Awards Peggior Regista','Golden Raspberry Award Foundation',2006,30,'Los Angeles, California, USA');

INSERT INTO Premiazione_Regista VALUES
('Oscar Per Miglior Regista','AMPAS',1940,1), -- ok
('Oscar Per Miglior Regista','AMPAS',1944,2), -- ok
('Oscar Per Miglior Regista','AMPAS',1946,4), -- ok
('Oscar Per Miglior Regista','AMPAS',1961,4), -- ok
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1946,4), -- ok
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1951,4), -- ok
('BAFTA Fellowship','Bafta',1995,4), -- ok
('Oscar Per Miglior Regista','AMPAS',1975,5),-- ok
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1973,5), -- ok
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1980,5), -- ok
('Leone Di Oro Alla Carriera','Biennale di Venezia',1992,5), -- ok
('Oscar Per Miglior Regista','AMPAS',1995,7), -- ok
('Golden Globe Per Miglior Regista','HFPA/Golden Globe Foundation',1995,7), -- ok
('Saturn Award Per Migliore Regista','Academy Of Science Fiction, Fantasy & Horror Films',1990,7), -- ok
('Empire Awards Migliore Regista Vincitore/trice','Empire',2000,8), -- ok
('Razzie Awards Peggior Regista','Golden Raspberry Award Foundation',2006,8);


INSERT INTO Premio_Attore VALUES
('Premio Oscar Per Miglior Attrice','AMPAS',1940,100,'New York'), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',1952,100,'New York'), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',1945,100,'New York'), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',1957,100,'New York'), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',2009,100,'New York'), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',1935,100,'New York'), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',1955,100,'New York'), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',1994,100,'New York'), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',1995,100,'New York'), -- ok
('Premio Oscar Per Miglior Attore Protagonista','AMPAS',1993,100,'New York'), -- ok
('Premio Oscar Per Miglior Attore Protagonista','AMPAS',2014,100,'New York'), -- ok
('Premio Oscar Per Migliore Attrice Non Protagonista','AMPAS',1975,100,'New York'), -- ok
('Mostra Internazionale Di Arte Cinematografica Coppa Volpi Alla Miglior Attrice','Biennale Di Venezia',1951,90,'Italia'),-- ok
('Premio BAFTA Migliore Attrice Britannica','BAFTA',1953,80,'Britannia'), -- ok
('Premio BAFTA Migliore Attrice Non Protagonista','BAFTA',1975,80,'Britannia'), -- ok
('Premio BAFTA Miglior Attore Protagonista','BAFTA',1973,80,'Britannia'), -- ok
('Premio BAFTA Miglior Attore Protagonista','BAFTA',1953,80,'Britannia'), -- ok
('Premio BAFTA Miglior Attore Protagonista','BAFTA',1955,80,'Britannia'), -- ok
('Premio BAFTA Stanley Kubrick Britannia Award For Excellence','BAFTA',2004,80,'Britannia'), -- ok
('Premio BAFTA Migliore Attore Internazione','BAFTA',1963,85,'Britannia'), -- ok
('Premio BAFTA Migliore Attore Internazione','BAFTA',1964,85,'Britannia'), -- ok
('New York Film Critics Circle Awards Per La Miglior Attrice Protagonista','New York Film Critics Circle',1939,80,'New York'), -- ok
('New York Film Critics Circle Awards Per La Miglior Attrice Protagonista','New York Film Critics Circle',1951,80,'New York'), -- ok
('New York Film Critics Circle Awards Per La Miglior Attrice Protagonista','New York Film Critics Circle',1954,80,'New York'), -- ok
('National Board Of Review Award Al Miglior Attore','NBRA',1937,80,'New York'), -- ok
('National Board Of Review Award Al Miglior Attore','NBRA',1944,80,'New York'), -- ok
('National Board Of Review Award Al Miglior Attore Protagonista','NBRA',1952,80,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',1945,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',1946,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',1957,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',1994,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',1995,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',2001,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',2009,100,'New York'), -- ok
('Golden Globe Per Il Miglior Attore In Un Film Commedia O Musicale','HFPA/Golden Globe Foundation',1963,100,'New York'),
('Golden Globe Per Il Miglior Attore In Un Film Commedia O Musicale','HFPA/Golden Globe Foundation',1988,100,'New York'),
('Golden Globe Per Il Miglior Attore In Un Film Commedia O Musicale','HFPA/Golden Globe Foundation',2016,100,'New York'),
('Golden Globe Per La Miglior Attrice Debuttante','HFPA/Golden Globe Foundation',1956,100,'New York'), -- ok
('Golden Globe Alla Carriera','HFPA/Golden Globe Foundation',2002,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice Non Protagonista','HFPA/Golden Globe Foundation',2009,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice Non Protagonista','HFPA/Golden Globe Foundation',2016,100,'New York'), -- ok
('Golden Globe Per La Migliore Attrice Protagonista','HFPA/Golden Globe Foundation',2023,100,'New York'),
('David Di Donatello Per La Migliore Attrice Straniera','Accademia Del Cinema Italiano',1957,80,'Italia'), -- ok
('David Di Donatello Per La Migliore Attrice Straniera','Accademia Del Cinema Italiano',1979,80,'Italia'), -- ok
('David Di Donatello Per La Miglior Attrice Protagonista','Accademia Del Cinema Italiano',1962,80,'Italia'), -- ok
('David Di Donatello Per La Miglior Attrice Protagonista','Accademia Del Cinema Italiano',1986,80,'Italia'), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',1964,80,'Italia'), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',1965,80,'Italia'), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',1988,80,'Italia'), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',1995,80,'Italia'), -- ok
('David Di Donatello Medaglia Di Oro Del Comune Di Roma','Accademia Del Cinema Italiano',1986,85,'Italia'), -- ok
('David Di Donatello Premio Alla Carriera','Accademia Del Cinema Italiano',1983,85,'Italia'), -- ok
('David Di Donatello Premio Alla Carriera','Accademia Del Cinema Italiano',1997,85,'Italia'), -- ok
('David di Donatello Per Il Miglior Attore Straniero','Accademia Del Cinema Italiano',1958,80,'Italia'), -- ok
('Jussi Awards Come Miglior Attore','Filmiaura',1951,80,'Finlandia'), -- ok
('Jussi Awards Come Miglior Attore','Filmiaura',1952,80,'Finlandia'), -- ok
('Jussi Awards Alla Carriera','Filmiaura',2001,80,'Finlandia'), -- ok
('Prix De Interprétation Masculine','Festival di Cannes',1970,100,'Francia'),
('Prix De Interprétation Masculine','Festival di Cannes',1987,100,'Francia'),
('Prix De Interprétation Masculine','Festival di Cannes',1953,100,'Francia'),
('Palma Di Oro Onoraria','Festival di Cannes',2023,100,'Francia'), -- ok
('Saturn Award Per Il Migliore Attore','Academy Of Science Fiction, Fantasy & Horror Films',1982,100,'New York'), -- ok
('Saturn Award Per Il Migliore Attore','Academy Of Science Fiction, Fantasy & Horror Films',2016,100,'New York'), -- ok
('Saturn Award Life Achievement Award','Academy Of Science Fiction, Fantasy & Horror Films',1996,100,'New York'), -- ok
('People Choice Awards Per Il Miglior Attore','People Choice Awards',1996,60,'New York'), -- ok
('People Choice Awards Per Attore Preferito','People Choice Awards',2012,60,'New York'), -- ok
('People Choice Awards Per Attore Preferito In Un Film Drammatico','People Choice Awards',2017,60,'New York'), -- ok
('People Choice Awards Per Il Migliore Star Maschile','People Choice Awards',1998,65,'New York'), -- ok
('People Choice Awards Per Il Migliore Star Maschile','People Choice Awards',1999,65,'New York'), -- ok
('People Choice Awards Per Il Migliore Star Maschile','People Choice Awards',2000,65,'New York'), -- ok
('Nastro Di Argento Per La Migliore Attrice Straniera In Italia','SNGCI',1951,80,'Italia'), -- ok
('Nastro Di Argento Per La Migliore Attrice Straniera In Italia','SNGCI',1953,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1955,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1958,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1961,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1962,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1986,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1988,80,'Italia'), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',1991,80,'Italia'), -- ok
('Nastro Di Argento Speciale','SNGCI',1997,80,'Italia'), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',1976,70,'Italia'), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',1977,70,'Italia'), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',1984,70,'Italia'), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',1986,70,'Italia'), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',1991,70,'Italia'), -- ok
('Grolla Di Oro Per Il Miglior Attore','Telegrolle',1955,60,'Italia'), -- ok
('Grolla Di Oro Per Il Miglior Attore','Telegrolle',1976,60,'Italia'), -- ok
('Grolla Di Oro Premio Speciale','Telegrolle',1978,60,'Italia'), -- ok
('Premio Cesar Onorario','Academie Des Arts Et Techniques Du Cinema',1976,80,'Francia'), -- ok
('Premio Cesar Onorario','Academie Des Arts Et Techniques Du Cinema',1993,80,'Francia'), -- ok
('Screen Actors Guild Awards Al Miglior Attore Protagonista','SAG-AFTRA',1995,100,'Los Angeles'), -- ok
('Screen Actors Guild Awards Al Miglior Attore Protagonista','SAG-AFTRA',2016,100,'Los Angeles'), -- ok
('Screen Actors Guild Awards Al Miglior Cast','SAG-AFTRA',1996,100,'Los Angeles'), -- ok
('Razzie Awards Premio Peggior Coppia','Razzie Awards',2022,30,'Los Angeles, California, USA'), -- ok
('Razzie Awards Premio Peggior Coppia','Razzie Awards',1998,30,'Los Angeles, California, USA'), -- ok
('Razzie Awards Premio Peggior Attore Protagonista','Razzie Awards',1998,30,'Los Angeles, California, USA'), -- ok
('British Academy Film Awards Al Miglior Attore Protagonista','BAFA',2016,80,'Britannia'), -- ok
('British Academy Film Awards Alla Migliore Attrice','BAFA',2009,80,'Britannia'), -- ok
('British Academy Film Awards Alla Migliore Attrice Protagonista','BAFA',2023,80,'Britannia'), -- ok
('British Academy Film Awards Alla Migliore Attrice Non Protagonista','BAFA',1996,80,'Britannia'),
('British Academy Film Awards Alla Migliore Attrice Non Protagonista','BAFA',2016,80,'Britannia'),
('Premio Emmy Alla Miglior Attrice','Academy of Television Arts & Sciences',2009,100,'Los Angeles'), -- ok
('Premio Emmy Miglior Attore In Una Serie Drammatica','Academy of Television Arts & Sciences',1987,100,'Los Angeles'), -- ok
('Critics Choice Awards Al Miglior Giovane Interprete','BFCA',2000,100,'Santa Monica'), -- ok
('Young Artist Award Al Miglior Giovane Attore Sotto I 10 Anni','YAA',1995,70,NULL); -- ok

INSERT INTO Premiazione_Attore VALUES
('Premio Oscar Per Miglior Attrice','AMPAS',1,1940), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',1,1952), -- ok
('Premio BAFTA Migliore Attrice Britannica','BAFTA',1,1953), -- ok
('Mostra Internazionale Di Arte Cinematografica Coppa Volpi Alla Miglior Attrice','Biennale Di Venezia',1,1951), -- ok
('New York Film Critics Circle Awards Per La Miglior Attrice Protagonista','New York Film Critics Circle',1,1939), -- ok
('New York Film Critics Circle Awards Per La Miglior Attrice Protagonista','New York Film Critics Circle',1,1951), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',2,1935), -- ok
('National Board Of Review Award Al Miglior Attore Protagonista','NBRA',3,1952), -- ok
('National Board Of Review Award Al Miglior Attore','NBRA',3,1937), -- ok
('National Board Of Review Award Al Miglior Attore','NBRA',3,1944), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',4,1945), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',4,1957), -- ok
('Premio Oscar Per Migliore Attrice Non Protagonista','AMPAS',4,1975), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',4,1945), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',4,1946), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',4,1957), -- ok
('Premio BAFTA Migliore Attrice Non Protagonista','BAFTA',4,1975), -- ok
('David Di Donatello Per La Migliore Attrice Straniera','Accademia Del Cinema Italiano',4,1957), -- ok
('David Di Donatello Per La Migliore Attrice Straniera','Accademia Del Cinema Italiano',4,1979), -- ok
('Nastro Di Argento Per La Migliore Attrice Straniera In Italia','SNGCI',4,1951), -- ok
('Nastro Di Argento Per La Migliore Attrice Straniera In Italia','SNGCI',4,1953), -- ok
('Premio Cesar Onorario','Academie Des Arts Et Techniques Du Cinema',4,1976), -- ok
('David Di Donatello Per La Miglior Attrice Protagonista','Accademia Del Cinema Italiano',6,1962), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',7,1964), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',7,1965), -- ok
('David Di Donatello Premio Alla Carriera','Accademia Del Cinema Italiano',7,1983), -- ok
('David Di Donatello Per La Miglior Attrice Protagonista','Accademia Del Cinema Italiano',7,1986), -- ok
('David Di Donatello Medaglia Di Oro Del Comune Di Roma','Accademia Del Cinema Italiano',7,1986),
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',7,1988), -- ok
('David Di Donatello Per Il Miglior Attore Protagonista','Accademia Del Cinema Italiano',7,1995), -- ok
('David Di Donatello Premio Alla Carriera','Accademia Del Cinema Italiano',7,1997), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1955), -- ok 
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1958), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1961), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1962), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1986), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1988), -- ok
('Nastro Di Argento Per Il Miglior Attore Protagonista','SNGCI',7,1991), -- ok
('Nastro Di Argento Speciale','SNGCI',7,1997), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',7,1976), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',7,1977), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',7,1984), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',7,1986), -- ok
('Globo Di Oro Per Il Migliore Attore','Associazione Stampa Estera In Italia',7,1991), -- ok
('Grolla Di Oro Per Il Miglior Attore','Telegrolle',7,1955), -- ok
('Grolla Di Oro Per Il Miglior Attore','Telegrolle',7,1976), -- ok
('Grolla Di Oro Premio Speciale','Telegrolle',7,1978), -- ok
('Premio BAFTA Migliore Attore Internazione','BAFTA',7,1963),
('Premio BAFTA Migliore Attore Internazione','BAFTA',7,1964),
('Prix De Interprétation Masculine','Festival di Cannes',7,1970), -- ok
('Prix De Interprétation Masculine','Festival di Cannes',7,1987), -- ok
('Golden Globe Per Il Miglior Attore In Un Film Commedia O Musicale','HFPA/Golden Globe Foundation',7,1963), -- ok
('Premio Cesar Onorario','Academie Des Arts Et Techniques Du Cinema',7,1993), -- ok
('Golden Globe Per La Miglior Attrice Debuttante','HFPA/Golden Globe Foundation',8,1956), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',9,1955), -- ok
('Premio BAFTA Miglior Attore Protagonista','BAFTA',9,1973), -- ok
('Premio BAFTA Miglior Attore Protagonista','BAFTA',9,1953), -- ok
('Premio BAFTA Miglior Attore Protagonista','BAFTA',9,1955), -- ok
('Jussi Awards Come Miglior Attore','Filmiaura',9,1951), -- ok
('Jussi Awards Come Miglior Attore','Filmiaura',9,1952), -- ok
('Prix De Interprétation Masculine','Festival di Cannes',9,1953), -- ok
('New York Film Critics Circle Awards Per La Miglior Attrice Protagonista','New York Film Critics Circle',9,1954), -- ok
('David di Donatello Per Il Miglior Attore Straniero','Accademia Del Cinema Italiano',9,1958), -- ok
('Jussi Awards Alla Carriera','Filmiaura',9,2001), -- ok
('Premio Oscar Per Miglior Attore Protagonista','AMPAS',10,1993),-- ok 
('Golden Globe Alla Carriera','HFPA/Golden Globe Foundation',12,2002), -- ok
('Palma Di Oro Onoraria','Festival di Cannes',12,2023), -- ok
('Saturn Award Per Il Migliore Attore','Academy Of Science Fiction, Fantasy & Horror Films',12,1982), -- ok
('Saturn Award Life Achievement Award','Academy Of Science Fiction, Fantasy & Horror Films',12,1996), -- ok
('Saturn Award Per Il Migliore Attore','Academy Of Science Fiction, Fantasy & Horror Films',12,2016), -- ok
('People Choice Awards Per Il Migliore Star Maschile','People Choice Awards',12,1998), -- ok
('People Choice Awards Per Il Migliore Star Maschile','People Choice Awards',12,1999), -- ok
('People Choice Awards Per Il Migliore Star Maschile','People Choice Awards',12,2000), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',13,1994), -- ok
('Premio Oscar Per Migliore Attore','AMPAS',13,1995), -- ok
('Golden Globe Per Il Miglior Attore In Un Film Commedia O Musicale','HFPA/Golden Globe Foundation',13,1988), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',13,1994), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',13,1995), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',13,2001), -- ok
('Premio BAFTA Stanley Kubrick Britannia Award For Excellence','BAFTA',13,2004), -- ok
('Screen Actors Guild Awards Al Miglior Attore Protagonista','SAG-AFTRA',13,1995), -- ok
('Screen Actors Guild Awards Al Miglior Attore Protagonista','SAG-AFTRA',15,2016), -- ok
('Screen Actors Guild Awards Al Miglior Cast','SAG-AFTRA',13,1996), -- ok
('People Choice Awards Per Il Miglior Attore','People Choice Awards',13,1996), -- ok
('People Choice Awards Per Attore Preferito','People Choice Awards',13,2012), -- ok
('People Choice Awards Per Attore Preferito In Un Film Drammatico','People Choice Awards',13,2017), -- ok
('Razzie Awards Premio Peggior Coppia','Razzie Awards',13,2022), -- ok
('Premio Oscar Per Miglior Attore Protagonista','AMPAS',15,2014), -- ok
('Golden Globe Per Il Miglior Attore In Un Film Commedia O Musicale','HFPA/Golden Globe Foundation',15,2016), -- ok
('British Academy Film Awards Al Miglior Attore Protagonista','BAFA',15,2016), -- ok
('Razzie Awards Premio Peggior Coppia','Razzie Awards',15,1998), -- ok
('Premio Oscar Per Miglior Attrice','AMPAS',16,2009), -- ok
('Golden Globe Per La Migliore Attrice In Un Film Drammatico','HFPA/Golden Globe Foundation',16,2009), -- ok
('Golden Globe Per La Migliore Attrice Non Protagonista','HFPA/Golden Globe Foundation',16,2009), -- ok
('Golden Globe Per La Migliore Attrice Non Protagonista','HFPA/Golden Globe Foundation',16,2016), -- ok
('Golden Globe Per La Migliore Attrice Protagonista','HFPA/Golden Globe Foundation',16,2023), -- ok
('British Academy Film Awards Alla Migliore Attrice Non Protagonista','BAFA',16,1996), -- ok
('British Academy Film Awards Alla Migliore Attrice','BAFA',16,2009), -- ok
('British Academy Film Awards Alla Migliore Attrice Non Protagonista','BAFA',16,2016),
('British Academy Film Awards Alla Migliore Attrice Protagonista','BAFA',16,2023), -- ok
('Premio Emmy Alla Miglior Attrice','Academy of Television Arts & Sciences',16,2009), -- ok
('Premio Emmy Miglior Attore In Una Serie Drammatica','Academy of Television Arts & Sciences',17,1987), -- ok
('Razzie Awards Premio Peggior Attore Protagonista','Razzie Awards',17,1998), -- ok
('Critics Choice Awards Al Miglior Giovane Interprete','BFCA',18,2000), -- ok
('Young Artist Award Al Miglior Giovane Attore Sotto I 10 Anni','YAA',18,1995); -- ok

-- codec

INSERT INTO Codec VALUES
-- video
('H.264 (MPEG-4 Part 10 AVC)','Uno dei codec video più diffusi e offre una buona qualità video con dimensioni di file più piccole.'),
('H.265 (High Efficiency Video Coding)','Un codec video più recente e avanzato rispetto al H.264, che offre una migliore qualità video con dimensioni di file più ridotte.'),
('VP9','Un codec video open source sviluppato da Google per la compressione dei video su Internet.'),
('MPEG-2','Un codec comunemente usato per la trasmissione televisiva via cavo, satellitare e DVD.'),
('AV1','Un codec video open source sviluppato dalla Alliance for Open Media (AOMedia), progettato per fornire una migliore compressione e qualità video.'),
-- audio
('MP3 (MPEG-1 Audio Layer III)','Uno dei codec audio più comuni e ampiamente usati per la compressione dei file audio.'),
('AAC (Advanced Audio Coding)','Un codec audio ad alta efficienza utilizzato per la compressione dei file audio.'),
('Opus','Un codec audio open source sviluppato per la trasmissione vocale su Internet, con una buona qualità e flessibilità'),
('FLAC (Free Lossless Audio Codec)','Un codec audio senza perdita di qualità, che comprime lo audio mantenendo la integrità dei dati audio.'),
('Vbis','Un codec audio open source utilizzato spesso nel formato contenitore OGG.');

INSERT INTO Formato VALUES -- Id_Formato, Data_Aggiornamento, Bitrate, Tipo_Formato, Durata
-- video
(1,'2009-09-10 16:09:10',100000,'MP4',238), -- 100Mbps = 100000 kbps 
(2,'2023-07-12 18:20:12',100000,'AVI',102),
(3,'1991-12-18 07:53:18',100000,'MKV',116),
(4,'2013-05-11 05:43:11',100000,'MOV',174),
(5,'2010-04-28 02:02:28',100000,'WMV',175),
(6,'2004-10-28 22:34:28',100000,'MP4',121),
(7,'2011-09-22 23:33:22',100000,'AVI',142),
(8,'2014-06-05 06:43:05',100000,'MKV',195),
(9,'2002-07-03 23:07:03',100000,'MOV',107),
(10,'2001-09-03 00:39:03',100000,'WMV',201),
-- audio
(11,'2017-03-23 20:18:23',100000,'MP3',238),
(12,'1998-05-14 18:52:14',100000,'WAV',102),
(13,'2010-10-23 19:55:23',100000,'AAC',116),
(14,'2015-10-30 08:44:30',100000,'FLAC',174),
(15,'2001-01-25 09:05:25',100000,'OGG',175),
(16,'2020-03-13 03:58:13',100000,'M4A',121),
(17,'2018-02-13 17:27:13',100000,'MP3',142),
(18,'2003-08-11 16:26:11',100000,'WAV',195),
(19,'2018-12-21 20:00:21',100000,'AAC',107),
(20,'2021-06-17 15:26:17',100000,'FLAC',201);

INSERT INTO Aggiornamento VALUES -- Id_Formato, Data_Aggiornamento,File_Codec
-- video
(1,'2009-09-10 16:09:10','H.264 (MPEG-4 Part 10 AVC)'), -- 100Mbps = 100000 kbps 
(2,'2023-07-12 18:20:12','H.265 (High Efficiency Video Coding)'),
(3,'1991-12-18 07:53:18','VP9'),
(4,'2013-05-11 05:43:11','MPEG-2'),
(5,'2010-04-28 02:02:28','AV1'),
(6,'2004-10-28 22:34:28','H.264 (MPEG-4 Part 10 AVC)'),
(7,'2011-09-22 23:33:22','H.265 (High Efficiency Video Coding)'),
(8,'2014-06-05 06:43:05','VP9'),
(9,'2002-07-03 23:07:03','MPEG-2'),
(10,'2001-09-03 00:39:03','AV1'),
-- audio
(11,'2017-03-23 20:18:23','MP3 (MPEG-1 Audio Layer III)'),
(12,'1998-05-14 18:52:14','AAC (Advanced Audio Coding)'),
(13,'2010-10-23 19:55:23','Opus'),
(14,'2015-10-30 08:44:30','FLAC (Free Lossless Audio Codec)'),
(15,'2001-01-25 09:05:25','Vbis'),
(16,'2020-03-13 03:58:13','MP3 (MPEG-1 Audio Layer III)'),
(17,'2018-02-13 17:27:13','AAC (Advanced Audio Coding)'),
(18,'2003-08-11 16:26:11','Opus'),
(19,'2018-12-21 20:00:21','FLAC (Free Lossless Audio Codec)'),
(20,'2021-06-17 15:26:17','Vbis');

INSERT INTO Formato_Video VALUES -- `Qualita_Video`,Risoluzione, Larghezza(in pixel), Lunghezza(in pixel), Id_Formato,Data_Aggiornamento
(36,2160,1920,2160,1,'2009-09-10 16:09:10'), -- 100Mbps = 100000 kbps, che sono presenti in HD
(36,2160,1920,2160,2,'2023-07-12 18:20:12'), 
(36,2160,1920,2160,3,'1991-12-18 07:53:18'),
(36,2160,1920,2160,4,'2013-05-11 05:43:11'),
(36,2160,1920,2160,5,'2010-04-28 02:02:28'),
(36,2160,1920,2160,6,'2004-10-28 22:34:28'),
(36,2160,1920,2160,7,'2011-09-22 23:33:22'),
(36,2160,1920,2160,8,'2014-06-05 06:43:05'),
(36,2160,1920,2160,9,'2002-07-03 23:07:03'),
(36,2160,1920,2160,10,'2001-09-03 00:39:03');

INSERT INTO Formato_Audio VALUES
(96,11,'2017-03-23 20:18:23'),
(96,12,'1998-05-14 18:52:14'),
(96,13,'2010-10-23 19:55:23'),
(96,14,'2015-10-30 08:44:30'),
(96,15,'2001-01-25 09:05:25'),
(96,16,'2020-03-13 03:58:13'),
(96,17,'2018-02-13 17:27:13'),
(96,18,'2003-08-11 16:26:11'),
(96,19,'2018-12-21 20:00:21'),
(96,20,'2021-06-17 15:26:17');

INSERT INTO Film_Formato VALUES -- Id_Film, Id_Formato, Data_Aggiornamento, Data_Rilascio
(1,1,'2009-09-10 16:09:10','2010-10-28'), -- 100Mbps = 100000 kbps 
(2,2,'2023-07-12 18:20:12','2023-08-28'),
(3,3,'1991-12-18 07:53:18','1992-12-18'),
(4,4,'2013-05-11 05:43:11','2014-05-11'),
(5,5,'2010-04-28 02:02:28','2011-04-28'),
(6,6,'2004-10-28 22:34:28','2005-10-28'),
(7,7,'2011-09-22 23:33:22','2012-09-22'),
(8,8,'2014-06-05 06:43:05','2014-08-05'),
(9,9,'2002-07-03 23:07:03','2002-09-03'),
(10,10,'2001-09-03 00:39:03','2001-12-03'),
-- audio
(1,11,'2017-03-23 20:18:23','2017-04-23'),
(2,12,'1998-05-14 18:52:14','1998-06-14'),
(3,13,'2010-10-23 19:55:23','2010-12-23'),
(4,14,'2015-10-30 08:44:30','2016-01-30'),
(5,15,'2001-01-25 09:05:25','2001-08-25'),
(6,16,'2020-03-13 03:58:13','2020-06-13'),
(7,17,'2018-02-13 17:27:13','2018-08-13'),
(8,18,'2003-08-11 16:26:11','2003-10-11'),
(9,19,'2018-12-21 20:00:21','2018-02-21'),
(10,20,'2021-06-17 15:26:17','2021-08-17');

-- elenco stato e ammissione
INSERT INTO Elenco_Stato VALUES
("Italia",0),
("Francia",0),
("Spagnia",0),
("Portogallo",0),
("Germania",0),
("Polonia",0),
("Russia",0),
("Cina",0),
("Giappone",0),
("Corea",0),
("Afghanistan",0),
("Australia",0),
("Britannia",0),
("America",0),
("India",0),
("Canada",0),
("Norvegia",0),
("Filandia",0),
("Svezia",0),
("Romania",0),
("Grecia",0),
("Austria",0),
('Alabama',1),
('Alaska',1),
('Arizona',1),
('Arkansas',1),
('California',1),
('Colorado',1),
('Connecticut',1),
('Delaware',1),
('Florida',1),
('Georgia',1),
('Hawaii',1),
('Idaho',1),
('Illinois',1),
('Indiana',1),
('Iowa',1),
('Kansas',1),
('Kentucky',1),
('Louisiana',1),
('Maine',1),
('Maryland',1),
('Massachusetts',1),
('Michigan',1),
('Minnesota',1),
('Mississippi',1),
('Missouri',1),
('Montana',1),
('Nebraska',1),
('Nevada',1),
('New Hampshire',1),
('New Jersey',1),
('New Mexico',1),
('New York',1),
('North Carolina',1),
('North Dakota',1),
('Ohio',1),
('Oklahoma',1),
('Oregon',1),
('Pennsylvania',1),
('Rhode Island',1),
('South Carolina',1),
('South Dakota',1),
('Tennessee',1),
('Texas',1),
('Utah',1),
('Vermont',1),
('Virginia',1),
('Washington',1),
('West Virginia',1),
('Wisconsin',1),
('Wyoming',1);

INSERT INTO Ammissione VALUES -- Id_Formato, Data_Aggiornamento,Stato
(1,'2009-09-10 16:09:10',"Italia"),
(1,'2009-09-10 16:09:10',"Francia"),
(1,'2009-09-10 16:09:10',"Spagnia"),
(1,'2009-09-10 16:09:10',"Portogallo"),
(1,'2009-09-10 16:09:10',"Germania"),
(1,'2009-09-10 16:09:10',"Polonia"),
(1,'2009-09-10 16:09:10',"Russia"),
(1,'2009-09-10 16:09:10',"Cina"),
(1,'2009-09-10 16:09:10',"Giappone"),
(1,'2009-09-10 16:09:10',"Corea"),
(1,'2009-09-10 16:09:10',"Afghanistan"),
(1,'2009-09-10 16:09:10',"Australia"),
(1,'2009-09-10 16:09:10',"Britannia"),
(1,'2009-09-10 16:09:10',"America"),
(1,'2009-09-10 16:09:10',"India"),
(1,'2009-09-10 16:09:10',"Canada"),
(1,'2009-09-10 16:09:10',"Norvegia"),
(1,'2009-09-10 16:09:10',"Filandia"),
(1,'2009-09-10 16:09:10',"Svezia"),
(1,'2009-09-10 16:09:10',"Romania"),
(1,'2009-09-10 16:09:10',"Grecia"),
(1,'2009-09-10 16:09:10',"Austria"),
(1,'2009-09-10 16:09:10','Alabama'),
(1,'2009-09-10 16:09:10','Alaska'),
(1,'2009-09-10 16:09:10','Arizona'),
(1,'2009-09-10 16:09:10','Arkansas'),
(1,'2009-09-10 16:09:10','California'),
(1,'2009-09-10 16:09:10','Colorado'),
(1,'2009-09-10 16:09:10','Connecticut'),
(1,'2009-09-10 16:09:10','Delaware'),
(1,'2009-09-10 16:09:10','Florida'),
(1,'2009-09-10 16:09:10','Georgia'),
(1,'2009-09-10 16:09:10','Hawaii'),
(1,'2009-09-10 16:09:10','Idaho'),
(1,'2009-09-10 16:09:10','Illinois'),
(1,'2009-09-10 16:09:10','Indiana'),
(1,'2009-09-10 16:09:10','Iowa'),
(1,'2009-09-10 16:09:10','Kansas'),
(1,'2009-09-10 16:09:10','Kentucky'),
(1,'2009-09-10 16:09:10','Louisiana'),
(1,'2009-09-10 16:09:10','Maine'),
(1,'2009-09-10 16:09:10','Maryland'),
(1,'2009-09-10 16:09:10','Massachusetts'),
(1,'2009-09-10 16:09:10','Michigan'),
(1,'2009-09-10 16:09:10','Minnesota'),
(1,'2009-09-10 16:09:10','Mississippi'),
(1,'2009-09-10 16:09:10','Missouri'),
(1,'2009-09-10 16:09:10','Montana'),
(1,'2009-09-10 16:09:10','Nebraska'),
(1,'2009-09-10 16:09:10','Nevada'),
(1,'2009-09-10 16:09:10','New Hampshire'),
(1,'2009-09-10 16:09:10','New Jersey'),
(1,'2009-09-10 16:09:10','New Mexico'),
(1,'2009-09-10 16:09:10','New York'),
(1,'2009-09-10 16:09:10','North Carolina'),
(1,'2009-09-10 16:09:10','North Dakota'),
(1,'2009-09-10 16:09:10','Ohio'),
(1,'2009-09-10 16:09:10','Oklahoma'),
(1,'2009-09-10 16:09:10','Oregon'),
(1,'2009-09-10 16:09:10','Pennsylvania'),
(1,'2009-09-10 16:09:10','Rhode Island'),
(1,'2009-09-10 16:09:10','South Carolina'),
(1,'2009-09-10 16:09:10','South Dakota'),
(1,'2009-09-10 16:09:10','Tennessee'),
(1,'2009-09-10 16:09:10','Texas'),
(1,'2009-09-10 16:09:10','Utah'),
(1,'2009-09-10 16:09:10','Vermont'),
(1,'2009-09-10 16:09:10','Virginia'),
(1,'2009-09-10 16:09:10','Washington'),
(1,'2009-09-10 16:09:10','West Virginia'),
(1,'2009-09-10 16:09:10','Wisconsin'),
(1,'2009-09-10 16:09:10','Wyoming'),
(2,'2023-07-12 18:20:12',"Italia"),
(2,'2023-07-12 18:20:12',"Francia"),
(2,'2023-07-12 18:20:12',"Spagnia"),
(2,'2023-07-12 18:20:12',"Portogallo"),
(2,'2023-07-12 18:20:12',"Germania"),
(2,'2023-07-12 18:20:12',"Polonia"),
(2,'2023-07-12 18:20:12',"Russia"),
(2,'2023-07-12 18:20:12',"Cina"),
(2,'2023-07-12 18:20:12',"Giappone"),
(2,'2023-07-12 18:20:12',"Corea"),
(2,'2023-07-12 18:20:12',"Afghanistan"),
(2,'2023-07-12 18:20:12',"Australia"),
(2,'2023-07-12 18:20:12',"Britannia"),
(2,'2023-07-12 18:20:12',"America"),
(2,'2023-07-12 18:20:12',"India"),
(2,'2023-07-12 18:20:12',"Canada"),
(2,'2023-07-12 18:20:12',"Norvegia"),
(2,'2023-07-12 18:20:12',"Filandia"),
(2,'2023-07-12 18:20:12',"Svezia"),
(2,'2023-07-12 18:20:12',"Romania"),
(2,'2023-07-12 18:20:12',"Grecia"),
(2,'2023-07-12 18:20:12',"Austria"),
(2,'2023-07-12 18:20:12','Alabama'),
(2,'2023-07-12 18:20:12','Alaska'),
(2,'2023-07-12 18:20:12','Arizona'),
(2,'2023-07-12 18:20:12','Arkansas'),
(2,'2023-07-12 18:20:12','California'),
(2,'2023-07-12 18:20:12','Colorado'),
(2,'2023-07-12 18:20:12','Connecticut'),
(2,'2023-07-12 18:20:12','Delaware'),
(2,'2023-07-12 18:20:12','Florida'),
(2,'2023-07-12 18:20:12','Georgia'),
(2,'2023-07-12 18:20:12','Hawaii'),
(2,'2023-07-12 18:20:12','Idaho'),
(2,'2023-07-12 18:20:12','Illinois'),
(2,'2023-07-12 18:20:12','Indiana'),
(2,'2023-07-12 18:20:12','Iowa'),
(2,'2023-07-12 18:20:12','Kansas'),
(2,'2023-07-12 18:20:12','Kentucky'),
(2,'2023-07-12 18:20:12','Louisiana'),
(2,'2023-07-12 18:20:12','Maine'),
(2,'2023-07-12 18:20:12','Maryland'),
(2,'2023-07-12 18:20:12','Massachusetts'),
(2,'2023-07-12 18:20:12','Michigan'),
(2,'2023-07-12 18:20:12','Minnesota'),
(2,'2023-07-12 18:20:12','Mississippi'),
(2,'2023-07-12 18:20:12','Missouri'),
(2,'2023-07-12 18:20:12','Montana'),
(2,'2023-07-12 18:20:12','Nebraska'),
(2,'2023-07-12 18:20:12','Nevada'),
(2,'2023-07-12 18:20:12','New Hampshire'),
(2,'2023-07-12 18:20:12','New Jersey'),
(2,'2023-07-12 18:20:12','New Mexico'),
(2,'2023-07-12 18:20:12','New York'),
(2,'2023-07-12 18:20:12','North Carolina'),
(2,'2023-07-12 18:20:12','North Dakota'),
(2,'2023-07-12 18:20:12','Ohio'),
(2,'2023-07-12 18:20:12','Oklahoma'),
(2,'2023-07-12 18:20:12','Oregon'),
(2,'2023-07-12 18:20:12','Pennsylvania'),
(2,'2023-07-12 18:20:12','Rhode Island'),
(2,'2023-07-12 18:20:12','South Carolina'),
(2,'2023-07-12 18:20:12','South Dakota'),
(2,'2023-07-12 18:20:12','Tennessee'),
(2,'2023-07-12 18:20:12','Texas'),
(2,'2023-07-12 18:20:12','Utah'),
(2,'2023-07-12 18:20:12','Vermont'),
(2,'2023-07-12 18:20:12','Virginia'),
(2,'2023-07-12 18:20:12','Washington'),
(2,'2023-07-12 18:20:12','West Virginia'),
(2,'2023-07-12 18:20:12','Wisconsin'),
(2,'2023-07-12 18:20:12','Wyoming'),
(3,'1991-12-18 07:53:18',"Italia"), 
(3,'1991-12-18 07:53:18',"Francia"),
(3,'1991-12-18 07:53:18',"Spagnia"),
(3,'1991-12-18 07:53:18',"Portogallo"),
(3,'1991-12-18 07:53:18',"Germania"),
(3,'1991-12-18 07:53:18',"Polonia"),
(3,'1991-12-18 07:53:18',"Russia"),
(3,'1991-12-18 07:53:18',"Cina"),
(3,'1991-12-18 07:53:18',"Giappone"),
(3,'1991-12-18 07:53:18',"Corea"),
(3,'1991-12-18 07:53:18',"Afghanistan"),
(3,'1991-12-18 07:53:18',"Australia"),
(3,'1991-12-18 07:53:18',"Britannia"),
(3,'1991-12-18 07:53:18',"America"),
(3,'1991-12-18 07:53:18',"India"),
(3,'1991-12-18 07:53:18',"Canada"),
(3,'1991-12-18 07:53:18',"Norvegia"),
(3,'1991-12-18 07:53:18',"Filandia"),
(3,'1991-12-18 07:53:18',"Svezia"),
(3,'1991-12-18 07:53:18',"Romania"),
(3,'1991-12-18 07:53:18',"Grecia"),
(3,'1991-12-18 07:53:18',"Austria"),
(3,'1991-12-18 07:53:18','Alabama'),
(3,'1991-12-18 07:53:18','Alaska'),
(3,'1991-12-18 07:53:18','Arizona'),
(3,'1991-12-18 07:53:18','Arkansas'),
(3,'1991-12-18 07:53:18','California'),
(3,'1991-12-18 07:53:18','Colorado'),
(3,'1991-12-18 07:53:18','Connecticut'),
(3,'1991-12-18 07:53:18','Delaware'),
(3,'1991-12-18 07:53:18','Florida'),
(3,'1991-12-18 07:53:18','Georgia'),
(3,'1991-12-18 07:53:18','Hawaii'),
(3,'1991-12-18 07:53:18','Idaho'),
(3,'1991-12-18 07:53:18','Illinois'),
(3,'1991-12-18 07:53:18','Indiana'),
(3,'1991-12-18 07:53:18','Iowa'),
(3,'1991-12-18 07:53:18','Kansas'),
(3,'1991-12-18 07:53:18','Kentucky'),
(3,'1991-12-18 07:53:18','Louisiana'),
(3,'1991-12-18 07:53:18','Maine'),
(3,'1991-12-18 07:53:18','Maryland'),
(3,'1991-12-18 07:53:18','Massachusetts'),
(3,'1991-12-18 07:53:18','Michigan'),
(3,'1991-12-18 07:53:18','Minnesota'),
(3,'1991-12-18 07:53:18','Mississippi'),
(3,'1991-12-18 07:53:18','Missouri'),
(3,'1991-12-18 07:53:18','Montana'),
(3,'1991-12-18 07:53:18','Nebraska'),
(3,'1991-12-18 07:53:18','Nevada'),
(3,'1991-12-18 07:53:18','New Hampshire'),
(3,'1991-12-18 07:53:18','New Jersey'),
(3,'1991-12-18 07:53:18','New Mexico'),
(3,'1991-12-18 07:53:18','New York'),
(3,'1991-12-18 07:53:18','North Carolina'),
(3,'1991-12-18 07:53:18','North Dakota'),
(3,'1991-12-18 07:53:18','Ohio'),
(3,'1991-12-18 07:53:18','Oklahoma'),
(3,'1991-12-18 07:53:18','Oregon'),
(3,'1991-12-18 07:53:18','Pennsylvania'),
(3,'1991-12-18 07:53:18','Rhode Island'),
(3,'1991-12-18 07:53:18','South Carolina'),
(3,'1991-12-18 07:53:18','South Dakota'),
(3,'1991-12-18 07:53:18','Tennessee'),
(3,'1991-12-18 07:53:18','Texas'),
(3,'1991-12-18 07:53:18','Utah'),
(3,'1991-12-18 07:53:18','Vermont'),
(3,'1991-12-18 07:53:18','Virginia'),
(3,'1991-12-18 07:53:18','Washington'),
(3,'1991-12-18 07:53:18','West Virginia'),
(3,'1991-12-18 07:53:18','Wisconsin'),
(3,'1991-12-18 07:53:18','Wyoming'),
(4,'2013-05-11 05:43:11',"Italia"),
(4,'2013-05-11 05:43:11',"Francia"),
(4,'2013-05-11 05:43:11',"Spagnia"),
(4,'2013-05-11 05:43:11',"Portogallo"),
(4,'2013-05-11 05:43:11',"Germania"),
(4,'2013-05-11 05:43:11',"Polonia"),
(4,'2013-05-11 05:43:11',"Russia"),
(4,'2013-05-11 05:43:11',"Cina"),
(4,'2013-05-11 05:43:11',"Giappone"),
(4,'2013-05-11 05:43:11',"Corea"),
(4,'2013-05-11 05:43:11',"Afghanistan"),
(4,'2013-05-11 05:43:11',"Australia"),
(4,'2013-05-11 05:43:11',"Britannia"),
(4,'2013-05-11 05:43:11',"America"),
(4,'2013-05-11 05:43:11',"India"),
(4,'2013-05-11 05:43:11',"Canada"),
(4,'2013-05-11 05:43:11',"Norvegia"),
(4,'2013-05-11 05:43:11',"Filandia"),
(4,'2013-05-11 05:43:11',"Svezia"),
(4,'2013-05-11 05:43:11',"Romania"),
(4,'2013-05-11 05:43:11',"Grecia"),
(4,'2013-05-11 05:43:11',"Austria"),
(4,'2013-05-11 05:43:11','Alabama'),
(4,'2013-05-11 05:43:11','Alaska'),
(4,'2013-05-11 05:43:11','Arizona'),
(4,'2013-05-11 05:43:11','Arkansas'),
(4,'2013-05-11 05:43:11','California'),
(4,'2013-05-11 05:43:11','Colorado'),
(4,'2013-05-11 05:43:11','Connecticut'),
(4,'2013-05-11 05:43:11','Delaware'),
(4,'2013-05-11 05:43:11','Florida'),
(4,'2013-05-11 05:43:11','Georgia'),
(4,'2013-05-11 05:43:11','Hawaii'),
(4,'2013-05-11 05:43:11','Idaho'),
(4,'2013-05-11 05:43:11','Illinois'),
(4,'2013-05-11 05:43:11','Indiana'),
(4,'2013-05-11 05:43:11','Iowa'),
(4,'2013-05-11 05:43:11','Kansas'),
(4,'2013-05-11 05:43:11','Kentucky'),
(4,'2013-05-11 05:43:11','Louisiana'),
(4,'2013-05-11 05:43:11','Maine'),
(4,'2013-05-11 05:43:11','Maryland'),
(4,'2013-05-11 05:43:11','Massachusetts'),
(4,'2013-05-11 05:43:11','Michigan'),
(4,'2013-05-11 05:43:11','Minnesota'),
(4,'2013-05-11 05:43:11','Mississippi'),
(4,'2013-05-11 05:43:11','Missouri'),
(4,'2013-05-11 05:43:11','Montana'),
(4,'2013-05-11 05:43:11','Nebraska'),
(4,'2013-05-11 05:43:11','Nevada'),
(4,'2013-05-11 05:43:11','New Hampshire'),
(4,'2013-05-11 05:43:11','New Jersey'),
(4,'2013-05-11 05:43:11','New Mexico'),
(4,'2013-05-11 05:43:11','New York'),
(4,'2013-05-11 05:43:11','North Carolina'),
(4,'2013-05-11 05:43:11','North Dakota'),
(4,'2013-05-11 05:43:11','Ohio'),
(4,'2013-05-11 05:43:11','Oklahoma'),
(4,'2013-05-11 05:43:11','Oregon'),
(4,'2013-05-11 05:43:11','Pennsylvania'),
(4,'2013-05-11 05:43:11','Rhode Island'),
(4,'2013-05-11 05:43:11','South Carolina'),
(4,'2013-05-11 05:43:11','South Dakota'),
(4,'2013-05-11 05:43:11','Tennessee'),
(4,'2013-05-11 05:43:11','Texas'),
(4,'2013-05-11 05:43:11','Utah'),
(4,'2013-05-11 05:43:11','Vermont'),
(4,'2013-05-11 05:43:11','Virginia'),
(4,'2013-05-11 05:43:11','Washington'),
(4,'2013-05-11 05:43:11','West Virginia'),
(4,'2013-05-11 05:43:11','Wisconsin'),
(4,'2013-05-11 05:43:11','Wyoming'),
(5,'2010-04-28 02:02:28',"Italia"),
(5,'2010-04-28 02:02:28',"Francia"),
(5,'2010-04-28 02:02:28',"Spagnia"),
(5,'2010-04-28 02:02:28',"Portogallo"),
(5,'2010-04-28 02:02:28',"Germania"),
(5,'2010-04-28 02:02:28',"Polonia"),
(5,'2010-04-28 02:02:28',"Russia"),
(5,'2010-04-28 02:02:28',"Cina"),
(5,'2010-04-28 02:02:28',"Giappone"),
(5,'2010-04-28 02:02:28',"Corea"),
(5,'2010-04-28 02:02:28',"Afghanistan"),
(5,'2010-04-28 02:02:28',"Australia"),
(5,'2010-04-28 02:02:28',"Britannia"),
(5,'2010-04-28 02:02:28',"America"),
(5,'2010-04-28 02:02:28',"India"),
(5,'2010-04-28 02:02:28',"Canada"),
(5,'2010-04-28 02:02:28',"Norvegia"),
(5,'2010-04-28 02:02:28',"Filandia"),
(5,'2010-04-28 02:02:28',"Svezia"),
(5,'2010-04-28 02:02:28',"Romania"),
(5,'2010-04-28 02:02:28',"Grecia"),
(5,'2010-04-28 02:02:28',"Austria"),
(5,'2010-04-28 02:02:28','Alabama'),
(5,'2010-04-28 02:02:28','Alaska'),
(5,'2010-04-28 02:02:28','Arizona'),
(5,'2010-04-28 02:02:28','Arkansas'),
(5,'2010-04-28 02:02:28','California'),
(5,'2010-04-28 02:02:28','Colorado'),
(5,'2010-04-28 02:02:28','Connecticut'),
(5,'2010-04-28 02:02:28','Delaware'),
(5,'2010-04-28 02:02:28','Florida'),
(5,'2010-04-28 02:02:28','Georgia'),
(5,'2010-04-28 02:02:28','Hawaii'),
(5,'2010-04-28 02:02:28','Idaho'),
(5,'2010-04-28 02:02:28','Illinois'),
(5,'2010-04-28 02:02:28','Indiana'),
(5,'2010-04-28 02:02:28','Iowa'),
(5,'2010-04-28 02:02:28','Kansas'),
(5,'2010-04-28 02:02:28','Kentucky'),
(5,'2010-04-28 02:02:28','Louisiana'),
(5,'2010-04-28 02:02:28','Maine'),
(5,'2010-04-28 02:02:28','Maryland'),
(5,'2010-04-28 02:02:28','Massachusetts'),
(5,'2010-04-28 02:02:28','Michigan'),
(5,'2010-04-28 02:02:28','Minnesota'),
(5,'2010-04-28 02:02:28','Mississippi'),
(5,'2010-04-28 02:02:28','Missouri'),
(5,'2010-04-28 02:02:28','Montana'),
(5,'2010-04-28 02:02:28','Nebraska'),
(5,'2010-04-28 02:02:28','Nevada'),
(5,'2010-04-28 02:02:28','New Hampshire'),
(5,'2010-04-28 02:02:28','New Jersey'),
(5,'2010-04-28 02:02:28','New Mexico'),
(5,'2010-04-28 02:02:28','New York'),
(5,'2010-04-28 02:02:28','North Carolina'),
(5,'2010-04-28 02:02:28','North Dakota'),
(5,'2010-04-28 02:02:28','Ohio'),
(5,'2010-04-28 02:02:28','Oklahoma'),
(5,'2010-04-28 02:02:28','Oregon'),
(5,'2010-04-28 02:02:28','Pennsylvania'),
(5,'2010-04-28 02:02:28','Rhode Island'),
(5,'2010-04-28 02:02:28','South Carolina'),
(5,'2010-04-28 02:02:28','South Dakota'),
(5,'2010-04-28 02:02:28','Tennessee'),
(5,'2010-04-28 02:02:28','Texas'),
(5,'2010-04-28 02:02:28','Utah'),
(5,'2010-04-28 02:02:28','Vermont'),
(5,'2010-04-28 02:02:28','Virginia'),
(5,'2010-04-28 02:02:28','Washington'),
(5,'2010-04-28 02:02:28','West Virginia'),
(5,'2010-04-28 02:02:28','Wisconsin'),
(5,'2010-04-28 02:02:28','Wyoming'),
(6,'2004-10-28 22:34:28',"Italia"),
(6,'2004-10-28 22:34:28',"Francia"),
(6,'2004-10-28 22:34:28',"Spagnia"),
(6,'2004-10-28 22:34:28',"Portogallo"),
(6,'2004-10-28 22:34:28',"Germania"),
(6,'2004-10-28 22:34:28',"Polonia"),
(6,'2004-10-28 22:34:28',"Russia"),
(6,'2004-10-28 22:34:28',"Cina"),
(6,'2004-10-28 22:34:28',"Giappone"),
(6,'2004-10-28 22:34:28',"Corea"),
(6,'2004-10-28 22:34:28',"Afghanistan"),
(6,'2004-10-28 22:34:28',"Australia"),
(6,'2004-10-28 22:34:28',"Britannia"),
(6,'2004-10-28 22:34:28',"America"),
(6,'2004-10-28 22:34:28',"India"),
(6,'2004-10-28 22:34:28',"Canada"),
(6,'2004-10-28 22:34:28',"Norvegia"),
(6,'2004-10-28 22:34:28',"Filandia"),
(6,'2004-10-28 22:34:28',"Svezia"),
(6,'2004-10-28 22:34:28',"Romania"),
(6,'2004-10-28 22:34:28',"Grecia"),
(6,'2004-10-28 22:34:28',"Austria"),
(6,'2004-10-28 22:34:28','Alabama'),
(6,'2004-10-28 22:34:28','Alaska'),
(6,'2004-10-28 22:34:28','Arizona'),
(6,'2004-10-28 22:34:28','Arkansas'),
(6,'2004-10-28 22:34:28','California'),
(6,'2004-10-28 22:34:28','Colorado'),
(6,'2004-10-28 22:34:28','Connecticut'),
(6,'2004-10-28 22:34:28','Delaware'),
(6,'2004-10-28 22:34:28','Florida'),
(6,'2004-10-28 22:34:28','Georgia'),
(6,'2004-10-28 22:34:28','Hawaii'),
(6,'2004-10-28 22:34:28','Idaho'),
(6,'2004-10-28 22:34:28','Illinois'),
(6,'2004-10-28 22:34:28','Indiana'),
(6,'2004-10-28 22:34:28','Iowa'),
(6,'2004-10-28 22:34:28','Kansas'),
(6,'2004-10-28 22:34:28','Kentucky'),
(6,'2004-10-28 22:34:28','Louisiana'),
(6,'2004-10-28 22:34:28','Maine'),
(6,'2004-10-28 22:34:28','Maryland'),
(6,'2004-10-28 22:34:28','Massachusetts'),
(6,'2004-10-28 22:34:28','Michigan'),
(6,'2004-10-28 22:34:28','Minnesota'),
(6,'2004-10-28 22:34:28','Mississippi'),
(6,'2004-10-28 22:34:28','Missouri'),
(6,'2004-10-28 22:34:28','Montana'),
(6,'2004-10-28 22:34:28','Nebraska'),
(6,'2004-10-28 22:34:28','Nevada'),
(6,'2004-10-28 22:34:28','New Hampshire'),
(6,'2004-10-28 22:34:28','New Jersey'),
(6,'2004-10-28 22:34:28','New Mexico'),
(6,'2004-10-28 22:34:28','New York'),
(6,'2004-10-28 22:34:28','North Carolina'),
(6,'2004-10-28 22:34:28','North Dakota'),
(6,'2004-10-28 22:34:28','Ohio'),
(6,'2004-10-28 22:34:28','Oklahoma'),
(6,'2004-10-28 22:34:28','Oregon'),
(6,'2004-10-28 22:34:28','Pennsylvania'),
(6,'2004-10-28 22:34:28','Rhode Island'),
(6,'2004-10-28 22:34:28','South Carolina'),
(6,'2004-10-28 22:34:28','South Dakota'),
(6,'2004-10-28 22:34:28','Tennessee'),
(6,'2004-10-28 22:34:28','Texas'),
(6,'2004-10-28 22:34:28','Utah'),
(6,'2004-10-28 22:34:28','Vermont'),
(6,'2004-10-28 22:34:28','Virginia'),
(6,'2004-10-28 22:34:28','Washington'),
(6,'2004-10-28 22:34:28','West Virginia'),
(6,'2004-10-28 22:34:28','Wisconsin'),
(6,'2004-10-28 22:34:28','Wyoming'),
(7,'2011-09-22 23:33:22',"Italia"),
(7,'2011-09-22 23:33:22',"Francia"),
(7,'2011-09-22 23:33:22',"Spagnia"),
(7,'2011-09-22 23:33:22',"Portogallo"),
(7,'2011-09-22 23:33:22',"Germania"),
(7,'2011-09-22 23:33:22',"Polonia"),
(7,'2011-09-22 23:33:22',"Russia"),
(7,'2011-09-22 23:33:22',"Cina"),
(7,'2011-09-22 23:33:22',"Giappone"),
(7,'2011-09-22 23:33:22',"Corea"),
(7,'2011-09-22 23:33:22',"Afghanistan"),
(7,'2011-09-22 23:33:22',"Australia"),
(7,'2011-09-22 23:33:22',"Britannia"),
(7,'2011-09-22 23:33:22',"America"),
(7,'2011-09-22 23:33:22',"India"),
(7,'2011-09-22 23:33:22',"Canada"),
(7,'2011-09-22 23:33:22',"Norvegia"),
(7,'2011-09-22 23:33:22',"Filandia"),
(7,'2011-09-22 23:33:22',"Svezia"),
(7,'2011-09-22 23:33:22',"Romania"),
(7,'2011-09-22 23:33:22',"Grecia"),
(7,'2011-09-22 23:33:22',"Austria"),
(7,'2011-09-22 23:33:22','Alabama'),
(7,'2011-09-22 23:33:22','Alaska'),
(7,'2011-09-22 23:33:22','Arizona'),
(7,'2011-09-22 23:33:22','Arkansas'),
(7,'2011-09-22 23:33:22','California'),
(7,'2011-09-22 23:33:22','Colorado'),
(7,'2011-09-22 23:33:22','Connecticut'),
(7,'2011-09-22 23:33:22','Delaware'),
(7,'2011-09-22 23:33:22','Florida'),
(7,'2011-09-22 23:33:22','Georgia'),
(7,'2011-09-22 23:33:22','Hawaii'),
(7,'2011-09-22 23:33:22','Idaho'),
(7,'2011-09-22 23:33:22','Illinois'),
(7,'2011-09-22 23:33:22','Indiana'),
(7,'2011-09-22 23:33:22','Iowa'),
(7,'2011-09-22 23:33:22','Kansas'),
(7,'2011-09-22 23:33:22','Kentucky'),
(7,'2011-09-22 23:33:22','Louisiana'),
(7,'2011-09-22 23:33:22','Maine'),
(7,'2011-09-22 23:33:22','Maryland'),
(7,'2011-09-22 23:33:22','Massachusetts'),
(7,'2011-09-22 23:33:22','Michigan'),
(7,'2011-09-22 23:33:22','Minnesota'),
(7,'2011-09-22 23:33:22','Mississippi'),
(7,'2011-09-22 23:33:22','Missouri'),
(7,'2011-09-22 23:33:22','Montana'),
(7,'2011-09-22 23:33:22','Nebraska'),
(7,'2011-09-22 23:33:22','Nevada'),
(7,'2011-09-22 23:33:22','New Hampshire'),
(7,'2011-09-22 23:33:22','New Jersey'),
(7,'2011-09-22 23:33:22','New Mexico'),
(7,'2011-09-22 23:33:22','New York'),
(7,'2011-09-22 23:33:22','North Carolina'),
(7,'2011-09-22 23:33:22','North Dakota'),
(7,'2011-09-22 23:33:22','Ohio'),
(7,'2011-09-22 23:33:22','Oklahoma'),
(7,'2011-09-22 23:33:22','Oregon'),
(7,'2011-09-22 23:33:22','Pennsylvania'),
(7,'2011-09-22 23:33:22','Rhode Island'),
(7,'2011-09-22 23:33:22','South Carolina'),
(7,'2011-09-22 23:33:22','South Dakota'),
(7,'2011-09-22 23:33:22','Tennessee'),
(7,'2011-09-22 23:33:22','Texas'),
(7,'2011-09-22 23:33:22','Utah'),
(7,'2011-09-22 23:33:22','Vermont'),
(7,'2011-09-22 23:33:22','Virginia'),
(7,'2011-09-22 23:33:22','Washington'),
(7,'2011-09-22 23:33:22','West Virginia'),
(7,'2011-09-22 23:33:22','Wisconsin'),
(7,'2011-09-22 23:33:22','Wyoming'),
(8,'2014-06-05 06:43:05',"Italia"),
(8,'2014-06-05 06:43:05',"Francia"),
(8,'2014-06-05 06:43:05',"Spagnia"),
(8,'2014-06-05 06:43:05',"Portogallo"),
(8,'2014-06-05 06:43:05',"Germania"),
(8,'2014-06-05 06:43:05',"Polonia"),
(8,'2014-06-05 06:43:05',"Russia"),
(8,'2014-06-05 06:43:05',"Cina"),
(8,'2014-06-05 06:43:05',"Giappone"),
(8,'2014-06-05 06:43:05',"Corea"),
(8,'2014-06-05 06:43:05',"Afghanistan"),
(8,'2014-06-05 06:43:05',"Australia"),
(8,'2014-06-05 06:43:05',"Britannia"),
(8,'2014-06-05 06:43:05',"America"),
(8,'2014-06-05 06:43:05',"India"),
(8,'2014-06-05 06:43:05',"Canada"),
(8,'2014-06-05 06:43:05',"Norvegia"),
(8,'2014-06-05 06:43:05',"Filandia"),
(8,'2014-06-05 06:43:05',"Svezia"),
(8,'2014-06-05 06:43:05',"Romania"),
(8,'2014-06-05 06:43:05',"Grecia"),
(8,'2014-06-05 06:43:05',"Austria"),
(8,'2014-06-05 06:43:05','Alabama'),
(8,'2014-06-05 06:43:05','Alaska'),
(8,'2014-06-05 06:43:05','Arizona'),
(8,'2014-06-05 06:43:05','Arkansas'),
(8,'2014-06-05 06:43:05','California'),
(8,'2014-06-05 06:43:05','Colorado'),
(8,'2014-06-05 06:43:05','Connecticut'),
(8,'2014-06-05 06:43:05','Delaware'),
(8,'2014-06-05 06:43:05','Florida'),
(8,'2014-06-05 06:43:05','Georgia'),
(8,'2014-06-05 06:43:05','Hawaii'),
(8,'2014-06-05 06:43:05','Idaho'),
(8,'2014-06-05 06:43:05','Illinois'),
(8,'2014-06-05 06:43:05','Indiana'),
(8,'2014-06-05 06:43:05','Iowa'),
(8,'2014-06-05 06:43:05','Kansas'),
(8,'2014-06-05 06:43:05','Kentucky'),
(8,'2014-06-05 06:43:05','Louisiana'),
(8,'2014-06-05 06:43:05','Maine'),
(8,'2014-06-05 06:43:05','Maryland'),
(8,'2014-06-05 06:43:05','Massachusetts'),
(8,'2014-06-05 06:43:05','Michigan'),
(8,'2014-06-05 06:43:05','Minnesota'),
(8,'2014-06-05 06:43:05','Mississippi'),
(8,'2014-06-05 06:43:05','Missouri'),
(8,'2014-06-05 06:43:05','Montana'),
(8,'2014-06-05 06:43:05','Nebraska'),
(8,'2014-06-05 06:43:05','Nevada'),
(8,'2014-06-05 06:43:05','New Hampshire'),
(8,'2014-06-05 06:43:05','New Jersey'),
(8,'2014-06-05 06:43:05','New Mexico'),
(8,'2014-06-05 06:43:05','New York'),
(8,'2014-06-05 06:43:05','North Carolina'),
(8,'2014-06-05 06:43:05','North Dakota'),
(8,'2014-06-05 06:43:05','Ohio'),
(8,'2014-06-05 06:43:05','Oklahoma'),
(8,'2014-06-05 06:43:05','Oregon'),
(8,'2014-06-05 06:43:05','Pennsylvania'),
(8,'2014-06-05 06:43:05','Rhode Island'),
(8,'2014-06-05 06:43:05','South Carolina'),
(8,'2014-06-05 06:43:05','South Dakota'),
(8,'2014-06-05 06:43:05','Tennessee'),
(8,'2014-06-05 06:43:05','Texas'),
(8,'2014-06-05 06:43:05','Utah'),
(8,'2014-06-05 06:43:05','Vermont'),
(8,'2014-06-05 06:43:05','Virginia'),
(8,'2014-06-05 06:43:05','Washington'),
(8,'2014-06-05 06:43:05','West Virginia'),
(8,'2014-06-05 06:43:05','Wisconsin'),
(8,'2014-06-05 06:43:05','Wyoming'),
(9,'2002-07-03 23:07:03',"Italia"),
(9,'2002-07-03 23:07:03',"Francia"),
(9,'2002-07-03 23:07:03',"Spagnia"),
(9,'2002-07-03 23:07:03',"Portogallo"),
(9,'2002-07-03 23:07:03',"Germania"),
(9,'2002-07-03 23:07:03',"Polonia"),
(9,'2002-07-03 23:07:03',"Russia"),
(9,'2002-07-03 23:07:03',"Cina"),
(9,'2002-07-03 23:07:03',"Giappone"),
(9,'2002-07-03 23:07:03',"Corea"),
(9,'2002-07-03 23:07:03',"Afghanistan"),
(9,'2002-07-03 23:07:03',"Australia"),
(9,'2002-07-03 23:07:03',"Britannia"),
(9,'2002-07-03 23:07:03',"America"),
(9,'2002-07-03 23:07:03',"India"),
(9,'2002-07-03 23:07:03',"Canada"),
(9,'2002-07-03 23:07:03',"Norvegia"),
(9,'2002-07-03 23:07:03',"Filandia"),
(9,'2002-07-03 23:07:03',"Svezia"),
(9,'2002-07-03 23:07:03',"Romania"),
(9,'2002-07-03 23:07:03',"Grecia"),
(9,'2002-07-03 23:07:03',"Austria"),
(9,'2002-07-03 23:07:03','Alabama'),
(9,'2002-07-03 23:07:03','Alaska'),
(9,'2002-07-03 23:07:03','Arizona'),
(9,'2002-07-03 23:07:03','Arkansas'),
(9,'2002-07-03 23:07:03','California'),
(9,'2002-07-03 23:07:03','Colorado'),
(9,'2002-07-03 23:07:03','Connecticut'),
(9,'2002-07-03 23:07:03','Delaware'),
(9,'2002-07-03 23:07:03','Florida'),
(9,'2002-07-03 23:07:03','Georgia'),
(9,'2002-07-03 23:07:03','Hawaii'),
(9,'2002-07-03 23:07:03','Idaho'),
(9,'2002-07-03 23:07:03','Illinois'),
(9,'2002-07-03 23:07:03','Indiana'),
(9,'2002-07-03 23:07:03','Iowa'),
(9,'2002-07-03 23:07:03','Kansas'),
(9,'2002-07-03 23:07:03','Kentucky'),
(9,'2002-07-03 23:07:03','Louisiana'),
(9,'2002-07-03 23:07:03','Maine'),
(9,'2002-07-03 23:07:03','Maryland'),
(9,'2002-07-03 23:07:03','Massachusetts'),
(9,'2002-07-03 23:07:03','Michigan'),
(9,'2002-07-03 23:07:03','Minnesota'),
(9,'2002-07-03 23:07:03','Mississippi'),
(9,'2002-07-03 23:07:03','Missouri'),
(9,'2002-07-03 23:07:03','Montana'),
(9,'2002-07-03 23:07:03','Nebraska'),
(9,'2002-07-03 23:07:03','Nevada'),
(9,'2002-07-03 23:07:03','New Hampshire'),
(9,'2002-07-03 23:07:03','New Jersey'),
(9,'2002-07-03 23:07:03','New Mexico'),
(9,'2002-07-03 23:07:03','New York'),
(9,'2002-07-03 23:07:03','North Carolina'),
(9,'2002-07-03 23:07:03','North Dakota'),
(9,'2002-07-03 23:07:03','Ohio'),
(9,'2002-07-03 23:07:03','Oklahoma'),
(9,'2002-07-03 23:07:03','Oregon'),
(9,'2002-07-03 23:07:03','Pennsylvania'),
(9,'2002-07-03 23:07:03','Rhode Island'),
(9,'2002-07-03 23:07:03','South Carolina'),
(9,'2002-07-03 23:07:03','South Dakota'),
(9,'2002-07-03 23:07:03','Tennessee'),
(9,'2002-07-03 23:07:03','Texas'),
(9,'2002-07-03 23:07:03','Utah'),
(9,'2002-07-03 23:07:03','Vermont'),
(9,'2002-07-03 23:07:03','Virginia'),
(9,'2002-07-03 23:07:03','Washington'),
(9,'2002-07-03 23:07:03','West Virginia'),
(9,'2002-07-03 23:07:03','Wisconsin'),
(9,'2002-07-03 23:07:03','Wyoming'),
(10,'2001-09-03 00:39:03',"Italia"),
(10,'2001-09-03 00:39:03',"Francia"),
(10,'2001-09-03 00:39:03',"Spagnia"),
(10,'2001-09-03 00:39:03',"Portogallo"),
(10,'2001-09-03 00:39:03',"Germania"),
(10,'2001-09-03 00:39:03',"Polonia"),
(10,'2001-09-03 00:39:03',"Russia"),
(10,'2001-09-03 00:39:03',"Cina"),
(10,'2001-09-03 00:39:03',"Giappone"),
(10,'2001-09-03 00:39:03',"Corea"),
(10,'2001-09-03 00:39:03',"Afghanistan"),
(10,'2001-09-03 00:39:03',"Australia"),
(10,'2001-09-03 00:39:03',"Britannia"),
(10,'2001-09-03 00:39:03',"America"),
(10,'2001-09-03 00:39:03',"India"),
(10,'2001-09-03 00:39:03',"Canada"),
(10,'2001-09-03 00:39:03',"Norvegia"),
(10,'2001-09-03 00:39:03',"Filandia"),
(10,'2001-09-03 00:39:03',"Svezia"),
(10,'2001-09-03 00:39:03',"Romania"),
(10,'2001-09-03 00:39:03',"Grecia"),
(10,'2001-09-03 00:39:03',"Austria"),
(10,'2001-09-03 00:39:03','Alabama'),
(10,'2001-09-03 00:39:03','Alaska'),
(10,'2001-09-03 00:39:03','Arizona'),
(10,'2001-09-03 00:39:03','Arkansas'),
(10,'2001-09-03 00:39:03','California'),
(10,'2001-09-03 00:39:03','Colorado'),
(10,'2001-09-03 00:39:03','Connecticut'),
(10,'2001-09-03 00:39:03','Delaware'),
(10,'2001-09-03 00:39:03','Florida'),
(10,'2001-09-03 00:39:03','Georgia'),
(10,'2001-09-03 00:39:03','Hawaii'),
(10,'2001-09-03 00:39:03','Idaho'),
(10,'2001-09-03 00:39:03','Illinois'),
(10,'2001-09-03 00:39:03','Indiana'),
(10,'2001-09-03 00:39:03','Iowa'),
(10,'2001-09-03 00:39:03','Kansas'),
(10,'2001-09-03 00:39:03','Kentucky'),
(10,'2001-09-03 00:39:03','Louisiana'),
(10,'2001-09-03 00:39:03','Maine'),
(10,'2001-09-03 00:39:03','Maryland'),
(10,'2001-09-03 00:39:03','Massachusetts'),
(10,'2001-09-03 00:39:03','Michigan'),
(10,'2001-09-03 00:39:03','Minnesota'),
(10,'2001-09-03 00:39:03','Mississippi'),
(10,'2001-09-03 00:39:03','Missouri'),
(10,'2001-09-03 00:39:03','Montana'),
(10,'2001-09-03 00:39:03','Nebraska'),
(10,'2001-09-03 00:39:03','Nevada'),
(10,'2001-09-03 00:39:03','New Hampshire'),
(10,'2001-09-03 00:39:03','New Jersey'),
(10,'2001-09-03 00:39:03','New Mexico'),
(10,'2001-09-03 00:39:03','New York'),
(10,'2001-09-03 00:39:03','North Carolina'),
(10,'2001-09-03 00:39:03','North Dakota'),
(10,'2001-09-03 00:39:03','Ohio'),
(10,'2001-09-03 00:39:03','Oklahoma'),
(10,'2001-09-03 00:39:03','Oregon'),
(10,'2001-09-03 00:39:03','Pennsylvania'),
(10,'2001-09-03 00:39:03','Rhode Island'),
(10,'2001-09-03 00:39:03','South Carolina'),
(10,'2001-09-03 00:39:03','South Dakota'),
(10,'2001-09-03 00:39:03','Tennessee'),
(10,'2001-09-03 00:39:03','Texas'),
(10,'2001-09-03 00:39:03','Utah'),
(10,'2001-09-03 00:39:03','Vermont'),
(10,'2001-09-03 00:39:03','Virginia'),
(10,'2001-09-03 00:39:03','Washington'),
(10,'2001-09-03 00:39:03','West Virginia'),
(10,'2001-09-03 00:39:03','Wisconsin'),
(10,'2001-09-03 00:39:03','Wyoming'),
(11,'2017-03-23 20:18:23',"Italia"),
(11,'2017-03-23 20:18:23',"Francia"),
(11,'2017-03-23 20:18:23',"Spagnia"),
(11,'2017-03-23 20:18:23',"Portogallo"),
(11,'2017-03-23 20:18:23',"Germania"),
(11,'2017-03-23 20:18:23',"Polonia"),
(11,'2017-03-23 20:18:23',"Russia"),
(11,'2017-03-23 20:18:23',"Cina"),
(11,'2017-03-23 20:18:23',"Giappone"),
(11,'2017-03-23 20:18:23',"Corea"),
(11,'2017-03-23 20:18:23',"Afghanistan"),
(11,'2017-03-23 20:18:23',"Australia"),
(11,'2017-03-23 20:18:23',"Britannia"),
(11,'2017-03-23 20:18:23',"America"),
(11,'2017-03-23 20:18:23',"India"),
(11,'2017-03-23 20:18:23',"Canada"),
(11,'2017-03-23 20:18:23',"Norvegia"),
(11,'2017-03-23 20:18:23',"Filandia"),
(11,'2017-03-23 20:18:23',"Svezia"),
(11,'2017-03-23 20:18:23',"Romania"),
(11,'2017-03-23 20:18:23',"Grecia"),
(11,'2017-03-23 20:18:23',"Austria"),
(11,'2017-03-23 20:18:23','Alabama'),
(11,'2017-03-23 20:18:23','Alaska'),
(11,'2017-03-23 20:18:23','Arizona'),
(11,'2017-03-23 20:18:23','Arkansas'),
(11,'2017-03-23 20:18:23','California'),
(11,'2017-03-23 20:18:23','Colorado'),
(11,'2017-03-23 20:18:23','Connecticut'),
(11,'2017-03-23 20:18:23','Delaware'),
(11,'2017-03-23 20:18:23','Florida'),
(11,'2017-03-23 20:18:23','Georgia'),
(11,'2017-03-23 20:18:23','Hawaii'),
(11,'2017-03-23 20:18:23','Idaho'),
(11,'2017-03-23 20:18:23','Illinois'),
(11,'2017-03-23 20:18:23','Indiana'),
(11,'2017-03-23 20:18:23','Iowa'),
(11,'2017-03-23 20:18:23','Kansas'),
(11,'2017-03-23 20:18:23','Kentucky'),
(11,'2017-03-23 20:18:23','Louisiana'),
(11,'2017-03-23 20:18:23','Maine'),
(11,'2017-03-23 20:18:23','Maryland'),
(11,'2017-03-23 20:18:23','Massachusetts'),
(11,'2017-03-23 20:18:23','Michigan'),
(11,'2017-03-23 20:18:23','Minnesota'),
(11,'2017-03-23 20:18:23','Mississippi'),
(11,'2017-03-23 20:18:23','Missouri'),
(11,'2017-03-23 20:18:23','Montana'),
(11,'2017-03-23 20:18:23','Nebraska'),
(11,'2017-03-23 20:18:23','Nevada'),
(11,'2017-03-23 20:18:23','New Hampshire'),
(11,'2017-03-23 20:18:23','New Jersey'),
(11,'2017-03-23 20:18:23','New Mexico'),
(11,'2017-03-23 20:18:23','New York'),
(11,'2017-03-23 20:18:23','North Carolina'),
(11,'2017-03-23 20:18:23','North Dakota'),
(11,'2017-03-23 20:18:23','Ohio'),
(11,'2017-03-23 20:18:23','Oklahoma'),
(11,'2017-03-23 20:18:23','Oregon'),
(11,'2017-03-23 20:18:23','Pennsylvania'),
(11,'2017-03-23 20:18:23','Rhode Island'),
(11,'2017-03-23 20:18:23','South Carolina'),
(11,'2017-03-23 20:18:23','South Dakota'),
(11,'2017-03-23 20:18:23','Tennessee'),
(11,'2017-03-23 20:18:23','Texas'),
(11,'2017-03-23 20:18:23','Utah'),
(11,'2017-03-23 20:18:23','Vermont'),
(11,'2017-03-23 20:18:23','Virginia'),
(11,'2017-03-23 20:18:23','Washington'),
(11,'2017-03-23 20:18:23','West Virginia'),
(11,'2017-03-23 20:18:23','Wisconsin'),
(11,'2017-03-23 20:18:23','Wyoming'),
(12,'1998-05-14 18:52:14',"Italia"),
(12,'1998-05-14 18:52:14',"Francia"),
(12,'1998-05-14 18:52:14',"Spagnia"),
(12,'1998-05-14 18:52:14',"Portogallo"),
(12,'1998-05-14 18:52:14',"Germania"),
(12,'1998-05-14 18:52:14',"Polonia"),
(12,'1998-05-14 18:52:14',"Russia"),
(12,'1998-05-14 18:52:14',"Cina"),
(12,'1998-05-14 18:52:14',"Giappone"),
(12,'1998-05-14 18:52:14',"Corea"),
(12,'1998-05-14 18:52:14',"Afghanistan"),
(12,'1998-05-14 18:52:14',"Australia"),
(12,'1998-05-14 18:52:14',"Britannia"),
(12,'1998-05-14 18:52:14',"America"),
(12,'1998-05-14 18:52:14',"India"),
(12,'1998-05-14 18:52:14',"Canada"),
(12,'1998-05-14 18:52:14',"Norvegia"),
(12,'1998-05-14 18:52:14',"Filandia"),
(12,'1998-05-14 18:52:14',"Svezia"),
(12,'1998-05-14 18:52:14',"Romania"),
(12,'1998-05-14 18:52:14',"Grecia"),
(12,'1998-05-14 18:52:14',"Austria"),
(12,'1998-05-14 18:52:14','Alabama'),
(12,'1998-05-14 18:52:14','Alaska'),
(12,'1998-05-14 18:52:14','Arizona'),
(12,'1998-05-14 18:52:14','Arkansas'),
(12,'1998-05-14 18:52:14','California'),
(12,'1998-05-14 18:52:14','Colorado'),
(12,'1998-05-14 18:52:14','Connecticut'),
(12,'1998-05-14 18:52:14','Delaware'),
(12,'1998-05-14 18:52:14','Florida'),
(12,'1998-05-14 18:52:14','Georgia'),
(12,'1998-05-14 18:52:14','Hawaii'),
(12,'1998-05-14 18:52:14','Idaho'),
(12,'1998-05-14 18:52:14','Illinois'),
(12,'1998-05-14 18:52:14','Indiana'),
(12,'1998-05-14 18:52:14','Iowa'),
(12,'1998-05-14 18:52:14','Kansas'),
(12,'1998-05-14 18:52:14','Kentucky'),
(12,'1998-05-14 18:52:14','Louisiana'),
(12,'1998-05-14 18:52:14','Maine'),
(12,'1998-05-14 18:52:14','Maryland'),
(12,'1998-05-14 18:52:14','Massachusetts'),
(12,'1998-05-14 18:52:14','Michigan'),
(12,'1998-05-14 18:52:14','Minnesota'),
(12,'1998-05-14 18:52:14','Mississippi'),
(12,'1998-05-14 18:52:14','Missouri'),
(12,'1998-05-14 18:52:14','Montana'),
(12,'1998-05-14 18:52:14','Nebraska'),
(12,'1998-05-14 18:52:14','Nevada'),
(12,'1998-05-14 18:52:14','New Hampshire'),
(12,'1998-05-14 18:52:14','New Jersey'),
(12,'1998-05-14 18:52:14','New Mexico'),
(12,'1998-05-14 18:52:14','New York'),
(12,'1998-05-14 18:52:14','North Carolina'),
(12,'1998-05-14 18:52:14','North Dakota'),
(12,'1998-05-14 18:52:14','Ohio'),
(12,'1998-05-14 18:52:14','Oklahoma'),
(12,'1998-05-14 18:52:14','Oregon'),
(12,'1998-05-14 18:52:14','Pennsylvania'),
(12,'1998-05-14 18:52:14','Rhode Island'),
(12,'1998-05-14 18:52:14','South Carolina'),
(12,'1998-05-14 18:52:14','South Dakota'),
(12,'1998-05-14 18:52:14','Tennessee'),
(12,'1998-05-14 18:52:14','Texas'),
(12,'1998-05-14 18:52:14','Utah'),
(12,'1998-05-14 18:52:14','Vermont'),
(12,'1998-05-14 18:52:14','Virginia'),
(12,'1998-05-14 18:52:14','Washington'),
(12,'1998-05-14 18:52:14','West Virginia'),
(12,'1998-05-14 18:52:14','Wisconsin'),
(12,'1998-05-14 18:52:14','Wyoming'),
(13,'2010-10-23 19:55:23',"Italia"),
(13,'2010-10-23 19:55:23',"Francia"),
(13,'2010-10-23 19:55:23',"Spagnia"),
(13,'2010-10-23 19:55:23',"Portogallo"),
(13,'2010-10-23 19:55:23',"Germania"),
(13,'2010-10-23 19:55:23',"Polonia"),
(13,'2010-10-23 19:55:23',"Russia"),
(13,'2010-10-23 19:55:23',"Cina"),
(13,'2010-10-23 19:55:23',"Giappone"),
(13,'2010-10-23 19:55:23',"Corea"),
(13,'2010-10-23 19:55:23',"Afghanistan"),
(13,'2010-10-23 19:55:23',"Australia"),
(13,'2010-10-23 19:55:23',"Britannia"),
(13,'2010-10-23 19:55:23',"America"),
(13,'2010-10-23 19:55:23',"India"),
(13,'2010-10-23 19:55:23',"Canada"),
(13,'2010-10-23 19:55:23',"Norvegia"),
(13,'2010-10-23 19:55:23',"Filandia"),
(13,'2010-10-23 19:55:23',"Svezia"),
(13,'2010-10-23 19:55:23',"Romania"),
(13,'2010-10-23 19:55:23',"Grecia"),
(13,'2010-10-23 19:55:23',"Austria"),
(13,'2010-10-23 19:55:23','Alabama'),
(13,'2010-10-23 19:55:23','Alaska'),
(13,'2010-10-23 19:55:23','Arizona'),
(13,'2010-10-23 19:55:23','Arkansas'),
(13,'2010-10-23 19:55:23','California'),
(13,'2010-10-23 19:55:23','Colorado'),
(13,'2010-10-23 19:55:23','Connecticut'),
(13,'2010-10-23 19:55:23','Delaware'),
(13,'2010-10-23 19:55:23','Florida'),
(13,'2010-10-23 19:55:23','Georgia'),
(13,'2010-10-23 19:55:23','Hawaii'),
(13,'2010-10-23 19:55:23','Idaho'),
(13,'2010-10-23 19:55:23','Illinois'),
(13,'2010-10-23 19:55:23','Indiana'),
(13,'2010-10-23 19:55:23','Iowa'),
(13,'2010-10-23 19:55:23','Kansas'),
(13,'2010-10-23 19:55:23','Kentucky'),
(13,'2010-10-23 19:55:23','Louisiana'),
(13,'2010-10-23 19:55:23','Maine'),
(13,'2010-10-23 19:55:23','Maryland'),
(13,'2010-10-23 19:55:23','Massachusetts'),
(13,'2010-10-23 19:55:23','Michigan'),
(13,'2010-10-23 19:55:23','Minnesota'),
(13,'2010-10-23 19:55:23','Mississippi'),
(13,'2010-10-23 19:55:23','Missouri'),
(13,'2010-10-23 19:55:23','Montana'),
(13,'2010-10-23 19:55:23','Nebraska'),
(13,'2010-10-23 19:55:23','Nevada'),
(13,'2010-10-23 19:55:23','New Hampshire'),
(13,'2010-10-23 19:55:23','New Jersey'),
(13,'2010-10-23 19:55:23','New Mexico'),
(13,'2010-10-23 19:55:23','New York'),
(13,'2010-10-23 19:55:23','North Carolina'),
(13,'2010-10-23 19:55:23','North Dakota'),
(13,'2010-10-23 19:55:23','Ohio'),
(13,'2010-10-23 19:55:23','Oklahoma'),
(13,'2010-10-23 19:55:23','Oregon'),
(13,'2010-10-23 19:55:23','Pennsylvania'),
(13,'2010-10-23 19:55:23','Rhode Island'),
(13,'2010-10-23 19:55:23','South Carolina'),
(13,'2010-10-23 19:55:23','South Dakota'),
(13,'2010-10-23 19:55:23','Tennessee'),
(13,'2010-10-23 19:55:23','Texas'),
(13,'2010-10-23 19:55:23','Utah'),
(13,'2010-10-23 19:55:23','Vermont'),
(13,'2010-10-23 19:55:23','Virginia'),
(13,'2010-10-23 19:55:23','Washington'),
(13,'2010-10-23 19:55:23','West Virginia'),
(13,'2010-10-23 19:55:23','Wisconsin'),
(13,'2010-10-23 19:55:23','Wyoming'),
(14,'2015-10-30 08:44:30',"Italia"),
(14,'2015-10-30 08:44:30',"Francia"),
(14,'2015-10-30 08:44:30',"Spagnia"),
(14,'2015-10-30 08:44:30',"Portogallo"),
(14,'2015-10-30 08:44:30',"Germania"),
(14,'2015-10-30 08:44:30',"Polonia"),
(14,'2015-10-30 08:44:30',"Russia"),
(14,'2015-10-30 08:44:30',"Cina"),
(14,'2015-10-30 08:44:30',"Giappone"),
(14,'2015-10-30 08:44:30',"Corea"),
(14,'2015-10-30 08:44:30',"Afghanistan"),
(14,'2015-10-30 08:44:30',"Australia"),
(14,'2015-10-30 08:44:30',"Britannia"),
(14,'2015-10-30 08:44:30',"America"),
(14,'2015-10-30 08:44:30',"India"),
(14,'2015-10-30 08:44:30',"Canada"),
(14,'2015-10-30 08:44:30',"Norvegia"),
(14,'2015-10-30 08:44:30',"Filandia"),
(14,'2015-10-30 08:44:30',"Svezia"),
(14,'2015-10-30 08:44:30',"Romania"),
(14,'2015-10-30 08:44:30',"Grecia"),
(14,'2015-10-30 08:44:30',"Austria"),
(14,'2015-10-30 08:44:30','Alabama'),
(14,'2015-10-30 08:44:30','Alaska'),
(14,'2015-10-30 08:44:30','Arizona'),
(14,'2015-10-30 08:44:30','Arkansas'),
(14,'2015-10-30 08:44:30','California'),
(14,'2015-10-30 08:44:30','Colorado'),
(14,'2015-10-30 08:44:30','Connecticut'),
(14,'2015-10-30 08:44:30','Delaware'),
(14,'2015-10-30 08:44:30','Florida'),
(14,'2015-10-30 08:44:30','Georgia'),
(14,'2015-10-30 08:44:30','Hawaii'),
(14,'2015-10-30 08:44:30','Idaho'),
(14,'2015-10-30 08:44:30','Illinois'),
(14,'2015-10-30 08:44:30','Indiana'),
(14,'2015-10-30 08:44:30','Iowa'),
(14,'2015-10-30 08:44:30','Kansas'),
(14,'2015-10-30 08:44:30','Kentucky'),
(14,'2015-10-30 08:44:30','Louisiana'),
(14,'2015-10-30 08:44:30','Maine'),
(14,'2015-10-30 08:44:30','Maryland'),
(14,'2015-10-30 08:44:30','Massachusetts'),
(14,'2015-10-30 08:44:30','Michigan'),
(14,'2015-10-30 08:44:30','Minnesota'),
(14,'2015-10-30 08:44:30','Mississippi'),
(14,'2015-10-30 08:44:30','Missouri'),
(14,'2015-10-30 08:44:30','Montana'),
(14,'2015-10-30 08:44:30','Nebraska'),
(14,'2015-10-30 08:44:30','Nevada'),
(14,'2015-10-30 08:44:30','New Hampshire'),
(14,'2015-10-30 08:44:30','New Jersey'),
(14,'2015-10-30 08:44:30','New Mexico'),
(14,'2015-10-30 08:44:30','New York'),
(14,'2015-10-30 08:44:30','North Carolina'),
(14,'2015-10-30 08:44:30','North Dakota'),
(14,'2015-10-30 08:44:30','Ohio'),
(14,'2015-10-30 08:44:30','Oklahoma'),
(14,'2015-10-30 08:44:30','Oregon'),
(14,'2015-10-30 08:44:30','Pennsylvania'),
(14,'2015-10-30 08:44:30','Rhode Island'),
(14,'2015-10-30 08:44:30','South Carolina'),
(14,'2015-10-30 08:44:30','South Dakota'),
(14,'2015-10-30 08:44:30','Tennessee'),
(14,'2015-10-30 08:44:30','Texas'),
(14,'2015-10-30 08:44:30','Utah'),
(14,'2015-10-30 08:44:30','Vermont'),
(14,'2015-10-30 08:44:30','Virginia'),
(14,'2015-10-30 08:44:30','Washington'),
(14,'2015-10-30 08:44:30','West Virginia'),
(14,'2015-10-30 08:44:30','Wisconsin'),
(14,'2015-10-30 08:44:30','Wyoming'),
(15,'2001-01-25 09:05:25',"Italia"),
(15,'2001-01-25 09:05:25',"Francia"),
(15,'2001-01-25 09:05:25',"Spagnia"),
(15,'2001-01-25 09:05:25',"Portogallo"),
(15,'2001-01-25 09:05:25',"Germania"),
(15,'2001-01-25 09:05:25',"Polonia"),
(15,'2001-01-25 09:05:25',"Russia"),
(15,'2001-01-25 09:05:25',"Cina"),
(15,'2001-01-25 09:05:25',"Giappone"),
(15,'2001-01-25 09:05:25',"Corea"),
(15,'2001-01-25 09:05:25',"Afghanistan"),
(15,'2001-01-25 09:05:25',"Australia"),
(15,'2001-01-25 09:05:25',"Britannia"),
(15,'2001-01-25 09:05:25',"America"),
(15,'2001-01-25 09:05:25',"India"),
(15,'2001-01-25 09:05:25',"Canada"),
(15,'2001-01-25 09:05:25',"Norvegia"),
(15,'2001-01-25 09:05:25',"Filandia"),
(15,'2001-01-25 09:05:25',"Svezia"),
(15,'2001-01-25 09:05:25',"Romania"),
(15,'2001-01-25 09:05:25',"Grecia"),
(15,'2001-01-25 09:05:25',"Austria"),
(15,'2001-01-25 09:05:25','Alabama'),
(15,'2001-01-25 09:05:25','Alaska'),
(15,'2001-01-25 09:05:25','Arizona'),
(15,'2001-01-25 09:05:25','Arkansas'),
(15,'2001-01-25 09:05:25','California'),
(15,'2001-01-25 09:05:25','Colorado'),
(15,'2001-01-25 09:05:25','Connecticut'),
(15,'2001-01-25 09:05:25','Delaware'),
(15,'2001-01-25 09:05:25','Florida'),
(15,'2001-01-25 09:05:25','Georgia'),
(15,'2001-01-25 09:05:25','Hawaii'),
(15,'2001-01-25 09:05:25','Idaho'),
(15,'2001-01-25 09:05:25','Illinois'),
(15,'2001-01-25 09:05:25','Indiana'),
(15,'2001-01-25 09:05:25','Iowa'),
(15,'2001-01-25 09:05:25','Kansas'),
(15,'2001-01-25 09:05:25','Kentucky'),
(15,'2001-01-25 09:05:25','Louisiana'),
(15,'2001-01-25 09:05:25','Maine'),
(15,'2001-01-25 09:05:25','Maryland'),
(15,'2001-01-25 09:05:25','Massachusetts'),
(15,'2001-01-25 09:05:25','Michigan'),
(15,'2001-01-25 09:05:25','Minnesota'),
(15,'2001-01-25 09:05:25','Mississippi'),
(15,'2001-01-25 09:05:25','Missouri'),
(15,'2001-01-25 09:05:25','Montana'),
(15,'2001-01-25 09:05:25','Nebraska'),
(15,'2001-01-25 09:05:25','Nevada'),
(15,'2001-01-25 09:05:25','New Hampshire'),
(15,'2001-01-25 09:05:25','New Jersey'),
(15,'2001-01-25 09:05:25','New Mexico'),
(15,'2001-01-25 09:05:25','New York'),
(15,'2001-01-25 09:05:25','North Carolina'),
(15,'2001-01-25 09:05:25','North Dakota'),
(15,'2001-01-25 09:05:25','Ohio'),
(15,'2001-01-25 09:05:25','Oklahoma'),
(15,'2001-01-25 09:05:25','Oregon'),
(15,'2001-01-25 09:05:25','Pennsylvania'),
(15,'2001-01-25 09:05:25','Rhode Island'),
(15,'2001-01-25 09:05:25','South Carolina'),
(15,'2001-01-25 09:05:25','South Dakota'),
(15,'2001-01-25 09:05:25','Tennessee'),
(15,'2001-01-25 09:05:25','Texas'),
(15,'2001-01-25 09:05:25','Utah'),
(15,'2001-01-25 09:05:25','Vermont'),
(15,'2001-01-25 09:05:25','Virginia'),
(15,'2001-01-25 09:05:25','Washington'),
(15,'2001-01-25 09:05:25','West Virginia'),
(15,'2001-01-25 09:05:25','Wisconsin'),
(15,'2001-01-25 09:05:25','Wyoming'),
(16,'2020-03-13 03:58:13',"Italia"),
(16,'2020-03-13 03:58:13',"Francia"),
(16,'2020-03-13 03:58:13',"Spagnia"),
(16,'2020-03-13 03:58:13',"Portogallo"),
(16,'2020-03-13 03:58:13',"Germania"),
(16,'2020-03-13 03:58:13',"Polonia"),
(16,'2020-03-13 03:58:13',"Russia"),
(16,'2020-03-13 03:58:13',"Cina"),
(16,'2020-03-13 03:58:13',"Giappone"),
(16,'2020-03-13 03:58:13',"Corea"),
(16,'2020-03-13 03:58:13',"Afghanistan"),
(16,'2020-03-13 03:58:13',"Australia"),
(16,'2020-03-13 03:58:13',"Britannia"),
(16,'2020-03-13 03:58:13',"America"),
(16,'2020-03-13 03:58:13',"India"),
(16,'2020-03-13 03:58:13',"Canada"),
(16,'2020-03-13 03:58:13',"Norvegia"),
(16,'2020-03-13 03:58:13',"Filandia"),
(16,'2020-03-13 03:58:13',"Svezia"),
(16,'2020-03-13 03:58:13',"Romania"),
(16,'2020-03-13 03:58:13',"Grecia"),
(16,'2020-03-13 03:58:13',"Austria"),
(16,'2020-03-13 03:58:13','Alabama'),
(16,'2020-03-13 03:58:13','Alaska'),
(16,'2020-03-13 03:58:13','Arizona'),
(16,'2020-03-13 03:58:13','Arkansas'),
(16,'2020-03-13 03:58:13','California'),
(16,'2020-03-13 03:58:13','Colorado'),
(16,'2020-03-13 03:58:13','Connecticut'),
(16,'2020-03-13 03:58:13','Delaware'),
(16,'2020-03-13 03:58:13','Florida'),
(16,'2020-03-13 03:58:13','Georgia'),
(16,'2020-03-13 03:58:13','Hawaii'),
(16,'2020-03-13 03:58:13','Idaho'),
(16,'2020-03-13 03:58:13','Illinois'),
(16,'2020-03-13 03:58:13','Indiana'),
(16,'2020-03-13 03:58:13','Iowa'),
(16,'2020-03-13 03:58:13','Kansas'),
(16,'2020-03-13 03:58:13','Kentucky'),
(16,'2020-03-13 03:58:13','Louisiana'),
(16,'2020-03-13 03:58:13','Maine'),
(16,'2020-03-13 03:58:13','Maryland'),
(16,'2020-03-13 03:58:13','Massachusetts'),
(16,'2020-03-13 03:58:13','Michigan'),
(16,'2020-03-13 03:58:13','Minnesota'),
(16,'2020-03-13 03:58:13','Mississippi'),
(16,'2020-03-13 03:58:13','Missouri'),
(16,'2020-03-13 03:58:13','Montana'),
(16,'2020-03-13 03:58:13','Nebraska'),
(16,'2020-03-13 03:58:13','Nevada'),
(16,'2020-03-13 03:58:13','New Hampshire'),
(16,'2020-03-13 03:58:13','New Jersey'),
(16,'2020-03-13 03:58:13','New Mexico'),
(16,'2020-03-13 03:58:13','New York'),
(16,'2020-03-13 03:58:13','North Carolina'),
(16,'2020-03-13 03:58:13','North Dakota'),
(16,'2020-03-13 03:58:13','Ohio'),
(16,'2020-03-13 03:58:13','Oklahoma'),
(16,'2020-03-13 03:58:13','Oregon'),
(16,'2020-03-13 03:58:13','Pennsylvania'),
(16,'2020-03-13 03:58:13','Rhode Island'),
(16,'2020-03-13 03:58:13','South Carolina'),
(16,'2020-03-13 03:58:13','South Dakota'),
(16,'2020-03-13 03:58:13','Tennessee'),
(16,'2020-03-13 03:58:13','Texas'),
(16,'2020-03-13 03:58:13','Utah'),
(16,'2020-03-13 03:58:13','Vermont'),
(16,'2020-03-13 03:58:13','Virginia'),
(16,'2020-03-13 03:58:13','Washington'),
(16,'2020-03-13 03:58:13','West Virginia'),
(16,'2020-03-13 03:58:13','Wisconsin'),
(16,'2020-03-13 03:58:13','Wyoming'),
(17,'2018-02-13 17:27:13',"Italia"),
(17,'2018-02-13 17:27:13',"Francia"),
(17,'2018-02-13 17:27:13',"Spagnia"),
(17,'2018-02-13 17:27:13',"Portogallo"),
(17,'2018-02-13 17:27:13',"Germania"),
(17,'2018-02-13 17:27:13',"Polonia"),
(17,'2018-02-13 17:27:13',"Russia"),
(17,'2018-02-13 17:27:13',"Cina"),
(17,'2018-02-13 17:27:13',"Giappone"),
(17,'2018-02-13 17:27:13',"Corea"),
(17,'2018-02-13 17:27:13',"Afghanistan"),
(17,'2018-02-13 17:27:13',"Australia"),
(17,'2018-02-13 17:27:13',"Britannia"),
(17,'2018-02-13 17:27:13',"America"),
(17,'2018-02-13 17:27:13',"India"),
(17,'2018-02-13 17:27:13',"Canada"),
(17,'2018-02-13 17:27:13',"Norvegia"),
(17,'2018-02-13 17:27:13',"Filandia"),
(17,'2018-02-13 17:27:13',"Svezia"),
(17,'2018-02-13 17:27:13',"Romania"),
(17,'2018-02-13 17:27:13',"Grecia"),
(17,'2018-02-13 17:27:13',"Austria"),
(17,'2018-02-13 17:27:13','Alabama'),
(17,'2018-02-13 17:27:13','Alaska'),
(17,'2018-02-13 17:27:13','Arizona'),
(17,'2018-02-13 17:27:13','Arkansas'),
(17,'2018-02-13 17:27:13','California'),
(17,'2018-02-13 17:27:13','Colorado'),
(17,'2018-02-13 17:27:13','Connecticut'),
(17,'2018-02-13 17:27:13','Delaware'),
(17,'2018-02-13 17:27:13','Florida'),
(17,'2018-02-13 17:27:13','Georgia'),
(17,'2018-02-13 17:27:13','Hawaii'),
(17,'2018-02-13 17:27:13','Idaho'),
(17,'2018-02-13 17:27:13','Illinois'),
(17,'2018-02-13 17:27:13','Indiana'),
(17,'2018-02-13 17:27:13','Iowa'),
(17,'2018-02-13 17:27:13','Kansas'),
(17,'2018-02-13 17:27:13','Kentucky'),
(17,'2018-02-13 17:27:13','Louisiana'),
(17,'2018-02-13 17:27:13','Maine'),
(17,'2018-02-13 17:27:13','Maryland'),
(17,'2018-02-13 17:27:13','Massachusetts'),
(17,'2018-02-13 17:27:13','Michigan'),
(17,'2018-02-13 17:27:13','Minnesota'),
(17,'2018-02-13 17:27:13','Mississippi'),
(17,'2018-02-13 17:27:13','Missouri'),
(17,'2018-02-13 17:27:13','Montana'),
(17,'2018-02-13 17:27:13','Nebraska'),
(17,'2018-02-13 17:27:13','Nevada'),
(17,'2018-02-13 17:27:13','New Hampshire'),
(17,'2018-02-13 17:27:13','New Jersey'),
(17,'2018-02-13 17:27:13','New Mexico'),
(17,'2018-02-13 17:27:13','New York'),
(17,'2018-02-13 17:27:13','North Carolina'),
(17,'2018-02-13 17:27:13','North Dakota'),
(17,'2018-02-13 17:27:13','Ohio'),
(17,'2018-02-13 17:27:13','Oklahoma'),
(17,'2018-02-13 17:27:13','Oregon'),
(17,'2018-02-13 17:27:13','Pennsylvania'),
(17,'2018-02-13 17:27:13','Rhode Island'),
(17,'2018-02-13 17:27:13','South Carolina'),
(17,'2018-02-13 17:27:13','South Dakota'),
(17,'2018-02-13 17:27:13','Tennessee'),
(17,'2018-02-13 17:27:13','Texas'),
(17,'2018-02-13 17:27:13','Utah'),
(17,'2018-02-13 17:27:13','Vermont'),
(17,'2018-02-13 17:27:13','Virginia'),
(17,'2018-02-13 17:27:13','Washington'),
(17,'2018-02-13 17:27:13','West Virginia'),
(17,'2018-02-13 17:27:13','Wisconsin'),
(17,'2018-02-13 17:27:13','Wyoming'),
(18,'2003-08-11 16:26:11',"Italia"),
(18,'2003-08-11 16:26:11',"Francia"),
(18,'2003-08-11 16:26:11',"Spagnia"),
(18,'2003-08-11 16:26:11',"Portogallo"),
(18,'2003-08-11 16:26:11',"Germania"),
(18,'2003-08-11 16:26:11',"Polonia"),
(18,'2003-08-11 16:26:11',"Russia"),
(18,'2003-08-11 16:26:11',"Cina"),
(18,'2003-08-11 16:26:11',"Giappone"),
(18,'2003-08-11 16:26:11',"Corea"),
(18,'2003-08-11 16:26:11',"Afghanistan"),
(18,'2003-08-11 16:26:11',"Australia"),
(18,'2003-08-11 16:26:11',"Britannia"),
(18,'2003-08-11 16:26:11',"America"),
(18,'2003-08-11 16:26:11',"India"),
(18,'2003-08-11 16:26:11',"Canada"),
(18,'2003-08-11 16:26:11',"Norvegia"),
(18,'2003-08-11 16:26:11',"Filandia"),
(18,'2003-08-11 16:26:11',"Svezia"),
(18,'2003-08-11 16:26:11',"Romania"),
(18,'2003-08-11 16:26:11',"Grecia"),
(18,'2003-08-11 16:26:11',"Austria"),
(18,'2003-08-11 16:26:11','Alabama'),
(18,'2003-08-11 16:26:11','Alaska'),
(18,'2003-08-11 16:26:11','Arizona'),
(18,'2003-08-11 16:26:11','Arkansas'),
(18,'2003-08-11 16:26:11','California'),
(18,'2003-08-11 16:26:11','Colorado'),
(18,'2003-08-11 16:26:11','Connecticut'),
(18,'2003-08-11 16:26:11','Delaware'),
(18,'2003-08-11 16:26:11','Florida'),
(18,'2003-08-11 16:26:11','Georgia'),
(18,'2003-08-11 16:26:11','Hawaii'),
(18,'2003-08-11 16:26:11','Idaho'),
(18,'2003-08-11 16:26:11','Illinois'),
(18,'2003-08-11 16:26:11','Indiana'),
(18,'2003-08-11 16:26:11','Iowa'),
(18,'2003-08-11 16:26:11','Kansas'),
(18,'2003-08-11 16:26:11','Kentucky'),
(18,'2003-08-11 16:26:11','Louisiana'),
(18,'2003-08-11 16:26:11','Maine'),
(18,'2003-08-11 16:26:11','Maryland'),
(18,'2003-08-11 16:26:11','Massachusetts'),
(18,'2003-08-11 16:26:11','Michigan'),
(18,'2003-08-11 16:26:11','Minnesota'),
(18,'2003-08-11 16:26:11','Mississippi'),
(18,'2003-08-11 16:26:11','Missouri'),
(18,'2003-08-11 16:26:11','Montana'),
(18,'2003-08-11 16:26:11','Nebraska'),
(18,'2003-08-11 16:26:11','Nevada'),
(18,'2003-08-11 16:26:11','New Hampshire'),
(18,'2003-08-11 16:26:11','New Jersey'),
(18,'2003-08-11 16:26:11','New Mexico'),
(18,'2003-08-11 16:26:11','New York'),
(18,'2003-08-11 16:26:11','North Carolina'),
(18,'2003-08-11 16:26:11','North Dakota'),
(18,'2003-08-11 16:26:11','Ohio'),
(18,'2003-08-11 16:26:11','Oklahoma'),
(18,'2003-08-11 16:26:11','Oregon'),
(18,'2003-08-11 16:26:11','Pennsylvania'),
(18,'2003-08-11 16:26:11','Rhode Island'),
(18,'2003-08-11 16:26:11','South Carolina'),
(18,'2003-08-11 16:26:11','South Dakota'),
(18,'2003-08-11 16:26:11','Tennessee'),
(18,'2003-08-11 16:26:11','Texas'),
(18,'2003-08-11 16:26:11','Utah'),
(18,'2003-08-11 16:26:11','Vermont'),
(18,'2003-08-11 16:26:11','Virginia'),
(18,'2003-08-11 16:26:11','Washington'),
(18,'2003-08-11 16:26:11','West Virginia'),
(18,'2003-08-11 16:26:11','Wisconsin'),
(18,'2003-08-11 16:26:11','Wyoming'),
(19,'2018-12-21 20:00:21',"Italia"),
(19,'2018-12-21 20:00:21',"Francia"),
(19,'2018-12-21 20:00:21',"Spagnia"),
(19,'2018-12-21 20:00:21',"Portogallo"),
(19,'2018-12-21 20:00:21',"Germania"),
(19,'2018-12-21 20:00:21',"Polonia"),
(19,'2018-12-21 20:00:21',"Russia"),
(19,'2018-12-21 20:00:21',"Cina"),
(19,'2018-12-21 20:00:21',"Giappone"),
(19,'2018-12-21 20:00:21',"Corea"),
(19,'2018-12-21 20:00:21',"Afghanistan"),
(19,'2018-12-21 20:00:21',"Australia"),
(19,'2018-12-21 20:00:21',"Britannia"),
(19,'2018-12-21 20:00:21',"America"),
(19,'2018-12-21 20:00:21',"India"),
(19,'2018-12-21 20:00:21',"Canada"),
(19,'2018-12-21 20:00:21',"Norvegia"),
(19,'2018-12-21 20:00:21',"Filandia"),
(19,'2018-12-21 20:00:21',"Svezia"),
(19,'2018-12-21 20:00:21',"Romania"),
(19,'2018-12-21 20:00:21',"Grecia"),
(19,'2018-12-21 20:00:21',"Austria"),
(19,'2018-12-21 20:00:21','Alabama'),
(19,'2018-12-21 20:00:21','Alaska'),
(19,'2018-12-21 20:00:21','Arizona'),
(19,'2018-12-21 20:00:21','Arkansas'),
(19,'2018-12-21 20:00:21','California'),
(19,'2018-12-21 20:00:21','Colorado'),
(19,'2018-12-21 20:00:21','Connecticut'),
(19,'2018-12-21 20:00:21','Delaware'),
(19,'2018-12-21 20:00:21','Florida'),
(19,'2018-12-21 20:00:21','Georgia'),
(19,'2018-12-21 20:00:21','Hawaii'),
(19,'2018-12-21 20:00:21','Idaho'),
(19,'2018-12-21 20:00:21','Illinois'),
(19,'2018-12-21 20:00:21','Indiana'),
(19,'2018-12-21 20:00:21','Iowa'),
(19,'2018-12-21 20:00:21','Kansas'),
(19,'2018-12-21 20:00:21','Kentucky'),
(19,'2018-12-21 20:00:21','Louisiana'),
(19,'2018-12-21 20:00:21','Maine'),
(19,'2018-12-21 20:00:21','Maryland'),
(19,'2018-12-21 20:00:21','Massachusetts'),
(19,'2018-12-21 20:00:21','Michigan'),
(19,'2018-12-21 20:00:21','Minnesota'),
(19,'2018-12-21 20:00:21','Mississippi'),
(19,'2018-12-21 20:00:21','Missouri'),
(19,'2018-12-21 20:00:21','Montana'),
(19,'2018-12-21 20:00:21','Nebraska'),
(19,'2018-12-21 20:00:21','Nevada'),
(19,'2018-12-21 20:00:21','New Hampshire'),
(19,'2018-12-21 20:00:21','New Jersey'),
(19,'2018-12-21 20:00:21','New Mexico'),
(19,'2018-12-21 20:00:21','New York'),
(19,'2018-12-21 20:00:21','North Carolina'),
(19,'2018-12-21 20:00:21','North Dakota'),
(19,'2018-12-21 20:00:21','Ohio'),
(19,'2018-12-21 20:00:21','Oklahoma'),
(19,'2018-12-21 20:00:21','Oregon'),
(19,'2018-12-21 20:00:21','Pennsylvania'),
(19,'2018-12-21 20:00:21','Rhode Island'),
(19,'2018-12-21 20:00:21','South Carolina'),
(19,'2018-12-21 20:00:21','South Dakota'),
(19,'2018-12-21 20:00:21','Tennessee'),
(19,'2018-12-21 20:00:21','Texas'),
(19,'2018-12-21 20:00:21','Utah'),
(19,'2018-12-21 20:00:21','Vermont'),
(19,'2018-12-21 20:00:21','Virginia'),
(19,'2018-12-21 20:00:21','Washington'),
(19,'2018-12-21 20:00:21','West Virginia'),
(19,'2018-12-21 20:00:21','Wisconsin'),
(19,'2018-12-21 20:00:21','Wyoming'),
(20,'2021-06-17 15:26:17',"Italia"),
(20,'2021-06-17 15:26:17',"Francia"),
(20,'2021-06-17 15:26:17',"Spagnia"),
(20,'2021-06-17 15:26:17',"Portogallo"),
(20,'2021-06-17 15:26:17',"Germania"),
(20,'2021-06-17 15:26:17',"Polonia"),
(20,'2021-06-17 15:26:17',"Russia"),
(20,'2021-06-17 15:26:17',"Cina"),
(20,'2021-06-17 15:26:17',"Giappone"),
(20,'2021-06-17 15:26:17',"Corea"),
(20,'2021-06-17 15:26:17',"Afghanistan"),
(20,'2021-06-17 15:26:17',"Australia"),
(20,'2021-06-17 15:26:17',"Britannia"),
(20,'2021-06-17 15:26:17',"America"),
(20,'2021-06-17 15:26:17',"India"),
(20,'2021-06-17 15:26:17',"Canada"),
(20,'2021-06-17 15:26:17',"Norvegia"),
(20,'2021-06-17 15:26:17',"Filandia"),
(20,'2021-06-17 15:26:17',"Svezia"),
(20,'2021-06-17 15:26:17',"Romania"),
(20,'2021-06-17 15:26:17',"Grecia"),
(20,'2021-06-17 15:26:17',"Austria"),
(20,'2021-06-17 15:26:17','Alabama'),
(20,'2021-06-17 15:26:17','Alaska'),
(20,'2021-06-17 15:26:17','Arizona'),
(20,'2021-06-17 15:26:17','Arkansas'),
(20,'2021-06-17 15:26:17','California'),
(20,'2021-06-17 15:26:17','Colorado'),
(20,'2021-06-17 15:26:17','Connecticut'),
(20,'2021-06-17 15:26:17','Delaware'),
(20,'2021-06-17 15:26:17','Florida'),
(20,'2021-06-17 15:26:17','Georgia'),
(20,'2021-06-17 15:26:17','Hawaii'),
(20,'2021-06-17 15:26:17','Idaho'),
(20,'2021-06-17 15:26:17','Illinois'),
(20,'2021-06-17 15:26:17','Indiana'),
(20,'2021-06-17 15:26:17','Iowa'),
(20,'2021-06-17 15:26:17','Kansas'),
(20,'2021-06-17 15:26:17','Kentucky'),
(20,'2021-06-17 15:26:17','Louisiana'),
(20,'2021-06-17 15:26:17','Maine'),
(20,'2021-06-17 15:26:17','Maryland'),
(20,'2021-06-17 15:26:17','Massachusetts'),
(20,'2021-06-17 15:26:17','Michigan'),
(20,'2021-06-17 15:26:17','Minnesota'),
(20,'2021-06-17 15:26:17','Mississippi'),
(20,'2021-06-17 15:26:17','Missouri'),
(20,'2021-06-17 15:26:17','Montana'),
(20,'2021-06-17 15:26:17','Nebraska'),
(20,'2021-06-17 15:26:17','Nevada'),
(20,'2021-06-17 15:26:17','New Hampshire'),
(20,'2021-06-17 15:26:17','New Jersey'),
(20,'2021-06-17 15:26:17','New Mexico'),
(20,'2021-06-17 15:26:17','New York'),
(20,'2021-06-17 15:26:17','North Carolina'),
(20,'2021-06-17 15:26:17','North Dakota'),
(20,'2021-06-17 15:26:17','Ohio'),
(20,'2021-06-17 15:26:17','Oklahoma'),
(20,'2021-06-17 15:26:17','Oregon'),
(20,'2021-06-17 15:26:17','Pennsylvania'),
(20,'2021-06-17 15:26:17','Rhode Island'),
(20,'2021-06-17 15:26:17','South Carolina'),
(20,'2021-06-17 15:26:17','South Dakota'),
(20,'2021-06-17 15:26:17','Tennessee'),
(20,'2021-06-17 15:26:17','Texas'),
(20,'2021-06-17 15:26:17','Utah'),
(20,'2021-06-17 15:26:17','Vermont'),
(20,'2021-06-17 15:26:17','Virginia'),
(20,'2021-06-17 15:26:17','Washington'),
(20,'2021-06-17 15:26:17','West Virginia'),
(20,'2021-06-17 15:26:17','Wisconsin'),
(20,'2021-06-17 15:26:17','Wyoming');

-- operazioni interessanti

-- dato un cliente, indicare quanti titolari di carta diversi dal suo nome e cognome ha nelle carte usate per pagare i suoi abbonamenti

DROP PROCEDURE IF EXISTS Quanti_Titolari_Diversi;
DELIMITER $$
CREATE PROCEDURE Quanti_Titolari_Diversi (IN Id_Cliente INT, OUT Quanti_Titolari_Diversi_ INT)
BEGIN
  
SET Quanti_Titolari_Diversi_ =   (
                                    
                                    SELECT  COUNT(*)
                                    FROM    Utente U INNER JOIN Abbonamento A INNER JOIN Fattura F INNER JOIN Carta C ON(U.Id_Cliente = A.Id_Cliente AND A.Numero_Fattura = F.Numero_Fattura AND F.CVV = C.CVV AND F.PAN = C.PAN)
                                    WHERE   U.Id_Cliente = Id_Cliente AND U.Nome = C.Nome_Titolare AND U.Cognome = C.Cognome_Titolare AND F.Scadenza < F.Data_Pagamento AND F.Data_Pagamento IS NOT NULL                  
                                );

END $$

DELIMITER ;

-- conta quanti dispositivi diversi l'utente ha utilizzato per accedere alla piattaforma SphereFilm

DROP PROCEDURE IF EXISTS Conta_Dispositivi_Diversi;
DELIMITER $$
CREATE PROCEDURE Conta_Dispositivi_Diversi(IN Id_Cliente INT,OUT Quanti_Dispositivi INT)
BEGIN

        SET Quanti_Dispositivi =    (
                                        SELECT  U.Quanti_Dispositivi
                                        FROM    Utente U
                                        WHERE   U.Id_Cliente = Id_Cliente
                                    );

END $$
DELIMITER ;

-- inserimento di una lingua disponibile per i sottotitoli
DROP PROCEDURE IF EXISTS Inserisci_Disposizione;
DELIMITER $$
CREATE PROCEDURE Inserisci_Disposizione(IN Lingua VARCHAR(100),IN Id_Film INT)
BEGIN

        DECLARE Lingua_Esistente TINYINT DEFAULT 0;
        DECLARE Film_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Disposizione D
                        WHERE   D.Id_Film = Id_Film
                    )
        THEN SET Lingua_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Film F
                        WHERE   F.Id_Film = Id_Film
                    )
        THEN SET Film_Esistente = 1;

        END IF;

        IF (Lingua_Esistente = 1 AND Film_Esistente = 1) THEN

            INSERT INTO Disposizione VALUES (Lingua,Id_Film);

        ELSEIF (Lingua_Esistente = 0 AND Film_Esistente = 1) THEN 

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lingua Inesistente: Lingua errata!';   

        ELSEIF (Lingua_Esistente = 1 AND Film_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film Inesistente: Id_Film errato!';   

        END IF;

END $$
DELIMITER ;

-- inserisce una nuova lingua disponibile per il doppiaggio

DROP PROCEDURE IF EXISTS Inserisci_Doppiaggio;
DELIMITER $$
CREATE PROCEDURE Inserisci_Doppiaggio(IN Lingua VARCHAR(100),IN Id_Film INT)
BEGIN

        DECLARE Lingua_Esistente TINYINT DEFAULT 0;
        DECLARE Film_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Doppiaggio D
                        WHERE   D.Id_Film = Id_Film
                    )
        THEN SET Lingua_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Film F
                        WHERE   F.Id_Film = Id_Film
                    )
        THEN SET Film_Esistente = 1;

        END IF;

        IF (Lingua_Esistente = 1 AND Film_Esistente = 1) THEN

            INSERT INTO Disposizione VALUES (Lingua,Id_Film);

        ELSEIF (Lingua_Esistente = 0 AND Film_Esistente = 1) THEN 

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lingua Inesistente: Lingua errata!';   

        ELSEIF (Lingua_Esistente = 1 AND Film_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film Inesistente: Id_Film errato!';   

        END IF;

END $$
DELIMITER ;

-- inserisce una nuova connessione del dispositivo, che sarà geolocalizzato

DROP PROCEDURE IF EXISTS Inserisci_Nuova_Connessione;
DELIMITER $$
CREATE PROCEDURE Inserisci_Nuova_Connessione (IN Id_Cliente INT,IN Tipo VARCHAR(80),IN Longitudine DOUBLE,IN Latitudine DOUBLE,IN IP CHAR(21),IN Inizio_Connesione TIMESTAMP,IN Fine_Connessione TIMESTAMP)
BEGIN

        DECLARE Utente_Esistente TINYINT DEFAULT 0;
        DECLARE Posizione_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Utente U
                        WHERE   U.Id_Cliente = Id_Cliente
                    )
        THEN SET Utente_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Posizione P
                        WHERE   P.Latitudine = Latitudine AND P.Longitudine = Longitudine
                    )
        THEN SET Posizione_Esistente = 1;

        END IF;

        IF (Utente_Esistente = 1 AND Posizione_Esistente = 1) THEN

            INSERT INTO Dispositivo VALUES(IP, Tipo, Longitudine, Latitudine, Inizio_Connesione, Fine_Connessione);

            INSERT INTO Connessione VALUES(IP,Id_Cliente,Inizio_Connesione,Fine_Connessione);

        ELSEIF (Utente_Esistente = 0 AND Posizione_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente inesistente: Id_Cliente errato!';

        ELSEIF (Utente_Esistente = 1 AND Posizione_Esistente = 0) THEN 

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Posizione inesistente: Longitudine o Latitudine errati!';

        END IF;

END $$

DELIMITER ;

-- restituisce quanti premi ha vinto un certo artista

DROP PROCEDURE IF EXISTS Conta_Premi_Attore;
DELIMITER $$
CREATE PROCEDURE Conta_Premi_Attore(IN Id_Artista INT,OUT Quanti_Premi INT)
BEGIN

        SET Quanti_Premi =  (
                                SELECT  A.Quanti_Premi
                                FROM    Attore A
                                WHERE   A.Id_Artista = Id_Artista
                            );

END $$
DELIMITER ;

-- restituisce quanti premi ha vinto un certo film

DROP PROCEDURE IF EXISTS Conta_Premi_Film;
DELIMITER $$
CREATE PROCEDURE Conta_Premi_Film(IN Id_Film INT,OUT Quanti_Premi INT)
BEGIN

        SET Quanti_Premi =  (
                                SELECT  F.Quanti_Premi
                                FROM    Film F
                                WHERE   F.Id_Film = Id_Film
                            );

END $$
DELIMITER ;

-- indica quanti premi ha vinto un certo regista

DROP PROCEDURE IF EXISTS Conta_Premi_Regista;
DELIMITER $$
CREATE PROCEDURE Conta_Premi_Regista(IN Id_Artista INT,OUT Quanti_Premi INT)
BEGIN

        SET Quanti_Premi =  (
                                SELECT  R.Quanti_Premi
                                FROM    Regista R
                                WHERE   R.Id_Artista = Id_Artista
                            );

END $$
DELIMITER ;

-- inserisce un premio per un attore

DROP PROCEDURE IF EXISTS Inserisci_Premiazione_Attore_Procedura;
DELIMITER $$
CREATE PROCEDURE Inserisci_Premiazione_Attore_Procedura(IN Nome VARCHAR(200),IN Istituzione VARCHAR(200),IN Anno_Premiazione_Attore INT,IN Id_Artista INT)
BEGIN
        DECLARE Premio_Esistente TINYINT DEFAULT 0;
        DECLARE Attore_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Premio_Attore PA
                        WHERE   PA.Nome = Nome AND PA.Istituzione = Istituzione
                    )
        THEN SET Premio_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Attore A
                        WHERE   A.Id_Artista = Id_Artista
                    )
        THEN SET Attore_Esistente = 1;
        END IF;

        IF (Premio_Esistente = 1 AND Attore_Esistente = 1) THEN

            INSERT INTO Premiazione_Attore VALUES(Nome,Istituzione,Id_Artista,Anno_Premiazione_Attore);

        ELSEIF(Premio_Esistente = 0 AND Attore_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Premio per il attore inesistente: Nome o Istituzione errati!';

        ELSEIF(Premio_Esistente = 1 AND Attore_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Attore inesistente: Id_Artista errato!';

        END IF;

END $$

DELIMITER ;

-- inserisce un premio per un film

DROP PROCEDURE IF EXISTS Inserisci_Premiazione_Film_Procedura;
DELIMITER $$
CREATE PROCEDURE Inserisci_Premiazione_Film_Procedura(IN Nome VARCHAR(200),IN Istituzione VARCHAR(200),IN Anno_Premiazione_Film INT,IN Id_Film INT)
BEGIN
        DECLARE Premio_Esistente TINYINT DEFAULT 0;
        DECLARE Film_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Premio_Film PF
                        WHERE   PF.Nome = Nome AND PF.Istituzione = Istituzione
                    )
        THEN SET Premio_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Film F
                        WHERE   F.Id_Film = Id_Film
                    )
        THEN SET Film_Esistente = 1;
        END IF;

        IF (Premio_Esistente = 1 AND Film_Esistente = 1) THEN

            INSERT INTO Premiazione_Film VALUES(Id_Film,Nome,Istituzione,Anno_Premiazione_Film);

        ELSEIF(Premio_Esistente = 0 AND Film_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Premio per il film inesistente: Nome o Istituzione errati!';

        ELSEIF(Premio_Esistente = 1 AND Film_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film inesistente: Id_Artista errato!';

        END IF;

END $$

-- inserisce un premio per un regista

DROP PROCEDURE IF EXISTS Inserisci_Premiazione_Regista_Procedura;
DELIMITER $$
CREATE PROCEDURE Inserisci_Premiazione_Regista_Procedura(IN Nome VARCHAR(200),IN Istituzione VARCHAR(200),IN Anno_Premiazione_Regista INT,IN Id_Artista INT)
BEGIN
        DECLARE Premio_Esistente TINYINT DEFAULT 0;
        DECLARE Regista_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Premio_Regista PR
                        WHERE   PR.Nome = Nome AND PR.Istituzione = Istituzione
                    )
        THEN SET Premio_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Regista R
                        WHERE   R.Id_Artista = Id_Artista
                    )
        THEN SET Regista_Esistente = 1;
        END IF;

        IF (Premio_Esistente = 1 AND Regista_Esistente = 1) THEN

            INSERT INTO Premiazione_Regista VALUES(Nome,Istituzione,Anno_Premiazione_Regista,Id_Artista);

        ELSEIF(Premio_Esistente = 0 AND Regista_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Premio per il regista inesistente: Nome o Istituzione errati!';

        ELSEIF(Premio_Esistente = 1 AND Regista_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Regista inesistente: Id_Artista errato!';

        END IF;

END $$

-- procedura per restituire quante lingue ci sono sia per il doppiaggio che per i sottotitoli in un certo film

DROP PROCEDURE IF EXISTS Quante_Lingue_Disponibili_Doppiaggio_Sottotitolo;
DELIMITER $$
CREATE PROCEDURE Quante_Lingue_Disponibili_Doppiaggio_Sottotitolo(IN Id_Film INT,OUT Quante_Lingue INT)
BEGIN

    SET Quante_Lingue =     (
                                SELECT  F.Quante_Lingue
                                FROM    Film F
                                WHERE   F.Id_Film = Id_Film
                            );

END $$
DELIMITER ;

-- procedura per indicare quanti ritardi nei pagamenti dell'abbonamento per un determinato utente

DROP PROCEDURE IF EXISTS Conta_Abbonamenti_Ritardo;
DELIMITER $$
CREATE PROCEDURE Conta_Abbonamenti_Ritardo(IN Id_Cliente_ INT, OUT Quanti_Ritardi_ INT)
BEGIN
  
        SET Quanti_Ritardi_ =    (
                                    SELECT  U.Quanti_Ritardi
                                    FROM    Utente U
                                    WHERE   U.Id_Cliente = Id_Cliente_
                                );

END $$
DELIMITER ;

-- procedura di appoggio per Inserisci_Pagamento_Abbonamento
DROP PROCEDURE IF EXISTS Trova_Stato_Importo;
DELIMITER $$
CREATE PROCEDURE Trova_Stato_Importo(IN Durata_Abbonamento INT,IN Tipo_Abbonamento VARCHAR(100),OUT Stato TINYINT,OUT Importo DOUBLE)
BEGIN

        DECLARE Prezzo_Base DOUBLE DEFAULT 0;

        IF(Durata_Abbonamento <> 1 AND Durata_Abbonamento % 3 <> 0) THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Durata abbonamento errato: possibile 1 mese o un numero di mesi multiplo di 3!';

        END IF;

        IF Tipo_Abbonamento = 'Basic' THEN
            SET Stato = 1;
            SET Prezzo_Base = 3;
        ELSEIF Tipo_Abbonamento = 'Premium' THEN
            SET Stato = 1;
            SET Prezzo_Base = 5;
        ELSEIF Tipo_Abbonamento = 'Special' THEN
            SET Stato = 0;
            SET Prezzo_Base = 8;
        ELSEIF Tipo_Abbonamento = 'Incredible' THEN
            SET Stato = 0;
            SET Prezzo_Base = 10;
        ELSEIF Tipo_Abbonamento = 'King' THEN
            SET Stato = 0;
            SET Prezzo_Base = 12;

        ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abbonamento di tipo Inesistente!';
        END IF;

        SET Importo = ROUND(Prezzo_Base * ( 1 + Durata_Abbonamento * Durata_Abbonamento/100),2); 

END $$

DELIMITER ;

-- procedura per pagare l'abbonamento, quindi inserendo eventualmente i nuovi dati di carta, inserendo sicuramente la nuova fattura e le caratteristiche dell'abbonamento

DROP PROCEDURE IF EXISTS Inserisci_Pagamento_Abbonamento;

DELIMITER $$

CREATE PROCEDURE Inserisci_Pagamento_Abbonamento (IN Id_Cliente INT ,IN Numero_Fattura VARCHAR(45) ,IN Durata_Abbonamento INT ,IN Tipo VARCHAR(100) ,IN Caratterizzazione TEXT,IN Eta TINYINT, IN Ore_Massime INT ,IN Data_Pagamento DATE ,IN Scadenza DATE,IN CVV CHAR(3), IN PAN VARCHAR(19) ,IN Nome_Titolare VARCHAR(100) ,IN Cognome_Titolare VARCHAR(100) ,IN Circuito_Carta VARCHAR(100))
BEGIN

    DECLARE Esistenza_Cliente TINYINT DEFAULT 0;
    DECLARE Esistenza_Carta TINYINT DEFAULT 0;
    DECLARE Stato TINYINT DEFAULT 0;
    DECLARE Importo DOUBLE DEFAULT 0;

     IF EXISTS   (
                    SELECT  1
                    FROM    Utente U
                    WHERE   U.Id_Cliente = Id_Cliente
                )
    THEN SET Esistenza_Cliente = 1;

    END IF;

    IF EXISTS   (
                    SELECT  1
                    FROM    Carta C
                    WHERE   C.CVV = CVV AND C.PAN = PAN
                )
    THEN SET Esistenza_Carta = 1;

    END IF;

    -- creare una procedura che mi consenta di ricavare, dato Durata_Abbonamento e Tipo, informazioni su Importo e Stato

    IF Esistenza_Cliente = 1 THEN

    -- inserire la carta, se non ci sono informazioni coerenti

        IF Esistenza_Carta = 0 THEN
        
            INSERT INTO Carta VALUES (CVV,PAN,Nome_Titolare,Cognome_Titolare,Circuito_Carta);
        
        END IF;

        CALL Trova_Stato_Importo(Durata_Abbonamento,Tipo,Stato,Importo);

    -- inserire la fattura

        INSERT INTO Fattura VALUES (Numero_Fattura,Importo,Scadenza,Data_Pagamento,CVV,PAN);

        -- inserire Abbonamento

        INSERT INTO Abbonamento VALUES (Durata_Abbonamento,Tipo,Caratterizzazione,Stato,Eta,Ore_Massime,Numero_Fattura,Id_Cliente);

        ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente inesistente: Id_Cliente Errato!';

    END IF;

END $$

DELIMITER ;

-- consiglio sui film

-- procedura di utilità per creare le tabelle di appoggio, 
-- necessarie per avere un unico genere all'id per ogni riga. 
-- Si inseriranno alla fine in lista Id_Genere i generi presenti nella caratterizzazione 
-- dell'abbonamento più recente che ha l'utente.

DROP PROCEDURE IF EXISTS Crea_Lista_Caratterizzazioni;
DELIMITER $$
CREATE PROCEDURE Crea_Lista_Caratterizzazioni (IN Id_Cliente INT)
BEGIN

        DECLARE Durata_Abbonamento INT DEFAULT 0;
        DECLARE Data_Pagamento DATE DEFAULT NULL;
        DECLARE Caratterizzazione TEXT DEFAULT '';
        DECLARE Tipo VARCHAR(100) DEFAULT '';
        DECLARE i INT DEFAULT 0;
        DECLARE Quante_Virgole INT DEFAULT 0;
        DECLARE Contenuto TEXT DEFAULT '';
        DECLARE Elimina TEXT DEFAULT '';
        DECLARE Inizio INT DEFAULT 0;
        DECLARE Fine INT DEFAULT 0;
        DECLARE Quanti_Divisori INT DEFAULT 0;
        DECLARE Id_Prestito INT DEFAULT 0;
        DECLARE Genere_Albero_Appoggio VARCHAR(100) DEFAULT '';
        DECLARE Genere VARCHAR(100) DEFAULT '';
        DECLARE Genere_Prestito VARCHAR(100) DEFAULT '';
        -- variabile per l'handler
        DECLARE Finito_Ciclo INT DEFAULT 0;
        -- cursore per inserire in una nuova tabella l'identificatore del film e il Genere
        DECLARE Cursore_Trovato CURSOR FOR  (
                                                SELECT  DISTINCT F.Id_Film,F.Genere  
                                                FROM    Film F
                                            ); 
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito_Ciclo = 1; -- handler per il cursore, quando esce dalla tabella


        WITH Abbonamento_Giusto AS  (
                                        SELECT      A.Durata_Abbonamento,A.Caratterizzazione,F.Data_Pagamento,A.Tipo
                                        FROM        Utente U NATURAL JOIN Abbonamento A NATURAL JOIN Fattura F
                                        WHERE       U.Id_Cliente = Id_Cliente AND F.Data_Pagamento IS NOT NULL
                                        ORDER BY    F.Data_Pagamento DESC  
                                    )
        SELECT  AG.Durata_Abbonamento,AG.Data_Pagamento,AG.Caratterizzazione,AG.Tipo INTO Durata_Abbonamento,Data_Pagamento,Caratterizzazione,Tipo
        FROM    Abbonamento_Giusto AG
        LIMIT   1;   

        -- messaggio d'errore se l'abbonamento è Basic
        IF(Tipo = 'Basic')THEN

             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo di abbonamento errato: il tipo Basic non permette contenuti consigliati';

        END IF;


        -- messaggio d'errore se l'abbonamento è scaduto

        IF (Data_Pagamento <> CURRENT_DATE) AND (Data_Pagamento + INTERVAL Durata_Abbonamento MONTH < CURRENT_DATE) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abbonamento Scaduto: pagare il nuovo abbonamento per accedere al contenuto';

        END IF;

        -- troviamo i film con la stessa caratterizzazione;

        DROP TABLE IF EXISTS Lista_Caratterizzazioni;
        CREATE TABLE Lista_Caratterizzazioni(Contenuto VARCHAR(255) PRIMARY KEY);

        SET Quante_Virgole = (SELECT LENGTH(Caratterizzazione) - LENGTH(REPLACE(Caratterizzazione, ',', '')));
        SET Contenuto = Caratterizzazione;

    WHILE(i <= Quante_Virgole) DO

        SET Fine = POSITION(',' IN Contenuto); -- Trova la posizione della virgola

        IF Fine = 0 THEN -- Se non trova più virgole, prendi l'intera stringa
            SET Fine = LENGTH(Contenuto) + 1;
        END IF;

        SET Elimina = TRIM(SUBSTRING(Contenuto, 1, Fine - 1)); -- Prendi il genere tra le virgole
        INSERT INTO Lista_Caratterizzazioni VALUES (Elimina); -- Inserisci il genere nella tabella

        SET Contenuto = TRIM(SUBSTRING(Contenuto, Fine + 1)); -- Aggiorna la stringa rimuovendo il genere che hai già processato

        SET i = i + 1;

    END WHILE;

        -- dalla lista possiamo trovare tutti i film consigliati
        -- creaiamo una tabella in cui inserire 

        DROP TABLE IF EXISTS Lista_Id_Genere_Appoggio;
        CREATE TABLE Lista_Id_Genere_Appoggio(
                                        Id INT,
                                        Genere VARCHAR(100),
                                        PRIMARY KEY(Id,Genere)
                                    );
        
        OPEN Cursore_Trovato;

    scan: LOOP

        IF Finito_Ciclo = 1 THEN
            LEAVE scan;
        END IF;

        FETCH Cursore_Trovato INTO Id_Prestito,Genere_Prestito;

        -- devo contare i '/'

        SET Quanti_Divisori = (SELECT LENGTH(Genere_Prestito) - LENGTH(REPLACE(Genere_Prestito, '/', '')));

        SET Genere_Albero_Appoggio = Genere_Prestito;

        SET i = 0;

            WHILE(i <= Quanti_Divisori) DO

                SET Fine = POSITION('/' IN Genere_Albero_Appoggio); -- Trova la posizione della virgola

                IF Fine = 0 THEN -- Se non trova più virgole, prendi l'intera stringa
                    SET Fine = LENGTH(Genere_Albero_Appoggio) + 1;
                END IF;

                SET Elimina = TRIM(SUBSTRING(Genere_Albero_Appoggio, 1, Fine - 1)); -- Prendi il genere tra le virgole
                
                INSERT IGNORE INTO Lista_Id_Genere_Appoggio VALUES (Id_Prestito,Elimina); -- Inserisci il genere nella tabella

                SET Genere_Albero_Appoggio = TRIM(SUBSTRING(Genere_Albero_Appoggio, Fine + 1)); -- Aggiorna la stringa rimuovendo il genere che hai già processato

                SET i = i + 1;

            END WHILE;

        END LOOP scan;

        CLOSE Cursore_Trovato;

        -- a questo punto, dobbiamo creare una tabella che combini le 2

        DROP TABLE IF EXISTS Lista_Id_Genere;
        CREATE TABLE Lista_Id_Genere(   Id INT,
                                        Genere VARCHAR(100),
                                        PRIMARY KEY(Id,Genere)
                                    );

        INSERT INTO Lista_Id_Genere(Id,Genere)
        SELECT  LIGA.Id,LIGA.Genere 
        FROM    Lista_Id_Genere_Appoggio LIGA
        WHERE   LIGA.Genere IN(
                                  SELECT  LC.Contenuto
                                  FROM    Lista_Caratterizzazioni LC
                              );

END $$

DELIMITER ;

-- a questo punto abbiamo 3 opzioni: 
-- 1)classifica in base ai premi vinti dai film dei generi presenti in Lista_Id_Genere
-- 2)classifica in base ai premi vinti dai registi presenti nei film dei generi elencati in Lista_Id_Genere
-- 3)classifica in base ai premi vinti dagli attori presenti nei film dei generi elencati in Lista_Id_Genere

-- Attori

-- function di utilità per calcolare il punteggio per l'attore

DROP FUNCTION IF EXISTS Calcola_Punteggio_Attore;
DELIMITER $$
CREATE FUNCTION Calcola_Punteggio_Attore(Nome VARCHAR(200),Peso DOUBLE)
RETURNS DOUBLE DETERMINISTIC
BEGIN

    DECLARE Peggiore_Trovato INT DEFAULT 0;
    DECLARE Peggior_Trovato INT DEFAULT 0;

    SET Peggior_Trovato = INSTR(Nome,'Peggior');
    SET Peggiore_Trovato = INSTR(Nome,'Peggiore');

    IF(Peggior_Trovato = 0 AND Peggiore_Trovato = 0) THEN
        RETURN Peso * 13.301;
    
    ELSE 
        RETURN Peso * -13.301;


    END IF;

    

END $$

DELIMITER ;


-- procedura di utilità per stilare la classifica dei film più consigliati in base agli attori

DROP PROCEDURE IF EXISTS Stampa_Film_Attori_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Attori_Preferiti()
BEGIN

-- verifico che la tabella esista, se non è così,messaggio di errore

        IF NOT EXISTS	( 
							SELECT table_name 
							FROM information_schema.tables 
							WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere'
                        ) 
        
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabella Inesistente,chiamare prima la procedura Crea_Lista_Caratterizzazioni(Id_Utente)';

        END IF;


          -- uso la tabella che ho creato in Stampa_Film_Consigliati
        WITH Attore_Trovato AS  (
                                        SELECT  LID.*,I.Id_Artista
                                        FROM    Lista_Id_Genere LID INNER JOIN Interpretazione I ON LID.Id = I.Id_Film
                                ),
        Calcolo_Peso AS (
                                SELECT      ATO.Id_Artista,PA.Nome,PA.Istituzione,PA.Anno_Premiazione_Attore,IF(PA.Nome IS NULL AND PA.Istituzione IS NULL AND PA.Anno_Premiazione_Attore IS NULL,100,Calcola_Punteggio_Attore(PA.Nome,PA.Peso)) AS Punteggio_Premio
                                FROM        Attore_Trovato ATO NATURAL LEFT OUTER JOIN Premiazione_Attore PAT NATURAL LEFT OUTER JOIN Premio_Attore PA
                                GROUP BY    ATO.Id_Artista,PA.Nome,PA.Istituzione,PA.Anno_Premiazione_Attore -- va corretto con attore al suo posto
                        ),
        Artista_Punteggio_Alto AS   (
                                            SELECT      CP.Id_Artista,SUM(CP.Punteggio_Premio) AS Totale_Punteggio
                                            FROM        Calcolo_Peso CP
                                            GROUP BY    CP.Id_Artista
                                    )
       
        SELECT          ATO.Id,SUM(APA.Totale_Punteggio) AS Punteggio_Film
        FROM            Attore_Trovato ATO NATURAL JOIN Artista_Punteggio_Alto APA  
        GROUP BY        ATO.Id;    
        
END $$

DELIMITER ;

-- procedura di stampa dei film consigliati in base ai premi vinti: procedura da chiamare per fare i test

DROP PROCEDURE IF EXISTS Stampa_Film_Consigliati_Attori;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Consigliati_Attori(IN Id_Utente INT)
BEGIN
        CALL Crea_Lista_Caratterizzazioni(Id_Utente);
        -- ora possiamo a seconda della scelta, classificare in base ai premi del film, in base all'attore e regista preferito
        CALL Stampa_Film_Attori_Preferiti();
        DROP TABLE Lista_Id_Genere;
        DROP TABLE Lista_Caratterizzazioni;
        DROP TABLE Lista_Id_Genere_Appoggio;
END $$

DELIMITER ;

-- regista

-- function di utilità per calcolare il punteggio del regista
DROP FUNCTION IF EXISTS Calcola_Punteggio_Regista;
DELIMITER $$
CREATE FUNCTION Calcola_Punteggio_Regista(Nome VARCHAR(200),Peso DOUBLE)
RETURNS DOUBLE DETERMINISTIC
BEGIN

    DECLARE Peggiore_Trovato INT DEFAULT 0;
    DECLARE Peggior_Trovato INT DEFAULT 0;
    
    SET Peggior_Trovato = INSTR(Nome,'Peggior');
    SET Peggiore_Trovato = INSTR(Nome,'Peggiore');

   IF(Peggior_Trovato = 0 AND Peggiore_Trovato = 0) THEN

        RETURN Peso * 33.301;

    ELSE
        RETURN Peso * -33.301;

    END IF;

END $$

DELIMITER ;

-- procedura di utilità per stilare la classifica dei film più consigliati in base ai registi

DROP PROCEDURE IF EXISTS Stampa_Film_Registi_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Registi_Preferiti()
BEGIN

        -- verifico l'esistenza della tabella   
        IF NOT EXISTS ( 
							SELECT table_name
							FROM information_schema.tables 
							WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere'
						) 
        
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabella Inesistente,chiamare prima la procedura Crea_Lista_Caratterizzazioni(Id_Utente)';
        
        END IF;
        
        -- uso la tabella che ho creato in Stampa_Film_Consigliati
        WITH Regista_Trovato AS  (
                                        SELECT  LID.*,D.Id_Artista
                                        FROM    Lista_Id_Genere LID INNER JOIN Direzione D ON LID.Id = D.Id_Film
                                ),
        Calcolo_Peso AS (
                                SELECT      RT.Id_Artista,PE.Nome,PE.Istituzione,PER.Anno_Premiazione_Regista,IF(PER.Nome IS NULL AND PER.Istituzione IS NULL AND PER.Anno_Premiazione_Regista IS NULL,100,Calcola_Punteggio_Film(PE.Nome,PE.Peso)) AS Punteggio_Premio
                                FROM        Regista_Trovato RT NATURAL LEFT OUTER JOIN Premiazione_Regista PER NATURAL LEFT OUTER JOIN Premio_Regista PE  
                                GROUP BY    RT.Id_Artista,PE.Nome,PE.Istituzione,PER.Anno_Premiazione_Regista
                        ),
        Artista_Punteggio_Alto AS   (
                                            SELECT      CP.Id_Artista,SUM(CP.Punteggio_Premio) AS Totale_Punteggio
                                            FROM        Calcolo_Peso CP
                                            GROUP BY    CP.Id_Artista
                                    )
        SELECT      RT.Id,APA.Totale_Punteggio
        FROM        Regista_Trovato RT NATURAL JOIN Artista_Punteggio_Alto APA
        GROUP BY    RT.Id    
        ORDER BY    APA.Totale_Punteggio DESC;   
        
END $$

DELIMITER ;

-- procedura di stampa dei film consigliati in base ai registi: procedura da chiamare per fare i test

DROP PROCEDURE IF EXISTS Stampa_Film_Consigliati_Registi;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Consigliati_Registi(IN Id_Utente INT)
BEGIN

        CALL Crea_Lista_Caratterizzazioni(Id_Utente);
        -- ora possiamo a seconda della scelta, classificare in base ai premi del film, in base all'attore e regista preferito
        CALL Stampa_Film_Registi_Preferiti();
        DROP TABLE Lista_Id_Genere;
        DROP TABLE Lista_Caratterizzazioni;
        DROP TABLE Lista_Id_Genere_Appoggio;
END $$

DELIMITER ;

-- film

-- function di appoggio per calcolare il punteggio per il regista

DROP FUNCTION IF EXISTS Calcola_Punteggio_Regista;
DELIMITER $$
CREATE FUNCTION Calcola_Punteggio_Regista(Nome VARCHAR(200),Peso DOUBLE)
RETURNS DOUBLE DETERMINISTIC
BEGIN

    DECLARE Peggiore_Trovato INT DEFAULT 0;
    DECLARE Peggior_Trovato INT DEFAULT 0;
    
    SET Peggior_Trovato = INSTR(Nome,'Peggior');
    SET Peggiore_Trovato = INSTR(Nome,'Peggiore');

   IF(Peggior_Trovato = 0 AND Peggiore_Trovato = 0) THEN

        RETURN Peso * 23.301;

    ELSE
        RETURN Peso * -23.301;

    END IF;

END $$

DELIMITER ;

-- stampa di film consigliati

DROP PROCEDURE IF EXISTS Stampa_Film_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Preferiti()
BEGIN

        
        IF NOT EXISTS	(	SELECT table_name 
							FROM information_schema.tables 
							WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere'
						) 
		THEN
        
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabella Inesistente,chiamare prima la procedura Crea_Lista_Caratterizzazioni(Id_Utente)';
        
        END IF;

        -- uso la tabella che ho creato in Stampa_Film_Consigliati
        WITH Film_Trovato AS    (
                                        SELECT  LID.Genere,LID.Id AS Id_Film,PF.Nome,PF.Istituzione,PF.Anno_Premiazione_Film
                                        FROM    Lista_Id_Genere LID LEFT OUTER JOIN Premiazione_Film PF ON LID.Id = PF.Id_Film
                                ),
        Calcolo_Peso AS (
                                SELECT          FT.Id_Film,FT.Nome,FT.Istituzione,FT.Anno_Premiazione_Film,IF(PF.Nome IS NULL AND PF.Istituzione IS NULL AND PF.Anno_Premiazione_Film IS NULL,100,Calcola_Punteggio_Film(PF.Nome,PF.Peso)) AS Punteggio_Premio
                                FROM            Film_Trovato FT NATURAL LEFT OUTER JOIN Premio_Film PF
                                GROUP BY        FT.Id_Film,FT.Nome,FT.Istituzione,PF.Anno_Premiazione_Film
                        ),
        Film_Punteggio AS (
                                SELECT      CP.Id_Film,SUM(CP.Punteggio_Premio) AS Totale_Punteggio
                                FROM        Calcolo_Peso CP
                                GROUP BY    CP.Id_Film
                          )
        
        SELECT          FM.Id_Film,FM.Totale_Punteggio
        FROM            Film_Punteggio FM
        ORDER BY        FM.Totale_Punteggio DESC;    

END $$

DELIMITER ;

-- procedura di stampa dei film consigliati in base ai registi: procedura da chiamare per fare i test

DROP PROCEDURE IF EXISTS Stampa_Film_Consigliati;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Consigliati(IN Id_Utente INT)
BEGIN

        CALL Crea_Lista_Caratterizzazioni(Id_Utente);
        -- ora possiamo a seconda della scelta, classificare in base ai premi del film, in base all'attore e regista preferito
        CALL Stampa_Film_Preferiti();
        DROP TABLE Lista_Id_Genere;
        DROP TABLE Lista_Caratterizzazioni;
        DROP TABLE Lista_Id_Genere_Appoggio;
END $$

DELIMITER ;

-- classifica film con il suo formato, in base alle visualizzazioni degli utenti

DROP PROCEDURE IF EXISTS Genera_Classifica;
DELIMITER $$
CREATE PROCEDURE Genera_Classifica()
BEGIN
    -- affianco alla tabella formato,il formato successivo dello stessi film, rilasciati in date differenti
     WITH Tabella_Appoggio AS   (
                                    SELECT  FM.Id_Film,FM.Id_Formato,FM.Data_Aggiornamento,FM.Data_Rilascio,LEAD(FM.Data_Rilascio,1) OVER A AS Data_Rilascio_Successiva
                                    FROM    Film_Formato FM
                                    WINDOW A AS (
                                                    PARTITION BY FM.Id_Film,FM.Id_Formato,FM.Data_Aggiornamento
                                                    ORDER BY FM.Data_Rilascio
                                                )
                                ), 
    -- creo la tabella delle date visualizzate, che rispettono il formato delle date che risulta essere corretto, ovvero compreso fra la data del rilascio e del suo successivo, per ciascun film
	 Tabella_Appoggio2 AS(
                            SELECT  VF.Id_Film, TA.Id_Formato,TA.Data_Aggiornamento,TA.Data_Rilascio,VF.Ora_Visualizzazione,TA.Data_Rilascio_Successiva -- COUNT(*) AS Quante_Visualizzazioni --
                            FROM    Visualizzazioni_Film VF NATURAL JOIN Tabella_Appoggio TA
                            WHERE   TA.Data_Rilascio_Successiva IS NULL AND ( (DATE(VF.Ora_Visualizzazione) >= TA.Data_Rilascio) OR ( TA.Data_Rilascio_Successiva IS NOT NULL AND DATE(VF.Ora_Visualizzazione) BETWEEN TA.Data_Rilascio AND TA.Data_Rilascio_Successiva) )
                            ),
    -- conto le visualizzazioni corrette per ogni formato del film
    Conteggio_Visualizzazioni AS (
                                    SELECT      TA.Id_Film, TA.Id_Formato, TA.Data_Aggiornamento, COUNT(DISTINCT TA.Ora_Visualizzazione) AS Quante_Visualizzazioni
                                    FROM        Tabella_Appoggio2 TA
                                    GROUP BY    TA.Id_Film,TA.Id_Formato,TA.Data_Aggiornamento
                                ),
    -- classifica del film più visualizzati per ciascun formato, basandosi su quante visualizzazioni ha ricevuto
    Classifica_Appoggio AS (
                                SELECT CV.Id_Film, CV.Id_Formato,CV.Data_Aggiornamento, CV.Quante_Visualizzazioni, DENSE_RANK() OVER S AS Graduatoria
                                FROM Conteggio_Visualizzazioni CV
                                WINDOW S AS (
                                                ORDER BY CV.Quante_Visualizzazioni DESC
                                            )
                            )

    SELECT CA.Id_Film, CA.Id_Formato, CA.Quante_Visualizzazioni, CA.Graduatoria
    FROM Classifica_Appoggio CA
    ORDER BY CA.Graduatoria;
    

END $$

DELIMITER ;

-- procedura di appoggio per l'evento 
DROP PROCEDURE IF EXISTS Procedura_Lista;
DELIMITER $$
CREATE PROCEDURE Procedura_Lista()
BEGIN


-- se la tabella di log non esiste, la creiamo

    IF NOT EXISTS	(
						SELECT table_name 
						FROM information_schema.tables 
						WHERE table_schema = 'mydb' AND table_name = 'log_suggerimenti'
					) 
	THEN
    
            CREATE TABLE Log_Utenti (
                                        Id INT NOT NULL,
                                        Tipo_Abbonamento VARCHAR(100) NOT NULL,
                                        PRIMARY KEY(Id_Utente)        
                                    ); 

    END IF;

    -- troviamo gli utenti che contengono abbonamenti King e incredible del mese
    INSERT INTO Log_Utenti
    WITH Utenti_Corretti AS (
                                SELECT  A.Id_Utente,A.Tipo
                                FROM    Abbonamento A
                                WHERE   (A.Tipo = 'Incredible' OR A.Tipo = 'King') AND MONTH(A.Data_Pagamento) + A.Durata_Abbonamento >= MONTH(CURRENT_DATE)
                            )
    -- inseriamo quelli non presenti nel LOG
    SELECT  UC.*
    FROM    Log_Utenti LU LEFT OUTER JOIN Utenti_Corretti UC ON (LU.Id = UC.Id_Utente AND LU.Tipo_Abbonamento = UC.Tipo)
    WHERE   UC.Id_Utente IS NULL;


    -- eliminiamo quelli non più abbonati
    WITH Utenti_Corretti AS (
                                SELECT  A.Id_Utente,A.Tipo
                                FROM    Abbonamento A
                                WHERE   (A.Tipo = 'Incredible' OR A.Tipo = 'King') AND MONTH(A.Data_Pagamento) + A.Durata_Abbonamento >= MONTH(CURRENT_DATE)
                            )
    -- eliminiamo il log vecchio
    DELETE FROM Log_Utenti LU
    WHERE (LU.Id,LU.Tipo_Abbonamento) NOT IN(
                                                SELECT  UC.*
                                                FROM    Utenti_Corretti UC
                                            );


END $$

DELIMITER ;

-- Il punteggio dell'utente dipendente dal tipo di abbonamento e viene inserito nella tabella Suggerimento_Utenti, contenente l'id dell'utente e gli attributi del film.
-- Ecco la procedura che la gestisce

DROP PROCEDURE IF EXISTS Ascolto_Suggerimento;
DELIMITER $$

CREATE PROCEDURE Ascolto_Suggerimento   (
                                            IN Id_Utente INT,
                                            IN Id_Film INT,
                                            IN Nome_Film VARCHAR(100),
                                            IN Anno_Produzione INT,
                                            IN Durata INT,
                                            IN Paese_Produzione VARCHAR(100),
                                            IN Genere VARCHAR(100),
                                            IN Descrizione TEXT
                                        )
BEGIN

DECLARE Utente_Presente TINYINT DEFAULT 0; 
DECLARE Film_Esistente TINYINT DEFAULT 0;
DECLARE Abbonamento_Cliente VARCHAR(40) DEFAULT '';
DECLARE Punteggio DOUBLE DEFAULT 0;

-- grazie al LOG posso ricavare informazioni sull'utente
IF EXISTS   (
                SELECT  1
                FROM    Log_Utenti LU
                WHERE   LU.Id = Id_Utente
            )
THEN SET Utente_Presente = 1;

END IF;

IF EXISTS   (
                SELECT  1
                FROM    Film F
                WHERE   F.Id_Film = Id_Film
            )
THEN SET Film_Esistente = 1;

END IF;

-- se l'utente non è presente, il suo suggerimento non viene colto e viene lanciato un messaggio d'errore
IF Utente_Presente = 0 THEN

    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non presente fra la lista di abbonati di tipo Incredible o King';

END IF;

-- se il film già esiste, si da un messaggio di errore:
IF Film_Esistente = 1 THEN

    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film già esistente nel catalogo!';

END IF;


SET Abbonamento_Cliente =   (
                                SELECT  LU.Tipo_Abbonamento
                                FROM    Log_Utenti LU
                                WHERE   LU.Id = Id_Utente
                            );

IF(Abbonamento_Cliente = 'Incredible') THEN
    
    SET Punteggio = 10;

ELSE 

    SET Punteggio = 70;

END IF;

	 IF NOT EXISTS	(	
						SELECT table_name 
						FROM information_schema.tables 
						WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere'
					) 
	THEN
			CREATE TABLE Suggerimento_Utenti(
                                                    Id_Utente INT NOT NULL,
                                                    Id_Film INT NOT NULL,
                                                    Nome_Film VARCHAR(100) NOT NULL,
                                                    Anno_Produzione INT NOT NULL,
                                                    Durata INT NOT NULL,
                                                    Paese_Produzione VARCHAR(100) NOT NULL,
                                                    Genere VARCHAR(100) NOT NULL,
                                                    Descrizione TEXT NOT NULL,
                                                    Punteggio DOUBLE NOT NULL,
                                                    PRIMARY KEY(Id_Utente,Id_Film)
											);
	END IF;

INSERT INTO Suggerimento_Utenti VALUES (Id_Utente,Id_Film,Nome_Film,Anno_Produzione,Durata,Paese_Produzione,Genere,Descrizione,Punteggio);

END $$

DELIMITER ;

-- evento che aggiorna il suggerimento degli utenti

DROP EVENT IF EXISTS Aggiornamento_Suggerimenti;
DELIMITER $$

CREATE EVENT Aggiornamento_Suggerimenti ON SCHEDULE EVERY 1 MONTH
DO BEGIN

DECLARE Procedo TINYINT DEFAULT 0;
-- aggiorno il log

CALL Procedura_Lista();
-- creo la tabella se non esiste
    IF NOT EXISTS 	(	
						SELECT table_name 
						FROM information_schema.tables 
						WHERE table_schema = 'mydb' AND table_name = 'suggerimento_utenti'
					) 
	THEN
    
                CREATE TABLE Suggerimento_Utenti(
                                                    Id_Utente INT NOT NULL,
                                                    Id_Film INT NOT NULL,
                                                    Nome_Film VARCHAR(100) NOT NULL,
                                                    Anno_Produzione INT NOT NULL,
                                                    Durata INT NOT NULL,
                                                    Paese_Produzione VARCHAR(100) NOT NULL,
                                                    Genere VARCHAR(100) NOT NULL,
                                                    Descrizione TEXT NOT NULL,
                                                    Punteggio DOUBLE NOT NULL,
                                                    PRIMARY KEY(Id_Utente,Id_Film)
                                                );

    END IF;

    IF NOT EXISTS (
					SELECT table_name 
					FROM information_schema.tables 
					WHERE table_schema = 'mydb' AND table_name = 'suggerimento_utenti'
                  ) 
    THEN
    
                CREATE TABLE Classifica_Film_Suggeriti  (
                                                            Posizione INT NOT NULL,
                                                            Id_Film INT NOT NULL,
                                                            Punteggio DOUBLE NOT NULL,
                                                            PRIMARY KEY(Id_Film)
                                                        );

    END IF;

-- Prendo la lista se non vuota
    IF EXISTS   (
                    SELECT  1
                    FROM    Suggerimento_Utente
                )
    THEN

        SET Procedo = 1;
    
    END IF;

    IF Procedo = 1 THEN

-- creazione classifica per i suggerimenti

        INSERT INTO Classifica_Film_Suggeriti
        WITH Conteggio_Punteggio AS(
										SELECT      SU.Id_Film,SUM(SU.Punteggio) AS Valore_Suggerimento
										FROM        Suggerimento_Utenti SU
										GROUP BY    SU.Id_Film
                                    )
        SELECT  RANK() OVER W AS Classifica,CP.Id_Film,CP.Valore_Suggerimento
        FROM    Conteggio_Punteggio CP
        WINDOW W AS (
                        PARTITION BY SU.Id_Film
                        ORDER BY SU.Valore_Suggerimento
                    );

        -- Inserimento Film in prima classifica

        INSERT INTO Film
        SELECT  SU.*
        FROM    Classifica_Film CF NATURAL JOIN Suggerimento_Utenti SU
        WHERE   CF.Classifica = 1;

    END IF;

END $$

DELIMITER ;
