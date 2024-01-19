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

DROP TRIGGER IF EXISTS Controllo_password;
DELIMITER $$
	CREATE TRIGGER Controllo_password
    BEFORE INSERT ON Utente 
	FOR EACH ROW
	BEGIN
    IF CHAR_LENGTH(NEW.Password) < 6 OR CHAR_LENGTH(NEW.Password) > 20 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La lunghezza della password deve essere compresa tra 8 e 20 caratteri';
		END IF;
	END $$
DELIMITER ;

DROP TRIGGER IF EXISTS Connessionedispositivi;
DELIMITER $$
	CREATE TRIGGER Connessionedispositivi
	BEFORE INSERT ON Connessione
	FOR EACH ROW
	BEGIN
    DECLARE q int;
	SELECT COUNT(*) into q
    FROM Connessione c INNER JOIN Dispositivo d ON c.Dispositivo= d.IDDispositivo
	WHERE d.Utente = (SELECT Utente 
					  FROM Dispositivo s
                      WHERE s.IDDispositivo = NEW.Dispositivo ) AND c.OraFine IS NULL;
	IF q >=2 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il numero dei dispositivi connessi deve essere minore di 2';
	END IF;
	END $$;
DELIMITER ;



DROP TRIGGER IF EXISTS Controllo_carta;
DELIMITER $$
	CREATE TRIGGER Controllo_carta
    BEFORE INSERT ON CartadiCredito
	FOR EACH ROW
	BEGIN
    IF CHAR_LENGTH(cast(NEW.NumeroCarta as char)) != 16 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La lunghezza del numero della carta deve essere di 16 cifre';
		END IF;
	END $$
DELIMITER ;

DROP TRIGGER IF EXISTS Stelle_Critici;
	DELIMITER $$
	CREATE TRIGGER Stelle_Critici 
	AFTER insert on Critica 
	FOR EACH ROW 
  	BEGIN 
		DECLARE c1 int;
        DECLARE c2 int;
        SELECT COUNT(*) INTO c1
        FROM RecensioneUtente 
        WHERE Film = NEW.Film;
        SELECT COUNT(*) INTO c2
        FROM Critica 
        WHERE Film = NEW.Film;
		UPDATE Film f
		SET f.StelleCritici = f.StelleCritici+ NEW.ValutazioneC
        WHERE f.ID = NEW.Film;
        UPDATE Film
        SET VotoTotale = ((3*(StelleCritici))+ (2*StelleUtenti)) / (5*(c1+c2)) 
        WHERE ID = NEW.Film;
        END $$
      DELIMITER ; 
        
DROP TRIGGER IF EXISTS Stelle_Utenti;
  DELIMITER $$
        
CREATE TRIGGER Stelle_Utenti 
        AFTER insert on RecensioneUtente 
        FOR EACH ROW 
        BEGIN 
        DECLARE c1 int;
        DECLARE c2 int;
        SELECT COUNT(*) INTO c1
        FROM RecensioneUtente 
        WHERE Film= NEW.Film;
        SELECT COUNT(*) INTO c2
        FROM Critica 
        WHERE Film= NEW.Film;
        UPDATE Film f
        SET f.StelleUtenti= f.StelleUtenti+ NEW.ValutazioneU
        WHERE f.ID = NEW.Film;
        UPDATE Film
        SET VotoTotale = ((3*StelleCritici)+ (2*(StelleUtenti))) / (5*(c1+c2)) 
        WHERE ID = NEW.Film;
        END $$
	DELIMITER ;
    
DROP TRIGGER IF EXISTS Bit_totale;
        DELIMITER $$
CREATE TRIGGER Bit_totale
        BEFORE insert on File 
        FOR EACH ROW 
        BEGIN 
        DECLARE audio int;
        DECLARE video int;
        DECLARE aux int;
        SELECT Bitrate into audio
        FROM FormatoAudio 
        WHERE Codice = NEW.FormatoAudio;
        SELECT Bitrate into video
        FROM FormatoVideo
        WHERE Codice = NEW.FormatoVideo;
        SET aux = audio+video;
        SET NEW.BitrateTotale = aux;
        END $$
	DELIMITER ;
    
    
DROP TRIGGER IF EXISTS Banda_Disponibile;
	DELIMITER $$
		CREATE TRIGGER Banda_Disponibile
        AFTER insert on Erogazione 
        FOR EACH ROW 
        BEGIN 
        DECLARE totbit int;
		SELECT BitrateTotale INTO totbit 
        FROM File f 
        WHERE f.IDFile = NEW.File;
        IF NEW.OraFine IS NULL THEN
        UPDATE Server s
        SET s.BandaDisponibile = s.BandaDisponibile - totbit
        WHERE s.IDServer = NEW.Server;
        END IF;
        END $$
	DELIMITER ;
    
-- -----------------------------------------------------
-- POPOLAMENTO TABELLE
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Popolamento `PianoDiAbbonamento`
-- -----------------------------------------------------
INSERT INTO PianoDiAbbonamento (Nome, MaxQualita, MaxGiga, MaxOre, Costo, FunzioneAggiuntiva)
VALUES
('Basic', 1080, 50, 30, 14.99, 'Nessuna funzione aggiuntiva'),
('Premium', 720, 30, 20, 19.99, 'Catalogo di film esclusivi'),
('Pro', 1080, 100, 40, 29.99, 'Streaming in 4K di film recenti'),
('Deluxe', 720, 50, 25, 35.99, 'Accesso illimitato a film in streaming'),
('Ultimate', 1080, 80, 35, 39.99, 'Accesso anticipato a nuovi film');
-- -----------------------------------------------------
-- Popolamento 'Utente'
-- -----------------------------------------------------
INSERT INTO Utente (Codice, Nome, Cognome, Password, Email, Abbonamento)
VALUES
(1, 'Mario', 'Rossi', 'passs123', 'mario.rossi@email.com', 'Basic'),
(2, 'Luigi', 'Verdi', 'green456', 'luigi.verdi@email.com', 'Pro'),
(3, 'Giovanna', 'Bianchi', 'abhc789', 'giovanna.bianchi@email.com', 'Deluxe'),
(4, 'Francesca', 'Rizzo', 'fran123', 'francesca.rizzo@email.com', 'Premium'),
(5, 'Paolo', 'Gialli', 'yellow789', 'paolo.gialli@email.com', 'Ultimate'),
(6, 'Anna', 'Marroni', 'anna456', 'anna.marroni@email.com', 'Basic'),
(7, 'Roberto', 'Blu', 'roby789', 'roberto.blu@email.com', 'Pro'),
(8, 'Sara', 'Verde', 'sara456', 'sara.verde@email.com', 'Deluxe'),
(9, 'Alessio', 'Arancio', 'ale789', 'alessio.arancio@email.com', 'Premium'),
(10, 'Chiara', 'Rosa', 'chiara456', 'chiara.rosa@email.com', 'Ultimate'),
(11, 'Marco', 'Viola', 'marco123', 'marco.viola@email.com', 'Basic'),
(12, 'Elisa', 'Celeste', 'elisa789', 'elisa.celeste@email.com', 'Pro'),
(13, 'Gianluca', 'Azzurro', 'gian123', 'gianluca.azzurro@email.com', 'Deluxe'),
(14, 'Valentina', 'Lilla', 'val456', 'valentina.lilla@email.com', 'Premium'),
(15, 'Davide', 'Magenta', 'davide789', 'davide.magenta@email.com', 'Ultimate'),
(16, 'Elena', 'Ciano', 'elena456', 'elena.ciano@email.com', 'Basic'),
(17, 'Federico', 'Indaco', 'fede123', 'federico.indaco@email.com', 'Pro'),
(18, 'Alessandra', 'Turchese', 'ale789', 'alessandra.turchese@email.com', 'Deluxe'),
(19, 'Nicola', 'Oro', 'nicola456', 'nicola.oro@email.com', 'Premium'),
(20, 'Laura', 'Argento', 'laura789', 'laura.argento@email.com', 'Ultimate');


