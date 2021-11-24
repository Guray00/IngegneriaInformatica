
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

-- Popolamento (6 persone)
BEGIN;
INSERT INTO `nuovoUtente` VALUES ('FRYPLP74M14Z404Y','Fry','Philip J','1974-08-14','3452867014'),('TRNLLE87L69Z404O','Leela','Turanga','1974-07-29','3452867123'),('RDRBDR76C27Z404E','Bender','Rodriguez','1976-03-27','7222867123'),('ZDBJHN70T17Z404B','John','Zoidberg','1970-12-17','07987774321'),('WNGMYA80M44Z404X','Amy','Wong','1980-08-04','93981234321'),('FRNHRT41D09Z404J','Huber','Farnsworth','1941-04-09','43984754321');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `registroIscrizione` VALUES ('FRYPLP74M14Z404Y','ID12345AB','Backto3000','2010-05-02'),('TRNLLE87L69Z404O','ID31842TU','BigEyeS','2010-05-02'),('RDRBDR76C27Z404E','ID56781UR','BadShinyMetalguy','2010-05-02'),('ZDBJHN70T17Z404B','ID73546NM','ImNotMrKrab','2010-05-02'),('WNGMYA80M44Z404X','ID01321QW','Amyami','2010-05-02'),('FRNHRT41D09Z404J','ID84182JK','HubertFarnsworth41','2010-05-02');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `documento` VALUES ('ID12345AB','IDCard','2023-02-02','New New York'),('ID31842TU','IDCard','2024-11-12','New New York'),('ID56781UR','IDCard','2023-01-10','New New York'),('ID73546NM','IDCard','2022-07-17','New New York'),('ID01321QW','IDCard','2024-03-22','New New York'),('ID84182JK','IDCard','2022-02-06','New New York');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `account` VALUES ('Backto3000','123456789','Famiglia','1234','56789'),('BigEyeS','SuperMordicchio','Gestore','Il mio piu grande amore','NON FRY'),('BadShinyMetalguy','42656e646572736569756e6d69746f','Famiglia','Cosa Sono io','In Esadecimale'),('ImNotMrKrab','Sgrognixallapiastra','Famiglia','Il mio cibo preferito','Piatto tipico marziano'),('Amyami','Distrarsidalmondo','Famiglia','Dormire','Borges'),('HubertFarnsworth41','6,62606876','Famiglia','Una delle cose piu importanti in fisica','Costante di plank');
COMMIT;




#--------------dispositivo------------------------

