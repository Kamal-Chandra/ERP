-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: college
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `dob` date NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `email_2` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Arjun','Mehta','arjun@gmail.com','1985-05-15'),(2,'Deepika','Patel','deepika@gmail.com','1990-08-20'),(3,'Rahul','Singh','rahul@gmail.com','1988-12-25'),(4,'Neha','Chopra','neha@gmail.com','1995-03-30'),(5,'Ravi','Sharma','ravi123@gmail.com','1990-04-10');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_admin_insert_login` AFTER INSERT ON `admin` FOR EACH ROW BEGIN
    DECLARE generated_username VARCHAR(100);
    DECLARE generated_password VARCHAR(100);

    
    SET generated_username = NEW.email;

    
    SET generated_password = CONCAT(NEW.firstName, '@', DATE_FORMAT(NEW.dob, '%d%m%Y'));

    
    INSERT INTO admin_login (admin_id, username, password)
    VALUES (NEW.admin_id, generated_username, generated_password);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `admin_login`
--

DROP TABLE IF EXISTS `admin_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_login` (
  `admin_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_login`
--

LOCK TABLES `admin_login` WRITE;
/*!40000 ALTER TABLE `admin_login` DISABLE KEYS */;
INSERT INTO `admin_login` VALUES (1,'arjun@gmail.com','Arjun@15051985'),(2,'deepika@gmail.com','Deepika@20081990'),(3,'rahul@gmail.com','Rahul@25121988'),(4,'neha@gmail.com','Neha@30031995'),(5,'ravi123@gmail.com','Ravi@10041990');
/*!40000 ALTER TABLE `admin_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `isbn` varchar(13) NOT NULL,
  `total_copies` int NOT NULL,
  `copies_available` int NOT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `isbn` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `department` varchar(3) DEFAULT NULL,
  `instructor` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `instructor` (`instructor`),
  KEY `fk_course_department` (`department`),
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`department`) REFERENCES `department` (`code`) ON DELETE CASCADE,
  CONSTRAINT `course_ibfk_2` FOREIGN KEY (`instructor`) REFERENCES `instructor` (`id`),
  CONSTRAINT `fk_course_department` FOREIGN KEY (`department`) REFERENCES `department` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (301,'Data Structures','CSE',101),(302,'Digital Electronics','ECE',102),(303,'AI in IoT','ECI',108),(304,'Algorithms','CSE',104),(305,'Database Management Systems','CSE',101),(306,'Artificial Intelligence Basics','CSA',105),(307,'Data Mining','CSD',106),(308,'Game Design Fundamentals','CSH',107),(309,'IoT Protocols','ECI',108),(310,'Communication Systems','ECE',109),(311,'Machine Learning','CSA',110),(312,'Advanced AI Techniques','CSA',111),(313,'Data Visualization','CSD',112),(314,'Statistical Learning','CSD',113),(315,'Operating Systems','CSE',114),(316,'Compiler Design','CSE',115),(317,'Human-Computer Interaction','CSH',116),(318,'Virtual Reality','CSH',117),(319,'Embedded Systems','ECI',118),(320,'Wireless Sensor Networks','ECI',119),(321,'VLSI Design','ECE',120),(322,'Digital Signal Processing','ECE',121),(323,'Natural Language Processing','CSA',105),(324,'Advanced Machine Learning','CSA',122),(325,'Big Data Analytics','CSD',106),(326,'Data Wrangling','CSD',123),(327,'Advanced Operating Systems','CSE',101),(328,'Computer Networks','CSE',124),(329,'Distributed Systems','CSE',115),(330,'Compiler Construction','CSE',104),(331,'Augmented Reality','CSH',125),(332,'3D Modeling','CSH',117),(333,'Game Programming','CSH',116),(334,'IoT and Smart Cities','ECI',108),(335,'IoT for Healthcare','ECI',103),(336,'Sensor Networks','ECI',118),(337,'Analog Circuits','ECE',102),(338,'Digital Circuits','ECE',120),(339,'Control Systems','ECE',121),(340,'Computer Vision','CSA',111),(341,'Reinforcement Learning','CSA',110),(342,'Deep Learning','CSA',105),(343,'Bioinformatics','CSD',112),(344,'Data Ethics','CSD',113),(345,'Cloud Computing','CSD',106),(346,'Mobile App Development','CSE',114),(347,'Cyber Security','CSE',101),(348,'Blockchain Technology','CSE',115),(349,'HCI in Virtual Environments','CSH',107),(350,'Digital Image Processing','ECE',102);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `code` varchar(3) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES ('CSA','Artificial Intelligence'),('CSD','Data Science'),('CSE','Computer Science and Engineering'),('CSH','Human Computer Interaction and Gaming Technology'),('ECE','Electronics and Communication Engineering'),('ECI','Internet of Things');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollment`
--

DROP TABLE IF EXISTS `enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollment` (
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  `marks` int DEFAULT NULL,
  PRIMARY KEY (`student_id`,`course_id`),
  KEY `enrollment_ibfk_2` (`course_id`),
  CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
  CONSTRAINT `enrollment_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_marks` CHECK (((`marks` >= 0) and (`marks` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollment`
--

LOCK TABLES `enrollment` WRITE;
/*!40000 ALTER TABLE `enrollment` DISABLE KEYS */;
INSERT INTO `enrollment` VALUES (101,301,NULL),(101,302,NULL),(102,301,NULL),(102,302,NULL),(103,301,NULL),(103,302,NULL),(104,301,NULL),(104,302,NULL),(105,301,NULL),(105,302,NULL),(106,301,NULL),(106,302,NULL),(107,301,NULL),(107,302,NULL),(108,301,NULL),(108,302,NULL),(109,301,NULL),(109,302,NULL),(110,301,NULL),(110,302,NULL),(111,301,NULL),(111,302,NULL),(112,301,NULL),(112,302,NULL),(113,301,NULL),(113,302,NULL),(114,301,NULL),(114,302,NULL),(115,301,NULL),(115,302,NULL),(116,301,NULL),(116,302,NULL),(117,301,NULL),(117,302,NULL),(118,301,NULL),(118,302,NULL),(119,301,NULL),(119,302,NULL),(120,301,NULL),(120,302,NULL),(121,301,NULL),(121,302,NULL),(122,301,NULL),(122,302,NULL),(123,301,NULL),(123,302,NULL),(124,301,NULL),(124,302,NULL),(125,301,NULL),(125,302,NULL),(126,301,NULL),(126,302,NULL),(127,301,NULL),(127,302,NULL),(128,301,NULL),(128,302,NULL),(129,301,NULL),(129,302,NULL),(130,301,NULL),(130,302,NULL),(201,301,NULL),(201,302,NULL),(202,301,NULL),(202,302,NULL),(203,301,NULL),(203,302,NULL),(204,301,NULL),(204,302,NULL),(205,301,NULL),(205,302,NULL),(206,301,NULL),(206,302,NULL),(207,301,NULL),(207,302,NULL),(208,301,NULL),(208,302,NULL),(209,301,NULL),(209,302,NULL),(210,301,NULL),(210,302,NULL),(211,301,NULL),(211,302,NULL),(212,301,NULL),(212,302,NULL),(213,301,NULL),(213,302,NULL),(214,301,NULL),(214,302,NULL),(215,301,NULL),(215,302,NULL),(216,301,NULL),(216,302,NULL),(217,301,NULL),(217,302,NULL),(218,301,NULL),(218,302,NULL),(219,301,NULL),(219,302,NULL),(220,301,NULL),(220,302,NULL),(221,301,NULL),(221,302,NULL),(222,301,NULL),(222,302,NULL),(223,301,NULL),(223,302,NULL),(224,301,NULL),(224,302,NULL),(225,301,NULL),(225,302,NULL),(226,301,NULL),(226,302,NULL),(227,301,NULL),(227,302,NULL),(228,301,NULL),(228,302,NULL),(229,301,NULL),(229,302,NULL),(230,301,NULL),(230,302,NULL),(301,301,NULL),(301,302,NULL),(302,301,NULL),(302,302,NULL),(303,301,NULL),(303,302,NULL),(304,301,NULL),(304,302,NULL),(305,301,NULL),(305,302,NULL),(306,301,NULL),(306,302,NULL),(307,301,NULL),(307,302,NULL),(308,301,NULL),(308,302,NULL),(309,301,NULL),(309,302,NULL),(310,301,NULL),(310,302,NULL),(311,301,NULL),(311,302,NULL),(312,301,NULL),(312,302,NULL),(313,301,NULL),(313,302,NULL),(314,301,NULL),(314,302,NULL),(315,301,NULL),(315,302,NULL),(316,301,NULL),(316,302,NULL),(317,301,NULL),(317,302,NULL),(318,301,NULL),(318,302,NULL),(319,301,NULL),(319,302,NULL),(320,301,NULL),(320,302,NULL),(321,301,NULL),(321,302,NULL),(322,301,NULL),(322,302,NULL),(323,301,NULL),(323,302,NULL),(324,301,NULL),(324,302,NULL),(325,301,NULL),(325,302,NULL),(326,301,NULL),(326,302,NULL),(327,301,NULL),(327,302,NULL),(328,301,NULL),(328,302,NULL),(329,301,NULL),(329,302,NULL),(330,301,NULL),(330,302,NULL),(401,301,NULL),(401,302,NULL),(402,301,NULL),(402,302,NULL),(403,301,NULL),(403,302,NULL),(404,301,NULL),(404,302,NULL),(405,301,NULL),(405,302,NULL),(406,301,NULL),(406,302,NULL),(407,301,NULL),(407,302,NULL),(408,301,NULL),(408,302,NULL),(409,301,NULL),(409,302,NULL),(410,301,NULL),(410,302,NULL),(411,301,NULL),(411,302,NULL),(412,301,NULL),(412,302,NULL),(413,301,NULL),(413,302,NULL),(414,301,NULL),(414,302,NULL),(415,301,NULL),(415,302,NULL),(416,301,NULL),(416,302,NULL),(417,301,NULL),(417,302,NULL),(418,301,NULL),(418,302,NULL),(419,301,NULL),(419,302,NULL),(420,301,NULL),(420,302,NULL),(421,301,NULL),(421,302,NULL),(422,301,NULL),(422,302,NULL),(423,301,NULL),(423,302,NULL),(424,301,NULL),(424,302,NULL),(425,301,NULL),(425,302,NULL),(426,301,NULL),(426,302,NULL),(427,301,NULL),(427,302,NULL),(428,301,NULL),(428,302,NULL),(429,301,NULL),(429,302,NULL),(430,301,NULL),(430,302,NULL),(501,301,NULL),(501,302,NULL),(502,301,NULL),(502,302,NULL),(503,301,NULL),(503,302,NULL),(504,301,NULL),(504,302,NULL),(505,301,NULL),(505,302,NULL),(506,301,NULL),(506,302,NULL),(507,301,NULL),(507,302,NULL),(508,301,NULL),(508,302,NULL),(509,301,NULL),(509,302,NULL),(510,301,NULL),(510,302,NULL),(511,301,NULL),(511,302,NULL),(512,301,NULL),(512,302,NULL),(513,301,NULL),(513,302,NULL),(514,301,NULL),(514,302,NULL),(515,301,NULL),(515,302,NULL),(516,301,NULL),(516,302,NULL),(517,301,NULL),(517,302,NULL),(518,301,NULL),(518,302,NULL),(519,301,NULL),(519,302,NULL),(520,301,NULL),(520,302,NULL),(521,301,NULL),(521,302,NULL),(522,301,NULL),(522,302,NULL),(523,301,NULL),(523,302,NULL),(524,301,NULL),(524,302,NULL),(525,301,NULL),(525,302,NULL),(526,301,NULL),(526,302,NULL),(527,301,NULL),(527,302,NULL),(528,301,NULL),(528,302,NULL),(529,301,NULL),(529,302,NULL),(530,301,NULL),(530,302,NULL),(601,301,NULL),(601,302,NULL),(602,301,NULL),(602,302,NULL),(603,301,NULL),(603,302,NULL),(604,301,NULL),(604,302,NULL),(605,301,NULL),(605,302,NULL),(606,301,NULL),(606,302,NULL),(607,301,NULL),(607,302,NULL),(608,301,NULL),(608,302,NULL),(609,301,NULL),(609,302,NULL),(610,301,NULL),(610,302,NULL),(611,301,NULL),(611,302,NULL),(612,301,NULL),(612,302,NULL),(613,301,NULL),(613,302,NULL),(614,301,NULL),(614,302,NULL),(615,301,NULL),(615,302,NULL),(616,301,NULL),(616,302,NULL),(617,301,NULL),(617,302,NULL),(618,301,NULL),(618,302,NULL),(619,301,NULL),(619,302,NULL),(620,301,NULL),(620,302,NULL),(621,301,NULL),(621,302,NULL),(622,301,NULL),(622,302,NULL),(623,301,NULL),(623,302,NULL),(624,301,NULL),(624,302,NULL),(625,301,NULL),(625,302,NULL),(626,301,NULL),(626,302,NULL),(627,301,NULL),(627,302,NULL),(628,301,NULL),(628,302,NULL),(629,301,NULL),(629,302,NULL),(630,301,NULL),(630,302,NULL);
/*!40000 ALTER TABLE `enrollment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_schedule`
--

DROP TABLE IF EXISTS `exam_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_schedule` (
  `course_id` int NOT NULL,
  `exam_date` date DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  CONSTRAINT `exam_schedule_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_schedule`
--

LOCK TABLES `exam_schedule` WRITE;
/*!40000 ALTER TABLE `exam_schedule` DISABLE KEYS */;
INSERT INTO `exam_schedule` VALUES (301,'2024-10-05'),(302,'2024-10-07'),(304,'2024-10-11'),(305,'2024-10-13');
/*!40000 ALTER TABLE `exam_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee`
--

DROP TABLE IF EXISTS `fee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `fee_type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `due_date` date NOT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `status` enum('paid','unpaid') NOT NULL DEFAULT 'unpaid',
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `fee_ibfk_1` (`student_id`),
  CONSTRAINT `fee_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=273 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee`
--

LOCK TABLES `fee` WRITE;
/*!40000 ALTER TABLE `fee` DISABLE KEYS */;
INSERT INTO `fee` VALUES (90,101,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(91,102,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(92,103,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(93,104,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(94,105,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(95,106,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(96,107,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(97,108,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(98,109,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(99,110,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(100,111,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(101,112,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(102,113,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(103,114,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(104,115,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(105,116,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(106,117,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(107,118,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(108,119,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(109,120,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(110,121,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(111,122,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(112,123,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(113,124,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(114,125,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(115,126,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(116,127,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(117,128,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(118,129,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(119,130,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(120,201,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(121,202,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(122,203,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(123,204,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(124,205,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(125,206,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(126,207,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(127,208,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(128,209,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(129,210,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(130,211,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(131,212,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(132,213,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(133,214,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(134,215,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(135,216,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(136,217,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(137,218,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(138,219,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(139,220,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(140,221,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(141,222,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(142,223,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(143,224,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(144,225,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(145,226,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(146,227,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(147,228,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(148,229,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(149,230,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(150,301,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(151,302,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(152,303,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(153,304,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(154,305,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(155,306,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(156,307,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(157,308,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(158,309,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(159,310,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(160,311,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(161,312,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(162,313,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(163,314,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(164,315,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(165,316,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(166,317,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(167,318,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(168,319,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(169,320,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(170,321,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(171,322,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(172,323,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(173,324,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(174,325,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(175,326,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(176,327,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(177,328,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(178,329,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(179,330,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(180,401,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(181,402,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(182,403,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(183,404,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(184,405,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(185,406,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(186,407,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(187,408,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(188,409,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(189,410,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(190,411,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(191,412,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(192,413,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(193,414,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(194,415,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(195,416,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(196,417,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(197,418,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(198,419,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(199,420,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(200,421,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(201,422,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(202,423,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(203,424,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(204,425,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(205,426,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(206,427,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(207,428,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(208,429,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(209,430,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(210,501,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(211,502,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(212,503,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(213,504,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(214,505,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(215,506,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(216,507,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(217,508,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(218,509,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(219,510,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(220,511,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(221,512,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(222,513,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(223,514,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(224,515,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(225,516,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(226,517,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(227,518,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(228,519,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(229,520,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(230,521,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(231,522,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(232,523,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(233,524,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(234,525,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(235,526,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(236,527,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(237,528,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(238,529,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(239,530,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(240,601,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(241,602,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(242,603,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(243,604,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(244,605,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(245,606,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(246,607,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(247,608,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(248,609,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(249,610,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(250,611,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(251,612,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(252,613,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(253,614,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(254,615,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(255,616,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(256,617,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(257,618,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(258,619,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(259,620,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(260,621,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(261,622,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(262,623,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(263,624,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(264,625,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(265,626,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(266,627,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(267,628,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(268,629,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(269,630,'Admission Fee',100000.00,'2024-11-26',NULL,'unpaid'),(270,101,'Hostel Fee',50000.00,'2024-11-26',NULL,'unpaid'),(271,102,'Hostel Fee',50000.00,'2024-11-26',NULL,'unpaid'),(272,103,'Hostel Fee',50000.00,'2024-11-26',NULL,'unpaid');
/*!40000 ALTER TABLE `fee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `giver_type` enum('student','faculty') NOT NULL,
  `giver_id` int NOT NULL,
  `subject` varchar(100) NOT NULL,
  `status` enum('resolved','unresolved') DEFAULT 'unresolved',
  `date_posted` date NOT NULL,
  `feedback_text` text NOT NULL,
  PRIMARY KEY (`feedback_id`),
  KEY `giver_id` (`giver_id`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`giver_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`giver_id`) REFERENCES `instructor` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hostel`
--

DROP TABLE IF EXISTS `hostel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hostel` (
  `student_id` int NOT NULL,
  `allocation_status` enum('not allocated','allocated') DEFAULT 'not allocated',
  `room_number` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  CONSTRAINT `hostel_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostel`
--

LOCK TABLES `hostel` WRITE;
/*!40000 ALTER TABLE `hostel` DISABLE KEYS */;
INSERT INTO `hostel` VALUES (101,'allocated','601'),(102,'allocated','601'),(103,'allocated','602'),(104,'not allocated',NULL),(105,'not allocated',NULL),(106,'not allocated',NULL),(107,'not allocated',NULL),(108,'not allocated',NULL),(109,'not allocated',NULL),(110,'not allocated',NULL),(111,'not allocated',NULL),(112,'not allocated',NULL),(113,'not allocated',NULL),(114,'not allocated',NULL),(115,'not allocated',NULL),(116,'not allocated',NULL),(117,'not allocated',NULL),(118,'not allocated',NULL),(119,'not allocated',NULL),(120,'not allocated',NULL),(121,'not allocated',NULL),(122,'not allocated',NULL),(123,'not allocated',NULL),(124,'not allocated',NULL),(125,'not allocated',NULL),(126,'not allocated',NULL),(127,'not allocated',NULL),(128,'not allocated',NULL),(129,'not allocated',NULL),(130,'not allocated',NULL),(201,'not allocated',NULL),(202,'not allocated',NULL),(203,'not allocated',NULL),(204,'not allocated',NULL),(205,'not allocated',NULL),(206,'not allocated',NULL),(207,'not allocated',NULL),(208,'not allocated',NULL),(209,'not allocated',NULL),(210,'not allocated',NULL),(211,'not allocated',NULL),(212,'not allocated',NULL),(213,'not allocated',NULL),(214,'not allocated',NULL),(215,'not allocated',NULL),(216,'not allocated',NULL),(217,'not allocated',NULL),(218,'not allocated',NULL),(219,'not allocated',NULL),(220,'not allocated',NULL),(221,'not allocated',NULL),(222,'not allocated',NULL),(223,'not allocated',NULL),(224,'not allocated',NULL),(225,'not allocated',NULL),(226,'not allocated',NULL),(227,'not allocated',NULL),(228,'not allocated',NULL),(229,'not allocated',NULL),(230,'not allocated',NULL),(301,'not allocated',NULL),(302,'not allocated',NULL),(303,'not allocated',NULL),(304,'not allocated',NULL),(305,'not allocated',NULL),(306,'not allocated',NULL),(307,'not allocated',NULL),(308,'not allocated',NULL),(309,'not allocated',NULL),(310,'not allocated',NULL),(311,'not allocated',NULL),(312,'not allocated',NULL),(313,'not allocated',NULL),(314,'not allocated',NULL),(315,'not allocated',NULL),(316,'not allocated',NULL),(317,'not allocated',NULL),(318,'not allocated',NULL),(319,'not allocated',NULL),(320,'not allocated',NULL),(321,'not allocated',NULL),(322,'not allocated',NULL),(323,'not allocated',NULL),(324,'not allocated',NULL),(325,'not allocated',NULL),(326,'not allocated',NULL),(327,'not allocated',NULL),(328,'not allocated',NULL),(329,'not allocated',NULL),(330,'not allocated',NULL),(401,'not allocated',NULL),(402,'not allocated',NULL),(403,'not allocated',NULL),(404,'not allocated',NULL),(405,'not allocated',NULL),(406,'not allocated',NULL),(407,'not allocated',NULL),(408,'not allocated',NULL),(409,'not allocated',NULL),(410,'not allocated',NULL),(411,'not allocated',NULL),(412,'not allocated',NULL),(413,'not allocated',NULL),(414,'not allocated',NULL),(415,'not allocated',NULL),(416,'not allocated',NULL),(417,'not allocated',NULL),(418,'not allocated',NULL),(419,'not allocated',NULL),(420,'not allocated',NULL),(421,'not allocated',NULL),(422,'not allocated',NULL),(423,'not allocated',NULL),(424,'not allocated',NULL),(425,'not allocated',NULL),(426,'not allocated',NULL),(427,'not allocated',NULL),(428,'not allocated',NULL),(429,'not allocated',NULL),(430,'not allocated',NULL),(501,'not allocated',NULL),(502,'not allocated',NULL),(503,'not allocated',NULL),(504,'not allocated',NULL),(505,'not allocated',NULL),(506,'not allocated',NULL),(507,'not allocated',NULL),(508,'not allocated',NULL),(509,'not allocated',NULL),(510,'not allocated',NULL),(511,'not allocated',NULL),(512,'not allocated',NULL),(513,'not allocated',NULL),(514,'not allocated',NULL),(515,'not allocated',NULL),(516,'not allocated',NULL),(517,'not allocated',NULL),(518,'not allocated',NULL),(519,'not allocated',NULL),(520,'not allocated',NULL),(521,'not allocated',NULL),(522,'not allocated',NULL),(523,'not allocated',NULL),(524,'not allocated',NULL),(525,'not allocated',NULL),(526,'not allocated',NULL),(527,'not allocated',NULL),(528,'not allocated',NULL),(529,'not allocated',NULL),(530,'not allocated',NULL),(601,'not allocated',NULL),(602,'not allocated',NULL),(603,'not allocated',NULL),(604,'not allocated',NULL),(605,'not allocated',NULL),(606,'not allocated',NULL),(607,'not allocated',NULL),(608,'not allocated',NULL),(609,'not allocated',NULL),(610,'not allocated',NULL),(611,'not allocated',NULL),(612,'not allocated',NULL),(613,'not allocated',NULL),(614,'not allocated',NULL),(615,'not allocated',NULL),(616,'not allocated',NULL),(617,'not allocated',NULL),(618,'not allocated',NULL),(619,'not allocated',NULL),(620,'not allocated',NULL),(621,'not allocated',NULL),(622,'not allocated',NULL),(623,'not allocated',NULL),(624,'not allocated',NULL),(625,'not allocated',NULL),(626,'not allocated',NULL),(627,'not allocated',NULL),(628,'not allocated',NULL),(629,'not allocated',NULL),(630,'not allocated',NULL);
/*!40000 ALTER TABLE `hostel` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_hostel` BEFORE INSERT ON `hostel` FOR EACH ROW BEGIN
    DECLARE room_count INT;

    
    SELECT COUNT(*) INTO room_count
    FROM hostel
    WHERE room_number = NEW.room_number;

    
    IF room_count >= 2 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Room allocation failed: Room is already full';
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
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_hostel_allocation` AFTER UPDATE ON `hostel` FOR EACH ROW BEGIN
    IF NEW.allocation_status = 'allocated' AND OLD.allocation_status != 'allocated' THEN
        
        INSERT INTO fee (student_id, fee_type, amount, due_date, status)
        VALUES (NEW.student_id, 'Hostel Fee', 50000.00, DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'unpaid'); 
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `instructor`
--

DROP TABLE IF EXISTS `instructor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructor` (
  `id` int NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `department` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_instructor_department` (`department`),
  CONSTRAINT `fk_instructor_department` FOREIGN KEY (`department`) REFERENCES `department` (`code`),
  CONSTRAINT `instructor_ibfk_1` FOREIGN KEY (`department`) REFERENCES `department` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructor`
--

LOCK TABLES `instructor` WRITE;
/*!40000 ALTER TABLE `instructor` DISABLE KEYS */;
INSERT INTO `instructor` VALUES (101,'Anil','Kumar','CSE'),(102,'Priya','Sharma','ECE'),(103,'Sunita','Deshmukh','ECI'),(104,'Deepa','Singh','CSE'),(105,'Raj','Verma','CSA'),(106,'Sneha','Menon','CSD'),(107,'Pooja','Nair','CSH'),(108,'Ravi','Reddy','ECI'),(109,'Sanjay','Kumar','ECE'),(110,'Amit','Patel','CSA'),(111,'Meera','Iyer','CSA'),(112,'Vikram','Joshi','CSD'),(113,'Kiran','Shetty','CSD'),(114,'Ramesh','Chawla','CSE'),(115,'Anita','Garg','CSE'),(116,'Vasudha','Bhatt','CSH'),(117,'Tarun','Malik','CSH'),(118,'Rekha','Pandey','ECI'),(119,'Siddharth','Nanda','ECI'),(120,'Naveen','Mehra','ECE'),(121,'Gauri','Sharma','ECE'),(122,'Mohit','Kapoor','CSA'),(123,'Neha','Singh','CSD'),(124,'Aarti','Chopra','CSE'),(125,'Varun','Bose','CSH');
/*!40000 ALTER TABLE `instructor` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_instructor_insert` AFTER INSERT ON `instructor` FOR EACH ROW BEGIN
    DECLARE generated_username VARCHAR(100);
    DECLARE generated_password VARCHAR(100);

    
    SET generated_username = CONCAT(LOWER(NEW.firstName), '_', LOWER(NEW.lastName));
    SET generated_password = CONCAT(LOWER(NEW.firstName), '@', NEW.id);

    
    INSERT INTO instructor_login (instructor_id, username, password)
    VALUES (NEW.id, generated_username, generated_password);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `instructor_login`
--

DROP TABLE IF EXISTS `instructor_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructor_login` (
  `instructor_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`instructor_id`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `instructor_login_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `instructor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructor_login`
--

LOCK TABLES `instructor_login` WRITE;
/*!40000 ALTER TABLE `instructor_login` DISABLE KEYS */;
INSERT INTO `instructor_login` VALUES (101,'anil.kumar_101','anil@101'),(102,'priya.sharma_102','priya@102'),(103,'sunita.deshmukh_103','sunita@103'),(104,'deepa.singh_104','deepa@104'),(105,'raj.verma_105','raj@105'),(106,'sneha.menon_106','sneha@106'),(107,'pooja.nair_107','pooja@107'),(108,'ravi.reddy_108','ravi@108'),(109,'sanjay.kumar_109','sanjay@109'),(110,'amit.patel_110','amit@110'),(111,'meera.iyer_111','meera@111'),(112,'vikram.joshi_112','vikram@112'),(113,'kiran.shetty_113','kiran@113'),(114,'ramesh.chawla_114','ramesh@114'),(115,'anita.garg_115','anita@115'),(116,'vasudha.bhatt_116','vasudha@116'),(117,'tarun.malik_117','tarun@117'),(118,'rekha.pandey_118','rekha@118'),(119,'siddharth.nanda_119','siddharth@119'),(120,'naveen.mehra_120','naveen@120'),(121,'gauri.sharma_121','gauri@121'),(122,'mohit.kapoor_122','mohit@122'),(123,'neha.singh_123','neha@123'),(124,'aarti.chopra_124','aarti@124'),(125,'varun.bose_125','varun@125');
/*!40000 ALTER TABLE `instructor_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issued_books`
--

DROP TABLE IF EXISTS `issued_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issued_books` (
  `issue_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `issuer_type` enum('student','faculty') NOT NULL,
  `issuer_id` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_return` date DEFAULT NULL,
  PRIMARY KEY (`issue_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `issued_books_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_return_after_issue` CHECK (((`date_of_return` is null) or (`date_of_return` > `date_of_issue`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issued_books`
--

LOCK TABLES `issued_books` WRITE;
/*!40000 ALTER TABLE `issued_books` DISABLE KEYS */;
/*!40000 ALTER TABLE `issued_books` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `decrease_copies_on_issue` AFTER INSERT ON `issued_books` FOR EACH ROW BEGIN
    UPDATE books
    SET copies_available = copies_available - 1
    WHERE book_id = NEW.book_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `increase_copies_on_return` AFTER UPDATE ON `issued_books` FOR EACH ROW BEGIN
    IF NEW.date_of_return IS NOT NULL AND OLD.date_of_return IS NULL THEN
        UPDATE books
        SET copies_available = copies_available + 1
        WHERE book_id = NEW.book_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `id` int NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `department_code` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_student_department` (`department_code`),
  CONSTRAINT `fk_student_department` FOREIGN KEY (`department_code`) REFERENCES `department` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (101,'Aarav','Sharma','CSE'),(102,'Vivaan','Patel','CSE'),(103,'Aditya','Verma','CSE'),(104,'Vihaan','Kumar','CSE'),(105,'Arjun','Singh','CSE'),(106,'Rohan','Gupta','CSE'),(107,'Sai','Reddy','CSE'),(108,'Karthik','Nair','CSE'),(109,'Shivansh','Mehta','CSE'),(110,'Ayaan','Khan','CSE'),(111,'Krishna','Sahu','CSE'),(112,'Tanmay','Bansal','CSE'),(113,'Manan','Jain','CSE'),(114,'Shreyas','Dixit','CSE'),(115,'Siddharth','Rastogi','CSE'),(116,'Kunal','Chopra','CSE'),(117,'Nikhil','Ghosh','CSE'),(118,'Advik','Kapoor','CSE'),(119,'Pranav','Singh','CSE'),(120,'Raj','Yadav','CSE'),(121,'Karan','Malhotra','CSE'),(122,'Aniket','Bhardwaj','CSE'),(123,'Harsh','Agarwal','CSE'),(124,'Dev','Nair','CSE'),(125,'Rishabh','Nanda','CSE'),(126,'Ishaan','Jha','CSE'),(127,'Yash','Kumar','CSE'),(128,'Vansh','Bansal','CSE'),(129,'Ritvik','Singh','CSE'),(130,'Aaditya','Shukla','CSE'),(201,'Saanvi','Patel','CSA'),(202,'Aditi','Sharma','CSA'),(203,'Pooja','Gupta','CSA'),(204,'Ananya','Kaur','CSA'),(205,'Shruti','Reddy','CSA'),(206,'Meera','Verma','CSA'),(207,'Neha','Malhotra','CSA'),(208,'Diya','Nair','CSA'),(209,'Riya','Singh','CSA'),(210,'Tanya','Kumar','CSA'),(211,'Isha','Bansal','CSA'),(212,'Vaishali','Shukla','CSA'),(213,'Kavya','Jain','CSA'),(214,'Kajal','Patel','CSA'),(215,'Aarohi','Ghosh','CSA'),(216,'Radhika','Agarwal','CSA'),(217,'Naina','Kapoor','CSA'),(218,'Saloni','Kaur','CSA'),(219,'Simran','Yadav','CSA'),(220,'Tanvi','Chopra','CSA'),(221,'Snehal','Dixit','CSA'),(222,'Niharika','Sharma','CSA'),(223,'Pallavi','Jha','CSA'),(224,'Neelam','Bhardwaj','CSA'),(225,'Aditi','Yadav','CSA'),(226,'Rashmi','Sahu','CSA'),(227,'Deepika','Reddy','CSA'),(228,'Ritika','Malhotra','CSA'),(229,'Sonali','Verma','CSA'),(230,'Bhawna','Gupta','CSA'),(301,'Neel','Patel','CSD'),(302,'Aniket','Sharma','CSD'),(303,'Gaurav','Kumar','CSD'),(304,'Karan','Soni','CSD'),(305,'Ritika','Mehta','CSD'),(306,'Akshay','Gupta','CSD'),(307,'Vikrant','Singh','CSD'),(308,'Sneha','Verma','CSD'),(309,'Shivam','Chopra','CSD'),(310,'Rishabh','Bansal','CSD'),(311,'Nitin','Sahu','CSD'),(312,'Kriti','Agarwal','CSD'),(313,'Tanvi','Kaur','CSD'),(314,'Vansh','Nair','CSD'),(315,'Deepa','Jain','CSD'),(316,'Shivangi','Malhotra','CSD'),(317,'Harsh','Ghosh','CSD'),(318,'Rupal','Kumar','CSD'),(319,'Nisha','Mehta','CSD'),(320,'Ajay','Patel','CSD'),(321,'Kiran','Shukla','CSD'),(322,'Krishna','Reddy','CSD'),(323,'Geetanjali','Nanda','CSD'),(324,'Ajit','Yadav','CSD'),(325,'Sonu','Malhotra','CSD'),(326,'Manisha','Sharma','CSD'),(327,'Samir','Kapoor','CSD'),(328,'Rhea','Gupta','CSD'),(329,'Pankaj','Bansal','CSD'),(330,'Kajal','Singh','CSD'),(401,'Shreya','Kumar','CSH'),(402,'Parul','Gupta','CSH'),(403,'Dev','Mehta','CSH'),(404,'Arnav','Sharma','CSH'),(405,'Neha','Kaur','CSH'),(406,'Kartik','Reddy','CSH'),(407,'Riya','Nair','CSH'),(408,'Akanksha','Sahu','CSH'),(409,'Rahul','Khan','CSH'),(410,'Aashish','Yadav','CSH'),(411,'Radhika','Patel','CSH'),(412,'Lakshmi','Agarwal','CSH'),(413,'Vivek','Singh','CSH'),(414,'Kriti','Shukla','CSH'),(415,'Siddharth','Chopra','CSH'),(416,'Sakshi','Nanda','CSH'),(417,'Aarushi','Malhotra','CSH'),(418,'Rishabh','Bhardwaj','CSH'),(419,'Gauravi','Kumar','CSH'),(420,'Vanshika','Rathi','CSH'),(421,'Sanjeev','Agarwal','CSH'),(422,'Anshika','Patel','CSH'),(423,'Arpita','Yadav','CSH'),(424,'Uday','Jha','CSH'),(425,'Niranjan','Gupta','CSH'),(426,'Megha','Rai','CSH'),(427,'Charvi','Joshi','CSH'),(428,'Ritesh','Nair','CSH'),(429,'Chandni','Kaur','CSH'),(430,'Dhruv','Malhotra','CSH'),(501,'Ajay','Verma','ECE'),(502,'Neelam','Sharma','ECE'),(503,'Rohan','Kumar','ECE'),(504,'Aditi','Iyer','ECE'),(505,'Siddharth','Patel','ECE'),(506,'Ananya','Kaur','ECE'),(507,'Karan','Singh','ECE'),(508,'Manish','Mehta','ECE'),(509,'Preeti','Ghosh','ECE'),(510,'Tanmay','Yadav','ECE'),(511,'Priya','Nanda','ECE'),(512,'Hitesh','Chopra','ECE'),(513,'Vaibhav','Soni','ECE'),(514,'Pooja','Kumar','ECE'),(515,'Ritika','Bansal','ECE'),(516,'Vikram','Jha','ECE'),(517,'Gaurav','Rai','ECE'),(518,'Neha','Malhotra','ECE'),(519,'Ramesh','Agarwal','ECE'),(520,'Anita','Sahu','ECE'),(521,'Sakshi','Gupta','ECE'),(522,'Kajal','Reddy','ECE'),(523,'Manish','Patel','ECE'),(524,'Kriti','Singh','ECE'),(525,'Tanushree','Chaudhary','ECE'),(526,'Riya','Nair','ECE'),(527,'Ajit','Sahu','ECE'),(528,'Nisha','Verma','ECE'),(529,'Dheeraj','Kaur','ECE'),(530,'Suman','Malik','ECE'),(601,'Ravi','Desai','ECI'),(602,'Shruti','Reddy','ECI'),(603,'Vishal','Bansal','ECI'),(604,'Meenal','Khan','ECI'),(605,'Tarun','Ghosh','ECI'),(606,'Bhavana','Sharma','ECI'),(607,'Sanjay','Chopra','ECI'),(608,'Komal','Sahu','ECI'),(609,'Arun','Bharadwaj','ECI'),(610,'Shweta','Rai','ECI'),(611,'Aditya','Kumar','ECI'),(612,'Niharika','Malhotra','ECI'),(613,'Ankit','Yadav','ECI'),(614,'Swati','Gupta','ECI'),(615,'Kunal','Patel','ECI'),(616,'Kavita','Kaur','ECI'),(617,'Deepak','Iyer','ECI'),(618,'Pankaj','Agarwal','ECI'),(619,'Shivani','Rai','ECI'),(620,'Ravi','Shukla','ECI'),(621,'Geeta','Sahu','ECI'),(622,'Ananya','Joshi','ECI'),(623,'Manoj','Yadav','ECI'),(624,'Mohan','Verma','ECI'),(625,'Nisha','Bansal','ECI'),(626,'Amit','Rai','ECI'),(627,'Vinod','Khan','ECI'),(628,'Karishma','Gupta','ECI'),(629,'Harish','Nanda','ECI'),(630,'Tanu','Iyer','ECI');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_student_insert` AFTER INSERT ON `student` FOR EACH ROW BEGIN
    INSERT INTO fee (student_id, fee_type, amount, due_date, status)
    VALUES (NEW.id, 'Admission Fee', 100000.00, DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'unpaid'); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_student_insert_login` AFTER INSERT ON `student` FOR EACH ROW BEGIN
    DECLARE generated_username VARCHAR(100);
    DECLARE generated_password VARCHAR(100);

    
    SET generated_username = CONCAT(LOWER(NEW.firstName), '.', LOWER(NEW.lastName), '_', NEW.id);
    SET generated_password = CONCAT(LOWER(NEW.firstName), '@', NEW.id);

    
    INSERT INTO student_login (student_id, username, password)
    VALUES (NEW.id, generated_username, generated_password);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_student_insert_hostel` AFTER INSERT ON `student` FOR EACH ROW BEGIN
    
    INSERT INTO hostel (student_id, allocation_status)
    VALUES (NEW.id, 'not_alloted'); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `student_login`
--

DROP TABLE IF EXISTS `student_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_login` (
  `student_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `student_login_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_login`
--

LOCK TABLES `student_login` WRITE;
/*!40000 ALTER TABLE `student_login` DISABLE KEYS */;
INSERT INTO `student_login` VALUES (101,'Aarav.Sharma_101','Aarav@101'),(102,'Vivaan.Patel_102','Vivaan@102'),(103,'Aditya.Verma_103','Aditya@103'),(104,'Vihaan.Kumar_104','Vihaan@104'),(105,'Arjun.Singh_105','Arjun@105'),(106,'Rohan.Gupta_106','Rohan@106'),(107,'Sai.Reddy_107','Sai@107'),(108,'Karthik.Nair_108','Karthik@108'),(109,'Shivansh.Mehta_109','Shivansh@109'),(110,'Ayaan.Khan_110','Ayaan@110'),(111,'Krishna.Sahu_111','Krishna@111'),(112,'Tanmay.Bansal_112','Tanmay@112'),(113,'Manan.Jain_113','Manan@113'),(114,'Shreyas.Dixit_114','Shreyas@114'),(115,'Siddharth.Rastogi_115','Siddharth@115'),(116,'Kunal.Chopra_116','Kunal@116'),(117,'Nikhil.Ghosh_117','Nikhil@117'),(118,'Advik.Kapoor_118','Advik@118'),(119,'Pranav.Singh_119','Pranav@119'),(120,'Raj.Yadav_120','Raj@120'),(121,'Karan.Malhotra_121','Karan@121'),(122,'Aniket.Bhardwaj_122','Aniket@122'),(123,'Harsh.Agarwal_123','Harsh@123'),(124,'Dev.Nair_124','Dev@124'),(125,'Rishabh.Nanda_125','Rishabh@125'),(126,'Ishaan.Jha_126','Ishaan@126'),(127,'Yash.Kumar_127','Yash@127'),(128,'Vansh.Bansal_128','Vansh@128'),(129,'Ritvik.Singh_129','Ritvik@129'),(130,'Aaditya.Shukla_130','Aaditya@130'),(201,'Saanvi.Patel_201','Saanvi@201'),(202,'Aditi.Sharma_202','Aditi@202'),(203,'Pooja.Gupta_203','Pooja@203'),(204,'Ananya.Kaur_204','Ananya@204'),(205,'Shruti.Reddy_205','Shruti@205'),(206,'Meera.Verma_206','Meera@206'),(207,'Neha.Malhotra_207','Neha@207'),(208,'Diya.Nair_208','Diya@208'),(209,'Riya.Singh_209','Riya@209'),(210,'Tanya.Kumar_210','Tanya@210'),(211,'Isha.Bansal_211','Isha@211'),(212,'Vaishali.Shukla_212','Vaishali@212'),(213,'Kavya.Jain_213','Kavya@213'),(214,'Kajal.Patel_214','Kajal@214'),(215,'Aarohi.Ghosh_215','Aarohi@215'),(216,'Radhika.Agarwal_216','Radhika@216'),(217,'Naina.Kapoor_217','Naina@217'),(218,'Saloni.Kaur_218','Saloni@218'),(219,'Simran.Yadav_219','Simran@219'),(220,'Tanvi.Chopra_220','Tanvi@220'),(221,'Snehal.Dixit_221','Snehal@221'),(222,'Niharika.Sharma_222','Niharika@222'),(223,'Pallavi.Jha_223','Pallavi@223'),(224,'Neelam.Bhardwaj_224','Neelam@224'),(225,'Aditi.Yadav_225','Aditi@225'),(226,'Rashmi.Sahu_226','Rashmi@226'),(227,'Deepika.Reddy_227','Deepika@227'),(228,'Ritika.Malhotra_228','Ritika@228'),(229,'Sonali.Verma_229','Sonali@229'),(230,'Bhawna.Gupta_230','Bhawna@230'),(301,'Neel.Patel_301','Neel@301'),(302,'Aniket.Sharma_302','Aniket@302'),(303,'Gaurav.Kumar_303','Gaurav@303'),(304,'Karan.Soni_304','Karan@304'),(305,'Ritika.Mehta_305','Ritika@305'),(306,'Akshay.Gupta_306','Akshay@306'),(307,'Vikrant.Singh_307','Vikrant@307'),(308,'Sneha.Verma_308','Sneha@308'),(309,'Shivam.Chopra_309','Shivam@309'),(310,'Rishabh.Bansal_310','Rishabh@310'),(311,'Nitin.Sahu_311','Nitin@311'),(312,'Kriti.Agarwal_312','Kriti@312'),(313,'Tanvi.Kaur_313','Tanvi@313'),(314,'Vansh.Nair_314','Vansh@314'),(315,'Deepa.Jain_315','Deepa@315'),(316,'Shivangi.Malhotra_316','Shivangi@316'),(317,'Harsh.Ghosh_317','Harsh@317'),(318,'Rupal.Kumar_318','Rupal@318'),(319,'Nisha.Mehta_319','Nisha@319'),(320,'Ajay.Patel_320','Ajay@320'),(321,'Kiran.Shukla_321','Kiran@321'),(322,'Krishna.Reddy_322','Krishna@322'),(323,'Geetanjali.Nanda_323','Geetanjali@323'),(324,'Ajit.Yadav_324','Ajit@324'),(325,'Sonu.Malhotra_325','Sonu@325'),(326,'Manisha.Sharma_326','Manisha@326'),(327,'Samir.Kapoor_327','Samir@327'),(328,'Rhea.Gupta_328','Rhea@328'),(329,'Pankaj.Bansal_329','Pankaj@329'),(330,'Kajal.Singh_330','Kajal@330'),(401,'Shreya.Kumar_401','Shreya@401'),(402,'Parul.Gupta_402','Parul@402'),(403,'Dev.Mehta_403','Dev@403'),(404,'Arnav.Sharma_404','Arnav@404'),(405,'Neha.Kaur_405','Neha@405'),(406,'Kartik.Reddy_406','Kartik@406'),(407,'Riya.Nair_407','Riya@407'),(408,'Akanksha.Sahu_408','Akanksha@408'),(409,'Rahul.Khan_409','Rahul@409'),(410,'Aashish.Yadav_410','Aashish@410'),(411,'Radhika.Patel_411','Radhika@411'),(412,'Lakshmi.Agarwal_412','Lakshmi@412'),(413,'Vivek.Singh_413','Vivek@413'),(414,'Kriti.Shukla_414','Kriti@414'),(415,'Siddharth.Chopra_415','Siddharth@415'),(416,'Sakshi.Nanda_416','Sakshi@416'),(417,'Aarushi.Malhotra_417','Aarushi@417'),(418,'Rishabh.Bhardwaj_418','Rishabh@418'),(419,'Gauravi.Kumar_419','Gauravi@419'),(420,'Vanshika.Rathi_420','Vanshika@420'),(421,'Sanjeev.Agarwal_421','Sanjeev@421'),(422,'Anshika.Patel_422','Anshika@422'),(423,'Arpita.Yadav_423','Arpita@423'),(424,'Uday.Jha_424','Uday@424'),(425,'Niranjan.Gupta_425','Niranjan@425'),(426,'Megha.Rai_426','Megha@426'),(427,'Charvi.Joshi_427','Charvi@427'),(428,'Ritesh.Nair_428','Ritesh@428'),(429,'Chandni.Kaur_429','Chandni@429'),(430,'Dhruv.Malhotra_430','Dhruv@430'),(501,'Ajay.Verma_501','Ajay@501'),(502,'Neelam.Sharma_502','Neelam@502'),(503,'Rohan.Kumar_503','Rohan@503'),(504,'Aditi.Iyer_504','Aditi@504'),(505,'Siddharth.Patel_505','Siddharth@505'),(506,'Ananya.Kaur_506','Ananya@506'),(507,'Karan.Singh_507','Karan@507'),(508,'Manish.Mehta_508','Manish@508'),(509,'Preeti.Ghosh_509','Preeti@509'),(510,'Tanmay.Yadav_510','Tanmay@510'),(511,'Priya.Nanda_511','Priya@511'),(512,'Hitesh.Chopra_512','Hitesh@512'),(513,'Vaibhav.Soni_513','Vaibhav@513'),(514,'Pooja.Kumar_514','Pooja@514'),(515,'Ritika.Bansal_515','Ritika@515'),(516,'Vikram.Jha_516','Vikram@516'),(517,'Gaurav.Rai_517','Gaurav@517'),(518,'Neha.Malhotra_518','Neha@518'),(519,'Ramesh.Agarwal_519','Ramesh@519'),(520,'Anita.Sahu_520','Anita@520'),(521,'Sakshi.Gupta_521','Sakshi@521'),(522,'Kajal.Reddy_522','Kajal@522'),(523,'Manish.Patel_523','Manish@523'),(524,'Kriti.Singh_524','Kriti@524'),(525,'Tanushree.Chaudhary_525','Tanushree@525'),(526,'Riya.Nair_526','Riya@526'),(527,'Ajit.Sahu_527','Ajit@527'),(528,'Nisha.Verma_528','Nisha@528'),(529,'Dheeraj.Kaur_529','Dheeraj@529'),(530,'Suman.Malik_530','Suman@530'),(601,'Ravi.Desai_601','Ravi@601'),(602,'Shruti.Reddy_602','Shruti@602'),(603,'Vishal.Bansal_603','Vishal@603'),(604,'Meenal.Khan_604','Meenal@604'),(605,'Tarun.Ghosh_605','Tarun@605'),(606,'Bhavana.Sharma_606','Bhavana@606'),(607,'Sanjay.Chopra_607','Sanjay@607'),(608,'Komal.Sahu_608','Komal@608'),(609,'Arun.Bharadwaj_609','Arun@609'),(610,'Shweta.Rai_610','Shweta@610'),(611,'Aditya.Kumar_611','Aditya@611'),(612,'Niharika.Malhotra_612','Niharika@612'),(613,'Ankit.Yadav_613','Ankit@613'),(614,'Swati.Gupta_614','Swati@614'),(615,'Kunal.Patel_615','Kunal@615'),(616,'Kavita.Kaur_616','Kavita@616'),(617,'Deepak.Iyer_617','Deepak@617'),(618,'Pankaj.Agarwal_618','Pankaj@618'),(619,'Shivani.Rai_619','Shivani@619'),(620,'Ravi.Shukla_620','Ravi@620'),(621,'Geeta.Sahu_621','Geeta@621'),(622,'Ananya.Joshi_622','Ananya@622'),(623,'Manoj.Yadav_623','Manoj@623'),(624,'Mohan.Verma_624','Mohan@624'),(625,'Nisha.Bansal_625','Nisha@625'),(626,'Amit.Rai_626','Amit@626'),(627,'Vinod.Khan_627','Vinod@627'),(628,'Karishma.Gupta_628','Karishma@628'),(629,'Harish.Nanda_629','Harish@629'),(630,'Tanu.Iyer_630','Tanu@630');
/*!40000 ALTER TABLE `student_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'college'
--

--
-- Dumping routines for database 'college'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-29 17:55:14