-- -----------------------------------------------------
-- Popolamento 'Dispositivo'
-- -----------------------------------------------------
INSERT INTO Dispositivo (IDDispositivo, Modello, RisoluzioneSchermo, Utente)
VALUES
(1, 'Smartphone X1', '1080x1920', 1),
(2, 'Tablet A2', '1200x1920', 2),
(3, 'Laptop B3', '1366x768', 3),
(4, 'Smartphone Y5', '1440x2560', 4),
(5, 'Tablet D6', '800x1280', 5),
(6, 'Laptop E7', '1920x1080', 6),
(7, 'Smartphone Z9', '720x1280', 7),
(8, 'Tablet G10', '1600x2560', 8),
(9, 'Laptop H11', '1280x720', 9),
(10, 'Smartphone W13', '1080x2340', 10),
(11, 'Tablet J14', '1024x1600', 11),
(12, 'Laptop K15', '2560x1440', 12),
(13, 'Smartphone M17', '1440x2960', 13),
(14, 'Tablet N18', '1200x1920', 14),
(15, 'Laptop O19', '1366x768', 15),
(16, 'Smartphone X21', '1080x1920', 16),
(17, 'Tablet A22', '1200x1920', 17),
(18, 'Laptop B23', '1366x768', 18),
(19, 'Smartphone Y24', '1440x2560', 19),
(20, 'Tablet D25', '800x1280', 20),
(21, 'Tablet Q27', '1600x2560', 1),
(22, 'Laptop R28', '1280x720', 2),
(23, 'Smartphone S29', '1080x2340', 3),
(24, 'Tablet T30', '1024x1600', 4),
(25, 'Laptop U31', '2560x1440', 5),
(26, 'Smartphone V32', '1440x2960', 6),
(27, 'Tablet W33', '1200x1920', 7),
(28, 'Laptop X34', '1366x768', 8),
(29, 'Smartphone Y35', '1080x1920', 9),
(30, 'Tablet Z36', '1200x1920', 10);

-- -----------------------------------------------------
-- Popolamento 'Connessione'
-- -----------------------------------------------------
INSERT INTO Connessione (OraInizio, Dispositivo, IP, OraFine)
VALUES
('2024-11-01 08:00:00', 1, 3232235778, '2023-11-01 10:30:00'),
('2023-11-03 10:15:00', 5, 3232240782, '2023-11-03 11:00:00'),
('2023-11-05 12:15:00', 10, 3232236787, '2023-11-05 13:00:00'),
('2023-11-07 14:30:00', 15, 3232235792, '2023-11-07 15:30:00'),
('2024-11-09 17:30:00', 21, 3232235797, '2023-11-12 10:01:00'),
('2023-11-11 08:45:00', 25, 3232260802, '2023-11-11 10:00:00'),
('2023-11-13 11:30:00', 30, 3232235807, '2023-11-13 13:00:00'),
('2023-11-15 14:45:00', 3, 3232239780, '2023-11-15 16:15:00'),
('2023-11-17 09:15:00', 8, 3232235785, '2023-11-17 10:45:00'),
('2023-11-19 11:30:00', 13, 3232235790, '2023-11-19 13:00:00'),
('2023-11-21 14:15:00', 18, 3232235795, '2023-11-21 15:30:00'),
('2023-11-23 16:45:00', 23, 3232237800, '2023-11-23 18:00:00'),
('2023-11-25 08:30:00', 28, 3232244805, '2023-11-25 09:45:00'),
('2023-11-27 10:00:00', 2, 3232267779, '2023-11-27 11:30:00'),
('2023-11-29 12:45:00', 7, 3232269784, '2023-11-29 14:00:00'),
('2023-11-02 15:15:00', 12, 3232270789, '2023-11-02 16:45:00'),
('2023-11-04 08:30:00', 17, 3232273794, '2023-11-04 09:45:00'),
('2023-11-06 10:00:00', 22, 3232235799, '2023-11-06 11:30:00'),
('2023-11-08 12:45:00', 27, 3232235804, '2023-11-08 14:00:00'),
('2023-12-01 08:00:00', 1, 3232271778, '2023-12-01 09:30:00'),
('2023-12-03 10:15:00', 5, 3232235782, '2023-12-03 11:00:00'),
('2023-12-05 12:15:00', 10, 3232255787, '2023-12-05 13:00:00'),
('2023-12-07 14:30:00', 15, 3232256792, '2023-12-07 15:30:00'),
('2023-12-09 17:30:00', 20, 3232266797, '2023-12-09 18:45:00'),
('2023-12-11 08:45:00', 25, 3232261802, '2023-12-11 10:00:00'),
('2023-12-13 11:30:00', 30, 3232235807, '2023-12-13 13:00:00'),
('2023-12-15 14:45:00', 3, 3232235780, '2023-12-15 16:15:00'),
('2023-12-17 09:15:00', 8, 3232235785, '2023-12-17 10:45:00'),
('2023-12-19 11:30:00', 13, 3232235790, '2023-12-19 13:00:00'),
('2023-12-21 14:15:00', 18, 3232235795, '2023-12-21 15:30:00'),
('2023-12-23 16:45:00', 23, 3232235800, '2023-12-23 18:00:00'),
('2023-12-25 08:30:00', 28, 3232262805, '2023-12-25 09:45:00'),
('2023-12-27 10:00:00', 2, 3232265779, '2023-12-27 11:30:00'),
('2023-12-29 12:45:00', 7, 3232268784, '2023-12-29 14:00:00'),
('2023-12-01 15:15:00', 12, 3232235789, '2023-12-01 16:45:00'),
('2023-12-03 08:30:00', 17, 3232235794, '2023-12-03 09:45:00'),
('2023-12-05 10:00:00', 22, 3232235799, '2023-12-05 11:30:00'),
('2023-12-07 12:45:00', 27, 3232244804, '2023-12-07 14:00:00'),
('2024-01-01 08:00:00', 1, 3232269778, '2024-01-01 09:30:00'),
('2024-01-03 10:15:00', 5, 3232235782, '2024-01-03 11:00:00'),
('2024-01-05 12:15:00', 10, 3232235787, '2024-01-05 13:00:00'),
('2024-01-07 14:30:00', 15, 3232235792, '2024-01-07 15:30:00'),
('2024-01-09 17:30:00', 20, 3232236797, '2024-01-09 18:45:00'),
('2024-01-11 08:45:00', 25, 3232235802, '2024-01-11 10:00:00'),
('2024-01-13 11:30:00', 30, 3232238807, '2024-01-13 13:00:00'),
('2024-01-15 14:45:00', 3, 3232235780, '2024-01-15 16:15:00'),
('2024-01-17 09:15:00', 8, 3232235785, '2024-01-17 10:45:00'),
('2024-01-19 11:30:00', 13, 3232235790, '2024-01-19 13:00:00'),
('2024-01-21 14:15:00', 18, 3232235795, '2024-01-21 15:30:00'),
('2024-01-23 16:45:00', 23, 3232238800, '2024-01-23 18:00:00'),
('2024-01-25 08:30:00', 28, 3232235805, '2024-01-25 09:45:00'),
('2024-01-27 10:00:00', 2, 3232240779, '2024-01-27 11:30:00'),
('2024-01-29 12:45:00', 7, 3232236784, '2024-01-29 14:00:00'),
('2024-01-02 15:15:00', 12, 3232241789, '2024-01-02 16:45:00'),
('2024-01-04 08:30:00', 17, 3232241794, '2024-01-04 09:45:00'),
('2024-01-06 10:00:00', 22, 3232242799, '2024-01-06 11:30:00'),
('2024-01-08 12:45:00', 27, 3232235804, '2024-01-08 14:00:00'),
('2024-02-01 08:00:00', 1, 3232237778, '2024-02-01 09:30:00'),
('2024-02-03 10:15:00', 5, 3232236782, '2024-02-03 11:00:00'),
('2024-02-05 12:15:00', 10, 3232235787, '2024-02-05 13:00:00'),
('2024-02-07 14:30:00', 15, 3232240792, '2024-02-07 15:30:00'),
('2024-02-09 17:30:00', 20, 3232242797, '2024-02-09 18:45:00'),
('2024-02-11 08:45:00', 25, 3232235802, '2024-02-11 10:00:00'),
('2024-02-13 11:30:00', 30, 3232239807, '2024-02-13 13:00:00'),
('2024-02-15 14:45:00', 3, 3232239780, '2024-02-15 16:15:00'),
('2024-02-17 09:15:00', 8, 3232241785, '2024-02-17 10:45:00'),
('2024-02-19 11:30:00', 13, 3232235790, '2024-02-19 13:00:00'),
('2024-02-21 14:15:00', 18, 3232240795, '2024-02-21 15:30:00'),
('2024-02-23 16:45:00', 23, 3232235800, '2024-02-23 18:00:00'),
('2024-02-25 08:30:00', 28, 3232237805, '2024-02-25 09:45:00'),
('2024-02-27 10:00:00', 2, 3232238779, '2024-02-27 11:30:00'),
('2024-02-29 12:45:00', 7, 3232242784, '2024-02-29 14:00:00'),
('2024-02-02 15:15:00', 12, 3232235789, '2024-02-02 16:45:00'),
('2024-02-04 08:30:00', 17, 3232237794, '2024-02-04 09:45:00'),
('2024-02-06 10:00:00', 22, 3232235799, '2024-02-06 11:30:00'),
('2024-02-08 12:45:00', 27, 3232239804, '2024-02-08 14:00:00');

