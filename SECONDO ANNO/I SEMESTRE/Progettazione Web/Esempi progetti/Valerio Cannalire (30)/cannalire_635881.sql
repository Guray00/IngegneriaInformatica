-- Progettazione Web 
DROP DATABASE if exists cannalire_635881; 
CREATE DATABASE cannalire_635881; 
USE cannalire_635881; 
-- MySQL dump 10.13  Distrib 5.7.28, for Win64 (x86_64)
--
-- Host: localhost    Database: cannalire_635881
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
-- Table structure for table `forum`
--

DROP TABLE IF EXISTS `forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum` (
  `id_forum` int(11) NOT NULL AUTO_INCREMENT,
  `id_creatore` int(11) NOT NULL,
  `nome_forum` varchar(20) NOT NULL,
  `descrizione` text,
  PRIMARY KEY (`id_forum`),
  UNIQUE KEY `nome_forum` (`nome_forum`),
  KEY `id_creatore` (`id_creatore`),
  CONSTRAINT `forum_ibfk_1` FOREIGN KEY (`id_creatore`) REFERENCES `utenti` (`id_utente`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum`
--

LOCK TABLES `forum` WRITE;
/*!40000 ALTER TABLE `forum` DISABLE KEYS */;
INSERT INTO `forum` VALUES (1,1,'Scienze',NULL),(2,1,'Informatica',NULL),(3,2,'Matematica',NULL);
/*!40000 ALTER TABLE `forum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interazioni`
--

DROP TABLE IF EXISTS `interazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interazioni` (
  `id_utente` int(11) NOT NULL,
  `id_post` int(11) NOT NULL,
  `tipo_interazione` enum('like','dislike','segnala') NOT NULL,
  PRIMARY KEY (`id_utente`,`id_post`,`tipo_interazione`),
  KEY `id_post` (`id_post`),
  CONSTRAINT `interazioni_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utenti` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `interazioni_ibfk_2` FOREIGN KEY (`id_post`) REFERENCES `post` (`id_post`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interazioni`
--

LOCK TABLES `interazioni` WRITE;
/*!40000 ALTER TABLE `interazioni` DISABLE KEYS */;
INSERT INTO `interazioni` VALUES (1,1,'like'),(2,1,'like'),(4,1,'dislike'),(1,2,'segnala'),(2,2,'segnala'),(3,2,'segnala'),(4,2,'dislike'),(4,2,'segnala'),(5,2,'segnala'),(1,3,'like'),(5,4,'dislike'),(3,6,'like'),(4,6,'like');
/*!40000 ALTER TABLE `interazioni` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iscrizioni_forum`
--

DROP TABLE IF EXISTS `iscrizioni_forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iscrizioni_forum` (
  `id_utente` int(11) NOT NULL,
  `id_forum` int(11) NOT NULL,
  PRIMARY KEY (`id_utente`,`id_forum`),
  KEY `id_forum` (`id_forum`),
  CONSTRAINT `iscrizioni_forum_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utenti` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `iscrizioni_forum_ibfk_2` FOREIGN KEY (`id_forum`) REFERENCES `forum` (`id_forum`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iscrizioni_forum`
--

LOCK TABLES `iscrizioni_forum` WRITE;
/*!40000 ALTER TABLE `iscrizioni_forum` DISABLE KEYS */;
INSERT INTO `iscrizioni_forum` VALUES (1,1),(1,2),(2,2),(3,2),(4,2),(5,2),(2,3);
/*!40000 ALTER TABLE `iscrizioni_forum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post` (
  `id_post` int(11) NOT NULL AUTO_INCREMENT,
  `id_utente` int(11) NOT NULL,
  `id_forum` int(11) NOT NULL,
  `titolo` varchar(20) NOT NULL,
  `contenuto` text NOT NULL,
  `data_pubblicazione` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modificato` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_post`),
  KEY `id_utente` (`id_utente`),
  KEY `id_forum` (`id_forum`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utenti` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `post_ibfk_2` FOREIGN KEY (`id_forum`) REFERENCES `forum` (`id_forum`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,1,2,'Provate Java','Miglior linguaggio a oggetti!','2026-06-08 21:34:24',0),(2,1,2,'Java fa schifo','Nessuno mi crederà','2026-06-08 21:35:02',0),(3,1,2,'Sistemare dialog','In mozilla','2026-06-08 21:35:47',0),(4,1,2,'Bel sito','Lorem ipsum','2026-06-08 21:36:18',0),(5,2,3,'Calcolo numerico','Ma quanto è difficile?','2026-06-08 21:37:50',0),(6,3,2,'Meglio python','Devo solo imparare a usarlo! È facile','2026-06-08 21:39:33',1);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `id_topic` int(11) NOT NULL AUTO_INCREMENT,
  `id_forum` int(11) NOT NULL,
  `titolo_topic` varchar(20) NOT NULL,
  PRIMARY KEY (`id_topic`),
  KEY `id_forum` (`id_forum`),
  CONSTRAINT `topic_ibfk_1` FOREIGN KEY (`id_forum`) REFERENCES `forum` (`id_forum`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,2,'Java'),(2,2,'JavaScript'),(3,2,'PHP');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic_post`
--

DROP TABLE IF EXISTS `topic_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic_post` (
  `id_post` int(11) NOT NULL,
  `id_topic` int(11) NOT NULL,
  PRIMARY KEY (`id_post`,`id_topic`),
  KEY `id_topic` (`id_topic`),
  CONSTRAINT `topic_post_ibfk_1` FOREIGN KEY (`id_post`) REFERENCES `post` (`id_post`) ON DELETE CASCADE,
  CONSTRAINT `topic_post_ibfk_2` FOREIGN KEY (`id_topic`) REFERENCES `topic` (`id_topic`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic_post`
--

LOCK TABLES `topic_post` WRITE;
/*!40000 ALTER TABLE `topic_post` DISABLE KEYS */;
INSERT INTO `topic_post` VALUES (1,1),(3,2),(4,2),(4,3);
/*!40000 ALTER TABLE `topic_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utenti` (
  `id_utente` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(12) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id_utente`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES (1,'utente1','$2y$10$OLApmtobSJz42HlpOVq1y.KurEm9T5Y7PZoRz8f11zCoYCjT6M2d6'),(2,'utente2','$2y$10$hhKdUr0F9pyVsyUy6ZZY/OT2eZZy/UGV4ha./q3OJUUkXRLt6iqhG'),(3,'utente3','$2y$10$2HtdzpPsni0.RW21t0UoYOvnJQeY/Eyh5jQvnCxhBeEg8z0j9XOJm'),(4,'utente4','$2y$10$cn61EIQ189Ysv/VmIztZnubns8d0mn.n4nHLbMy/wlaXALd8FJO6q'),(5,'utente5','$2y$10$iBc2KSi91TR5PYvtaUxN0urze.pvdEm2As7YShi9jfmvCjgcX8uEq');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-08 23:48:31