DROP TABLE IF EXISTS `dispositivo`;
CREATE TABLE `dispositivo` (
  `CodDisp` integer NOT NULL AUTO_INCREMENT,
  `NomeDisp` varchar(50) NOT NULL,
  `TipoConsumo` varchar(50) NOT NULL,
  CHECK(TipoConsumo='Variabile' or TipoConsumo='Interrompibile' or TipoConsumo='Fisso'),
  PRIMARY KEY (`CodDisp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Popolamento 
BEGIN;
INSERT INTO `dispositivo`(NomeDisp,TipoConsumo) VALUES ('Phon','Variabile'),('Aspirapolvere','Variabile'),('ScaldaBagno','Fisso'),('Tv','Fisso'),('Forno','Fisso'),('Frullatore','Fisso'),('Lavastoviglie','Interrompibile'),('MacchinadelCaffe','Fisso'),('Tostapane','Fisso'),('Stereo','Fisso'),('Lavatrice','Interrompibile'),('Asciugatrice','Interrompibile'),('Ferrodastiro','Fisso'),('ComputerQuantistico','Fisso'),('Vaporella','Variabile'),('PlanciaOlografica','Fisso'),('Sniffoscopio','Fisso'),('LuceSoggiorno','Variabile'),('LuceCucina','Variabile'),('LuceStudio','Variabile'),('LuceBagno','Variabile'),('LuceAulaMagna','Variabile'),('LuceGarage','Variabile'),('CondSoggiorno','Variabile'),('CondCucina','Variabile'),('CondStudio','Variabile'),('CondAulaMagno','Variabile'),('Telefono1','Fisso'),('Telefono2','Fisso'),('Telefono3','Fisso'),('Trapano','Fisso'),('Flessibile','Fisso'),('AttrezziTipicidiunGarage','Fisso'),('LuceCamera1','Variabile'),('LuceCamera2','Variabile'),('LuceCamera3','Variabile'),('CondCamera1','Variabile'),('CondCamera2','Variabile'),('CondCamera3','Variabile');
COMMIT;


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

-- Popolamento 
BEGIN;
INSERT INTO `stanza`(Nome,Piano,Altezza,Larghezza,Lunghezza) VALUES ('Soggiorno','1','3.20','3.50','6'),('Cucina','1','3.15','3.50','3'),('Studio','2','3.15','7','2.5'),('Bagno','1','3.15','3.50','3.00'),('AulaMagna','2','3.00','7','3.5'),('Garage','1','3.00','7','10'),('Camera','2','3.00','3.50','5'),('Camera','2','3.00','3.50','5'),('Camera','2','3.00','3.5','10');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `smartPlug`(CodSt) VALUES ('1'),('1'),('1'),('2'),('2'),('3'),('3'),('3'),('4'),('5'),('5'),('5'),('5'),('6'),('6'),('6'),('7'),('7'),('8'),('8'),('9'),('9'),('9');
COMMIT;

#------------regolazione--------------------------
														
DROP TABLE IF EXISTS `regolazione`;						
CREATE TABLE `regolazione` (
  `CodDisp` integer NOT NULL,
  `CodR` integer NOT NULL DEFAULT 1,
  PRIMARY KEY (`CodR`, `CodDisp`),
  FOREIGN KEY (`CodDisp`) REFERENCES dispositivo(`CodDisp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- trigger che mi incrementa automaticamente a seconda di CodDisp
DROP TRIGGER IF EXISTS incrementatore_regolazione;
delimiter $$
CREATE TRIGGER incrementatore_regolazione
BEFORE INSERT ON regolazione
FOR EACH ROW
BEGIN

DECLARE _tip varchar(50) DEFAULT '';
DECLARE _reg integer DEFAULT 0;

SELECT TipoConsumo into _tip
FROM dispositivo
WHERE CodDisp=new.CodDisp;

if(_tip<>'Fisso') then -- in questo caso posso incrementare il valore di regolazione partendo dall'ultimo presente
SELECT if(Max(CodR)>0,Max(CodR),0) into _reg
FROM regolazione
where CodDisp=new.CodDisp;

SET new.CodR=_reg+1; -- incremento effettivo
end if;

END $$
delimiter ;

-- Popolamento 
BEGIN;
INSERT INTO `regolazione`(CodDisp) VALUES ('1'),('1'),('1'),('2'),('2'),('2'),('2'),('2'),('3'),('4'),('5'),('6'),('7'),('7'),('7'),('7'),('7'),('7'),('7'),('7'),('8'),('9'),('10'),('11'),('11'),('11'),('11'),('11'),('11'),('11'),('11'),('11'),('12'),('12'),('12'),('12'),('12'),('13'),('14'),('15'),('16'),('17'),('18'),('18'),('18'),('18'),('19'),('19'),('19'),('19'),('20'),('20'),('20'),('20'),('21'),('21'),('21'),('21'),('22'),('22'),('22'),('22'),('23'),('23'),('23'),('23'),('24'),('24'),('24'),('24'),('25'),('25'),('25'),('25'),('26'),('26'),('26'),('26'),('27'),('27'),('27'),('27'),('28'),('29'),('30'),('31'),('32'),('33'),('34'),('35'),('36'),('37'),('38'),('39');
COMMIT;


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

-- Popolamento 
BEGIN;
INSERT INTO `illuminazione`(CodDisp,Posizione,Cspecifico) VALUES ('18','3','60'),('19','2','50'),('20','3','50'),('21','4','30'),('22','5','70'),('23','6','120'),('34','7','60'),('35','8','60'),('36','9','60');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `condizionatore`(CodDisp,Stanza) VALUES ('24','1'),('25','2'),('26','3'),('27','5'),('37','7'),('38','8'),('39','9');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `livello` VALUES ('1','1','150'),('1','2','600'),('1','3','1200'),('2','1','600'),('2','2','700'),('2','3','800'),('2','4','900'),('2','5','1000'),('3','1','1000'),('4','1','70'),('5','1','1500'),('6','1','400'),('8','1','400'),('9','1','900'),('10','1','60'),('13','1','950'),('14','1','300'),('15','1','1500'),('15','2','1600'),('15','3','1700'),('15','4','1800'),('16','1','300'),('17','1','2800'),('28','1','3.50'),('29','1','3.30'),('30','1','3.15'),('31','1','900'),('32','1','850'),('33','1','1000');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `programma` VALUES ('7','1','Ammollo','0','1','10'),('7','2','Intensivo','70','1700','95'),('7','3','Normale_Prelavaggio','65','1500','60'),('7','4','Leggero_Prelavaggio','55','850','45'),('7','5','Economico_Prelavaggio','55','1250','100'),('7','6','Leggero','55','830','30'),('7','7','Economico','55','1000','90'),('7','8','Delicato','45','900','90'),('11','1','Cotone_20','20','280','150'),('11','2','Cotone_40','40','800','150'),('11','3','Cotone_60','60','1130','150'),('11','4','Cotone_90','90','2020','165'),('11','5','Sintetici_40','40','640','105'),('11','6','Rapido/misto','40','460','75'),('11','7','Delicati/Seta','30','240','45'),('11','8','Lana','30','220','45'),('11','9','Super15','30','100','15'),('12','1','Cotone','30','235','100'),('12','2','Delicati','20','215','100'),('12','3','Lana','40','520','90'),('12','4','Jeans','60','600','100'),('12','5','Rapido','50','450','30');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `impLuce` VALUES ('18','1','2700','65','Si'),('18','2','2300','80','No'),('18','3','2222','43','No'),('18','4','1000','30','No'),('19','1','4000','80','No'),('19','2','4500','100','Si'),('19','3','3500','86','No'),('19','4','3325','70','No'),('20','1','6000','100','Si'),('20','2','5500','100','No'),('20','3','6630','80','No'),('20','4','7000','100','Si'),('21','1','6000','100','Si'),('21','2','3000','100','Si'),('21','3','4000','100','Si'),('21','4','5000','100','Si'),('22','1','2000','100','No'),('22','2','2300','90','No'),('22','3','3000','100','Si'),('22','4','4000','100','Si'),('23','1','6000','100','Si'),('23','2','10000','100','Si'),('23','3','9000','100','Si'),('23','4','7000','100','Si'),('34','1','2500','100','Si'),('34','2','2100','100','Si'),('35','1','2500','100','Si'),('35','2','2100','100','Si'),('36','1','2500','100','Si'),('36','2','2100','100','Si');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `impCondiz`(CodDisp, CodR,Temp,Umidita,_Default) VALUES ('24','1','25','50','No'),('24','2','20','50','No'),('24','3','20','70','No'),('24','4','23','50','Si'),('25','1','25','50','No'),('25','2','20','50','No'),('25','3','20','70','No'),('25','4','23','50','Si'),('26','1','25','50','No'),('26','2','20','50','No'),('26','3','20','70','No'),('26','4','23','50','Si'),('27','1','25','50','No'),('27','2','20','50','No'),('27','3','20','70','No'),('27','4','23','50','Si'),('37','1','23','50','Si'),('38','1','23','50','Si'),('39','1','23','50','Si');
COMMIT;

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

-- Popolamento 
BEGIN;
INSERT INTO `schedule` VALUES ('HubertFarnsworth41','27','4','08:00:00','0','11','60','4','1');
COMMIT;
-- l'ora in cui viene richiamata è quella dell'ultima volta in cui è stata richiamata la regolazione (o un ora default se non c'è)

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

-- Popolamento 
BEGIN;
INSERT INTO `efficienzaEnergetica`(CodSt) VALUES ('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9');
COMMIT; 


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


-- popolamento efficienza energetica e impcondiz

-- aggiorna la tabella efficienza energetica per ogni record su termometro creato
-- aggiorna le ridondanze Tiniziale e Eunitaria in impcondiz
DROP TRIGGER IF EXISTS Calcola_Enecessaria;
delimiter $$
CREATE TRIGGER Calcola_Enecessaria
AFTER INSERT ON termometro
FOR EACH ROW
BEGIN
-- variabili per il calcolo
DECLARE _lung double DEFAULT 1; -- lunghezza
DECLARE _larg double DEFAULT 1; -- larghezza
DECLARE _alt double DEFAULT 1; -- altezza
DECLARE _p double DEFAULT 1.29; -- densità
DECLARE _Cp integer DEFAULT 1; -- calore specifico
DECLARE _DT double DEFAULT 0; -- (Testerna - Tinterna)
DECLARE Eff double DEFAULT 0; -- Energia necessaria
declare _k integer default 3; -- coefficiente conduzione mattone
declare _sp double default 0.2; -- spessore di un muro
declare _dissip double default 0; -- dissipamento istantaneo

-- calcolo effettivo
SELECT Altezza,Larghezza,Lunghezza INTO _alt,_larg,_lung -- ricavo i dati volumetrici della stanza
FROM stanza
WHERE CodSt=new.CodSt;

SET _DT=new.Testerna - new.Tinterna;
-- gestisco il valore assoluto di DT
if(_DT<0) then SET _DT=_DT*(-1);
end if;

SET Eff=_alt*_larg*_lung*_p*_Cp; -- è unitaria (1 grado)

-- aggiornamento Efficienza energetica
UPDATE efficienzaEnergetica
SET Testerna=new.Testerna, Tinterna=new.Tinterna, Enecessaria=Eff 
WHERE CodSt=new.CodSt;

-- calcolo dissipamento (istantaneo)

set _dissip=(_k/_sp)*_DT*_alt*(_lung+_larg); -- dove l'area esposta corrisponde a due pareti (alt*(lung+larg))

-- aggiornamento ridondanza impCondiz
UPDATE impcondiz
SET Tiniziale=new.Tinterna, Eunitaria=Eff, Dissipamento=_dissip
WHERE CodDisp in (Select CodDisp  -- aggiorno le ridondanze nei condizionatori della stanza dove la temperatura è variata
				  from condizionatore 
                  where Stanza=new.CodSt);



END $$
delimiter ;

-- Popolamento termometro
drop procedure if exists pop_term;
delimiter $$ 
create procedure pop_term(temp1 timestamp, temp2 timestamp)
begin
declare conto integer default 0; -- numero di stanze
declare i integer default 20; -- Temperatura esterna
declare e integer default 23; -- Temperatura interna
declare resetter timestamp default Not null; -- serve per reimpostare ogni volta temp1 ad ogni ciclo 
set resetter=temp1;

select count(*) into conto
from stanza;

WHILE conto<>0 DO -- questo while calcola le temperature delle stanze
           WHILE temp1 <= temp2 DO -- questo calcola la temperatura di un certo numero di giornate di una determinata stanza
           SET i=RAND()*(23-18)+18;
           SET e=RAND()*(23-18)+18;
			INSERT INTO termometro (CodSt,Tmisura,Tinterna,Testerna) VALUES (conto,temp1,i,e);
			SET temp1 = timestampadd(minute,15,temp1); -- aggiorno l'ora
		  END WHILE;
SET conto=conto-1;
Set temp1=resetter;

END WHILE;
end $$
delimiter ;
CALL pop_term('2021-11-03 07:00:00','2021-11-06 07:00:00'); -- 3 gg
drop procedure pop_term; -- non serve più


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

-- Popolamento 
BEGIN; -- popolo le stanze chiuse
INSERT INTO `apertura`(St1,St2,TipoApert,TipoSerr,Orientamento) VALUES ('1',NULL,'Porta','Blindata','S'),('1','2','Porta','Serratura','O'),('1',NULL,'Finestra','Persiane','E'),('1','4','Porta','Serratura','O'),('2',NULL,'Finestra','Persiane','O'),('1','6','Porta','Serratura','N'),('4',NULL,'Finestra','Persiane','O'),('6',NULL,'Porta','Serratura','N'),('1','5','Scala','Varco','E'),('6',NULL,'Finestra','Persiane','E'),('6',NULL,'Finestra','Persiane','E'),('6',NULL,'Finestra','Persiane','E'),('6',NULL,'Finestra','Persiane','E'),('6',NULL,'Finestra','Persiane','O'),('6',NULL,'Finestra','Persiane','O'),('6',NULL,'Finestra','Persiane','O'),('6',NULL,'Finestra','Persiane','O'),('5','3','Porta','Serratura','S'),('5',NULL,'Finestra','Persiane','E'),('5',NULL,'Finestra','Persiane','O'),('3',NULL,'Finestra','Persiane','S'),('9','5','Porta','Serratura','N'),('8','9','Porta','Serratura','O'),('7','9','Porta','Serratura','O'),('9',NULL,'Finestra','Persiane','E'),('9',NULL,'Finestra','Persiane','E'),('8',NULL,'PortaFinestra','Maniglia','N'),('7',NULL,'PortaFinestra','Maniglia','O');
COMMIT;

update apertura -- inizialmente solo la porta principale di casa e le finestre sono chiuse (stanno tutti a dormire)
set StatoBlocco='ON'
Where CodA=1 or CodA=8
	 or TipoApert='Finestra'
     or TipoApert='PortaFinestra';

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

-- Popolamento 
BEGIN;
INSERT INTO `registroSerramenti` VALUES ('27','2021-11-03 09:03:11','2021-11-03 15:30:00'),('26','2021-11-03 09:03:11','2021-11-03 15:30:00'),('1','2021-11-03 09:30:00','2021-11-03 09:30:53'),('1','2021-11-03 10:31:10','2021-11-03 10:31:59'),('1','2021-11-03 15:01:17','2021-11-03 15:02:53'),('1','2021-11-03 15:15:53','2021-11-03 15:16:27'),('1','2021-11-03 18:03:34','2021-11-03 18:04:00'),('1','2021-11-03 19:00:00','2021-11-03 19:00:33'),('1','2021-11-03 20:30:10','2021-11-03 20:30:30'),('1','2021-11-03 21:33:14','2021-11-03 21:33:53'),('1','2021-11-03 23:39:12','2021-11-03 23:39:49'),('1','2021-11-03 02:17:00','2021-11-03 02:17:15'),
										('27','2021-11-04 09:03:11','2021-11-04 15:30:00'),('26','2021-11-04 09:03:11','2021-11-04 15:30:00'),('1','2021-11-04 09:30:00','2021-11-04 09:30:53'),('1','2021-11-04 10:31:10','2021-11-04 10:31:59'),('1','2021-11-04 15:01:17','2021-11-04 15:02:53'),('1','2021-11-04 15:15:53','2021-11-04 15:16:27'),('1','2021-11-04 18:03:34','2021-11-04 18:04:00'),('1','2021-11-04 19:00:00','2021-11-04 19:00:33'),('1','2021-11-04 20:30:10','2021-11-04 20:30:30'),('1','2021-11-04 21:33:14','2021-11-04 21:33:53'),('1','2021-11-04 23:39:12','2021-11-04 23:39:49'),('1','2021-11-04 02:17:00','2021-11-04 02:17:15'),
                                        ('27','2021-11-05 09:03:11','2021-11-05 15:30:00'),('26','2021-11-05 09:03:11','2021-11-05 15:30:00'),('1','2021-11-05 09:30:00','2021-11-05 09:30:53'),('1','2021-11-05 10:31:10','2021-11-05 10:31:59'),('1','2021-11-05 15:01:17','2021-11-05 15:02:53'),('1','2021-11-05 15:15:53','2021-11-05 15:16:27'),('1','2021-11-05 18:03:34','2021-11-05 18:04:00'),('1','2021-11-05 19:00:00','2021-11-05 19:00:33'),('1','2021-11-05 20:30:10','2021-11-05 20:30:30'),('1','2021-11-05 21:33:14','2021-11-05 21:33:53'),('1','2021-11-05 23:39:12','2021-11-05 23:39:49'),('1','2021-11-05 02:17:00','2021-11-05 02:17:15');
COMMIT;
-- implementare una copia fake procedure di seguito (da inserire prima della begin insert di questo popolamento) che devono essere chiamate per i giorni 3,4,5 di Novembre 2021 per le ore 21:34:00 (chiusura), 23:40:00 (apertura) -> ricorda che normalmente le funzioni sotto modificano solo apertura, qui si deve modificare il registro (simile a quella di temperatura ma senza while esterno)
-- Call chiuditutto(); funzione da implementare che permette di chiudere tutta la casa -> viene anche attivata quando si presenta un intrusione
-- Call sonoacasa(); funzione che apre tutte le porte tranne la principale, le portefinestre e le finestre 
-- trigger che ogni variazione di apertura aggiorna registroSerramenti



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

-- Popolamento 
BEGIN;
INSERT INTO `controlloAccessi` VALUES ('9','24','BigEyeS','2021-11-03 08:01:11','2021-11-03 08:01:59'),('5','22','BigEyeS','2021-11-03 08:01:59','2021-11-03 08:02:05'),('1','9','BigEyeS','2021-11-03 08:02:05','2021-11-03 08:02:14'),('4','4','BigEyeS','2021-11-03 08:02:14','2021-11-03 08:22:00'),('1','4','BigEyeS','2021-11-03 08:22:00','2021-11-03 08:22:04'),('2','2','BigEyeS','2021-11-03 08:22:04','2021-11-03 08:40:14'),('1','2','BigEyeS','2021-11-03 08:40:14','2021-11-03 09:43:00'),('5','9','BigEyeS','2021-11-03 09:43:14','2021-11-03 10:31:00'),('1','9','BigEyeS','2021-11-03 10:31:00','2021-11-03 10:31:59'),('1','1','BigEyeS','2021-11-03 18:04:00','2021-11-03 18:04:45'),('5','9','BigEyeS','2021-11-03 18:04:45','2021-11-03 18:05:00'),('9','22','BigEyeS','2021-11-03 18:05:00','2021-11-03 18:05:06'),('7','24','BigEyeS','2021-11-03 18:05:06','2021-11-03 20:29:40'),('9','24','BigEyeS','2021-11-03 20:29:40','2021-11-03 20:29:45'),('5','22','BigEyeS','2021-11-03 20:29:45','2021-11-03 20:29:50'),('1','9','BigEyeS','2021-11-03 20:29:55','2021-11-03 21:33:53'),('1','1','BigEyeS','2021-11-03 23:39:49','2021-11-03 23:29:54'),('5','9','BigEyeS','2021-11-03 23:29:54','2021-11-03 23:30:00'),('9','22','BigEyeS','2021-11-03 23:30:00','2021-11-03 23:30:04'),('7','24','BigEyeS','2021-11-03 23:30:04','2021-11-04 08:01:11'),
									  ('1','1','ImNotMrKrab','2021-11-03 09:30:53','2021-11-03 09:31:00'),('5','9','ImNotMrKrab','2021-11-03 09:31:00','2021-11-03 10:30:06'),('1','9','ImNotMrKrab','2021-11-03 10:30:06','2021-11-03 10:30:15'),('2','2','ImNotMrKrab','2021-11-03 10:30:15','2021-11-03 10:50:59'),('1','2','ImNotMrKrab','2021-11-03 10:50:59','2021-11-03 10:51:09'),('4','4','ImNotMrKrab','2021-11-03 10:51:09','2021-11-03 11:35:59'),('1','4','ImNotMrKrab','2021-11-03 11:35:59','2021-11-03 11:36:07'),('5','9','ImNotMrKrab','2021-11-03 11:36:07','2021-11-03 11:36:12'),('9','22','ImNotMrKrab','2021-11-03 11:36:12','2021-11-03 12:15:41'),('5','22','ImNotMrKrab','2021-11-03 12:15:41','2021-11-03 12:15:50'),('1','9','ImNotMrKrab','2021-11-03 12:15:50','2021-11-03 12:49:59'),('2','2','ImNotMrKrab','2021-11-03 12:49:59','2021-11-03 13:48:03'),('1','2','ImNotMrKrab','2021-11-03 13:48:03','2021-11-03 15:02:53'),('1','1','ImNotMrKrab','2021-11-03 19:00:33','2021-11-03 21:33:53'),
                                      ('9','24','Backto3000','2021-11-03 09:00:05','2021-11-03 09:00:13'),('5','22','Backto3000','2021-11-03 09:00:13','2021-11-03 09:00:19'),('1','9','Backto3000','2021-11-03 09:00:19','2021-11-03 09:00:27'),('2','2','Backto3000','2021-11-03 09:00:27','2021-11-03 09:20:23'),('1','2','Backto3000','2021-11-03 09:20:23','2021-11-03 09:20:35'),('4','4','Backto3000','2021-11-03 09:20:35','2021-11-03 09:41:39'),('1','4','Backto3000','2021-11-03 09:41:39','2021-11-03 09:41:45'),('5','9','Backto3000','2021-11-03 09:41:45','2021-11-03 10:29:57'),('1','9','Backto3000','2021-11-03 10:29:57','2021-11-03 10:30:09'),('6','6','Backto3000','2021-11-03 10:30:09','2021-11-03 12:59:59'),('1','6','Backto3000','2021-11-03 12:59:59','2021-11-03 13:00:04'),('2','2','Backto3000','2021-11-03 13:00:04','2021-11-03 14:01:59'),('1','2','Backto3000','2021-11-03 14:01:59','2021-11-03 15:02:32'),('2','2','Backto3000','2021-11-03 15:02:32','2021-11-03 15:15:42'),('1','2','Backto3000','2021-11-03 15:15:42','2021-11-03 15:16:27'),('1','1','Backto3000','2021-11-03 18:04:00','2021-11-03 18:04:17'),('5','9','Backto3000','2021-11-03 18:04:17','2021-11-03 18:04:26'),('9','22','Backto3000','2021-11-03 18:04:26','2021-11-03 18:04:34'),('8','23','Backto3000','2021-11-03 18:04:34','2021-11-03 20:30:31'),('9','23','Backto3000','2021-11-03 20:30:31','2021-11-03 20:30:42'),('5','22','Backto3000','2021-11-03 20:30:42','2021-11-03 20:30:59'),('1','9','Backto3000','2021-11-03 20:30:59','2021-11-03 21:33:53'),('1','1','Backto3000','2021-11-03 23:33:53','2021-11-03 23:39:49'),('5','9','Backto3000','2021-11-03 23:39:49','2021-11-03 23:39:59'),('9','22','Backto3000','2021-11-03 23:39:59','2021-11-03 23:40:04'),('8','23','Backto3000','2021-11-03 23:40:04','2021-11-04 09:00:05'),

('9','24','BigEyeS','2021-11-04 08:01:11','2021-11-04 08:01:59'),('5','22','BigEyeS','2021-11-04 08:01:59','2021-11-04 08:02:05'),('1','9','BigEyeS','2021-11-04 08:02:05','2021-11-04 08:02:14'),('4','4','BigEyeS','2021-11-04 08:02:14','2021-11-04 08:22:00'),('1','4','BigEyeS','2021-11-04 08:22:00','2021-11-04 08:22:04'),('2','2','BigEyeS','2021-11-04 08:22:04','2021-11-04 08:40:14'),('1','2','BigEyeS','2021-11-04 08:40:14','2021-11-04 09:43:00'),('5','9','BigEyeS','2021-11-04 09:43:14','2021-11-04 10:31:00'),('1','9','BigEyeS','2021-11-04 10:31:00','2021-11-04 10:31:59'),('1','1','BigEyeS','2021-11-04 18:04:00','2021-11-04 18:04:45'),('5','9','BigEyeS','2021-11-04 18:04:45','2021-11-04 18:05:00'),('9','22','BigEyeS','2021-11-04 18:05:00','2021-11-04 18:05:06'),('7','24','BigEyeS','2021-11-04 18:05:06','2021-11-04 20:29:40'),('9','24','BigEyeS','2021-11-04 20:29:40','2021-11-04 20:29:45'),('5','22','BigEyeS','2021-11-04 20:29:45','2021-11-04 20:29:50'),('1','9','BigEyeS','2021-11-04 20:29:55','2021-11-04 21:33:53'),('1','1','BigEyeS','2021-11-04 23:39:49','2021-11-04 23:29:54'),('5','9','BigEyeS','2021-11-04 23:29:54','2021-11-04 23:30:00'),('9','22','BigEyeS','2021-11-04 23:30:00','2021-11-04 23:30:04'),('7','24','BigEyeS','2021-11-04 23:30:04','2021-11-05 08:01:11'),
									  ('1','1','ImNotMrKrab','2021-11-04 09:30:53','2021-11-04 09:31:00'),('5','9','ImNotMrKrab','2021-11-04 09:31:00','2021-11-04 10:30:06'),('1','9','ImNotMrKrab','2021-11-04 10:30:06','2021-11-04 10:30:15'),('2','2','ImNotMrKrab','2021-11-04 10:30:15','2021-11-04 10:50:59'),('1','2','ImNotMrKrab','2021-11-04 10:50:59','2021-11-04 10:51:09'),('4','4','ImNotMrKrab','2021-11-04 10:51:09','2021-11-04 11:35:59'),('1','4','ImNotMrKrab','2021-11-04 11:35:59','2021-11-04 11:36:07'),('5','9','ImNotMrKrab','2021-11-04 11:36:07','2021-11-04 11:36:12'),('9','22','ImNotMrKrab','2021-11-04 11:36:12','2021-11-04 12:15:41'),('5','22','ImNotMrKrab','2021-11-04 12:15:41','2021-11-04 12:15:50'),('1','9','ImNotMrKrab','2021-11-04 12:15:50','2021-11-04 12:49:59'),('2','2','ImNotMrKrab','2021-11-04 12:49:59','2021-11-04 13:48:03'),('1','2','ImNotMrKrab','2021-11-04 13:48:03','2021-11-04 15:02:53'),('1','1','ImNotMrKrab','2021-11-04 19:00:33','2021-11-04 21:33:53'),
                                      ('9','24','Backto3000','2021-11-04 09:00:05','2021-11-04 09:00:13'),('5','22','Backto3000','2021-11-04 09:00:13','2021-11-04 09:00:19'),('1','9','Backto3000','2021-11-04 09:00:19','2021-11-04 09:00:27'),('2','2','Backto3000','2021-11-04 09:00:27','2021-11-04 09:20:23'),('1','2','Backto3000','2021-11-04 09:20:23','2021-11-04 09:20:35'),('4','4','Backto3000','2021-11-04 09:20:35','2021-11-04 09:41:39'),('1','4','Backto3000','2021-11-04 09:41:39','2021-11-04 09:41:45'),('5','9','Backto3000','2021-11-04 09:41:45','2021-11-04 10:29:57'),('1','9','Backto3000','2021-11-04 10:29:57','2021-11-04 10:30:09'),('6','6','Backto3000','2021-11-04 10:30:09','2021-11-04 12:59:59'),('1','6','Backto3000','2021-11-04 12:59:59','2021-11-04 13:00:04'),('2','2','Backto3000','2021-11-04 13:00:04','2021-11-04 14:01:59'),('1','2','Backto3000','2021-11-04 14:01:59','2021-11-04 15:02:32'),('2','2','Backto3000','2021-11-04 15:02:32','2021-11-04 15:15:42'),('1','2','Backto3000','2021-11-04 15:15:42','2021-11-04 15:16:27'),('1','1','Backto3000','2021-11-04 18:04:00','2021-11-04 18:04:17'),('5','9','Backto3000','2021-11-04 18:04:17','2021-11-04 18:04:26'),('9','22','Backto3000','2021-11-04 18:04:26','2021-11-04 18:04:34'),('8','23','Backto3000','2021-11-04 18:04:34','2021-11-04 20:30:31'),('9','23','Backto3000','2021-11-04 20:30:31','2021-11-04 20:30:42'),('5','22','Backto3000','2021-11-04 20:30:42','2021-11-04 20:30:59'),('1','9','Backto3000','2021-11-04 20:30:59','2021-11-04 21:33:53'),('1','1','Backto3000','2021-11-04 23:33:53','2021-11-04 23:39:49'),('5','9','Backto3000','2021-11-04 23:39:49','2021-11-04 23:39:59'),('9','22','Backto3000','2021-11-04 23:39:59','2021-11-04 23:40:04'),('8','23','Backto3000','2021-11-04 23:40:04','2021-11-05 09:00:05'),


('9','24','BigEyeS','2021-11-05 08:01:11','2021-11-05 08:01:59'),('5','22','BigEyeS','2021-11-05 08:01:59','2021-11-05 08:02:05'),('1','9','BigEyeS','2021-11-05 08:02:05','2021-11-05 08:02:14'),('4','4','BigEyeS','2021-11-05 08:02:14','2021-11-05 08:22:00'),('1','4','BigEyeS','2021-11-05 08:22:00','2021-11-05 08:22:04'),('2','2','BigEyeS','2021-11-05 08:22:04','2021-11-05 08:40:14'),('1','2','BigEyeS','2021-11-05 08:40:14','2021-11-05 09:43:00'),('5','9','BigEyeS','2021-11-05 09:43:14','2021-11-05 10:31:00'),('1','9','BigEyeS','2021-11-05 10:31:00','2021-11-05 10:31:59'),('1','1','BigEyeS','2021-11-05 18:04:00','2021-11-05 18:04:45'),('5','9','BigEyeS','2021-11-05 18:04:45','2021-11-05 18:05:00'),('9','22','BigEyeS','2021-11-05 18:05:00','2021-11-05 18:05:06'),('7','24','BigEyeS','2021-11-05 18:05:06','2021-11-05 20:29:40'),('9','24','BigEyeS','2021-11-05 20:29:40','2021-11-05 20:29:45'),('5','22','BigEyeS','2021-11-05 20:29:45','2021-11-05 20:29:50'),('1','9','BigEyeS','2021-11-05 20:29:55','2021-11-05 21:33:53'),('1','1','BigEyeS','2021-11-05 23:39:49','2021-11-05 23:29:54'),('5','9','BigEyeS','2021-11-05 23:29:54','2021-11-05 23:30:00'),('9','22','BigEyeS','2021-11-05 23:30:00','2021-11-05 23:30:04'),('7','24','BigEyeS','2021-11-05 23:30:04','2021-11-06 08:01:11'),
									  ('1','1','ImNotMrKrab','2021-11-05 09:30:53','2021-11-05 09:31:00'),('5','9','ImNotMrKrab','2021-11-05 09:31:00','2021-11-05 10:30:06'),('1','9','ImNotMrKrab','2021-11-05 10:30:06','2021-11-05 10:30:15'),('2','2','ImNotMrKrab','2021-11-05 10:30:15','2021-11-05 10:50:59'),('1','2','ImNotMrKrab','2021-11-05 10:50:59','2021-11-05 10:51:09'),('4','4','ImNotMrKrab','2021-11-05 10:51:09','2021-11-05 11:35:59'),('1','4','ImNotMrKrab','2021-11-05 11:35:59','2021-11-05 11:36:07'),('5','9','ImNotMrKrab','2021-11-05 11:36:07','2021-11-05 11:36:12'),('9','22','ImNotMrKrab','2021-11-05 11:36:12','2021-11-05 12:15:41'),('5','22','ImNotMrKrab','2021-11-05 12:15:41','2021-11-05 12:15:50'),('1','9','ImNotMrKrab','2021-11-05 12:15:50','2021-11-05 12:49:59'),('2','2','ImNotMrKrab','2021-11-05 12:49:59','2021-11-05 13:48:03'),('1','2','ImNotMrKrab','2021-11-05 13:48:05','2021-11-05 15:02:53'),('1','1','ImNotMrKrab','2021-11-05 19:00:33','2021-11-05 21:33:53'),
                                      ('9','24','Backto3000','2021-11-05 09:00:05','2021-11-05 09:00:13'),('5','22','Backto3000','2021-11-05 09:00:13','2021-11-05 09:00:19'),('1','9','Backto3000','2021-11-05 09:00:19','2021-11-05 09:00:27'),('2','2','Backto3000','2021-11-05 09:00:27','2021-11-05 09:20:23'),('1','2','Backto3000','2021-11-05 09:20:23','2021-11-05 09:20:35'),('4','4','Backto3000','2021-11-05 09:20:35','2021-11-05 09:41:39'),('1','4','Backto3000','2021-11-05 09:41:39','2021-11-05 09:41:45'),('5','9','Backto3000','2021-11-05 09:41:45','2021-11-05 10:29:57'),('1','9','Backto3000','2021-11-05 10:29:57','2021-11-05 10:30:09'),('6','6','Backto3000','2021-11-05 10:30:09','2021-11-05 12:59:59'),('1','6','Backto3000','2021-11-05 12:59:59','2021-11-05 13:00:04'),('2','2','Backto3000','2021-11-05 13:00:04','2021-11-05 14:01:59'),('1','2','Backto3000','2021-11-05 14:01:59','2021-11-05 15:02:32'),('2','2','Backto3000','2021-11-05 15:02:32','2021-11-05 15:15:42'),('1','2','Backto3000','2021-11-05 15:15:42','2021-11-05 15:16:27'),('1','1','Backto3000','2021-11-05 18:04:00','2021-11-05 18:04:17'),('5','9','Backto3000','2021-11-05 18:04:17','2021-11-05 18:04:26'),('9','22','Backto3000','2021-11-05 18:04:26','2021-11-05 18:04:34'),('8','23','Backto3000','2021-11-05 18:04:34','2021-11-05 20:30:31'),('9','23','Backto3000','2021-11-05 20:30:31','2021-11-05 20:30:42'),('5','22','Backto3000','2021-11-05 20:30:42','2021-11-05 20:30:59'),('1','9','Backto3000','2021-11-05 20:30:59','2021-11-05 21:33:53'),('1','1','Backto3000','2021-11-05 23:33:53','2021-11-05 23:39:49'),('5','9','Backto3000','2021-11-05 23:39:49','2021-11-05 23:39:59'),('9','22','Backto3000','2021-11-05 23:39:59','2021-11-05 23:40:04'),('8','23','Backto3000','2021-11-05 23:40:04','2021-11-06 09:00:05'),


('9','24','Amyami','2021-11-03 08:01:15','2021-11-03 08:01:35'),('5','22','Amyami','2021-11-03 08:01:35','2021-11-03 08:01:59'),('1','9','Amyami','2021-11-03 08:01:59','2021-11-03 08:22:02'),('4','4','Amyami','2021-11-03 8:22:02','2021-11-03 8:42:03'),('1','4','Amyami','2021-11-03 08:42:03','2021-11-03 09:43:02'),('5','9','Amyami','2021-11-03 09:43:02','2021-11-03 10:25:46'),('1','9','Amyami','2021-11-03 10:25:46','2021-11-03 10:31:10'),('1','1','Amyami','2021-11-03 15:01:17','2021-11-03 15:02:56'),('5','9','Amyami','2021-11-03 15:02:56','2021-11-03 15:03:01'),('3','18','Amyami','2021-11-03 15:03:01','2021-11-03 18:03:34'),('5','18','Amyami','2021-11-03 18:03:34','2021-11-03 18:03:46'),('1','9','Amyami','2021-11-03 18:03:46','2021-11-03 18:03:53'),('4','4','Amyami','2021-11-03 18:03:53','2021-11-03 18:10:22'),('1','4','Amyami','2021-11-03 18:10:22','2021-11-03 18:10:33'),('5','9','Amyami','2021-11-03 18:10:33','2021-11-03 18:10:40'),('3','18','Amyami','2021-11-03 18:10:40','2021-11-03 20:23:42'),('5','18','Amyami','2021-11-03 20:23:42','2021-11-03 20:23:54'),('1','9','Amyami','2021-11-03 20:23:54','2021-11-03 21:33:14'),('1','1','Amyami','2021-11-03 23:39:12','2021-11-03 23:39:12'),('5','9','Amyami','2021-11-03 23:39:12','2021-11-03 23:39:23'),('9','22','Amyami','2021-11-03 23:39:23','2021-11-03 23:39:30'),('7','24','Amyami','2021-11-03 23:39:30','2021-11-03 07:59:49'),
										('9','24','Amyami','2021-11-04 08:01:15','2021-11-04 08:01:35'),('5','22','Amyami','2021-11-04 08:01:35','2021-11-04 08:01:59'),('1','9','Amyami','2021-11-04 08:01:59','2021-11-04 08:22:02'),('4','4','Amyami','2021-11-04 8:22:02','2021-11-04 8:42:03'),('1','4','Amyami','2021-11-04 08:42:03','2021-11-04 09:43:02'),('5','9','Amyami','2021-11-04 09:43:02','2021-11-04 10:25:46'),('1','9','Amyami','2021-11-04 10:25:46','2021-11-04 10:31:10'),('1','1','Amyami','2021-11-04 15:01:17','2021-11-04 15:02:56'),('5','9','Amyami','2021-11-04 15:02:56','2021-11-04 15:03:01'),('3','18','Amyami','2021-11-04 15:03:01','2021-11-04 18:03:34'),('5','18','Amyami','2021-11-04 18:03:34','2021-11-04 18:03:46'),('1','9','Amyami','2021-11-04 18:03:46','2021-11-04 18:03:53'),('4','4','Amyami','2021-11-04 18:03:53','2021-11-04 18:10:22'),('1','4','Amyami','2021-11-04 18:10:22','2021-11-04 18:10:33'),('5','9','Amyami','2021-11-04 18:10:33','2021-11-04 18:10:40'),('3','18','Amyami','2021-11-04 18:10:40','2021-11-04 20:23:42'),('5','18','Amyami','2021-11-04 20:23:42','2021-11-04 20:23:54'),('1','9','Amyami','2021-11-04 20:23:54','2021-11-04 21:33:14'),('1','1','Amyami','2021-11-04 23:39:12','2021-11-04 23:39:12'),('5','9','Amyami','2021-11-04 23:39:12','2021-11-04 23:39:23'),('9','22','Amyami','2021-11-04 23:39:23','2021-11-04 23:39:30'),('7','24','Amyami','2021-11-04 23:39:30','2021-11-04 07:59:49'),
										('9','24','Amyami','2021-11-05 08:01:15','2021-11-05 08:01:35'),('5','22','Amyami','2021-11-05 08:01:35','2021-11-05 08:01:59'),('1','9','Amyami','2021-11-05 08:01:59','2021-11-05 08:22:02'),('4','4','Amyami','2021-11-05 8:22:02','2021-11-05 8:42:03'),('1','4','Amyami','2021-11-05 08:42:03','2021-11-05 09:43:02'),('5','9','Amyami','2021-11-05 09:43:02','2021-11-05 10:25:46'),('1','9','Amyami','2021-11-05 10:25:46','2021-11-05 10:31:10'),('1','1','Amyami','2021-11-05 15:01:17','2021-11-05 15:02:56'),('5','9','Amyami','2021-11-05 15:02:56','2021-11-05 15:03:01'),('3','18','Amyami','2021-11-05 15:03:01','2021-11-05 18:03:34'),('5','18','Amyami','2021-11-05 18:03:34','2021-11-05 18:03:46'),('1','9','Amyami','2021-11-05 18:03:46','2021-11-05 18:03:53'),('4','4','Amyami','2021-11-05 18:03:53','2021-11-05 18:10:22'),('1','4','Amyami','2021-11-05 18:10:22','2021-11-05 18:10:33'),('5','9','Amyami','2021-11-05 18:10:33','2021-11-05 18:10:40'),('3','18','Amyami','2021-11-05 18:10:40','2021-11-05 20:23:42'),('5','18','Amyami','2021-11-05 20:23:42','2021-11-05 20:23:54'),('1','9','Amyami','2021-11-05 20:23:54','2021-11-05 21:33:14'),('1','1','Amyami','2021-11-05 23:39:12','2021-11-05 23:39:12'),('5','9','Amyami','2021-11-05 23:39:12','2021-11-05 23:39:23'),('9','22','Amyami','2021-11-05 23:39:23','2021-11-05 23:39:30'),('7','24','Amyami','2021-11-05 23:39:30','2021-11-05 07:59:49'),
                                      
                                        ('1','1','HubertFarnsworth41','2021-11-03 09:30:00','2021-11-03 09:44:27'),('5','9','HubertFarnsworth41','2021-11-03 9:44:27','2021-11-03 10:32:23'),('3','18','HubertFarnsworth41','2021-11-03 10:32:23','2021-11-03 13:01:34'),('5','18','HubertFarnsworth41','2021-11-03 13:01:34','2021-11-03 13:01:56'),('1','9','HubertFarnsworth41','2021-11-03 13:01:56','2021-11-03 15:10:02'),('2','2','HubertFarnsworth41','2021-11-03 13:01:56','2021-11-03 14:07:02'),('1','2','HubertFarnsworth41','2021-11-03 14:07:02','2021-11-03 15:10:02'),('5','9','HubertFarnsworth41','2021-11-03 15:10:02','2021-11-03 15:10:13'),('3','18','HubertFarnsworth41','2021-11-03 15:10:13','2021-11-03 16:20:22'),('5','18','HubertFarnsworth41','2021-11-03 16:20:22','2021-11-03 16:20:34'),('1','9','HubertFarnsworth41','2021-11-03 16:20:34','2021-11-03 16:20:41'),('4','4','HubertFarnsworth41','2021-11-03 16:20:41','2021-11-03 16:25:50'),('1','4','HubertFarnsworth41','2021-11-03 16:25:50','2021-11-03 16:26:02'),('5','9','HubertFarnsworth41','2021-11-03 16:26:02','2021-11-03 16:26:23'),('3','18','HubertFarnsworth41','2021-11-03 16:26:23','2021-11-03 20:23:48'),('5','18','HubertFarnsworth41','2021-11-03 20:23:48','2021-11-03 20:24:01'),('1','9','HubertFarnsworth41','2021-11-03 20:24:01','2021-11-03 20:30:10'),
                                        ('1','1','HubertFarnsworth41','2021-11-04 9:30:00','2021-11-04 09:44:27'),('5','9','HubertFarnsworth41','2021-11-04 9:44:27','2021-11-04 10:32:23'),('3','18','HubertFarnsworth41','2021-11-04 10:32:23','2021-11-04 13:01:34'),('5','18','HubertFarnsworth41','2021-11-04 13:01:34','2021-11-04 13:01:56'),('1','9','HubertFarnsworth41','2021-11-04 13:01:56','2021-11-04 15:10:02'),('2','2','HubertFarnsworth41','2021-11-04 13:01:56','2021-11-04 14:07:02'),('1','2','HubertFarnsworth41','2021-11-04 14:07:02','2021-11-04 15:10:02'),('5','9','HubertFarnsworth41','2021-11-04 15:10:02','2021-11-04 15:10:13'),('3','18','HubertFarnsworth41','2021-11-04 15:10:13','2021-11-04 16:20:22'),('5','18','HubertFarnsworth41','2021-11-04 16:20:22','2021-11-04 16:20:34'),('1','9','HubertFarnsworth41','2021-11-04 16:20:34','2021-11-04 16:20:41'),('4','4','HubertFarnsworth41','2021-11-04 16:20:41','2021-11-04 16:25:50'),('1','4','HubertFarnsworth41','2021-11-04 16:25:50','2021-11-04 16:26:02'),('5','9','HubertFarnsworth41','2021-11-04 16:26:02','2021-11-04 16:26:23'),('3','18','HubertFarnsworth41','2021-11-04 16:26:23','2021-11-04 20:23:48'),('5','18','HubertFarnsworth41','2021-11-04 20:23:48','2021-11-04 20:24:01'),('1','9','HubertFarnsworth41','2021-11-04 20:24:01','2021-11-04 21:30:10'),
                                        ('1','1','HubertFarnsworth41','2021-11-05 9:30:00','2021-11-05 09:44:27'),('5','9','HubertFarnsworth41','2021-11-05 9:44:27','2021-11-05 10:32:23'),('3','18','HubertFarnsworth41','2021-11-05 10:32:23','2021-11-05 13:01:34'),('5','18','HubertFarnsworth41','2021-11-05 13:01:34','2021-11-05 13:01:56'),('1','9','HubertFarnsworth41','2021-11-05 13:01:56','2021-11-05 15:10:02'),('2','2','HubertFarnsworth41','2021-11-05 13:01:56','2021-11-05 14:07:02'),('1','2','HubertFarnsworth41','2021-11-05 14:07:02','2021-11-05 15:10:02'),('5','9','HubertFarnsworth41','2021-11-05 15:10:02','2021-11-05 15:10:13'),('3','18','HubertFarnsworth41','2021-11-05 15:10:13','2021-11-05 16:20:22'),('5','18','HubertFarnsworth41','2021-11-05 16:20:22','2021-11-05 16:20:34'),('1','9','HubertFarnsworth41','2021-11-05 16:20:34','2021-11-05 16:20:41'),('4','4','HubertFarnsworth41','2021-11-05 16:20:41','2021-11-05 16:25:50'),('1','4','HubertFarnsworth41','2021-11-05 16:25:50','2021-11-05 16:26:02'),('5','9','HubertFarnsworth41','2021-11-05 16:26:02','2021-11-05 16:26:23'),('3','18','HubertFarnsworth41','2021-11-05 16:26:23','2021-11-05 20:23:48'),('5','18','HubertFarnsworth41','2021-11-05 20:23:48','2021-11-05 20:24:01'),('1','9','HubertFarnsworth41','2021-11-05 20:24:01','2021-11-05 21:30:10'),
                                        
                                        ('9','23','BadShinyMetalguy','2021-11-03 09:01:22','2021-11-03 09:01:45'),('5','22','BadShinyMetalguy','2021-11-03 09:02:10','2021-11-03 09:02:22'),('1','9','BadShinyMetalguy','2021-11-03 09:02:34','2021-11-03 09:02:42'),('2','2','BadShinyMetalguy','2021-11-03 09:02:42','2021-11-03 09:10:23'),('1','2','BadShinyMetalguy','2021-11-03 09:10:23','2021-11-03 09:42:11'),('5','9','BadShinyMetalguy','2021-11-03 09:42:11','2021-11-03 10:31:45'),('1','9','BadShinyMetalguy','2021-11-03 10:31:45','2021-11-03 10:31:59'),('6','6','BadShinyMetalguy','2021-11-03 10:31:59','2021-11-03 13:00:43'),('1','6','BadShinyMetalguy','2021-11-03 13:00:43','2021-11-03 13:01:12'),('2','2','BadShinyMetalguy','2021-11-03 13:01:12','2021-11-03 14:06:22'),('1','2','BadShinyMetalguy','2021-11-03 14:06:22','2021-11-03 15:01:17'),('1','1','BadShinyMetalguy','2021-11-03 19:00:23','2021-11-03 19:09:46'),('2','2','BadShinyMetalguy','2021-11-03 19:09:46','2021-11-03 19:24:56'),('1','2','BadShinyMetalguy','2021-11-03 19:24:56','2021-11-03 21:33:08'),('1','1','BadShinyMetalguy','2021-11-03 02:17:09','2021-11-03 02:17:23'),('5','9','BadShinyMetalguy','2021-11-03 02:17:23','2021-11-03 02:17:39'),('9','22','BadShinyMetalguy','2021-11-03 02:17:39','2021-11-03 02:17:57'),('8','23','BadShinyMetalguy','2021-11-03 02:17:57','2021-11-03 09:01:05'),
										('9','23','BadShinyMetalguy','2021-11-04 09:01:05','2021-11-04 09:01:45'),('5','22','BadShinyMetalguy','2021-11-04 09:02:10','2021-11-04 09:02:22'),('1','9','BadShinyMetalguy','2021-11-04 09:02:34','2021-11-04 09:02:42'),('2','2','BadShinyMetalguy','2021-11-04 09:02:42','2021-11-04 09:10:23'),('1','2','BadShinyMetalguy','2021-11-04 09:10:23','2021-11-04 09:42:11'),('5','9','BadShinyMetalguy','2021-11-04 09:42:11','2021-11-04 10:31:45'),('1','9','BadShinyMetalguy','2021-11-04 10:31:45','2021-11-04 10:31:59'),('6','6','BadShinyMetalguy','2021-11-04 10:31:59','2021-11-04 13:00:43'),('1','6','BadShinyMetalguy','2021-11-04 13:00:43','2021-11-04 13:01:12'),('2','2','BadShinyMetalguy','2021-11-04 13:01:12','2021-11-04 14:06:22'),('1','2','BadShinyMetalguy','2021-11-04 14:06:22','2021-11-04 15:01:17'),('1','1','BadShinyMetalguy','2021-11-04 19:00:23','2021-11-04 19:09:46'),('2','2','BadShinyMetalguy','2021-11-04 19:09:46','2021-11-04 19:24:56'),('1','2','BadShinyMetalguy','2021-11-04 19:24:56','2021-11-04 21:33:08'),('1','1','BadShinyMetalguy','2021-11-04 02:17:09','2021-11-04 02:17:23'),('5','9','BadShinyMetalguy','2021-11-04 02:17:23','2021-11-04 02:17:39'),('9','22','BadShinyMetalguy','2021-11-04 02:17:39','2021-11-04 02:17:57'),('8','23','BadShinyMetalguy','2021-11-04 02:17:57','2021-11-04 09:00:45'),
										('9','23','BadShinyMetalguy','2021-11-05 09:00:45','2021-11-05 09:01:45'),('5','22','BadShinyMetalguy','2021-11-05 09:02:10','2021-11-05 09:02:22'),('1','9','BadShinyMetalguy','2021-11-05 09:02:34','2021-11-05 09:02:42'),('2','2','BadShinyMetalguy','2021-11-05 09:02:42','2021-11-05 09:10:23'),('1','2','BadShinyMetalguy','2021-11-05 09:10:23','2021-11-05 09:42:11'),('5','9','BadShinyMetalguy','2021-11-05 09:42:11','2021-11-05 10:31:45'),('1','9','BadShinyMetalguy','2021-11-05 10:31:45','2021-11-05 10:31:59'),('6','6','BadShinyMetalguy','2021-11-05 10:31:59','2021-11-05 13:00:43'),('1','6','BadShinyMetalguy','2021-11-05 13:00:43','2021-11-05 13:01:12'),('2','2','BadShinyMetalguy','2021-11-05 13:01:12','2021-11-05 14:06:22'),('1','2','BadShinyMetalguy','2021-11-05 14:06:22','2021-11-05 15:01:17'),('1','1','BadShinyMetalguy','2021-11-05 19:00:23','2021-11-05 19:09:46'),('2','2','BadShinyMetalguy','2021-11-05 19:09:46','2021-11-05 19:24:56'),('1','2','BadShinyMetalguy','2021-11-05 19:24:56','2021-11-05 21:33:08'),('1','1','BadShinyMetalguy','2021-11-05 02:17:09','2021-11-05 02:17:23'),('5','9','BadShinyMetalguy','2021-11-05 02:17:23','2021-11-05 02:17:39'),('9','22','BadShinyMetalguy','2021-11-05 02:17:39','2021-11-05 02:17:57'),('8','23','BadShinyMetalguy','2021-11-05 02:17:57','2021-11-05 09:02:32');

COMMIT;
-- trigger che se vede entrare uno sconosciuto chiude tutte gli accessi, apparte quello da dove proviene (per farlo scappare) e accende le luci per segnalarlo agli inquilini o spaventare l'intruso se è notte
-- funzione che descrive il percorso di una persona tramite una pivot (può essere utile per analytic e quando cerchiamo di capire cosa succede nel DB)


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

-- trigger che popola inizialmente consumo (viene eliminato dopo il primo uso e ne viene creata una versione che funzioni con la normale esecuzione del DB)

drop trigger if exists calcoloConsumo; 
delimiter $$
create trigger calcoloConsumo after insert on Interazione for each row 
begin 
	
    declare ValConsumo double default 0; 
    declare TipoD varchar(40) default ''; 
    declare tempoD integer default 0; 
    declare F varchar(3) default ''; 
    declare H integer default 0; 
    declare TempCondiz integer default 0; 
    declare TempInterna integer default 0; 
    declare TempExt integer default 0; 
    declare Diss double default 0; 
    
    declare finito integer default 0; 
    
    select	tipoconsumo into TipoD
    from 	Dispositivo 
    where	coddisp = new.coddisp; 
    
	if TipoD = 'Fisso' then 				
		begin 
			select	l.CLVL 	into ValConsumo 
			from 	Livello l
			where	l.codr = new.codr
			and 	l.coddisp = new.coddisp; 
			
			set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
            
			select	distinct last_value(FasciaOraria) over() into F
			from 	contatorebidirezionale
			where	RangeF <= hour(new.Inizio);
			
			set H = hour(new.inizio);
		
			insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
		end; 
	end if; 
	
    if TipoD = 'Variabile' then 
		if new.coddisp in 	(						-- Illuminazione
							select  i.coddisp 
                            from 	illuminazione i
							) then 
			begin 
				select	i1.cspecifico into ValConsumo
                from 	illuminazione i1
                where	i1.coddisp = new.coddisp;
					
				set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
                
                select	distinct last_value(FasciaOraria) over() into F
				from 	contatorebidirezionale
				where	RangeF <= hour(new.Inizio);
				
				set H = hour(new.inizio);
			
				insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
                
                set finito = 1; 
			end;
		end if; 
        if new.coddisp in 	(						-- Condizionamento 
							select 	c.coddisp
                            from	condizionatore c
							) then 
                begin
					select	im.EUnitaria, im.Dissipamento, im.Temp, im.Tiniziale into ValConsumo, Diss, TempCondiz, TempInterna
                    from 	ImpCondiz im
                    where	im.coddisp =new.coddisp
                    and 	im.codr = new.codr;
					
					set ValConsumo = ValConsumo * abs(TempCondiz-TempInterna) + (Diss * ((time_to_sec(timediff(new.fine, new.inizio)))/3600));
			
					select	distinct last_value(FasciaOraria) over() into F
					from 	contatorebidirezionale
					where	RangeF <= hour(new.Inizio);
					
					set H = hour(new.inizio);
				
					insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
					
                    set finito = 1; 
				end; 
		end if; 
        if finito = 0 then 							-- Dispositivi Variabili al di fuori di Illuminazione e Condizinamento 
			begin	
				select	l1.CLVL into ValConsumo
				from 	livello l1
				where	l1.codr = new.codr
				and 	l1.coddisp = new.coddisp; 
				
				set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
				
				select	distinct last_value(FasciaOraria) over() into F
				from 	contatorebidirezionale
				where	RangeF <= hour(new.Inizio);
				
				set H = hour(new.inizio);
			
				insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
			end; 
		end if; 
    end if; 
    
    if tipoD = 'Interrompibile' then 
		begin 
			select	CMedio, Durata into ValConsumo, TempoD
            from 	programma	
            where 	codr = new.codr
            and 	coddisp = new.coddisp;
            
            set ValConsumo = ValConsumo * (TempoD/60); 
            			
			select	distinct last_value(FasciaOraria) over() into F
			from 	contatorebidirezionale
			where	RangeF <= hour(new.Inizio);
			
			set H = hour(new.inizio);
		
			insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
        end; 
	end if; 
end $$
delimiter ;

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

-- Popolamento interazione
drop procedure if exists pop_interazione;
delimiter $$ 
create procedure pop_interazione(temp1 date, temp2 date)
begin


           WHILE temp1 <= temp2 DO -- questo calcola la temperatura di un certo numero di giornate di una determinata stanza
           set @interaz=null;
           
           set @interaz=concat("
           INSERT INTO interazione VALUES 
			                     ('Backto3000','",temp1," 09:00:30','8','1','",temp1," 09:02:30','No'),('Backto3000','",temp1," 09:00:33','9','1','",temp1," 09:02:30','No'),('Backto3000','",temp1," 09:42:00','28','1','",temp1," 10:20:13','No'),('Backto3000','",temp1," 14:02:05','4','1','",temp1," 15:01:02','No'),('Backto3000','",temp1," 15:03:41','8','1','",temp1," 15:05:16','No'),('Backto3000','",temp1," 18:05:01','10','1','",temp1," 20:28:21','No'),('Backto3000','",temp1," 18:05:01','35','1','",temp1," 20:28:21','No'),('Backto3000','",temp1," 23:33:54','35','1','",temp1," 23:39:48','No'),('Backto3000','",temp1," 23:39:50','22','1','",temp1," 23:39:58','No'),('Backto3000','",temp1," 23:40:00','36','2','",temp1," 23:40:04','No'),
								 ('BigEyeS','",temp1," 08:02:20','3','1','",temp1," 08:16:01','No'),('BigEyeS','",temp1," 08:16:20','1','2','",temp1," 08:20:01','No'),('BigEyeS','",temp1," 08:22:27','8','1','",temp1," 08:33:01','No'),('BigEyeS','",temp1," 08:22:27','9','1','",temp1," 08:33:01','No'),('BigEyeS','",temp1," 18:05:07','34','1','",temp1," 20:29:39','No'),('BigEyeS','",temp1," 18:05:07','30','1','",temp1," 19:26:17','No'),('BigEyeS','",temp1," 21:05:07','7','4','",temp1," 21:50:07','No'),
                                 ('ImNotMrKrab','",temp1," 10:30:20','5','1','",temp1," 10:50:01','No'),('ImNotMrKrab','",temp1," 10:51:30','11','9','",temp1," 11:6:30','No'),('ImNotMrKrab','",temp1," 11:06:45','12','5','",temp1," 11:35:45','No'),('ImNotMrKrab','",temp1," 11:37:00','13','1','",temp1," 12:14:48','No'),('ImNotMrKrab','",temp1," 12:26:03','2','1','",temp1," 12:38:56','No'),('ImNotMrKrab','",temp1," 19:00:48','4','1','",temp1," 20:28:01','No'),
                                 ('Amyami','",temp1," 08:22:45','3','1','",temp1," 08:30:22','NO'),('Amyami','",temp1," 08:31:22','1','2','",temp1," 08:38:56','NO'),('Amyami','",temp1," 08:43:06','4','1','",temp1," 09:22:45','NO'),('Amyami','",temp1," 09:24:02','2','3','",temp1," 09:29:21','NO'),('Amyami','",temp1," 15:04:23','29','1','",temp1," 15:24:56','NO'),('Amyami','",temp1," 15:45:21','14','1','",temp1," 17:30:13','NO'),('Amyami','",temp1," 17:35:23','29','1','",temp1," 17:55:51','NO'),('Amyami','",temp1," 18:04:21','1','1','",temp1," 21:32:59','NO'),('Amyami','",temp1," 18:04:44','21','2','",temp1," 18:10:32','NO'),('Amyami','",temp1," 18:13:34','14','1','",temp1," 19:55:23','NO'),('Amyami','",temp1," 19:55:34','29','1','",temp1," 20:19:56','NO'),('Amyami','",temp1," 23:39:13','24','1','",temp1," 23:39:20','NO'),
							     ('HubertFarnsworth41','",temp1," 09:32:21','30','1','",temp1," 09:43:32','NO'),('HubertFarnsworth41','",temp1," 09:46:23','16','1','",temp1," 10:23:34','NO'),('HubertFarnsworth41','",temp1," 10:38:21','14','1','",temp1," 12:55:45','NO'),('HubertFarnsworth41','",temp1," 13:45:34','30','1','",temp1," 13:59:21','NO'),('HubertFarnsworth41','",temp1," 15:15:23','14','1','",temp1," 16:23:46','NO'),('HubertFarnsworth41','",temp1," 16:45:21','14','1','",temp1," 18:23:45','NO'),('HubertFarnsworth41','",temp1," 18:25:34','30','1','",temp1," 19:21:54','NO'),('HubertFarnsworth41','",temp1," 18:26:38','17','1','",temp1," 20:23:43','NO'),
								 ('BadShinyMetalguy','",temp1," 09:12:34','6','1','",temp1," 09:13:01','NO'), ('BadShinyMetalguy','",temp1," 09:15:02','9','1','",temp1," 09:18:22','NO'),('BadShinyMetalguy','",temp1," 10:34:21','31','1','",temp1," 10:36:35','NO'),('BadShinyMetalguy','",temp1," 10:39:45','31','1','",temp1," 10:41:33','NO'),('BadShinyMetalguy','",temp1," 10:45:34','31','1','",temp1," 10:52:12','NO'),('BadShinyMetalguy','",temp1," 11:32:45','32','1','",temp1," 11:50:21','NO'),('BadShinyMetalguy','",temp1," 12:34:34','31','1','",temp1," 12:44:23','NO'),('BadShinyMetalguy','",temp1," 13:14:54','15','3','",temp1," 13:20:23','NO'),('BadShinyMetalguy','",temp1," 13:43:12','7','5','",temp1," 15:13:12','NO'),('BadShinyMetalguy','",temp1," 19:13:44','6','1','",temp1," 19:14:21','NO'),('BadShinyMetalguy','",temp1," 19:32:44','5','1','",temp1," 20:00:21','NO');   "
           );
           prepare sql_statement from @interaz; 
           execute sql_statement;
			
            SET temp1 = date_add(temp1, interval 1 day); -- aggiorno l'ora
		  END WHILE;

end $$
delimiter ;
CALL pop_interazione('2021-11-03','2021-11-06'); -- 3 gg
drop procedure pop_interazione; -- non serve più

drop trigger if exists calcoloConsumo; -- ora non serve più


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

-- Popolamento 
drop procedure if exists pop_foto;
delimiter $$ 
create procedure pop_foto(temp1 timestamp, temp2 timestamp)
begin

declare en double default 0;
declare f varchar(3) default '';

WHILE temp1 <= temp2 DO -- genera produzioni randomiche nei 3 gg


-- i valori randomici di produzione sono stabiliti secondo un range che è diverso a seconda delle ore della giornata (simula l'incidenza del sole)

if (hour(temp1)>=12 and hour(temp1)<=15) then
SET en=RAND()*(1200-1100)+1100;
end if;

if (hour(temp1)>=0 and hour(temp1)<5) then 
SET en=0; 
end if;

if (hour(temp1)<8 and hour(temp1)>=6) then
SET en=RAND()*(500-400)+300;
end if;

if (hour(temp1)<10 and hour(temp1)>=8) then
SET en=RAND()*(700-400)+400;
end if;

if (hour(temp1)<11 and hour(temp1)>=10) then
SET en=RAND()*(700-400)+500;
end if;

if (hour(temp1)<12 and hour(temp1)>=11) then
SET en=RAND()*(700-400)+400;
end if;

if (hour(temp1)<=17 and hour(temp1)>15) then
SET en=RAND()*(1000-800)+800;
end if;

if (hour(temp1)<20 and hour(temp1)>=17) then 
SET en=RAND()*(400-200)+500; 
end if; 

if (hour(temp1)>=20 and hour(temp1)<=23) then 
SET en=0; 
end if;

-- determina la fascia oraria
if (hour(temp1)>=5 and hour(temp1)<=12) then set f='F1'; end if;
if (hour(temp1)>=13 and hour(temp1)<=20) then set f='F2'; end if;
if (hour(temp1)>=21) then set f='F3'; end if;


INSERT INTO pannelliFotovoltaici (Istante,Energia,FasciaOraria,Ora) VALUES (temp1,en,f,hour(temp1));
SET temp1 = timestampadd(minute,15,temp1); -- aggiorno l'ora
END WHILE;

end $$
delimiter ;
CALL pop_foto('2021-11-03 07:00:00','2021-11-06 07:00:00'); -- 3 gg
drop procedure pop_foto; -- non serve più




-- Popolamento contatore bidirezionale
BEGIN;
INSERT INTO `contatoreBidirezionale`(FasciaOraria,RangeF,Preferenza) VALUES ('F1','5','Immettere'),('F2','13','Autoconsumare'),('F3','21','Riserva');
COMMIT;

-- si crea una stored procedure che fa update rispetto all'ultimo giorno
drop procedure if exists pop_contatore;
delimiter $$
create procedure pop_contatore()
begin
	declare Prod double default 0; 
	declare Cons double default 0; 
	declare Ora integer default 5; -- fascia oraria di partenza 
    declare fa varchar(3) default ''; -- nome della fascia oraria
    

fascia:loop
if(Ora>21) then leave fascia;
end if;

-- determinare la fascia
case Ora
when 5 then set fa='F1';
when 13 then set fa='F2';
when 21 then set fa='F3';
else set fa='F1';
end case;

-- calcolo consumo
select if(sum(EnergiaConsumata) is null,0,sum(EnergiaConsumata)) into Cons
from consumo
where FasciaOraria=fa
	  and day(Inizio)=5; -- va aggiornata all'ultimo giorno disponibile del popolamento

-- calcolo produzione
select if(sum(Energia) is null,0,sum(Energia)) into Prod
from pannellifotovoltaici
where FasciaOraria=fa
	  and day(Istante)=5; -- va aggiornata all'ultimo giorno disponibile del popolamento


update contatorebidirezionale
set RiepilogoP=Prod, RiepilogoC=Cons
where RangeF=Ora;

set Ora=Ora+8;
end loop;
        
end $$
delimiter ; 
call pop_contatore();
drop procedure pop_contatore;

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

-- Popolamento 
BEGIN;
INSERT INTO `contratto` VALUES ('T1','5','100'),('T2','13','110'),('T3','15','50'),('T4','21','30');
COMMIT;


#-------------costo-------------------------

DROP TABLE IF EXISTS `costo`;
CREATE TABLE `costo` (
  `FasciaTariffaria` varchar(20) NOT NULL,
  `FasciaOraria` varchar(3) NOT NULL,
   check (FasciaTariffaria='T1' or FasciaTariffaria='T2' or FasciaTariffaria='T3' or FasciaTariffaria='T4'),
   check (FasciaOraria='F1' or FasciaOraria='F2' or FasciaOraria='F3'),
  PRIMARY KEY (`FasciaTariffaria`, `FasciaOraria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Popolamento 
BEGIN;
INSERT INTO `costo` VALUES ('T1','F1'),('T2','F2'),('T3','F2'),('T4','F3');
COMMIT;


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

-- Popolamento 
drop procedure if exists Popolamento_Batteria; 
delimiter $$
create procedure Popolamento_Batteria ()
begin 
	
    declare Fascia varchar(3) default ''; 
    declare Prod double default 0; 
    
    declare var tinyint default 0;



declare bact cursor for -- vengono presi solo i record schedulati che hanno raggiunto la fine regolazione
select FasciaOraria,RiepilogoP
from contatorebidirezionale
where Preferenza='Riserva';
    
declare continue handler
for not found set var=1;

open bact;
scan:loop  -- serve a popolare nel caso ci siano più fascie in riserva
fetch bact into fascia,prod;

if(var=1)then leave scan;
end if;

	insert into Batteria values ('2021-11-03', fascia, prod),('2021-11-04',fascia,prod),('2021-11-05',fascia,prod); -- in questo caso il popolamento è su 3 gg

end loop;
close bact;


end $$
delimiter ; 

call Popolamento_Batteria();
drop procedure Popolamento_Batteria;




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

-- popolamento

drop procedure if exists CreazioneSuggerimento; 
delimiter $$
create procedure CreazioneSuggerimento () 
begin 
    
    declare H integer default 0; 
    declare Resp varchar(4) default ''; 
    declare HDispHot integer default 0;
    declare DispHot integer default 0; 
    declare CodRegHot integer default 0; 
    
    declare Sugg varchar(255) default '';
    declare OraConsigliata integer default 0; 
    declare DataConsigliata timestamp default '0000-00-00 00:00:00'; 
    
    declare UscitaWhile integer default 0; 
    declare Ranking integer default 0; 
    declare OraFreq integer default 0; 
    
	declare nSugg integer default 3; 
    declare nRank integer default 0;
    
    declare finito integer default 0; 
	declare OreProduttive cursor for													#Classifica delle Ore più Produttive degli Ultimi 3 Giorni
		select 	hour(Ora) as Ora, RankingProduzione
		from 	(        
				select	*, rank() over(order by MediaProduzioneOraria desc) as RankingProduzione 
				from 	(
						select	istante as Ora, avg(energia) as MediaProduzioneOraria
						from 	pannellifotovoltaici 
                        where	day(istante) between (day(subdate(/*current_date()*/'2021-11-04', 3))) and day(/*current_date()*/'2021-11-04')
						and		month(istante) between month(subdate(/*current_date()*/'2021-11-04', 3)) and month(/*current_date()*/'2021-11-04')	
						group 	by hour(istante)
						) as D
				where	MediaProduzioneOraria <> 0
				) as D1;
    declare continue handler for not found set finito = 1; 
    

    truncate Suggerimento;
    
    replace 	into HotTable 																																						#Creazione HotTable (Ore con Prod>Cons = 'Cold' & Ore con Prod<Cons 'Hot'); I Dati considerati sono quelli degli Ultimi 3 Giorni 
		select	hour(inizio) as Ora, if(avg(energiaconsumata) < avg(energia), "COLD", "HOT") as Responso 
		from 	consumo c
				inner join pannellifotovoltaici p on hour(p.istante) = hour(c.inizio)
		where	day(inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
		and		month(inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/)
		and		timediff(inizio, istante) > 0
		and 	timediff(inizio, istante) <= '00:15:00'
		group	by hour(inizio), hour(istante);
		
    while uscitawhile = 0 do
		
        begin 
			select 	distinct first_value(D.coddisp) over(), 
					first_value(D.codr) over(), 
					first_value(rankingorder) over() into DispHot, CodRegHot, Ranking																								#Identificazione del Dispositivo che ha Consumato di più mediamente negli ultimi 3 giorni
			from	(
					select 	c.coddisp, c.codr, rank() over (order by avg(energiaConsumata) desc) as RankingOrder 
					from	consumo c
					where	day(c.inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
					and		month(c.inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/)
					group 	by c.coddisp
					) as D
			where 	rankingorder > Ranking; 
			-- select 	DispHot, Ranking; 

			select 	distinct first_value(Ora) over() into OraFreq
			from 	(
					select 	coddisp, 
							hour(inizio) as Ora, 
							count(*) as VolteUsatoinQuestOra, 
							avg(energiaconsumata) as MedioConsumo, 
							rank() over(order by count(*) desc) as RankingUsage, 
							rank() over(order by avg(energiaconsumata) desc) as RankingEn
					from 	consumo c
					where	coddisp = DispHot
                    and		day(c.inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
					and		month(c.inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/) 	
					group 	by hour(inizio)
					) as D	
			where 	RankingUsage = 1
			and 	RankingEn = 1; 
			-- select	OraFreq;

			if 	OraFreq not in		(																#Se l'Ora in cui è stato utilizzato il Dispositivo più Dispendioso NON si trova nelle Ore 'Cold' (Prod>Cons)
									select	ora
									from 	hottable 
									where	responso = 'COLD'
									) 	then 
				set UscitaWhile = 1; 
			end if; 
		end; 
        
	end while;         
        
        begin																																									#Si Creano un MAX di 3 Suggerimenti per il solito Disp e Regolazione nelle Ore più Produttive degli ultimi 3 giorni 
			open OreProduttive; 
			preleva : loop 
				fetch OreProduttive into OraConsigliata, nRank;
				
				if finito = 1 then 
					leave preleva; 
				end if; 
		
				if nSugg = 0 then 
					leave preleva; 
				end if; 
                
				if  OraConsigliata not in	(																																	#Sempre Verificando che l'Ora più Produttiva coincida con una delle Ore 'Cold' 
											select	Ora	
											from	hottable
											where	responso = 'COLD'
											) then 
												iterate preleva; 
				else 
					set nSugg = nSugg - 1; 
                    
                    select timestamp(current_date(), sec_to_time(OraConsigliata*3600)) into DataConsigliata;
                    
					if nRank = 1 then 
						set Sugg = concat('Suggerimento : E`*Fortemente* Consigliato di Usare il Dispositivo ', DispHot, ' alle Ore ', OraConsigliata, ' di Domani'); 
                    else
						set Sugg = concat('Suggerimento : E`Anche Consigliato di Usare il Dispositivo ', DispHot, ' alle Ore ', OraConsigliata, ' di Domani'); 
                    end if; 
					
                    set DataConsigliata = adddate(DataConsigliata, 1);
                    replace into Suggerimento values (OraConsigliata, DispHot, Sugg, 'NO', 'Gestore', DataConsigliata, CodRegHot);
				end if; 
                
			end loop;
            close OreProduttive; 
		end; 


end $$
delimiter ; 

call CreazioneSuggerimento();
drop procedure if exists CreazioneSuggerimento; -- serve solo per il popolamento
 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 



# TRIGGER PER APERTURA ------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

drop trigger if exists Verifica_Apertura; -- verifica che in apertura St1 e St2 siano esistenti e che non si possa reinserire un'apertura equivalente
delimiter $$                              -- un'apertura è equivalente a un'altra se St1=St2' e St2=St1' (per questo vanno evitate) 
create trigger Verifica_Apertura
before insert on Apertura for each row 
begin 
	
    -- verifica su St1
    if not exists( 
					select* 
					from 	Stanza 
					where CodSt=new.St1
                  ) then
		signal sqlstate '45000'
        set message_text = 'Errore : Stanza 1 inserita NON Esistente'; 
	end if;
    
	-- verifica su st2
    if(new.St2 is not null) -- perchè in caso alternativo non c'è bisogno di verificarlo
	   then
    
			if not exists(
							select*
							from 	Stanza 
							where CodSt=new.St2
							  
						 )then 
				signal sqlstate '45000'
				set message_text = 'Errore : Stanza 2 inserita NON Esistente'; 
			end if;
    
    end if;
    
    -- verifica su porte equivalenti
    if exists ( select*
				from Apertura
                where St1=new.St2 and St2=new.St1
               ) then
                signal sqlstate '45000'
				set message_text = 'Errore : Stanza 2 inserita NON Esistente';
    end if;
    
end $$
delimiter ;  
#--------------------------------------------------------








# TRIGGER PER LE IMPOSTAZIONI-----------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------

drop trigger if exists VerificaNumImpostazioni_Luce; -- non si possono avere più di 5 impostazioni personalizzabili per dispositivo
delimiter $$
create trigger VerificaNumImpostazioni_Luce
before insert on impLuce for each row 
begin
    declare count integer default 0; 
    
    select	count(*) into count
    from 	impLuce
    where 	coddisp = new.coddisp;
    
    if count >= 5 then
		signal sqlstate '45000'
        set message_text = 'Errore : Impostazioni Disponibili Terminate'; 
	end if; 
    
end $$
delimiter ;  
#---------------------------------------------------------

drop trigger if exists DefaultImpostazioni_Luce; -- se si modifica un impostazione non può essere più default
delimiter $$
create trigger DefaultImpostazioni_Luce
after update on impLuce for each row 
begin 
	
    if(new._Default='Si') then
    update 	impLuce 
    set 	_Default = 'No'
    where  CodDisp=new.CodDisp and CodR=new.CodR;
    end if;
    
end $$
delimiter ; 
#---------------------------------------------------------

drop trigger if exists VerificaNumImpostazioni_Condizionatore; -- possono esserci al massimo 5 impostazioni per condizionatore
delimiter $$
create trigger VerificaNumImpostazioni_Condizionatore 
before insert on impCondiz for each row
begin 

	declare count integer default 0; 
    
    select	count(*) into count
    from 	impCondiz
    where 	coddisp = new.coddisp;
    
    if count = 5 then
		signal sqlstate '45000'
        set message_text = 'Errore : Impostazioni Disponibili Terminate'; 
	end if; 

end $$
delimiter ;
#---------------------------------------------------------

drop trigger if exists DefaultImpostazioni_Condizionatore; -- se si modifica un impostazione non può essere più default
delimiter $$
create trigger DefaultImpostazioni_Condizionatore 
before insert on impCondiz for each row
begin 

if(new._Default='Si') then
    update 	impCondiz 
    set 	_Default = 'No'
    where  CodDisp=new.CodDisp and CodR=new.CodR;
    end if;
        
end $$
delimiter ;

#---------------------------------------------------------









#TRIGGER PER SMARTPLUG---------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------
drop trigger if exists VerificaCodDispCodSt_SmartP_1; -- gestisce solo la creazione di smartplug 
delimiter $$
create trigger VerificaCodDispCodSt_SmartP_1
before insert on smartplug for each row
begin 
	
    if(new.CodDisp is not null) -- perchè la smartplug potrebbe non avere dispositivi connessi
    then 
    if not exists 	(
					select	*
                    from 	Dispositivo 
                    where 	CodDisp = new.CodDisp
					)	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Dispositivo NON Riconosciuto';
	end if; 
    end if;
    
    if not exists 	(
					select	*
                    from 	Stanza s
                    where 	s.CodSt = new.CodSt
					) 	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Stanza NON Riconosciuta';
	end if; 

end $$
delimiter ;
#---------------------------------------------------------

drop trigger if exists VerificaCodDispCodSt_SmartP_1; -- gestisce l'update di smartplug 
delimiter $$
create trigger VerificaCodDispCodSt_SmartP_1
before update on smartplug for each row
begin 
	
    if(new.CodDisp is not null) -- perchè la smartplug potrebbe non avere dispositivi connessi
    then 
    if not exists 	(
					select	*
                    from 	Dispositivo 
                    where 	CodDisp = new.CodDisp
					)	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Dispositivo NON Riconosciuto';
	end if; 
    end if;
    
    if not exists 	( -- sta in una precisa stanza
					select	*
                    from 	Stanza s
                    where 	s.CodSt = new.CodSt
					) 	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Stanza NON Riconosciuta';
	end if; 

end $$
delimiter ;

#---------------------------------------------------------



#AGGIORNAMENTO RIDONDANZE IMPCondiz-----------------------------------------------------------------------------------------------------

-- aggiorna la tabella efficienza energetica per ogni record su termometro creato
-- aggiorna le ridondanze Tiniziale e Eunitaria in impcondiz
DROP TRIGGER IF EXISTS Calcola_Enecessaria;
delimiter $$
CREATE TRIGGER Calcola_Enecessaria
AFTER INSERT ON termometro
FOR EACH ROW
BEGIN
-- variabili per il calcolo
DECLARE _lung double DEFAULT 1; -- lunghezza
DECLARE _larg double DEFAULT 1; -- larghezza
DECLARE _alt double DEFAULT 1; -- altezza
DECLARE _p double DEFAULT 1.29; -- densità
DECLARE _Cp integer DEFAULT 1; -- calore specifico
DECLARE _DT double DEFAULT 0; -- (Testerna - Tinterna)
DECLARE Eff double DEFAULT 0; -- Energia necessaria
declare _k integer default 3; -- coefficiente conduzione mattone
declare _sp double default 0.2; -- spessore di un muro
declare _dissip double default 0; -- dissipamento istantaneo

-- calcolo effettivo
SELECT Altezza,Larghezza,Lunghezza INTO _alt,_larg,_lung -- ricavo i dati volumetrici della stanza
FROM stanza
WHERE CodSt=new.CodSt;

SET _DT=new.Testerna - new.Tinterna;
-- gestisco il valore assoluto di DT
if(_DT<0) then SET _DT=_DT*(-1);
end if;

SET Eff=_alt*_larg*_lung*_p*_Cp; -- è unitaria (1 grado)

-- aggiornamento Efficienza energetica
UPDATE efficienzaEnergetica
SET Testerna=new.Testerna, Tinterna=new.Tinterna, Enecessaria=Eff 
WHERE CodSt=new.CodSt;

-- calcolo dissipamento (istantaneo)

set _dissip=(_k/_sp)*_DT*_alt*(_lung+_larg); -- dove l'area esposta corrisponde a due pareti (alt*(lung+larg))

-- aggiornamento ridondanza impCondiz
UPDATE impcondiz
SET Tiniziale=new.Tinterna, Eunitaria=Eff, Dissipamento=_dissip
WHERE CodDisp in (Select CodDisp  -- aggiorno le ridondanze nei condizionatori della stanza dove la temperatura è variata
				  from condizionatore 
                  where Stanza=new.CodSt);



END $$
delimiter ;
#---------------------------------------------------------------------------------------------------------------------------------------








#TRIGGER PER SCHEDULE---------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------
-- nel caso venga eliminato uno schedule tutte le impostazioni programmate devono essere cancellate se non hanno il corrispettivo record in consumo 
-- (quindi se ancora non è stato calcolato, anche perchè il calcolo del consumo è relativo anche ai dati di schedule, che non ci sono più!)

drop trigger if exists distruggiSchedule;
delimiter $$
create trigger distruggiSchedule
before delete on schedule
for each row
begin

delete 
from interazione 
where Differita='Si' -- cerco solo le interazioni tra le interazioni in differita
	 and (NomeUtente,CodDisp,CodR) in (
									select Utente, CodDisp, CodR
                                    from schedule
                                    where Utente=old.Utente and CodDisp=old.CodDisp and CodR=old.CodR and OraR=old.OraR and GiornoI=old.GiornoI and MeseI=old.MeseI
                                    )
	  and Fine is null; -- quando ancora il trigger di spegnimento non è ancora partito
	  

end $$
delimiter ;

#----------------------------------------------------












#TRIGGER LEGATI AL TEMPO----------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------

-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_batteria;
delimiter $$
create trigger controllo_batteria
before insert on batteria
for each row
begin

if (new.Data>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida: non si possono programmare accumuli di energia in batteria' ;
end if;    

end $$
delimiter ;


-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_documento;
delimiter $$
create trigger controllo_documento
before insert on documento
for each row
begin

if (new.Scadenza>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida: non si possono inserire documenti scaduti' ;
end if;    

end $$
delimiter ;

-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_nuovoutente; 
delimiter $$
create trigger controllo_nuovoutente
before insert on nuovoutente
for each row
begin

if (new.DataNascita>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida' ;
end if;    

end $$
delimiter ;


-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_registroiscrizione; 
delimiter $$
create trigger controllo_registroiscrizione
before insert on registroiscrizione
for each row
begin
	
if (new.DataIscrizione>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida' ;
end if;    

end $$
delimiter ;







#TRIGGER SULLE STANZE-----------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------

-- controllo che la luce abbia una stanza

drop trigger if exists controllo_insert_stanza_luce;
delimiter $$
create trigger controllo_insert_stanza_luce
before insert on illuminazione
for each row
begin

if not exists (
			   select*
               from stanza
               where CodSt=new.Posizione
) then
	signal sqlstate '45000'
    set message_text='Stanza inserita non esistente' ;
end if;    

end $$
delimiter ;


drop trigger if exists controllo_update_stanza_luce; -- si potrebbe cambiare la posizione di una luce
delimiter $$
create trigger controllo_update_stanza_luce
before update on illuminazione
for each row
begin

if not exists (
			   select*
               from stanza
               where CodSt=new.Posizione
) then
	signal sqlstate '45000'
    set message_text='Stanza inserita non esistente' ;
end if;    

end $$
delimiter ;

-- controllo che il condizionatore abbia una stanza

drop trigger if exists controllo_insert_stanza_condiz;
delimiter $$
create trigger controllo_insert_stanza_condiz
before insert on condizionatore
for each row
begin

if not exists (
			   select*
               from stanza
               where CodSt=new.Stanza
) then
	signal sqlstate '45000'
    set message_text='Stanza inserita non esistente' ;
end if;    

end $$
delimiter ;





#TRIGGER su INTERAZIONE-----------------------------------------------------------------------------------------------------------------------------
-- accettato il suggerimento viene programmata l'interazione indicata


drop trigger if exists InterazioneDaSugg; 
delimiter $$
create trigger InterazioneDaSugg 
after update on Suggerimento for each row 
begin 
	
    declare H integer default 0; 
    declare Utente varchar(50) default ''; 
    declare I timestamp default '0000-00-00 00:00:00'; 
    declare F timestamp default NULL; 
    declare Reg integer default 0; 
    declare Disp integer default 0; 
    
    declare finito integer default 0; 
    declare SceltaPositiva cursor for
		select	Ora, NomeUtente, Inizio, CodR, CodDisp 
        from 	Suggerimento 
        where	Scelta = 'SI';
	declare continue handler for not found set finito = 1; 
    
    open SceltaPositiva; 
    preleva : loop 
		fetch SceltaPositiva into H, Utente, I, Reg, Disp; 
        if finito = 1 then 
			leave preleva; 
		end if; 
        
        call CreazioneInterazione(Utente, I, F, Disp, Reg); 
    end loop; 
    
end $$
delimiter ; 


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 



-- event che gestisce la creazione di interazione di IMPOSTAZIONI RICORRENTI per i CONDIZIONATORI
-- -----------------------------------------------------------------------------------------------

drop event if exists controlla_schedule;
delimiter $$
create event controlla_schedule
on schedule every 1 day 
starts '2021:11:03 05:00:00'  
do
begin 

-- variabili di valore
declare _nome varchar(30) default '';
declare _in timestamp default not null;
declare _disp integer default not null; 
declare _reg integer default not null;

-- variabili discriminanti
declare var tinyint default 0;
declare _ora timestamp default not null;

declare scheduling cursor for -- vengono presi solo i record schedulati che stanno nel range
select Utente,CodDisp,CodR,OraR
from schedule
where (month(current_date)>=MeseI and ((weekday(current_date) between GiornoI and GiornoF) or GiornoF is null) and MeseF is null) or -- quando è a mese indeterminato e giorno definito o indefinito
	  ((month(current_date) between MeseI and MeseF) and GiornoF is null) or -- quando è a giorno indeterminato e mese definito
      ((month(current_date) between MeseI and MeseF) and (weekday(current_date) between GiornoI and GiornoF)) -- quando sta nel range definito
;   

declare continue handler
for not found set var=1;

open scheduling;
scan:loop
fetch scheduling into _nome,_disp,_reg,_ora;

if(var=1)then leave scan;
end if;

set _in= timestamp(current_date,_ora); -- crea il timestamp di inizio interazione

insert into interazione -- inserimento della regolazione programmata (ricorrente)
values (_nome,_in,_disp,_reg,null,'Si');

end loop;
close scheduling;

end $$
delimiter ;
#------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- SPEGNE le impostazioni ricorrenti precedentemente impostate nello schedule -------------------------------------------------------------------------------------
drop event if exists spegni_schedule;
delimiter $$
create event spegni_schedule -- deve spegnere la regolazione nel momento stabilito da schedule
on schedule every 10 minute   
do
begin 

declare _nome varchar(30) default '';
declare _in timestamp default not null;
declare _fin timestamp default not null;
declare _disp integer default not null; 
declare _reg integer default not null;

declare var tinyint default 0;
declare _ora timestamp default not null;


declare scheduling cursor for -- vengono presi solo i record schedulati che hanno raggiunto la fine regolazione
select s.Utente,s.CodDisp,s.CodR,i.Inizio,timestampadd(minute,s.Durata,i.Inizio)
from interazione i inner join schedule s on (i.NomeUtente=s.Utente and i.CodDisp=s.CodDisp and i.CodR=s.CodR)
where i.Differita='Si' -- cerco solo le interazioni tra le interazioni in differita
	  and timestampadd(minute,s.Durata,i.Inizio)< now() -- devo prendere le interazioni terminate
;

declare continue handler
for not found set var=1;

open scheduling;
scan:loop
fetch scheduling into _nome,_disp,_reg,_in,_fin;

if(var=1)then leave scan;
end if;

update interazione
set Fine=_fin
where NomeUtente=_nome and Inizio=_in and CodDisp=_disp and CodR=_reg;

end loop;
close scheduling;


end $$
delimiter ;
#--------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 



# CREAZIONE di un'INTERAZIONE ------------------------------------------------------------------------------------------------------------------

drop procedure if exists CreazioneInterazione; 
delimiter $$
create procedure CreazioneInterazione 	(
										in Utente varchar(50), 
										in TempI timestamp, 
                                        in TempF timestamp, 
                                        in CodD integer, 
                                        in Reg integer
                                        )
begin 
		
	declare I timestamp default '0000-00-00 00:00:00'; 
    declare F timestamp default '0000-00-00 00:00:00'; 
    
    declare Dur integer default 0; 
	
	if TempI is NULL then 								# Interazione : *SPEGNIMENTO DIFFERITA o NO*
		begin 
        
			select 	Inizio, Fine into I,F 																								#[1]
            from 	(
					select 	coddisp, last_value(Inizio) over () as Inizio, last_value(Fine) over() as Fine
					from 	(
							select	coddisp, Inizio, Fine 
							from 	interazione i 
							where 	i.coddisp = codD 
							and 	i.codr = reg 
							and 	(day(inizio) = day(current_date()) and day(fine) = day(current_date())) 
							order 	by Inizio, Fine 
							) as D 
					) as D1 
			group 	by coddisp; 
			
            if I <> '0000-00-00 00:00:00' and codD in 	(																				#[2]					
														select 	distinct CodDisp 
														from 	programma 
														) then 
				begin 																				
					if F > current_timestamp() then  																						#[2.1]
						update 	interazione i 
						set 	i.Fine = TempF
						where	codDisp = CodDisp
						and 	CodR = Reg
						and 	Inizio = I;
					else 
						signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo con Programma è già Spento'; 		
					end if;
                end; 
            end if; 
            
            if I <> '0000-00-00 00:00:00' and F = '0000-00-00 00:00:00' then 															#[3]	
				begin 
					update 	interazione i
					set 	i.Fine = TempF
					where	i.CodDisp = codD
					and 	i.CodR = reg
					and 	i.Inizio = I;
				end; 
			else 
				signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo è già Spento'; 							
			end if; 
            
        end; 
    end if; 
    #-----------------------------------------------------------------------------------------------------------------------------------------------
    if TempF is NULL then 									# Interazione : ACCENSIONE o CAMBIO REGOLAZINE DIFFERITA o NO
		begin
        
			select 	Inizio, Fine, codr into I,F, @CodReg 			#[1]
            from 	(
					select 	coddisp, codr, last_value(Inizio) over () as Inizio, last_value(Fine) over() as Fine
					from 	(
							select	coddisp,codr, Inizio, Fine 
							from 	interazione i
							where 	i.coddisp = 9 -- codD
							and 	(day(inizio) = day('2021-11-03'/*current_date()*/) and day(fine) = day('2021-11-03'/*current_date()*/))
							order 	by Inizio, Fine
							) as D
					) as D1
			group 	by coddisp; 
			
			if I = '0000-00-00 00:00:00' or (I <> '0000-00-00 00:00:00' and F <> '0000-00-00 00:00:00') then 						#[2]
				begin 
					if codD in (																										#[2.1]
							   select 	distinct coddisp 
							   from 	programma	
							   ) then 
						begin 
							select	durata	into Dur 
                            from 	programma 
                            where	coddisp = CodD 
                            and 	codr = reg;
							
                            set TempF = timestampadd(minute, Dur, TempI);																
                
                            if TempI = Current_time() then 								 	# Se il Tempo d'Inizio Inserito è lo stesso di quello Corrente, allora NON è Differita (Differita = 'NO')
								insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'NO'); 
							else 						 									# Altrimenti è Differita (Differita = 'SI')
								insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'SI'); 
							end if; 
                        end; 
					else 
							if TempI = Current_time() then  								# Se il Tempo d'Inizio Inserito è lo stesso di quello Corrente, allora NON è Differita (Differita = 'NO')
								insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'NO'); 
							else 	 														# Altrimenti è Differita (Differita = 'SI')
								insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'SI'); 
							end if; 
					end if; 
				end; 
			else 
				signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo è già Acceso'; 						#[2.3]
			end if; 
            
            if (I <> '0000-00-00 00:00:00' and F = '0000-00-00 00:00:00' and @CodReg <> Reg) then 									#[3]
				begin
					
                    if TempI = Current_time() then  								# Se il Tempo d'Inizio Inserito è lo stesso di quello Corrente, allora NON è Differita (Differita = 'NO')
						insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'NO'); 
					else 	 														# Altrimenti è Differita (Differita = 'SI')
						insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'SI'); 
					end if; 
                    
                end; 
			end if; 
            
        end; 
    end if; 
    #-----------------------------------------------------------------------------------------------------------------------------------------------
    if TempI is NOT NULL and TempF is NOT NULL then 		-- Interazione : ACCENSIONE PROGRAMMATA 
		begin 
			select 	Inizio, Fine into I,F 																							#[1]
            from 	( 	
					select 	coddisp, last_value(Inizio) over () as Inizio, last_value(Fine) over() as Fine 
					from 	( 
							select	coddisp, Inizio, Fine 
							from 	interazione i 
							where 	i.coddisp = codD 
							and 	i.codr = reg 
							and 	(day(inizio) = day(current_date()) and day(fine) = day(current_date())) 
							order 	by Inizio, Fine 
							) as D 
					) as D1 
			group 	by coddisp; 
					
			if I = '0000-00-00 00:00:00' or  I < TempI then 																		#[2]
				begin 
					if codD in (																										#[2.1]
							   select 	distinct coddisp 
							   from 	programma	
							   ) then 
						begin 
							select	durata	into Dur 
                            from 	programma 
                            where	coddisp = CodD 
                            and 	codr = reg;
							
                            set TempF = timestampadd(minute, Dur, TempI);
							insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'SI'); 					
                        end; 
					else 
						insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'SI'); 
					end if; 
				end; 
			else 
				signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo è già Attivo o Programmato'; 			
			end if; 
            
		end; 
	end if; 

end $$ 
delimiter ; 
#-----------------------------------------------------------------------------------------------------------------------------------------------------




#RIEPILOGO SMART PLUG : mostra i dati di consumo di una smartplug fino a un certo istante---------------------------------------------

drop procedure if exists RiepilogoSmartPlug; 
delimiter $$ 
create procedure RiepilogoSmartPlug ( 
									in SP integer, 
									out SemiRiepilogo varchar(255) 
                                    ) 
begin 
	
    declare Disp integer default 0; 	
    declare Fascia varchar(3) default ''; 
    declare Consumo double default 0; 
    declare NomeDisp varchar(50) default ''; 
    
    select 	CodDisp into Disp 
    from 	SmartPlug 
    where	CodSp = SP; 
    
    select 	NomeDisp into NomeDisp 
    from 	Dispositivo 
    where	coddisp = Disp; 
    
    select	distinct last_value(FasciaOraria) over() into Fascia 
    from 	ContatoreBidirezionale 
    where	hour(current_time) >= RangeF; 
    
    select 	sum(energiaConsumata) into Consumo 
    from 	Consumo 
    where	coddisp = disp 
    and 	fasciaoraria = fascia 
    and 	day(inizio) = day(current_date); 
    
    set SemiRiepilogo = concat('Dalla SmartPlug ', SP, ' è stato Consumato ', Consumo, ' a cui vi è collegato il Dispostivo ', NomeDisp); 
	select SemiRiepilogo as MessaggioDiRiepilogoSmartPlug; 
    
end $$ 
delimiter ; 



#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 


#[5.2.1]CREAZIONE di un ACCOUNT ----------------------------------------------------------------------------------

drop procedure if exists CreazioneAccount; 
delimiter $$
create procedure CreazioneAccount 	(
									in codfiscale varchar(40), --
									in nome varchar(40), --
                                    in cognome varchar(40), --
                                    in datanascita date, --
									in telefono double, --
                                    in nomeutente varchar(40), 
                                    in pswrd varchar(40), 
                                    in domanda varchar(255), 
                                    in risposta varchar(255), 
									in privilegio varchar(255), 
                                    in tipoDoc varchar(40), 
                                    in scadenza date, 
                                    in enteRilascio varchar(40), 
                                    in num varchar(10) -- 
									)
begin 
    
    if datediff(current_date, scadenza) < 0 && (length(pswrd) > 7 && length(nomeutente) > 3) then 
		begin 
			insert into nuovoUtente values (codfiscale, nome, cognome, datanascita, telefono);
            insert into registroIscrizioni values (codfiscale, num, nomeutente, current_date); 
            insert into documento values (num, tipodoc, scadenza, enteRilascio); 
            insert into account values (nomeutente, pswrd, privilegio, domanda, risposta); 
        end ; 
	else 
    signal sqlstate '45000'
    set message_text='Errore, dati non corretti. Indicare un documento non scaduto e/o una password lunga almeno 8 caratteri e/o un nome utente lungo 4';
	end if;

end $$
delimiter ; 
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------





#[5.2.2]"CONSUMO DISPOSITIVO"-------------------------------------------------------------------------------------------------------------------------------

drop trigger if exists calcoloConsumo; 
delimiter $$
create trigger calcoloConsumo after update on Interazione for each row -- il consuno viene calcolato ogni volta che lo stato di fine interazione viene settato con update  
begin 
	
    declare ValConsumo double default 0; 
    declare TipoD varchar(40) default ''; 
    declare tempoD integer default 0; 
    declare F varchar(3) default ''; 
    declare H integer default 0; 
    declare TempCondiz integer default 0; 
    declare TempInterna integer default 0; 
    declare TempExt integer default 0; 
    declare Diss double default 0; 
    
    declare finito integer default 0; 
    
    select	tipoconsumo into TipoD
    from 	Dispositivo 
    where	coddisp = new.coddisp; 
    
	if TipoD = 'Fisso' then 				
		begin 
			select	l.CLVL 	into ValConsumo 
			from 	Livello l
			where	l.codr = new.codr
			and 	l.coddisp = new.coddisp; 
			
			set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
            
			select	distinct last_value(FasciaOraria) over() into F
			from 	contatorebidirezionale
			where	RangeF <= hour(new.Inizio);
			
			set H = hour(new.inizio);
		
			insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
		end; 
	end if; 
	
    if TipoD = 'Variabile' then 
		if new.coddisp in 	(						-- Illuminazione
							select  i.coddisp 
                            from 	illuminazione i
							) then 
			begin 
				select	i1.cspecifico into ValConsumo
                from 	illuminazione i1
                where	i1.coddisp = new.coddisp;
					
				set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
                
                select	distinct last_value(FasciaOraria) over() into F
				from 	contatorebidirezionale
				where	RangeF <= hour(new.Inizio);
				
				set H = hour(new.inizio);
			
				insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
                
                set finito = 1; 
			end;
		end if; 
        if new.coddisp in 	(						-- Condizionamento 
							select 	c.coddisp
                            from	condizionatore c
							) then 
                begin
					select	im.EUnitaria, im.Dissipamento, im.Temp, im.Tiniziale into ValConsumo, Diss, TempCondiz, TempInterna
                    from 	ImpCondiz im
                    where	im.coddisp =new.coddisp
                    and 	im.codr = new.codr;
					
					set ValConsumo = ValConsumo * abs(TempCondiz-TempInterna) + (Diss * ((time_to_sec(timediff(new.fine, new.inizio)))/3600));
			
					select	distinct last_value(FasciaOraria) over() into F
					from 	contatorebidirezionale
					where	RangeF <= hour(new.Inizio);
					
					set H = hour(new.inizio);
				
					insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
					
                    set finito = 1; 
				end; 
		end if; 
        if finito = 0 then 							-- Dispositivi Variabili al di fuori di Illuminazione e Condizinamento 
			begin	
				select	l1.CLVL into ValConsumo
				from 	livello l1
				where	l1.codr = new.codr
				and 	l1.coddisp = new.coddisp; 
				
				set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
				
				select	distinct last_value(FasciaOraria) over() into F
				from 	contatorebidirezionale
				where	RangeF <= hour(new.Inizio);
				
				set H = hour(new.inizio);
			
				insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
			end; 
		end if; 
    end if; 
    
    if tipoD = 'Interrompibile' then 
		begin 
			select	CMedio, Durata into ValConsumo, TempoD
            from 	programma	
            where 	codr = new.codr
            and 	coddisp = new.coddisp;
            
            set ValConsumo = ValConsumo * (TempoD/60); 
            			
			select	distinct last_value(FasciaOraria) over() into F
			from 	contatorebidirezionale
			where	RangeF <= hour(new.Inizio);
			
			set H = hour(new.inizio);
		
			insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
        end; 
	end if; 
end $$
delimiter ;
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------


#[5.2.3] Registrazione Consumo ImpCondiz---------------------------------------------------------------------------------------------------------------
-- aggiorna la tabella efficienza energetica per ogni record su termometro creato
-- aggiorna le ridondanze Tiniziale e Eunitaria in impcondiz
DROP TRIGGER IF EXISTS Calcola_Enecessaria;
delimiter $$
CREATE TRIGGER Calcola_Enecessaria
AFTER INSERT ON termometro
FOR EACH ROW
BEGIN
-- variabili per il calcolo
	DECLARE _lung double DEFAULT 1; -- lunghezza
	DECLARE _larg double DEFAULT 1; -- larghezza
	DECLARE _alt double DEFAULT 1; -- altezza
	DECLARE _p double DEFAULT 1.29; -- densità
	DECLARE _Cp integer DEFAULT 1; -- calore specifico
	DECLARE _DT double DEFAULT 0; -- (Testerna - Tinterna)
	DECLARE Eff double DEFAULT 0; -- Energia necessaria
	declare _k integer default 3; -- coefficiente conduzione mattone
	declare _sp double default 0.2; -- spessore di un muro
	declare _dissip double default 0; -- dissipamento istantaneo

	-- calcolo effettivo
	SELECT Altezza,Larghezza,Lunghezza INTO _alt,_larg,_lung -- ricavo i dati volumetrici della stanza
	FROM stanza
	WHERE CodSt=new.CodSt;

	SET _DT=new.Testerna - new.Tinterna;
	-- gestisco il valore assoluto di DT
	if(_DT<0) then SET _DT=_DT*(-1);
	end if;

	SET Eff=_alt*_larg*_lung*_p*_Cp; -- è unitaria (1 grado)

	-- aggiornamento Efficienza energetica
	UPDATE efficienzaEnergetica
	SET Testerna=new.Testerna, Tinterna=new.Tinterna, Enecessaria=Eff 
	WHERE CodSt=new.CodSt;

	-- calcolo dissipamento (istantaneo)

	set _dissip=(_k/_sp)*_DT*_alt*(_lung+_larg); -- dove l'area esposta corrisponde a due pareti (alt*(lung+larg))

	-- aggiornamento ridondanza impCondiz
	UPDATE impcondiz
	SET Tiniziale=new.Tinterna, Eunitaria=Eff, Dissipamento=_dissip
	WHERE CodDisp in (Select CodDisp  -- aggiorno le ridondanze nei condizionatori della stanza dove la temperatura è variata
					  from condizionatore 
					  where Stanza=new.CodSt);
END $$
delimiter ;
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------



#[5.2.4] SINCRONIZZAZIONE LUCI----------------------------------------------------------------------------------------------------------
drop procedure if exists SincronizzazioneLuci; 
delimiter $$
create procedure SincronizzazioneLuci 	(
										in Luce integer, 
                                        in codreg integer, 
                                        in Utente varchar(40)
										)
begin 
	
    declare Disp integer default 0; 
    declare CSpecifico double default 0; 
    declare TempC double default 0; 
    declare Intense double default 0; 
    
    declare finito integer default 0; 
	declare LuciAccendere cursor for 
		select	i.coddisp, cspecifico
        from 	illuminazione i 
        where	i.posizione = 	(
								select	i1.posizione
                                from 	illuminazione i1
                                where	i1.coddisp = Luce
								); 
	declare continue handler for not found set finito = 1; 
    
    select	TempColore, Intensita into TempC, Intense
        from 	impluce	
        where	coddisp = Luce 
        and 	codr = codreg; 
    
    open LuciAccendere; 
    preleva : loop 
		fetch	LuciAccendere into Disp, CSpecifico; 
		
        update 	illuminazione 
        set 	accesa = 'ON'
        where	coddisp = Disp;
        
        update 	impluce 
        set 	tempcolore = TempC, intensita = Intense
        where	coddisp = Disp
        and 	codr = 1; 
		
		insert into Interazione values (Utente, current_time, Disp, codr, NULL, 'NO'); 
        
	end loop; 
    
end $$
delimiter ; 
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------







#[5.2.5]RIEPILOGO PRODUZIONE & CONSUMO--------------------------------------------------------------------------------------------------------------------------

drop event if exists RiepilogoPandC;
delimiter $$
create event RiepilogoPandC on schedule every 8 hour starts '2021-01-01 05:00:00' do -- il riepilogo viene fatto alla fine di ogni fascia oraria
begin 
	
	declare Prod double default 0; 
    declare Cons double default 0; 
    declare OraSuperiore integer default 0; 
    declare OraInferiore integer default 0; 
		
    select	RangeF into OraSuperiore
    from 	(
			select	distinct last_value(FasciaOraria) over() as FasciaOraria
			from 	contatorebidirezionale 
			where	rangeF <= hour(current_time)
			)as D natural join contatorebidirezionale;
    
    select 	RangeF into OraInferiore
	from	(
            select	distinct last_value(FasciaOraria) over() as FasciaOraria
			from 	contatorebidirezionale 
			where	RangeF < OraSuperiore
			)as D natural join contatorebidirezionale;
	
    if OraInferiore > 0 then 
		begin													-- per le fasce Orarie F2-F3
			select	sum(energia) into Prod
            from 	pannellifotovoltaici 
            where	hour(istante) >= OraInferiore
            and 	hour(istante) < OraSuperiore
            and 	day(istante) = day(current_date); 
            
            select	sum(energiaConsumata) into Cons
            from 	consumo 
            where	hour(inizio) >= OraInferiore
            and 	hour(inizio) < OraSuperiore
            and 	day(inizio) = day(current_date); 
            
            update 	contatoreBidirezionale 
            set 	produzione = prod
            where 	rangeF = OraInferiore;
            
            update 	contatoreBidirezionale 
            set 	consumo = cons
            where 	rangeF = OraInferiore;
        end;
	else 
		begin 													-- per la fasce Oraria F1
			select	distinct last_value(rangeF) over() into OraInferiore
            from 	contatorebidirezionale; 
            
            select	sum(energia) into Prod
            from 	pannellifotovoltaici 
            where	hour(istante) >= OraInferiore
            and 	hour(istante) < OraSuperiore
            and 	(
					day(istante) = day(current_date) 
                    or day(istante) = day(subdate(current_date, 1))
                    );
			
            select	sum(energiaConsumata) into Prod
            from 	consumo  
            where	hour(inizio) >= OraInferiore
            and 	hour(inizio) < OraSuperiore
            and 	(
					day(inizio) = day(current_date) 
                    or day(inizio) = day(subdate(current_date, 1))
                    );
			
            update 	contatoreBidirezionale 
            set 	produzione = prod, consumo = cons 
            where 	rangeF = OraInferiore;
            
            
		end; 
	end if; 
			
end $$
delimiter ; 
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------




#[5.2.6]ENERGIA IN RISERVA------------------------------------------------------------------------------------------------------------------------
drop event if exists AccumuloBatteria; 
delimiter $$ 
create event AccumuloBatteria on schedule every 8 hour starts '2021-01-01 05:00:00' do 
begin 
	
    declare Fascia varchar(3) default ''; 
    declare Prod double default null; 
    
    select 	 FasciaOraria,RiepilogoP into Fascia,Prod
    from 	contatorebidirezionale 
    where	Preferenza = 'Riserva'
			and hour(now())=RangeF-8; -- si registra la fascia oraria precedente (perchè si stocca alla fine di ogni fascia oraria) 
    
    
    if(prod is not null) then -- prod vale null quando la query precedente è vuota (la fascia oraria analizzata non era destinata alla riserva)
	insert into Batteria values (current_date, fascia, prod); 
	end if;
    
end $$
delimiter ; 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------






#[5.2.7]VERIFICA di un 'ACCESSO' in una Stanza ---------------------------------------------------------------------------------------------

drop procedure if exists segnalazione; -- proietta un messaggio
delimiter $$
create procedure segnalazione(in _Stanza integer,in _Accesso integer ,in _Orario timestamp)
begin
select 'Intrusione rilevata in' as Messaggio, _Stanza as Stanza, _Accesso as Accesso, _Orario as Orario;
end $$
delimiter ;


drop trigger if exists VerificaIntrusione_ControlloAccessi; 
delimiter $$
create trigger VerificaIntrusione_ControlloAccessi
before insert on controlloAccessi for each row 
begin 
	
    if (Persona= 'Intruso') then 
    call segnalazione(new.CodSt, new.CodA,new.Entrata); 
    end if; 
    
end $$
delimiter ; 


#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------




#[5.2.8]CREAZIONE SUGGERIMENTO-------------------------------------------------------------------------------------------------------------------

drop event if exists CreazioneSuggerimento; 
delimiter $$
create event CreazioneSuggerimento on schedule every 1 day starts '2021-01-01 23:00:00' do 
begin 
    
    declare H integer default 0; 
    declare Resp varchar(4) default ''; 
    declare HDispHot integer default 0;
    declare DispHot integer default 0; 
    declare CodRegHot integer default 0; 
    
    declare Sugg varchar(255) default '';
    declare OraConsigliata integer default 0; 
    declare DataConsigliata timestamp default '0000-00-00 00:00:00'; 
    
    declare UscitaWhile integer default 0; 
    declare Ranking integer default 0; 
    declare OraFreq integer default 0; 
    
	declare nSugg integer default 3; 
    declare nRank integer default 0;
    
    declare finito integer default 0; 
	declare OreProduttive cursor for													#Classifica delle Ore più Produttive degli Ultimi 3 Giorni
		select 	hour(Ora) as Ora, RankingProduzione
		from 	(        
				select	*, rank() over(order by MediaProduzioneOraria desc) as RankingProduzione 
				from 	(
						select	istante as Ora, avg(energia) as MediaProduzioneOraria
						from 	pannellifotovoltaici 
                        where	day(istante) between (day(subdate(/*current_date()*/'2021-11-04', 3))) and day(/*current_date()*/'2021-11-04')
						and		month(istante) between month(subdate(/*current_date()*/'2021-11-04', 3)) and month(/*current_date()*/'2021-11-04')	
						group 	by hour(istante)
						) as D
				where	MediaProduzioneOraria <> 0
				) as D1;
    declare continue handler for not found set finito = 1; 
    
    set sql_safe_updates = 0;
    delete from Suggerimento;
    
    replace 	into HotTable 																																						#Creazione HotTable (Ore con Prod>Cons = 'Cold' & Ore con Prod<Cons 'Hot'); I Dati considerati sono quelli degli Ultimi 3 Giorni 
		select	hour(inizio) as Ora, if(avg(energiaconsumata) < avg(energia), "COLD", "HOT") as Responso 
		from 	consumo c
				inner join pannellifotovoltaici p on hour(p.istante) = hour(c.inizio)
		where	day(inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
		and		month(inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/)
		and		timediff(inizio, istante) > 0
		and 	timediff(inizio, istante) <= '00:15:00'
		group	by hour(inizio), hour(istante);
		
    while uscitawhile = 0 do
		
        begin 
			select 	distinct first_value(D.coddisp) over(), 
					first_value(D.codr) over(), 
					first_value(rankingorder) over() into DispHot, CodRegHot, Ranking																								#Identificazione del Dispositivo che ha Consumato di più mediamente negli ultimi 3 giorni
			from	(
					select 	c.coddisp, c.codr, rank() over (order by avg(energiaConsumata) desc) as RankingOrder 
					from	consumo c
					where	day(c.inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
					and		month(c.inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/)
					group 	by c.coddisp
					) as D
			where 	rankingorder > Ranking; 
			-- select 	DispHot, Ranking; 

			select 	distinct first_value(Ora) over() into OraFreq
			from 	(
					select 	coddisp, 
							hour(inizio) as Ora, 
							count(*) as VolteUsatoinQuestOra, 
							avg(energiaconsumata) as MedioConsumo, 
							rank() over(order by count(*) desc) as RankingUsage, 
							rank() over(order by avg(energiaconsumata) desc) as RankingEn
					from 	consumo c
					where	coddisp = DispHot
                    and		day(c.inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
					and		month(c.inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/) 	
					group 	by hour(inizio)
					) as D	
			where 	RankingUsage = 1
			and 	RankingEn = 1; 
			-- select	OraFreq;

			if 	OraFreq not in		(																#Se l'Ora in cui è stato utilizzato il Dispositivo più Dispendioso NON si trova nelle Ore 'Cold' (Prod>Cons)
									select	ora
									from 	hottable 
									where	responso = 'COLD'
									) 	then 
				set UscitaWhile = 1; 
			end if; 
		end; 
        
	end while;         
        
        begin																																									#Si Creano un MAX di 3 Suggerimenti per il solito Disp e Regolazione nelle Ore più Produttive degli ultimi 3 giorni 
			open OreProduttive; 
			preleva : loop 
				fetch OreProduttive into OraConsigliata, nRank;
				
				if finito = 1 then 
					leave preleva; 
				end if; 
		
				if nSugg = 0 then 
					leave preleva; 
				end if; 
                
				if  OraConsigliata not in	(																																	#Sempre Verificando che l'Ora più Produttiva coincida con una delle Ore 'Cold' 
											select	Ora	
											from	hottable
											where	responso = 'COLD'
											) then 
												iterate preleva; 
				else 
					set nSugg = nSugg - 1; 
                    
                    select timestamp(current_date(), sec_to_time(OraConsigliata*3600)) into DataConsigliata;
                    
					if nRank = 1 then 
						set Sugg = concat('Suggerimento : E`*Fortemente* Consigliato di Usare il Dispositivo ', DispHot, ' alle Ore ', OraConsigliata, ' di Domani'); 
                    else
						set Sugg = concat('Suggerimento : E`Anche Consigliato di Usare il Dispositivo ', DispHot, ' alle Ore ', OraConsigliata, ' di Domani'); 
                    end if; 
					
                    set DataConsigliata = adddate(DataConsigliata, 1);
                    replace into Suggerimento values (OraConsigliata, DispHot, Sugg, 'NO', 'Gestore', DataConsigliata, CodRegHot);
				end if; 
                
			end loop;
            close OreProduttive; 
		end; 

	select 	*
    from 	Suggerimento;

end $$
delimiter ; 
 
 
 


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 



SET SQL_SAFE_UPDATES = 0;
set @@group_concat_max_len=20000;

drop procedure if exists Apriori;
delimiter $$
create procedure Apriori()
begin

-- VARIABILI DI APPOGGIO  
declare loca varchar(30); -- loca indica il singolo dispositivo (item) considerato
declare finito tinyint default 0; -- variabile handler
declare step integer default 2; -- indica a che step siamo nel loop delle regole (cioè la lunghezza dell'itemset della regola) 
declare k integer default 0; -- indica il numero di item totali
declare fre_select integer default 0; -- è un contatore che mi serve in Sql dinamico per contare il numero di attributi nella select 

-- VARIABILI FONDAMENTALI
declare _supp double default 0.01; -- supporto stabilito
declare _conf double default 0.3; -- confidenza stabilita

-- CURSORE PER ESTRARRE I NOMI DEI DISPOSITIVI (gli item)
declare farm cursor for   -- permette di estrarre i nomi dei dispositivi
select NomeDisp
from Dispositivo;
declare continue handler for not found set finito=1;


#-----------------------------------------------------------------------------------
-- TABELLA PIVOT delle TRANSAZIONI da cui ricavare le regole
set @inc=0; -- questa variabile è una specie di auto_increment
drop table if exists riferimento_pivot;
create table riferimento_pivot as (
select @inc:=@inc+1 as TID,ITEMLIST
from (select group_concat( distinct NomeDisp) as ITEMLIST 
from interazione natural join dispositivo
group by NomeUtente,hour(inizio), date(inizio)) as d);

select* from riferimento_pivot; -- mostro la tabella
#--------------------------------------------------------------------------------------




-- TABELLA DI RIFERIMENTO delle TRANSAZIONI (questa parte di codice è intervallata da un loop di utility)-----------------------------------------------------------------

set @tab_riferimento=null; -- inizializzo la variabile che potrebbe essere sporca

-- questa parte gestisce gli squash che collidono su un'unica transazione 
-- (bisogna trasformare la tabella interazione in una più compatta)

with dispositivi as ( 
select NomeDisp 
from Dispositivo
)
select group_concat( 
concat('sum(if(NomeDisp= ''',f.NomeDisp,''',1,0)) as ''', f.NomeDisp, '''' -- calcolo di una parte della select
) 
)
from dispositivi f 
into @tab_riferimento; 


set @tab_riferimento=concat(
'select NomeUtente, ',
@tab_riferimento,
' from interazione natural join dispositivo group by NomeUtente,hour(inizio), date(inizio)'  -- fino a questo passo la tabella non è completa (possiede un conteggio per elemento)
);

-- inizializzazione variabili possibilmente sporche --> completano delle query
set @ifstat=null; -- questa variabile contiene una serie di if utili
set @union_=null; -- questa variabile contiene una serie di union 
set @uni=null; -- questa variabile contiene una serie di union (diverse da @union)

-- LOOP DI UTILITY -> serve per gestire la parte propedeutica all'algoritmo
open farm;
scan:loop
fetch farm into loca;
if(finito=1) then leave scan;
end if;

if(@ifstat is null) then  set @ifstat=concat(' if(d.',loca,'<>0,"',loca,'",0) as ',loca); -- prima iterazione non ha la virgola davanti (sennò non funziona la select)
else
set @ifstat=concat(@ifstat,', if(d.',loca,'<>0,"',loca,'",0) as ',loca);
end if;

if(@union_ is null) then set @union_=concat('select "',loca,'" as ITEM, sum(if(',loca,'="',loca,'",1,0)) as OCCORRENZE, COUNT(*) as TOTALE from riferimento'); -- prima iterazione non necessita union all davanti
else
set @union_=concat_ws(' Union all ',@union_,concat('select "',loca,'" as ITEM, sum(if(',loca,'="',loca,'",1,0)) as OCCORRENZE, COUNT(*) as TOTALE from riferimento'));
end if;


if(@uni is null) then set @uni=concat('select TID, "',loca,'" as ITEM from riferimento where ',loca,'<> "0"'); -- prima iterazione non necessita union all davanti
else
set @uni =concat_ws(' Union all ',@uni,concat('select TID, "',loca,'" as ITEM from riferimento where ',loca,'<> "0"'));
end if;


end loop;
close farm;

-- aggiunta del if che aggiusta la tabella nel risultato desiderato
set @ghost=0;
set @tab_riferimento=concat(
' select @ghost:=@ghost+1 as TID, z.* 
  from (select ',@ifstat,
'       from (',@tab_riferimento,') as d) as z;'
);


-- creazione effettiva tabella di riferimento
drop table if exists riferimento; 
set @tab_rifer=null; -- inizializzo variabile che potrebbe essere sporca
set @tab_rifer=concat(
'create table riferimento as ',
@tab_riferimento
);


prepare sql_statement from @tab_rifer; 
execute sql_statement;


select* from riferimento; -- mostro la tabella
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- calcolo ITEM CANDIDATI per le regole (è lo step 1. Inizialmente è solo la lista degli elementi affiancati alle occorenze e al totale delle transazioni)----------------
set @C_creation='';	
drop table if exists C1;
set @C_creation=concat('
create table C1 as 
Select ITEM as ITEM_1, OCCORRENZE, TOTALE from ( 
',@union_,') as d;'); -- ogni item viene estratto dalla tab di riferimento da cui si fanno i conti e viene unito all'item successivo
prepare sql_statement from @C_creation; 
execute sql_statement;
/*
-- mostra la tabella
select*
from C1;
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- calcolo del supporto step 1 ------------------------------------------------------------------------------------------------------------------------------------
drop table if exists F1; 
create table F1 AS
SELECT ITEM_1, SUPPORTO, OCCORRENZE FROM (
    SELECT ITEM_1, OCCORRENZE/TOTALE as SUPPORTO, OCCORRENZE 
    FROM C1
) as D
WHERE SUPPORTO >= _supp; -- PRUNING
/*
-- mostra la tabella
select *
from F1;
*/
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


# UTILITY per APRIORI------------------------------------------------------------------------------------------------------------------------------------------------
-- tabella che verticalizza gli elementi (necessaria per il passo di join) -> in pratica è una colonna di utility per fare i cross join
set @vertical='';	
drop table if exists Vertical;
set @vertical=concat('
create table Vertical as '
,@uni,';');
prepare sql_statement from @Vertical; 
execute sql_statement;
 
-- calcolo la lunghezza dell'itemset più grande (indica il numero massimo di loop da fare)
select max( length(ITEMLIST) - length(replace(ITEMLIST,',',''))+1) into k -- contando il numero di virgole = numero di elementi -1
from riferimento_pivot;
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------











#LOOP CHE MI CALCOLA TUTTE LE REGOLE FORTI (2 passi: 1)calcolo delle regole forti parziali 2) calcolo delle regole forti rimanenti)
# ATTENZIONE: alta densità di codice dinamico e tabelle non temporanee (dal momento che non sono concessi multi-statment nelle prepare e che non sono usabili temporary table)


large:loop

if(step>k) then leave large; -- se arrivo qui ho guardato la regola più lunga
end if;


-- VARIABILI per SQL DINAMICO
set @name_frequenza=concat('frequenza',step); -- indica la tabella FREQUENZA che si vuole considerare
set @name_regolestrong=concat('F',step-1); -- indica la tabella regoleforti che si vuole considerare (che è sempre quella del passo precedente)

-- TABELLA FREQUENZA : è una tabella di supporto che fa il passo di join (quindi calcola le possibili combinazioni) e determina gli elementi di frequenza

-- DROP
set @drop_freq=concat('drop table if exists ',@name_frequenza,';');
prepare sql_statement from @drop_freq; 
execute sql_statement;
-- SELECT
set fre_select=1;
set @fre_select=null;
set @fre_spaz=step-1; -- variabile d'appoggio che mi fa inserire particolari valori (l'ultimo prende l'indice del penultimo)
while fre_select<=step do
	if(fre_select=step) then  
		begin
        set @letter_select_freq='B'; -- l'ultima colonna
        end;
    else set @letter_select_freq='A'; -- le altre colonne
	end if;
    
	if (fre_select=1) then set @fre_select=concat(@letter_select_freq,'.ITEM_',fre_select,' as ITEM_',fre_select);-- in questo caso non ci va la virgola 
    else
		begin
		if(fre_select=step) then set @fre_select=concat(@fre_select,', ',@letter_select_freq,'.ITEM_',@fre_spaz,' as ITEM_',fre_select); -- qui si usa fre_spaz
        else
        set @fre_select=concat(@fre_select,', ',@letter_select_freq,'.ITEM_',fre_select,' as ITEM_',fre_select); -- questi sono gli item consecutivi nella select
		end if;
        end;
    end if;
    
	
    set fre_select=fre_select+1;
end while;
-- WHERE
set fre_select=1;
set @fre_where=null;

while fre_select<step do
-- i < confrontano in ordine alfabetico gli elementi
	if(fre_select=step-1) then  
        begin
			if(@fre_where is null) then set @fre_where=concat('A.ITEM_1 < B.ITEM_1'); -- caso speciale (vale solo per frequenza1)
			else
			  set @fre_where=concat(@fre_where,' and A.ITEM_',fre_select,'< B.ITEM_',fre_select);
			end if;
        end;
        else
			begin
			if(@fre_where is null) then set @fre_where=concat('A.ITEM_1 = B.ITEM_1'); -- caso speciale (vale solo per il primo elemento del where)
			else
			  set @fre_where=concat(@fre_where,' and A.ITEM_',fre_select,'= B.ITEM_',fre_select);
			  end if;
			end;
	end if;
set fre_select=fre_select+1;
end while;
-- CREATE
set @create_freq=concat('
CREATE TABLE ',@name_frequenza,' AS 
SELECT ',@fre_select,' 
FROM ',@name_regolestrong,' A CROSS JOIN ',@name_regolestrong,' B
WHERE ',@fre_where,';
');

prepare sql_statement from @create_freq; 
execute sql_statement;
-- MOSTRA la tabella
/*
set @mostra_freq=concat('select* from ',@name_frequenza,';');
prepare sql_statement from @mostra_freq; 
execute sql_statement;
*/

-- preparo la condizione di USCITA ANTICIPATA
set @fre_co=0;
set @fre_count=concat(
'select count(*) into @fre_co
 from ',@name_frequenza,';');
prepare sql_statement from @fre_count; 
execute sql_statement;

if (@fre_co=0) then leave large; -- in questo caso non ci sono più itemset frequenti (si può abbandonare prima il loop)
end if;




#TABELLA REGOLE CANDIDATE------------------------------------
set @name_C=concat('C',step);

-- DROP
set @drop_C=concat('drop table if exists ',@name_C,';');
prepare sql_statement from @drop_C; 
execute sql_statement;

-- SELECT e FROM
set fre_select=1; set @select1_C=''; set @select2_C=''; set @select3_C=''; set @select4_C=''; set @from1_C=''; set @from2_C=''; set @where1_C='';
set @where3_C=''; set @where4_C=''; set @on1_C=''; set @group1_C=''; set @group2_C=''; set @on2_C='';
sele:while fre_select <= step do
		set @select1_C=concat(@select1_C,' Z.ITEM_',fre_select,' as ITEM_',fre_select,', ');
		set @select2_C=concat(@select2_C,' C.ITEM_',fre_select,' as ITEM_',fre_select,', ');
		set @select3_C=concat(@select3_C,', A',fre_select,'.ITEM as ITEM_',fre_select);
        
        
        if(fre_select=1) then 
			begin
				set @from1_C=concat(' Vertical A',fre_select);
                set @on1_C=concat(' X.ITEM_',fre_select,'= C.ITEM_',fre_select);
                set @group1_C=concat(' C.ITEM_',fre_select);
			end ;
        else 
			begin
				set @from1_C=concat(@from1_C,' Cross join Vertical A',fre_select);
                set @on1_C=concat(@on1_C,' and X.ITEM_',fre_select,'= C.ITEM_',fre_select);
                set @group1_C=concat(@group1_C,', C.ITEM_',fre_select);
            end ;
        end if;
        
        if(fre_select>2) then -- questo va bene solo dall' itemset lungo 3 in poi
				set @where1_C=concat(@where1_C,' and A1.TID=A',fre_select,'.TID'); 
        end if;
        
        if(step>2 and fre_select>1 and fre_select<step) then 
				begin
					set @where3_C=concat(@where3_C,' and A.ITEM_',fre_select,'=B',fre_select,'.ITEM');
					set @where4_C=concat(@where4_C,' and B',fre_select-1,'.TID=B',fre_select,'.TID');
				end ;
		end if;
        
        if(fre_select<>step) then 
		  begin
			set @select4_C=concat(@select4_C,' A.ITEM_',fre_select,','); -- l'ultimo step non ci deve essere
            
            if(fre_select=1) then 
				begin
					set @group2_C=concat(' A.ITEM_',fre_select);
                    set @on2_C=concat(' Z.ITEM_',fre_select,'= E.ITEM_',fre_select);
				end;
            else 
				begin
					set @group2_C=concat(@group2_C,', A.ITEM_',fre_select);
                    set @on2_C=concat(@on2_C,' and Z.ITEM_',fre_select,'= E.ITEM_',fre_select);
				end ;
            end if;
			
            set @from2_C=concat(@from2_C,' cross join Vertical B',fre_select);
		  end;
        end if;
		
	set fre_select=fre_select+1;
	end while sele;
set @select1_C=concat(@select1_C,'Occorrenze, Elementi_Freq as Totale, Tot_Transazioni ');
set @select2_C=concat(@select2_C,'Count(Distinct C.TID) as Occorrenze ');


-- WHERE
set @where2_C='';
set fre_select=1;
while fre_select<step do

set @fr=fre_select+1;
while @fr<=step do
set @where2_C=concat(@where2_C,' and A',fre_select,'.ITEM<A',@fr,'.ITEM');
set @fr=@fr+1;
end while;

set fre_select=fre_select+1;
end while;

set @where1_C=concat(@where1_C,@where2_C);
set @where3_C=concat(@where3_C,@where4_C);

-- Create
set @create_C=concat('
CREATE TABLE ',@name_C,' AS
SELECT ',@select1_C,'
FROM
(
    SELECT ',@select2_C,'
    FROM (SELECT * FROM ',@name_frequenza,') as X
    INNER JOIN 
    (
        SELECT A1.TID',@select3_C,'
        FROM ',@from1_C,'
        WHERE A1.TID = A2.TID ',@where1_C,'
    ) as C 
    ON ',@on1_C,'
    GROUP BY ',@group1_C,'
) as Z

CROSS JOIN 
(
    SELECT COUNT(*) as Elementi_Freq 
    FROM ',@name_frequenza,'
) as D
INNER JOIN 
(
    SELECT ',@select4_C,' COUNT(DISTINCT B1.TID) as Tot_transazioni
    FROM ',@name_frequenza,' A ',@from2_C,'
	WHERE A.ITEM_1 = B1.ITEM ',@where3_C,'
    GROUP BY ',@group2_C,'
) as E ON ',@on2_C,' 
where OCCORRENZE< Elementi_Freq;
');
prepare sql_statement from @create_C; 
execute sql_statement;


-- preparo la condizione di USCITA ANTICIPATA
set @C_co=0;
set @C_count=concat(
'select count(*) into @C_co
 from ',@name_C,';');
prepare sql_statement from @C_count; 
execute sql_statement;

if (@C_co=0) then 
	begin
    prepare sql_statement from @drop_C; -- drop della tabella vuota 
	execute sql_statement;
    leave large; -- in questo caso non ci sono regole candidate (si può abbandonare prima il loop)
	end;
end if;
/*
-- MOSTRA la tabella
set @mostra_C=concat('select* from ',@name_C,';');
prepare sql_statement from @mostra_C; 
execute sql_statement;
*/

-- TABELLA REGOLE FORTI (Iniziali, poichè mancano alcune combinazioni della confidenza)--------------------------
-- Vengono proiettate solo le regole che raggiungono un certo supporto e di cui la confidenza dei primi k-1 elementi è raggiunta

set @name_F=concat('F',step);

-- DROP
set @drop_F=concat('drop table if exists ',@name_F,';');
prepare sql_statement from @drop_F; 
execute sql_statement;

-- SELECT
set fre_select=1;
set @select1_F='';
while fre_select<=step do
	set @select1_F=concat(@select1_F,'ITEM_',fre_select,',');
set fre_select=fre_select+1;
end while;

-- CREATE
set @create_F=concat('
CREATE TABLE ',@name_F,' AS
SELECT ',@select1_F,' SUPPORTO, CONFIDENZA, OCCORRENZE FROM (
    SELECT ',@select1_F,' TRUNCATE(OCCORRENZE / TOTALE,2) as SUPPORTO, TRUNCATE(OCCORRENZE / Tot_Transazioni,2) as CONFIDENZA, OCCORRENZE FROM ',@name_C,' 
) as D
WHERE SUPPORTO >= ',_supp,'
AND CONFIDENZA >= ',_conf,';
');
prepare sql_statement from @create_F; 
execute sql_statement;
-- MOSTRA la tabella
set @mostra_F=concat('select* from ',@name_F,';');
prepare sql_statement from @mostra_F; 
execute sql_statement;
set @ghostrider= fre_select; -- è necessario sapere l'ultimo F creata


set step=step+1; -- incremento step per il passo successivo

end loop;

-- ALTRE REGOLE FORTI: si ottengono combinando le C precedenti con la F che si vuole partizionare 
		-- creo una tabella Ri_j per ogni partizionamento (i si riferisce alla F considerata, j è il numero di colonne che fanno parte di X)

if(step>2) then
	begin
		set fre_select=3; -- il partizionamento si fa solo dallo step 3 in poi

		while fre_select<@ghostrider do
        
		set @inner_count=1; -- si parte dalla colonna singola
		set @max_partiz=fre_select-2; -- poichè la regola con k-1 determinati è quella descritta da F
		set @R_selection=''; set @item_count=1;
		
        
            -- WHILE DI SELECT
            while @item_count<=fre_select do
				set @R_selection=concat(@R_selection,'ITEM_',@item_count,',');
				set @item_count=@item_count+1;
			end while;
            
        
			-- WHILE PARTIZIONAMENTI
            
            while @inner_count<=@max_partiz do
				set @R_drop=concat('drop table if exists R',fre_select,'_',@inner_count,';');
				prepare sql_statement from @R_drop; 
				execute sql_statement;

				set @R_Create=concat(
				'create table R',fre_select,'_',@inner_count,' as
				select f.*,TRUNCATE(f.Occorrenze_/c',@inner_count,'.Occorrenze,2) as Confidenza
				from (select ',@R_selection,' Supporto,Occorrenze as Occorrenze_ 
					  from F',fre_select,') as f 
                      natural join C',@inner_count,' c',@inner_count,' ;
				');
                
				prepare sql_statement from @R_Create; 
				execute sql_statement;

			set @inner_count=@inner_count+1;
			end while;

		set fre_select=fre_select+1;
		end while;
	end;
end if;
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# in questa parte di codice si genera una TABELLA PIVOT che riassume le REGOLE FORTI --------------------------------------------------------
drop table if exists REGOLE_FORTI;
create TABLE REGOLE_FORTI (
 `X` varchar(1000) default '',
 `Y` varchar(1000) default '',
 `SUPPORTO` double default 0,
 `CONFIDENZA` double default 0,
 primary key (`X`,`Y`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

#POPOLAMENTO Regole Base ---------------------------------------------------------------
set @pewds=2; set @minecraft=1; set @regolo=''; set @conca=''; set fre_select=fre_select-2;

while @pewds<=fre_select do

	while @minecraft<fre_select do -- Concateno per X (in questo caso Y non è necessario perchè l'ultimo item: le regole Forti iniziali sono quelle con k-1 determinanti)
		
			set @conca=concat(@conca,',ITEM_',@minecraft);
		
		set @minecraft=@minecraft+1;
	end while;


	set @regolo=concat('
	insert into REGOLE_FORTI
	select concat_ws(","',@conca,') as X, ITEM_',@pewds,' as Y,SUPPORTO,CONFIDENZA
	from F',@pewds,';');
	prepare sql_statement from @regolo; 
	execute sql_statement;

set @pewds=@pewds+1;
end while;

-- Popolamento Regole partizionate -----------------------------------------------------------------
if(step>2) then 
begin
	set @pewds=3; 

	while @pewds<@ghostrider do
    
        set @inner_count=1; -- si parte dalla colonna singola
		set @max_partiz=@pewds-2; -- poichè la regola con k-1 determinati è quella descritta da F
        
        while @inner_count<=@max_partiz do -- inserisce tutte le tabelle partizionate Ri
			set @minecraft=1; set @regolo=''; set @conca='';
			
            -- CONCATENO per X
			while @minecraft<=@max_partiz do 
				
					set @conca=concat(@conca,',ITEM_',@minecraft);
				
				set @minecraft=@minecraft+1;
			end while;
			
            -- CONCATENO per Y
			set @minecraft=@max_partiz+1; set @conca2='';
			while @minecraft<=@pewds do -- Concateno per Y
				
					set @conca2=concat(@conca2,',ITEM_',@minecraft);
				
				set @minecraft=@minecraft+1;
			end while;


			set @regolo=concat('
			insert into REGOLE_FORTI
			select concat_ws(","',@conca,') as X, concat_ws(","',@conca2,') as Y ,SUPPORTO,CONFIDENZA
			from R',@pewds,'_',@inner_count,';');
			prepare sql_statement from @regolo; 
			execute sql_statement;
				
                
		set @inner_count=@inner_count+1;
		end while;

	set @pewds=@pewds+1;
	end while;

end;
end if;
#----------------------------------------------------------------------------------------------------------------------------------------------------
select*
from REGOLE_FORTI;


#DROP di tutte le tabelle che non mi servono più
set @drop_count=1; set @drop_name_freq='frequenza'; set @drop_name_C='C'; set @drop_name_F='F'; set @drop_name_R='R';
while @drop_count<=step do
	-- drop tabelle frequenti
    set @drop_name=concat(@drop_name_freq,@drop_count);
	set @dropper=concat('drop table if exists ',@drop_name,';');
	prepare sql_statement from @dropper; 
	execute sql_statement;
    -- drop tabelle regole candidate
    set @drop_name=concat(@drop_name_C,@drop_count);
	set @dropper=concat('drop table if exists ',@drop_name,';');
	prepare sql_statement from @dropper; 
	execute sql_statement;
    -- drop tabelle regole forti F
    set @drop_name=concat(@drop_name_F,@drop_count);
	set @dropper=concat('drop table if exists ',@drop_name,';');
	prepare sql_statement from @dropper; 
	execute sql_statement;
    -- drop tabelle regole forti R
    if (@drop_count>2) then
    begin
		set @inner_count=1; set @max_partiz=@drop_count -2; 
		while @inner_count<= @max_partiz do
			set @drop_name=concat(@drop_name_R,@drop_count,'_',@inner_count);
			set @dropper=concat('drop table if exists ',@drop_name,';');
			prepare sql_statement from @dropper; 
			execute sql_statement;
		set @inner_count=@inner_count+1;
		end while;
    end ;
    end if;
set @drop_count=@drop_count+1;
end while;
drop table if exists vertical;

end $$
delimiter ;
call Apriori();