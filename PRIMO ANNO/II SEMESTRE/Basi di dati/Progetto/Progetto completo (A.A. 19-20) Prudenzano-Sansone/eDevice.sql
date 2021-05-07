BEGIN;
DROP DATABASE IF EXISTS `eDevice`;
CREATE DATABASE `eDevice`; 
COMMIT;
USE `eDevice`;

-- --------------------
--     Prodotto      --
-- --------------------
DROP TABLE IF EXISTS Prodotto;
CREATE TABLE Prodotto
(
    IDProdotto      INT NOT NULL AUTO_INCREMENT,
    Nome            VARCHAR(100) NOT NULL,
    Marca           VARCHAR(100) NOT NULL,
    Modello         VARCHAR(100) NOT NULL,
    DataProduzione  DATE NOT NULL,
    Prezzo          INT NOT NULL
					CHECK(Prezzo>=0),
    Predisposizione VARCHAR(20) NOT NULL
					CHECK(Predisposizione IN ('Piccolo','Medio','Grande')),
    SdR             INT NOT NULL,
    PRIMARY KEY(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------
--     Variante      --
-- --------------------
DROP TABLE IF EXISTS Variante;
CREATE TABLE Variante
(
    IDVariante      INT NOT NULL AUTO_INCREMENT,
    Prezzo          INT NOT NULL
					CHECK( Prezzo>=0 ),
    Descrizione     TEXT NOT NULL,
    IDProdotto      INT NOT NULL,
    PRIMARY KEY(IDVariante),

    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--    VarianteDiProdotto     --
-- ----------------------------
DROP TABLE IF EXISTS VarianteDiProdotto;
CREATE TABLE VarianteDiProdotto
(
    CodiceSeriale   INT NOT NULL AUTO_INCREMENT,
    Ricondizionato  TINYINT(1) NOT NULL,
    IDProdotto      INT NOT NULL,
    PRIMARY KEY(CodiceSeriale),

    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------
--    Modello     --
-- -----------------
DROP TABLE IF EXISTS Modello;
CREATE TABLE Modello
(
    IDVariante     INT NOT NULL,
    CodiceSeriale  INT NOT NULL,
    PRIMARY KEY(IDVariante, CodiceSeriale),

    FOREIGN KEY (CodiceSeriale) REFERENCES VarianteDiProdotto(CodiceSeriale),
    FOREIGN KEY (IDVariante) REFERENCES Variante(IDVariante)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------
--    Parte     --
-- ---------------
DROP TABLE IF EXISTS Parte;
CREATE TABLE Parte
(
    CodiceParte    INT NOT NULL AUTO_INCREMENT,
    Nome           VARCHAR(100) NOT NULL,
    Prezzo         INT DEFAULT NULL
				   CHECK( Prezzo>=0 OR Prezzo IS NULL ),
    Peso           DOUBLE DEFAULT NULL
				   CHECK( Peso>=0 OR Peso IS NULL),
    CdS            DOUBLE DEFAULT NULL,
    Intermedio     TINYINT(1) NOT NULL,
    IDProdotto     INT NOT NULL,
    PRIMARY KEY(CodiceParte),
    
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------
--   Materiale    --
-- -----------------
DROP TABLE IF EXISTS Materiale;
CREATE TABLE Materiale
(
    IDMateriale    INT NOT NULL AUTO_INCREMENT,
    Nome           VARCHAR(100) NOT NULL,
    VKG            DOUBLE NOT NULL
				   CHECK( VKG>=0 ),
    PRIMARY KEY(IDMateriale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------
--   Composizione    --
-- --------------------
DROP TABLE IF EXISTS Composizione;
CREATE TABLE Composizione
(
    CodiceParte    INT NOT NULL,
    IDMateriale    INT NOT NULL,
    Quantita       DOUBLE NOT NULL
				   CHECK( Quantita>=0 ),
    PRIMARY KEY(CodiceParte,IDMateriale),
    
    FOREIGN KEY (CodiceParte) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (IDMateriale) REFERENCES Materiale(IDMateriale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------
--   Faccia    --
-- --------------
DROP TABLE IF EXISTS Faccia;
CREATE TABLE Faccia
(
    IDFaccia      INT NOT NULL AUTO_INCREMENT,
    IDProdotto    INT NOT NULL,
    PRIMARY KEY(IDFaccia),
    
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------
--   Giunzione    --
-- -----------------
DROP TABLE IF EXISTS Giunzione;
CREATE TABLE Giunzione
(
    IDGiunzione    INT NOT NULL,
    Nome           VARCHAR(100) NOT NULL,
    PRIMARY KEY(IDGiunzione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------
--   Caratteristica    --
-- ----------------------
DROP TABLE IF EXISTS Caratteristica;
CREATE TABLE Caratteristica
(
    IDCaratteristica    INT NOT NULL AUTO_INCREMENT,
    Descrizione         TEXT DEFAULT NULL,
    UDM                 VARCHAR(10) NOT NULL,
    Valore              DOUBLE NOT NULL				   
						CHECK( Valore>=0 ),
    IDGiunzione         INT NOT NULL,
    PRIMARY KEY(IDCaratteristica),

    FOREIGN KEY (IDGiunzione) REFERENCES Giunzione(IDGiunzione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Utensile    --
-- ------------------
DROP TABLE IF EXISTS Utensile;
CREATE TABLE Utensile
(
    IDUtensile    INT NOT NULL,
    Nome          VARCHAR(100) NOT NULL,
    PRIMARY KEY(IDUtensile)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------
--    Operazione    --
-- -------------------
DROP TABLE IF EXISTS Operazione;
CREATE TABLE Operazione
(
    IDOperazione    INT NOT NULL AUTO_INCREMENT,
    Nome            VARCHAR(100) NOT NULL,
    Priorita        INT NOT NULL,
    ParteA          INT NOT NULL,
    ParteB          INT NOT NULL,
    IDGiunzione     INT NOT NULL,
    IDFaccia        INT NOT NULL,
    
    PRIMARY KEY(IDOperazione),

    FOREIGN KEY (ParteA) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (ParteB) REFERENCES Parte(CodiceParte),
    FOREIGN KEY (IDGiunzione) REFERENCES Giunzione(IDGiunzione),
    FOREIGN KEY (IDFaccia) REFERENCES Faccia(IDFaccia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------
--   Uso    --
-- -----------
DROP TABLE IF EXISTS Uso;
CREATE TABLE Uso
(
    IDOperazione      INT NOT NULL,
    IDUtensile        INT NOT NULL,
    PRIMARY KEY(IDOperazione,IDUtensile),

    FOREIGN KEY (IDOperazione) REFERENCES Operazione(IDOperazione),
    FOREIGN KEY (IDUtensile) REFERENCES Utensile(IDUtensile)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------------------
--    SequenzaDiOperazioni    --
-- -----------------------------
DROP TABLE IF EXISTS SequenzaDiOperazioni;
CREATE TABLE SequenzaDiOperazioni
(
    IDSequenza      INT NOT NULL AUTO_INCREMENT,
    Indicatore      VARCHAR(100) NOT NULL,
    TempoStazione   INT NOT NULL
					CHECK( TempoStazione>=0 ),
    IDProdotto      INT NOT NULL,
    PRIMARY KEY(IDSequenza),
    
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------
--    Operatore     --
-- -------------------
DROP TABLE IF EXISTS Operatore;
CREATE TABLE Operatore
(
    Badge        INT NOT NULL AUTO_INCREMENT,
    Nome         VARCHAR(100) NOT NULL,
    Cognome      VARCHAR(100) NOT NULL,
    PRIMARY KEY(Badge)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Stazione     --
-- ------------------
DROP TABLE IF EXISTS Stazione;
CREATE TABLE Stazione
(
    IDStazione     INT NOT NULL AUTO_INCREMENT,
    Precedenza     INT NOT NULL,
    Operatore      INT NOT NULL,
    IDSequenza     INT NOT NULL,
    PRIMARY KEY(IDStazione),

    FOREIGN KEY (Operatore) REFERENCES Operatore(Badge),
    FOREIGN KEY (IDSequenza) REFERENCES SequenzaDiOperazioni(IDSequenza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------
--    Fase     --
-- --------------
DROP TABLE IF EXISTS Fase;
CREATE TABLE Fase
(
    IDStazione     INT NOT NULL,
    IDOperazione   INT NOT NULL,
    PRIMARY KEY(IDStazione, IDOperazione),

    FOREIGN KEY (IDStazione) REFERENCES Stazione(IDStazione),
    FOREIGN KEY (IDOperazione) REFERENCES Operazione(IDOperazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--    OperazioneCampione     --
-- ----------------------------
DROP TABLE IF EXISTS OperazioneCampione;
CREATE TABLE OperazioneCampione
(
    Nome         VARCHAR(100) NOT NULL,
    PRIMARY KEY(Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Capacita     --
-- ------------------
DROP TABLE IF EXISTS Capacita;
CREATE TABLE Capacita
(
    Badge        INT NOT NULL,
    Operazione   VARCHAR(100) NOT NULL,
    TempoMedio   DOUBLE NOT NULL
				 CHECK( TempoMedio>=0 ),
    Varianza     DOUBLE NOT NULL,
    PRIMARY KEY(Badge,Operazione),

    FOREIGN KEY (Badge) REFERENCES Operatore(Badge),
    FOREIGN KEY (Operazione) REFERENCES OperazioneCampione(Nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------
--    Lotto     --
-- ---------------
DROP TABLE IF EXISTS Lotto;
CREATE TABLE Lotto
(
    CodiceLotto         INT NOT NULL AUTO_INCREMENT,
    DataPrevista        DATE NOT NULL,
    DataEffettiva       DATE DEFAULT NULL,
    SedeProduzione      VARCHAR(100) NOT NULL,
    Quantita            INT NOT NULL
    				    CHECK( Quantita>0 ),
    Rimanente           INT DEFAULT NULL,
    CodiceSeriale       INT NOT NULL,
    IDSequenza          INT DEFAULT NULL,
    PRIMARY KEY(CodiceLotto),
    
    FOREIGN KEY (CodiceSeriale) REFERENCES VarianteDiProdotto(CodiceSeriale),
    FOREIGN KEY (IDSequenza) REFERENCES SequenzaDiOperazioni(IDSequenza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------
--    UnitaPerse     --
-- --------------------
DROP TABLE IF EXISTS UnitaPerse;
CREATE TABLE UnitaPerse
(
    IDStazione         INT NOT NULL,
    CodiceLotto        INT NOT NULL,
    Quantita           INT NOT NULL
    				   CHECK( Quantita>=0 ),

    PRIMARY KEY(IDStazione,CodiceLotto),
        
    FOREIGN KEY (IDStazione) REFERENCES Stazione(IDStazione),
    FOREIGN KEY (CodiceLotto) REFERENCES Lotto(CodiceLotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------
--    Magazzino      --
-- --------------------
DROP TABLE IF EXISTS Magazzino;
CREATE TABLE Magazzino
(
    CodiceMagazzino       INT NOT NULL AUTO_INCREMENT,
    Capienza              INT NOT NULL,
    Predisposizione       VARCHAR(100) NOT NULL
    					  CHECK(Predisposizione IN ('Piccolo','Medio','Grande')),

    PRIMARY KEY(CodiceMagazzino)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ---------------------
--    Ubicazione      --
-- ---------------------
DROP TABLE IF EXISTS Ubicazione;
CREATE TABLE Ubicazione
(
    IDUbicazione            INT NOT NULL AUTO_INCREMENT,
    Piano                   INT NOT NULL,
    Stanza                  INT NOT NULL,
    Scaffale                INT NOT NULL,
    CodiceMagazzino         INT NOT NULL,

    PRIMARY KEY(IDUbicazione),

    FOREIGN KEY (CodiceMagazzino) REFERENCES Magazzino(CodiceMagazzino)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ---------------------------
--    StoccaggioAttuale     --
-- ---------------------------
DROP TABLE IF EXISTS StoccaggioAttuale;
CREATE TABLE StoccaggioAttuale
(
    CodiceLotto      INT NOT NULL,
    IDUbicazione     INT NOT NULL,
    DataInizio       DATE NOT NULL,
    PRIMARY KEY(CodiceLotto,IDUbicazione),
    
    FOREIGN KEY (CodiceLotto) REFERENCES Lotto(CodiceLotto),
    FOREIGN KEY (IDUbicazione) REFERENCES Ubicazione(IDUbicazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------------------
--    StoccaggioStorico     --
-- ---------------------------
DROP TABLE IF EXISTS StoccaggioStorico;
CREATE TABLE StoccaggioStorico
(
    CodiceLotto      INT NOT NULL,
    IDUbicazione     INT NOT NULL,
    DataInizio       DATE NOT NULL,
    DataFine         DATE NOT NULL,

    PRIMARY KEY(CodiceLotto,IDUbicazione),
    
    FOREIGN KEY (CodiceLotto) REFERENCES Lotto(CodiceLotto),
    FOREIGN KEY (IDUbicazione) REFERENCES Ubicazione(IDUbicazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------------
--    FormulaGaranzia    --
-- ------------------------
DROP TABLE IF EXISTS FormulaGaranzia;
CREATE TABLE FormulaGaranzia
(
    CodiceGaranzia  INT NOT NULL AUTO_INCREMENT,
    Periodo         INT NOT NULL,
    Costo           DECIMAL(7, 2) NOT NULL,
    TIPO            TINYINT(1) NOT NULL,    -- 0 per temporale | 1 per classe di guasto

    PRIMARY KEY(CodiceGaranzia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
      

-- --------------------
--    Applicabile    --
-- --------------------
DROP TABLE IF EXISTS Applicabile;
CREATE TABLE Applicabile
(
    CodiceGaranzia  INT NOT NULL,
    IDProdotto      INT NOT NULL,

    PRIMARY KEY (CodiceGaranzia, IDProdotto),

    FOREIGN KEY (CodiceGaranzia) REFERENCES FormulaGaranzia(CodiceGaranzia),
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------------
--    DomandaSicurezza    --
-- -------------------------
DROP TABLE IF EXISTS DomandaSicurezza;
CREATE TABLE DomandaSicurezza
(
    CodiceDomanda   INT NOT NULL AUTO_INCREMENT,
    Testo           VARCHAR(100) NOT NULL,

    PRIMARY KEY(CodiceDomanda)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------
--    Utente    --
-- ---------------
DROP TABLE IF EXISTS Utente;
CREATE TABLE Utente
(
    CodiceFiscale       VARCHAR(16) NOT NULL,
    Nome                VARCHAR(20) NOT NULL,
    Cognome             VARCHAR(20) NOT NULL,
    Telefono            VARCHAR(10) NOT NULL,
    Indirizzo           VARCHAR(100) NOT NULL,
    NumeroDocumento     VARCHAR(10) NOT NULL,
    TipoDocumento       VARCHAR(50) NOT NULL,
    ScadenzaDocumento   DATE NOT NULL,
    EnteDocumento       VARCHAR(50) NOT NULL,

    PRIMARY KEY(CodiceFiscale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------
--    Account    --
-- ----------------
DROP TABLE IF EXISTS Account;
CREATE TABLE Account
(
    Username    	VARCHAR(20) NOT NULL,
    Email       	VARCHAR(255) NOT NULL,
    DataIscrizione 	DATE NOT NULL,
    Credito     	DECIMAL(7, 2) NOT NULL,
    Salt        	CHAR(5) NOT NULL,
    Hash        	CHAR(32) NOT NULL,
    CodiceFiscale 	CHAR(16) NOT NULL,
    CodiceDomanda	INT NOT NULL,
    Risposta    	VARCHAR(200) NOT NULL,

    PRIMARY KEY(Username),
    FOREIGN KEY (CodiceFiscale) REFERENCES Utente(CodiceFiscale),
    FOREIGN KEY (CodiceDomanda) REFERENCES DomandaSicurezza(CodiceDomanda)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------
--    Ordine    --
-- ---------------
DROP TABLE IF EXISTS Ordine;
CREATE TABLE Ordine
(
    CodiceOrdine      INT NOT NULL AUTO_INCREMENT,
    Indirizzo         VARCHAR(200) DEFAULT NULL,
    timestamp         DATETIME NOT NULL,
    DataIncasso       DATE DEFAULT NULL,
    Costo             DECIMAL(7, 2) DEFAULT NULL,
    STATO             VARCHAR(20) NOT NULL
			            CHECK(STATO IN ('processazione', 'preparazione', 'evaso', 'spedito', 'pendente')),
    Username          VARCHAR(20) NOT NULL,

    PRIMARY KEY(CodiceOrdine),

    FOREIGN KEY (Username) REFERENCES Account(Username)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------------
--    UnitaAcquistata    --
-- ------------------------
DROP TABLE IF EXISTS UnitaAcquistata;
CREATE TABLE UnitaAcquistata
(
    IDUnita         INT NOT NULL AUTO_INCREMENT,
    CodiceSeriale   INT NOT NULL,
    CodiceOrdine    INT NOT NULL,

    PRIMARY KEY(IDUnita),
    FOREIGN KEY (CodiceSeriale) REFERENCES VarianteDiProdotto(CodiceSeriale),
    FOREIGN KEY (CodiceOrdine) REFERENCES Ordine(CodiceOrdine)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------
--    Estensione    --
-- -------------------
DROP TABLE IF EXISTS Estensione;
CREATE TABLE Estensione
(
    IDUnita         INT NOT NULL,
    CodiceGaranzia  INT NOT NULL,

    FOREIGN KEY (IDUnita) REFERENCES UnitaAcquistata(IDUnita),
    FOREIGN KEY (CodiceGaranzia) REFERENCES FormulaGaranzia(CodiceGaranzia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------
--    Spedizione    --
-- -------------------
DROP TABLE IF EXISTS Spedizione;
CREATE TABLE Spedizione
(
    Tracking        INT NOT NULL AUTO_INCREMENT,
    DataSpedizione  DATE NOT NULL,
    DataPrevista    DATE NOT NULL,
    DataEffettiva   DATE DEFAULT NULL,
    STATO           VARCHAR(20) NOT NULL
                    CHECK(STATO IN ('spedito', 'transito', 'inconsegna', 'consegnato')),
    CodiceOrdine    INT NOT NULL,

    PRIMARY KEY(Tracking),
    FOREIGN KEY (CodiceOrdine) REFERENCES Ordine(CodiceOrdine)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------
--    Hub    --
-- ------------
DROP TABLE IF EXISTS Hub;
CREATE TABLE Hub
(
    IDHub       INT NOT NULL AUTO_INCREMENT,
    Citta       VARCHAR(50) NOT NULL,

    PRIMARY KEY(IDHub)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Passaggio    --
-- ------------------
DROP TABLE IF EXISTS Passaggio;
CREATE TABLE Passaggio
(
    Tracking    INT NOT NULL,
    IDHub       INT NOT NULL
                references Hub(IDHub),
    Data        DATE NOT NULL,
    Ora         TIME NOT NULL,

    PRIMARY KEY(Tracking, IDHub)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------
--    Recensione    --
-- -------------------
DROP TABLE IF EXISTS Recensione;
CREATE TABLE Recensione
(
    CodiceRecensione    INT NOT NULL AUTO_INCREMENT,
    Testo               TEXT DEFAULT NULL,
    IDUnita             INT NOT NULL,

    PRIMARY KEY(CodiceRecensione),
    FOREIGN KEY (IDUnita) REFERENCES UnitaAcquistata(IDUnita)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------
--    Giudizio    --
-- -----------------
DROP TABLE IF EXISTS Giudizio;
CREATE TABLE Giudizio
(
    IDGiudizio      INT NOT NULL AUTO_INCREMENT,
    Descrizione     VARCHAR(200) NOT NULL,

    PRIMARY KEY(IDGiudizio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------------
--    Caratterizzata    --
-- -----------------------
DROP TABLE IF EXISTS Caratterizzata;
CREATE TABLE Caratterizzata
(
    CodiceRecensione    INT NOT NULL,
    IDGiudizio          INT NOT NULL,
    Voto                INT NOT NULL
                        CHECK(Voto >= 1 and Voto <=5),
                        
    PRIMARY KEY(CodiceRecensione, IDGiudizio),
    FOREIGN KEY (IDGiudizio) REFERENCES Giudizio(IDGiudizio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------
--    Motivazione    --
-- --------------------
DROP TABLE IF EXISTS Motivazione;
CREATE TABLE Motivazione
(
    CodiceMotivazione   INT NOT NULL AUTO_INCREMENT,
    Nome                VARCHAR(20) NOT NULL,
    Descrizione         TEXT NOT NULL,
    TIPO                BOOLEAN NOT NULL,

    PRIMARY KEY(CodiceMotivazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------
--    RichiestaReso    --
-- ----------------------
DROP TABLE IF EXISTS RichiestaReso;
CREATE TABLE RichiestaReso
(
    IDRichiesta         INT NOT NULL AUTO_INCREMENT,
    Accettato           BOOLEAN NOT NULL DEFAULT FALSE,
    IDUnita             INT NOT NULL,
    CodiceMotivazione   INT NOT NULL,

    PRIMARY KEY(IDRichiesta),
    FOREIGN KEY (IDUnita) REFERENCES UnitaAcquistata(IDUnita),
    FOREIGN KEY (CodiceMotivazione) REFERENCES Motivazione(CodiceMotivazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------
--    Reso    --
-- -------------
DROP TABLE IF EXISTS Reso;
CREATE TABLE Reso
(
    CodiceReso          INT NOT NULL AUTO_INCREMENT,
    Ricondizionato      BOOLEAN NOT NULL DEFAULT FALSE,
    IDRichiesta         INT NOT NULL,
    CodiceMagazzino     INT NOT NULL,

    PRIMARY KEY(CodiceReso),
    FOREIGN KEY (IDRichiesta) REFERENCES RichiestaReso(IDRichiesta),
    FOREIGN KEY (CodiceMagazzino) REFERENCES Magazzino(CodiceMagazzino)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------
--    Guasto    --
-- ---------------
DROP TABLE IF EXISTS Guasto;
CREATE TABLE Guasto
(
    CodiceGuasto    INT NOT NULL AUTO_INCREMENT,
    Nome            VARCHAR(50) NOT NULL,
    Descrizione     TEXT NOT NULL,

    PRIMARY KEY(CodiceGuasto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Specifica    --
-- ------------------
DROP TABLE IF EXISTS Specifica;
CREATE TABLE Specifica
(
    CodiceGuasto    INT NOT NULL,
    CodiceGaranzia  INT NOT NULL,

    PRIMARY KEY (CodiceGuasto, CodiceGaranzia),

    FOREIGN KEY (CodiceGuasto) REFERENCES Guasto(CodiceGuasto),
    FOREIGN KEY (CodiceGaranzia) REFERENCES FormulaGaranzia(CodiceGaranzia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------------
--    CodiceErrore    --
-- ---------------------
DROP TABLE IF EXISTS CodiceErrore;
CREATE TABLE CodiceErrore
(
    CodiceErrore    INT NOT NULL,
    IDProdotto      INT NOT NULL,
    CodiceGuasto    INT NOT NULL,
    
    PRIMARY KEY(CodiceErrore, IDProdotto),
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto),
    FOREIGN KEY (CodiceGuasto) REFERENCES Guasto(CodiceGuasto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------
--    Rimedio    --
-- ----------------
DROP TABLE IF EXISTS Rimedio;
CREATE TABLE Rimedio
(
    CodiceRimedio   INT NOT NULL AUTO_INCREMENT,
    Descrizione     TEXT NOT NULL,

    PRIMARY KEY(CodiceRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Soluzione    --
-- ------------------
DROP TABLE IF EXISTS Soluzione;
CREATE TABLE Soluzione
(
    CodiceErrore    INT NOT NULL,
    IDProdotto      INT NOT NULL,
    CodiceRimedio   INT NOT NULL,

    FOREIGN KEY (CodiceErrore) REFERENCES CodiceErrore(CodiceErrore),
    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto),
    FOREIGN KEY (CodiceRimedio) REFERENCES Rimedio(CodiceRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------
--    Domanda    --
-- ----------------
DROP TABLE IF EXISTS Domanda;
CREATE TABLE Domanda
(
    IDDomanda       INT NOT NULL AUTO_INCREMENT,
    Testo           TEXT NOT NULL,
    TIPOSI          BOOLEAN DEFAULT NULL,
    TIPONO          BOOLEAN DEFAULT NULL,
    NextYes         INT DEFAULT NULL,
    NextNo          INT DEFAULT NULL,

    PRIMARY KEY(IDDomanda)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE Domanda
ADD CONSTRAINT fk_next_yes FOREIGN KEY (NextYes) REFERENCES Domanda(IDDomanda);
ALTER TABLE Domanda
ADD CONSTRAINT fk_next_no FOREIGN KEY (NextNo) REFERENCES Domanda(IDDomanda);


-- ---------------
--    EndYes    --
-- ---------------
DROP TABLE IF EXISTS EndYes;
CREATE TABLE EndYes
(
    IDDomanda       INT NOT NULL,
    CodiceRimedio   INT NOT NULL,

    FOREIGN KEY (IDDomanda) REFERENCES Domanda(IDDomanda),
    FOREIGN KEY (CodiceRimedio) REFERENCES Rimedio(CodiceRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------
--    EndNo    --
-- --------------
DROP TABLE IF EXISTS EndNo;
CREATE TABLE EndNo
(
    IDDomanda       INT NOT NULL,
    CodiceRimedio   INT NOT NULL,

    FOREIGN KEY (IDDomanda) REFERENCES Domanda(IDDomanda),
    FOREIGN KEY (CodiceRimedio) REFERENCES Rimedio(CodiceRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------------------
--    AssistenzaVirtuale    --
-- ---------------------------
DROP TABLE IF EXISTS AssistenzaVirtuale;
CREATE TABLE AssistenzaVirtuale
(
    IDProdotto      INT NOT NULL,
    IDGuasto        INT NOT NULL,
    IDDomanda       INT NOT NULL,

    FOREIGN KEY (IDProdotto) REFERENCES Prodotto(IDProdotto),
    FOREIGN KEY (IDGuasto) REFERENCES Guasto(CodiceGuasto),
    FOREIGN KEY (IDDomanda) REFERENCES Domanda(IDDomanda)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------------
--    AssistenzaFisica    --
-- -------------------------
DROP TABLE IF EXISTS AssistenzaFisica;
CREATE TABLE AssistenzaFisica
(
    CodiceAssistenza    INT NOT NULL AUTO_INCREMENT,
    Preventivo          INT DEFAULT NULL,
    Accettato           BOOLEAN DEFAULT NULL,
    IDUnita             INT NOT NULL,

    PRIMARY KEY(CodiceAssistenza),
    FOREIGN KEY (IDUnita) REFERENCES UnitaAcquistata(IDUnita)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------------
--    RicevutaFiscale    --
-- ------------------------
DROP TABLE IF EXISTS RicevutaFiscale;
CREATE TABLE RicevutaFiscale
(
    CodiceRicevuta      INT NOT NULL AUTO_INCREMENT,
    MetodoDiPagamento   VARCHAR(20) NOT NULL,
    CostoTotale         DECIMAL(7,2) NOT NULL,
    CodiceAssistenza    INT NOT NULL,

    PRIMARY KEY(CodiceRicevuta),
    FOREIGN KEY (CodiceAssistenza) REFERENCES AssistenzaFisica(CodiceAssistenza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------
--    Tecnico    --
-- ----------------
DROP TABLE IF EXISTS Tecnico;
CREATE TABLE Tecnico
(
    Badge           INT NOT NULL AUTO_INCREMENT,
    Nome            VARCHAR(20) NOT NULL,
    Cognome         VARCHAR(20) NOT NULL,
    CostoOrario     DECIMAL(5, 2) NOT NULL,

    PRIMARY KEY(Badge)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -------------------
--    Intervento    --
-- -------------------
DROP TABLE IF EXISTS Intervento;
CREATE TABLE Intervento
(
    Ticket              INT NOT NULL AUTO_INCREMENT,
    Descrizione         TEXT DEFAULT NULL,
    OreLavoro           INT DEFAULT NULL,
    Data                DATE NOT NULL,
    FasciaOraria        INT NOT NULL
                        CHECK(FasciaOraria BETWEEN 1 AND 4),
    Latitudine          DECIMAL(7, 2) NOT NULL,
    Longitudine         DECIMAL(7, 2) NOT NULL,
    TIPO                BOOLEAN NOT NULL,
    Badge               INT DEFAULT NULL,
    CodiceAssistenza    INT NOT NULL,

    PRIMARY KEY(Ticket),
    FOREIGN KEY (Badge) REFERENCES Tecnico(Badge),
    FOREIGN KEY (CodiceAssistenza) REFERENCES AssistenzaFisica(CodiceAssistenza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- -----------------
--    Diagnosi    --
-- -----------------
DROP TABLE IF EXISTS Diagnosi;
CREATE TABLE Diagnosi
(
    Ticket              INT NOT NULL,
    CodiceGuasto        INT NOT NULL,

    FOREIGN KEY (Ticket) REFERENCES Intervento(Ticket),
    FOREIGN KEY (CodiceGuasto) REFERENCES Guasto(CodiceGuasto) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------
--    OrdineParti    --
-- --------------------
DROP TABLE IF EXISTS OrdineParti;
CREATE TABLE OrdineParti
(
    CodiceOrdineParti   INT NOT NULL AUTO_INCREMENT,
    Data                DATE NOT NULL,
    DataPrevista        DATE NOT NULL,
    DataEffettiva       DATE DEFAULT NULL,
    BadgeTecnico        INT NOT NULL,
    CodiceAssistenza    INT NOT NULL,

    PRIMARY KEY(CodiceOrdineParti),
    FOREIGN KEY (BadgeTecnico) REFERENCES Tecnico(Badge),
    FOREIGN KEY (CodiceAssistenza) REFERENCES AssistenzaFisica(CodiceAssistenza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- -----------------
--    Ricambio    --
-- -----------------
DROP TABLE IF EXISTS Ricambio;
CREATE TABLE Ricambio
(
    CodiceOrdineParti   INT NOT NULL,
    CodiceParte         INT NOT NULL,
    
    FOREIGN KEY (CodiceOrdineParti) REFERENCES OrdineParti(CodiceOrdineParti),
    FOREIGN KEY (CodiceParte) REFERENCES Parte(CodiceParte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------
--    Test     --
-- --------------
DROP TABLE IF EXISTS Test;
CREATE TABLE Test
(
    CodiceTest     INT NOT NULL,
    Nome           VARCHAR(100) NOT NULL,
    PdS            DOUBLE DEFAULT NULL,
    PRIMARY KEY(CodiceTest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE Test
ADD COLUMN
CodicePadre INT DEFAULT NULL;

ALTER TABLE Test
ADD CONSTRAINT
FOREIGN KEY (CodicePadre) REFERENCES Test(CodiceTest);

ALTER TABLE Prodotto
ADD COLUMN
CodiceTestRoot INT NOT NULL;

ALTER TABLE Prodotto
ADD CONSTRAINT 
FOREIGN KEY (CodiceTestRoot) REFERENCES Test(CodiceTest);

-- --------------------
--    Fallimento     --
-- --------------------
DROP TABLE IF EXISTS Fallimento;
CREATE TABLE Fallimento
(
    CodiceTest           INT NOT NULL,
    CodiceReso           INT NOT NULL,
    Sostituzione         TINYINT(1) NOT NULL,
    PRIMARY KEY(CodiceTest,CodiceReso),
    
    FOREIGN KEY (CodiceTest) REFERENCES Test(CodiceTest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------
--    Riguarda     --
-- ------------------
DROP TABLE IF EXISTS Riguarda;
CREATE TABLE Riguarda
(
    CodiceTest            INT NOT NULL
                          references Test(CodiceTest),
    CodiceParte           INT NOT NULL
                          references Parte(CodiceParte),
    PRIMARY KEY(CodiceTest,CodiceParte),
    
	FOREIGN KEY (CodiceTest) REFERENCES Test(CodiceTest),
	FOREIGN KEY (CodiceParte) REFERENCES Parte(CodiceParte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;