-- -----------------------------------------------------
-- Popolamento 'Server'
-- -----------------------------------------------------
INSERT INTO Server (IDServer, MaxCapacita, BandaDisponibile, Banda, Latitudine, Longitudine) 
VALUES
(1, 135000, 0, 600000000, 41.9028, 12.4964), -- Roma, Italia
(2, 122000, 0, 700000000, 40.7128, -74.0060), -- New York City, Stati Uniti
(3, 160000, 0, 800000000, 59.3293, 18.0686),  -- Stoccolma, Svezia
(4, 170000, 0, 750000000, 55.7558, 37.6176),  -- Mosca, Russia
(5, 200000, 0, 650000000, 31.2304, 121.4737), -- Shanghai, Cina
(6, 190000, 0, 800000000, -26.2041, 28.0473), -- Johannesburg, Sudafrica
(7, 140000, 0, 900000000, -34.6118, -58.4173), -- Buenos Aires, Argentina
(8, 150000, 0, 750023000, -34.9285, 138.6007); -- Adelaide, Australia

-- -----------------------------------------------------
-- Popolamento `Paese`
-- -----------------------------------------------------
INSERT INTO Paese (Nome, IPMin, IPMax, Latitudine, Longitudine)
VALUES
('Italia', 3232235778, 3232236035, 41.9028, 12.4964),
('Francia', 3232236036, 3232236293, 48.8566, 2.3522),
('Germania', 3232236294, 3232236551, 51.1657, 10.4515),
('Spagna', 3232236552, 3232236809, 40.4168, -3.7038),
('Regno Unito', 3232236810, 3232237067, 51.5099, -0.1180),
('Stati Uniti', 3232237068, 3232237325, 38.8951, -77.0364),
('Canada', 3232237326, 3232237583, 45.4215, -75.6994),
('Australia', 3232237584, 3232237841, -35.3081, 149.1240),
('Giappone', 3232237842, 3232238099, 35.6895, 139.6917),
('Brasile', 3232238100, 3232238357, -15.7801, -47.9292),
('Cina', 3232238358, 3232238615, 39.9042, 116.4074),
('India', 3232238616, 3232238873, 28.6139, 77.2090),
('Russia', 3232238874, 3232239131, 55.7558, 37.6176),
('Sudafrica', 3232239132, 3232239389, -25.7461, 28.1881),
('Messico', 3232239390, 3232239647, 19.4326, -99.1332),
('Argentina', 3232239648, 3232239905, -34.6118, -58.4173),
('Corea del Sud', 3232239906, 3232240163, 37.5665, 126.9780),
('Svezia', 3232240164, 3232240421, 59.3293, 18.0686),
('Norvegia', 3232240422, 3232240679, 60.4720, 8.4689),
('Olanda', 3232240680, 3232240937, 52.3676, 4.9041),
('Portogallo', 3232240938, 3232241195, 38.7223, -9.1393),
('Nuova Zelanda', 3232241196, 3232241453, -41.2866, 174.7762),
('Grecia', 3232241454, 3232241711, 37.9838, 23.7275),
('Egitto', 3232241712, 3232241969, 30.0444, 31.2357),
('Thailandia', 3232241970, 3232242227, 13.7563, 100.5018),
('Israele', 3232242228, 3232242485, 31.7683, 35.2137),
('Arabia Saudita', 3232242486, 3232242743, 24.7136, 46.6753),
('Marocco', 3232242744, 3232243001, 31.7917, -7.0926),
('Congo', 3232243002, 3232243259, -4.3217, 15.3121),
('Perù', 3232243260, 3232243517, -12.0464, -77.0428);

-- -----------------------------------------------------
-- Popolamento `Film`
-- -----------------------------------------------------
INSERT INTO Film (ID, AnnoP, Descrizione, Titolo, StelleCritici, StelleUtenti, Durata, Genere, VotoTotale, Paese)
VALUES
(1, 2020, 'Un eccitante film d azione', 'Mission Impossible', 0, 0, 120, 'Azione', 0, 'Stati Uniti'),
(2, 2019, 'Una commedia divertente', 'La La Land-DC', 0, 0, 128, 'Commedia', 0, 'Stati Uniti'),
(3, 2021, 'Un dramma emozionante', 'The Shawshank Redemption', 0, 0, 142, 'Drammatico', 0, 'Stati Uniti'),
(4, 2018, 'Un avvincente thriller psicologico', 'Gone Girl', 0, 0, 145, 'Thriller', 0, 'Stati Uniti'),
(5, 2017, 'Un epico film fantasy', 'The Lord of the Rings', 0, 0, 180, 'Fantasy', 0, 'Nuova Zelanda'),
(6, 2016, 'Una storia romantica indimenticabile', 'La La Land', 0, 0, 126, 'Romantico', 0, 'Stati Uniti'),
(7, 2022, 'Un appassionante film di fantascienza', 'Dune', 0, 0, 155, 'Fantascienza', 0, 'Stati Uniti'),
(8, 2015, 'Un intenso film di guerra', 'Hacksaw Ridge', 0, 0, 139, 'Guerra', 0, 'Australia'),
(9, 1977, 'Un appassionante film di fantascienza', 'Guerre Stellari', 0,0, 121,'Fantascienza', 0, 'Stati Uniti'),
(10, 2013, 'Una storia commovente', 'The Fault in Our Stars', 0, 0, 125, 'Drammatico', 0, 'Stati Uniti'),
(11, 2012, 'Un divertente film d animazione', 'Wreck-It Ralph', 0, 0, 101, 'Animazione', 0, 'Stati Uniti'),
(12, 2011, 'Un film di fantascienza avvincente', 'Inception', 0, 0, 148, 'Fantascienza', 0, 'Stati Uniti'),
(13, 2010, 'Un thriller psicologico avvincente', 'Black Swan', 0, 0, 108, 'Thriller', 0, 'Stati Uniti'),
(14, 2009, 'Un emozionante film biografico', 'The Social Network', 0, 0, 120, 'Biografico', 0, 'Stati Uniti'),
(15, 2008, 'Una commedia brillante', 'The Dark Knight', 0, 0, 152, 'Commedia', 0, 'Stati Uniti'),
(16, 2007, 'Un avvincente film d azione', 'No Country for Old Men', 0, 0, 122, 'Azione', 0, 'Stati Uniti'),
(17, 2006, 'Un dramma coinvolgente', 'The Departed', 0, 0, 151, 'Drammatico', 0, 'Stati Uniti'),
(18, 2005, 'Un thriller mozzafiato', 'Batman Begins', 0, 0, 140, 'Thriller', 0, 'Stati Uniti'),
(19, 2004, 'Un film epico di fantascienza', 'Eternal Sunshine of the Spotless Mind', 0, 0, 108, 'Fantascienza', 0, 'Stati Uniti'),
(20, 2003, 'Una commedia romantica', 'Lost in Translation', 0, 0, 102, 'Romantico', 0, 'Stati Uniti');

