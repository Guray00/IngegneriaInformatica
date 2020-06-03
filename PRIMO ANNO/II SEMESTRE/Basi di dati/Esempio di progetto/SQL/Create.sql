-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Dipendente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Dipendente` (
  `CF` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(20) NOT NULL,
  `Cognome` VARCHAR(20) NOT NULL,
  `Data_Ass` DATE NOT NULL,
  `Settore` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Punto_Vendita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Punto_Vendita` (
  `ID_Store` INT NOT NULL,
  `Indirizzo` VARCHAR(30) NOT NULL,
  `Telefono` DOUBLE NOT NULL,
  PRIMARY KEY (`ID_Store`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cliente` (
  `CF` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(20) NOT NULL,
  `Cognome` VARCHAR(20) NOT NULL,
  `Telefono` DOUBLE NOT NULL,
  `Indirizzo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Modulo_Vendita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Modulo_Vendita` (
  `ID_Vendita` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Prezzo` FLOAT NULL,
  `Cliente_CF` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`ID_Vendita`),
  INDEX `fk_Modulo_Vendita_Cliente1_idx` (`Cliente_CF` ASC),
  CONSTRAINT `fk_Modulo_Vendita_Cliente1`
    FOREIGN KEY (`Cliente_CF`)
    REFERENCES `mydb`.`Cliente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Modulo_Riparazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Modulo_Riparazione` (
  `ID_Riparazione` INT NOT NULL,
  `Difetto` VARCHAR(100) NULL,
  `Data_E` DATE NOT NULL,
  `Data_U` DATE NULL,
  `Cliente_CF` VARCHAR(16) NOT NULL,
  `Prezzo` FLOAT NULL,
  `Stato` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`ID_Riparazione`),
  INDEX `fk_Modulo_Riparazione_Cliente1_idx` (`Cliente_CF` ASC),
  CONSTRAINT `fk_Modulo_Riparazione_Cliente1`
    FOREIGN KEY (`Cliente_CF`)
    REFERENCES `mydb`.`Cliente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Prodotto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Prodotto` (
  `ID_prod` INT NOT NULL,
  `Marca` VARCHAR(20) NOT NULL,
  `Modello` VARCHAR(20) NOT NULL,
  `Categoria` VARCHAR(20) NOT NULL,
  `Costo` FLOAT NOT NULL,
  `Prezzo` FLOAT NOT NULL,
  PRIMARY KEY (`ID_prod`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ordine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ordine` (
  `ID_Ordine` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Dipendente_CF` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`ID_Ordine`),
  INDEX `fk_Ordine_Dipendente1_idx` (`Dipendente_CF` ASC),
  CONSTRAINT `fk_Ordine_Dipendente1`
    FOREIGN KEY (`Dipendente_CF`)
    REFERENCES `mydb`.`Dipendente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lista_Riparazioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lista_Riparazioni` (
  `Dipendente_CF` VARCHAR(16) NOT NULL,
  `Modulo_Riparazione_ID_Riparazione` INT NOT NULL,
  PRIMARY KEY (`Dipendente_CF`, `Modulo_Riparazione_ID_Riparazione`),
  INDEX `fk_Dipendente_has_Modulo_Riparazione_Modulo_Riparazione1_idx` (`Modulo_Riparazione_ID_Riparazione` ASC),
  INDEX `fk_Dipendente_has_Modulo_Riparazione_Dipendente_idx` (`Dipendente_CF` ASC),
  CONSTRAINT `fk_Dipendente_has_Modulo_Riparazione_Dipendente`
    FOREIGN KEY (`Dipendente_CF`)
    REFERENCES `mydb`.`Dipendente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dipendente_has_Modulo_Riparazione_Modulo_Riparazione1`
    FOREIGN KEY (`Modulo_Riparazione_ID_Riparazione`)
    REFERENCES `mydb`.`Modulo_Riparazione` (`ID_Riparazione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lista_Vendite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lista_Vendite` (
  `Modulo_Vendita_ID_Vendita` INT NOT NULL,
  `Dipendente_CF` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Modulo_Vendita_ID_Vendita`, `Dipendente_CF`),
  INDEX `fk_Modulo_Vendita_has_Dipendente_Dipendente1_idx` (`Dipendente_CF` ASC),
  INDEX `fk_Modulo_Vendita_has_Dipendente_Modulo_Vendita1_idx` (`Modulo_Vendita_ID_Vendita` ASC),
  CONSTRAINT `fk_Modulo_Vendita_has_Dipendente_Modulo_Vendita1`
    FOREIGN KEY (`Modulo_Vendita_ID_Vendita`)
    REFERENCES `mydb`.`Modulo_Vendita` (`ID_Vendita`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Modulo_Vendita_has_Dipendente_Dipendente1`
    FOREIGN KEY (`Dipendente_CF`)
    REFERENCES `mydb`.`Dipendente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lista_Dipendenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lista_Dipendenti` (
  `Dipendente_CF` VARCHAR(16) NOT NULL,
  `Punto_Vendita_ID_Store` INT NOT NULL,
  PRIMARY KEY (`Dipendente_CF`, `Punto_Vendita_ID_Store`),
  INDEX `fk_Dipendente_has_Punto Vendita_Punto Vendita1_idx` (`Punto_Vendita_ID_Store` ASC),
  INDEX `fk_Dipendente_has_Punto Vendita_Dipendente1_idx` (`Dipendente_CF` ASC),
  CONSTRAINT `fk_Dipendente_has_Punto Vendita_Dipendente1`
    FOREIGN KEY (`Dipendente_CF`)
    REFERENCES `mydb`.`Dipendente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dipendente_has_Punto Vendita_Punto Vendita1`
    FOREIGN KEY (`Punto_Vendita_ID_Store`)
    REFERENCES `mydb`.`Punto_Vendita` (`ID_Store`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Magazzino`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Magazzino` (
  `Prodotto_ID_prod` INT NOT NULL,
  `Punto_Vendita_ID_Store` INT NOT NULL,
  `Quantità` INT NOT NULL,
  PRIMARY KEY (`Prodotto_ID_prod`, `Punto_Vendita_ID_Store`),
  INDEX `fk_Prodotto_has_Punto Vendita_Punto Vendita1_idx` (`Punto_Vendita_ID_Store` ASC),
  INDEX `fk_Prodotto_has_Punto Vendita_Prodotto1_idx` (`Prodotto_ID_prod` ASC),
  CONSTRAINT `fk_Prodotto_has_Punto Vendita_Prodotto1`
    FOREIGN KEY (`Prodotto_ID_prod`)
    REFERENCES `mydb`.`Prodotto` (`ID_prod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prodotto_has_Punto Vendita_Punto Vendita1`
    FOREIGN KEY (`Punto_Vendita_ID_Store`)
    REFERENCES `mydb`.`Punto_Vendita` (`ID_Store`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lista_Ordine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lista_Ordine` (
  `Prodotto_ID_prod` INT NOT NULL,
  `Ordine_ID_Ordine` INT NOT NULL,
  `Quantità` INT NOT NULL,
  PRIMARY KEY (`Prodotto_ID_prod`, `Ordine_ID_Ordine`),
  INDEX `fk_Prodotto_has_Ordine_Ordine1_idx` (`Ordine_ID_Ordine` ASC),
  INDEX `fk_Prodotto_has_Ordine_Prodotto1_idx` (`Prodotto_ID_prod` ASC),
  CONSTRAINT `fk_Prodotto_has_Ordine_Prodotto1`
    FOREIGN KEY (`Prodotto_ID_prod`)
    REFERENCES `mydb`.`Prodotto` (`ID_prod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prodotto_has_Ordine_Ordine1`
    FOREIGN KEY (`Ordine_ID_Ordine`)
    REFERENCES `mydb`.`Ordine` (`ID_Ordine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lista_Prodotti_Riparazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lista_Prodotti_Riparazione` (
  `Prodotto_ID_prod` INT NOT NULL,
  `Modulo_Riparazione_ID_Riparazione` INT NOT NULL,
  PRIMARY KEY (`Prodotto_ID_prod`, `Modulo_Riparazione_ID_Riparazione`),
  INDEX `fk_Prodotto_has_Modulo_Riparazione_Modulo_Riparazione1_idx` (`Modulo_Riparazione_ID_Riparazione` ASC),
  INDEX `fk_Prodotto_has_Modulo_Riparazione_Prodotto1_idx` (`Prodotto_ID_prod` ASC),
  CONSTRAINT `fk_Prodotto_has_Modulo_Riparazione_Prodotto1`
    FOREIGN KEY (`Prodotto_ID_prod`)
    REFERENCES `mydb`.`Prodotto` (`ID_prod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prodotto_has_Modulo_Riparazione_Modulo_Riparazione1`
    FOREIGN KEY (`Modulo_Riparazione_ID_Riparazione`)
    REFERENCES `mydb`.`Modulo_Riparazione` (`ID_Riparazione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lista_Prodotti_Vendita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lista_Prodotti_Vendita` (
  `Modulo_Vendita_ID_Vendita` INT NOT NULL,
  `Prodotto_ID_prod` INT NOT NULL,
  `Quantità` INT NOT NULL,
  PRIMARY KEY (`Modulo_Vendita_ID_Vendita`, `Prodotto_ID_prod`),
  INDEX `fk_Modulo_Vendita_has_Prodotto_Prodotto1_idx` (`Prodotto_ID_prod` ASC),
  INDEX `fk_Modulo_Vendita_has_Prodotto_Modulo_Vendita1_idx` (`Modulo_Vendita_ID_Vendita` ASC),
  CONSTRAINT `fk_Modulo_Vendita_has_Prodotto_Modulo_Vendita1`
    FOREIGN KEY (`Modulo_Vendita_ID_Vendita`)
    REFERENCES `mydb`.`Modulo_Vendita` (`ID_Vendita`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Modulo_Vendita_has_Prodotto_Prodotto1`
    FOREIGN KEY (`Prodotto_ID_prod`)
    REFERENCES `mydb`.`Prodotto` (`ID_prod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
