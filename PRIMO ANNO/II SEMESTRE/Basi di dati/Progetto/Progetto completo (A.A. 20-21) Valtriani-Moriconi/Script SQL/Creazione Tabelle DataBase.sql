# Segue all'interno del seguente script.sql la creazione delle tabelle, popolamento di quest'ultime.
-- ----------------------------------- INIZIO DELLA CREAZIONE DELLE TABELLE ----------------------------------------------
DROP DATABASE IF EXISTS SmartHome;
CREATE DATABASE IF NOT EXISTS SmartHome;
USE SmartHome;
SET foreign_key_checks = 1;
SET GLOBAL event_scheduler = ON;

DROP TABLE IF EXISTS Timestamp;
CREATE TABLE Timestamp(
	Istante TIMESTAMP,
    TemperaturaEsterna DOUBLE NOT NULL,
    PRIMARY KEY(Istante)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Domanda;
CREATE TABLE Domanda (
	ID_Domanda INT AUTO_INCREMENT,
    Quesito VARCHAR(100) NOT NULL,
	PRIMARY KEY(ID_Domanda)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Documento;
CREATE TABLE Documento (
	ID_Documento INT AUTO_INCREMENT,
	Tipologia VARCHAR(60) NOT NULL,
	EnteRilascio VARCHAR(60) NOT NULL,
	CodiceDocumento VARCHAR(60) NOT NULL,
	DataScadenza DATE NOT NULL,
	PRIMARY KEY(ID_Documento)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Utente;
CREATE TABLE Utente (
	ID_Utente INT AUTO_INCREMENT,
    Nome VARCHAR(30) NOT NULL,
    Cognome VARCHAR(30) NOT NULL,
    DataNascita DATE NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    CodiceFiscale CHAR(16) NOT NULL,
    DataIscrizione DATE DEFAULT(CURRENT_DATE) NOT NULL,
    Username VARCHAR(30) NOT NULL,
    Password CHAR(40) NOT NULL,
    Risposta VARCHAR(100) NOT NULL,
    ID_Domanda INT NOT NULL,
    ID_Documento INT NOT NULL,
    PRIMARY KEY(ID_Utente),
    FOREIGN KEY (ID_Documento) REFERENCES Documento(ID_Documento)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Domanda)   REFERENCES Domanda(ID_Domanda)
	ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS PuntoCardinale;
CREATE TABLE PuntoCardinale (
	ID_PuntoCardinale INT AUTO_INCREMENT,
    Nome VARCHAR(2) NOT NULL,
    PRIMARY KEY(ID_PuntoCardinale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Stanza;
CREATE TABLE Stanza (
	ID_Stanza INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    Larghezza DOUBLE NOT NULL,
	CHECK(Larghezza > 0),
    Lunghezza DOUBLE NOT NULL,
	CHECK(Lunghezza > 0),
    Altezza DOUBLE NOT NULL,
	CHECK(Altezza > 0),
    NumeroPiano INT NOT NULL,
    TemperaturaAttuale DOUBLE NOT NULL,
    UmiditaAttuale DOUBLE NOT NULL,
	CHECK(UmiditaAttuale > 0 AND  UmiditaAttuale <= 100),
    SpessoreParete DOUBLE NOT NULL,
	CHECK(SpessoreParete > 0),
    ConducibilitaTermica DOUBLE NOT NULL,
	CHECK(ConducibilitaTermica > 0),
    PRIMARY KEY(ID_Stanza)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS PuntoDiAccesso;
CREATE TABLE PuntoDiAccesso (
	ID_PuntoDiAccesso INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    Aperto TINYINT(1) NOT NULL,
    ID_Stanza1 INT NOT NULL,
    ID_Stanza2 INT,
    ID_PuntoCardinale INT,
    PRIMARY KEY(ID_PuntoDiAccesso),
    FOREIGN KEY (ID_Stanza1) REFERENCES Stanza(ID_Stanza)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Stanza2) REFERENCES Stanza(ID_Stanza)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_PuntoCardinale) REFERENCES PuntoCardinale(ID_PuntoCardinale)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS SmartPlug;
CREATE TABLE SmartPlug (
	ID_SmartPlug INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    StatoConnessione TINYINT(1) NOT NULL,
    StatoUscita TINYINT(1) NOT NULL,
	ID_Stanza INT NOT NULL,
    PRIMARY KEY(ID_SmartPlug),
    FOREIGN KEY (ID_Stanza) REFERENCES Stanza(ID_Stanza)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS TipologiaDispositivo;
CREATE TABLE TipologiaDispositivo (
	ID_TipologiaDispositivo INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    PRIMARY KEY(ID_TipologiaDispositivo)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Dispositivo;
CREATE TABLE Dispositivo (
	ID_Dispositivo INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    Potenza DOUBLE,
	CHECK(Potenza > 0),
    ID_SmartPlug INT,
    ID_TipologiaDispositivo INT NOT NULL,
    PRIMARY KEY(ID_Dispositivo),
    FOREIGN KEY (ID_SmartPlug) REFERENCES SmartPlug(ID_SmartPlug)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_TipologiaDispositivo) REFERENCES TipologiaDispositivo(ID_TipologiaDispositivo)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Programma;
CREATE TABLE Programma (
	ID_Programma INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    PotenzaMedia DOUBLE NOT NULL,
    CHECK(PotenzaMedia > 0),
    DurataTemporale DOUBLE,
    CHECK(DurataTemporale > 0),
    ID_Dispositivo INT NOT NULL,
    PRIMARY KEY(ID_Programma),
    FOREIGN KEY (ID_Dispositivo) REFERENCES Dispositivo(ID_Dispositivo)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Suggerimento;
CREATE TABLE Suggerimento (
	ID_Suggerimento INT AUTO_INCREMENT,
    Accettato TINYINT(1) DEFAULT 0,
    ID_Programma INT NOT NULL,
    ID_Utente INT,
    Convenienza INT,
    Istante TIMESTAMP NOT NULL,
    PRIMARY KEY(ID_Suggerimento),
    FOREIGN KEY (ID_Programma) REFERENCES Programma(ID_Programma)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Istante) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RegistroDispositivo;
CREATE TABLE RegistroDispositivo (
	IstanteInizio TIMESTAMP NOT NULL,
    ID_Dispositivo INT NOT NULL,
    ID_Utente INT NOT NULL,
    ID_Programma INT,
    IstanteFine TIMESTAMP,
    PRIMARY KEY(IstanteInizio, ID_Dispositivo),
    FOREIGN KEY (IstanteInizio) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Dispositivo) REFERENCES Dispositivo(ID_Dispositivo)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Programma) REFERENCES Programma(ID_Programma)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IstanteFine) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS FasciaOraria;
CREATE TABLE FasciaOraria (
	ID_FasciaOraria INT AUTO_INCREMENT,
    OraInizio TIME NOT NULL,
    OraFine TIME NOT NULL,
    Prezzo DOUBLE NOT NULL,
    CHECK(Prezzo > 0),
    PRIMARY KEY(ID_FasciaOraria)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RiepilogoEnergeticoGiornaliero;
CREATE TABLE RiepilogoEnergeticoGiornaliero (
	Data DATE,
    TotaleAcquisto DOUBLE NOT NULL,
    TotaleVendita DOUBLE NOT NULL,
    TotaleConsumi DOUBLE NOT NULL,
    ImportoTotaleAcquisto DOUBLE NOT NULL,
    ImportoTotaleVendita DOUBLE NOT NULL,
    PRIMARY KEY(Data)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS ContatoreBidirezionale;
CREATE TABLE ContatoreBidirezionale (
	Istante TIMESTAMP DEFAULT(CURRENT_TIMESTAMP),
    AcquistoReteElettrica DOUBLE NOT NULL,
    CHECK(AcquistoReteElettrica >= 0),
    VenditaReteElettrica DOUBLE NOT NULL,
    CHECK(VenditaReteElettrica >= 0),
    PotenzaTotaleAbitazione DOUBLE NOT NULL,
    CHECK(PotenzaTotaleAbitazione >= 0),
    ID_FasciaOraria INT NOT NULL,
    DataRiepilogo DATE,
    PRIMARY KEY(Istante),
    FOREIGN KEY (ID_FasciaOraria) REFERENCES FasciaOraria(ID_FasciaOraria)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DataRiepilogo) REFERENCES RiepilogoEnergeticoGiornaliero(Data)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Climatizzatore;
CREATE TABLE Climatizzatore (
	ID_Climatizzatore INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    Acceso TINYINT(1) NOT NULL,
    ID_Stanza INT NOT NULL,
    PRIMARY KEY(ID_Climatizzatore),
    FOREIGN KEY (ID_Stanza) REFERENCES Stanza(ID_Stanza)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Mese;
CREATE TABLE Mese (
	Numero INT NOT NULL,
	Nome VARCHAR(30) NOT NULL,
    PRIMARY KEY(Numero)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Giorno;
CREATE TABLE Giorno (
	Numero INT NOT NULL,
	Nome VARCHAR(30) NOT NULL,
    PRIMARY KEY(Numero)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS ImpostazioneClimatizzatore;
CREATE TABLE ImpostazioneClimatizzatore (
	ID_ImpostazioneClimatizzatore INT AUTO_INCREMENT,
    TemperaturaDesiderata DOUBLE,
    UmiditaDesiderata DOUBLE,
	CHECK(UmiditaDesiderata >= 0 AND  UmiditaDesiderata <= 100),
    OraInizio TIME,
    OraFine TIME,
    DataInizio DATE,
    DataFine DATE,
    Ripetitiva TINYINT(1) NOT NULL,
    ID_Utente INT NOT NULL,
    PRIMARY KEY(ID_ImpostazioneClimatizzatore),
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS MesiAttivi;
CREATE TABLE MesiAttivi (
	ID_ImpostazioneClimatizzatore INT NOT NULL,
    NumeroMese INT NOT NULL,
    PRIMARY KEY(ID_ImpostazioneClimatizzatore, NumeroMese),
    FOREIGN KEY (ID_ImpostazioneClimatizzatore) REFERENCES ImpostazioneClimatizzatore(ID_ImpostazioneClimatizzatore)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (NumeroMese) REFERENCES Mese(Numero)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS GiorniAttivi;
CREATE TABLE GiorniAttivi (
	ID_ImpostazioneClimatizzatore INT NOT NULL,
    NumeroGiorno INT NOT NULL,
    PRIMARY KEY(ID_ImpostazioneClimatizzatore, NumeroGiorno),
    FOREIGN KEY (ID_ImpostazioneClimatizzatore) REFERENCES ImpostazioneClimatizzatore(ID_ImpostazioneClimatizzatore)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (NumeroGiorno) REFERENCES Giorno(Numero)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Riferito;
CREATE TABLE Riferito (
	ID_ImpostazioneClimatizzatore INT NOT NULL,
    ID_Climatizzatore INT NOT NULL,
    PRIMARY KEY(ID_ImpostazioneClimatizzatore, ID_Climatizzatore),
    FOREIGN KEY (ID_ImpostazioneClimatizzatore) REFERENCES ImpostazioneClimatizzatore(ID_ImpostazioneClimatizzatore)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Climatizzatore) REFERENCES Climatizzatore(ID_Climatizzatore)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RegistroClimatizzatore;
CREATE TABLE RegistroClimatizzatore (
	IstanteInizio TIMESTAMP NOT NULL,
    ID_Climatizzatore INT NOT NULL,
    ID_Utente INT NOT NULL,
	ID_ImpostazioneClimatizzatore INT,
	IstanteFine TIMESTAMP,
    TemperaturaObiettivo DOUBLE,
    UmiditaObiettivo DOUBLE,
    TemperaturaIniziale DOUBLE NOT NULL,
    UmiditaIniziale DOUBLE NOT NULL,
    PRIMARY KEY(IstanteInizio, ID_Climatizzatore),
    FOREIGN KEY (IstanteInizio) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Climatizzatore) REFERENCES Climatizzatore(ID_Climatizzatore)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_ImpostazioneClimatizzatore) REFERENCES ImpostazioneClimatizzatore(ID_ImpostazioneClimatizzatore)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IstanteFine) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Luce;
CREATE TABLE Luce (
	ID_Luce INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    IntensitaMinima DOUBLE NOT NULL,
    IntensitaMassima DOUBLE NOT NULL,
    TemperaturaMinima DOUBLE NOT NULL,
    TemperaturaMassima DOUBLE NOT NULL,
    ID_Stanza INT NOT NULL,
    PRIMARY KEY(ID_Luce),
    FOREIGN KEY (ID_Stanza) REFERENCES Stanza(ID_Stanza)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS ImpostazioneLuce;
CREATE TABLE ImpostazioneLuce (
	ID_ImpostazioneLuce INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    Intensita DOUBLE,
    Temperatura DOUBLE,
    ID_Utente INT NOT NULL,
    ID_Luce INT NOT NULL,
    PRIMARY KEY(ID_ImpostazioneLuce),
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Luce) REFERENCES Luce(ID_Luce)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RegistroIlluminazione;
CREATE TABLE RegistroIlluminazione (
	IstanteInizio TIMESTAMP NOT NULL,
    ID_Luce INT NOT NULL,
    Intensita DOUBLE,
    Temperatura DOUBLE,
    IstanteFine TIMESTAMP,
    ID_Utente INT NOT NULL,
    PRIMARY KEY(IstanteInizio, ID_Luce),
    FOREIGN KEY(IstanteInizio) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(IstanteFine) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Luce) REFERENCES Luce(ID_Luce)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RegistroAccessi;
CREATE TABLE RegistroAccessi (
	ID_Utente INT NOT NULL,
	IstanteInizio TIMESTAMP NOT NULL,
    IstanteFine TIMESTAMP,
	Entrata INT NOT NULL,
    Uscita INT,
    Permanenza DOUBLE,
    CHECK(Permanenza > 0),
    PRIMARY KEY(ID_Utente, IstanteInizio),
    FOREIGN KEY(IstanteInizio) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(IstanteFine) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Entrata) REFERENCES PuntoDiAccesso(ID_PuntoDiAccesso)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Uscita) REFERENCES PuntoDiAccesso(ID_PuntoDiAccesso)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RegistroIntrusioni;
CREATE TABLE RegistroIntrusioni (
	ID_Intrusione INT AUTO_INCREMENT,
    IstanteInizio TIMESTAMP NOT NULL,
    IstanteFine TIMESTAMP,
	Infiltrazione INT NOT NULL,
    Fuga INT,
    PercorsoFotografia VARCHAR(300),
    Permanenza DOUBLE,
    CHECK(Permanenza > 0),
    PRIMARY KEY(ID_Intrusione),
    FOREIGN KEY(IstanteInizio) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(IstanteFine) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Infiltrazione) REFERENCES PuntoDiAccesso(ID_PuntoDiAccesso)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Fuga) REFERENCES PuntoDiAccesso(ID_PuntoDiAccesso)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS Serramento;
CREATE TABLE Serramento (
	ID_Serramento INT AUTO_INCREMENT,
    Nome VARCHAR(60) NOT NULL,
    Aperto TINYINT(1) NOT NULL,
    ID_PuntoDiAccesso INT NOT NULL,
    PRIMARY KEY(ID_Serramento),
    FOREIGN KEY(ID_PuntoDiAccesso) REFERENCES PuntoDiAccesso(ID_PuntoDiAccesso)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

DROP TABLE IF EXISTS RegistroSerramenti;
CREATE TABLE RegistroSerramenti (
	ID_Serramento INT AUTO_INCREMENT,
    Istante TIMESTAMP NOT NULL,
    StatoIstantaneo TINYINT(1) NOT NULL,
    ID_Utente INT NOT NULL,
    PRIMARY KEY(ID_Serramento, Istante),
    FOREIGN KEY(ID_Serramento) REFERENCES Serramento(ID_Serramento)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Istante) REFERENCES Timestamp(Istante)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(ID_Utente) REFERENCES Utente(ID_Utente)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- Questa è una tabella riferita alla Prima Analytics
DROP TABLE IF EXISTS RangeTemperatura;
CREATE TABLE IF NOT EXISTS RangeTemperatura (
	ID_Colore VARCHAR(6) NOT NULL,
	TemperaturaMinima INT NOT NULL,
	TemperaturaMassima INT,
	ColoreEsadecimale CHAR(6),
	PRIMARY KEY(ID_Colore)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- Sempre una tabella per la Prima Analytics
DROP TABLE IF EXISTS ColoriFrequenti;
CREATE TABLE ColoriFrequenti (
	Combinazione INT NOT NULL AUTO_INCREMENT,
	Colore VARCHAR(3) NOT NULL,
	Data DATE NOT NULL DEFAULT (CURRENT_DATE),
	PRIMARY KEY (Combinazione, Data, Colore)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;
