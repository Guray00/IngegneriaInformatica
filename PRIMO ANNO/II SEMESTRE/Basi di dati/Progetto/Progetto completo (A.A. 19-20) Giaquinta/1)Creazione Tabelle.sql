SET @timer = CURRENT_TIME();
SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS Azienda;
CREATE DATABASE Azienda;
USE Azienda;


DROP TABLE IF EXISTS Prodotto;
CREATE TABLE Prodotto (
	CodProdotto INT AUTO_INCREMENT PRIMARY KEY,
    Marca VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL, 
    Modello VARCHAR(50) NOT NULL, 
    DataProduzione DATE NOT NULL, 
    NumFacce INT, 
    SogliaRic INT NOT NULL, 
    PrimoTest INT NOT NULL,
    FOREIGN KEY (PrimoTest) REFERENCES Test(CodTest)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Variante;
CREATE TABLE Variante (
	CodVariante VARCHAR(50) PRIMARY KEY, 
    Prezzo FLOAT, 
    Prodotto INT NOT NULL,
    FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodProdotto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Unita;
CREATE TABLE Unita (
	CodSeriale INT AUTO_INCREMENT PRIMARY KEY,
    Variante VARCHAR(50) NOT NULL, 
    Garanzia INT,
    Lotto INT NOT NULL,
    Acquisto INT,
    FOREIGN KEY (Variante) REFERENCES Variante(CodVariante),
    FOREIGN KEY (Garanzia) REFERENCES Garanzia(IDformula),
    FOREIGN KEY (Lotto) REFERENCES Lotto(CodiceLotto),
    FOREIGN KEY (Acquisto) REFERENCES Ordine(CodOrdine)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Parte;
CREATE TABLE Parte (
	CodiceParte INT AUTO_INCREMENT PRIMARY KEY, 
    NomeParte VARCHAR(50) NOT NULL, 
    PrezzoParte VARCHAR(50), 
    Peso VARCHAR(50) NOT NULL, 
    Prodotto INT NOT NULL,
    FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodProdotto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Costituzione;
CREATE TABLE Costituzione (
	CodiceParte INT, 
    NomeMateriale VARCHAR(50), 
    Quantita INT NOT NULL,
    PRIMARY KEY (CodiceParte, NomeMateriale),
    FOREIGN KEY (CodiceParte) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (NomeMateriale) REFERENCES Materiale(NomeMateriale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Materiale;
CREATE TABLE Materiale (
	NomeMateriale VARCHAR(50) PRIMARY KEY, 
    TassoSvalutazione INT, 
    Valore INT NOT NULL
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Fissaggio;
CREATE TABLE Fissaggio (
	PrimaParte INT, 
    SecondaParte INT, 
    Giunzione VARCHAR (50),
    PRIMARY KEY (PrimaParte, SecondaParte, Giunzione),
    FOREIGN KEY (PrimaParte) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (SecondaParte) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (Giunzione) REFERENCES Giunzione(Tipo)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Giunzione;
CREATE TABLE Giunzione (
	Tipo VARCHAR(50) PRIMARY KEY
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



DROP TABLE IF EXISTS InfoGiunzione;
CREATE TABLE InfoGiunzione (
	Giunzione VARCHAR(50), 
    Caratteristica VARCHAR(50), 
    Valore INT NOT NULL,
    PRIMARY KEY (Giunzione, Caratteristica, Valore),
	FOREIGN KEY (Giunzione) REFERENCES Giunzione(Tipo),
    FOREIGN KEY (Caratteristica) REFERENCES Caratteristica(NomeCaratteristica)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Caratteristica;
CREATE TABLE Caratteristica (
	NomeCaratteristica VARCHAR(50) PRIMARY KEY, 
    UnitaDiMisura VARCHAR(50)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Operazione;
CREATE TABLE Operazione (
	IDoperazione INT AUTO_INCREMENT PRIMARY KEY, 
    NomeOperazione VARCHAR(50), 
    Faccia INT, 
    TempoMedio INT NOT NULL, 
    Varianza INT, 
    Parte INT NOT NULL,
    FOREIGN KEY (Parte) REFERENCES Parte(CodiceParte)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Vincoli;
CREATE TABLE Vincoli (
	Precedente INT,
    Successiva INT,
    PRIMARY KEY (Precedente, Successiva),
    FOREIGN KEY (Precedente) REFERENCES Operazione(IDoperazione),
	FOREIGN KEY (Successiva) REFERENCES Operazione(IDoperazione)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Utilizzo;
CREATE TABLE Utilizzo (
	Operazione INT, 
    Giunzione VARCHAR(50),
    PRIMARY KEY (Operazione, Giunzione),
    FOREIGN KEY (Operazione) REFERENCES Operazione(IDoperazione),
	FOREIGN KEY (Giunzione) REFERENCES Giunzione(Tipo)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS StrumentiOp;
CREATE TABLE StrumentiOp (
	Utensile VARCHAR(50), 
    Operazione INT,
    PRIMARY KEY (Utensile, Operazione),
    FOREIGN KEY (Operazione) REFERENCES Operazione(IDoperazione),
    FOREIGN KEY (Utensile) REFERENCES Utensile(NomeUtensile)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Utensile;
CREATE TABLE Utensile (
	NomeUtensile VARCHAR(50) PRIMARY KEY
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Esecuzione;
CREATE TABLE Esecuzione (
	Stazione INT, 
    Operazione INT, 
    Ordine INT NOT NULL,
    PRIMARY KEY (Stazione, Operazione),
    FOREIGN KEY (Operazione) REFERENCES Operazione(IDoperazione),
    FOREIGN KEY (Stazione) REFERENCES Stazione(CodStazione)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Stazione;
CREATE TABLE Stazione (
	CodStazione INT AUTO_INCREMENT PRIMARY KEY, 
    Operatore INT NOT NULL, 
    Sequenza INT NOT NULL,
    FOREIGN KEY (Operatore) REFERENCES Operatore(IDoperatore),
    FOREIGN KEY (Sequenza) REFERENCES Sequenza(IDsequenza)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Operatore;
CREATE TABLE Operatore (
	IDoperatore INT AUTO_INCREMENT PRIMARY KEY
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Sequenza;
CREATE TABLE Sequenza (
	IDsequenza INT AUTO_INCREMENT PRIMARY KEY, 
    TempoT INT NOT NULL
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Lotto;
CREATE TABLE Lotto (
	CodiceLotto INT AUTO_INCREMENT PRIMARY KEY, 
    Tipo VARCHAR(50) NOT NULL, 
    SedeProduzione VARCHAR(50) NOT NULL, 
    DataProduzione DATE NOT NULL, 
    DurataPreventiva INT, 
    DurataEffettiva INT,      
    Prodotto INT NOT NULL,
	Categoria VARCHAR(1) CHECK (Categoria IN ('A','B','C','D')), 
    Sequenza INT NOT NULL, 
    Magazzino INT NOT NULL, 
    Settore VARCHAR(50), 
    DataStock DATE, 
    DataRilascio DATE,
    Quantita INT NOT NULL DEFAULT 0,
    FOREIGN KEY (Sequenza) REFERENCES Sequenza(IDsequenza),
    FOREIGN KEY (Magazzino) REFERENCES Magazzino(CodMagazzino),
    FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodProdotto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Perdite;
CREATE TABLE Perdite (
	Lotto INT, 
    Operazione INT, 
    Stazione INT, 
    Numero INT NOT NULL,
	PRIMARY KEY (Lotto, Operazione, Stazione),
    FOREIGN KEY (Lotto) REFERENCES Lotto(CodiceLotto),
    FOREIGN KEY (Operazione) REFERENCES Operazione(IDoperazione),
    FOREIGN KEY (Stazione) REFERENCES Stazione(CodStazione)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Magazzino;
CREATE TABLE Magazzino (
	CodMagazzino INT AUTO_INCREMENT PRIMARY KEY, 
    Capienza INT NOT NULL, 
    Predisposizione VARCHAR(50) NOT NULL
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Account;
CREATE TABLE Account (
	NumCliente INT AUTO_INCREMENT PRIMARY KEY, 
    NomeUtente VARCHAR (50) NOT NULL, 
    Password VARCHAR(50) NOT NULL, 
    DomandaSicurezza VARCHAR(100) NOT NULL, 
    Risposta VARCHAR(50) NOT NULL, 
    Timestamp TIMESTAMP, 	
    CodFiscale VARCHAR(50) NOT NULL,
    FOREIGN KEY (CodFiscale) REFERENCES Utente(CodFiscale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Utente;
CREATE TABLE Utente (
	CodFiscale VARCHAR(50) PRIMARY KEY, 
    Nome VARCHAR(50) NOT NULL, 
    Cognome VARCHAR(50) NOT NULL, 
    Telefono BIGINT(8),
    Cap INT, 
    Via VARCHAR(50), 
    Numero INT,
    Documento INT NOT NULL,
    FOREIGN KEY (Documento) REFERENCES Documento(NumDocumento)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Documento;
CREATE TABLE Documento (
	NumDocumento INT PRIMARY KEY, 
    Tipologia VARCHAR(50) NOT NULL, 
    DataScadenza DATE NOT NULL, 
    EnteRilascio VARCHAR(50) NOT NULL
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Ordine;
CREATE TABLE Ordine (
	CodOrdine INT AUTO_INCREMENT PRIMARY KEY, 
    Timestamp TIMESTAMP, 
    Stato VARCHAR(50) NOT NULL CHECK (Stato IN ('In Processazione', 'In Preparazione', 'Spedito', 'Evaso')), 
    Spesa FLOAT,
    CAP INT NOT NULL,
    Via VARCHAR(50) NOT NULL,  
	Numero INT NOT NULL, 
    Cliente INT NOT NULL,
    FOREIGN KEY (Cliente) REFERENCES Account(NumCliente)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Spedizione;
CREATE TABLE Spedizione (
	IDspedizione INT AUTO_INCREMENT PRIMARY KEY, 
    Stato VARCHAR(50) NOT NULL, 
    DataPrevista DATE NOT NULL, 
    Hub INT, 
    DataUpdate DATE NOT NULL, 
    Ordine INT NOT NULL,
    FOREIGN KEY (Ordine) REFERENCES Ordine(CodOrdine)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Recensione;
CREATE TABLE Recensione (
	IDreview INT AUTO_INCREMENT PRIMARY KEY, 
    Servizio INT CHECK (Servizio>=1 and Servizio<=5), 
    Qualita INT CHECK (Qualita>=1 and Qualita<=5), 
    Prezzo INT CHECK (Prezzo>=1 and Prezzo<=5), 
    Commento VARCHAR(300),
    Cliente INT NOT NULL, 
    Unita INT NOT NULL,
    FOREIGN KEY (Cliente) REFERENCES Account(NumCliente),
	FOREIGN KEY (Unita) REFERENCES Unita(CodSeriale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Garanzia;
CREATE TABLE Garanzia (
	IDformula INT AUTO_INCREMENT PRIMARY KEY, 
    Costo FLOAT, 
    Periodo VARCHAR(50) NOT NULL
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Formula;
CREATE TABLE Formula (
	Prodotto INT, 
    Garanzia INT,
    PRIMARY KEY (Prodotto, Garanzia),
    FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodProdotto),
    FOREIGN KEY (Garanzia) REFERENCES Garanzia(IDformula)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Validita;
CREATE TABLE Validita (
	Garanzia INT,
    Guasto INT,
    PRIMARY KEY (Garanzia, Guasto),
    FOREIGN KEY (Garanzia) REFERENCES Garanzia(IDformula),
    FOREIGN KEY (Guasto) REFERENCES Guasto(CodGuasto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Reso;
CREATE TABLE Reso (
	CodReso INT AUTO_INCREMENT PRIMARY KEY, 
    Motivo INT NOT NULL, 
    DataRichiesta TIMESTAMP, 
    Unita INT NOT NULL,
    FOREIGN KEY (Unita) REFERENCES Unita(CodSeriale),
    FOREIGN KEY (Motivo) REFERENCES Motivazione(CodMotivo)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Motivazione;
CREATE TABLE Motivazione (
	CodMotivo INT AUTO_INCREMENT PRIMARY KEY,
    Motivo VARCHAR(50) NOT NULL,
    Descrizione VARCHAR(300)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Guasto;
CREATE TABLE Guasto (
	CodGuasto INT AUTO_INCREMENT PRIMARY KEY, 
    Nome VARCHAR(50) NOT NULL, 
    Descrizione VARCHAR(300), 
    Prodotto INT NOT NULL, 
    PrimaDomanda VARCHAR(300) NOT NULL,
    FOREIGN KEY (PrimaDomanda) REFERENCES Domanda(Richiesta)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Errore;
CREATE TABLE Errore (
	CodErrore INT AUTO_INCREMENT PRIMARY KEY,
    Guasto INT NOT NULL,
    FOREIGN KEY (Guasto) REFERENCES Guasto(CodGuasto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Rimedio;
CREATE TABLE Rimedio (
	CodRimedio INT AUTO_INCREMENT PRIMARY KEY,
    Descrizione VARCHAR(300),
    Errore INT NOT NULL,
    FOREIGN KEY (Errore) REFERENCES Errore(CodErrore)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Domanda;
CREATE TABLE Domanda (
	Richiesta VARCHAR(300) PRIMARY KEY, 
    DomandaPrecedente VARCHAR(300), 
    RispostaPrecedente VARCHAR(2) CHECK (RispostaPrecedente IN ('Sì', 'No')), 
    Rimedio INT,
    FOREIGN KEY (DomandaPrecedente) REFERENCES Domanda(Richiesta),
    FOREIGN KEY (Rimedio) REFERENCES Rimedio(CodRimedio)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Diagnosi;
CREATE TABLE Diagnosi (
	CodAssistenza INT,
    Guasto INT,
    PRIMARY KEY (CodAssistenza, Guasto),
    FOREIGN KEY (CodAssistenza) REFERENCES AssistenzaFisica(Codice),
    FOREIGN KEY (Guasto) REFERENCES Guasto(CodGuasto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS AssistenzaFisica;
CREATE TABLE AssistenzaFisica (
	Codice INT AUTO_INCREMENT PRIMARY KEY, 
    Preventivo FLOAT, 
    Accettato VARCHAR(3), 
    Unita INT NOT NULL,
    FOREIGN KEY (Unita) REFERENCES Unita(CodSeriale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Intervento;
CREATE TABLE Intervento (
	Ticket INT AUTO_INCREMENT PRIMARY KEY, 
    DataIntervento DATE NOT NULL, 
    Tipo VARCHAR(50) NOT NULL, 
    CAP INT, 
    Via VARCHAR(50),
    Numero INT,
    Tecnico INT NOT NULL, 
    CodAssistenza INT NOT NULL,
    FOREIGN KEY (CodAssistenza) REFERENCES AssistenzaFisica(Codice),
    FOREIGN KEY (Tecnico) REFERENCES Tecnico(Matricola)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Tecnico;
CREATE TABLE Tecnico (
	Matricola INT AUTO_INCREMENT PRIMARY KEY,
    CAPsede INT NOT NULL,
    FOREIGN KEY (CAPsede) REFERENCES Sede(Cap)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Sede;
CREATE TABLE Sede (
	Cap INT PRIMARY KEY
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Disponibilita;
CREATE TABLE Disponibilita (
	Tecnico INT,
    Giorno VARCHAR(10),
    Fascia VARCHAR(10),
    PRIMARY KEY (Tecnico, Giorno, Fascia),
    FOREIGN KEY (Tecnico) REFERENCES Tecnico(Matricola),
    FOREIGN KEY (Giorno, Fascia) REFERENCES Orario(Giorno, Fascia)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Orario;
CREATE TABLE Orario (
	Giorno VARCHAR(10),
    Fascia VARCHAR(10),
    PRIMARY KEY (Giorno, Fascia)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS OrdineParti;
CREATE TABLE OrdineParti (
	CodRicambio INT AUTO_INCREMENT PRIMARY KEY, 
    DataOrdine DATE NOT NULL, 
    StimaConseg DATE, 
    DataConseg DATE, 
    CodAssistenza INT NOT NULL,
	FOREIGN KEY (CodAssistenza) REFERENCES AssistenzaFisica(Codice)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Lista;
CREATE TABLE Lista (
	Parte INT,
    CodRicambio INT,
    PRIMARY KEY (Parte, CodRicambio),
    FOREIGN KEY (Parte) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (CodRicambio) REFERENCES OrdineParti(CodRicambio)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Ricevuta;
CREATE TABLE Ricevuta (
	Codice INT AUTO_INCREMENT PRIMARY KEY, 
    Prezzo INT NOT NULL, 
    Metodo VARCHAR(50) NOT NULL, 
    CodAssistenza INT NOT NULL,
	FOREIGN KEY (CodAssistenza) REFERENCES AssistenzaFisica(Codice)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Test;
CREATE TABLE Test (
	CodTest INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Politica VARCHAR(300),
    Padre INT,
    FOREIGN KEY (Padre) REFERENCES Test(CodTest)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Funzionamento;
CREATE TABLE Funzionamento (
	Test INT,
    Parte INT,
    PRIMARY KEY (Test, Parte),
    FOREIGN KEY (Test) REFERENCES Test(CodTest),
    FOREIGN KEY (Parte) REFERENCES Parte(CodiceParte)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Esito;
CREATE TABLE Esito (
	Unita INT, 
    Test INT, 
    Fallito BOOL check (Fallito=0 or Fallito=1),
    PRIMARY KEY (Unita, Test),
	FOREIGN KEY (Test) REFERENCES Test(CodTest),
    FOREIGN KEY (Unita) REFERENCES Unita(CodSeriale)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Conservato;
CREATE TABLE Conservato (
	Magazzino INT,
    Reso INT,
	PRIMARY KEY (Magazzino, Reso),
    FOREIGN KEY (Magazzino) REFERENCES Magazzino(CodMagazzino),
    FOREIGN KEY (Reso) REFERENCES Reso(CodReso)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;



SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VINCOLI GENERICI AGGIUNTIVI
-- CONTROLLO CHE LA PASSWORD SIA LUNGA ALMENO 8 CARATTERI:

DROP TRIGGER IF EXISTS LunghezzaPassword;
DELIMITER $$
CREATE TRIGGER LunghezzaPassword
BEFORE INSERT ON Account
FOR EACH ROW
BEGIN
	IF
		(CHAR_LENGTH(NEW.Password) < 8)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La Password deve contenere almeno 8 caratteri';
    END IF;
END $$
DELIMITER ;


-- CONTROLLO CHE GLI ORDINI SEGUANO LA SEQUENZA in Processazione, Preparazione, Spedito, Evaso:

DROP TRIGGER IF EXISTS ControllaStatoOrdine;
DELIMITER $$
CREATE TRIGGER ControllaStatoOrdine
BEFORE UPDATE ON Ordine
FOR EACH ROW
BEGIN
    IF    
        ((OLD.Stato = 'In Processazione' AND NEW.Stato <> 'In Preparazione')
        OR (OLD.Stato = 'In Preparazione' AND NEW.Stato <> 'Spedito')
        OR (OLD.Stato = 'Spedito' AND NEW.Stato <> 'Evaso')
        OR (OLD.Stato = 'Evaso'))
        AND (OLD.Stato<>NEW.Stato)
	THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire, gli stati di un ordine devono seguire questo ordine: Processazione, Preparazione, Spedito, Evaso';
    END IF;
END $$
DELIMITER ;


-- CONTROLLO CHE UN CLIENTE NON POSSA RECENSIRE UNA STESSA VARIANTE DI PRODOTTO PIÙ VOLTE INDIPENDENTEMENTE DA QUANTE UNITÀ DELLA DATA VARIANTE HA ACQUISTATO:

DROP TRIGGER IF EXISTS ControlloRecensioni;
DELIMITER $$
CREATE TRIGGER ControllaRecensioni
BEFORE INSERT ON Recensione
FOR EACH ROW
BEGIN
	IF EXISTS	
		(SELECT 1
		FROM Recensione R INNER JOIN Unita U ON R.Unita=U.CodSeriale
		WHERE R.Cliente=NEW.Cliente
		AND U.Variante = 	(SELECT U1.Variante
							FROM Unita U1 INNER JOIN Recensione R1 ON R1.Unita=U1.CodSeriale
							WHERE U1.CodSeriale=NEW.Unita))
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Questo articolo è stato già recensito';
    END IF;
END $$
DELIMITER ;


-- CONTROLLO CHE UN ORDINE APPENA AGGIUNTO ABBIA LO STATO In Processazione ALTRIMENTI RESTITUISCO UN ERRORE

/*DROP TRIGGER IF EXISTS ControlloNuovoOrdine;
DELIMITER $$
CREATE TRIGGER ControlloNuovoOrdine
BEFORE INSERT ON Ordine
FOR EACH ROW
BEGIN
	IF 
		(NEW.Stato<>'In Processazione')
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile aggiungere il nuovo Ordine, lo stato iniziale non ammissibile';
    END IF;
END $$
DELIMITER ;*/


SELECT TIMEDIFF(CURRENT_TIME(),@timer) as 'Tempo impiegato';