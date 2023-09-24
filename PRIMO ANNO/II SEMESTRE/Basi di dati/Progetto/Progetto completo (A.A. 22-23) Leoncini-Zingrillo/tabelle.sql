-- Lorenzo Leoncini, Giulio Zingrillo. Progetto di Basi di Dati 2023

-- Questo script inizializza il database, creando le varie tabelle.

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS PLZ; -- ProgettoLeonciniZingrillo
CREATE SCHEMA IF NOT EXISTS PLZ DEFAULT CHARACTER SET utf8;

-- -----------------------------------------------------
-- Tabella Abbonamento
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Abbonamento` (
  `Nome` VARCHAR(45) NOT NULL,
  `Tariffa` INT NOT NULL,
  `Durata` INT,
  `MaxOre` INT,
  `EtaMinima` INT NULL,
  `MaxGB` INT,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Appartenenza
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Appartenenza` (
  `Film` INT NOT NULL,
  `Genere` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Film`, `Genere`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Artista
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Artista` (
  `Id` INT NOT NULL,
  `Nome` VARCHAR(255) NOT NULL,
  `Cognome` VARCHAR(255) NOT NULL,
   `Pseudonimo` VARCHAR(255),
    `Profilo` VARCHAR(3000) NOT NULL,
    `Attore` TINYINT(1) NOT NULL,
     `Regista` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella CartaDiCredito
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`CartaDiCredito` (
  `Numero` BIGINT NOT NULL,
  `CVV`INT NOT NULL,
  `NomeIntestatario` VARCHAR(255) NOT NULL,
   `CognomeIntestatario` VARCHAR(255)  NOT NULL,
     `MeseScadenza`INT NOT NULL,
      `AnnoScadenza`INT NOT NULL,
  PRIMARY KEY (`Numero`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella CodificaVideo
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`CodificaVideo` (
  `Contenuto` INT NOT NULL,
  `FormatoVideo`INT NOT NULL,
  PRIMARY KEY (`Contenuto`, `FormatoVideo`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella Connessione
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Connessione` (
  `Inizio` DATETIME NOT NULL,
  `Dispositivo`INT NOT NULL,
  `IP` BIGINT NOT NULL,
  `Fine` DATETIME,
  `Utente`INT NOT NULL,
  PRIMARY KEY (`Inizio`, `Dispositivo`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Contenuto
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Contenuto` (
  `Id` INT NOT NULL,
  `Dimensione` BIGINT NOT NULL,
  `Lunghezza` INT NOT NULL,
  `Film` INT NOT NULL,
  `LinguaAudio` VARCHAR(45),
  `CodificaAudio`INT,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Critico
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Critico` (
  `Id` INT NOT NULL,
  `Nome` VARCHAR(255) NOT NULL,
    `Cognome` VARCHAR(255) NOT NULL,
    `Pseudonimo` VARCHAR(255),
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Direzione
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Direzione` (
  `Film` INT NOT NULL,
  `Artista` INT NOT NULL,
  PRIMARY KEY (`Film`, `Artista`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella Dispositivo
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Dispositivo` (
  `Id` INT NOT NULL,
  `Nome` VARCHAR(255) NOT NULL,
`VersioneApp` VARCHAR(45) NOT NULL,
    `SistemaOperativo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella Erogazione
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Erogazione` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Inizio` DATETIME NOT NULL,
  `Fine` DATETIME,
  `Contenuto` INT NOT NULL,
  `Server` INT NOT NULL,
  `InizioConnessione` DATETIME NOT NULL,
`Dispositivo` INT NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella Fattura
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Fattura` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Saldo` DATE,
  `Emissione` DATE NOT NULL,
  `Utente` INT NOT NULL,
  `CartaDiCredito` BIGINT NOT NULL,
  `Abbonamento` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Film
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Film` (
  `Id` INT NOT NULL,
  `Titolo` VARCHAR(255) NOT NULL,
`Descrizione` VARCHAR(3000) NOT NULL,
  `Anno` INT NOT NULL,
  `Durata` INT NOT NULL,
  `Paese` VARCHAR(45) NOT NULL,
`SommaCritica` BIGINT NOT NULL DEFAULT 0,
    `TotaleCritica` INT NOT NULL DEFAULT 0,
    `SommaUtenti` BIGINT NOT NULL DEFAULT 0,
    `TotaleUtenti` BIGINT NOT NULL DEFAULT 0,
    `RatingAssoluto` DOUBLE DEFAULT NULL,
`Visualizzazioni` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella FormatoAudio
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`FormatoAudio` (
  `Codice` INT NOT NULL,
  `Famiglia` VARCHAR(45) NOT NULL,
`DataRilascio` DATE NOT NULL,
  `Qualita` VARCHAR(45) NOT NULL,
`Bitrate` INT NOT NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella FormatoVideo
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`FormatoVideo` (
  `Codice` INT NOT NULL,
  `Famiglia` VARCHAR(45) NOT NULL,
`DataRilascio` DATE NOT NULL,
  `Qualita` VARCHAR(45) NOT NULL,
`Bitrate` INT NOT NULL,
    `Risoluzione` INT NOT NULL,
    `RapportoAspetto` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella Importanza
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Importanza` (

  `Fattore` VARCHAR(255) NOT NULL,
`Utente` INT NOT NULL,
    `Valore` INT NOT NULL,
  PRIMARY KEY (`Fattore`, `Utente`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Interpretazione
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Interpretazione` (


`Artista` INT NOT NULL,
    `Film` INT NOT NULL,
  PRIMARY KEY (`Artista`, `Film`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella OffertaContenuto
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`OffertaContenuto` (


`Abbonamento` VARCHAR(45) NOT NULL,
  `Contenuto` INT NOT NULL,
  PRIMARY KEY (`Abbonamento`, `Contenuto`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella OffertaFunzionalita
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`OffertaFunzionalita` (


`Abbonamento` VARCHAR(45) NOT NULL,
  `Funzionalita` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Abbonamento`, `Funzionalita`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella Paese
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Paese` (
  `Nome` VARCHAR(45) NOT NULL,
  `InizioIP` INT NOT NULL,
  `FineIP` INT NOT NULL,
  `Latitudine` DOUBLE NOT NULL,
    `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella PossessoServer
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`PossessoServer` (

  `Contenuto` INT NOT NULL,
  `Server` INT NOT NULL,

  PRIMARY KEY (`Contenuto`, `Server`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella PremiazioneAttore
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`PremiazioneAttore` (

  `Attore` INT NOT NULL,
  `Premio` INT NOT NULL,

  PRIMARY KEY (`Attore`, `Premio`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella PremiazioneFilm
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`PremiazioneFilm` (

  `Film` INT NOT NULL,
  `Premio` INT NOT NULL,

  PRIMARY KEY (`Film`, `Premio`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella PremiazioneRegista
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`PremiazioneRegista` (

  `Regista` INT NOT NULL,
  `Premio` INT NOT NULL,

  PRIMARY KEY (`Regista`, `Premio`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Premio
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Premio` (

  `Id` INT NOT NULL,
  `Nome` VARCHAR(255) NOT NULL,
  `Anno` INT NOT NULL,
 `Istituzione` VARCHAR(255) NOT NULL,
    `Descrizione` VARCHAR(3000) NOT NULL,
    `Peso` INT NOT NULL,
    `Attore` TINYINT(1) NOT NULL,
    `Film` TINYINT(1) NOT NULL,
    `Regista` TINYINT(1) NOT NULL,


  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella RecensioneCritico
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`RecensioneCritico` (

  `Critico` INT NOT NULL,
  `Film` INT NOT NULL,
    `Data` DATE NOT NULL,
  `Testo` VARCHAR(3000) NOT NULL,
  `Voto` INT NOT NULL,
  PRIMARY KEY (`Critico`, `Film`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella RecensioneUtente
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`RecensioneUtente` (

  `Utente` INT NOT NULL,
  `Film` INT NOT NULL,
    `Data` DATE NOT NULL,
  `Testo` VARCHAR(3000) NOT NULL,
  `Voto` INT NOT NULL,
  PRIMARY KEY (`Utente`, `Film`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella RestrizioneAbbonamento
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`RestrizioneAbbonamento` (

  `Abbonamento` VARCHAR(45) NOT NULL,
    `Paese` VARCHAR(45) NOT NULL,

  PRIMARY KEY (`Abbonamento`, `Paese`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------------------------------
-- Tabella RestrizioneContenuto
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`RestrizioneContenuto` (

  `Contenuto` INT NOT NULL,
    `Paese` VARCHAR(45) NOT NULL,

  PRIMARY KEY (`Contenuto`, `Paese`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Server
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Server` (
  `Id` INT NOT NULL,
  `LarghezzaBanda` BIGINT NOT NULL,
   `CapacitaMax` BIGINT NOT NULL,
  `Latitudine` DOUBLE NOT NULL,
    `Longitudine` DOUBLE NOT NULL,
    `Jitter` INT NOT NULL,
    `BandaDisponibile` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Sottotitoli
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Sottotitoli` (

  `Contenuto` INT NOT NULL,
    `Lingua` VARCHAR(45) NOT NULL,

  PRIMARY KEY (`Contenuto`, `Lingua`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Tabella Utente
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PLZ.`Utente` (

  `Codice` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(255) NOT NULL,
    `Cognome` VARCHAR(255) NOT NULL,
    `Email` VARCHAR(255) NOT NULL,
    `Password` VARCHAR(255) NOT NULL,
  `DataNascita` DATE NOT NULL,
    `Nazionalita` VARCHAR(45) NOT NULL,
    `CartaDiCredito` BIGINT,
    `Abbonamento` VARCHAR(45),
    `Inizio` DATE,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB DEFAULT CHARSET=latin1;