-- -----------------------------------------------------
-- Popolamento `File`
-- -----------------------------------------------------
INSERT INTO File (IDFile, Dimensione, BitrateTotale, Film, FormatoAudio, FormatoVideo, DataRilascioA, DataRilascioV)
VALUES
(1, 1024, 128, 1, 1, 1, '2000-01-01', '2000-01-01'),
(2, 2048, 192, 2, 2, 2, '2001-02-03', '2001-02-03'),
(3, 3072, 256, 3, 3, 3, '2002-04-05', '2002-04-05'),
(4, 4096, 320, 4, 4, 4, '2003-06-07', '2003-06-07'),
(5, 5120, 384, 5, 5, 5, '2004-08-09', '2004-08-09'),
(6, 6144, 448, 6, 6, 6, '2005-10-11', '2005-10-11'),
(7, 7168, 512, 7, 7, 7, '2002-12-13', '2002-12-13'),
(8, 8192, 576, 8, 8, 8, '2002-12-13', '2002-12-13'),
(9, 9216, 640, 19, 9, 9, '2006-12-13', '2006-12-13'),
(10, 1040, 704, 10, 10, 10, '2007-02-15', '2007-02-15'),
(11, 1264, 768, 11, 11, 11, '2008-04-17', '2008-04-17'),
(12, 1288, 832, 12, 12, 12, '2009-06-19', '2009-06-19'),
(13, 1312, 896, 13, 13, 13, '2010-08-21', '2010-08-21'),
(14, 1336, 960, 14, 14, 14, '2011-10-23', '2011-10-23'),
(15, 1360, 1024, 15, 15, 15, '2012-12-25', '2012-12-25'),
(16, 6384, 1088, 16, 16, 16, '2013-02-27', '2013-02-27'),
(17, 7408, 1152, 17, 17, 17, '2014-04-29', '2014-04-29'),
(18, 1832, 1216, 18, 18, 18, '2015-06-01', '2015-06-01'),
(19, 1456, 1280, 19, 19, 19, '2014-08-03', '2014-08-03'),
(20, 2480, 1344, 20, 20, 20, '2016-08-03', '2016-08-03'),
(21, 1504, 1408, 1, 2, 3, '2000-03-12', '2000-03-12'),
(22, 2528, 1472, 2, 4, 6, '2001-05-14', '2001-05-14'),
(23, 3552, 1536, 3, 7, 17, '2016-08-03', '2016-08-03'),
(24, 4576, 1600, 4, 8, 12, '2002-07-16', '2002-07-16'),
(25, 5600, 1664, 5, 3, 9, '2003-09-18', '2003-09-18'),
(26, 6624, 1728, 6, 5, 11, '2004-11-20', '2004-11-20'),
(27, 7648, 1792, 7, 4, 13, '2020-08-03', '2020-08-03'),
(28, 8672, 1856, 8, 7, 15, '2006-01-22', '2006-01-22'),
(29, 5696, 1920, 17, 12, 16, '2007-03-24', '2007-03-24'),
(30, 2720, 1984, 10, 15, 18, '2008-05-26', '2008-05-26');
-- -----------------------------------------------------
-- Popolamento 'Erogazione'
-- -----------------------------------------------------
INSERT INTO `Erogazione` (`IDErogazione`, `OraInizio`, `OraFine`, `Server`, `File`, `Dispositivo`)
VALUES
  (1, '2023-11-01 08:00:00', '2023-11-01 9:30:00', 1, 15, 1 ),
  (2, '2023-11-02 14:30:00', '2023-11-02 16:45:00', 2, 25, 5),
  (3, '2023-11-03 09:15:00', '2023-11-03 10:30:00', 3, 5, 5),
  (4, '2023-11-04 18:45:00', '2023-11-04 20:30:00', 4, 10, 10),
  (5, '2023-11-05 12:00:00', '2023-11-05 14:15:00', 5, 20, 15 ),
  (6, '2023-11-06 16:30:00', '2023-11-06 18:00:00', 6, 1, 28),
  (7, '2023-11-07 11:45:00', '2023-11-07 13:30:00', 7, 30, 23),
  (8, '2023-11-08 17:00:00', '2023-11-08 19:15:00', 8, 8, 25),
  (9, '2023-11-09 14:00:00', '2023-11-09 16:30:00', 1, 18, 12),
  (10, '2023-11-10 20:45:00', '2023-11-10 22:00:00', 2, 3, 30),
  (11, '2023-11-11 09:30:00', '2023-11-11 11:15:00', 3, 12, 3),
  (12, '2023-11-12 18:00:00', '2023-11-12 20:30:00', 4, 22, 22),
  (13, '2023-11-13 12:15:00', '2023-11-13 14:00:00', 5, 7, 22),
  (14, '2023-11-14 16:30:00', '2023-11-14 18:45:00', 6, 29, 10),
  (15, '2023-11-15 11:00:00', '2023-11-15 13:30:00', 7, 14, 23),
  (16, '2023-11-16 17:45:00', '2023-11-16 19:00:00', 8, 9, 22),
  (17, '2023-11-17 08:30:00', '2023-11-17 10:15:00', 1, 24, 30),
  (18, '2023-11-18 14:45:00', '2023-11-18 16:00:00', 2, 13, 15),
  (19, '2023-11-19 10:30:00', '2023-11-19 12:15:00', 3, 27, 22),
  (20, '2023-11-20 15:00:00', '2023-11-20 17:30:00', 4, 4, 12),
  (21, '2023-11-21 20:15:00', '2023-11-21 22:00:00', 5, 19, 3),
  (22, '2023-11-22 09:45:00', '2023-11-22 11:30:00', 6, 2, 30),
  (23, '2023-11-23 16:30:00', '2023-11-23 18:15:00', 7, 28, 23),
  (24, '2023-11-24 12:00:00', '2023-11-24 14:30:00', 8, 6, 27),
  (25, '2023-11-25 17:45:00', '2023-11-25 19:30:00', 1, 23, 20),
  (26, '2023-11-26 13:30:00', '2023-11-26 15:45:00', 2, 11, 10),
  (27, '2023-11-27 10:15:00', '2023-11-27 12:30:00', 3, 26, 13),
  (28, '2023-11-28 18:30:00', '2023-11-28 20:00:00', 4, 16, 22),
  (29, '2023-11-29 11:45:00', '2023-11-29 13:30:00', 5, 21, 7 ),
  (30, '2023-11-30 15:00:00', '2023-11-30 17:15:00', 6, 17, 3),
  (31, '2023-12-01 09:30:00', '2023-12-01 11:45:00', 7, 10, 20),
  (32, '2023-12-02 14:15:00', '2023-12-02 16:30:00', 8, 30, 15),
  (33, '2023-12-03 19:45:00', '2023-12-03 21:30:00', 1, 8, 27),
  (34, '2023-12-04 08:00:00', '2023-12-04 10:15:00', 2, 22, 3),
  (35, '2023-12-05 15:30:00', '2023-12-05 17:00:00', 3, 12, 5),
  (36, '2023-12-06 12:45:00', '2023-12-06 14:30:00', 4, 7, 30),
  (37, '2023-12-07 17:00:00', '2023-12-07 19:15:00', 5, 18, 20),
  (38, '2023-12-08 11:15:00', '2023-12-08 13:30:00', 6, 2, 22),
  (39, '2023-12-09 16:45:00', '2023-12-09 18:00:00', 7, 26, 10),
  (40, '2023-12-10 09:30:00', '2023-12-10 11:45:00', 8, 14, 23),
  (41, '2023-12-11 14:00:00', '2023-12-11 16:30:00', 1, 29, 3),
  (42, '2023-12-12 20:45:00', '2023-12-12 22:00:00', 2, 4, 28),
  (43, '2023-12-13 09:30:00', '2023-12-13 11:15:00', 3, 16, 1),
  (44, '2023-12-14 18:45:00', '2023-12-14 20:30:00', 4, 21, 3),
  (45, '2023-12-15 12:00:00', '2023-12-15 14:15:00', 5, 13, 12),
  (46, '2023-12-16 16:30:00', '2023-12-16 18:00:00', 6, 8, 28),
  (47, '2023-12-17 11:45:00', '2023-12-17 13:30:00', 7, 24, 25),
  (48, '2023-12-18 17:00:00', '2023-12-18 19:15:00', 8, 1, 13),
  (49, '2023-12-19 14:00:00', '2023-12-19 16:30:00', 1, 19, 22),
  (50, '2023-12-20 20:45:00', '2023-12-20 22:00:00', 2, 6, 10),
  (51, '2023-12-21 09:00:00', '2023-12-21 11:15:00', 3, 10, 28),
  (52, '2023-12-22 14:30:00', '2023-12-22 16:45:00', 5, 15, 23),
  (53, '2023-12-23 10:15:00', '2023-12-23 12:30:00', 7, 20, 15),
  (54, '2023-12-24 18:45:00', '2023-12-24 20:30:00', 1, 25, 20),
  (55, '2023-12-25 12:00:00', '2023-12-25 14:15:00', 2, 30, 10),
  (56, '2023-12-26 16:30:00', '2023-12-26 18:00:00', 4, 5, 23),
  (57, '2023-12-27 11:45:00', '2023-12-27 13:30:00', 6, 10, 28),
  (58, '2023-12-28 17:00:00', '2023-12-28 19:15:00', 8, 15, 3),
  (59, '2023-12-29 14:00:00', '2023-12-29 16:30:00', 1, 20, 7),
  (60, '2023-12-30 20:45:00', '2023-12-30 22:00:00', 3, 25, 28),
  (61, '2023-12-31 09:30:00', '2023-12-31 11:45:00', 5, 30, 5),
  (62, '2024-01-01 14:00:00', '2024-01-01 16:30:00', 7, 5, 13),
  (63, '2024-01-02 20:45:00', '2024-01-02 22:00:00', 2, 10, 27),
  (64, '2024-01-03 09:30:00', '2024-01-03 11:45:00', 4, 15, 12),
  (65, '2024-01-04 14:15:00', '2024-01-04 16:30:00', 6, 20, 22),
  (66, '2024-01-05 19:45:00', '2024-01-05 21:30:00', 8, 25, 3),
  (67, '2024-01-06 08:00:00', '2024-01-06 10:15:00', 1, 30, 30),
  (68, '2024-01-07 15:30:00', '2024-01-07 17:00:00', 3, 5, 7),
  (69, '2024-01-08 12:45:00', '2024-01-08 14:30:00', 5, 10, 25),
  (70, '2024-01-09 17:00:00', '2024-01-09 19:15:00', 7, 15, 1),
  (71, '2024-01-10 11:15:00', '2024-01-10 13:30:00', 2, 20, 28),
  (72, '2024-01-11 16:45:00', '2024-01-11 18:00:00', 4, 25, 10),
  (73, '2024-01-12 09:30:00', '2024-01-12 11:45:00', 6, 30, 3),
  (74, '2024-01-13 14:15:00', '2024-01-13 16:30:00', 8, 5, 12),
  (75, '2024-01-14 19:45:00', '2024-01-14 21:30:00', 1, 10, 13),
  (76, '2024-01-15 08:00:00', '2024-01-15 10:15:00', 3, 15, 27),
  (77, '2024-01-16 15:30:00', '2024-01-16 17:00:00', 5, 20, 28),
  (78, '2024-01-17 12:45:00', '2024-01-17 14:30:00', 7, 25, 25),
  (79, '2024-01-18 17:00:00', '2024-01-18 19:15:00', 2, 30, 20 ),
  (80, '2024-01-19 11:15:00', '2024-01-19 13:30:00', 4, 5, 12 ),
  (81, '2024-01-20 16:45:00', '2024-01-20 18:00:00', 6, 10, 7),
  (82, '2024-01-21 09:30:00', '2024-01-21 11:45:00', 8, 15, 22),
  (83, '2024-01-22 14:15:00', '2024-01-22 16:30:00', 1, 20, 7),
  (84, '2024-01-23 19:45:00', '2024-01-23 21:30:00', 3, 25, 28),
  (85, '2024-01-24 08:00:00', '2024-01-24 10:15:00', 5, 30, 10),
  (86, '2024-01-25 15:30:00', '2024-01-25 17:00:00', 7, 5, 7),
  (87, '2024-01-26 12:45:00', '2024-01-26 14:30:00', 2, 10, 28),
  (88, '2024-01-27 17:00:00', '2024-01-27 19:15:00', 4, 15, 3),
  (89, '2024-01-28 11:15:00', '2024-01-28 13:30:00', 6, 20, 28),
  (90, '2024-01-29 16:45:00', '2024-01-29 18:00:00', 8, 25, 12),
  (91, '2024-01-30 09:30:00', '2024-01-30 11:45:00', 1, 30, 13),
  (92, '2024-01-31 14:15:00', '2024-01-31 16:30:00', 3, 5, 3),
  (93, '2024-02-01 19:45:00', '2024-02-01 21:30:00', 5, 10, 27),
  (94, '2024-02-02 08:00:00', '2024-02-02 10:15:00', 7, 15, 7),
  (95, '2024-02-03 15:30:00', '2024-02-03 17:00:00', 2, 20, 22),
  (96, '2024-02-04 12:45:00', '2024-02-04 14:30:00', 4, 25, 10),
  (97, '2024-02-05 17:00:00', '2024-02-05 19:15:00', 6, 30, 12),
  (98, '2024-02-06 11:15:00', '2024-02-06 13:30:00', 8, 5, 22),
  (99, '2024-02-07 16:45:00', '2024-02-07 18:00:00', 1, 10, 12),
  (100, '2024-02-08 09:30:00', '2024-02-08 11:45:00', 3, 15, 28);
  
