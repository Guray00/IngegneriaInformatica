-- Progettazione Web 
DROP DATABASE if exists zingrillo_662371; 
CREATE DATABASE zingrillo_662371; 
USE zingrillo_662371; 
-- MySQL dump 10.13  Distrib 5.6.20, for Win32 (x86)
--
-- Host: localhost    Database: zingrillo_662371
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `affiliazione`
--

DROP TABLE IF EXISTS `affiliazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliazione` (
  `Giocatore` int(11) NOT NULL,
  `Squadra` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliazione`
--

LOCK TABLES `affiliazione` WRITE;
/*!40000 ALTER TABLE `affiliazione` DISABLE KEYS */;
INSERT INTO `affiliazione` VALUES (3,6),(4,7),(5,8),(6,9),(7,10),(10,11),(11,12),(12,13),(6,7),(5,7),(11,7),(12,7);
/*!40000 ALTER TABLE `affiliazione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arbitraggio`
--

DROP TABLE IF EXISTS `arbitraggio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arbitraggio` (
  `Arbitro` int(11) DEFAULT NULL,
  `Torneo` varchar(255) NOT NULL,
  `Codice` varchar(255) NOT NULL,
  PRIMARY KEY (`Torneo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arbitraggio`
--

LOCK TABLES `arbitraggio` WRITE;
/*!40000 ALTER TABLE `arbitraggio` DISABLE KEYS */;
INSERT INTO `arbitraggio` VALUES (2,'Lega Pistoia','$2y$10$yJ9rC1AGhT2qpdS7I9tRTOcZbOSaSa1TLoPfxkI3S/kQbL5isRELm');
/*!40000 ALTER TABLE `arbitraggio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificato`
--

DROP TABLE IF EXISTS `certificato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificato` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Giocatore` int(11) NOT NULL,
  `Scadenza` date NOT NULL,
  `Contenuto` blob NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificato`
--

LOCK TABLES `certificato` WRITE;
/*!40000 ALTER TABLE `certificato` DISABLE KEYS */;
INSERT INTO `certificato` VALUES (1,4,'2024-03-14',''),(2,6,'2024-09-05',''),(3,5,'2024-01-30','UHJvdmE='),(4,11,'2025-01-30','UHJvdmE='),(5,12,'2024-10-30','UHJvdmE=');
/*!40000 ALTER TABLE `certificato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partita`
--

DROP TABLE IF EXISTS `partita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partita` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Squadra1` varchar(255) DEFAULT NULL,
  `Squadra2` varchar(255) DEFAULT NULL,
  `Set1Squadra1` int(11) DEFAULT NULL,
  `Set1Squadra2` int(11) DEFAULT NULL,
  `Set2Squadra1` int(11) DEFAULT NULL,
  `Set2Squadra2` int(11) DEFAULT NULL,
  `Set3Squadra1` int(11) DEFAULT NULL,
  `Set3Squadra2` int(11) DEFAULT NULL,
  `Vince1` int(11) DEFAULT NULL,
  `Commenti` varchar(255) DEFAULT NULL,
  `Dataeora` datetime NOT NULL,
  `Luogo` varchar(255) NOT NULL,
  `Torneo` varchar(255) NOT NULL,
  `Squadra1dapartita` int(11) DEFAULT NULL,
  `Squadra2dapartita` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partita`
--

LOCK TABLES `partita` WRITE;
/*!40000 ALTER TABLE `partita` DISABLE KEYS */;
INSERT INTO `partita` VALUES (9,'6','10',25,10,25,10,25,22,1,'                        \r\n                                                \r\n                        Nessun commento\r\n                        \r\n                        ','2024-01-30 17:00:00','Palasport','Lega Pistoia',NULL,NULL),(10,'7','11',30,28,23,25,25,10,1,'                        \r\n                        Nessun commento\r\n                        ','2024-01-31 17:00:00','Palasport','Lega Pistoia',NULL,NULL),(11,'8','12',25,20,20,25,10,25,0,'                        \r\n                        Nessun commento\r\n                        ','2024-02-01 17:00:00','Palasport','Lega Pistoia',NULL,NULL),(12,'9','13',25,10,10,25,10,25,0,'                        \r\n                        Nessun Commento\r\n                        ','2024-02-02 17:00:00','Palasport','Lega Pistoia',NULL,NULL),(13,'13','12',10,25,15,25,0,0,0,'                        \r\n                                                \r\n                                                \r\n                        Nessun commento\r\n                        \r\n                        \r\n                        ','2024-02-06 17:00:00','Palasport','Lega Pistoia',12,11),(14,'7','6',25,16,28,26,0,0,1,'                        \r\n                                                \r\n                        Nessun commento\r\n                        \r\n                        ','2024-02-07 17:00:00','Palasport','Lega Pistoia',10,9),(15,'7','12',23,25,25,12,25,12,0,'Grande abilità tecnica.\r\n                        \r\n                        ','2024-02-08 17:00:00','Palasport','Lega Pistoia',14,13);
/*!40000 ALTER TABLE `partita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `squadra`
--

DROP TABLE IF EXISTS `squadra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `squadra` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(255) NOT NULL,
  `Capitano` int(11) NOT NULL,
  `Torneo` varchar(255) NOT NULL,
  `Codice` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `squadra`
--

LOCK TABLES `squadra` WRITE;
/*!40000 ALTER TABLE `squadra` DISABLE KEYS */;
INSERT INTO `squadra` VALUES (6,'CUS Pisa',3,'Lega Pistoia','$2y$10$PqgKL6fAZyu.OIzW2KTeKuT956SaUaa7c40nM7B/Ge.XaxIoHFx36'),(7,'Alberto e Co',4,'Lega Pistoia','$2y$10$SbP8naXKtLGPFji49.Kspuxyfehl7oThxBvbh1TbnR1kwotLdHC/q'),(8,'Quelli del liceo',5,'Lega Pistoia','$2y$10$GoxInuKQIz0SxVr5.8TrKewNugVzutKOQJ0zceZJP.NQ1BN9C7nRy'),(9,'Scienze Politiche ',6,'Lega Pistoia','$2y$10$DbURJ.HuhVkEnKV7radnkudYxN2zcjj1ESrED9yD7Xs.nG5jelVqG'),(10,'barLume',7,'Lega Pistoia','$2y$10$570XcaVGUh9h7JTrTMGJiukRvxeepli7zg2aHymYqeeo4PAF7wYmC'),(11,'Giannelli Fanclub',10,'Lega Pistoia','$2y$10$0OAt8cSigzokDfeW7Y5GTOZNJc70tBJBEw7Ks7upA5zYOzoW6/6FO'),(12,'Economia Pisa',11,'Lega Pistoia','$2y$10$PhHHTj0x426qgkqExDYbmen2mlgClnJ3aNg1ikq/0uGWe7QbZq1V6'),(13,'Studio Rossi',12,'Lega Pistoia','$2y$10$P7P/1OOG0cUpZHzB.Ed1qOpR6tnh.YYU/NOk3zUYzrcIypi5Dl2IW');
/*!40000 ALTER TABLE `squadra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utente` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Ruolo` int(11) NOT NULL COMMENT '0=Admin, 1=Arbitro,  2= Giocatore',
  `Nome` varchar(255) NOT NULL,
  `Cognome` varchar(255) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,0,'admin','admin','admin','$2y$10$eg2eQkb1zKEFLzPt1PhOkOQTdzdmWZQszz/cgve1AHvCnlmQe2PYu'),(2,1,'mario','rossi','arbitro','$2y$10$kKKxAv1wh3dPoaFOFtPE1Ow.VVtidt34PDD9ah.MSTqkLoSvVmKWa'),(3,2,'fabio','bianchi','capitano','$2y$10$zRzw36ZxS0H2yQqgtdZ91.cxZvnSVuPb6rh0OzWBKPoP3qE4PYfq2'),(4,2,'Alberto','Neri','alberto','$2y$10$Tbfa3FwfFbId4x3rAFEVT.wizbW0Tp2BRGlQDL8GvXky8qYvLIeyG'),(5,2,'Gabriele','Ferrari','gabriele','$2y$10$vRPi5LsLU3S9eMdZyNxyleXhrfdn8WcZht8pg2jSb.rVMiRiy.Aha'),(6,2,'Gabriele','Gargaloni','gargaloni','$2y$10$V1DVdo4zpZ8hgmrMx8iTGe0wUf9Vsr9OITDMcSwZWptvZT/whUISu'),(7,2,'Francesco','Toiati','francesco','$2y$10$TL1N973a6R0FRe/AqeJkP.p0ISgrsfWENcAr9h0NRMmXFwC.JB3.W'),(8,1,'Andrea','Canforini','andrea','$2y$10$Ob9.pBDYHOrCHNY1TLa1NuDv1PYDoMJ5oOXuw5Khux7/SXlxg3CnK'),(9,1,'simone','fazzello','simone','$2y$10$UIy/w4LOIc.wCndAWkhhzuctSxoTqp5.SS/tGeAlThoKj3ZloTAcC'),(10,2,'filippo','terrinoni','filippo','$2y$10$mLYrA1YVpRetLNsTdZttTel/RSHcCdqcKP.VXP5iG3Enb2fKlZ2xy'),(11,2,'Giovanni','Stivella','giovanni','$2y$10$PJY2RxEsxlXmvXLRLhzNo.0SfkipdXx1O8uunGbyRK3TCB5KuAepe'),(12,2,'Edoardo','Spataro','edoardo','$2y$10$3a7HlJAJYHT3fhsL1qu4x.FSzV8aJsawNCqhTuUxFo6DYPMqp9wlC');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-07  0:26:00
