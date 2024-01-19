DROP SCHEMA IF EXISTS `FilmSphere` ;
CREATE SCHEMA IF NOT EXISTS `FilmSphere` DEFAULT CHARACTER SET utf8 ;
USE `FilmSphere`;

-- -----------------------------------------------------
-- Tabella `PianoDiAbbonamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PianoDiAbbonamento` (
 `Nome` VARCHAR(100) NOT NULL,
 `MaxQualita` INT UNSIGNED,
 `MaxGiga` INT UNSIGNED ,
 `MaxOre` INT UNSIGNED ,
 `Costo` DOUBLE  NOT NULL,
 `FunzioneAggiuntiva` VARCHAR(100),
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB; 
-- -----------------------------------------------------
-- Tabella `Utente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Utente` (
  `Codice` INT UNSIGNED NOT NULL,
  `Nome` VARCHAR(50) NOT NULL,
  `Cognome` VARCHAR(50) NOT NULL,
  `Password` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Abbonamento` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Codice`),
  FOREIGN KEY (`Abbonamento`) REFERENCES `PianoDiAbbonamento` (`Nome`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Dispositivo` (
  `IDDispositivo` INT UNSIGNED NOT NULL,
  `Modello` VARCHAR(100) NOT NULL,
  `RisoluzioneSchermo` VARCHAR(100) NOT NULL,
  `Utente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`IDDispositivo`),
  FOREIGN KEY (`Utente`) REFERNCES `Utente`(`Codice`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Connessione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Connessione` (
  `OraInizio` DATETIME NOT NULL,
  `IP` BIGINT NOT NULL,
  `Dispositivo` INT UNSIGNED NOT NULL,
  `OraFine` DATETIME,
  PRIMARY KEY (`OraInizio`, `Dispositivo`),
  FOREIGN KEY (`Dispositivo`) REFERENCES `Dispositivo` (`IDDispositivo`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Server`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Server` (
  `IDServer` INT UNSIGNED NOT NULL,
  `MaxCapacita` INT UNSIGNED NOT NULL,
  `BandaDisponibile` INT UNSIGNED NOT NULL,
  `Banda` INT UNSIGNED NOT NULL,
  `Latitudine` DOUBLE NOT NULL,
  `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`IDServer`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Paese`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Paese` (
 `Nome` VARCHAR(100) NOT NULL,
 `IPMin`  BIGINT NOT NULL,
 `IPMax`  BIGINT NOT NULL,
 `Latitudine` DOUBLE NOT NULL,
 `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Film` (
 `ID` INT UNSIGNED NOT NULL,
 `AnnoP` INT UNSIGNED NOT NULL,
 `Descrizione` VARCHAR(200) NOT NULL,
 `Titolo` VARCHAR(50) NOT NULL,
 `StelleCritici` INT UNSIGNED ,
 `StelleUtenti` INT UNSIGNED ,
 `Durata` INT UNSIGNED NOT NULL,
 `Genere` VARCHAR(100) NOT NULL,
 `VotoTotale` DOUBLE UNSIGNED,
 `Paese` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ID`),
 FOREIGN KEY (`Paese`) REFERENCES `Paese` (`Nome`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `File`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `File` (
  `IDFile` INT UNSIGNED NOT NULL,
  `Dimensione` INT UNSIGNED NOT NULL,
  `BitrateTotale` INT UNSIGNED,
  `Film` INT UNSIGNED NOT NULL,
  `FormatoAudio` INT UNSIGNED NOT NULL,
  `FormatoVideo` INT UNSIGNED NOT NULL,
  `DataRilascioA` DATETIME NOT NULL,
  `DataRilascioV` DATETIME NOT NULL,
  PRIMARY KEY (`IDFile`),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`)
   )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Erogazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Erogazione` (
  `IDErogazione` INT UNSIGNED NOT NULL,
  `OraInizio` DATETIME NOT NULL,
  `OraFine` DATETIME,
  `Server` INT UNSIGNED NOT NULL,
  `File` INT UNSIGNED NOT NULL,
  `Dispositivo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`IDErogazione`),
  FOREIGN KEY (`Server`) REFERENCES `Server` (`IDServer`),
  FOREIGN KEY (`File`) REFERENCES `File` (`IDFile`),
  FOREIGN KEY (`Dispositivo`) REFERENCES `Connessione` (`Dispositivo`)
  )
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Presenza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Presenza` (
  `Server` INT UNSIGNED NOT NULL,
  `File` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Server`,`File`), 
  FOREIGN KEY (`Server`) REFERENCES `Server` (`IDServer`),
  FOREIGN KEY (`File`) REFERENCES `File` (`IDFile`)
  )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `RestrizioneGeografica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RestrizioneGeografica` (
 `File` INT UNSIGNED NOT NULL,
 `Paese` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`File`,`Paese`),
  FOREIGN KEY (`File`) REFERENCES `File` (`IDFile`),
  FOREIGN KEY (`Paese`) REFERENCES `Paese` (`Nome`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `FormatoVideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FormatoVideo` (
 `Codice` INT UNSIGNED NOT NULL,
 `Risoluzione` INT UNSIGNED NOT NULL,
 `Bitrate` INT UNSIGNED NOT NULL,
 `Rapporto` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `FormatoAudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `FormatoAudio` (
 `Codice` INT UNSIGNED NOT NULL,
 `Frequenza` INT UNSIGNED NOT NULL,
 `Bitrate` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `RestrizioneVideo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RestrizioneVideo` (
 `Paese` VARCHAR(100) NOT NULL,
 `FormatoVideo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Paese`,`FormatoVideo`),
  FOREIGN KEY (`Paese`) REFERENCES `Paese` (`Nome`),
  FOREIGN KEY (`FormatoVideo`) REFERENCES `FormatoVideo` (`Codice`)
  )
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `RestrizioneAudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RestrizioneAudio` (
 `Paese` VARCHAR(100) NOT NULL,
 `FormatoAudio` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Paese`,`FormatoAudio`),
  FOREIGN KEY (`Paese`) REFERENCES `Paese` (`Nome`),
  FOREIGN KEY (`FormatoAudio`) REFERENCES `FormatoAudio` (`Codice`)
  )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Lingua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Lingua` (
 `NomeLingua` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`NomeLingua`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Sottotitolaggio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Sottotitolaggio` (
 `Film` INT UNSIGNED NOT NULL,
 `Lingua` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`FIlm`,`Lingua`),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`),
  FOREIGN KEY (`Lingua`) REFERENCES `Lingua` (`NomeLingua`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Doppiaggio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Doppiaggio` (
 `Film` INT UNSIGNED NOT NULL,
 `Lingua` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`FIlm`,`Lingua`),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`),
  FOREIGN KEY (`Lingua`) REFERENCES `Lingua` (`NomeLingua`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabella `Attore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Attore` (
 `IDAttore` INT UNSIGNED NOT NULL,
 `Nome` VARCHAR(100) NOT NULL,
 `Cognome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IDAttore`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Regista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Regista` (
 `IDRegista` INT UNSIGNED NOT NULL,
 `Nome` VARCHAR(100) NOT NULL,
 `Cognome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IDRegista`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Regia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Regia` (
 `Film` INT UNSIGNED NOT NULL,
 `Regista` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Film`,`Regista` ),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`),
  FOREIGN KEY (`Regista`) REFERENCES `Regista` (`IDRegista`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Recitazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Recitazione` (
 `Attore`INT UNSIGNED NOT NULL,
 `Film` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Film`,`Attore`),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`),
  FOREIGN KEY (`Attore`) REFERENCES `Attore` (`IDAttore`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Premio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Premio` (
 `IDPremio` INT UNSIGNED NOT NULL,
 `Nome`  VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IDPremio` ))
  ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `PremiazioneRegista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PremiazioneRegista` (
 `Regista` INT UNSIGNED NOT NULL,
 `Premio` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Premio`,`Regista` ),
  FOREIGN KEY (`Regista`) REFERENCES `Regista` (`IDRegista`),
  FOREIGN KEY (`Premio`) REFERENCES `Premio` (`IDPremio`)
  )
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `PremiazioneFilm`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PremiazioneFilm` (
 `Film` INT UNSIGNED NOT NULL,
 `Premio` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Premio`,`Film` ),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`),
  FOREIGN KEY (`Premio`) REFERENCES `Premio` (`IDPremio`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `PremiazioneAttore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PremiazioneAttore` (
  `Attore` INT UNSIGNED NOT NULL,
  `Premio` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Premio`,`Attore` ),
  FOREIGN KEY (`Attore`) REFERENCES `Attore` (`IDAttore`),
  FOREIGN KEY (`Premio`) REFERENCES `Premio` (`IDPremio`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Critico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Critico` (
 `IDCritico` INT UNSIGNED NOT NULL,
 `Nome` VARCHAR(100) NOT NULL,
 `Cognome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IDCritico` ))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Critica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Critica` (
 `Critico` INT UNSIGNED NOT NULL,
 `Film` INT UNSIGNED NOT NULL,
 `ValutazioneC` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Critico`,`Film`),
  FOREIGN KEY (`Critico`) REFERENCES `Critico` (`IDCritico`),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `RecensioneUtente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RecensioneUtente` (
 `Utente` INT UNSIGNED NOT NULL,
 `Film` INT UNSIGNED NOT NULL,
 `ValutazioneU` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Utente`,`Film`),
  FOREIGN KEY (`Utente`) REFERENCES `Utente` (`Codice`),
  FOREIGN KEY (`Film`) REFERENCES `Film` (`ID`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabella `Disponibilita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Disponibilita` (
 `File` INT UNSIGNED NOT NULL,
 `PianoDiAbbonamento` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`File`,`PianoDiAbbonamento`),
  FOREIGN KEY (`File`) REFERENCES `File` (`IDFile`),
  FOREIGN KEY (`PianoDiAbbonamento`) REFERENCES `PianoDiAbbonamento` (`Nome`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `CartadiCredito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CartadiCredito` (
 `NumeroCarta` BIGINT  NOT NULL,
 `CVV` INT UNSIGNED NOT NULL,
 `DataScadenza` DATE NOT NULL,
  PRIMARY KEY (`NumeroCarta`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Proprieta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proprieta` (
 `Utente` INT UNSIGNED NOT NULL,
 `CartadiCredito` BIGINT  NOT NULL,
  PRIMARY KEY (`Utente`,`CartadiCredito`),
  FOREIGN KEY (`Utente`) REFERENCES `Utente` (`Codice`),
  FOREIGN KEY (`CartadiCredito`) REFERENCES `CartadiCredito` (`NumeroCarta`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabella `Fattura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fattura` (
 `IDFattura` INT UNSIGNED NOT NULL,
 `DataEmissione` DATE NOT NULL,
 `Scadenza` DATE NOT NULL,
 `Intestatario` INT UNSIGNED NOT NULL,
 `Importo` DOUBLE  NOT NULL,
 `CartaPagamento`  BIGINT ,
  PRIMARY KEY (`IDFattura`),
  FOREIGN KEY (`Intestatario`) REFERENCES `Utente` (`Codice`),
  FOREIGN KEY (`CartaPagamento`) REFERENCES `CartaDiCredito` (`NumeroCarta`)
  )
ENGINE = InnoDB;