-- -----------------------------------------------------
-- Popolamento `Presenza`
-- -----------------------------------------------------
INSERT INTO Presenza (Server, File)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(5, 13),
(5, 14),
(5, 15),
(6, 16),
(6, 17),
(6, 18),
(7, 19),
(8, 20);

-- -----------------------------------------------------
-- Popolamento `RestrizioneGeografica`
-- -----------------------------------------------------
INSERT INTO RestrizioneGeografica (File, Paese)
VALUES
(1, 'Congo'),
(2, 'Francia'),
(3, 'Germania'),
(4, 'Spagna'),
(5, 'Regno Unito'),
(6, 'Stati Uniti'),
(7, 'Canada'),
(8, 'Australia'),
(9, 'Giappone'),
(10, 'Brasile'),
(10, 'Cina'),
(10, 'India'),
(10, 'Russia'),
(14, 'Sudafrica'),
(15, 'Messico'),
(16, 'Argentina'),
(17, 'Corea del Sud'),
(18, 'Svezia'),
(19, 'Norvegia'),
(20, 'Olanda');

-- -----------------------------------------------------
-- Popolamento `FormatoVideo`
-- -----------------------------------------------------
INSERT INTO FormatoVideo (Codice, Risoluzione, Bitrate, Rapporto)
VALUES
(1, 1920, 5000, '16:9'),
(2, 1280, 3000, '4:3'),
(3, 3840, 8000, '16:9'),
(4, 720, 2000, '16:9'),
(5, 1920, 6000, '16:9'),
(6, 1280, 4000, '4:3'),
(7, 3840, 10000, '16:9'),
(8, 720, 2500, '16:9'),
(9, 1920, 7000, '16:9'),
(10, 1280, 3500, '4:3'),
(11, 3840, 9000, '16:9'),
(12, 720, 2200, '16:9'),
(13, 1920, 5500, '16:9'),
(14, 1280, 3200, '4:3'),
(15, 3840, 8500, '16:9'),
(16, 720, 2300, '16:9'),
(17, 1920, 6500, '16:9'),
(18, 1280, 3800, '4:3'),
(19, 3840, 9500, '16:9'),
(20, 720, 2700, '16:9');

-- -----------------------------------------------------
-- Popolamento `FormatoAudio`
-- -----------------------------------------------------
INSERT INTO FormatoAudio (Codice, Frequenza, Bitrate)
VALUES
(1, 44100000, 128), 
(2, 48000000, 192),
(3, 32000000, 96),
(4, 44104790, 256),
(5, 48003220, 128),
(6, 32034300, 192),
(7, 44104420, 192),
(8, 48003330, 256),
(9, 32004440, 128),
(10, 44103330, 96),
(11, 48002220, 320),
(12, 32004440, 160),
(13, 44102220, 224),
(14, 48003330, 160),
(15, 32006630, 256),
(16, 44106640, 160),
(17, 48001110, 224),
(18, 32003330, 128),
(19, 44100111, 320),
(20, 48000221, 192);


-- -----------------------------------------------------
-- Popolamento `RestrizioneVideo`
-- -----------------------------------------------------
INSERT INTO RestrizioneVideo (Paese, FormatoVideo)
VALUES
('Italia', 1),
('Francia', 2),
('Germania', 3),
('Spagna', 4),
('Regno Unito', 5),
('Stati Uniti', 6),
('Canada', 7),
('Australia', 8),
('Giappone', 9),
('Brasile', 10),
('Cina', 11),
('India', 12),
('Russia', 13),
('Sudafrica', 14),
('Messico', 15),
('Argentina', 16),
('Corea del Sud', 17),
('Svezia', 18),
('Norvegia', 19),
('Olanda', 20);

