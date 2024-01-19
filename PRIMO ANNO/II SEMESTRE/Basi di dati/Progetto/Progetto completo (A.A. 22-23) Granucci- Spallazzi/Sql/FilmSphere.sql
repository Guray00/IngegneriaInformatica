SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

BEGIN;
CREATE DATABASE IF NOT EXISTS `FilmSphere`;
COMMIT;
USE `filmsphere`;
-- FILM 
DROP TABLE IF EXISTS `Film`;
Create Table `Film` (
	`Codice` int not null,
    `Titolo` varchar(50) not null,
    `Descrizione` varchar(2047) not null,
    `Durata` int not null,
    `AnnoProduzione` int not null,
    `Regista` int not null,
    `PaeseDiProduzione` char(255) not null,
    `NumeroRecensioni` int default 0,
    `MediaRecensioni` float,
    Primary Key(`Codice`),
    FOREIGN KEY(`Regista`) REFERENCES Regista(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`PaeseDiProduzione`) REFERENCES Stato(`Nome`)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


DELIMITER //
CREATE TRIGGER AnnoProd_Film
BEFORE INSERT ON Film
FOR EACH ROW
BEGIN
    IF NEW.AnnoProduzione >= YEAR(CURRENT_DATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'AnnoProduzione deve essere minore o uguale all\'anno corrente';
    END IF;
END //
DELIMITER ;


-- Partecipazione
DROP TABLE IF EXISTS `Partecipazione`;
Create Table `Partecipazione`(
	`Film` int not null,
    `Attore` int not null,
    Primary key(`Film`, `Attore`),
    FOREIGN KEY(`Film`) REFERENCES film(Codice)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`Attore`) references attore(Codice)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Attore
DROP TABLE IF EXISTS `Attore`;
Create table `Attore` (
	`Codice` int not null,
    `Nome` char(255) not null,
    `Cognome` char(255) not null,
	Primary key(`Codice`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Regista
DROP TABLE IF EXISTS `Regista`;
Create table `Regista` (
	`Codice` int not null,
    `Nome` char(255) not null,
    `Cognome` char(255) not null,
	Primary key(`Codice`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;
    
-- Vincita
DROP TABLE IF EXISTS `Vincita`;
Create table `Vincita` (
	`Codice` int not null,
    `Film` int not null,
    `Premio` varchar(255) not null,
	`Data` date not null,
    Primary key(`Codice`),
    FOREIGN KEY(`Film`) references film(`Codice`),
    FOREIGN KEY(`Premio`) references premio(`Tipo`)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DELIMITER //
CREATE TRIGGER Data_Vincita
BEFORE INSERT ON Vincita
FOR EACH ROW
BEGIN
    IF NEW.Data >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una Vincita non può avvenire nel futuro';
	END IF;
END //
DELIMITER ;


-- PremiazioneRegista
DROP TABLE IF EXISTS `PremiazioneRegista`;
Create table `PremiazioneRegista` (
	`Regista` int not null,
    `Vincita` int not null,
    Primary key (`Regista`, `Vincita`),
    
	foreign key(`Regista`) references `Regista`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(`Vincita`) references `Vincita`(`Codice`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- PremiazioneAttore
DROP TABLE IF EXISTS `PremiazioneAttore`;
Create table `PremiazioneAttore` (
	`Attore` int not null,
	`Vincita` int not null,
	Primary key(`Attore`, `Vincita`),
    foreign key(`Attore`) references `Attore`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(`Vincita`) references `Vincita`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Premio
DROP TABLE IF EXISTS `Premio`;
Create table `Premio` (
	`Tipo` varchar(255) not null,
    `Valore` float not null,
	Primary key(`Tipo`),
    check(Valore BETWEEN 0.0 and 1.0)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;
    
-- Critico
DROP TABLE IF EXISTS `Critico`;
Create table `Critico` (
	`Codice` int not null,
    `Nome` char(255) not null,
    `Cognome` char(255) not null,
	Primary key(`Codice`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Recensione
DROP TABLE IF EXISTS `Recensione`;
Create table `Recensione` (
	`Film` int not null,
	`Critico` int not null,
    `Data` date not null,
    `Valore` int not null,
	Primary key(`Film`, `Critico`),
    check (Valore between 0 and 10),
    foreign key (`Film`) references `Film`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key (`Critico`) references `Critico`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Appartenenza
DROP TABLE IF EXISTS `Appartenenza`;
Create table `Appartenenza` (
	`Film` int not null,
    `Genere` varchar(63) not null,
	Primary key(`Film`, `Genere`),
    foreign key(`Film`) references `Film`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(`Genere`) references `Genere`(`Nome`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- Genere
DROP TABLE IF EXISTS `Genere`;
Create table `Genere` (
	`Nome` varchar(63) not null,
	Primary key(`Nome`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- FilmCodificato
DROP TABLE IF EXISTS `FilmCodificato`;
Create table `FilmCodificato` (
	`Codice` int not null,
	`Lunghezza` int not null,
	`Dimensione` int not null,
	`Film` int not null,
	`FormatoAudio` varchar(50) not null,
	`FormatoVideo` varchar(50) not null,
	Primary key(`Codice`),
    Foreign key(`Film`) references `Film`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    Foreign key (`FormatoAudio`) references `FormatoAudio`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    Foreign key (`FormatoVideo`) references `FormatoVideo`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- FormatoVideo
DROP TABLE IF EXISTS `FormatoVideo`;
Create table `FormatoVideo` (
	`Codice` varchar(50) not null,
	`Risoluzione` int not null,
    `Famiglia` varchar(31) not null,
    `AspectRatio` float not null,
    `DataRilascio` date not null,
    `Qualita` int not null,
    `BitRate` int not null,
	Primary key(`Codice`),
    check (`Risoluzione` between 480 and 9999),
    check (`Qualita` between 0 and 4)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

DELIMITER //
CREATE TRIGGER DataRilascio_FV
BEFORE INSERT ON FormatoVideo
FOR EACH ROW
BEGIN
    IF NEW.DataRilascio >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un FormatoVideo non può essere rilasciato nel futuro';
	END IF;
END //
DELIMITER ;

-- FormatoAudio
DROP TABLE IF EXISTS `FormatoAudio`;
Create table `FormatoAudio` (
	`Codice` varchar(50) not null,
    `Famiglia` varchar(31) not null,
    `DataRilascio` date not null,
    `Qualita` int not null,
    `BitRate` int not null,
	Primary key(`Codice`),
    check (`Qualita` between 0 and 4)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;
    
    
DROP TRIGGER IF EXISTS DataRilascio_FA;
DELIMITER //
CREATE TRIGGER DataRilascio_FA
BEFORE INSERT ON FormatoAudio
FOR EACH ROW
BEGIN
    IF NEW.DataRilascio >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un FormatoAudio non può essere rilasciato nel futuro';
	END IF;
END //
DELIMITER ;

-- Lingua
DROP TABLE IF EXISTS `Lingua`;
Create table `Lingua` (
	`Nome` varchar(31) not null,
	
	Primary key(`Nome`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Audio
DROP TABLE IF EXISTS `Audio`;
Create table `Audio` (
	`Lingua` varchar(31) not null,
	`FilmCodificato` int not null,
	Primary key(`Lingua`, `FilmCodificato`),
    foreign key(`Lingua`) references `Lingua`(`Nome`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(`FilmCodificato`) references `filmcodificato`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Sottotitolo
DROP TABLE IF EXISTS `Sottotitolo`;
Create table `Sottotitolo` (
	`Lingua` varchar(31) not null,
	`FilmCodificato` int not null,
	Primary key(`Lingua`, `FilmCodificato`),
    foreign key(`Lingua`) references `Lingua`(`Nome`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key(`FilmCodificato`) references `filmcodificato`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Stato
DROP TABLE IF EXISTS `Stato`;
Create table `Stato` (
	`Nome` varchar(255) not null,
    `Longitudine` float not null,
    `Latitudine` float not null,
    `IpInizio` int not null,
    `IpFine` int not null,
	Primary key(`Nome`),
    check (`latitudine` between -90.0 and 90.0),
    check (`longitudine` between -180.0 and 180.0),
    check (`IpInizio`  between 1 and 255255255255),
    check (`IpFine` between 1 and 255255255255),
    check(`IpInizio` < `Ipfine`) 
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- RestrizioneFormato
DROP TABLE IF EXISTS `RestrizioneFormato`;
Create table `RestrizioneFormato` (
	`Stato` varchar(255) not null,
	`FilmCodificato` int not null,
	Primary key(`Stato`, `FilmCodificato`),
    foreign key(`Stato`) references `Stato`(`Nome`)
     ON DELETE CASCADE ON UPDATE CASCADE,
     foreign key(`FilmCodificato`) references `FilmCodificato`(`Codice`)
      ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Abbonamento
DROP TABLE IF EXISTS `Abbonamento`;
Create table `Abbonamento` (
	`Tipo` varchar(10) not null,
	`Durata` int not null,
    `MaxRisoluzione` int,
    `Download` bool not null,
    `MaxConnessioni` int,
    `TariffaMensile` int not null,
    `MaxGb` int,
	Primary key(`Tipo`),
     check (`MaxRisoluzione` between 480 and 9999)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- RestrizioneAbbonamento
DROP TABLE IF EXISTS `RestrizioneAbbonamento`;
Create table `RestrizioneAbbonamento` (
	`Stato` varchar(255) not null,
	`Abbonamento` varchar(10) not null,
	Primary key(`Stato`, `Abbonamento`),
    foreign key(`Stato`) references `Stato`(`Nome`)
      ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (`Abbonamento`) references `abbonamento`(`Tipo`)
      ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Utente
DROP TABLE IF EXISTS `Utente`;
Create table `Utente` (
	`Codice` varchar(255) not null,
    `Email` varchar(255) not null,
    `Nome` varchar(255) not null,
    `Cognome` varchar(255) not null,
    `ConnessioniAttive` tinyint not null default 0,
    `Password` varchar(255) not null,
    `Stato` varchar(255) not null,
	Primary key(`Codice`),
    foreign key (`Stato`) references `Stato`(`Nome`)
      ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Fattura
DROP TABLE IF EXISTS `Fattura`;
Create table `Fattura` (
	`Tariffa` int not null,
    `DataEmissione` date not null,
    `Scadenza` date not null,
    `Utente` varchar(255) not null,
    `CartaDiCredito` int not null,
	Primary key(`DataEmissione`, `Scadenza`, `Utente`),
    foreign key(`Utente`) references `Utente`(`Codice`),
    foreign key(`CartaDiCredito`) references `CartaDiCredito`(`NumeroCarta`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- CartaDiCredito
DROP TABLE IF EXISTS `CartaDiCredito`;
Create table `CartaDiCredito` (
	`NumeroCarta` int not null,
	`Scadenza` date not null,
    `CVV` int not null,
    `Utente` varchar(255),
	Primary key(`NumeroCarta`),
    foreign key(`Utente`) references `Utente`(`Codice`)
      ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Acquisto
DROP TABLE IF EXISTS `Acquisto`;
Create table `Acquisto` (
	`Utente` varchar(255) not null,
	`Abbonamento` varchar(10) not null,
    `InizioAbbonamento` date not null,
	Primary key(`Utente`, `Abbonamento`),
    foreign key(`Utente`) references `Utente`(`Codice`)
     ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key(`Abbonamento`) references `Abbonamento`(`Tipo`)
     ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;
    
    
    
DROP trigger if exists InizioAbbonamento_Acquisto;
DELIMITER //
CREATE TRIGGER `InizioAbbonamento_Acquisto`
BEFORE INSERT ON `Acquisto`
FOR EACH ROW
BEGIN
    IF NEW.InizioAbbonamento >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non ci si può abbonare nel futuro';
	END IF;
END //
DELIMITER ;

-- Preferenza
DROP TABLE IF EXISTS `Preferenza`;
Create table `Preferenza` (
	`Nome` varchar(63) not null,
	Primary key(`Nome`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Selezione
DROP TABLE IF EXISTS `Selezione`;
Create table `Selezione` (
	`Utente` varchar(255) not null,
	`Preferenza` varchar(63) not null,
	Primary key(`Utente`, `Preferenza`),
    foreign key(`Utente`) references `Utente`(`Codice`)
     ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key(`Preferenza`) references `Preferenza`(`Nome`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- RecensioneUtente
DROP TABLE IF EXISTS `RecensioneUtente`;
Create table `RecensioneUtente` (
	`Utente` varchar(255) not null,
	`Film` int not null,
    `Data` date not null,
    `Valore` int not null,
	Primary key(`Utente`, `Film`),
    check(`Valore` between 1 and 10),
    foreign key(`Utente`) references `Utente`(`Codice`)
     ON DELETE CASCADE ON UPDATE CASCADE,
     foreign key(`Film`) references `Film`(`Codice`)
      ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP trigger if exists Data_RU;
DELIMITER //
CREATE TRIGGER Data_RU
BEFORE INSERT ON `RecensioneUtente`
FOR EACH ROW
BEGIN
    IF NEW.Data > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una recensione non può essere postata nel futuro';
	END IF;
END //
DELIMITER ;


-- Connessione
DROP TABLE IF EXISTS `Connessione`;
Create table `Connessione` (
	`Inizio` timestamp not null,
	`Dispositivo` int not null,
    `Ip` int not null,
    `Fine` timestamp default null,
	`Utente` varchar(255) not null,
	Primary key(`Inizio`, `Dispositivo`),
    check (`Ip` between 1 and 255255255255),
    foreign key(`Utente`) references `Utente`(`Codice`)
     ON DELETE CASCADE ON UPDATE CASCADE,
     foreign key(`Dispositivo`) references `Dispositivo`(`Codice`)
    
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dispositivo
DROP TABLE IF EXISTS `Dispositivo`;
Create table `Dispositivo` (
	`Codice` int not null,
	`Tipo` varchar(63) not null,
    `Risoluzione` int not null,
    `AspectRatio` float not null,
	Primary key(`Codice`)
    
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Visualizzazione
DROP TABLE IF EXISTS `Visualizzazione`;
Create table `Visualizzazione` (
	`Inizio` timestamp not null,
	`InizioConnessione` timestamp not null,
    `DispositivoConnessione` int not null,
    `Fine` timestamp not null,
    `Server` int not null,
    `FilmCodificato` int not null,
	Primary key(`Inizio`, `InizioConnessione`, `DispositivoConnessione`),
    foreign key(`InizioConnessione`, `DispositivoConnessione`) references `Connessione`(`Inizio`, `Dispositivo`)
     ON DELETE CASCADE ON UPDATE CASCADE,
     foreign key (`FilmCodificato`) references `FilmCodificato`(`Codice`)
      ON DELETE CASCADE ON UPDATE CASCADE,
     foreign key (`Server`) references `Server`(`Codice`)
      ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Server
DROP TABLE IF EXISTS `Server`;
Create table `Server` (
	`Codice` int not null,
	`LarghezzaDiBanda` int not null,
	`CapacitaMassima` int not null,
	`Longitudine` int not null,
	`Latitudine` int not null,
	`BandaAttuale` int not null,
	`CapacitaAttuale` int not null,
	`FilmCodificato` int not null,
	Primary key(`Codice`),
     check (`latitudine` between -90.0 and 90.0),
    check (`longitudine` between -180.0 and 180.0),
    foreign key (`FilmCodificato`) references `filmcodificato` (`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- PossessoServer
DROP TABLE IF EXISTS `PossessoServer`;
Create table `PossessoServer` (
	`Server` int not null,
	`FilmCodificato` int not null,
	Primary key(`Server`, `FilmCodificato`),
    foreign key (`Server`) references `Server`(`Codice`)
    ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key (`FilmCodificato`) references `FilmCodificato`(`Codice`)
    )ENGINE=InnoDB DEFAULT CHARSET=latin1;
