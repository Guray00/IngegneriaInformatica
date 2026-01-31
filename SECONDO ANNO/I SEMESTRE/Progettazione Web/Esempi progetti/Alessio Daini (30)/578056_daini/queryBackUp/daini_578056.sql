-- Progettazione Web 
DROP DATABASE if exists daini_578056; 
CREATE DATABASE daini_578056; 
USE daini_578056; 
-- MySQL dump 10.13  Distrib 5.7.28, for Win64 (x86_64)
--
-- Host: localhost    Database: daini_578056
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
-- Table structure for table `password`
--

DROP TABLE IF EXISTS `password`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password` (
  `password` varchar(255) NOT NULL,
  `passwordId` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`passwordId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password`
--

LOCK TABLES `password` WRITE;
/*!40000 ALTER TABLE `password` DISABLE KEYS */;
INSERT INTO `password` VALUES ('$2y$10$gYoevfPu4P2Gg5F3vdqt2eXrqUSG0M2QzBXSyXSgAOO44ER84CBEG',1),('$2y$10$PCRGQLYCUeADdli7UwphCORdU9Lm02Vel1TWqH3z65mCDCSUlTgqe',2),('$2y$10$GE2KYX05QqYU0nOcwRZ.peu3zpw.VIhEORLvhUmR/E2N4luNUVayO',3),('$2y$10$VMSo0PyPMmZDergLk0AaCOCEPlC6FEhtL09UgYpIgSUVSzNQg8V4C',4),('$2y$10$oQJ3tHwRVTAz7tg7gNnGQ.M4B8XL37/GEiC0nl0K8/U3OT8AG3LjS',5);
/*!40000 ALTER TABLE `password` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `question` text NOT NULL,
  `answer` text NOT NULL,
  `record` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES (1,'$2y$10$gYoevfPu4P2Gg5F3vdqt2eXrqUSG0M2QzBXSyXSgAOO44ER84CBEG','dains98','In che città sei nato?','Livorno',692),(3,'$2y$10$PCRGQLYCUeADdli7UwphCORdU9Lm02Vel1TWqH3z65mCDCSUlTgqe','alessio','Qual è la persona più importante per te?','me stesso',839),(5,'$2y$10$GE2KYX05QqYU0nOcwRZ.peu3zpw.VIhEORLvhUmR/E2N4luNUVayO','Alexandra01','Nome di un parente importante','Papa',1934),(7,'$2y$10$VMSo0PyPMmZDergLk0AaCOCEPlC6FEhtL09UgYpIgSUVSzNQg8V4C','master','Qual è la tua attività preferita','vincere',1520),(9,'$2y$10$oQJ3tHwRVTAz7tg7gNnGQ.M4B8XL37/GEiC0nl0K8/U3OT8AG3LjS','veroMaster','Qual è la tua attività preferita','Stravincere',2852);
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scoreplayer`
--

DROP TABLE IF EXISTS `scoreplayer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scoreplayer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `points` int(11) NOT NULL,
  `playerDate` datetime NOT NULL,
  `won` int(11) NOT NULL,
  `playerId` int(11) NOT NULL,
  PRIMARY KEY (`id`,`playerId`),
  KEY `fk_scorePlayer_player_idx` (`playerId`),
  CONSTRAINT `fk_scorePlayer_player` FOREIGN KEY (`playerId`) REFERENCES `player` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scoreplayer`
--

LOCK TABLES `scoreplayer` WRITE;
/*!40000 ALTER TABLE `scoreplayer` DISABLE KEYS */;
INSERT INTO `scoreplayer` VALUES (1,368,'2025-12-07 21:43:18',0,1),(2,692,'2025-12-07 21:45:00',0,1),(3,839,'2025-12-07 21:46:39',1,3),(4,1157,'2025-12-07 21:48:11',0,5),(5,1934,'2025-12-07 21:48:57',1,5),(6,1520,'2025-12-07 21:50:52',0,7),(7,304,'2025-12-07 21:51:39',0,7),(8,336,'2025-12-07 21:52:35',0,9),(9,2852,'2025-12-07 21:53:08',0,9);
/*!40000 ALTER TABLE `scoreplayer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security`
--

DROP TABLE IF EXISTS `security`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `security` (
  `playerId` int(11) NOT NULL,
  `passwordId` int(11) NOT NULL,
  PRIMARY KEY (`playerId`,`passwordId`),
  KEY `fk_player_has_password_password2_idx` (`passwordId`),
  KEY `fk_player_has_password_player2_idx` (`playerId`),
  CONSTRAINT `fk_player_has_password_password2` FOREIGN KEY (`passwordId`) REFERENCES `password` (`passwordId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_has_password_player2` FOREIGN KEY (`playerId`) REFERENCES `player` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security`
--

LOCK TABLES `security` WRITE;
/*!40000 ALTER TABLE `security` DISABLE KEYS */;
INSERT INTO `security` VALUES (1,1),(3,2),(5,3),(7,4),(9,5);
/*!40000 ALTER TABLE `security` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-07 22:01:17
