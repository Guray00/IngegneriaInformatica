-- Progettazione Web 
DROP DATABASE if exists cambria_672642; 
CREATE DATABASE cambria_672642; 
USE cambria_672642; 
-- MySQL dump 10.13  Distrib 5.7.28, for Win64 (x86_64)
--
-- Host: localhost    Database: cambria_672642
-- ------------------------------------------------------
-- Server version	5.7.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Account` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Password` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Monete` int(11) NOT NULL DEFAULT '10',
  `RefreshNegozio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ImmagineProfilo` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'images/pics/default.svg',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO `Account` VALUES (1,'admin','$2y$10$Jh/rJrgTFn2ac.IcmOqC3OMeI8arziTDN/wg68tm640wyDjRgrEBi',2,'2025-05-30 11:40:22','images/pics/elettro.svg'),(3,'Account1','$2y$10$TJRvLW4SjyfN6Wh169vy9eyVmBgxOcQi3oDWexW9B.MCN83VhXNI2',7,'2025-05-28 19:18:38','images/pics/fuoco.svg'),(4,'faiTu','$2y$10$iEt/vX4PbyV1S4PiIXgah.h7JBt6XxNJgkCcIqwWO3a5vI61jheUq',24,'2025-05-07 18:21:09','images/pics/elettro.svg'),(6,'Gino','$2y$10$Gb.vYG8hn/NHZ229xu4q8OuOKyZiW1zbzmHn/a1eKDTFgz1KjUt9S',17,'2025-05-14 16:34:14','images/pics/default.svg'),(7,'gigi','$2y$10$hxp51aAc5F3IiL8EvZHdU.9Cse544myH8TpEDZpqviiyFcglwZ6Da',11,'2025-05-16 16:00:03','images/pics/fuoco.svg'),(9,'pippo12','$2y$10$iuBoRL93Yp/fY0TVglpluOH1q9/4S4IU2gEw2cV8ewTpi6cl.Poeu',15,'2025-05-28 19:38:29','images/pics/default.svg'),(10,'ilPiuForte','$2y$10$GPAt26ObjbXqlRB2Ebzwo.tGZ.6meFkL2F19.h2.Oon3SLi4UxwvC',18,'2025-05-26 22:01:24','images/pics/elettro.svg'),(11,'pierino','$2y$10$u8GHlZaydnGreJ2CY4nNUukJ.mLC49Dx1wFz0KtJ9abz4sIgIRcsO',12,'2025-05-28 18:53:30','images/pics/terra.svg'),(12,'pippo1','$2y$10$EA8sXk7C5PyISfIHXk.v0e/eLWZ5K3.f5g4nT4P06JR6BoLJ9jqE2',11,'2025-05-28 19:52:27','images/pics/default.svg'),(13,'marco','$2y$10$SV8GpRhFM78fYtObCK15AurBWN.389ER1cRI/3ZCY0eYex5vMioO.',5,'2025-05-29 13:12:02','images/pics/terra.svg');
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_account_monete_check


BEFORE INSERT ON Account


FOR EACH ROW


BEGIN


    IF NEW.Monete < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Monete deve essere >= 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_welcome_gift` AFTER INSERT ON `Account` FOR EACH ROW BEGIN


    INSERT INTO Inventario  (Proprietario, Oggetto, Quantita)


    SELECT NEW.ID, 16, 1;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_account_monete_update_check


BEFORE UPDATE ON Account


FOR EACH ROW