-- -----------------------------------------------------
-- Tabella `RestrizioneAudio`
-- -----------------------------------------------------
INSERT INTO RestrizioneAudio (Paese, FormatoAudio)
VALUES
('Argentina', 1),
('Australia', 2),
('Brasile', 3),
('Canada', 4),
('Cina', 5),
('Corea del Sud', 6),
('Francia', 7),
('Germania', 8),
('Giappone', 9),
('India', 10),
('Italia', 11),
('Messico', 12),
('Norvegia', 13),
('Olanda', 14),
('Regno Unito', 15),
('Russia', 16),
('Spagna', 17),
('Sudafrica', 18),
('Stati Uniti', 19),
('Svezia', 20);

-- -----------------------------------------------------
-- Popolamento `Lingua`
-- -----------------------------------------------------
INSERT INTO Lingua (NomeLingua)
VALUES
('Italiano'),
('Francese'),
('Tedesco'),
('Spagnolo'),
('Inglese'),
('Giapponese'),
('Cinese'),
('Russo'),
('Portoghese'),
('Coreano'),
('Arabo'),
('Svedese'),
('Norvegese'),
('Olandese'),
('Greco'),
('Tailandese'),
('Ebraico'),
('Hindi'),
('Finlandese'),
('Turco');

-- -----------------------------------------------------
-- Popolamento `Sottotitolaggio`
-- -----------------------------------------------------
INSERT INTO Sottotitolaggio (Film, Lingua)
VALUES
(1, 'Italiano'),
(1, 'Francese'),
(2, 'Tedesco'),
(2, 'Spagnolo'),
(3, 'Inglese'),
(3, 'Giapponese'),
(4, 'Cinese'),
(4, 'Russo'),
(15, 'Portoghese'),
(5, 'Coreano'),
(6, 'Arabo'),
(6, 'Svedese'),
(17, 'Norvegese'),
(7, 'Olandese'),
(18, 'Greco'),
(8, 'Tailandese'),
(9, 'Ebraico'),
(9, 'Hindi'),
(10, 'Finlandese'),
(20, 'Turco');

-- -----------------------------------------------------
-- Popolamento `Doppiaggio`
-- -----------------------------------------------------
INSERT INTO Doppiaggio (Film, Lingua)
VALUES
(1, 'Italiano'),
(1, 'Francese'),
(2, 'Tedesco'),
(12, 'Spagnolo'),
(3, 'Inglese'),
(3, 'Giapponese'),
(14, 'Cinese'),
(4, 'Russo'),
(5, 'Portoghese'),
(15, 'Coreano'),
(6, 'Arabo'),
(6, 'Svedese'),
(7, 'Norvegese'),
(7, 'Olandese'),
(8, 'Greco'),
(18, 'Tailandese'),
(9, 'Ebraico'),
(19, 'Hindi'),
(11, 'Finlandese'),
(20, 'Turco');

-- -----------------------------------------------------
-- Popolamento `Attore`
-- -----------------------------------------------------
INSERT INTO Attore (IDAttore, Nome, Cognome)
VALUES
    (1, 'Tom', 'Cruise'),
    (2, 'Emma', 'Stone'),
    (3, 'Tim', 'Robbins'),
    (4, 'Ben', 'Affleck'),
    (5, 'Elijah', 'Wood'),
    (6, 'Ryan', 'Gosling'),
    (7, 'Timothée', 'Chalamet'),
    (8, 'Andrew', 'Garfield'),
    (9, 'Rosamund', 'Pike'),
    (10, 'Shailene', 'Woodley'),
    (11, 'John', 'C. Reilly'),
    (12, 'Leonardo', 'DiCaprio'),
    (13, 'Natalie', 'Portman'),
    (14, 'Jesse', 'Eisenberg'),
    (15, 'Christian', 'Bale'),
    (16, 'Javier', 'Bardem'),
    (17, 'Jack', 'Nicholson'),
    (18, 'Katie', 'Holmes'),
    (19, 'Jim', 'Carrey'),
    (20, 'Scarlett', 'Johansson');
-- -----------------------------------------------------
-- Popolamento `Regista`
-- -----------------------------------------------------
INSERT INTO `Regista` (`IDRegista`, `Nome`, `Cognome`)
VALUES
    (1, 'Christopher', 'McQuarrie'),
    (2, 'Damien', 'Chazelle'),
    (3, 'Frank', 'Darabont'),
    (4, 'David', 'Fincher'),
    (5, 'Peter', 'Jackson'),
    (6, 'Denis', 'Villeneuve'),
    (7, 'Mel', 'Gibson'),
    (8, 'Gillian', 'Flynn'),
    (9, 'Josh', 'Boone'),
    (10, 'Rich', 'Moore'),
    (11, 'Christopher', 'Nolan'),
    (12, 'Darren', 'Aronofsky'),
    (13, 'David', 'O. Russell'),
    (16, 'Joel', 'Coen'),
    (17, 'Martin', 'Scorsese'),
    (19, 'Michel', 'Gondry'),
    (20, 'Sofia', 'Coppola');
    
-- -----------------------------------------------------
-- Popolamento `Regia`
-- -----------------------------------------------------
INSERT INTO `Regia` (`Film`, `Regista`)
VALUES
    (1, 1), -- Christopher McQuarrie per "Mission Impossible"
    (2, 2), -- Damien Chazelle per "La La Land"
    (3, 3), -- Frank Darabont per "The Shawshank Redemption"
    (4, 4), -- David Fincher per "Gone Girl"
    (5, 5), -- Peter Jackson per "The Lord of the Rings"
    (6, 2), -- Damien Chazelle per "La La Land"
    (7, 6), -- Denis Villeneuve per "Dune"
    (8, 7), -- Mel Gibson per "Hacksaw Ridge"
    (10, 9), -- Gillian Flynn per "The Fault in Our Stars"
    (11, 10), -- Rich Moore per "Wreck-It Ralph"
    (12, 11), -- Christopher Nolan per "Inception"
    (13, 12), -- Darren Aronofsky per "Black Swan"
    (14, 13), -- David Fincher per "The Social Network"
    (15, 11), -- Christopher Nolan per "The Dark Knight"
    (16, 16), -- Joel Coen per "No Country for Old Men"
    (17, 17), -- Martin Scorsese per "The Departed"
    (18, 11), -- Christopher Nolan per "Batman Begins"
    (19, 19), -- Michel Gondry per "Eternal Sunshine of the Spotless Mind"
    (20, 20); -- Sofia Coppola per "Lost in Translation"

-- -----------------------------------------------------
-- Popolamento `Recitazione`
-- -----------------------------------------------------
INSERT INTO `Recitazione` (`Attore`, `Film`)
VALUES
    (1, 1), (1, 2),
    (2, 2), (2, 6),
    (3, 3),
    (4, 4), (4, 9),
    (5, 5),
    (6, 2), (6, 16),
    (7, 7),
    (8, 8),
    (9, 4),
    (10, 10),
    (11, 11),
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15),
    (16, 16),
    (17, 17),
    (18, 18),
    (19, 19),
    (20, 20);
-- -----------------------------------------------------
-- Popolamento `Premio`
-- -----------------------------------------------------
INSERT INTO `Premio` (`IDPremio`, `Nome`)
VALUES
    (1, 'Miglior Attore'),
    (2, 'Miglior Attrice'),
    (3, 'Miglior Regista'),
    (4, 'Miglior Film'),
    (5, 'Miglior Attore Non Protagonista'),
    (6, 'Miglior Attrice Non Protagonista'),
    (7, 'Miglior Sceneggiatura Originale'),
    (8, 'Miglior Sceneggiatura Adattata'),
    (9, 'Miglior Film Straniero'),
    (10, 'Migliori Effetti Speciali');
-- -----------------------------------------------------
-- Popolamento `PremiazioneRegista`
-- -----------------------------------------------------
INSERT INTO `PremiazioneRegista` (`Regista`, `Premio`)
VALUES
    (1, 3),  -- Christopher McQuarrie (IDRegista 1) ha vinto il premio Miglior Regista (IDPremio 3)
    (2, 7);  -- Damien Chazelle (IDRegista 2) ha vinto il premio Miglior Sceneggiatura Originale (IDPremio 7)
