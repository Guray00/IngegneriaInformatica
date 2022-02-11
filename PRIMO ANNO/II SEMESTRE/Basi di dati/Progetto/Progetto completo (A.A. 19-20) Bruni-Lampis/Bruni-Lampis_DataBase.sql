SET NAMES latin1;

BEGIN;
DROP DATABASE IF EXISTS eDevice;
CREATE DATABASE eDevice;
COMMIT;

USE eDevice;
SET GLOBAL event_scheduler = ON;

-- ----------------------------
--  Table structure for 'ClasseProdotto'
-- ----------------------------
DROP TABLE IF EXISTS classe_prodotto;
CREATE TABLE classe_prodotto (
  Nome varchar(50) PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Tipologia'
-- ----------------------------
DROP TABLE IF EXISTS tipologia;
CREATE TABLE tipologia (
  Tipo varchar(50) PRIMARY KEY,
  ClasseProdotto varchar(50),
  foreign key(ClasseProdotto) references classe_prodotto(Nome)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Prodotto'
-- ----------------------------
DROP TABLE IF EXISTS prodotto;
CREATE TABLE prodotto (
  ID int auto_increment PRIMARY KEY,
  Nome varchar(50),
  NumeroFacce int NOT NULL,
  NumeroUnitaLotto int NOT NULL,
  Marca varchar(50) NOT NULL,
  Modello varchar(50) NOT NULL,
  Tipologia varchar(50) NOT NULL,
  
  foreign key(Tipologia) references tipologia(Tipo)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Variante'
-- ----------------------------
DROP TABLE IF EXISTS variante;
CREATE TABLE variante (
  ID int auto_increment PRIMARY KEY,
  Prezzo double NOT NULL,
  Nome varchar(50) default NULL,
  NuoveDisponibili int NOT NULL default 0,
  Cat_A_Disponibili int NOT NULL default 0,
  Cat_B_Disponibili int NOT NULL default 0,
  Cat_C_Disponibili int NOT NULL default 0,
  UnitaDaProdurre int default 0,
  Prodotto int NOT NULL,
  
  foreign key(Prodotto) references prodotto(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Parte'
-- ----------------------------
DROP TABLE IF EXISTS parte;
CREATE TABLE parte (
  Codice int auto_increment PRIMARY KEY,
  Nome varchar(50) default NULL,
  Prezzo double NOT NULL default 0,
  Peso double NOT NULL default 0,
  Svalutazione int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Strutturazione'
-- ----------------------------
DROP TABLE IF EXISTS strutturazione;
CREATE TABLE strutturazione (
  Parte int,
  Prodotto int,
  PRIMARY KEY(Parte,Prodotto),
  
  foreign key (Parte) references parte(Codice)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (Prodotto) references prodotto(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Differenze'
-- ----------------------------
DROP TABLE IF EXISTS differenze;
CREATE TABLE differenze (
  Parte int,
  Variante int,
  PRIMARY KEY(Parte,Variante),
  
  foreign key (Parte) references parte(Codice)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (Variante) references variante(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Formazione'
-- ----------------------------
DROP TABLE IF EXISTS formazione;
CREATE TABLE formazione (
  Parte int,
  SottoParte int,
  PRIMARY KEY(Parte,SottoParte),
  
  foreign key (Parte) references parte(Codice)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (SottoParte) references parte(Codice)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Materiale'
-- ----------------------------
DROP TABLE IF EXISTS materiale;
CREATE TABLE materiale (
  Nome varchar(50) PRIMARY KEY,
  Valore double
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'ComposizioneParte'
-- ----------------------------
DROP TABLE IF EXISTS composizione_parte;
CREATE TABLE composizione_parte (
  Parte int,
  Materiale varchar(50),
  Quantita double not null,
  PRIMARY KEY(Parte,Materiale),
  
  foreign key (Parte) references parte(Codice)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (Materiale) references materiale(Nome)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- ----------------------------
--  Table structure for 'Giunzione'
-- ----------------------------
DROP TABLE IF EXISTS giunzione;
CREATE TABLE giunzione (
  ID int auto_increment PRIMARY KEY,
  Nome varchar(50) NOT NULL,
  Materiale varchar(50) NOT NULL,
  QuantitaMateriale double NOT NULL,
  
  foreign key (Materiale) references materiale(Nome)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Caratteristiche'
-- ----------------------------
DROP TABLE IF EXISTS caratteristiche;
CREATE TABLE caratteristiche (
  Nome varchar(50) PRIMARY KEY,
  UnitaDiMisura varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'CaratteristicheGiunzione'
-- ----------------------------
DROP TABLE IF EXISTS caratteristiche_giunzione;
CREATE TABLE caratteristiche_giunzione (
  Caratteristica varchar(50),
  Giunzione int,
  Valore double NOT NULL,
  PRIMARY KEY(Caratteristica,Giunzione),
  
  foreign key (Caratteristica) references caratteristiche(Nome)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (Giunzione) references giunzione(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Operazione'
-- ----------------------------
DROP TABLE IF EXISTS operazione;
CREATE TABLE operazione (
  ID int auto_increment PRIMARY KEY,
  Faccia int NOT NULL,
  Nome varchar(50),
  Giunzione int,
  Tipologia enum ("Montaggio","Smontaggio") NOT NULL DEFAULT "Montaggio",
  Parte1 int NOT NULL,
  Parte2 int NOT NULL,
  
  foreign key (Giunzione) references giunzione(ID)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (Parte1) references parte(Codice)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key (Parte2) references parte(Codice)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Sequenza'
-- ----------------------------
DROP TABLE IF EXISTS sequenza;
CREATE TABLE sequenza (
  Codice int auto_increment PRIMARY KEY,
  Tipologia enum('Montaggio','Smontaggio') NOT NULL,
  Variante int NOT NULL,
  
  foreign key(Variante) references Variante(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'OperazioniDellaSequenza'
-- ----------------------------
DROP TABLE IF EXISTS operazioni_della_sequenza;
CREATE TABLE operazioni_della_sequenza (
  ID int auto_increment PRIMARY KEY,
  Ordine int NOT NULL,
  Operazione int NOT NULL,
  Sequenza int NOT NULL,
  
  foreign key(Operazione) references Operazione(ID)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(Sequenza) references Sequenza(Codice)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of 'OperazioniDellaSequenza'
-- ----------------------------
BEGIN;

COMMIT;

-- ----------------------------
--  Table structure for 'Linea'
-- ----------------------------
DROP TABLE IF EXISTS linea;
CREATE TABLE linea (
  Codice int auto_increment PRIMARY KEY,
  Tempo double NOT NULL,
  CHECK (Tempo>0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Assegnamento'
-- ----------------------------
DROP TABLE IF EXISTS assegnamento;
CREATE TABLE assegnamento (
  Sequenza int,
  `Data` date,
  Linea int,
  PRIMARY KEY(Sequenza,`Data`,Linea),
  
  foreign key(Linea) references Linea(Codice)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(Sequenza) references Sequenza(Codice)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Stazione'
-- ----------------------------
DROP TABLE IF EXISTS stazione;
CREATE TABLE stazione (
  ID int auto_increment PRIMARY KEY,
  Ordine int NOT NULL,
  OrientamentoProdotto int,
  Linea int NOT NULL,
  
  foreign key(Linea) references Linea(Codice)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Utensile'
-- ----------------------------
DROP TABLE IF EXISTS utensile;
CREATE TABLE utensile (
  Nome varchar(50) PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'UtensiliOperazione'
-- ----------------------------
DROP TABLE IF EXISTS utensili_operazioni;
CREATE TABLE utensili_operazioni (
  Utensile varchar(50),
  Operazione int,
  PRIMARY KEY (Utensile,Operazione),
  
  foreign key(Operazione) references Operazione(ID)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(Utensile) references Utensile(Nome)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Operatore'
-- ----------------------------
DROP TABLE IF EXISTS operatore;
CREATE TABLE operatore (
  CodiceFiscale char(16) PRIMARY KEY,
  Nome varchar(50) NOT NULL,
  Cognome varchar(50) NOT NULL,
  DataAssunzione date,
  DataNascita date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Lavorare'
-- ----------------------------
DROP TABLE IF EXISTS lavorare;
CREATE TABLE lavorare (
  Operatore char(16),
  Stazione int,
  DataInizio date,
  DataFine date,
  PRIMARY KEY(Operatore,Stazione,DataInizio),
  
  foreign key(Operatore) references Operatore(CodiceFiscale)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(Stazione) references Stazione(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Esegue'
-- ----------------------------
DROP TABLE IF EXISTS esegue;
CREATE TABLE esegue (
  Operatore char(16),
  OperazioneSequenza int,
  Stazione int,
  DataInizio date,
  DataFine date,

  PRIMARY KEY(Operatore,OperazioneSequenza,Stazione, DataInizio),
  
  foreign key(Operatore) references Operatore(CodiceFiscale)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(Stazione) references Stazione(ID)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(OperazioneSequenza) references operazioni_della_sequenza(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Abilita_operatore'
-- ----------------------------
DROP TABLE IF EXISTS abilita_operatore;
CREATE TABLE abilita_operatore (
  Operatore char(16),
  Operazione int,
  Tmedio double,
  PRIMARY KEY(Operatore,Operazione),
  
  foreign key(Operatore) references Operatore(CodiceFiscale)
  on update CASCADE
  on delete NO ACTION,
  
  foreign key(Operazione) references operazione(ID)
  on update CASCADE
  on delete NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Lotto'
-- ----------------------------
DROP TABLE IF EXISTS lotto;
CREATE TABLE lotto (
  Codice int auto_increment PRIMARY KEY,
  Variante int NOT NULL,
  
  foreign key(Variante) references variante(ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'LottoProduzione'
-- ----------------------------
DROP TABLE IF EXISTS lotto_produzione;
CREATE TABLE lotto_produzione (
  Codice int PRIMARY KEY,
  SedeProduzione varchar(50) NOT NULL,
  DataInizioProduzione timestamp NOT NULL,
  DataFineProduzionePrevista timestamp NOT NULL,
  DataFineProduzione timestamp,
  Linea int NOT NULL,
  
  foreign key (Codice) references lotto(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key (Linea) references linea(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'LottoResi'
-- ----------------------------
DROP TABLE IF EXISTS lotto_resi;
CREATE TABLE lotto_resi (
  Codice int PRIMARY KEY,
  foreign key (Codice) references lotto(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'LottoRicondizionati'
-- ----------------------------
DROP TABLE IF EXISTS lotto_ricondizionati;
CREATE TABLE lotto_ricondizionati (
  Codice int PRIMARY KEY,
  foreign key (Codice) references lotto(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'LottoSmaltimento'
-- ----------------------------
DROP TABLE IF EXISTS lotto_smaltimento;
CREATE TABLE lotto_smaltimento (
  Codice int PRIMARY KEY,
  Usura int NOT NULL,
  Linea int NOT NULL,
  
  foreign key (Codice) references lotto(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key (Linea) references linea(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Magazzino'
-- ----------------------------
DROP TABLE IF EXISTS magazzino;
CREATE TABLE magazzino (
  Codice int auto_increment PRIMARY KEY,
  Citta varchar(50),
  Capienza int
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'TipologiaMagazzino'
-- ----------------------------
DROP TABLE IF EXISTS tipologia_magazzino;
CREATE TABLE tipologia_magazzino (
  Magazzino int,
  ClasseProdotto varchar(50),
  DataInizio date,
  DataFine date default NULL,
  PRIMARY KEY(Magazzino,ClasseProdotto,DataInizio),
  
  foreign key (ClasseProdotto) references classe_prodotto(Nome)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key (Magazzino) references magazzino(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ------------------------------
--  Table structure for 'Settore'
-- ------------------------------
DROP TABLE IF EXISTS settore;
CREATE TABLE settore (
  ID int auto_increment PRIMARY KEY,
  Ubicazione char(3) NOT NULL,
  Capienza int NOT NULL,
  Magazzino int NOT NULL,
  Prodotto int,
  
  foreign key (Prodotto) references prodotto(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key (Magazzino) references magazzino(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Stoccaggio'
-- ----------------------------
DROP TABLE IF EXISTS stoccaggio;
CREATE TABLE stoccaggio (
  Lotto int,
  Settore int,
  DataInizio date NOT NULL,
  DataFine date default NULL,
  Scompartimento int NOT NULL,
  PRIMARY KEY(Lotto,Settore),
  
  foreign key (Lotto) references lotto(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key (Settore) references settore(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

 
-- ----------------------------
--  Table structure for 'Documento'
-- ----------------------------
DROP TABLE IF EXISTS documento;
CREATE TABLE documento (
  Numero varchar(50) PRIMARY KEY,
  Tipologia enum('Patante','Passaporto','Carta identità') NOT NULL,
  EnteRilascio varchar(50) NOT NULL,
  DataScadenza date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Cap_Citta'
-- ----------------------------
DROP TABLE IF EXISTS cap_citta;
CREATE TABLE cap_citta (
	Cap int PRIMARY KEY,
    Citta varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Cliente'
-- ----------------------------
DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
  CodiceFiscale char(16) PRIMARY KEY,
  Nome varchar(50) NOT NULL,
  Cognome varchar(50) NOT NULL,
  Telefono int NOT NULL,
  Via varchar(50) NOT NULL,
  Civico int,
  Cap int NOT NULL,
  dataNascita date,					
  Documento varchar(50) NOT NULL,
  
  foreign key(Documento) references documento(Numero)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Cap) references cap_citta(Cap)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Account'
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  Username varchar(50) PRIMARY KEY,
  `Password` varchar(50) NOT NULL,
  DomandaSicurezza varchar(50),
  RispostaSicurezza varchar(50),
  DataIscrizione date NOT NULL,
  Cliente char(16) NOT NULL,
  
  foreign key(Cliente) references cliente(CodiceFiscale)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Indirizzo_Ordine'
-- ----------------------------
DROP TABLE IF EXISTS indirizzo_ordine;
CREATE TABLE indirizzo_ordine (
  ID int auto_increment PRIMARY KEY,
  Via varchar(50) NOT NULL,
  Civico int,
  Cap int NOT NULL,
  
  foreign key(Cap) references cap_citta(Cap)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Ordine'
-- ----------------------------
DROP TABLE IF EXISTS ordine;
CREATE TABLE ordine (
  Codice int auto_increment PRIMARY KEY,
  IstanteOrdine timestamp NOT NULL,
  DataEvasione date,
  Stato enum('Processazione','Preparazione','Spedito','Evaso','Pendente') NOT NULL default 'Processazione', 
  Indirizzo int NOT NULL,
  `Account` varchar(50) NOT NULL,
  
  foreign key(Indirizzo) references indirizzo_ordine(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(`Account`) references `Account`(Username)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Categoria'
-- ----------------------------
DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
  Nome varchar(50) PRIMARY KEY,
  Sconto int,
  Descrizione text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Carrello'
-- ----------------------------
DROP TABLE IF EXISTS carrello;
CREATE TABLE carrello (
  Variante int,
  Categoria varchar(50),
  Ordine int,
  Quantita int NOT NULL default 1,
  
  PRIMARY KEY(variante, categoria, ordine),
  foreign key(Variante) references variante(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Categoria) references categoria(Nome)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Ordine) references ordine(Codice)
  on delete CASCADE
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Spedizione'
-- ----------------------------
DROP TABLE IF EXISTS spedizione;
CREATE TABLE spedizione (
  Codice int auto_increment PRIMARY KEY,
  DataSpedizione date NOT NULL,
  DataConsegnaPrevista date NOT NULL,
  DataConsegnaEffettiva date,
  Stato enum('Spedita','In transito','In consegna','Consegnata') NOT NULL default 'Spedita', 
  Ordine int NOT NULL,
  
  foreign key(Ordine) references ordine(Codice)
  on delete CASCADE
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Trigger
-- ----------------------------
drop trigger if exists spedisciOrdine ;
DELIMITER $$
create trigger spedisciOrdine after insert on spedizione
for each row
BEGIN
		update ordine
        set Stato='Spedito'
        where Codice=new.Ordine;
END;
$$
DELIMITER ;

drop trigger if exists evadiOrdine ;
DELIMITER $$
create trigger evadiOrdine after update on spedizione
for each row
BEGIN
	if new.Stato='Consegnato' THEN
		update ordine
        set Stato='Evaso', DataEvasione=new.DataConsegnaEffettiva
        where Codice=new.Ordine;
	END IF;
END;
$$
DELIMITER ;

-- ----------------------------
--  Table structure for 'Hub'
-- ----------------------------
DROP TABLE IF EXISTS hub;
CREATE TABLE hub (
  Citta varchar(50) PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Tracciamento'
-- ----------------------------
DROP TABLE IF EXISTS tracciamento;
CREATE TABLE tracciamento (
  Hub varchar(50),
  Spedizione int,
  DataOraArrivo timestamp NOT NULL,
  PRIMARY KEY(Hub,Spedizione),
  
  foreign key(Hub) references hub(Citta)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Spedizione) references spedizione(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Estensione_garanzia'
-- ----------------------------
DROP TABLE IF EXISTS estensione_garanzia;
CREATE TABLE estensione_garanzia (
  Codice int auto_increment PRIMARY KEY,
  Prezzo double NOT NULL,
  Validita int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Estensione_applicabile'
-- ----------------------------
DROP TABLE IF EXISTS estensione_applicabile;
CREATE TABLE estensione_applicabile (
  EstensioneGaranzia int,
  ClasseProdotto varchar(50),
  PRIMARY KEY(EstensioneGaranzia,ClasseProdotto),
  
  foreign key(EstensioneGaranzia) references estensione_garanzia(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(ClasseProdotto) references classe_prodotto(Nome)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Unità'
-- ----------------------------
DROP TABLE IF EXISTS unita;
CREATE TABLE unita (
  Codice int auto_increment PRIMARY KEY,
  DataProduzione date,
  Variante int NOT NULL,
  EstensioneGaranzia int,
  Ordine int,
  Categoria varchar(50),
  LottoProduzione int,
  
  foreign key(Variante) references variante(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Ordine) references ordine(Codice)
  on delete SET NULL
  on update CASCADE,
  
  foreign key(EstensioneGaranzia) references estensione_garanzia(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Categoria) references categoria(Nome)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(LottoProduzione) references lotto_produzione(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Resi'
-- ----------------------------
DROP TABLE IF EXISTS resi;
CREATE TABLE resi (
  Unita int,
  LottoResi int,
  PRIMARY KEY(Unita,LottoResi),
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(LottoResi) references lotto_resi(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Ricondizionati'
-- ----------------------------
DROP TABLE IF EXISTS ricondizionati;
CREATE TABLE ricondizionati (
  Unita int,
  LottoRicondizionati int,
  PRIMARY KEY(Unita,LottoRicondizionati),
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(LottoRicondizionati) references lotto_ricondizionati(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Da_smaltire'
-- ----------------------------
DROP TABLE IF EXISTS da_smaltire;
CREATE TABLE da_smaltire (
  Unita int,
  LottoSmaltimento int,
  PRIMARY KEY(Unita,LottoSmaltimento),
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(LottoSmaltimento) references lotto_smaltimento(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Ricodifica'
-- ----------------------------
DROP TABLE IF EXISTS ricodifica;
CREATE TABLE ricodifica (
  UnitaVecchia int,
  UnitaNuova int,
  PRIMARY KEY(UnitaVecchia,UnitaNuova),
  
  foreign key(UnitaVecchia) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
 foreign key(UnitaNuova) references unita(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Scarto'
-- ----------------------------
DROP TABLE IF EXISTS scarto;
CREATE TABLE scarto(
  OperazioneSequenza int,
  `Data` timestamp,
  Unita int,
  Linea int,
  Reinserito bool,
  PRIMARY KEY(OperazioneSequenza, `Data`, Unita, Linea),
  
  foreign key(OperazioneSequenza) references operazioni_della_sequenza(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Linea) references linea(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Recupero_Parte'
-- ----------------------------
DROP TABLE IF EXISTS recupero_parte;
CREATE TABLE recupero_parte(
  Unita int,
  Parte int,
  PRIMARY KEY(Unita,Parte),
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Parte) references parte(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Recupero_Materiale'
-- ----------------------------
DROP TABLE IF EXISTS recupero_materiale;
CREATE TABLE recupero_materiale(
  Unita int,
  Materiale varchar(50),
  Quantita double NOT NULL,
  Valore_residuo double NOT NULL default 0,
  PRIMARY KEY(Unita,Materiale),
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Materiale) references materiale(Nome)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Motivo'
-- ----------------------------
DROP TABLE IF EXISTS motivo;
CREATE TABLE motivo(
  Codice int auto_increment PRIMARY KEY,
  Descrizione varchar(250)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Difetto'
-- ----------------------------
DROP TABLE IF EXISTS difetto;
CREATE TABLE difetto(
  Codice int auto_increment PRIMARY KEY,
  Descrizione varchar(250),
  Motivo int NOT NULL,
  
  foreign key(Motivo) references motivo(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Richiesta_di_reso'
-- ----------------------------
DROP TABLE IF EXISTS richiesta_di_reso;
CREATE TABLE richiesta_di_reso(
  Codice int auto_increment PRIMARY KEY,
  `Data` date NOT NULL,
  Stato enum('Accettata','Rifiutata','Valutazione') NOT NULL,
  Motivo int NOT NULL,
  Difetto int,
  `Account` varchar(50) NOT NULL,
  Unita int NOT NULL,
  
  foreign key(Motivo) references motivo(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Difetto) references difetto(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(`Account`) references `Account`(Username)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Guasto'
-- ----------------------------
DROP TABLE IF EXISTS guasto;
CREATE TABLE guasto(
  Codice int auto_increment PRIMARY KEY,
  Descrizione varchar(250),
  Nome varchar(50)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Rimedio'
-- ----------------------------
DROP TABLE IF EXISTS rimedio;
CREATE TABLE rimedio(
  Codice int auto_increment PRIMARY KEY,
  Descrizione varchar(250)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Assistenza_virtuale'
-- ----------------------------
DROP TABLE IF EXISTS assistenza_virtuale;
CREATE TABLE assistenza_virtuale(
  Rimedio int,
  Guasto int,
  Ordine int NOT NULL,
  Domanda varchar(250) NOT NULL,
  PRIMARY KEY(Rimedio,Guasto),
  
  foreign key(Rimedio) references rimedio(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Guasto) references guasto(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Copertura_guasto'
-- ----------------------------
DROP TABLE IF EXISTS copertura_guasto;
CREATE TABLE copertura_guasto(
  EstensioneGaranzia int,
  Guasto int,
  PRIMARY KEY(EstensioneGaranzia,Guasto),
  
  foreign key(EstensioneGaranzia) references estensione_garanzia(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Guasto) references guasto(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Errore'
-- ----------------------------
DROP TABLE IF EXISTS errore;
CREATE TABLE errore(
  Prodotto int,
  Guasto int,
  CodiceErrore int,
  PRIMARY KEY(Prodotto,Guasto),
  
  foreign key(Prodotto) references prodotto(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Guasto) references guasto(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Richiesta_intervento'
-- ----------------------------
DROP TABLE IF EXISTS richiesta_intervento;
CREATE TABLE richiesta_intervento(
  Ticket int auto_increment PRIMARY KEY,
  Preventivo double,
  StatoPreventivo enum('Accettato','Rifiutato','Valutazione'),
  Unita int NOT NULL,
  Cliente char(16) NOT NULL,
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Cliente) references cliente(CodiceFiscale)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Centro_assistenza'
-- ----------------------------
DROP TABLE IF EXISTS centro_assistenza;
CREATE TABLE centro_assistenza(
  ID int auto_increment PRIMARY KEY,
  Via varchar(50) NOT NULL,
  Civico int,
  Cap int NOT NULL,
  
  foreign key(Cap) references cap_citta(Cap)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Tecnico'
-- ----------------------------
DROP TABLE IF EXISTS tecnico;
CREATE TABLE tecnico(
  CodiceFiscale char(16) primary key,
  Nome varchar(50) NOT NULL,
  Cognome varchar(50) NOT NULL,
  ManodOpera double NOT NULL,
  dataNascita date,					
  CentroAssistenza int NOT NULL,
  
  foreign key(CentroAssistenza) references centro_assistenza(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Intervento'
-- ----------------------------
DROP TABLE IF EXISTS intervento;
CREATE TABLE intervento(
  ID int auto_increment PRIMARY KEY,
 `Data` date NOT NULL,
  Ora int,
  Via varchar(50) NOT NULL,
  Civico int,
  Cap int NOT NULL,
  Tecnico char(16),
  CodiceGuasto int,
  Ticket int NOT NULL,
  CentroAssistenza int NOT NULL,
  
  foreign key(Cap) references cap_citta(Cap)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Tecnico) references tecnico(CodiceFiscale)
  on delete SET NULL
  on update CASCADE,
  
  foreign key(CodiceGuasto) references Guasto(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Ticket) references richiesta_intervento(Ticket)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(CentroAssistenza) references centro_assistenza(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Riparazione'
-- ----------------------------
DROP TABLE IF EXISTS riparazione;
CREATE TABLE riparazione(
  ID int auto_increment PRIMARY KEY,
  TempoPrevisto int NOT NULL,
  TempoImpiegato int,
  Prezzo double default NULL,
  Intervento int,
  
  foreign key(Intervento) references intervento(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Trigger
-- ----------------------------
drop trigger if exists controlloPreventivo;
DELIMITER $$
create trigger controlloPreventivo before insert on riparazione
for each row
BEGIN
	DECLARE Check_Stato bool;
		select if(RI.StatoPreventivo<>'Accettato',0,1) into Check_Stato
        from riparazione R inner join intervento I on R.Intervento=I.ID inner join richiesta_intervento RI ON RI.Ticket=I.Ticket
        where R.ID=new.ID;
		
        if Check_Stato = 0 then
			signal sqlstate '45000'
            set message_text ='Il preventivo non è stato ancora accettato';
		end if;
END;
$$
DELIMITER ;

-- ----------------------------
--  Table structure for 'OrdineRiparazione'
-- ----------------------------
DROP TABLE IF EXISTS ordine_riparazione;
CREATE TABLE ordine_riparazione(
  Codice int auto_increment PRIMARY KEY,
  DataOrdine date NOT NULL,
  DataConsegnaPrevista date NOT NULL,
  DataConsegna date,
  Intervento int,
  
  foreign key(Intervento) references intervento(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Ricevuta'
-- ----------------------------
DROP TABLE IF EXISTS ricevuta;
CREATE TABLE ricevuta(
  Codice int auto_increment PRIMARY KEY,
  TipoPagamento enum('Contanti','POS') NOT NULL,
  Riparazione int NOT NULL,
  
  foreign key(Riparazione) references riparazione(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'OrdineParte'
-- ----------------------------
DROP TABLE IF EXISTS ordine_parte;
CREATE TABLE ordine_parte(
  Parte int,
  OrdineRiparazione int,
  
  foreign key(Parte) references parte(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(OrdineRiparazione) references ordine_riparazione(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'SostituzioneParte'
-- ----------------------------
DROP TABLE IF EXISTS sostituzione_parte;
CREATE TABLE sostituzione_parte(
  Parte int,
  Riparazione int,
  
  foreign key(Parte) references parte(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Riparazione) references riparazione(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'Recensione'
-- ----------------------------
DROP TABLE IF EXISTS recensione;
CREATE TABLE recensione(
  Variante int,
  `Account` varchar(50),
  Affidabilita int NOT NULL,
  Esperienza int NOT NULL,
  Performance int NOT NULL, 
  Descrizione text,
  `Data` date NOT NULL,
  PRIMARY KEY(Variante,`Account`),
  
  foreign key(Variante) references variante(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(`Account`) references `Account`(Username)
  on delete NO ACTION
  on update CASCADE,
  
  check(Affidabilita >0 OR Affidabilita <=5),
  check(Esperienza >0 OR Esperienza <=5),
  check(Performance >0 OR Performance <=5)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Test'
-- ----------------------------
DROP TABLE IF EXISTS test;
CREATE TABLE test(
  Codice int auto_increment PRIMARY KEY,
  Nome varchar(50)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for 'SottoTest'
-- ----------------------------
DROP TABLE IF EXISTS sotto_test;
CREATE TABLE sotto_test(
  TestPadre int,
  TestFiglio int,
  PRIMARY KEY(TestPadre,TestFiglio),
  
  foreign key(TestPadre) references Test(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(TestFiglio) references Test(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'TestFalliti'
-- ----------------------------
DROP TABLE IF EXISTS test_falliti;
CREATE TABLE test_falliti(
  Test int,
  Unita int,
  PRIMARY KEY(Test,Unita),
  
  foreign key(Test) references Test(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Unita) references Unita(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------------------
--  Table structure for 'Testare'
-- ----------------------------
DROP TABLE IF EXISTS testare;
CREATE TABLE testare(
  Test int,
  Parte int,
  PRIMARY KEY(Test,Parte),
  
  foreign key(Test) references Test(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Parte) references Parte(Codice)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'Livello1TestTree'
-- ----------------------------
DROP TABLE IF EXISTS livello1_test_tree;
CREATE TABLE livello1_test_tree(
  Test int,
  Variante int,
  PRIMARY KEY(Test,Variante),
  
  foreign key(Test) references Test(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Variante) references Variante(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'OperazioneRefurbishment'
-- ----------------------------
DROP TABLE IF EXISTS operazione_refurbishment;
CREATE TABLE operazione_refurbishment(
  ID int auto_increment PRIMARY KEY,
  Nome varchar(50),
  Tipo varchar(50),
  Operatore char(16) NOT NULL,
  
  foreign key(Operatore) references Operatore(CodiceFiscale)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'RicondizionamentoParte'
-- ----------------------------
DROP TABLE IF EXISTS ricondizionamento_parte;
CREATE TABLE ricondizionamento_parte(
  Parte int,
  OperazioneRefurbishment int,
  PRIMARY KEY(Parte,OperazioneRefurbishment),
  
  foreign key(Parte) references Parte(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(OperazioneRefurbishment) references operazione_refurbishment(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'RicondizionamentoUnita'
-- ----------------------------
DROP TABLE IF EXISTS ricondizionamento_unita;
CREATE TABLE ricondizionamento_unita(
  Unita int,
  OperazioneRefurbishment int,
  `Data` date,
  PRIMARY KEY(Unita,OperazioneRefurbishment),
  
  foreign key(Unita) references Unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(OperazioneRefurbishment) references operazione_refurbishment(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'PoliticaGestione'
-- ----------------------------
DROP TABLE IF EXISTS politica_gestione;
CREATE TABLE politica_gestione(
  ID int auto_increment PRIMARY KEY,
  Evento varchar(250),
  Azione varchar(250)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'GestioneProdotto'
-- ----------------------------
DROP TABLE IF EXISTS gestione_prodotto;
CREATE TABLE gestione_prodotto(
  PoliticaGestione int,
  Prodotto int,
  PRIMARY KEY(PoliticaGestione,Prodotto),
  
  foreign key(Prodotto) references Prodotto(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(PoliticaGestione) references politica_gestione(ID)
  on delete NO ACTION
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Table structure for 'UnitaDisponibiliOrdine'
-- ----------------------------
DROP TABLE IF EXISTS unita_disponibili_ordine;
CREATE TABLE unita_disponibili_ordine(
  Unita int PRIMARY KEY,
  Variante int NOT NULL,
  Categoria varchar(50),
  
  foreign key(Unita) references unita(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Variante) references variante(ID)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Categoria) references categoria(Nome)
  on delete no action
  on update CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Analyitics 1 tables
-- ----------------------------

-- Table structure for 'Sintomo'
DROP TABLE IF EXISTS sintomo;
CREATE TABLE sintomo(
  Codice int auto_increment PRIMARY KEY,
  Nome varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Table structure for 'SintomiGuasto'
DROP TABLE IF EXISTS sintomi_guasto;
CREATE TABLE sintomi_guasto(
  Guasto int,
  Sintomo int,
  PRIMARY KEY(Guasto, Sintomo),
  
  foreign key(Guasto) references guasto(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Sintomo) references sintomo(Codice)
  on delete NO ACTION
  on update CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for 'Soluzione'
DROP TABLE IF EXISTS soluzione;
CREATE TABLE soluzione(
  Rimedio varchar(250) PRIMARY KEY
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for 'Caso'
DROP TABLE IF EXISTS caso;
CREATE TABLE caso(
  Codice int PRIMARY KEY auto_increment,
  Guasto int,
   
  foreign key(Guasto) references guasto(Codice)
  on delete NO ACTION
  on update CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for 'SintomiDelCaso'
DROP TABLE IF EXISTS sintomi_caso;
CREATE TABLE sintomi_caso(
  Sintomo int,
  Caso int,
  PRIMARY KEY(Sintomo,Caso),
  
  foreign key(Caso) references caso(Codice)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Sintomo) references sintomo(Codice)
  on delete NO ACTION
  on update CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Table structure for 'SoluzioniCaso'
DROP TABLE IF EXISTS soluzioni_caso;
CREATE TABLE soluzioni_caso(
  Soluzione varchar(250),
  Caso int,
  PRIMARY KEY(Soluzione,Caso),
  
  foreign key(Soluzione) references soluzione(Rimedio)
  on delete NO ACTION
  on update CASCADE,
  
  foreign key(Caso) references caso(Codice)
  on delete NO ACTION
  on update CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
--  Events
-- ----------------------------

-- ----------------------------
--  Trigger prezzo parte
-- ----------------------------
drop trigger if exists prezzo_parte;
DELIMITER $$
create trigger prezzo_parte after insert on composizione_parte
for each row 
BEGIN
	
    DECLARE costo_materiale double;
    select M.Valore into costo_materiale
    from materiale M
    where M.Nome=new.Materiale;
	
    update parte
    set prezzo=prezzo+((new.Quantita/1000)*costo_materiale)
    where Codice=new.Parte; 

END; $$
DELIMITER ; 

-- trigger
drop trigger if exists  unita_stessa_variante_resi ;
DELIMITER $$
create trigger unita_stessa_variante_resi before insert on resi
for each row
BEGIN
	DECLARE var varchar(250);
    DECLARE var2 varchar(250);
    select L.Variante into var
    from resi R natural join lotto L
    where R.LottoResi=new.LottoResi;
    
	select U.Variante into var2
	from unita U
	where U.Codice=new.Unita;
		
	if var<>var2 THEN
		signal sqlstate '45000'
		set message_text ='Questo lotto è di un altra variante';
	END IF;
END;
$$ 
DELIMITER ;


-- Trigger
drop trigger if exists  unita_stessa_variante_produzione ;
DELIMITER $$
create trigger unita_stessa_variante_produzione before insert on unita
for each row
BEGIN
	DECLARE var varchar(250);

    select variante into var
    from Lotto
    where codice = new.LottoProduzione; 
    
	if var<>new.Variante THEN
		signal sqlstate '45000'
		set message_text ='Questo lotto è di un altra variante';
	END IF;
END;
$$ 
DELIMITER ;

-- Trigger
drop trigger if exists  unita_stessa_variante_smaltimento ;
DELIMITER $$
create trigger unita_stessa_variante_smaltimento before insert on da_smaltire
for each row
BEGIN
	DECLARE var varchar(250);
    DECLARE var2 varchar(250);
    select L.Variante into var
    from da_smaltire R natural join lotto L
    where R.LottoSmaltimento=new.LottoSmaltimento;
    
	select U.Variante into var2
	from unita U
	where U.Codice=new.Unita;
		
	if var<>var2 THEN
		signal sqlstate '45000'
		set message_text ='Questo lotto è di un altra variante';
	END IF;
END;
$$ 
DELIMITER ;

-- ----------------------------
--  Trigger
-- ----------------------------
drop trigger if exists  stoccaggio ;
DELIMITER $$
create trigger stoccaggio before insert on stoccaggio
for each row
BEGIN
	DECLARE checkSett bool;
    DECLARE disp int default 0;
	
    select if(SE.Prodotto=V.Prodotto,1,0) into checkSett
    from stoccaggio S inner join lotto L on S.Lotto=L.Codice inner join variante V on L.Variante=V.ID inner join settore SE on SE.ID=S.Settore
    where S.Lotto=new.Lotto and S.Settore=new.Settore;
    if checkSett = 0 then
		signal sqlstate '45000'
        set message_text ='Il settore deve contenere lo stesso prodotto';
	else
		-- si verifica che vi sia spazio nel settore
		select SS.Capienza-count(*) into disp
        from stoccaggio S inner join Settore SS on S.settore = SS.ID				-- si prende lo stoccaggio e il settore per verificare lo spazio disponibile attuale
        where SS.id = new.settore and S.DataFine IS NOT NULL;						-- vengono selezionati quelli attualmente usati e al contempo con spazio libero a sufficienza.
        
        if disp = 0 then
			signal sqlstate '45000'
			set message_text ='Settore pieno';
		end if;
    end if;    
END;
$$
DELIMITER ;   

-- Trigger
drop trigger if exists  unita_stessa_variante_ricondizionati ;
DELIMITER $$
create trigger unita_stessa_variante_ricondizionati before insert on ricondizionati
for each row
BEGIN
	DECLARE var varchar(250);
    DECLARE var2 varchar(250);
    select L.Variante into var
    from ricondizionati R natural join lotto L
    where R.LottoRicondizionati=new.LottoRicondizionati;
    
	select U.Variante into var2
	from unita U
	where U.Codice=new.Unita;
		
	if var<>var2 THEN
		signal sqlstate '45000'
		set message_text ='Questo lotto è di un altra variante';
	END IF;
END;
$$ 
DELIMITER ;


-- ----------------------------
-- "Operazione" 1 
-- ----------------------------
drop procedure if exists popolaCarrello;
DELIMITER $$
create procedure popolaCarrello(IN Variante_ int, IN Categoria_ varchar(50), IN Ordine_ int, IN Quantita_ int)
BEGIN
	DECLARE Stato varchar(50);
    DECLARE Disponibili int default 0;
    DECLARE nuovoOrdine int;
    DECLARE messaggio varchar(250);
    DECLARE Indirizzo varchar(50);
    DECLARE Profilo varchar(50);
    
		select O.Stato into Stato
        from ordine O
        where O.Codice=Ordine_;
        
        if Stato = 'Processazione' THEN
			if Categoria_ = 'Nuovo' then
				select V.NuoveDisponibili into Disponibili						-- memorizzo il numero di Unità disponibili in Disponibili
				from variante V
				where V.ID=Variante_;
                
                if Disponibili<Quantita_ then
					update variante				-- se non sono presenti abbastanza unità a magazzino si incrementa il numero di unità da produrre
                    set UnitaDaProdurre = UnitaDaProdurre + Quantita_
                    where ID=Variante_;
                    -- Recupero dati per creare un nuovo ordine e popolarne il carrello
					select max(Codice)+1 into nuovoOrdine   
                    from Ordine;
                    
                    select Ordine.Indirizzo, Account into Indirizzo, Profilo   
                    from Ordine
                    where Ordine.Codice = Ordine_;
                    -- creazione nuovo ordine e popolamento carrello
                    insert into Ordine values(nuovoOrdine, current_timestamp(),NULL,'Pendente', Indirizzo, Profilo);
                    insert into Carrello values(Variante_,Categoria_, nuovoOrdine, Quantita_);
                    
                    SET messaggio =concat('Nuovo ordine creato, codice: ', nuovoOrdine); 
                    signal sqlstate '45000'
                    set message_text = messaggio;
                else
					insert into Carrello values(Variante_,Categoria_, Ordine_, Quantita_);			-- le unità disponibili bastano a "coprire" l'ordine
					update variante						-- scalo la quantità acquistata dalle disponibili
                    set NuoveDisponibili=NuoveDisponibili-Quantita_
                    where ID=Variante_;
				end if;
                
            elseif Categoria_ = 'Categoria A' then
				select V.Cat_A_Disponibili into Disponibili
				from variante V
				where V.ID=Variante_;
            
				if Disponibili<Quantita_ then			-- non ci sono abbastanza unità ricondizionate
					signal sqlstate '45000'
                    set message_text = 'Non sono presenti abbastanze unità ricondizionate';
                else
					insert into Carrello values(Variante_,Categoria_, Ordine_, Quantita_);			-- le unità disponibili bastano a "coprire" l'ordine
					update variante
                    set Cat_A_Disponibili=Cat_A_Disponibili-Quantita_
                    where ID=Variante_;
				end if;
                
            elseif Categoria_ = 'Categoria B' then
				select V.Cat_B_Disponibili into Disponibili
				from variante V
				where V.ID=Variante_;
			
				if Disponibili<Quantita_ then
					signal sqlstate '45000'
                    set message_text = 'Non sono presenti abbastanze unità ricondizionate';
                else
					insert into Carrello values(Variante_,Categoria_, Ordine_, Quantita_);			-- le unità disponibili bastano a "coprire" l'ordine
					update variante
                    set Cat_B_Disponibili=Cat_B_Disponibili-Quantita_
                    where ID=Variante_;
				end if;
                
            elseif Categoria_ = 'Categoria C' then
				select V.Cat_C_Disponibili into Disponibili
				from variante V
				where V.ID=Variante_;
                
                if Disponibili<Quantita_ then
					signal sqlstate '45000'
                    set message_text = 'Non sono presenti abbastanze unità ricondizionate';
                else
					insert into Carrello values(Variante_,Categoria_, Ordine_, Quantita_);			-- le unità disponibili bastano a "coprire" l'ordine
					update variante
                    set Cat_C_Disponibili=Cat_C_Disponibili-Quantita_
                    where ID=Variante_;
				end if;
			END IF;
      	else 
			signal sqlstate '45000'
            set message_text='Ordine già presente non in processazione';
		END IF;
END;
$$
DELIMITER ;

drop procedure if exists checkOrdine ;
DELIMITER $$
create procedure checkOrdine(IN Ordine_ int)
BEGIN
	
    declare controllo int default 0;
	-- controlliamo che l'ordine preso in input non sia un ordine "vuoto", ovvero le cui varianti ordinate sono tutte pendenti
	select distinct 1 into controllo
    from carrello
    where Ordine=Ordine_;
    
    if controllo=0 then
		-- se l'ordine è vuoto si elimina
        delete from ordine where ordine.Codice=Ordine_;
	end if;
END; $$
DELIMITER ;


-- ----------------------------
--  operazione 1 parte due:
-- 	Triggers per mantenere aggiornate le ridondanze legate alla prima funzione
-- ----------------------------

drop trigger if exists aggiornaNuoveDisponibili;
DELIMITER $$
create trigger aggiornaNuoveDisponibili after insert on lotto_produzione
for each row
BEGIN
	DECLARE N_unita int default 0;
    DECLARE var int;
    DECLARE daProd int default 0;
    
    select V.ID, P.NumeroUnitaLotto into var, N_unita
    from lotto L inner join variante V on L.Variante=V.ID inner join prodotto P on V.Prodotto=P.ID
    where L.codice=new.Codice;
    
    
    select UnitaDaProdurre into daProd
    from Variante
    where id = var;
    
    if N_unita >= daProd then		-- delle unità prodotte, alcune potrebbero essere "risevate" per gli ordini pendenti
		SET N_unita=N_unita-daProd;
        
		update variante
		set NuoveDisponibili = NuoveDisponibili + N_unita, UnitaDaProdurre = 0
		where ID=var;
	 else 								-- le unità prodotto sono meno di quelle che servono per "coprire" gli ordini pendenti
		update variante
        set UnitaDaProdurre = UnitaDaProdurre - N_unita
        where ID=var;
	end if;
END;
$$
DELIMITER ;

drop trigger if exists  aggiornaDisponibiliRicondizionate ;
DELIMITER $$
create trigger aggiornaDisponibiliRicondizionate after insert on ricondizionati
for each row
BEGIN
    DECLARE var int;
    DECLARE categoria varchar(50);
    
    select V.ID, P.NumeroUnitaLotto into var,categoria
    from unita
    where Codice=new.Unita;
    
    case
		when categoria='Categoria A' THEN
			update variante
            SET Cat_A_Disponibili = Cat_A_Disponibili +1
            where ID=var; 
        when categoria='Categoria B' THEN
			update variante
            SET Cat_B_Disponibili = Cat_B_Disponibili +1
            where ID=var; 
        when categoria='Categoria C' THEN
			update variante
            SET Cat_C_Disponibili = Cat_C_Disponibili +1
            where ID=var; 
	END CASE;
END;
$$ 
DELIMITER ;

-- ---------------------------------------------------
-- Event per operazione 2
-- ---------------------------------------------------

DROP EVENT if exists production;
CREATE EVENT IF NOT EXISTS production
ON SCHEDULE EVERY 1 DAY
STARTS '2020-12-01 22:00:00' 
DO select V.ID, P.Nome as Prodotto, P.Modello, V.Nome as Variante, Floor(V.UnitaDaProdurre/NumeroUnitaLotto) as NumeroLotti
   from variante V inner join Prodotto P on V.Prodotto=P.ID;



-- ---------------------------------------------------
-- Procedure funzione 3 (necessita anche di event)
-- ---------------------------------------------------

-- funzione: per ogni ordine in processazione associa le unità da spedire in base a quantità e categoria
DROP procedure if exists associaUnita;
DELIMITER $$
create procedure associaUnita(IN _Ordine int, _Variante int, IN _Categoria varchar(50))	-- solo per un ordine
BEGIN
	
    DECLARE unita 		int default 0;
    DECLARE quantita 	int default 0;
    
    select C.Quantita into quantita
    from carrello C
    where C.Variante=_Variante and C.Ordine=_Ordine and C.Categoria=_Categoria;
    
    ciclo: LOOP
		-- preleva l'unita più antica
		select UO.Unita into unita
		from unita_disponibili_ordine UO inner join unita U on UO.Unita=U.Codice	-- join per la data di produzione
		where UO.Variante=_Variante and UO.Categoria=_Categoria and U.DataProduzione = ( select min(U2.DataProduzione) 
																						 from Unita U2 inner join unita_disponibili_ordine UO2 on U2.Codice=UO2.Unita
                                                                                         where
																							U.Variante = _Variante and
																							U.Categoria = _Categoria
																						)
		limit 1;
        
		-- associa unità all'ordine
		update unita U
		set U.Ordine=_Ordine
		where U.Codice=unita;
        
		-- elimina unità associata dalle disponibili
		delete from unita_disponibili_ordine UDO where UDO.Unita=unita;
		
        -- Condizione di uscita dal ciclo
        SET quantita=quantita-1;
        IF(quantita=0) THEN 
			leave ciclo;
        END IF;
    END LOOP;
END; $$
DELIMITER ;




-- event terza funzione
drop event if exists associa_unita;
DELIMITER $$
create event associa_unita
on schedule every 1 DAY
starts '2020-12-01 20.30'
DO BEGIN
	DECLARE finito int default 0;
    DECLARE Ordine_ int;
    DECLARE Variante_ int;
    DECLARE Categoria_ varchar(50);
    
    DECLARE ordini cursor for
    select O.Codice,C.Variante,C.Categoria
    from Ordine O inner join carrello C ON O.Codice=C.Ordine
    where O.Stato="Processazione";
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito=1;
    
    open ordini;
    ciclo: LOOP
		fetch ordini into Ordine_,Variante_,Categoria_;
        call associaUnita(Ordine_,Variante_,Categoria_);		-- associo, per ogni ordine, le unità da spedire
        
        UPDATE ordine											-- l'ordine deve essere ora solo preparato per la spedizione
        SET Stato="Preparazione"
        WHERE Codice=Ordine_;
        
        IF finito=1 THEN
			leave ciclo;
		end if;
    END LOOP;
    close ordini;
END;
$$
DELIMITER ;

-- ------------------------------------------------
-- Operazione 4
-- ------------------------------------------------

-- creare la sequenza 
-- creare tabella: codice parte | codice padre | livello | numero random
-- ordinare tabella per: order by livello, padre, numero random
-- "prelevare" record per record con stesso padre e con sottoparte successiva ed inserire in operazioni della sequenza
-- order by: se montaggio, ordine decrescente / smontaggio ordine crescente (in ingresso anche il livello)


DROP PROCEDURE IF EXISTS creazione_tabella;
DELIMITER $$
CREATE PROCEDURE creazione_tabella(IN _variante int, IN _tipologia int,IN _livello int)	-- tipologia 1 montaggio, 2 smontaggio
/* livello indica fino a quale livello di profondità si vuole smontare un oggetto se la sequenza è di smontaggio, 
questo parametro verrà preso in considerazione solo in quel caso*/
BEGIN
	
	drop temporary table if exists parti_livello; 			-- temporary table di appoggio per "creare una struttura ad albero generico"
	create temporary table parti_livello(
		Parte int,
		Padre int,
		Livello int,
		Num_random double,
		PRIMARY KEY (Parte,Padre,Livello)
    );
    
    drop temporary table if exists tmp;						-- tabella di appoggio per poter scorrere la tabella e popolarla contemporaneamente
    create temporary table tmp like parti_livello;			-- in quanto una tabella temporary non può essere aperta due volte durante la stessa query
    
    -- INSERIEMO LE MACRO-PARTI CHE COMPONGONO LA VARIANTE NELLA TEMPORARY TABLE
    insert into parti_livello
		select S.Parte as Parte, 0, 1, rand()
		from variante V inner join strutturazione S on S.Prodotto=V.Prodotto 
		where V.ID=_variante
		UNION
		select D2.Parte as Parte, 0, 1, rand()
		from differenze D2
		where D2.Variante=_variante;
	
    insert into tmp select * from parti_livello;		-- copia della tabella, per il motivo di sopra (vengono mantenute due uguali, una scorre e l'altra viene modificata)
    
    BEGIN
		DECLARE levels 	int default 1;
        DECLARE padre 	int;
		DECLARE finito 	int default 0;
		DECLARE parti 	CURSOR FOR
		 -- recuperiamo le "macro-parti" che formano la nostra variante
		select Parte, Livello
        from parti_livello
        where livello=levels;			-- prendere le parti livello per livello
        
        /*ragionamento: temporary a e temporary b
        inizio loop interno: scorro a con il cursore e popolo b, chiudo il cursore fine loop interno, replace a con b; */
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito=1;
        
		livelli: LOOP					-- loop esterno che scorre i livelli
       
			open parti;
			popolamento: LOOP			-- loop interno che modifica la tabella temporanea con i nuovi inserimenti (in quanto la tmp sarà sempre un passaggio avanti)
				fetch parti into padre,levels;
                
                -- se la tipologia è di smontaggio potremmo non voler smontare tutto, per cui si verifica se abbiamo raggiunto il livello di uscita
				if(_tipologia=2 AND levels >= _livello ) then
					leave livelli;		-- abbiamo già inserito tutte le parti fino al livello che si vuole smomntare
				
                -- in caso contrario viene aggiornata la tmp con i valori inerenti al nuovo livello
                else
					insert into tmp
							select *
							from (select F.SottoParte,F.Parte,levels+1,rand()						-- per ogni valore della temporary table inseriamo i figli
								  from formazione F inner join parti_livello P on F.Parte=P.Parte
								  where F.parte=padre) as D; 
				end if;	
                
				if finito = 1 then
					leave popolamento;
				end if;
			END LOOP;
        close parti;
        
        set finito=0;		-- viene riazzerata la variabile di controllo in quanto a ogni passaggio si verificherà un "not found"
        
        replace into parti_livello select * from tmp; -- aggiorniamo
        set levels=levels+1;
        
        if levels>(select ifnull(max(Livello), 0) from tmp) then			-- se la variante levels è maggiore del max livello, significa che l'ultima select ha dato risultato nullo, quindi abbiamo finito le parti
			leave livelli;													-- e' stato inoltre introdotto l'ifnull per evitare che il confronto generi un null creando un loop infinito
		end if;
		END LOOP; 
   END;
END; $$
DELIMITER ;


drop procedure if exists creazione_sequenza;
DELIMITER $$
CREATE PROCEDURE creazione_sequenza(IN _variante int, IN _tipologia int, IN _livello int)		-- tipologia 1 montaggio, tipologia 2 smontaggio
BEGIN
	DECLARE finito int default 0;
    DECLARE parte_1 int;
    DECLARE parte_2 int;
    DECLARE ordine_ int default 1;
    DECLARE operazione_ int;
    DECLARE seq int;
    
    -- creazione sequenza
    insert into sequenza(Tipologia,Variante) values (_tipologia,_variante);	-- creo la sequenza
	-- inizializzazione seq
    select max(Codice) into seq
    from sequenza;
    
	call creazione_tabella(_variante,_tipologia,_livello);			-- creo la tabella di appoggio
	-- per non ricopiare inutilmente il codice, moltiplichiamo per -1 così da avere l'ordine inverso usando la stessa query
    
    
    if _tipologia=2 then
		SET SQL_SAFE_UPDATES = 0;
		UPDATE parti_livello
        SET Livello=Livello*(-1);
        SET SQL_SAFE_UPDATES = 1;
    end if;
    
    BEGIN
		DECLARE partiOP cursor for						-- recupero coppie di parti (esistono tutte le operazioni per montare parti allo stesso livello)
        select Parte1,Parte2 from(
			select P.Parte as Parte1, lead (parte,1) over (	partition by P.padre, P.livello
															order by P.Livello, P.Num_random desc) as Parte2, P.Livello
			from parti_livello P
        ) as D
        
        where Parte2 is not null 
		order by D.Livello desc;
		
		declare continue handler for not found set finito=1;
		
		open partiOP;
		op_sequenze: LOOP
			
			fetch partiOP into parte_1, parte_2;
            
			-- recupero un'operazione
			select O.ID into operazione_
			from operazione O
			where ((O.Parte1=parte_1 and O.Parte2=parte_2) 
					OR
				(O.Parte1=parte_2 and O.Parte2=parte_1))  and  tipologia=_tipologia
			LIMIT 1;
			
            if finito=1 then
				leave op_sequenze;
			end if;
            
			insert into operazioni_della_sequenza(Ordine,Operazione,Sequenza) values(ordine_,operazione_,seq);
			-- ordine è contatore, operazione presa prima nella variabile e sequenza presa in ingresso
			SET ordine_=ordine_+1;
            
            
		END LOOP;
		close partiOP;
    END;
END; $$

DELIMITER ;

-- ------------------------------------------------
-- Operazione 5
-- ------------------------------------------------
DROP PROCEDURE IF EXISTS orari_disponibili_intervento;
DELIMITER $$
CREATE PROCEDURE orari_disponibili_intervento(IN _centroAssistenza int, IN _data date, IN _ore int)
BEGIN
	DECLARE intervento int;
    DECLARE tempoPrevisto int;
    DECLARE oraInizio int;
    DECLARE numero_tecnici int default 0;
    DECLARE finito int default 0;
    
    DECLARE interventi cursor for
    -- si prelevano gli interventi e il numero di ore previste
    select I.ID,I.Ora,IFNULL(R.TempoPrevisto,1) as TempoPrevisto			-- tempo previsto di default 1 ora (ad esempio se non è un intervento di riparazione)							
    from intervento I left outer join riparazione R ON I.ID=R.Intervento
    where I.CentroAssistenza=_centroAssistenza and I.Data=_data;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito=1;
    
    -- temporary table necessaria per dividere gli interventi che durano più di un'ora e poter effettuare in seguito join e ragguppamenti
    drop temporary table if exists tabella_interventi;
    create temporary table tabella_interventi(
		ID int, 			-- identifica l'intervento
        FasciaOraria int,
        PRIMARY KEY (ID,FasciaOraria)
    );
    
    open interventi;
    preleva: LOOP
		fetch interventi into intervento,oraInizio,tempoPrevisto;
        IF finito=1 THEN
			leave preleva;
		END IF;
        
        -- LOOP INTERNO
        inserimenti: LOOP
         
            insert into tabella_interventi values (intervento,oraInizio);
            
            -- decremento e condizione di uscita
            SET tempoPrevisto=tempoPrevisto-1;
			IF TempoPrevisto = 0 THEN
				leave inserimenti;
			ELSE
				SET oraInizio=oraInizio+1;		-- l'ora d'inizio viene aggioranata per la prossima fascia oraria
			END IF;
        END LOOP;
        
    END LOOP;
    close interventi;
    
    -- RECUPERIAMO IL NUMERO DI TECNICI CHE LAVORANO IN QUEL CENTRO ASSISTENZA
    select count(*) into numero_tecnici	
    from tecnico
    where CentroAssistenza=_centroAssistenza;

BEGIN
    DECLARE i int default 8;
    DECLARE finito2 int default 0;
    declare contatore int default 0;
    declare tmp 	  int default 0;
    
    DECLARE c CURSOR for 
		with orari as (
			select 8 as n union select 9 as n union select 10 as n union select 11 as n union select 12 as n union select 13 as n union select 14 as n union select 15 as n union select 16 as n union select 17 as n
		)
		select NumeroTecniciDisponibili from
		(
			select n as FasciaOraria, numero_tecnici-count(distinct T.id) as NumeroTecniciDisponibili
			from tabella_interventi T right outer join orari O on T.FasciaOraria= O.n
			group by n
		) as D
		where FasciaOraria >= i;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito2 = 1;
    
    drop temporary table if exists orariDisponibili;
    create temporary table orariDisponibili (
		oraInizio int
    );
    
    primoCiclo: LOOP				-- controlliamo di non andare otlre le 18
		if (i+ _ore > 18) then
			leave primoCiclo;
        end if;

		open c;
		secondoCiclo: LOOP			-- apriamo il cursore in modo tale da partire ogni volta dal record successivo, ad esempio: prima iterata partiamo dalla fascia oraria 8, alla seconda iterata partiamo dalle 9
			FETCH c into tmp;
        
				if (tmp = 0) then		-- non abbiamo abbastanze tecnici per n _ore di fila a partire dalla fascia oraria i
					leave secondoCiclo;
                
                else
					set contatore = contatore + 1;
                end if;
                
                if (contatore = _ore) then				-- controllo: abbiamo abbastanza tecnici per _ore di fila?
					insert into OrariDisponibili values (i);
                    leave secondoCiclo;
                end if;
                
                if finito2=1 then
					leave secondoCiclo;
                end if;

        END LOOP secondoCiclo;
        close c;
        set finito2 = 0;
        set i = i+1;									-- controlliamo a partire dalla fascia oraria i+1
		set contatore = 0;
    END LOOP primoCiclo;
     select * from orariDisponibili;
END;
END; $$
DELIMITER ;


-- ------------------------------------------------
-- Operazione 6
-- ------------------------------------------------

-- Ad ogni tecnico vengono associati gli interventi da effettuare in quel giorno (PROCEDURE UTILIZZATA DALL'EVENT)
drop procedure if exists associa_tecnico;
DELIMITER $$
create procedure associa_tecnico (IN _tecnico char(16), IN _data date)
BEGIN
	DECLARE ora int default 8;
    DECLARE durata int default 1;
    DECLARE centroAssistenza_ int;
    
    -- viene recuperato il centro assistenza in cui il tecnico lavora
    Select T.CentroAssistenza into centroAssistenza_
    from tecnico T
    where 
		T.CodiceFiscale = _tecnico;
    
    riempi_tecnico: LOOP
						-- ASSEGNO AL TECNICO IL PRIMO INTERVENTO DISPONIBILE PER QUELL'ORA
						UPDATE intervento I
						SET I.Tecnico = _tecnico
						where I.Data=_data and I.Ora=ora and I.Tecnico is NULL and I.CentroAssistenza = centroAssistenza_;
                        
                        -- recupero l'interveno appena assegnato per conoscere la durata
                        select IFNULL(R.TempoPrevisto,1) into durata			-- numero di ore previste per l'intervento
                        from intervento I left outer join riparazione R on I.ID=R.Intervento
                        where I.Data=_data and I.Ora=Ora and I.Tecnico=_tecnico;
                        
                        -- INCREMENTO ORA DI INIZIO, PERCHE' PRIMA DI ALLORA IL TECNICO E' OCCUPATO CON ALTRI INTERVENTI
                        SET ora=ora+durata;
                        
                        IF ora > 17 THEN			-- supponendo che un tecnico lavori dalle 8 alle 18
							leave riempi_tecnico;
						END IF;
	END LOOP;
END $$
DELIMITER ;

-- event operazione numero 6
 DROP EVENT IF EXISTS pianifica_turni;
 DELIMITER $$
 CREATE EVENT pianifica_turni
 ON SCHEDULE EVERY 1 WEEK
 STARTS "2020-12-02 03:00:00"
 DO
 BEGIN
	
    DECLARE giorni int default 0;  -- contatore per scorrere i giorni della settimana, event eseguito una volta a settimana di lunedì
    DECLARE tecnico char(16) default "";
    DECLARE finito int default 0;
    DECLARE tecnici CURSOR FOR 
    select T.CodiceFiscale
    from tecnico T;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito=1;
    
    open tecnici;
    scorri: LOOP 							-- scorre i tecnici (per fare assegnamenti)
        fetch tecnici into tecnico;
        SET giorni = 0;
        
        assegna: LOOP 
					CALL associa_tecnico(tecnico, current_date + INTERVAL giorni DAY);	-- per ogni tecnico si associa gli interventi del giorno
                    SET giorni=giorni+1;
                    IF giorni > 4 THEN 
						leave assegna;
					END IF;
		END LOOP;
        
		IF finito=1 THEN
			leave scorri;
		END IF;
    END LOOP;
    close tecnici;
 END;
 $$
 DELIMITER ;
 
 
-- ------------------------------------------------
-- Operazione 7
-- ------------------------------------------------
-- funzione: dato un codice lotto, vedere quali sono i settori dispnibili per lo stoccaggio
drop procedure if exists stoccaggio_lotto;
DELIMITER $$
create procedure stoccaggio_lotto (IN _codiceLotto int)
BEGIN
	-- vengono recuperati i settori inerenti al prodotto che bisogna stoccare
	with settoriInerenti as (
			select  S.id, S.Magazzino, S.capienza
			from settore S
			inner join Variante V on S.prodotto = V.prodotto
			where
				V.id = (select Variante
						from lotto 
						where Codice=_codiceLotto)
		),
		
		-- vengono contati i lotti stoccati per ciascun settore
		stoccati as (
			select SI.id as Settore, SI.magazzino, count(*) as stoccati 
			from stoccaggio S
				 inner join settoriInerenti SI ON S.Settore=SI.id
			where DataFine IS NULL				-- per prendere i lotti stoccati in questo momento si prende quelli in cui la data di fine è null (quindi sono ancora presenti)
			group by SI.id, SI.magazzino
		)
		
		-- vengono selezionati soltanto i settori che hanno almeno un posto libero in cui è possibile stoccare un lotto
		select Si.id, SI.Magazzino
		from SettoriInerenti SI left outer join stoccati S on S.settore = SI.id
		where 	SI.capienza > ifnull(S.stoccati, 0); -- un settore potrebbe essere vuoto, in tal caso deve essere ugualmente considerato (null verrebbe scartato)
		
    
END $$
DELIMITER ;

-- ------------------------------------------------
-- Operazione 8
-- ------------------------------------------------

-- funzione: per ogni linea deve restituire il numero di scarti per ogni stazione e il numero di operatori che hanno causato tali scarti
DROP PROCEDURE IF EXISTS analisi_linea;
DELIMITER $$
CREATE PROCEDURE analisi_linea(IN _linea int, IN _data date)	-- si cerca l'informazione a livello giornaliero
BEGIN
	
    drop temporary table if exists analisi_linea;	-- serve per restituire com valore un result-set, per vedere il risultato fare select su analisi_linea
    create temporary table analisi_linea(
		Linea int,
        Stazione int,
        Scarti int,
        NumOperatori int,
        PRIMARY KEY(Linea,Stazione)
	);
	
    insert into analisi_linea 
		select _linea, E.Stazione, count(*) as Scarti, count(distinct E.Operatore) as NumOperatori
		from scarto ST inner join operazioni_della_sequenza OS on ST.OperazioneSequenza=OS.ID inner join esegue E on OS.ID=E.OperazioneSequenza
		-- vediamo quale è stata l'ultima operazione prima dello scarto, in seguito vedo dove è stata eseguita
		where ST.Data=_data and ST.Linea=_linea 		-- scarti di quel giorno e di quella linea
		group by E.Stazione; 							-- raggruppiamo per stazione
END
$$
DELIMITER ;

-- event funzione 8
DROP EVENT IF EXISTS analisi_linea;
DELIMITER $$
CREATE EVENT analisi_linea
ON SCHEDULE EVERY 1 DAY
STARTS "2020-12-01 19:00:00"
DO
BEGIN
	DECLARE linea int;
	DECLARE finito int default 1;
    DECLARE linee cursor for
    select Codice
    from linea;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito=1;
    open linee;
    ciclo: LOOP
		fetch linee into linea;
        call analisi_linea(linea,current_date);
        IF finito=1 THEN
			leave ciclo;
		END IF;
	END LOOP;
    
    select *
    from analisi_linea;
END;
$$
DELIMITER ;


-- funzione: restituire data una variante tutti test e i sotto test connessi
-- ------------------------------------------------
-- Operazione numero 9
-- ------------------------------------------------
drop procedure if exists Test_tree;
DELIMITER $$
create procedure Test_tree (in _variante int)
BEGIN

    declare test_	int;
    declare livello_ int default 1;
    declare finito int default 0;
	declare c cursor for (select codice from tutti_test where livello = livello_);
	declare continue handler for not found set finito = 1;
    
    -- tabella di appoggio per elencare  tutti i test presenti
    drop temporary table if exists tutti_test;
    create temporary table tutti_test (
		codice int,
        Nome varchar(50),
        padre int,
        livello int,
        
        PRIMARY KEY (codice, padre)		-- padre fa parte della primary key in quanto uno stesso test potrebbe far parte di due test differenti (anche a un livello differente)
    );
    
    -- viene riempita la prima tabella con tutti i test del primo livello della variante
    insert into tutti_test
    select T.Codice, T.nome, 0, 1							-- con 0 si indica  la radice dell'albero
    from livello1_test_tree L1 inner join Test T
		on T.codice = L1.test
	where
		L1.Variante = _variante;
	
    -- viene aggiunto alla tabella tutti i sottotest fino a esaurirli
    esterno: LOOP
		open c;
		aggiunta: LOOP
			
			-- viene preso un test dalla lista
			fetch c into test_;
			
			-- condizione d'uscita
			if finito = 1 then
				leave aggiunta;
			end if;
            
			-- vengono presti tutti i sottotest dove test_ è padre
			insert into tutti_test
			select T.codice, T.nome, ST.TestPadre, livello_ + 1 
			from sotto_test ST
				inner join Test T on ST.TestFiglio = T.codice		-- completo l'informazione prendendendo i dettagli del test figlio
			where ST.TestPadre = test_; 
			
		end LOOP aggiunta;
		close c;
 
        set finito = 0;
        -- viene aggiornato il livello
		set livello_ = livello_ + 1;
	
        if (select ifnull(max(Livello), 0) from tutti_test) < livello_ then 
			leave esterno;
        end if;

	end loop esterno;
    
    -- selezione finale da restituire
    select * from tutti_test order by livello asc;
END $$
DELIMITER ;


-- ------------------------------------------------
-- Operazione numero 10
-- ------------------------------------------------

-- Dato il codice di un’unità, un guasto e una parte verificare se l’unità è coperta da garanzia

DROP PROCEDURE IF EXISTS garanzia;
DELIMITER $$
CREATE PROCEDURE garanzia(IN _unita int, IN _guasto int, IN _parte int, OUT garanzia_ varchar(50))
BEGIN
	
    SET garanzia_ = NULL;
    
	select "Garanzia produttore" into garanzia_			-- si va a vedere se l'unità è coperta dalla garanzia di 24 mesi
    from unita U inner join ordine O on U.Ordine=O.Codice
    where U.Codice=_unita and O.DataEvasione + INTERVAL 2 YEAR  >= current_date;
    
    if garanzia_ IS NULL then
		select concat("Estensione di garanzia numero: ",E.Codice) into garanzia_
        from unita U inner join estensione_garanzia E on U.EstensioneGaranzia=E.Codice 
			inner join copertura_guasto C on C.EstensioneGaranzia=E.Codice
            inner join ordine O on U.Ordine=O.Codice
        where U.Codice=_unita and C.Guasto=_guasto and O.DataEvasione + INTERVAL E.Validita MONTH >= current_date; 
    end if;
    
    if garanzia_ IS NULL then
		select "Garanzia di riparazione" into garanzia_
        from richiesta_intervento R inner join intervento I on R.Ticket=I.Ticket 
			inner join riparazione RP on I.ID=RP.Intervento 
            inner join sostituzione_parte SP on SP.Riparazione=RP.ID
        where R.unita=_unita and I.Data + INTERVAL 1 YEAR >= current_date and SP.Parte=_parte;
    end if;

END;	$$
DELIMITER ;

-- ------------------------------------------------
-- Operazione numero 11
-- ------------------------------------------------
-- funzione: dato un guasto restituisce tutte le domande ed eventuali rimedi (in ordine)
drop procedure if exists assistenzaVirtuale;
DELIMITER $$
create procedure assistenzaVirtuale(IN _Guasto int)
BEGIN
	select distinct Domanda, Ordine, Descrizione
    from assistenza_virtuale AV
		inner join rimedio R on R.codice = AV.rimedio 
    where Guasto=_Guasto
    order by Ordine;
END;
$$
DELIMITER ;

drop procedure if exists cerca_codice;
DELIMITER $$
create procedure cerca_codice (in prodotto_ int, in codice_errore int, in descrizione varchar(250))
BEGIN
	if (codice_errore = -1) then
		select * from guasto inner join Errore E on E.guasto = guasto.codice
        where guasto.descrizione like concat("%", descrizione, "%") and
        E.prodotto = prodotto_;
    
    else
		call assistenzaVirtuale( (select guasto from Guasto inner join Errore E on E.guasto = guasto.codice where codiceErrore = codice_errore and E.prodotto = prodotto_) );
    end if;
END $$
DELIMITER ;

-- ------------------------------------------------
-- Operazione numero 12
-- ------------------------------------------------
-- funzione: data una recensione, si verifica che questa sia stata effettuata da qualcuno che ha realmente compiuto l'ordine.
-- NB: Viene concesso anche a chi non è ancora arrivato il prodotto di effettuare una recensione in quanto in caso contrario, 
--     in seguito a una eventuale frode, non sarebbe possibile restituire un feedback negativo.
drop procedure if exists controllo_recensione;
DELIMITER $$
create procedure controllo_recensione (in _variante int, in _data date)
BEGIN        
SET SQL_SAFE_UPDATES = 0;

delete 
from recensione
        where (variante, account) in
        (
			-- seleziono solo le varianti e relativo account che non sono connesse a nulla
			select R.variante, R.account
			from (select * from recensione R1 where R1.data = _data and R1.Variante = _variante) as R left outer join (
			
							-- vengono prelevate le varianti e il relativo account per ciascun ordine realmente effettuato
							select C.variante, O.account
								from ordine O
								inner join Carrello C on O.Codice = C.ordine
								natural join recensione R
								where
									R.data =  _data	
				
			) as D							-- si effettua un left outer join tra tutte le recensioni e quelle realmente ottenute in modo da mantenere solamente quelle fasulle
			
			on R.variante = D.variante and R.account = D.account
			where D.account is null
		);
SET SQL_SAFE_UPDATES = 1;
END $$
DELIMITER ;
-- invece di procedura faccio event con controllo su solo data in cui chiamato

DROP EVENT IF EXISTS rimuovi_recensioni;
DELIMITER $$
create event rimuovi_recensioni 
	on schedule every 1 day 
	starts "2021-01-01 23:59:50" 
    DO
    BEGIN
    declare variante_ 	int;
    declare finito 		int default 0;
    
    declare c cursor for (select R.variante from Recensione R where R.data = current_date);
	declare continue handler for not found set finito = 1;

    open c;
    controllo: LOOP
        fetch c into variante_;
		
        call controllo_recensione(variante_, current_date);
        if (finito = 1) then leave controllo;
        end if;
        
    end loop controllo;
    close c;
	END $$
DELIMITER ;



-- ------------------------------------------------
-- ANALYTICS 1
-- ------------------------------------------------

drop procedure if exists CBR_reuse;
DELIMITER $$
create procedure CBR_reuse(IN Guasto_ int ,IN Sintomi_ varchar(250) )
BEGIN
	declare sintomi_totali int;
	
    -- la tabella viene utilizzata per memorizzare i sintomi inseriti come record distinti    
	drop temporary table if exists sintomi_attuali;
	create temporary table sintomi_attuali(Sintomo varchar(250));

	-- scriviamo la query dinamica concatenendo la parte "fissa" (l'inserimento) con quella variabile (la lista dei sintomi)
	set @dynamic_query = concat('replace into sintomi_attuali values ', Sintomi_,';');
	
	PREPARE sql_statement FROM @dynamic_query;  -- si prepare la query all'esecuzione
	EXECUTE sql_statement;						-- si esegue la query dinamica
   
   -- OUTPUT DELLA QUERY
   -- viene contato il numero di sintomi totali inseriti dal tecnico
   
	select count(*) into sintomi_totali from sintomi_attuali;
    
    -- vengono presi tutti i sintomi che hanno il guasto inserito
	with sintomi_casi_guasto as 	(select SC.*
									 from sintomi_caso SC inner join (	select C.Codice
																		from caso C
																		where C.Guasto=Guasto_
																	 ) AS C2 
									on SC.Caso=C2.Codice
	)
    
    select D.Caso,((Trovati/Totale) - if((Trovati/Totale)=1, if((Totale/D.N)<1,((Trovati/Totale)-(Totale/D.N)),0),0)) as Ranking 	-- viene effettuato il calcolo del ranking; diamo in outup il caso memorizzato e il suo rank (in modo da mostrare con numero più basso i migliori)
    from (
			  select 	SC.Caso ,count(distinct SA.sintomo) as Trovati, count(*) as Totale, ST.N 												-- selezioniamo il caso, il numero dei suoi sintomi, il numero totale dei sintomi del caso
              from sintomi_attuali SA right outer join sintomi_casi_guasto SC on SA.sintomo = SC.sintomo 								-- right outer join perchè vengono mantenuti tutti i casi, anche quelli che non hanno
					cross join (select sintomi_totali as N) as ST																						-- un sintomo in comune (che avranno ranking più basso).
			  group by SC.Caso																											-- raggruppiamo per caso (in quanto si vuole fare il rank sul caso) 
	) AS D
    order by Ranking desc;																												-- ranking maggiore significa più alto in classifica (motivo di desc);
END;
$$
DELIMITER ;



-- equivalente della reuse
drop procedure if exists CBR_show_solutions;
DELIMITER $$
create procedure CBR_show_solutions(IN Caso_ int)
BEGIN
    select SC.Soluzione									-- prende in input un caso e restituisce
    from soluzioni_caso SC								-- i passaggi che devono essere svolto
    where SC.Caso=Caso_;								-- per giungere alla soluzione
END;
$$
DELIMITER ;



drop procedure if exists CBR_retain;
DELIMITER $$
create procedure CBR_retain(IN Caso_ int,IN Soluzioni_ varchar(250), IN Sintomi_ varchar(250))
BEGIN
	DECLARE ranking double default 0;									-- variabile per memorizzare il ranking della soluzione
    DECLARE soluzioni_totali int;
	DECLARE	questo_caso int default 0;

	drop temporary table if exists soluzioni_adottate;					-- tabella in cui vengono inserite le soluzioni adottate dal tecnico
	create temporary table soluzioni_adottate(Soluzione varchar(250));

	-- scriviamo la query dinamica concatenendo la parte "fissa" (la tabella in cui inserire le informazioni) con quella variabile (i sintomi inseriti) per le soluzioni
	set @query_dinamica_1 = concat('replace into soluzioni_adottate values ', Soluzioni_,';');
	
	PREPARE sql_statement FROM @query_dinamica_1;				-- si prepare la query dinamica
	EXECUTE sql_statement;										-- si esegue la parte dinamica
    
    
    -- si contano il numero di soluzioni adottate in questo caso
	select count(*) into soluzioni_totali from soluzioni_adottate;
    
    select ((Trovati/Totale) - if((Trovati/Totale)=1, if((Totale/D.N)<1,((Trovati/Totale)-(Totale/D.N)),0),0)) as Ranking  into ranking -- calcolo del ranking 
    from (select SC.Caso ,count(distinct SA.Soluzione) as Trovati, count(*) as Totale, ST.N
		  from soluzioni_adottate SA right outer join soluzioni_caso SC on SA.Soluzione = SC.Soluzione 
				cross join (select soluzioni_totali as N) as ST 																					-- cross join utilizzato per "attacare" il numero di soluzioni totali calcolate precedentemente
		  where SC.Caso=Caso_
		  group by SC.Caso) AS D 
          order by Ranking desc 
          limit 1;
    
    IF(ranking < 0.80) THEN
		
        drop temporary table if exists sintomi_riscontrati;
		create temporary table sintomi_riscontrati(Sintomo varchar(250));

		-- dobbiamo memorizzare il nuovo caso, ovvero i sinotmi e le soluzioni adottate
        -- iniziamo popolando la temporary table dei sintomi così da poterli inserire tra i sintomi del caso
		set @query_dinamica_2 = concat('replace into sintomi_riscontrati values ', Sintomi_,';');
	
		PREPARE sql_statement FROM @query_dinamica_2;
		EXECUTE sql_statement;
        
        BEGIN
			declare finito 		int default 0;
            declare controllo 	int default 0;
			declare sintomo_ 	varchar(250);
            declare Guasto_ 	int;
            
            declare sintomi cursor for		-- cursore per scorrere i sintomi inseriti poichè per ogni sintomo dobbiamo fare una insert
            select *						-- nella tabella sintomi_caso
            from sintomi_riscontrati;
            
            declare continue handler for not found set finito = 1;
			
            select C.Guasto into Guasto_			-- recupero il guasto che si è risolto
            from caso C
            where C.Codice=Caso_;
            
            insert into caso(Guasto) values(Guasto_);		-- creazione del caso
			select max(Codice) into questo_caso from caso;  -- recupero il codice del guasto appena creato
           
           -- inserimento dei sintomi nella tabella sintomi_caso
            open sintomi;
            inserimento: LOOP 
            
				fetch sintomi into sintomo_;
                
                if finito=1 then
					leave inserimento;
				end if;
                
                -- controllo se tra i sintomi inseriti è presente un sintomo che non era mai stato riscontrato prima
                select if(SG.Sintomo IS NULL,0,1) into controllo   
                from sintomi_guasto SG
                where SG.Sintomo=sintomo_ and SG.Guasto=Guasto_;
                
                if controllo=0 then		-- se è un sintomo nuovo, inserisco tra i possibili sintomi del guasto
					insert into sintomi_guasto values(sintomo_,Guasto_);
                end if;
				
                insert into sintomi_caso values(sintomo_,questo_caso);		-- inserisco i sintomi tra i sintomi di questo caso
            
            END LOOP;
            close sintomi;
        END;
        
		BEGIN
			declare controllo int default 0;
            declare finito int default 0;
			declare soluzione_ varchar(250);
            
            declare soluzioni cursor for	-- cursore per scorrere le soluzioni inseriti poichè per ogni sintomo dobbiamo fare una insert
            select *						-- nella tabella sintomi_caso
            from soluzioni_adottate;
            
            declare continue handler for not found 
            set finito=1;
           
           -- inserimento delle soluzioni nella tabella soluzioni_caso
            open soluzioni;
            inserimento: LOOP 
				fetch soluzioni into soluzione_;
                
                if finito=1 then
					leave inserimento;
				end if;
                
                -- controllo se tra le soluzioni inseriti è presente una soluzione mai adottata prima
                select 1 into controllo   
                from soluzione S
                where S.Rimedio=soluzione_;
                
                if controllo is null or controllo = 0 then		-- se è una soluzione nuova, inserisco tra le possibili soluzioni
					insert into soluzione values(soluzione_);
                end if;
                
				insert into soluzioni_caso values(soluzione_, questo_caso);
            
				
            END LOOP;
            close soluzioni;
        END;
	END IF;
END;
$$
DELIMITER ;



-- ------------------------------------------------
-- ANALYTICS 2
-- ------------------------------------------------
drop procedure if exists efficienza_processo;
DELIMITER $$
create procedure efficienza_processo(IN _variante int, IN _data timestamp)
BEGIN
		drop temporary table if exists efficienza_;
		create temporary table efficienza_(
				Variante int,
                Sequenza int,
                IndiceTempo double,
                IndiceRotazioni double,
                IndiceScarti double,
                Efficienza double,
                PRIMARY KEY(Variante,Sequenza));
        
        insert into efficienza_
		with tempi_medi AS(
					select S.Codice as Sequenza, 
						avg(timestampdiff(MINUTE,IFNULL(LP.DataFineProduzione,current_date),LP.DataInizioProduzione))/
						avg(timestampdiff(MINUTE,LP.DataFineProduzionePrevista,LP.DataInizioProduzione)) as Coeff_Tempo -- tempi calcolati in minuti
                        
					from sequenza S inner join assegnamento A ON S.Codice=A.Sequenza inner join lotto_produzione LP on LP.Linea=A.Linea
					where S.Variante=_variante and Tipologia=1 and A.Data < LP.DataInizioProduzione and LP.DataInizioProduzione > _data - interval 1 year
					and A.data < _data 
					and NOT EXISTS (
							select 1 -- non esiste un assegnamento di un'altra sequenza alla stessa linea dopo la data A ma prima dell'inizio produzione
							from assegnamento A2 
							where S.Codice<>A2.Sequenza and A.Linea=A2.Linea and A2.Data > A.Data and A2.Data <= LP.DataInizioProduzione)
					group by S.Codice),
            
			numero_stazioni AS(			
			select S.Codice, count(distinct E.Stazione) as NStazioni					
			from operazioni_della_sequenza OS inner join sequenza S on OS.Sequenza=S.Codice inner join esegue E on OS.ID=E.OperazioneSequenza
			where S.Variante=_variante and S.Tipologia=1 -- prendiamo tutte le operazioni di tutte le sequenze del tipo richiesto che operano sulla variante
				and ((E.DataInizio BETWEEN (_data - INTERVAL 1 YEAR) AND _data) -- inizio nel periodo 
					OR
                   (E.DataFine BETWEEN (_data - INTERVAL 1 YEAR) AND _data)  -- finito nel periodo
                   OR
                   (E.DataInizio< _data - INTERVAL 1 YEAR AND (( E.DataFine > _data) OR E.DataFine IS NULL)) -- inizio e fine fuori dal periodo
			)
            group by S.Codice),
            
			numero_rotazioni AS(
			select D.Codice, sum(if (D.Faccia <> D.Cambio,1,0)) as Rotazioni
			from (select S.Codice, OS.Operazione, O.Faccia, 			-- CodiceSequenza, CodiceOperazione,FacciaOp,FacciaOperazionePrecedente 
						lag(O.Faccia,1) over(Partition by S.Codice			-- prendo il valore della facci dell'operazione precedente
										     order by OS.Ordine) as Cambio 
				from sequenza S inner join operazioni_della_sequenza OS on S.Codice=OS.Sequenza inner join operazione O on O.ID=OS.Operazione
				where S.Variante=_variante and S.Tipologia=1) as D
			group by D.Codice
			),
            
			numero_scarti AS(
			select S.Codice, count(*) as NumScarti -- per ogni operazione della sequenza andiamo a vedere quali sono gli scarti effettuati nell'ultimo anno
			from operazioni_della_sequenza OS inner join sequenza S on OS.Sequenza=S.Codice inner join scarto ST on OS.ID=ST.OperazioneSequenza
			where S.Variante=_variante and S.Tipologia=1 and 
				(ST.Data BETWEEN (_data - INTERVAL 1 YEAR) AND _data)
			group by S.codice),
                
			lottiProdotti as(		-- CTE utile per prelevare il codice dei lotti prodotti con la sequenza presa in input
				select S.Codice as Sequenza, LP.Codice as Lotto                    
				from (assegnamento A natural join lotto_produzione LP) inner join sequenza S on A.Sequenza=S.Codice 
				where S.Variante=_variante and S.Tipologia=1
					   and			-- controllo data assegnamento: vedasi documentazione al capitolo 2.6.2
					   A.Data <= LP.DataInizioProduzione 
				and NOT EXISTS (
						select 1 -- non esiste un assegnamento di un'altra sequenza alla stessa linea e allo stesso lotto dopo la data A ma prima dell'inizio produzione
						from assegnamento A2 natural join lotto_produzione LP2 
						where S.Codice<>A2.Sequenza and A.Linea=A2.Linea and LP.Codice=LP2.Codice 
							  and A2.Data > A.Data and A2.Data < LP2.DataInizioProduzione)
			   and			-- controllo date di produzione
			   ((LP.DataInizioProduzione BETWEEN (_data - INTERVAL 1 YEAR) AND _data) -- inizio nel periodo 
				OR
				(LP.DataFineProduzione BETWEEN (_data - INTERVAL 1 YEAR) AND _data)  -- finito nel periodo
				OR
				((LP.DataInizioProduzione < _data - INTERVAL 1 YEAR) AND (( LP.DataFineProduzione > _data) OR LP.DataFineProduzione IS NULL)))
			),
            
			numero_unita as(
				select LP.Sequenza as Codice, count(*) as NumUnita		-- inizializzazione della variabile n_unita
				from lottiProdotti LP inner join unita U ON LP.Lotto = U.LottoProduzione 
				group by LP.Sequenza
            )
                
            select D.*, 1-(D.tempo*D.rotazioni*D.scarti) as Efficienza
            from (select _variante,S.Codice,T.Coeff_Tempo as tempo,if(NR.Rotazioni is null or NR.Rotazioni=0,1,NR.Rotazioni/NS.NStazioni) as rotazioni,
					if(NU.NumUnita is null, null, if(NSC.NumScarti is null, 0, NSC.NumScarti/NU.NumUnita)) as scarti		-- se il numero di unità è null allora non possiamo calcolare l'efficienza, se la possiamo calcolare ma il numero di scarti è null il rapporto darà zero
					from ((((sequenza S natural left outer join tempi_medi T natural left outer join numero_stazioni NS ) natural left outer join numero_rotazioni NR) natural left outer join numero_scarti NSC)
						natural left outer join numero_unita NU)
					where NU.NumUnita IS NOT NULL		-- altrimenti non potremmo fare la divisione per NumUnita --> non possiamo valutare l'efficienza
                    group by S.codice 
		 ) as D;
END;

$$
DELIMITER ;

-- Creazione tabella
drop table if exists Classifica_Processo;
create table Classifica_Processo(
	Anno int,
	Variante int,
    Sequenza int,
    Efficienza double,
    
    PRIMARY KEY(Anno,Variante, Sequenza)
);

-- event che inserisce i valori nella tabella
drop event if exists classifica_processi_annuali;
create event if not exists classifica_processi_annuali
on schedule every 1 year
starts '2020-12-31 23:30:00'
DO call aggiorna_classifica(current_timestamp);


DROP PROCEDURE IF EXISTS aggiorna_classifica;
DELIMITER $$
CREATE PROCEDURE aggiorna_classifica(in _data timestamp)
BEGIN
	-- dichiarazione cursore e handler, serve per prelevare gli ID delle varianti
    DECLARE finito int default 0;
    DECLARE _variante int;
    DECLARE varianti cursor for
    select V.ID
    from variante V;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito=1;
	
    open varianti;
    ciclo: LOOP
		fetch varianti into _variante;
        
        IF finito=1 THEN 
			leave ciclo;
		END IF;
        
		call efficienza_processo(_variante, _data);
        
		-- PER OGNI VARIANTE INSERIAMO I VALORI NELLA CLASSIFICA
		insert into Classifica_Processo
		select year(_data),D.Variante, D.Sequenza,D.Efficienza 
		from (select *,
			   row_number() over (partition by E.Sequenza
								  order by E.Efficienza) as N
			  from efficienza_ E) as D
		where D.N <=5;
	
	END LOOP;
END;
$$
DELIMITER ;

-- ========================= POPOLAMENTO ====================================


-- ----------------------------
--  Records of 'Classe_prodotto'
-- ----------------------------
BEGIN;
insert into classe_prodotto values ('Telefonia'),('Computer e tablet'),('Foto e video'),('TV'),('Grandi elettrodomestici'),('Piccoli elettrodomestici');
COMMIT;

-- ----------------------------
--  Records of 'Tipologia'
-- ----------------------------
BEGIN;
insert into tipologia values ('Smartphone','Telefonia'),('Auricolari Bluetooth','Telefonia'), ('Smart TV', "TV");
COMMIT;

-- ----------------------------
--  Records of 'Prodotto'
-- ----------------------------
BEGIN;
insert into prodotto(Nome,NumeroFacce,NumeroUnitaLotto,Marca,Modello,Tipologia) values ('iPhone',2,3,'Apple','X','Smartphone'), ('Xiaomi Mi Smart TV',2, 3, 'Xiaomi','Mi Smart','Smart TV');
COMMIT;

-- ----------------------------
--  Records of 'Variante'
-- ----------------------------
BEGIN;
insert into variante(Prezzo,Nome,Prodotto) values (599.99,'64 GB','1'),(649.99,'128 GB','1');
COMMIT;

-- ----------------------------
--  Records of 'parte'
-- ----------------------------
BEGIN;
insert into parte(Codice,Nome,Svalutazione) values(1,'Schermo 5.8 pollici',50),(2,'Touch-screen',70),(3,'Cristalli liquidi',40),(4,'Fotocamera 23 Mpx',20),(5,'Diaframma X',35),(6,'Diaframma Y',35),(7,'Flash',10),(8,'Vetro fotocamera',80),(9,'Processore AMD 2.5 MHz','95'),(10,'Core AMD 2.5',95),(11,'Pin',20),(12,'Scocca nera',15), (13,"Memoria 64", 70),(14,"Memoria 128", 70),(15,'Ram 6 GB', 82), (16,'Connettori memoria 64', 45), (17,'Connettori memoria 128', 45), (18,'Parte della memoria',50);
COMMIT;

-- ----------------------------
--  Records of 'Strutturazione'
-- ----------------------------
BEGIN;
insert into strutturazione values(1,1),(4,1),(9,1),(12,1),(15,1);
COMMIT;

-- ----------------------------
--  Records of 'Differenze'
-- ----------------------------
BEGIN;
insert into differenze values(13,1),(14,2);
COMMIT;

-- ----------------------------
--  Records of 'Formazione'
-- ----------------------------
BEGIN;
insert into formazione values (1,2),(1,3),(4,5),(4,7),(4,8),(9,10),(9,11),(13,16),(13,18),(14,17),(14,18);
COMMIT;

-- ----------------------------
--  Records of 'Materiale'
-- ----------------------------
BEGIN;
Insert into materiale values ("Acciaio Inox", 0.8) , ("Silicio", 15), ("Gomma", 3.5), ("Rame", 1), ("Plastica", 0.57), ("Ottone",2), ("Piombo", 18), ("Stagno", 35), ("Vetro", 2), ("Alluminio", 0.50), ("Oro", 52129), ("Argento", 6530), ("Colla", 20),('Liquid Crystal',800);
COMMIT;

-- ----------------------------
--  Records of 'ComposizioneParte'
-- ----------------------------
BEGIN;
insert into composizione_parte values (1,'Vetro',9),(1,'Colla',1),(1,'Liquid Crystal',3),(2,'Vetro',9),(2,'Colla',1),(3,'Liquid Crystal',3), (5,'Vetro',9), (5,'Oro',0.56),(7,'Colla',1),(7,'Plastica',6),(7,'Vetro',2),(8,'Vetro',3), (4,'Oro',0.56),(4,'Colla',1), (4,'Plastica',6),(4,'Vetro',14),
								(10, "Silicio", 53), (10, "Acciaio Inox", 2),  (10, "Colla", 4), (11, "Stagno", 2), (11, "Oro", 0.80),
                                (9, "Silicio", 53), (9, "Acciaio Inox", 2),  (9, "Colla", 4), (9, "Stagno", 2), (9, "Oro", 0.80),
                                (12, "Plastica", 51),
                                (16, "Silicio", 15), (16, "Stagno", 8), (18, "Rame", 13), (18, "Ottone", 7),
                                (13, "Silicio", 15), (13, "Stagno", 8), (13, "Rame", 13), (13, "Ottone", 7),
                                (17, "Silicio", 13), (17, "Stagno", 15),
                                (14, "Silicio", 13), (14, "Stagno", 15), (14, "Rame", 13), (14, "Ottone", 7),
								(15, "Silicio", 32), (15, "Stagno", 13); 
COMMIT;

-- ----------------------------
--  Records of 'Cap_Citta'
-- ----------------------------
BEGIN;
insert into cap_citta VALUES 
	(50056, "Montelupo Fiorentino"),
    (09125, "Cagliari"),
    (09016, "Iglesias"),   
    (87064, "Corigliano Rossano"), 
    (66054, "Vasto"), 
    (62022, "Castelraimondo"), 
    (74014, "Laterza"),
    (04022, "Fondi"),
    (09095, "Mogoro");
COMMIT;


-- ----------------------------
--  Records of 'Categoria'
-- ----------------------------
BEGIN;
insert into categoria values 
	("Nuovo", 0, "Prodotto Nuovo"),
    ("Categoria A", 15, "Prodotto usato senza difetti estetici o di utilizzo paragonabile al nuovo"),
    ("Categoria B", 30, "Prodotto usato con alcune differenze estetiche"),
    ("Categoria C", 50, "Prodotto usato con differenze estetiche e/o prestazioni non ottimali"),
    ("End Of Life", NULL, "Prodotto da smaltire, NON VENDIBILE");
COMMIT;

-- ----------------------------
--  Records of 'Guasto'
-- ----------------------------
BEGIN;
insert into guasto (descrizione, nome) values
	("Malfunzionamento della batteria", "Guasto batteria"),
    ("Il touchscreen del dispositivo non viene correttamente rilevato", "Guasto touchscreen"),
	("La fotocamera non mette a fuoco", "Guasto diaframma"),
	("Rottura dello schermo", "Guasto schermo"),
    ("Sportello lavatrice rotto", "Guasto sportello lavatrice"),
    ("Non viene riprodotto alcun suono dagli altoparlanti del dispositivo", "Guasto altoparlanti"),
    ("La porta USB non rileva alcun segnale", "Guasto porta USB"),
    ("Lo scanner rimane fermo senza scannerizzare la pagina", "Guasto Scanner"),
    ("Il dispositivo non riesce ad accendersi correttamente", "Guasto accensione"),
    ("Il dispositivo non si connette a internet", "Guasto internet"),
    ("Resistenze della scheda del dispositivo danneggiate", "Guasto resistenze"),
    ("Il dispositivo non riconosce la scheda video", "Guasto scheda video"),
    ("Il dispositivo non riconosce la memoria RAM montata", "Guasto RAM"),
    ("La spia rilevatrice non si accende", "Guasto spia"),
    ("Il freezer non congela più", "Guasto freezer"),
    ("Le pale del dispositivo non si muovono", "Guasto pale");
COMMIT;
-- ----------------------------
--  Records of 'Lotto'
-- ----------------------------
BEGIN;
insert into Lotto values (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 2), (7, 2);
COMMIT;

-- ----------------------------
--  Records of 'Linea'
-- ----------------------------
BEGIN;
insert into linea values (1, 291.5), (2, 317.5), (3, 512.3);
COMMIT;

-- ----------------------------
--  Records of 'Lotto Produzione'
-- ----------------------------
BEGIN;
insert into Lotto_produzione values (1, "Decimomannu", "2020-10-31 00:00:00", "2020-11-07 00:00:00", "2020-11-05 00:00:00", 2), (6, "Montelupo", "2020-10-31 00:00:00", "2020-11-02 00:00:00", "2020-11-02 00:00:00", 3), (7, "Montelupo", "2015-02-02 00:00:00", "2015-02-10 00:00:00", "2015-02-10 00:00:00", 3);
COMMIT;

-- ----------------------------
--  Records of 'Indirizzo Ordine'
-- ----------------------------
BEGIN;
insert into indirizzo_ordine values(1, "Via Morosi", "11", 50056), (2, "Via Rossi", "34", 50056), (3, "Via Lazio", "21", 50056);
COMMIT;

-- ----------------------------
--  Records of 'Documento'
-- ----------------------------
insert into Documento values ("IT1", 3, "Comune", "2020-11-30"), ("IT3", 3, "Comune", "2020-12-05"), ("CA2", 3, "Comune", "2020-12-30");

-- ----------------------------
--  Records of 'Cliente'
-- ----------------------------
insert into cliente values ("GRDMRA80A01D403U", "Mario", "Giordano", 4245453, "Via Fratelli Cervi", 31, 50056, "1991-01-22", "IT1"), ("SLSMNL00R19B354B", "Emanuele", "Salis", 6433454, "Via P. Ruffini", 66, 09125, "2000-10-19", "CA2"), ("SRRDNL00L06B354J", "Daniele", "Serra", 6465454, "Vico Secondo Parrocchia", 81, 09125, "2000-07-06", "IT3");

-- ----------------------------
--  Records of 'Account'
-- ----------------------------
insert into `account` values ("Pippo", "PasswordDecisamenteNonInChiaro", "Come si chiama il tuo primo cane?", "Pupi", "2015-07-06", "SRRDNL00L06B354J"), ("Alan", "PasswordIperSegreta", "Come si chiama il tuo primo cane?", "Non ho un cane", "2018-06-02", "SLSMNL00R19B354B"), ("You can't specify target table", "for update in FROM clause", "Come si chiama il tuo primo errore?", "Delfino", "2020-02-04", "GRDMRA80A01D403U");


-- ----------------------------
--  Records of 'Ordine'
-- ----------------------------
BEGIN;
insert into ordine values (1, "2020-12-07 15:12:22", "2020-12-08", "Processazione", 2, "Pippo"), (2, "2020-12-07 15:12:22", "2020-12-14", "Processazione", 1, "You can't specify target table"), (3, "2020-12-07 15:12:22", "2020-12-08", "Processazione", 3, "Alan"), (4, "2015-02-12 18:52:22", "2015-02-13", "Processazione", 3, "Alan");
COMMIT;


-- ----------------------------
--  Estensione Garanzia
-- ----------------------------
BEGIN;
insert into estensione_garanzia values (1, 30, 36), (2, 50, 44), (3, 75, 56);
COMMIT;

-- ----------------------------
--  copertura guasto
-- ----------------------------
BEGIN;
insert into copertura_guasto values (1, 1), (1, 2), (1, 4), (2, 1), (2, 2), (2, 3), (2, 4), (2, 12), (2, 13), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9), (3, 10), (3, 11), (3, 12), (3, 13), (3, 14), (3, 15), (3, 16);
COMMIT;

-- ----------------------------
--  Records of 'Unità'
-- ----------------------------
BEGIN;
insert into unita values (1, "2020-11-01", 2, null, null, "Nuovo", 6), (2, "2020-11-01", 2, null, null, "Nuovo", 6), (3, "2020-11-01", 2, null, null, "Nuovo", 6), (4, "2020-11-01", 1, null, null, "Nuovo", 1), (5, "2020-11-01", 1, null, null, "Nuovo", 1), (6, "2020-11-01", 1, null, null, "Nuovo", 1), (7, "2015-02-04", 2, null, null, "Nuovo", 7), (8, "2015-02-08", 2, 1, null, "Nuovo", 7), (9, "2015-02-10", 2, 3, null, "Nuovo", 7);
COMMIT;

-- -------------------------------------
--  Records of 'unita_disponibili_ordine'
-- -------------------------------------
BEGIN;
insert into unita_disponibili_ordine values (7,2,"Nuovo"),(9,2,"Nuovo"),(8,2,"Nuovo"),(1,2,"Nuovo"), (2,2,"Nuovo"), (3,2,"Nuovo"), (4,1,"Nuovo"), (5,1,"Nuovo"), (6,1,"Nuovo");
COMMIT;

-- ----------------------------
--  Records of 'Carrello'
-- ----------------------------
call popolacarrello(2, "Nuovo", 1, 2);
call checkOrdine(1);
call popolacarrello(2, "Nuovo", 2, 1);
call popolacarrello(1, "Nuovo", 2, 1);
call checkOrdine(2);
call popolacarrello(1, "Nuovo", 3, 2);
call checkOrdine(3);
call popolacarrello(2, "Nuovo", 4, 3);
call checkOrdine(4);

-- esecuzione operazione numero 3: utile per 'popolare'
call associaUnita(4, 2, "Nuovo");
call associaUnita(1, 2, "Nuovo");
call associaUnita(2, 2, "Nuovo");
call associaUnita(2, 1, "Nuovo");
call associaUnita(3, 1, "Nuovo");

SET SQL_SAFE_UPDATES = 0;
update ordine 
set stato = "Evaso"
where
	stato = "Processazione";
SET SQL_SAFE_UPDATES = 1;
   
-- ----------------------------
--  Records of 'Operazione'
-- ----------------------------
insert into operazione values (1, 3, null, null, 1, 1, 4), (2, 1, null, null, 1, 1, 9), (3, 2, null, null, 1, 1, 12), (4, 1, null, null, 1, 1, 15), (5, 3, null, null, 1, 1, 13), (6, 2, null, null, 1, 1, 14), (7, 1, null, null, 1, 4, 9), (8, 1, null, null, 1, 4, 12), (9, 3, null, null, 1, 4, 15), (10, 3, null, null, 1, 4, 13), (11, 1, null, null, 1, 4, 14), (12, 2, null, null, 1, 9, 12), (13, 1, null, null, 1, 9, 15), (14, 3, null, null, 1, 9, 13), (15, 1, null, null, 1, 9, 14), (16, 1, null, null, 1, 12, 15), (17, 2, null, null, 1, 12, 13), (18, 1, null, null, 1, 12, 14), (19, 1, null, null, 1, 15, 13), (20, 2, null, null, 1, 15, 14), (21, 2, null, null, 2, 4, 1), (22, 3, null, null, 2, 9, 1), (23, 2, null, null, 2, 12, 1), (24, 3, null, null, 2, 15, 1), (25, 2, null, null, 2, 13, 1), (26, 3, null, null, 2, 14, 1), (27, 2, null, null, 2, 9, 4), (28, 1, null, null, 2, 12, 4), (29, 2, null, null, 2, 15, 4), (30, 2, null, null, 2, 13, 4), (31, 3, null, null, 2, 14, 4), (32, 3, null, null, 2, 12, 9), (33, 3, null, null, 2, 15, 9), (34, 2, null, null, 2, 13, 9), (35, 3, null, null, 2, 14, 9), (36, 2, null, null, 2, 15, 12), (37, 1, null, null, 2, 13, 12), (38, 3, null, null, 2, 14, 12), (39, 2, null, null, 2, 13, 15), (40, 3, null, null, 2, 14, 15), (41, 3, null, null, 1, 2, 3), (42, 3, null, null, 
1, 5, 7), (43, 2, null, null, 1, 5, 8), (44, 1, null, null, 1, 7, 8), (45, 1, null, null, 1, 10, 11), (46, 1, null, null, 1, 16, 18), (47, 1, null, null, 1, 17, 18), (48, 2, null, null, 2, 3, 2), (49, 1, null, null, 2, 7, 5), (50, 3, null, null, 2, 8, 5), (51, 1, null, null, 2, 8, 7), (52, 2, null, null, 2, 11, 10), (53, 1, null, null, 2, 18, 16), (54, 1, null, null, 2, 18, 17);

call creazione_sequenza(1,1,-1);
call creazione_sequenza(1, 2, 2);
call creazione_sequenza(1,1,-1);
call creazione_sequenza(1, 2, 1);

call creazione_sequenza(2,1,-1);
call creazione_sequenza(2, 2, 2);
call creazione_sequenza(2,1,-1);
call creazione_sequenza(2, 2, 1);


-- ----------------------------
--  Records of 'Centro Assistenza'
-- ----------------------------
BEGIN;
insert into centro_assistenza values (1, "Via dei Martiri", 11, 50056), (2, "Via Roma", 43, 09125);
COMMIT;


-- ----------------------------
--  Records of 'Richiesta di Intervento'
-- ----------------------------
BEGIN;
insert into richiesta_intervento values (1, 120, 1, 1, "SRRDNL00L06B354J"),(2, 74, 1, 3, "GRDMRA80A01D403U"),(3, 74, null, 5, "SLSMNL00R19B354B"),(4, 74, null, 6, "SLSMNL00R19B354B"), (5, 112, 1, 7, "SLSMNL00R19B354B"), (6, 112, 1, 8, "SLSMNL00R19B354B");
COMMIT;


-- ----------------------------
--  Records of 'Tecnico'
-- ----------------------------
BEGIN;
insert into tecnico values ("PRGLNI04C42L736J", "Ilenia", "Parego", 30.2, "1904-03-02", 1), ("RSSGPP92R06D612C", "Giuseppe", "Rossi", 25.7, "1992-10-06", 1), ("SNSGCM00A21G702O", "Giacomo", "Sansone", 38.2, "2000-01-21", 1), ("MLEFDL89H21D403X", "Fedele", "Mele", 22, "1989-06-21", 1);
COMMIT;


-- ----------------------------
--  Records of 'Intervento'
-- ----------------------------
BEGIN;
insert into intervento values (1, "2020-10-30", 15, "Via Garibaldi", 13, 50056, "PRGLNI04C42L736J", 2, 1, 1), (2, current_date + interval 3 day, 9, "Via Garibaldi", 13, 50056, null, 2, 1, 1), (3, "2020-11-05", 10, "Via XX Settembre", 89, 50056, "RSSGPP92R06D612C", 3, 2, 1), (4, current_date + interval 3 day, 10, "Via XX Settembre", 89, 50056, null, 3, 2, 1), (5, current_date + interval 3 day, 16, "Via dei Martiri", 11, 50056, null, null, 3, 1), (6, current_date + interval 3 day, 15, "Via dei Martiri", 11, 50056, null, null, 4, 1), (7, "2016-02-20", 15, "Via dei Martiri", 11, 50056, "SNSGCM00A21G702O", 2, 5, 1), (8, "2020-03-03", 15, "Via dei Martiri", 11, 50056, "SNSGCM00A21G702O", 2, 6, 1);
COMMIT;


-- ----------------------------
--  Records of 'Riparazione'
-- ----------------------------
BEGIN;
insert into riparazione values (1, 3, null, null, 2), (2, 3, null, null, 4), (3, 3, 4, 0, 7), (4, 2,2,120,8);
COMMIT;


-- ----------------------------
--  Records of 'Magazzino'
-- ----------------------------
BEGIN;
insert into Magazzino values (1, "Milano", 1200), (2, "Montelupo", 750);
COMMIT;

-- ----------------------------
--  Records of 'Tipologia Magazzino'
-- ----------------------------
BEGIN;
insert into tipologia_magazzino values (1, "Telefonia", "2015-03-12", null), (2, "Telefonia", "2017-11-21", null),  (1, "TV", "2019-02-11", null);
COMMIT;

-- ----------------------------
--  Records of 'Settore'
-- ----------------------------
BEGIN;
insert into Settore values (1, "F09", 150, 1, 1), (2, "B11", 115, 2, 1), (3, "B11", 60, 1, 2);
COMMIT;

-- ----------------------------
--  Records of 'Stocccaggio'
-- ----------------------------
BEGIN;
insert into Stoccaggio values (1, 1, '2020-10-31', '2020-12-14', 3), (6, 2, '2020-10-31', '2020-12-14', 7), (3, 2, '2020-10-31', null, 2), (4, 2, '2020-10-31', null, 2), (5, 2, '2015-02-02', '2015-02-13', 2);
COMMIT;


-- ----------------------------
--  Records of 'Stazione'
-- ----------------------------
BEGIN;
insert into Stazione values (1, 1, 3, 1), (2, 2, 2, 1), (3, 3, 1, 1), (4, 4, 3, 1), (5, 5, 1, 1),
							(6, 1, 3, 2), (7, 2, 2, 2), (8, 3, 3, 2), (9, 4, 1, 2), (10, 5, 2, 2),  (11, 6, 1, 2), (12, 7, 3, 2), (31, 8, 1, 2), (32, 9, 2, 2),
                            (13, 1, 3, 3), (14, 2, 2, 3), (15, 3, 3, 3), (16, 4, 1, 3), (17, 5, 3, 3),  (18, 6, 1, 3);
COMMIT;


-- ----------------------------
--  Records of 'Operatore'
-- ----------------------------
BEGIN;
insert into Operatore values 	("GRDMRA80A01D403U", "Mario", "Giordano", "2016-11-03", "1991-01-22"), 
								("SLSMNL00R19B354B", "Emanuele", "Salis", "2016-11-02","2000-10-19"), 
								("SRRDNL00L06B354J", "Daniele", "Serra", "2016-04-25","2000-07-06"),
								("PLOVRI87M21D403X", "Vieri", "Poli", "2016-11-03", "1987-08-21"),
								("MRRCSM88S22D403E", "Cosimo", "Marruganti", "2016-11-03", "1988-11-22"),
								("PRDLDR94T13D403Y", "Aleandro", "Prudenzano", "2016-11-03", "1994-12-13"),
								("HMDYBA79C08D403Z", "Ayub", "Hamdi", "2016-11-03", "1979-03-08"),
								("BRDCRL89A24D403A", "Carlo", "Bardazzi", "2016-11-03", "1989-01-24"),
								("NCHGRL89L16D403B", "Gabriel", "Nechita", "2016-11-03", "1989-07-16"),
								("LNONRC84E10D403A", "Enrico", "Loni", "2016-11-03", "1984-05-10"),
								("PLOLRD81H30D403D", "Leonardo", "Poli", "2016-11-03", "1981-06-30"),
								("DRSFNC80A26B354S", "Francesco", "De rossi", "2016-11-03", "1980-01-26"),
								("DLPGLL80E18F839I", "Guglielmo", "Del prete", "2016-11-03", "1980-05-18"),
								("BLTMRA87B01F205Q", "Mario", "Balotelli", "2016-11-03", "1987-02-01"),
								("LGBLCN77A22I452U", "Luciano", "Ligabue", "2016-11-03", "1977-01-22"),
								("GUOBRN77M21F979K", "Ugo", "Bruno", "2016-11-03", "1977-08-21"),
								("MLLGRL99R14B354Y", "Gabriele", "Mallei", "2015-10-22", "1999-10-14"),
								("MRABRS77H21F839Y", "Mario", "Bros", "2016-11-03", "1977-06-21"),
                                ("LGUBRS77H21F839Y", "Luigi", "Bros", "2016-11-03", "1977-06-21"),
                                ("WRABRS77H21F839Y", "Wario", "Bros", "2016-11-03", "1977-06-21");
COMMIT;

-- ----------------------------
--  Records of 'Assegnamento'
-- ---------------------------- 
insert into assegnamento values 
	(1, "2015-01-01", 1),
    (2, "2015-01-01", 2),
    (3, "2014-01-01", 3),
    (5, "2014-03-25", 3),
    (1, "2016-11-03", 2);

-- ----------------------------
--  Records of 'Esegue'
-- ----------------------------
BEGIN;
insert into Esegue values 	("GRDMRA80A01D403U", 1, 1, "2016-11-03", null),
							("GRDMRA80A01D403U", 2, 1, "2016-11-03", null),
                            
							("SLSMNL00R19B354B", 3, 2, "2016-11-02", null),
                            
                            ("SRRDNL00L06B354J", 4, 3, "2016-04-25", null),
							("SRRDNL00L06B354J", 5, 3, "2016-04-25", null),
                            
                            ("PLOVRI87M21D403X", 6, 4, "2016-11-03", null),
							("PLOVRI87M21D403X", 7, 4, "2016-11-03", null),
                            ("PLOVRI87M21D403X", 8, 4, "2016-11-03", null),

                            ("MRRCSM88S22D403E", 9, 5, "2016-11-03", null),
							("MRRCSM88S22D403E", 10, 5, "2016-11-03", null),

                            ("DLPGLL80E18F839I", 21, 13, "2016-11-03", null),

                            ("BLTMRA87B01F205Q", 22, 14, "2016-11-03", null),
							
                            ("LGBLCN77A22I452U", 23, 15, "2016-11-03", null),

                            ("GUOBRN77M21F979K", 24, 16, "2016-11-03", null),
							("GUOBRN77M21F979K", 25, 16, "2016-11-03", null),
                            ("GUOBRN77M21F979K", 26, 16, "2016-11-03", null),
                            ("GUOBRN77M21F979K", 27, 16, "2016-11-03", null),

                            ("MLLGRL99R14B354Y", 28, 17, "2016-11-03", null),
                            ("MLLGRL99R14B354Y", 29, 17, "2016-11-03", null),

                            ("MRABRS77H21F839Y", 30, 18, "2016-11-03", null),
                            
                            ("BLTMRA87B01F205Q", 23, 15, "2014-03-22", "2016-11-03"),
							
                            ("LGBLCN77A22I452U", 22, 14, "2014-03-13", "2016-11-03"),
                            
							("PRDLDR94T13D403Y", 36, 6, "2015-01-01", null),

                            ("HMDYBA79C08D403Z", 37, 7, "2015-01-01", null),
                            
                            ("BRDCRL89A24D403A", 38, 8, "2015-01-01", null),
                            
                            ("NCHGRL89L16D403B", 39, 9, "2015-01-01", null),
                            ("NCHGRL89L16D403B", 40, 9, "2015-01-01", null),
                            
							("LNONRC84E10D403A", 41, 10, "2015-01-01", null),

                            ("PLOLRD81H30D403D", 42, 11, "2015-01-01", null),

                            ("DRSFNC80A26B354S", 43, 12, "2015-01-01", null),
                            
							("LGUBRS77H21F839Y", 44, 31, "2015-01-01", null),
                            
							("WRABRS77H21F839Y", 45, 32, "2015-01-01", null);
COMMIT;

-- ----------------------------
--  Records of 'Scarto'
-- ----------------------------
BEGIN;
insert into scarto values 	(23, "2020-10-31", 1, 3, 1),
							(26, "2020-10-31", 1, 3, 1),
                            (30, "2020-11-01", 1, 3, 1),
                            (23, "2020-11-01", 2, 3, 1),
                            
							(9, "2020-11-01", 4, 2, 1),
                            (9, "2020-11-01", 5, 2, 1),
                            (10, "2020-11-01", 4, 2, 1),
							(10, "2020-11-01", 5, 2, 1),
                            
							(7, "2020-11-01", 4, 2, 1),
                            (7, "2020-11-01", 5, 2, 1);
COMMIT;


-- ----------------------------
--  Records of 'Test'
-- ----------------------------
BEGIN;
insert into test values (1, "Test Accensione"), (2, "Test Batteria"), (3, "Test Diaframma"), (4, "Test Fotocamera"), (5, "Test Flash fotocamera"), (6, "Test Touchscreen"), (7, "Test Software Touchscreen"), (8, "Test Hardware Touchscreen"), (9, "Test Schermo"), (10, "Test Pixel Bruciati"), (11, "Stress Test RAM"), (12, "Test Bus connessione RAM-CPU"), (13, "Test Pin Ram"), (14, "Test Casse audio"), (15, "Test Variazione Temperatura Scocca"), (16, "Test Memoria 64GB"), (17, "Test Sottoparte Memoria 64GB"), (18, "Test Memoria 128GB"), (19, "Test Sottoparte Memoria 128GB");
COMMIT;


-- ----------------------------
--  Records of 'Sotto Test'
-- ----------------------------
BEGIN;
insert into sotto_test values (1, 2), (4, 3), (4, 5), (9, 6), (6, 7), (6, 8), (9,10), (11, 12), (11, 13), (16, 17), (18, 19);
COMMIT;


-- ----------------------------
--  Records of 'Livello 1 Test Tree'
-- ----------------------------
BEGIN;
insert into livello1_test_tree values (1, 1), (4, 1), (9, 1), (11, 1), (14, 1), (16, 1), (1, 2), (4, 2), (9, 2), (11, 2), (14, 2), (18, 2);
COMMIT;


-- ----------------------------
--  Records of 'Sostituzione Parte'
-- ----------------------------
BEGIN;
insert into sostituzione_parte values (2, 3), (2, 4);
COMMIT;



-- ----------------------------
--  Sintomo
-- ----------------------------
BEGIN;
insert into Sintomo values 
(1, "Non carica"),
(2, "Non rispondo ai comandi"),
(3, "Non mette a fuoco"),
(4, "Colori casuali a schermo"),
(5, "Dispositivo non si accende"),
(6, "Memoria non rilevata"),
(7, "Non regge la carica"),
(8, "Flash non si accende"),
(9, "Colori output fotocamera errati"),
(10, "Le applicazioni si aprono a caso");
COMMIT;

-- ----------------------------
--  Records of Rimedio
-- ----------------------------
insert into rimedio values	(1, "Accendi il dispositivo"),
							(2, "Metti in carica il dispositivo"),
							(3, "Pulizia vetro fotocamera"),
							(4, "Reset impostazioni di fabbrica"),
							(5, "Spegni e riaccendi"),
                            (6, "Cambia cavo di ricarica"),
                            (7, "Cambia la spina di ricarica"),
                            (8, "Cambia il caricabatterie"),
                            (9, "Contatta il centro assistenza piu' vicino");
COMMIT;

-- ----------------------------
--  Records of assistenza virtuale
-- ----------------------------
BEGIN;
insert into assistenza_virtuale values 	(1, 1, 1, "Il dispositivo e' acceso?"),
										(2, 1, 2, "Il dispositivo e' carico?"),
                                        (6, 1, 3, "Il dispositivo e' acceso?"),
                                        (7, 1, 4, "Il dispositivo e' carico?"),
                                        (8, 1, 5, "Il dispositivo e' carico?"),
										(9, 1, 6, "Hai risolto il problema?"),
										
                                        (3, 3, 1, "La fotocamera e' pulita?"),
                                        (5, 3, 2, "La fotocamera mette a fuoco?"),
                                        (9, 3, 3, "Hai risolto il problema?");
COMMIT;


-- ----------------------------
--  Records of Recensione
-- ----------------------------
BEGIN;
insert into recensione values 	(1, "Pippo", 1, 1, 1, "Il prodotto esplode al primo utilizzo", current_date),
								(1, "Alan", 5, 3, 4, "Utilizza Linux e non mi sento schiavo di Windows, consigliatissimo!!1!!1", current_date),
                                (2, "You can't specify target table", 1, 1, 3, "Prodotto scadente, alla prima caduta si e' rotto lo schermo. La prossima volta compro un Android", current_date);
COMMIT;


-- ----------------------------
--  Records of sintomi_guasto
-- ----------------------------
BEGIN;
insert into sintomi_guasto values 
								(1, 1), (1, 5), (1, 7),
                                (2, 2), (2, 10),
                                (3, 3), (3, 9), (3, 8),
                                (4, 2), (4, 4), (4, 10), (4, 5),
                                (12, 4),
                                (13, 5), (13, 6);
COMMIT;

-- ----------------------------
--  Records of caso
-- ----------------------------
BEGIN;
insert into caso values (1, 1), (2, 2), (3, 3), (4, 4), (5, 12), (6, 13);
COMMIT;


-- ----------------------------
--  Records of sintomi_caso
-- ----------------------------
BEGIN;
insert into sintomi_caso values (1, 1), (7, 1),
								(10, 2),
                                (8, 3), (9, 3),
                                (2, 4),	(4, 4),
                                (4, 5),
                                (5, 6), (6, 6);
COMMIT;

-- ----------------------------
--  Records of soluzione
-- ----------------------------
BEGIN;
insert into soluzione values 
	("Ricalibrazione della batteria"),
	("Inversione pin schermo touchscreen"),
	("Pulizia diaframma"),
	("Sostituzione vetro dello schermo"),
	("Riavvio del dispositivo"),
	("Sostituzione flash"),
	("Spegni e riaccendi"),
    ("Soffiare sulla RAM"),
    ("Sostituzione scheda video");
COMMIT;


-- ----------------------------
--  Records of soluzione
-- ----------------------------
BEGIN;
insert into soluzioni_caso values 
	("Ricalibrazione della batteria", 1),
	("Inversione pin schermo touchscreen", 2),
	("Pulizia diaframma", 3),
	("Sostituzione vetro dello schermo", 3),
	("Riavvio del dispositivo", 4),
	("Sostituzione flash", 3),
	("Spegni e riaccendi", 6),
    ("Soffiare sulla RAM", 5),
    ("Sostituzione scheda video", 6);
COMMIT;

-- ----------------------------
--  Records of Errore
-- ----------------------------
BEGIN;
insert into errore values (1, 1, 303), (1, 2, 304), (1, 3, null), (1, 4, null), (1, 12, 208), (1, 13, 404), (1, 6, null);
COMMIT;

-- popolamento classifica delle sequenze
CALL aggiorna_classifica("2015-12-31 23:30:00");
CALL aggiorna_classifica("2017-12-31 23:30:00");
CALL aggiorna_classifica("2018-12-31 23:30:00");
CALL aggiorna_classifica("2019-12-31 23:30:00");
CALL aggiorna_classifica("2020-12-31 23:30:00");

