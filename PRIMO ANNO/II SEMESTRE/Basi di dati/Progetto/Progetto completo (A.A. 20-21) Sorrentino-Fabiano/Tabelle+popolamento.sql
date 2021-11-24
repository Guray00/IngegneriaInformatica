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
 