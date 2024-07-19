-- Progettazione Web 
DROP DATABASE if exists socialmemory; 
CREATE DATABASE socialmemory; 
USE socialmemory; 
-- MySQL dump 10.13  Distrib 5.7.28, for Win64 (x86_64)
--
-- Host: localhost    Database: socialmemory
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
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `Username` varchar(12) NOT NULL,
  `Password` varchar(32) NOT NULL,
  `RecQuestion` char(2) NOT NULL,
  `RecAnswer` varchar(32) NOT NULL,
  `RegData` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Score` int(11) NOT NULL,
  PRIMARY KEY (`Username`),
  KEY `RecQuestion` (`RecQuestion`),
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`RecQuestion`) REFERENCES `recovery_question` (`QuestionID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES ('bowser','b','Q2','Jeep','2022-08-01 06:00:00',740),('daisy','d','Q6','Pizza','2022-06-01 06:00:00',670),('luigi','l','Q2','Panda','2022-02-01 07:00:00',1150),('mario','m','Q1','Pisa','2022-01-01 07:00:00',500),('peach','p','Q1','Livorno','2022-07-01 06:00:00',380),('toad','t','Q5','Boletus','2022-05-01 06:00:00',230),('wario','w','Q3','Peach','2022-03-01 07:00:00',15),('yoshi','y','Q4','Football','2022-04-01 06:00:00',825);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_session`
--

DROP TABLE IF EXISTS `game_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_session` (
  `User` varchar(12) NOT NULL,
  `StartTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `EndTime` timestamp NULL DEFAULT NULL,
  `PointDiff` int(11) DEFAULT NULL,
  `Helps` int(11) DEFAULT NULL,
  `Errors` int(11) DEFAULT NULL,
  PRIMARY KEY (`User`,`StartTime`),
  CONSTRAINT `game_session_ibfk_1` FOREIGN KEY (`User`) REFERENCES `account` (`Username`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_session`
--

LOCK TABLES `game_session` WRITE;
/*!40000 ALTER TABLE `game_session` DISABLE KEYS */;
INSERT INTO `game_session` VALUES ('bowser','2022-08-31 22:20:00','2022-08-31 22:25:00',14,3,18),('bowser','2022-08-31 22:40:00','2022-08-31 22:45:00',0,1,7),('bowser','2022-09-01 18:00:00','2022-09-01 08:05:00',6,1,15),('bowser','2022-09-01 18:20:00','2022-09-01 18:25:00',-16,0,17),('bowser','2022-09-01 18:30:00','2022-09-01 18:35:00',-4,2,16),('daisy','2022-07-31 22:10:00','2022-07-31 22:15:00',0,0,7),('daisy','2022-07-31 22:20:00','2022-07-31 22:25:00',-14,0,17),('daisy','2022-08-01 08:10:00','2022-08-01 08:15:00',0,0,7),('daisy','2022-08-31 22:10:00','2022-08-31 22:15:00',0,0,7),('daisy','2022-08-31 22:20:00','2022-08-31 22:25:00',-14,0,17),('daisy','2022-09-01 08:00:00','2022-09-01 08:05:00',6,1,15),('daisy','2022-09-01 08:10:00','2022-09-01 08:15:00',0,0,7),('daisy','2022-09-01 08:20:00','2022-09-01 08:25:00',16,3,18),('luigi','2022-07-31 22:00:00','2022-07-31 22:05:00',8,1,15),('luigi','2022-07-31 22:30:00','2022-07-31 22:35:00',4,1,15),('luigi','2022-08-01 08:30:00','2022-08-01 08:35:00',4,1,15),('luigi','2022-08-31 22:10:00','2022-08-31 22:15:00',0,1,7),('luigi','2022-08-31 22:30:00','2022-08-31 22:35:00',4,1,15),('mario','2022-07-31 22:00:00','2022-07-31 22:05:00',-8,2,16),('mario','2022-07-31 22:10:00','2022-07-31 22:15:00',0,1,7),('mario','2022-08-01 08:00:00','2022-08-01 08:05:00',6,1,15),('mario','2022-08-01 08:10:00','2022-08-01 08:15:00',0,1,7),('peach','2022-07-31 22:40:00','2022-07-31 22:45:00',0,1,7),('peach','2022-08-01 08:00:00','2022-08-01 08:05:00',-6,2,16),('peach','2022-08-31 22:50:00','2022-08-31 22:55:00',14,3,18),('peach','2022-09-01 08:00:00','2022-09-01 08:05:00',-6,2,16),('peach','2022-09-01 08:30:00','2022-09-01 08:35:00',4,1,15),('peach','2022-09-01 18:00:00','2022-09-01 18:05:00',-6,2,16),('peach','2022-09-01 18:30:00','2022-09-01 18:35:00',4,1,15),('toad','2022-07-31 22:20:00','2022-07-31 22:25:00',14,3,18),('toad','2022-07-31 22:50:00','2022-07-31 22:55:00',14,3,18),('toad','2022-08-01 08:20:00','2022-08-01 08:25:00',16,3,18),('toad','2022-08-31 22:00:00','2022-08-31 22:05:00',8,1,15),('toad','2022-08-31 22:40:00','2022-08-31 22:45:00',0,0,7),('toad','2022-09-01 18:10:00','2022-09-01 18:15:00',0,0,7),('toad','2022-09-01 18:20:00','2022-09-01 18:25:00',16,3,18),('wario','2022-07-31 22:30:00','2022-07-31 22:35:00',-4,2,16),('wario','2022-07-31 22:50:00','2022-07-31 22:55:00',-14,0,17),('wario','2022-08-01 08:30:00','2022-08-01 08:35:00',-4,2,16),('wario','2022-08-31 22:00:00','2022-08-31 22:05:00',-8,2,16),('wario','2022-08-31 22:30:00','2022-08-31 22:35:00',-4,2,16),('wario','2022-08-31 22:50:00','2022-08-31 22:55:00',-14,0,17),('wario','2022-09-01 08:30:00','2022-09-01 08:35:00',-4,2,16),('yoshi','2022-07-31 22:40:00','2022-07-31 22:45:00',0,0,7),('yoshi','2022-08-01 08:20:00','2022-08-01 08:25:00',-16,0,17),('yoshi','2022-09-01 08:10:00','2022-09-01 08:15:00',0,1,7),('yoshi','2022-09-01 08:20:00','2022-09-01 08:25:00',-16,0,17),('yoshi','2022-09-01 18:10:00','2022-09-01 18:15:00',0,1,7);
/*!40000 ALTER TABLE `game_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `game_session_duplicate` BEFORE INSERT ON `game_session`
FOR EACH ROW
BEGIN
    DECLARE Flag INTEGER DEFAULT 0;
    DECLARE LastStartTime INTEGER DEFAULT 0;
    
    SELECT	COUNT(*)	
    INTO	Flag
    FROM	game_session GS
    WHERE 	NEW.User = GS.User AND 
			GS.EndTime IS NULL;
    
    IF(Flag > 0)
		THEN
			DELETE	
			FROM	game_session
			WHERE 	User = NEW.User	AND
					EndTime IS NULL;
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `game_session_score_update` AFTER UPDATE ON `game_session`
FOR EACH ROW
BEGIN
    DECLARE OldScore INTEGER DEFAULT 0;
    DECLARE NewScore INTEGER DEFAULT 0;
    DECLARE GameResult INTEGER DEFAULT 0;
    
    SELECT	Score	
    INTO	OldScore
    FROM	Account A
    WHERE 	NEW.User = A.Username;
    
    IF(NEW.PointDiff > 0)
		THEN
			SET GameResult = 10 + NEW.PointDiff * 1.5 + NEW.Helps - NEW.Errors/10;
    END IF;
    
    IF(NEW.PointDiff = 0)
		THEN
			SET GameResult = 0;
    END IF;
    
    IF(NEW.PointDiff < 0)
		THEN
			SET GameResult = -10 + NEW.PointDiff * 1.5 + NEW.Helps - NEW.Errors/10;
    END IF;
    
    IF((OldScore + GameResult)>0)
		THEN
			SET NewScore = OldScore + GameResult;
    END IF;

    UPDATE	Account A
    SET		RegData = RegData, Score = NewScore
    WHERE	NEW.User = A.Username;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `login_session`
--

DROP TABLE IF EXISTS `login_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_session` (
  `DataLogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `User` varchar(12) NOT NULL,
  `DataLogout` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`DataLogin`,`User`),
  KEY `User` (`User`),
  CONSTRAINT `login_session_ibfk_1` FOREIGN KEY (`User`) REFERENCES `account` (`Username`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_session`
--

LOCK TABLES `login_session` WRITE;
/*!40000 ALTER TABLE `login_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `login_session_duplicate` BEFORE INSERT ON `login_session`
FOR EACH ROW
BEGIN
    DECLARE flag INTEGER DEFAULT 0;
    
    SELECT	COUNT(*)	
	  INTO 	flag
	  FROM	login_session LS
	  WHERE	LS.User = NEW.User		AND 
			LS.DataLogout IS NULL;
    
    IF(flag)
	  THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User already logged'; 
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `recovery_question`
--

DROP TABLE IF EXISTS `recovery_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recovery_question` (
  `QuestionID` char(2) NOT NULL,
  `QuestionBody` varchar(32) NOT NULL,
  PRIMARY KEY (`QuestionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recovery_question`
--

LOCK TABLES `recovery_question` WRITE;
/*!40000 ALTER TABLE `recovery_question` DISABLE KEYS */;
INSERT INTO `recovery_question` VALUES ('Q1','In what city were you born?'),('Q2','What was your first car?'),('Q3','Who was your first crush?'),('Q4','What\'s your favorite sport?'),('Q5','What\'s your third name?'),('Q6','What\'s your favorite food?');
/*!40000 ALTER TABLE `recovery_question` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-07 19:25:39