-- -----------------------------------------------------
-- Popolamento `PremiazioneFilm`
-- -----------------------------------------------------
INSERT INTO `PremiazioneFilm` (`Film`, `Premio`)
VALUES
    (1, 4),  -- "Mission Impossible" (IDFilm 1) ha vinto il premio Miglior Film (IDPremio 4)
    (6, 8);  -- "La La Land" (IDFilm 6) ha vinto il premio Miglior Sceneggiatura Adattata (IDPremio 8)
-- -----------------------------------------------------
-- Popolamento `PremiazioneAttore`
-- -----------------------------------------------------
INSERT INTO `PremiazioneAttore` (`Attore`, `Premio`)
VALUES
    (1, 1),  -- Tom Cruise (IDAttore 1) ha vinto il premio Miglior Attore (IDPremio 1)
    (5, 5);  -- Elijah Wood (IDAttore 5) ha vinto il premio Miglior Attore Non Protagonista (IDPremio 5)
-- -----------------------------------------------------
-- Popolamento `Critico`
-- -----------------------------------------------------
INSERT INTO `Critico` (`IDCritico`, `Nome`, `Cognome`)
VALUES
    (1, 'John', 'Doe'),
    (2, 'Jane', 'Smith'),
    (3, 'Michael', 'Johnson'),
    (4, 'Emily', 'Williams'),
    (5, 'Daniel', 'Brown');
    
-- -----------------------------------------------------
-- Popolamento `Critica`
-- -----------------------------------------------------
INSERT INTO `Critica` (`Critico`, `Film`, `ValutazioneC`)
VALUES
    (1, 1, 4),
    (2, 3, 3),
    (3, 5, 5),
    (4, 7, 2),
    (5, 11, 4),
    (1, 2, 5),
    (2, 4, 1),
    (3, 6, 3),
    (4, 8, 4),
    (5, 12, 5),
    (1, 13, 2),
    (2, 15, 3),
    (3, 17, 4),
    (4, 19, 5),
    (5, 1, 1),
    (1, 14, 3),
    (2, 16, 4),
    (3, 18, 5),
    (4, 20, 2),
    (5, 2, 4),
    (1, 9, 5),
    (2, 11, 2),
    (3, 13, 3),
    (4, 15, 4),
    (5, 17, 5),
    (1, 10, 1),
    (2, 12, 3),
    (3, 14, 4),
    (4, 16, 5),
    (5, 18, 2);

-- -----------------------------------------------------
-- Popolamento `RecensioneUtente`
-- -----------------------------------------------------
INSERT INTO `RecensioneUtente` (`Utente`, `Film`, `ValutazioneU`)
VALUES
    (1, 1, 4),
    (2, 3, 3),
    (3, 5, 5),
    (4, 2, 2),
    (5, 6, 4),
    (6, 8, 1),
    (8, 10, 3),
    (9, 12, 4),
    (10, 14, 5),
    (11, 16, 2),
    (12, 18, 4),
    (13, 20, 5),
    (14, 4, 2),
    (15, 7, 3),
    (16, 9, 4),
    (17, 11, 5),
    (19, 13, 1),
    (20, 15, 3),
    (1, 17, 4),
    (2, 19, 5),
    (3, 1, 2),
    (4, 3, 5),
    (5, 5, 1),
    (6, 7, 3),
    (7, 9, 4),
    (8, 11, 5),
    (9, 13, 1),
    (10, 15, 2),
    (11, 17, 4);
-- -----------------------------------------------------
-- Popolamento `Disponibilita`
-- -----------------------------------------------------
INSERT INTO Disponibilita (File, PianoDiAbbonamento)
VALUES
(1, 'Basic'),
(2, 'Premium'),
(3, 'Premium'),
(4, 'Basic'),
(5, 'Pro'),
(6, 'Pro'),
(7, 'Pro'),
(8, 'Deluxe'),
(9, 'Deluxe'),
(10, 'Ultimate'),
(11, 'Basic'),
(12, 'Ultimate'),
(13, 'Premium'),
(14, 'Pro'),
(15, 'Pro'),
(16, 'Basic'),
(17, 'Pro'),
(18, 'Premium'),
(19, 'Basic'),
(20, 'Ultimate'),
(21, 'Premium'),
(22, 'Basic'),
(23, 'Pro'),
(24, 'Basic'),
(25, 'Basic'),
(26, 'Basic'),
(27, 'Premium'),
(28, 'Premium'),
(29, 'Premium'),
(30, 'Ultimate');


-- -----------------------------------------------------
-- Popolamento `CartadiCredito`
-- -----------------------------------------------------
INSERT INTO CartadiCredito (NumeroCarta, CVV, DataScadenza)
VALUES
(1111222233334444, 123, '2024-10-31'),
(2222333344445555, 234, '2025-07-31'),
(3333444455556666, 345, '2026-05-31'),
(4444555566667777, 456, '2027-11-30'),
(5555666677778888, 567, '2028-02-29'),
(6666777788889999, 678, '2024-10-31'),
(7777888899990000, 789, '2025-03-31'),
(8888999900001111, 890, '2026-06-30'),
(9999000011112222, 901, '2027-12-31'),
(1011122233344455, 012, '2028-01-31'),
(1212121212121212, 123, '2024-04-30'),
(1313131313131313, 234, '2025-05-31'),
(1414141414141414, 345, '2026-08-31'),
(1515151515151515, 456, '2027-09-30'),
(1616161616161616, 567, '2028-12-31'),
(1717171717171717, 678, '2024-11-30'),
(1818181818181818, 789, '2025-10-31'),
(1919191919191919, 890, '2026-01-31'),
(2020202020202020, 901, '2027-02-28'),
(2121212121212121, 012, '2028-08-31');

-- -----------------------------------------------------
-- Popolamento `Proprieta`
-- -----------------------------------------------------
INSERT INTO Proprieta (Utente, CartadiCredito)
VALUES
(1, 1111222233334444),
(2, 2222333344445555),
(3, 3333444455556666),
(4, 4444555566667777),
(5, 5555666677778888),
(6, 6666777788889999),
(7, 7777888899990000),
(8, 8888999900001111),
(9, 9999000011112222),
(10, 1011122233344455),
(11, 1212121212121212),
(12, 1313131313131313),
(13, 1414141414141414),
(14, 1515151515151515),
(15, 1616161616161616),
(16, 1717171717171717),
(17, 1818181818181818),
(18, 1919191919191919),
(19, 2020202020202020),
(20, 2121212121212121);

-- -----------------------------------------------------
-- Popolamente `Fattura`
-- -----------------------------------------------------
INSERT INTO Fattura (IDFattura, DataEmissione, Scadenza, Intestatario, Importo, CartaPagamento)
VALUES
(1, '2023-01-01', '2023-01-15', 1, 14.99, 1111222233334444),
(2, '2023-02-01', '2023-02-15', 2, 29.99, 2222333344445555),
(3, '2023-03-01', '2023-03-15', 3, 35.99, 3333444455556666),
(4, '2023-04-01', '2023-04-15', 4, 19.99, 4444555566667777),
(5, '2023-05-01', '2023-05-15', 5, 39.99, NULL),
(6, '2023-06-01', '2023-06-15', 6, 14.99, 6666777788889999),
(7, '2023-07-01', '2023-07-15', 7, 29.99, 7777888899990000),
(8, '2023-08-01', '2023-08-15', 8, 35.99, 8888999900001111),
(9, '2023-09-01', '2023-09-15', 9, 19.99, 9999000011112222),
(10, '2023-10-01', '2023-10-15', 10, 39.99, NULL),
(11, '2023-11-01', '2023-11-15', 11, 14.99, 1212121212121212),
(12, '2023-12-01', '2023-12-15', 12, 29.99, 1313131313131313),
(13, '2024-01-01', '2024-01-15', 13, 35.99, 1414141414141414),
(14, '2024-02-01', '2024-02-15', 14, 19.99, 1515151515151515),
(15, '2024-03-01', '2024-03-15', 15, 39.99, 1616161616161616),
(16, '2024-04-01', '2024-04-15', 16, 14.99, NULL),
(17, '2024-05-01', '2024-05-15', 17, 29.99, 1818181818181818),
(18, '2024-06-01', '2024-06-15', 18, 35.99, 1919191919191919),
(19, '2024-07-01', '2024-07-15', 19, 19.99, NULL),
(20, '2024-08-01', '2024-08-15', 20, 39.99, 2121212121212121);





