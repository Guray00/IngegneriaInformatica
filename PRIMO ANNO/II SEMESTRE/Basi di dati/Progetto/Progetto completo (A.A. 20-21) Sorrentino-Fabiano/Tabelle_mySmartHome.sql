SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;
#set global event_scheduler = on;


BEGIN;
CREATE DATABASE IF NOT EXISTS `mySmartHome`;
COMMIT;

USE `mySmartHome`;


#--------------nuovoUtente----------------------
DROP TABLE IF EXISTS `nuovoUtente`;
CREATE TABLE `nuovoUtente` (
  `CodFiscale` varchar(50) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cognome`varchar(50) NOT NULL,
  `DataNascita` date NOT NULL,
  `Telefono` double NOT NULL,
  PRIMARY KEY (`CodFiscale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#--------------registroIscrizione----------------------

DROP TABLE IF EXISTS `registroIscrizione`;
CREATE TABLE `registroIscrizione` (
  `CodFiscale` varchar(50) NOT NULL,
  `Numero` varchar(50) NOT NULL UNIQUE,
  `NomeUtente` varchar(50) NOT NULL,
  `DataIscrizione` date NOT NULL,
  PRIMARY KEY (`CodFiscale`, `Numero`), 
  FOREIGN KEY (`CodFiscale`) REFERENCES nuovoUtente(`CodFiscale`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



#-----------documento-------------------------

DROP TABLE IF EXISTS `documento`;
CREATE TABLE `documento` (
  `Numero` varchar(50) NOT NULL,
  `TipoDocumento` varchar(50) NOT NULL, 
  `Scadenza` date NOT NULL,
  `EnteRilascio` varchar(50) NOT NULL, 
  check(TipoDocumento='IDCard' or TipoDocumento='TS' or TipoDocumento='PP' or TipoDocumento='P' or TipoDocumento='Spid'),
  PRIMARY KEY (`Numero`), 
  FOREIGN KEY (`Numero`) REFERENCES registroIscrizione(`Numero`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#----------------account----------------------

DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `NomeUtente` varchar(50) NOT NULL,
  `Pswrd` varchar(50) NOT NULL,
  `Privilegio` varchar(50) NOT NULL,
  `Domanda` varchar(50) NOT NULL,
  `Risposta` varchar(50) NOT NULL,
  CHECK (Privilegio = 'Gestore' or
		 Privilegio = 'Famiglia' or
		 Privilegio = 'Ospite'),
  PRIMARY KEY (`NomeUtente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#--------------dispositivo------------------------

DROP TABLE IF EXISTS `dispositivo`;
CREATE TABLE `dispositivo` (
  `CodDisp` integer NOT NULL AUTO_INCREMENT,
  `NomeDisp` varchar(50) NOT NULL,
  `TipoConsumo` varchar(50) NOT NULL,
  CHECK(TipoConsumo='Variabile' or TipoConsumo='Interrompibile' or TipoConsumo='Fisso'),
  PRIMARY KEY (`CodDisp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#-------------stanza-------------------------

DROP TABLE IF EXISTS `stanza`;
CREATE TABLE `stanza` (
  `CodSt` integer NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Piano` integer NOT NULL,
  `Altezza` double NOT NULL,
  `Larghezza` double NOT NULL,
  `Lunghezza` double NOT NULL,
  PRIMARY KEY (`CodSt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#-------------smartPlug-------------------------

DROP TABLE IF EXISTS `smartPlug`;
CREATE TABLE `smartPlug` (
  `CodSp` integer NOT NULL AUTO_INCREMENT,
  `CodSt` integer NOT NULL,
  `CodDisp` integer DEFAULT NULL, 
  `StatoUtilizzo` varchar(3) DEFAULT 'OFF',
  CHECK (StatoUtilizzo = 'ON' or StatoUtilizzo = 'OFF'), 
  PRIMARY KEY (`CodSp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#------------regolazione--------------------------
														
DROP TABLE IF EXISTS `regolazione`;						
CREATE TABLE `regolazione` (
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL DEFAULT 1,
  PRIMARY KEY (`CodR`, `CodDisp`),
  FOREIGN KEY (`CodDisp`) REFERENCES dispositivo(`CodDisp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#---------------illuminazione-----------------------

DROP TABLE IF EXISTS `illuminazione`;
CREATE TABLE `illuminazione` (
  `CodDisp` integer NOT NULL,
  `Posizione` integer NOT NULL,
  `Cspecifico` double NOT NULL,
  `Accesa` varchar(3) DEFAULT 'OFF',
  check(Cspecifico>0),
  CHECK (Accesa = 'ON' or Accesa = 'OFF'),
  PRIMARY KEY (`CodDisp`), 
  FOREIGN KEY (`CodDisp`) REFERENCES dispositivo(`CodDisp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#--------------condizionatore------------------------

DROP TABLE IF EXISTS `condizionatore`;
CREATE TABLE `condizionatore` (
  `CodDisp` integer NOT NULL,
  `Stanza` varchar(50) NOT NULL,
  `Stato` varchar(3) DEFAULT 'OFF',
  CHECK (Stato = 'ON' or Stato = 'OFF'), 
  PRIMARY KEY (`CodDisp`),
  FOREIGN KEY (`CodDisp`) REFERENCES dispositivo(`CodDisp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#-------------livello-------------------------

DROP TABLE IF EXISTS `livello`;
CREATE TABLE `livello` (
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL,
  `CLVL` double NOT NULL,
  check (CLVL>0),
  PRIMARY KEY (`CodDisp`,`CodR`),
  FOREIGN KEY (`CodDisp`,`CodR`) REFERENCES regolazione(`CodDisp`, `CodR`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#-------------programma-------------------------

DROP TABLE IF EXISTS `programma`;
CREATE TABLE `programma` (
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Livello` integer NOT NULL,  -- per le lavatrici,asciugatrici e lavastoviglie è la temperatura
  `CMedio` double NOT NULL,  -- in Wh
  `Durata` integer NOT NULL, 				-- Durata : si spacifica con un numero Intero che indica i Minuti (della Durata)
  check(livello>=0),
  check(CMedio>0),
  check(Durata>9),
  PRIMARY KEY (`CodDisp`, `CodR`),
  FOREIGN KEY (`CodDisp`,`CodR`) REFERENCES regolazione(`CodDisp`, `CodR`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#-----------impLuce---------------------------

DROP TABLE IF EXISTS `impLuce`; -- bisogna impostare un massimale di luce creabili
CREATE TABLE `impLuce` (
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL,
  `TempColore` double NOT NULL,
  `Intensita` integer NOT NULL, -- è un valore %
  `_Default` char(2) DEFAULT 'No',
  check(intensita>=0 and intensita<=100),
  CHECK (_Default = 'Si' or _Default = 'No'),
  PRIMARY KEY (`CodDisp`, `CodR`),
  FOREIGN KEY (`CodDisp`,`CodR`) REFERENCES regolazione(`CodDisp`, `CodR`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#---------------impcondizionatore-----------------------

DROP TABLE IF EXISTS `impCondiz`;
CREATE TABLE `impCondiz` (
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL,
  `Temp` integer NOT NULL,
  `Umidita` integer NOT NULL,  -- è una percentuale
  `Eunitaria` double NOT NULL default 0,
  `Tiniziale` integer NOT NULL default 0,
  `Dissipamento` double NOT NULL DEFAULT 0,
  `_Default` char(2) DEFAULT 'No',
  check(Umidita>=0 and Umidita<=100),
  check(Eunitaria>=0),
  check(Dissipamento>=0),
  CHECK (_Default = 'Si' or _Default = 'No'),
  PRIMARY KEY (`CodDisp`, `CodR`), 
  FOREIGN KEY (`CodDisp`,`CodR`) REFERENCES regolazione(`CodDisp`, `CodR`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#----------------schedule----------------------

DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
  `Utente` varchar(30) NOT NULL,
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL,
  `OraR` time NOT NULL,
  `GiornoI` integer NOT NULL, -- è un day of week(0-6)
  `MeseI` integer NOT NULL,
  `Durata` integer NOT NULL,
  `GiornoF` integer DEFAULT NULL,
  `MeseF` integer DEFAULT NULL,
  check(Durata>0),
  check(GiornoI>=0 and GiornoI<=6),
  check(GiornoF>=0 and GiornoF<=6),
  check(MeseI>=1 and MeseI<=12),
  check(MeseI>=1 and MeseI<=12),
  PRIMARY KEY (`Utente`,`CodDisp`, `CodR`, `OraR`,`GiornoI`, `MeseI`),
  FOREIGN KEY (`CodDisp`,`CodR`) REFERENCES regolazione(`CodDisp`, `CodR`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#----------------efficienzaEnergetica----------------------

DROP TABLE IF EXISTS `efficienzaEnergetica`;
CREATE TABLE `efficienzaEnergetica` (
  `CodSt` integer NOT NULL,
  `Testerna` double NOT NULL DEFAULT 0,
  `Tinterna` double NOT NULL DEFAULT 0,
  `Enecessaria` double NOT NULL DEFAULT 0,
  check(Enecessaria>=0),
  PRIMARY KEY (`CodSt`),
  FOREIGN KEY (`CodSt`) REFERENCES stanza(`CodSt`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#--------------termometro------------------------

DROP TABLE IF EXISTS `termometro`;
CREATE TABLE `termometro` (
  `CodSt` integer NOT NULL,
  `Tmisura` timestamp NOT NULL,
  `Testerna` double NOT NULL,
  `Tinterna` double NOT NULL,
  PRIMARY KEY (`CodSt`, `Tmisura`), 
  FOREIGN KEY (`CodSt`) REFERENCES stanza(`CodSt`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#-------------apertura-------------------------

DROP TABLE IF EXISTS `apertura`;
CREATE TABLE `apertura` (
  `CodA` integer NOT NULL AUTO_INCREMENT,
  `St1` integer NOT NULL,
  `St2` integer DEFAULT NULL,
  `TipoSerr` varchar(50) NOT NULL,
  `TipoApert` varchar(50) NOT NULL,
  `StatoBlocco` varchar(3) NOT NULL DEFAULT 'OFF',
  `Orientamento` varchar(2) NOT NULL,
    CHECK (TipoSerr='Blindata' or TipoSerr='Tapparella' or TipoSerr='Serratura' 
           or TipoSerr='Maniglia' or TipoSerr='Persiane' or TipoSerr='Portoncino' or TipoSerr='Varco'),
     CHECK (TipoApert = 'Finestra' or 
	      TipoApert = 'PortaFinestra' or
          TipoApert = 'Porta' or
          TipoApert = 'Scala'),
  CHECK (StatoBlocco = 'ON' or StatoBlocco = 'OFF'),
  CHECK (Orientamento = 'N' or
		 Orientamento = 'NO' or
         Orientamento = 'O' or
         Orientamento = 'SO' or
         Orientamento = 'S' or
         Orientamento = 'SE' or
         Orientamento = 'E' or 
         Orientamento = 'NE'), 
  PRIMARY KEY (`CodA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#------------registroSerramenti--------------------------

DROP TABLE IF EXISTS `registroSerramenti`;
CREATE TABLE `registroSerramenti` (
  `CodA` integer NOT NULL,
  `Tapertura` timestamp NOT NULL,
  `Tchiusura` timestamp DEFAULT NULL,
  check(Tapertura<Tchiusura),
  PRIMARY KEY (`CodA`, `Tapertura`), 
  FOREIGN KEY (`CodA`) REFERENCES apertura(`CodA`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#-------------controlloAccessi------------------------- 

DROP TABLE IF EXISTS `controlloAccessi`;
CREATE TABLE `controlloAccessi` (
  `CodSt` integer NOT NULL,
  `CodA` integer NOT NULL,
  `Persona` varchar(50) NOT NULL default 'Intruso',					
  `Entrata` timestamp NOT NULL,
  `Uscita` timestamp default NULL,
  PRIMARY KEY (`CodSt`, `CodA`, `Persona`, `Entrata`),	
  FOREIGN KEY (`CodA`) REFERENCES apertura(`CodA`) ON UPDATE CASCADE, 
  FOREIGN KEY (`CodSt`) REFERENCES stanza(`CodSt`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#--------------consumo------------------------

DROP TABLE IF EXISTS `consumo`;
CREATE TABLE `consumo` (
  `NomeUtente` varchar(50) NOT NULL,
  `Inizio` timestamp NOT NULL,
  `CodR` integer NOT NULL,
  `CodDisp` integer NOT NULL,
  `EnergiaConsumata` double NOT NULL,
  `FasciaOraria` varchar(3) NOT NULL,
  `Ora` integer NOT NULL,
   CHECK (EnergiaConsumata>=0),
  CHECK (Ora <= 24 and Ora>=0), 
  PRIMARY KEY (`NomeUtente`, `Inizio`, `CodR`, `CodDisp`), 
  FOREIGN KEY (`NomeUtente`) REFERENCES account(`NomeUtente`) ON UPDATE CASCADE, 
  FOREIGN KEY (`CodR`) REFERENCES regolazione(`CodR`) ON UPDATE CASCADE, 
  FOREIGN KEY (`CodDisp`) REFERENCES dispositivo (`CodDisp`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#-------------interazione-------------------------

DROP TABLE IF EXISTS `interazione`;
CREATE TABLE `interazione` (
  `NomeUtente` varchar(50) NOT NULL,
  `Inizio` timestamp NOT NULL, 
  `CodDisp`integer NOT NULL,
  `CodR` integer NOT NULL,
  `Fine` timestamp DEFAULT NULL,
  `Differita` char(50) NOT NULL,
  CHECK (Differita ='Si' or Differita = 'No'),
  check (Inizio<Fine), -- non ci possono essere interazioni che finiscono prima di iniziare
  PRIMARY KEY (`NomeUtente`,`Inizio`,`CodDisp`,`CodR`), 
  FOREIGN KEY (`NomeUtente`) REFERENCES account(`NomeUtente`) ON UPDATE CASCADE, 
  FOREIGN KEY (`CodDisp`) REFERENCES dispositivo(`CodDisp`) ON UPDATE CASCADE, 
  FOREIGN KEY (`CodR`) REFERENCES regolazione(`CodR`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#--------------contatoreBidirezionale------------------------ 

DROP TABLE IF EXISTS `contatoreBidirezionale`;
CREATE TABLE `contatoreBidirezionale` (
  `FasciaOraria` varchar(3) NOT NULL,
  `RangeF` integer NOT NULL,
  `Preferenza` varchar(50) NOT NULL,
   `RiepilogoP` double NOT NULL default 0,
   `RiepilogoC` double NOT NULL default 0,
   check (RangeF=5 or RangeF=13 or RangeF=21), 
  CHECK (Preferenza = 'Immettere' or
		 Preferenza = 'Autoconsumare' or
         Preferenza = 'Riserva'),
  Check(RiepilogoP>=0 and RiepilogoC>=0),
  PRIMARY KEY (`FasciaOraria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#------------pannellifotovoltaici--------------------------

DROP TABLE IF EXISTS `pannelliFotovoltaici`;
CREATE TABLE `pannelliFotovoltaici` (
  `Istante` timestamp NOT NULL,
  `Energia` double NOT NULL,   -- in kwh/m^2
  `FasciaOraria` varchar(3) NOT NULL,
  `Ora` integer NOT NULL,
  check(Energia>=0),
  check(FasciaOraria='F1' or FasciaOraria='F2' or FasciaOraria='F3'),
  check(Ora>=0 and Ora<24),
  PRIMARY KEY (`Istante`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#----------------contratto----------------------

DROP TABLE IF EXISTS `contratto`;
CREATE TABLE `contratto` (
  `FasciaTariffaria` varchar(3) NOT NULL,
  `RangeT` integer NOT NULL,
  `Prezzo` double NOT NULL,      -- vale euro per KW
  check (FasciaTariffaria='T1' or FasciaTariffaria='T2' or FasciaTariffaria='T3' or FasciaTariffaria='T4'),
  check(RangeT=5 or RangeT=13 or RangeT=15 or RangeT=21),
  check(Prezzo>0),
  PRIMARY KEY (`FasciaTariffaria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#-------------costo-------------------------

DROP TABLE IF EXISTS `costo`;
CREATE TABLE `costo` (
  `FasciaTariffaria` varchar(20) NOT NULL,
  `FasciaOraria` varchar(3) NOT NULL,
   check (FasciaTariffaria='T1' or FasciaTariffaria='T2' or FasciaTariffaria='T3' or FasciaTariffaria='T4'),
   check (FasciaOraria='F1' or FasciaOraria='F2' or FasciaOraria='F3'),
  PRIMARY KEY (`FasciaTariffaria`, `FasciaOraria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#--------------batteria------------------------

DROP TABLE IF EXISTS `batteria`;
CREATE TABLE `batteria` (
  `Data` date NOT NULL,
  `FasciaOraria` varchar(3) NOT NULL,
  `Accumulo` double NOT NULL,
  check(Accumulo>=0),
  PRIMARY KEY (`Data`, `FasciaOraria`),
  FOREIGN KEY (`FasciaOraria`) REFERENCES contatoreBidirezionale(`FasciaOraria`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#------------hottable--------------------------

DROP TABLE IF EXISTS `hotTable`;
CREATE TABLE `hotTable` (
  `Ora` integer NOT NULL,
  `Responso` varchar(5) NOT NULL,
  check(Ora>=0 and Ora<=23),
  CHECK (Responso = 'HOT' or Responso = 'COLD'),
  PRIMARY KEY (`Ora`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#-----------suggerimento---------------------------

DROP TABLE IF EXISTS `suggerimento`;
CREATE TABLE `suggerimento` (
  `Ora` integer NOT NULL,
  `CodDisp` integer NOT NULL,
  `Tip` varchar(255) NOT NULL,
  `Scelta` varchar(2) not null default 'No',
  `NomeUtente` varchar(50) NOT NULL,
  `Inizio` timestamp NOT NULL,
  `CodR` integer NOT NULL,
  check(Ora>=0 and Ora<24),
  check(Scelta='Si' or Scelta='No'),
  PRIMARY KEY (`Ora`,`CodDisp`),
  FOREIGN KEY (`Ora`) REFERENCES hotTable(`Ora`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
