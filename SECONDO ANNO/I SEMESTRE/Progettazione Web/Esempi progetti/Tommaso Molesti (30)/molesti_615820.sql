-- Progettazione Web 
DROP DATABASE if exists molesti_615820; 
CREATE DATABASE molesti_615820; 
USE molesti_615820; 
-- MySQL dump 10.13  Distrib 5.7.28, for Win64 (x86_64)
--
-- Host: localhost    Database: molesti_615820
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
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `party_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `tracking_quantity` tinyint(1) NOT NULL,
  `price` float NOT NULL,
  `sort_index` int(11) DEFAULT NULL,
  `removed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (9,3,'Coperto',0,0,1.5,1,0),(10,3,'Crostata',5,1,3,9,0),(11,3,'Pasta al pomodoro',30,1,6,5,0),(12,3,'Coniglio',0,1,7,8,0),(13,3,'Pasta al ragù di coniglio',19,1,6,6,0),(14,3,'Vino bianco 0.75 L',15,1,5,3,0),(15,3,'Vino rosso 0.75 L',9,1,5,4,0),(16,3,'Piatto freddo',50,1,4,7,0),(17,4,'Coperto',0,0,1.5,1,0),(18,4,'Crostata',0,1,3,9,0),(19,4,'Pasta al pomodoro',38,1,6,5,0),(20,4,'Coniglio',30,1,7,7,0),(21,4,'Pasta al ragù di coniglio',77,1,6,6,0),(22,4,'Vino bianco 0.75 L',10,1,5,3,0),(23,4,'Vino rosso 0.75 L',8,1,5,4,0),(24,4,'Piatto freddo',68,1,4,8,0),(25,3,'Acqua 1.5 L',50,1,2,2,0),(26,4,'Acqua 1.5 L',20,1,2,2,0);
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles_ordered`
--

DROP TABLE IF EXISTS `articles_ordered`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles_ordered` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `party_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles_ordered`
--