BEGIN


    IF NEW.Monete < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Monete deve essere >= 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Combattimenti`
--

DROP TABLE IF EXISTS `Combattimenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Combattimenti` (
  `Giocatore1_Nome` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Giocatore1_Proprietario` int(11) NOT NULL,
  `Terminata` tinyint(1) NOT NULL DEFAULT '0',
  `Vittoria_Giocatore1` tinyint(1) DEFAULT NULL,
  `StatoPersonaggi` json DEFAULT NULL,
  `DataInizioBattaglia` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DataUltimoTurno` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Giocatore1_Proprietario`,`Giocatore1_Nome`,`DataInizioBattaglia`),
  KEY `Giocatore1_Nome` (`Giocatore1_Nome`,`Giocatore1_Proprietario`),
  CONSTRAINT `combattimenti_ibfk_1` FOREIGN KEY (`Giocatore1_Nome`, `Giocatore1_Proprietario`) REFERENCES `Personaggi` (`Nome`, `Proprietario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Combattimenti`
--

LOCK TABLES `Combattimenti` WRITE;
/*!40000 ALTER TABLE `Combattimenti` DISABLE KEYS */;
INSERT INTO `Combattimenti` VALUES ('Carlitos',1,1,0,NULL,'2025-05-29 17:25:57',NULL),('Leonardo',1,1,1,NULL,'2025-05-26 18:44:50',NULL),('Leonardo',1,1,1,NULL,'2025-05-26 21:32:55',NULL),('Leonardo',1,1,0,NULL,'2025-05-26 21:55:45',NULL),('Leonardo',1,1,0,NULL,'2025-05-26 21:56:06',NULL),('Leonardo',1,1,0,NULL,'2025-05-26 21:56:33',NULL),('Leonardo',1,1,1,NULL,'2025-05-26 21:56:36',NULL),('Leonardo',1,1,0,NULL,'2025-05-26 22:11:52',NULL),('Leonardo',1,1,0,NULL,'2025-05-29 13:20:51',NULL),('Leonardo',1,1,1,NULL,'2025-05-29 17:25:04',NULL),('Leonardo',1,1,1,NULL,'2025-05-29 17:34:18',NULL),('Pippo',1,1,1,NULL,'2025-05-29 13:24:02',NULL),('Rosso',1,1,0,NULL,'2025-05-27 13:22:44',NULL),('Rosso',1,1,0,NULL,'2025-05-27 13:22:56',NULL),('Scintilla',1,1,0,NULL,'2025-05-26 22:13:22',NULL),('Luca',3,1,0,NULL,'2025-05-28 19:25:22',NULL),('pg1',3,1,0,NULL,'2025-05-28 19:28:31',NULL),('Maradona',10,1,0,NULL,'2025-05-26 22:10:36',NULL),('Maradona',10,1,0,NULL,'2025-05-26 22:10:45',NULL),('BugsBunny',11,1,1,NULL,'2025-05-28 18:40:27',NULL),('BugsBunny',11,1,0,NULL,'2025-05-28 18:43:10',NULL),('BugsBunny',11,1,1,NULL,'2025-05-28 18:46:33',NULL),('BugsBunny',11,1,1,NULL,'2025-05-28 18:51:13',NULL),('BugsBunny',11,1,1,NULL,'2025-05-28 19:09:11',NULL),('BugsBunny',11,1,1,NULL,'2025-05-28 19:16:24',NULL),('piero',11,1,1,NULL,'2025-05-27 13:31:40',NULL),('piero',11,1,0,NULL,'2025-05-27 13:34:05',NULL),('piero',11,1,0,NULL,'2025-05-27 13:34:17',NULL),('Carlitos',12,1,1,NULL,'2025-05-28 19:52:36',NULL),('rama',13,1,1,NULL,'2025-05-29 13:05:12',NULL),('rama',13,1,1,NULL,'2025-05-29 13:07:12',NULL);
/*!40000 ALTER TABLE `Combattimenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_combattimenti_check_valid_insert


BEFORE INSERT ON Combattimenti


FOR EACH ROW


BEGIN


    IF NEW.Vittoria_Giocatore1 IS NULL THEN


        IF NEW.StatoPersonaggi IS NULL THEN


            SIGNAL SQLSTATE '45000' 


            SET MESSAGE_TEXT = 'StatoPersonaggi non può essere NULL se non è settata Vittoria_Giocatore1';


        END IF;


    END IF;





    IF NEW.DataUltimoTurno < NEW.DataInizioBattaglia THEN


        SIGNAL SQLSTATE '45000'


        SET MESSAGE_TEXT = "L'ultimo turno non può essere precedente all'inizio della battaglia";


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_combattimenti_terminata_check


BEFORE UPDATE ON Combattimenti


FOR EACH ROW


BEGIN


    IF NEW.Terminata = 1 AND NEW.Vittoria_Giocatore1 IS NULL THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Devi specificare il vincitore quando la battaglia è terminata';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_combattimenti_update_victory_status


BEFORE UPDATE ON Combattimenti


FOR EACH ROW


BEGIN


    IF NEW.Vittoria_Giocatore1 IS NOT NULL THEN


        SET NEW.StatoPersonaggi = NULL;


        SET NEW.Terminata = 1;


        SET NEW.DataUltimoTurno = NULL;


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_combattimenti_check_valid_update` BEFORE UPDATE ON `Combattimenti` FOR EACH ROW BEGIN


    DECLARE msg TEXT;


    


    IF NEW.Vittoria_Giocatore1 IS NULL THEN


        IF NEW.StatoPersonaggi IS NULL THEN


            SIGNAL SQLSTATE '45000' 


            SET MESSAGE_TEXT = 'StatoPersonaggi non può essere NULL se non è settata Vittoria_Giocatore1';


        END IF;


    END IF;





    IF NEW.DataUltimoTurno < OLD.DataUltimoTurno THEN


        SET msg = CONCAT('Errore: Il nuovo turno deve iniziare dopo quello precedente. NEW.DataUltimoTurno: ', NEW.DataUltimoTurno, ', OLD.DataUltimoTurno: ', OLD.DataUltimoTurno);


        SIGNAL SQLSTATE '45000' 


        SET MESSAGE_TEXT = msg;


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Element`
--

DROP TABLE IF EXISTS `Element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Element` (
  `Nome` varchar(50) NOT NULL,
  `PathImmagine` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PathImmaginePG` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `ModificatoreFor` int(11) DEFAULT '0',
  `ModificatoreDes` int(11) DEFAULT '0',
  `ModificatorePF` int(11) DEFAULT '0',
  `PrevaleSu` varchar(50) DEFAULT NULL,
  `PrevalsoDa` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Nome`),
  KEY `PrevaleSu` (`PrevaleSu`),
  KEY `PrevalsoDa` (`PrevalsoDa`) USING BTREE,
  CONSTRAINT `element_ibfk_1` FOREIGN KEY (`PrevaleSu`) REFERENCES `Element` (`Nome`) ON DELETE SET NULL,
  CONSTRAINT `element_ibfk_2` FOREIGN KEY (`PrevalsoDa`) REFERENCES `Element` (`Nome`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Element`
--

LOCK TABLES `Element` WRITE;
/*!40000 ALTER TABLE `Element` DISABLE KEYS */;
INSERT INTO `Element` VALUES ('Acqua','images/pics/acqua.svg','images/characters/acqua.svg',-3,2,5,'Fuoco','Elettro'),('Aria','images/pics/aria.svg','images/characters/aria.svg',-1,6,-1,'Terra','Fuoco'),('Elettro','images/pics/elettro.svg','images/characters/elettro.svg',6,0,-2,'Acqua','Terra'),('Fuoco','images/pics/fuoco.svg','images/characters/fuoco.svg',4,3,-3,'Aria','Acqua'),('Terra','images/pics/terra.svg','images/characters/terra.svg',0,-2,6,'Elettro','Aria');
/*!40000 ALTER TABLE `Element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inventario`
--

DROP TABLE IF EXISTS `Inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Inventario` (
  `Proprietario` int(11) NOT NULL,
  `Oggetto` int(11) NOT NULL,
  `Quantita` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Proprietario`,`Oggetto`),
  KEY `Oggetto` (`Oggetto`),
  CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`Proprietario`) REFERENCES `Account` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `inventario_ibfk_2` FOREIGN KEY (`Oggetto`) REFERENCES `Item` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inventario`
--

LOCK TABLES `Inventario` WRITE;
/*!40000 ALTER TABLE `Inventario` DISABLE KEYS */;
INSERT INTO `Inventario` VALUES (1,2,1),(1,3,2),(1,6,2),(1,7,2),(1,9,1),(1,13,1),(4,5,1),(4,9,1),(6,5,1),(6,11,1),(7,13,2),(9,7,1),(9,12,1),(12,2,1),(12,7,1),(13,5,2),(13,7,1);
/*!40000 ALTER TABLE `Inventario` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_inventario_quantita_check


BEFORE INSERT ON Inventario


FOR EACH ROW


BEGIN


    IF NEW.Quantita <= 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantita deve essere > 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_inventario_quantita_update_check


BEFORE UPDATE ON Inventario


FOR EACH ROW


BEGIN


    IF NEW.Quantita <= 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantita deve essere > 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Item`
--

DROP TABLE IF EXISTS `Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Item` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Descrizione` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Elemento` varchar(50) DEFAULT NULL,
  `PathImmagine` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `Tipologia` varchar(50) NOT NULL,
  `Costo` int(11) NOT NULL,
  `Danno` int(11) DEFAULT '0',
  `ProtezioneDanno` int(11) DEFAULT '0',
  `RecuperoVita` int(11) DEFAULT '0',
  `ModificatoreFor` int(11) DEFAULT '0',
  `ModificatoreDes` int(11) DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nome` (`Nome`),
  KEY `Elemento` (`Elemento`),
  KEY `Tipologia` (`Tipologia`),
  CONSTRAINT `item_ibfk_1` FOREIGN KEY (`Elemento`) REFERENCES `Element` (`Nome`),
  CONSTRAINT `item_ibfk_2` FOREIGN KEY (`Tipologia`) REFERENCES `ItemType` (`Nome`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Item`
--

LOCK TABLES `Item` WRITE;
/*!40000 ALTER TABLE `Item` DISABLE KEYS */;
INSERT INTO `Item` VALUES (1,'Spada d\'Acqua','Una spada affilata e leggera.','Acqua','images/items/weapons/acqua.svg','arma',20,6,0,0,2,1),(2,'Spada di Fuoco','Una spada infuocata.','Fuoco','images/items/weapons/fuoco.svg','arma',30,8,0,0,0,1),(3,'Mazza di Terra','Una mazza pesante e robusta.','Terra','images/items/weapons/terra.svg','arma',30,8,0,0,1,0),(4,'Bastone Elettrico','Un bastone che emette elettricità.','Elettro','images/items/weapons/elettro.svg','arma',25,7,0,0,1,1),(5,'Pugnale d\'Aria','Un pugnale leggero e veloce.','Aria','images/items/weapons/aria.svg','arma',20,6,0,0,1,2),(6,'Armatura d\'Acqua','Leggera e impermeabile.','Acqua','images/items/armors/acqua.svg','armatura',40,0,4,0,-1,0),(7,'Armatura di Fuoco','Resistente al calore.','Fuoco','images/items/armors/fuoco.svg','armatura',40,0,4,0,0,-1),(8,'Armatura di Terra','Robusta e pesante.','Terra','images/items/armors/terra.svg','armatura',45,0,5,0,-1,-2),(9,'Armatura Elettrica','Robusta e conduttiva.','Elettro','images/items/armors/elettro.svg','armatura',45,0,5,0,-2,-1),(10,'Armatura d\'Aria','Leggera e flessibile.','Aria','images/items/armors/aria.svg','armatura',35,0,3,0,0,0),(11,'Pozione di Vita','Ripristina 20 PF.',NULL,'images/items/potions/vita.svg','pozione',15,0,0,20,0,0),(12,'Pozione di Energia','Ripristina 10 PF.',NULL,'images/items/potions/energia.svg','pozione',10,0,0,10,0,0),(13,'Pozione di Forza','Aumenta la forza temporaneamente di 3 punti.',NULL,'images/items/potions/forza.svg','pozione',8,0,0,0,3,0),(14,'Pozione di Destrezza','Aumenta la destrezza temporaneamente di 3 punti.',NULL,'images/items/potions/destrezza.svg','pozione',8,0,0,0,0,3),(15,'Box Comune','Contiene monete, pozione, 2 oggetti (armi e/o armature).',NULL,'images/items/box/comune.svg','box',50,0,0,0,0,0),(16,'Box Rara','Contiene monete, 2 pozioni, 2 armi e 2 armature.',NULL,'images/items/box/raro.svg','box',100,0,0,0,0,0);
/*!40000 ALTER TABLE `Item` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_item_check` BEFORE INSERT ON `Item` FOR EACH ROW BEGIN


    IF NEW.Costo < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Costo deve essere >= 0';


    END IF;


    IF NEW.Danno < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danno deve essere >= 0';


    END IF;


    IF NEW.ProtezioneDanno < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ProtezioneDanno deve essere >= 0';


    END IF;


    IF NEW.RecuperoVita < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RecuperoVita deve essere >= 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_item_update_check` BEFORE UPDATE ON `Item` FOR EACH ROW BEGIN


    IF NEW.Costo < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Costo deve essere >= 0';


    END IF;


    IF NEW.Danno < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danno deve essere >= 0';


    END IF;


    IF NEW.ProtezioneDanno < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ProtezioneDanno deve essere >= 0';


    END IF;


    IF NEW.RecuperoVita < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RecuperoVita deve essere >= 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ItemType`
--

DROP TABLE IF EXISTS `ItemType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ItemType` (
  `Nome` varchar(50) NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ItemType`
--

LOCK TABLES `ItemType` WRITE;
/*!40000 ALTER TABLE `ItemType` DISABLE KEYS */;
INSERT INTO `ItemType` VALUES ('arma'),('armatura'),('box'),('pozione');
/*!40000 ALTER TABLE `ItemType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Negozio`
--

DROP TABLE IF EXISTS `Negozio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Negozio` (
  `Proprietario` int(11) NOT NULL,
  `Oggetto` int(11) NOT NULL,
  PRIMARY KEY (`Proprietario`,`Oggetto`),
  KEY `Oggetto` (`Oggetto`),
  CONSTRAINT `negozio_ibfk_1` FOREIGN KEY (`Proprietario`) REFERENCES `Account` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `negozio_ibfk_2` FOREIGN KEY (`Oggetto`) REFERENCES `Item` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Negozio`
--

LOCK TABLES `Negozio` WRITE;
/*!40000 ALTER TABLE `Negozio` DISABLE KEYS */;
INSERT INTO `Negozio` VALUES (1,1),(4,1),(10,1),(11,1),(13,1),(1,2),(3,2),(9,2),(10,2),(11,2),(13,2),(3,3),(7,3),(10,3),(11,3),(12,3),(13,3),(3,4),(4,4),(7,4),(9,4),(10,4),(13,4),(1,5),(3,5),(4,5),(7,5),(9,5),(10,5),(12,5),(13,5),(1,6),(4,6),(7,6),(9,6),(12,6),(13,6),(1,7),(4,7),(9,7),(11,7),(12,7),(1,8),(9,8),(13,8),(4,9),(7,9),(9,9),(10,9),(12,9),(7,10),(9,10),(11,10),(12,10),(1,11),(3,11),(4,11),(7,11),(10,11),(12,11),(13,11),(1,12),(3,12),(4,12),(7,12),(9,12),(10,12),(11,12),(13,12),(1,13),(3,13),(7,13),(9,13),(11,13),(12,13),(3,14),(4,14),(11,14),(12,14),(3,15),(4,15),(7,15),(10,15),(11,15),(12,15),(13,15),(1,16),(3,16),(10,16),(11,16);
/*!40000 ALTER TABLE `Negozio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Personaggi`
--

DROP TABLE IF EXISTS `Personaggi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Personaggi` (
  `Nome` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Proprietario` int(11) NOT NULL,
  `Forza` int(11) NOT NULL,
  `Destrezza` int(11) NOT NULL,
  `PuntiVita` int(11) NOT NULL DEFAULT '50',
  `Elemento` varchar(50) NOT NULL,
  `Armatura` int(11) DEFAULT NULL,
  `Arma` int(11) DEFAULT NULL,
  `Livello` int(11) NOT NULL DEFAULT '1',
  `PuntiExp` int(11) NOT NULL DEFAULT '0',
  `PuntiUpgrade` int(11) NOT NULL DEFAULT '5',
  PRIMARY KEY (`Nome`,`Proprietario`),
  KEY `Proprietario` (`Proprietario`),
  KEY `Arma` (`Arma`),
  KEY `Armatura` (`Armatura`),
  KEY `Elemento` (`Elemento`),
  CONSTRAINT `personaggi_ibfk_1` FOREIGN KEY (`Proprietario`) REFERENCES `Account` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `personaggi_ibfk_2` FOREIGN KEY (`Arma`) REFERENCES `Item` (`ID`) ON DELETE SET NULL,
  CONSTRAINT `personaggi_ibfk_3` FOREIGN KEY (`Armatura`) REFERENCES `Item` (`ID`) ON DELETE SET NULL,
  CONSTRAINT `personaggi_ibfk_4` FOREIGN KEY (`Elemento`) REFERENCES `Element` (`Nome`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Personaggi`
--

LOCK TABLES `Personaggi` WRITE;
/*!40000 ALTER TABLE `Personaggi` DISABLE KEYS */;
INSERT INTO `Personaggi` VALUES ('BugsBunny',11,2,6,49,'Aria',6,1,1,80,0),('Carlitos',1,6,3,48,'Elettro',9,4,1,0,0),('Carlitos',10,-1,9,49,'Aria',NULL,2,1,0,0),('Carlitos',12,0,2,55,'Acqua',9,1,1,15,0),('Folt',6,-3,2,56,'Acqua',NULL,3,1,0,2),('Fuochino',7,7,3,47,'Fuoco',6,1,1,0,0),('Gigino',4,4,3,47,'Fuoco',NULL,NULL,1,0,3),('Leonardo',1,0,2,55,'Acqua',9,1,1,80,0),('Luca',3,7,2,48,'Elettro',7,NULL,1,5,0),('Luchino',9,-1,2,56,'Acqua',9,NULL,1,0,0),('Maradona',10,0,-1,58,'Terra',9,NULL,1,0,0),('Pippo',1,0,2,55,'Acqua',9,2,1,15,0),('Rosso',1,4,3,50,'Fuoco',6,2,1,0,0),('Scintilla',1,6,2,49,'Elettro',8,3,1,0,0),('Scintilla',7,7,2,48,'Elettro',NULL,NULL,1,0,0),('bello',3,0,2,55,'Acqua',NULL,3,1,0,0),('pg1',3,0,0,57,'Terra',NULL,NULL,1,5,0),('piero',11,0,0,57,'Terra',NULL,NULL,1,20,0),('rama',13,6,0,48,'Elettro',7,3,1,30,3);
/*!40000 ALTER TABLE `Personaggi` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_personaggi_check


BEFORE INSERT ON Personaggi


FOR EACH ROW


BEGIN


    IF NEW.Forza < -10 OR NEW.Forza > 10 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Forza deve essere tra -10 e 10';


    END IF;


    IF NEW.Destrezza < -10 OR NEW.Destrezza > 10 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Destrezza deve essere tra -10 e 10';


    END IF;


    IF NEW.Livello < 1 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Livello deve essere >= 1';


    END IF;


    IF NEW.PuntiExp < 0 OR NEW.PuntiExp > 100 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiExp deve essere tra 0 e 100';


    END IF;


    IF NEW.PuntiUpgrade < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiUpgrade deve essere >= 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_personaggi_exp_update_for_lvl_up


BEFORE UPDATE ON Personaggi


FOR EACH ROW


BEGIN


    DECLARE proprietario_id INT;


    DECLARE livelli_guadagnati INT;





    IF NEW.PuntiExp >= 100 THEN


        SET livelli_guadagnati =  NEW.PuntiExp DIV 100;





        SET NEW.PuntiExp = NEW.PuntiExp % 100;


        SET NEW.Livello = NEW.Livello + livelli_guadagnati;


        SET NEW.PuntiUpgrade = NEW.PuntiUpgrade + (3 * livelli_guadagnati);





        SET proprietario_id = NEW.Proprietario;





        UPDATE Account


        SET Monete = Monete + (40 * livelli_guadagnati)


        WHERE ID = proprietario_id;








        INSERT INTO Inventario (Proprietario, Oggetto, Quantita)


        VALUES (proprietario_id, 15, livelli_guadagnati)


        ON DUPLICATE KEY UPDATE Quantita = Quantita + livelli_guadagnati;


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_personaggi_update_check` BEFORE UPDATE ON `Personaggi` FOR EACH ROW BEGIN


    IF NEW.Forza < -10 OR NEW.Forza > 10 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Forza deve essere tra -10 e 10';


    END IF;


    IF NEW.Destrezza < -10 OR NEW.Destrezza > 10 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Destrezza deve essere tra -10 e 10';


    END IF;


    IF NEW.Livello < 1 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Livello deve essere >= 1';


    END IF;


    IF NEW.PuntiExp < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiExp deve essere >= 100';


    END IF;


    IF NEW.PuntiUpgrade < 0 THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiUpgrade deve essere >= 0';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Zaino`
--

DROP TABLE IF EXISTS `Zaino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Zaino` (
  `Personaggio` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Proprietario` int(11) NOT NULL,
  `Oggetto` int(11) NOT NULL,
  `Quantita` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Personaggio`,`Proprietario`,`Oggetto`),
  KEY `Oggetto` (`Oggetto`),
  CONSTRAINT `zaino_ibfk_1` FOREIGN KEY (`Personaggio`, `Proprietario`) REFERENCES `Personaggi` (`Nome`, `Proprietario`) ON DELETE CASCADE,
  CONSTRAINT `zaino_ibfk_2` FOREIGN KEY (`Oggetto`) REFERENCES `Item` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Zaino`
--

LOCK TABLES `Zaino` WRITE;
/*!40000 ALTER TABLE `Zaino` DISABLE KEYS */;
INSERT INTO `Zaino` VALUES ('Carlitos',1,13,1),('Fuochino',7,12,1),('Fuochino',7,13,1),('Leonardo',1,11,1),('Pippo',1,12,1),('Pippo',1,13,1),('Pippo',1,14,1),('Rosso',1,12,1),('Rosso',1,13,1),('Scintilla',1,11,1),('Scintilla',1,12,1),('Scintilla',1,14,1),('pg1',3,14,1),('rama',13,13,1);
/*!40000 ALTER TABLE `Zaino` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_zaino_check


BEFORE INSERT ON Zaino


FOR EACH ROW


BEGIN


    DECLARE tipologia_invalid BOOLEAN;





    SELECT COUNT(*) > 0 INTO tipologia_invalid


    FROM Item


    WHERE ID = NEW.Oggetto AND Tipologia IN ('arma', 'armatura', 'box');





    IF tipologia_invalid THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipologia non valida per Zaino (arma, armatura, box non consentiti)';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_zaino_update_check


BEFORE UPDATE ON Zaino


FOR EACH ROW


BEGIN


    DECLARE tipologia_invalid BOOLEAN;





    SELECT COUNT(*) > 0 INTO tipologia_invalid


    FROM Item


    WHERE ID = NEW.Oggetto AND Tipologia IN ('arma', 'armatura', 'box');





    IF tipologia_invalid THEN


        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipologia non valida per Zaino (arma, armatura, box non consentiti)';


    END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-30 12:40:55