-- ----------------------------------------------------
-- Analytics 1: Bilanciamento del carico                        
-- -----------------------------------------------------
-- -----------------------------------------------------
-- procedura bilanciamento

drop procedure if exists bilanciamento ()
delimiter $$ 
create procedure bilanciamento ()
begin 
declare serverdestinazione int  default 0;
declare server_target int; -- id server da liberare
declare banda_d int ; -- banda disponibile
declare banda_tot int; -- banda totale
declare banda_liberare int; -- banda da liberare
declare cont int; -- contatore 
declare temp int;
declare id_er int;
declare id_f int;
declare finito int default 0;

declare cursore1 cursor for
select f.BitrateTotale, e.IDErogazione, f.IDFile
from Erogazione e inner join File f on e.File=f.IDFile
where e.Server=server_target and e.OraFine is NULL;

declare cursore cursor for
select IDServer, BandaDisponibile, Banda
from Server
where (BandaDisponibile/ Banda <= 0.2);
declare continue handler for not found set finito = 1;

select IDServer into serverdestinazione
from Server
where BandaDisponibile/Banda=(
    select max(BandaDisponibile/Banda)
    from Server);

open cursore;
scan : loop
    set cont = 0;
	fetch cursore into server_target, banda_d, banda_tot;
	if finito  
	then leave scan;
	end if;

    open cursore1;
    scan1 : loop
            fetch cursore1 into temp, id_er, id_f;
            set cont=cont+temp;

            if (select count(*) from Presenza p where p.Server=serverdestinazione and p.File=id_f)=0
            then insert into Presenza(Server, File) values (serverdestinazione, id_f);
            end if; 

            update Server
            set BandaDisponibile=BandaDisponibile+temp
            where IDServer=server_target;

            update Server
            set BandaDisponibile=BandaDisponibile-temp
            where IDServer=serverdestinazione;

            update Erogazione
            set Server=serverdestinazione
            where IDErogazione=id_er;

            if cont>=banda_d - 0.2 * banda_tot
            then leave scan1;
            end if;
    end loop;
end loop ;
end $$

-- ----------------------------------------------------
-- Analytics 2: Classifiche
-- ----------------------------------------------------
drop procedure if exists classifiche;

delimiter $$
create procedure classifiche()
begin 
select film.titolo as film, u.abbonamento, f.formatovideo as formatovideo, f.formatoaudio as formatoaudio, count(*) as visualizzazioni
from Erogazione e inner join File f on f.IDFile = e.file 
inner join Connessione c on e.ipconnessione = c.ip and e.dispositivo = c.dispositivo 
inner join Dispositivo d on c.dispositivo= d.IDdispositivo
inner join Utente u on d.utente = u.codice
inner join Film on f.film = Film.id
group by u.abbonamento, f.film, f.formatovideo, f.formatoaudio
order by u.abbonamento, visualizzazioni desc;

end $$

-- ----------------------------------------------------
-- Operazione 1: Nuova_connessione
-- ----------------------------------------------------
drop procedure if exists nuova_connessione;

delimiter $$
create procedure nuova_connessione( in _dispositivo int, in _ip bigint, in _inizioconn datetime, in _fineconn datetime, out stato_ bool)
begin
declare temp int;
set temp = (select count(*) from connessione c where c.orainizio = _inizioconn and c.dispositivo = _dispositivo);
if temp = 1 then set stato_ = false;
else INSERT INTO Connessione(OraInizio, Dispositivo, IP, OraFine)
            VALUES (_inizioconn, _dispositivo, _ip, _fineconn);
	set stato_ = true;
end if;

end $$
delimiter $$;
-- -----------------------------------------------------
-- Operazione 2: Fine_Erogazione
-- -----------------------------------------------------
drop procedure if exists fine_erogazione;
delimiter $$
create procedure fine_erogazione(in _iderogazione int, out check_ bool)
begin   
declare controllo datetime;
declare bitrate int;
declare serv int;
select BitrateTotale, e.Server into bitrate, serv
from Erogazione e inner join File f on e.File= f.IDFile 
where e.IDErogazione= _iderogazione ;
set controllo =(select orafine from Erogazione e where e.IDErogazione = _iderogazione);
if controllo is null then update Erogazione set orafine= current_time where IDErogazione = _iderogazione; 
update Server set BandaDisponibile = BandaDisponibile-bitrate where IDServer = serv;
	set check_= true;
else 
	set check_= false;
end if;
end $$
delimiter $$;

-- ----------------------------------------------------
-- Operazione 3: Registrazione_Utente
-- -----------------------------------------------------
drop procedure if exists registrazione_utente;
delimiter $$
create procedure registrazione_utente (in _codice int, in _nome varchar(50), in _cognome varchar(50), in _password varchar(20), in _email varchar(100), in _abbonamento varchar(100) ,out check_ bool)
begin   
declare temp int;
set temp = (select codice from Utente where codice = _codice); 
if temp =1 then set check_ = false;
else  INSERT INTO Utente(Codice,Nome, Cognome,Password,Email,Abbonamento)
            VALUES (_codice, _nome, _cognome , _password , _email , _abbonamento);
	set check_ = true;
end if;
end $$
delimiter $$;


-- ----------------------------------------------------
-- Operazione 4: Emissione_nuova_fattura
-- -----------------------------------------------------
drop procedure if exists emissione_nuova_fattura;
delimiter $$
create procedure emissione_nuova_fattura (in _idfattura int, in _intestatario int, in _importo double ,out check_ bool)
begin   
declare temp int;
set temp = (select IDFattura from Fattura where IDFattura = _idfattura);
if temp = 1 then set check_ = false;
else INSERT INTO Fattura (IDFattura, DataEmissione,Scadenza, Intestatario,  Importo, CartaPagamento)
            VALUES ( _idfattura , current_date(), current_date()+interval 14 day, _importo, null);
	set check_ = true;
    end if;
end $$
delimiter $$;
-- ----------------------------------------------------
-- Operazione 5: Pagamento_fattura
-- -----------------------------------------------------
drop procedure if exists pagamento_fattura;
delimiter $$
create procedure pagamento_fattura (in _idfattura int, in _cartapagamento bigint, out check_ bool)
begin   
declare temp bigint;
set temp = (select CartaPagamento from Fattura where IDFattura = _idfattura);
if temp  is not null then set check_ = false;
else update Fattura set CartaPagamento = _cartapagamento where  IDFattura = _idfattura;
	set check_ = true;
    end if;
end $$
delimiter $$;
-- ----------------------------------------------------
-- Operazione 6a: stampa_premi_attore 
-- -----------------------------------------------------
drop procedure if exists stampa_premi_attore;
delimiter $$
create procedure stampa_premi_attore (in _attore int)
begin   
select a.Nome as Nome, a.Cognome as Cognome, p.Nome as Lista_Premi 
from PremiazioneAttore pa INNER JOIN Attore a ON pa.attore = a.IDAttore INNER JOIN Premio p ON pa.Premio = p.IDPremio
where Attore = _attore ;
end $$
delimiter $$;
-- call stampa_premi_attore (5);

-- ----------------------------------------------------
-- Operazione 6b: Stampa_premi_regista
-- -----------------------------------------------------
drop procedure if exists stampa_premi_regista;
delimiter $$
create procedure stampa_premi_regista (in _regista int)
begin   
select r.Nome as Nome, r.Cognome as Cognome, p.Nome as Lista_Premi 
from PremiazioneRegista pr INNER JOIN Regista r ON pr.Regista = r.IDRegista INNER JOIN Premio p ON pr.Premio = p.IDPremio
where Regista = _regista ;
end $$
delimiter $$;
-- call stampa_premi_regista(2);
-- ----------------------------------------------------
-- Operazione 6c: Stampa_premi_film
-- -----------------------------------------------------
drop procedure if exists stampa_premi_film;
delimiter $$
create procedure stampa_premi_film (in _film int)
begin   
select f.Titolo as Titolo, p.Nome as Lista_Premi 
from PremiazioneFilm pf INNER JOIN Film f ON pf.Film = f.ID INNER JOIN Premio p ON pf.Premio = p.IDPremio
where ID = _film;
end $$
delimiter $$;
-- call stampa_premi_film(6);