LOCK TABLES `articles_ordered` WRITE;
/*!40000 ALTER TABLE `articles_ordered` DISABLE KEYS */;
INSERT INTO `articles_ordered` VALUES (21,9,6,3,3),(22,14,6,3,1),(23,16,6,3,1),(24,13,6,3,1),(25,12,6,3,1),(26,15,6,3,1),(27,9,7,3,2),(28,13,7,3,1),(29,25,7,3,1),(30,15,7,3,1),(31,14,7,3,1),(32,16,7,3,1),(33,12,7,3,2),(34,10,7,3,1),(35,11,7,3,1),(36,9,8,3,1),(37,14,8,3,1),(38,16,8,3,1),(39,13,8,3,1),(40,25,8,3,1),(41,15,8,3,2),(42,9,9,3,5),(43,13,9,3,3),(44,16,9,3,1),(45,14,9,3,1),(46,15,9,3,1),(47,11,9,3,1),(48,12,9,3,2),(49,25,9,3,1),(50,9,10,3,4),(51,14,10,3,1),(52,16,10,3,1),(53,12,10,3,2),(54,10,10,3,1),(55,11,10,3,2),(56,25,10,3,3),(57,9,11,3,2),(58,13,11,3,2),(59,14,11,3,1),(60,16,11,3,2),(61,12,11,3,1),(62,10,11,3,1),(63,11,11,3,1),(64,25,11,3,2),(65,9,12,3,3),(66,13,12,3,1),(67,14,12,3,1),(68,12,12,3,1),(69,15,12,3,1),(70,11,12,3,1),(71,16,12,3,1),(72,9,13,3,3),(73,13,13,3,1),(74,16,13,3,1),(75,15,13,3,1),(76,11,13,3,3),(77,12,13,3,1),(78,25,13,3,1),(79,9,14,3,3),(80,13,14,3,1),(81,16,14,3,1),(82,15,14,3,2),(83,14,14,3,1),(84,12,14,3,1),(85,25,14,3,1),(86,9,15,3,4),(87,14,15,3,1),(88,15,15,3,1),(89,10,15,3,2),(90,12,15,3,2),(91,16,15,3,2),(92,11,15,3,2),(93,13,15,3,1),(94,9,16,3,3),(95,14,16,3,1),(96,16,16,3,1),(97,12,16,3,2),(98,10,16,3,1),(99,25,16,3,1),(100,13,16,3,2),(101,9,17,3,3),(102,13,17,3,1),(103,16,17,3,2),(104,12,17,3,1),(105,11,17,3,1),(106,15,17,3,1),(107,25,17,3,2),(108,9,18,3,3),(109,13,18,3,1),(110,14,18,3,1),(111,16,18,3,1),(112,12,18,3,1),(113,11,18,3,2),(114,10,18,3,1),(115,25,18,3,1),(116,9,19,3,3),(117,13,19,3,2),(118,25,19,3,2),(119,16,19,3,1),(120,14,19,3,1),(121,15,19,3,1),(122,12,19,3,1),(123,10,19,3,1),(124,11,19,3,1),(125,9,20,3,3),(126,14,20,3,1),(127,16,20,3,2),(128,13,20,3,2),(129,25,20,3,2),(130,10,20,3,1),(131,11,20,3,1),(132,12,20,3,1),(133,9,21,3,3),(134,14,21,3,1),(135,16,21,3,1),(136,13,21,3,1),(137,25,21,3,2),(138,12,21,3,2),(139,10,21,3,1),(140,11,21,3,1),(141,9,22,3,3),(142,14,22,3,1),(143,15,22,3,1),(144,11,22,3,1),(145,13,22,3,2),(146,16,22,3,1),(147,12,22,3,1),(148,10,22,3,2),(149,9,23,3,3),(150,25,23,3,1),(151,14,23,3,1),(152,11,23,3,1),(153,13,23,3,1),(154,16,23,3,2),(155,10,23,3,2),(156,9,24,3,3),(157,15,24,3,1),(158,11,24,3,1),(159,13,24,3,2),(160,16,24,3,2),(161,12,24,3,1),(162,10,24,3,2),(163,9,25,3,4),(164,11,25,3,1),(165,13,25,3,2),(166,16,25,3,2),(167,12,25,3,3),(168,10,25,3,2),(169,17,26,4,4),(170,26,26,4,1),(171,22,26,4,1),(172,19,26,4,2),(173,21,26,4,1),(174,20,26,4,3),(175,18,26,4,1),(176,17,27,4,3),(177,26,27,4,1),(178,22,27,4,1),(179,19,27,4,2),(180,21,27,4,1),(181,20,27,4,1),(182,18,27,4,2),(183,17,28,4,3),(184,22,28,4,1),(185,23,28,4,1),(186,19,28,4,1),(187,21,28,4,1),(188,20,28,4,1),(189,24,28,4,1),(190,18,28,4,2),(191,17,29,4,3),(192,26,29,4,1),(193,22,29,4,1),(194,19,29,4,1),(195,21,29,4,1),(196,20,29,4,2),(197,24,29,4,1),(198,18,29,4,1),(199,17,30,4,3),(200,26,30,4,1),(201,19,30,4,1),(202,21,30,4,1),(203,20,30,4,3),(204,24,30,4,1),(205,17,31,4,3),(206,22,31,4,2),(207,19,31,4,1),(208,21,31,4,1),(209,20,31,4,1),(210,18,31,4,2),(211,17,32,4,3),(212,22,32,4,2),(213,23,32,4,1),(214,19,32,4,2),(215,21,32,4,2),(216,20,32,4,1),(217,24,32,4,1),(218,18,32,4,2),(219,17,33,4,4),(220,26,33,4,1),(221,22,33,4,1),(222,19,33,4,2),(223,21,33,4,1),(224,20,33,4,1),(225,24,33,4,2),(226,17,34,4,4),(227,26,34,4,2),(228,22,34,4,1),(229,19,34,4,1),(230,21,34,4,1),(231,20,34,4,1),(232,24,34,4,2),(233,18,34,4,2),(234,17,35,4,5),(235,26,35,4,2),(236,22,35,4,1),(237,23,35,4,1),(238,19,35,4,2),(239,21,35,4,1),(240,20,35,4,2),(241,24,35,4,1),(242,18,35,4,1),(243,17,36,4,4),(244,22,36,4,1),(245,19,36,4,2),(246,21,36,4,3),(247,20,36,4,1),(248,24,36,4,1),(249,18,36,4,3),(250,17,37,4,5),(251,26,37,4,2),(252,22,37,4,3),(253,19,37,4,2),(254,21,37,4,3),(255,20,37,4,2),(256,18,37,4,2),(257,17,38,4,4),(258,26,38,4,1),(259,19,38,4,2),(260,21,38,4,2),(261,20,38,4,4),(262,24,38,4,1),(263,18,38,4,2),(264,17,39,4,4),(265,22,39,4,1),(266,19,39,4,2),(267,21,39,4,2),(268,20,39,4,3),(269,18,39,4,1),(270,17,40,4,4),(271,26,40,4,2),(272,22,40,4,1),(273,23,40,4,2),(274,19,40,4,1),(275,21,40,4,2),(276,20,40,4,2),(277,18,40,4,1),(278,17,41,4,4),(279,26,41,4,1),(280,19,41,4,2),(281,21,41,4,2),(282,20,41,4,1),(283,18,41,4,1),(284,17,42,4,3),(285,26,42,4,2),(286,22,42,4,1),(287,19,42,4,1),(288,21,42,4,1),(289,20,42,4,2),(290,18,42,4,1),(291,17,43,4,4),(292,26,43,4,2),(293,19,43,4,1),(294,21,43,4,1),(295,24,43,4,1),(296,18,43,4,2),(297,17,44,4,5),(298,26,44,4,2),(299,19,44,4,1),(300,21,44,4,1),(301,18,44,4,1);
/*!40000 ALTER TABLE `articles_ordered` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `party_id` int(11) NOT NULL,
  `order_counter` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `ordered_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `waiter_handled_time` timestamp NULL DEFAULT NULL,
  `waiter_id` int(11) DEFAULT NULL,
  `served_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (6,3,1,'Rossi','2024-11-11 16:50:20','2024-11-11 17:00:52',2,'2024-11-11 17:12:55'),(7,3,2,'Verdi','2024-11-11 16:55:27','2024-11-11 17:15:52',3,'2024-11-11 17:23:34'),(8,3,3,'Neri','2024-11-11 17:00:34','2024-11-11 17:10:16',4,'2024-11-11 17:29:35'),(9,3,4,'Gialli','2024-11-11 17:15:46','2024-11-11 17:20:08',2,'2024-11-11 17:36:54'),(10,3,5,'Arancioni','2024-11-11 17:20:59','2024-11-11 17:35:08',3,'2024-11-11 17:55:56'),(11,3,6,'Celesti','2024-11-11 17:25:19','2024-11-11 17:40:20',4,'2024-11-11 17:57:50'),(12,3,7,'Rossini','2024-11-11 17:35:28','2024-11-11 17:40:13',2,'2024-11-11 18:07:33'),(13,3,8,'Violetti','2024-11-11 17:40:40','2024-11-11 18:00:06',3,'2024-11-11 18:25:49'),(14,3,9,'Arancionissimi','2024-11-11 17:45:52','2024-11-11 17:55:51',4,'2024-11-11 18:04:49'),(15,3,10,'Giallini','2024-11-11 17:50:11','2024-11-11 18:08:33',2,'2024-11-11 18:28:17'),(16,3,11,'Nerini','2024-11-11 17:55:05','2024-11-11 18:15:44',3,'2024-11-11 18:35:52'),(17,3,12,'Celestini','2024-11-11 18:10:25','2024-11-11 18:15:11',4,'2024-11-11 18:37:13'),(18,3,13,'Giallissimi','2024-11-11 18:15:41','2024-11-11 18:20:31',2,'2024-11-11 18:32:58'),(19,3,14,'Marroncini','2024-11-11 18:20:55','2024-11-11 18:35:20',3,'2024-11-11 18:55:44'),(20,3,15,'Marroni','2024-11-11 18:25:03','2024-11-11 18:30:40',4,'2024-11-11 18:50:08'),(21,3,16,'Rossetti','2024-11-11 18:30:45','2024-11-11 18:35:40',2,'2024-11-11 18:55:54'),(22,3,17,'Luca','2024-11-11 18:40:38','2024-11-11 18:45:34',3,'2024-11-11 19:05:09'),(23,3,18,'Mario','2024-11-11 18:45:45','2024-11-11 18:50:58',4,'2024-11-11 19:05:29'),(24,3,19,'Andrea','2024-11-11 18:55:54','2024-11-11 19:00:29',2,'2024-11-11 19:20:58'),(25,3,20,'Francesco','2024-11-11 19:05:08','2024-11-11 19:10:24',3,'2024-11-11 19:35:05'),(26,4,1,'Fabio','2024-11-11 17:25:33','2024-11-11 17:32:24',2,'2024-11-11 17:42:27'),(27,4,2,'Luca','2024-11-11 17:26:31','2024-11-11 17:32:45',3,'2024-11-11 17:50:39'),(28,4,3,'Tommaso','2024-11-11 17:26:38','2024-11-11 17:32:24',2,'2024-11-11 17:50:27'),(29,4,4,'Andrea','2024-11-11 17:26:45','2024-11-11 17:33:00',4,'2024-11-11 17:53:14'),(30,4,5,'Chiara','2024-11-11 17:26:56','2024-11-11 17:32:24',2,'2024-11-11 17:55:27'),(31,4,6,'Giuseppe','2024-11-11 17:27:03','2024-11-11 17:32:24',2,'2024-11-11 18:05:27'),(32,4,7,'Mario','2024-11-11 17:27:18','2024-11-11 17:32:45',3,'2024-11-11 18:05:39'),(33,4,8,'Sonia','2024-11-11 17:27:25','2024-11-11 17:32:24',2,'2024-11-11 18:00:27'),(34,4,9,'Maria','2024-11-11 17:27:31','2024-11-11 17:33:00',4,'2024-11-11 18:00:14'),(35,4,10,'Samuele','2024-11-11 17:27:41','2024-11-11 17:32:45',3,'2024-11-11 18:10:39'),(36,4,11,'Serena','2024-11-11 17:27:50','2024-11-11 17:32:24',2,NULL),(37,4,12,'Piero','2024-11-11 17:27:57','2024-11-11 17:33:00',4,'2024-11-11 18:10:14'),(38,4,13,'Rossi','2024-11-11 17:28:05','2024-11-11 17:32:24',2,NULL),(39,4,14,'Andrea','2024-11-11 17:28:15','2024-11-11 17:32:24',2,NULL),(40,4,15,'Matteo','2024-11-11 17:28:29','2024-11-11 17:32:45',3,NULL),(41,4,16,'Michele','2024-11-11 17:31:28','2024-11-11 17:32:45',3,NULL),(42,4,17,'Lorenzo','2024-11-11 17:31:34','2024-11-11 17:32:24',2,NULL),(43,4,18,'Alessio','2024-11-11 17:31:40','2024-11-11 17:33:00',4,'2024-11-11 18:15:14'),(44,4,19,'Mattia','2024-11-11 17:31:46','2024-11-11 17:33:00',4,'2024-11-11 18:20:14');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parties`
--

DROP TABLE IF EXISTS `parties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `ended` tinyint(1) NOT NULL DEFAULT '0',
  `waiters_code` varchar(8) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parties`
--

LOCK TABLES `parties` WRITE;
/*!40000 ALTER TABLE `parties` DISABLE KEYS */;
INSERT INTO `parties` VALUES (3,1,'Sagra del Coniglio Fritto 2023',1,'T0UIGHD5','2024-11-11 17:07:39'),(4,1,'Sagra del Coniglio Fritto 2024',0,'SVNYF5KJ','2024-11-11 17:11:56');
/*!40000 ALTER TABLE `parties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` enum('admin','waiter') NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `party_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin1@gmail.com','$2y$10$.LUFJe9iT0hgorC/XkVs0OmpAFP23mkj4abgCkYBvUot/PLyboVt2',NULL),(2,'waiter','cameriere1@gmail.com','$2y$10$x8tba1YhF2H7Uw8Ykzyjje8ebpjxm1.MLhMcaAZUQyol5pZUOykPi',4),(3,'waiter','cameriere2@gmail.com','$2y$10$0W9qjbNODb5UbTerpcpmXeUulwApHa7KgOzCXADYDMiaQmryiMhh2',4),(4,'waiter','cameriere3@gmail.com','$2y$10$PC2WNf1nPkG8IG9QDtB9C./sGQYa5TAMLJq1hYd2mXEoqAiwYsTrC',4);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-14 18:21:24
