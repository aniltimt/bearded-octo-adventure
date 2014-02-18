CREATE DATABASE  IF NOT EXISTS `clu_enums` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `clu_enums`;
-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: localhost    Database: clu_enums
-- ------------------------------------------------------
-- Server version	5.5.20

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
-- Table structure for table `crm_connection_types`
--

DROP TABLE IF EXISTS `crm_connection_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_connection_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_connection_types`
--

LOCK TABLES `crm_connection_types` WRITE;
/*!40000 ALTER TABLE `crm_connection_types` DISABLE KEYS */;
INSERT INTO `crm_connection_types` VALUES (1,'contact'),(2,'prospect'),(3,'lead'),(4,'client');
/*!40000 ALTER TABLE `crm_connection_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_commission_levels`
--

DROP TABLE IF EXISTS `usage_commission_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage_commission_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_commission_levels`
--

LOCK TABLES `usage_commission_levels` WRITE;
/*!40000 ALTER TABLE `usage_commission_levels` DISABLE KEYS */;
INSERT INTO `usage_commission_levels` VALUES (1,'Platinum');
/*!40000 ALTER TABLE `usage_commission_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagging_tag_rule_types`
--

DROP TABLE IF EXISTS `tagging_tag_rule_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tagging_tag_rule_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tagging_tag_rule_types`
--

LOCK TABLES `tagging_tag_rule_types` WRITE;
/*!40000 ALTER TABLE `tagging_tag_rule_types` DISABLE KEYS */;
INSERT INTO `tagging_tag_rule_types` VALUES (1,'integer'),(2,'plain text'),(3,'regex'),(4,'liquid');
/*!40000 ALTER TABLE `tagging_tag_rule_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_opennesses`
--

DROP TABLE IF EXISTS `crm_opennesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_opennesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_opennesses`
--

LOCK TABLES `crm_opennesses` WRITE;
/*!40000 ALTER TABLE `crm_opennesses` DISABLE KEYS */;
INSERT INTO `crm_opennesses` VALUES (1,'Open',NULL),(2,'Closed',NULL),(3,'Placed',NULL),(4,'Application Sent',NULL),(5,'Application Submitted',NULL),(6,'Legacy',NULL),(7,'Marketech',NULL);
/*!40000 ALTER TABLE `crm_opennesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_quoter_types`
--

DROP TABLE IF EXISTS `quoting_quoter_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_quoter_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `pinney_quoter_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_quoter_types`
--

LOCK TABLES `quoting_quoter_types` WRITE;
/*!40000 ALTER TABLE `quoting_quoter_types` DISABLE KEYS */;
INSERT INTO `quoting_quoter_types` VALUES (1,'tli','term'),(2,'neli','gbl'),(3,'spia','spia'),(4,'ltc','ltc');
/*!40000 ALTER TABLE `quoting_quoter_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `abbrev` varchar(255) DEFAULT NULL,
  `compulife_code` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `tz_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES (1,'AL',1,'Alabama',NULL),(2,'AK',2,'Alaska',NULL),(3,'AZ',3,'Arizona',NULL),(4,'AR',4,'Arkansas',NULL),(5,'CA',5,'California',NULL),(6,'CO',6,'Colorado',NULL),(7,'CT',7,'Connecticut',NULL),(8,'DE',8,'Delaware',NULL),(9,'DC',9,'District of Columbia',NULL),(10,'FL',10,'Florida',NULL),(11,'GA',11,'Georgia',NULL),(12,'HI',12,'Hawaii',NULL),(13,'ID',13,'Idaho',NULL),(14,'IL',14,'Illinois',NULL),(15,'IN',15,'Indiana',NULL),(16,'IA',16,'Iowa',NULL),(17,'KS',17,'Kansas',NULL),(18,'KY',18,'Kentucky',NULL),(19,'LA',19,'Louisiana',NULL),(20,'ME',20,'Maine',NULL),(21,'MD',21,'Maryland',NULL),(22,'MA',22,'Massachusetts',NULL),(23,'MI',23,'Michigan',NULL),(24,'MN',24,'Minnesota',NULL),(25,'MS',25,'Mississippi',NULL),(26,'MO',26,'Missouri',NULL),(27,'MT',27,'Montana',NULL),(28,'NE',28,'Nebraska',NULL),(29,'NV',29,'Nevada',NULL),(30,'NH',30,'New Hampshire',NULL),(31,'NJ',31,'New Jersey',NULL),(32,'NM',32,'New Mexico',NULL),(33,'NY-B',52,'New York (Business)',NULL),(34,'NY-NB',33,'New York (Non-Bus)',NULL),(35,'NC',34,'North Carolina',NULL),(36,'ND',35,'North Dakota',NULL),(37,'OH',36,'Ohio',NULL),(38,'OK',37,'Oklahoma',NULL),(39,'OR',38,'Oregon',NULL),(40,'PA',39,'Pennsylvania',NULL),(41,'RI',40,'Rhode Island',NULL),(42,'SC',41,'South Carolina',NULL),(43,'SD',42,'South Dakota',NULL),(44,'TN',43,'Tennessee',NULL),(45,'TX',44,'Texas',NULL),(46,'UT',45,'Utah',NULL),(47,'VT',46,'Vermont',NULL),(48,'VA',47,'Virginia',NULL),(49,'WA',48,'Washington',NULL),(50,'WV',49,'West Virginia',NULL),(51,'WI',50,'Wisconsin',NULL),(52,'WY',51,'Wyoming',NULL),(53,'GU',53,'Guam',NULL),(54,'PR',54,'Puerto Rico',NULL),(55,'VI',55,'Virgin Islands',NULL),(56,'AS',56,'American Samoa',NULL);
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagging_tag_rule_operators`
--

DROP TABLE IF EXISTS `tagging_tag_rule_operators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tagging_tag_rule_operators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tagging_tag_rule_operators`
--

LOCK TABLES `tagging_tag_rule_operators` WRITE;
/*!40000 ALTER TABLE `tagging_tag_rule_operators` DISABLE KEYS */;
INSERT INTO `tagging_tag_rule_operators` VALUES (1,'=='),(2,'!='),(3,'<'),(4,'>'),(5,'<='),(6,'>=');
/*!40000 ALTER TABLE `tagging_tag_rule_operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_activity_types`
--

DROP TABLE IF EXISTS `crm_activity_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_activity_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_activity_types`
--

LOCK TABLES `crm_activity_types` WRITE;
/*!40000 ALTER TABLE `crm_activity_types` DISABLE KEYS */;
INSERT INTO `crm_activity_types` VALUES (1,'other'),(2,'email'),(3,'phone'),(4,'phone message'),(5,'sms'),(6,'letter');
/*!40000 ALTER TABLE `crm_activity_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_types`
--

DROP TABLE IF EXISTS `phone_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_types`
--

LOCK TABLES `phone_types` WRITE;
/*!40000 ALTER TABLE `phone_types` DISABLE KEYS */;
INSERT INTO `phone_types` VALUES (1,'home'),(2,'work'),(3,'mobile');
/*!40000 ALTER TABLE `phone_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_contact_methods`
--

DROP TABLE IF EXISTS `crm_contact_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_contact_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_contact_methods`
--

LOCK TABLES `crm_contact_methods` WRITE;
/*!40000 ALTER TABLE `crm_contact_methods` DISABLE KEYS */;
INSERT INTO `crm_contact_methods` VALUES (1,'home phone'),(2,'work phone'),(3,'mobile phone'),(4,'email');
/*!40000 ALTER TABLE `crm_contact_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_model_for_patterns`
--

DROP TABLE IF EXISTS `crm_model_for_patterns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_model_for_patterns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_model_for_patterns`
--

LOCK TABLES `crm_model_for_patterns` WRITE;
/*!40000 ALTER TABLE `crm_model_for_patterns` DISABLE KEYS */;
INSERT INTO `crm_model_for_patterns` VALUES (1,'Connection'),(2,'Case'),(3,'StatusType'),(4,'TagKey'),(5,'User');
/*!40000 ALTER TABLE `crm_model_for_patterns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_health_questions`
--

DROP TABLE IF EXISTS `crm_health_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_health_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_health_questions`
--

LOCK TABLES `crm_health_questions` WRITE;
/*!40000 ALTER TABLE `crm_health_questions` DISABLE KEYS */;
INSERT INTO `crm_health_questions` VALUES (1,'Have you lost more than 10 lbs in the last 12 months?',NULL),(2,'Do you have a history of medical conditions besides minor colds or flu?',NULL),(3,'Have you ever had any heart disease or cancer history? (10 years)',NULL),(4,'Are you taking any prescription medications of any kind or have you in the last 10 years? If yes what are they for?',NULL),(5,'Have you been hospitalized overnight in the last 5 years?',NULL),(6,'Any lung, kidney or liver problems? Any digestive problems including colitis or ulcers?',NULL),(7,'Any treatment or diagnosis of HBP, High Chol, asthma, sleep apnea, diabetes depression or anxiety? (Ask for reading and if under control for past 12 months)',NULL),(8,'Are you currently being observed by a physician for any reason? When was your last physical (if over 55)?',NULL),(9,'Have you used nicotine or tobacco in any form at all the last 2 years - that includes chewing tobacco - nicotine gum patches or cigars? (Even socially)',NULL),(10,'Any treatment or history of drug or alcohol abuse in the past 10 years? DUI or reckless driving conviction? Any felony convictions? How about more than 1 moving violation in the past 10 years?',NULL),(11,'Any plans of traveling outside the US or Canada in the next 2 years? Any past travel out of country in the past 2 years?  Business or pleasure?',NULL),(12,'Have you ever filed for bankruptcy? If yes, what type and when was it discharged?',NULL),(13,'Any death from cancer, heart or cardiovascular disease in a parent or sibling prior to 60? Siblings prior to age 65?',NULL),(14,'Any hazardous activities such as private aviation, motor racing, mountain climbing, scuba diving in the past 3 years?',NULL),(15,'Have you ever had an application for insurance declined or had the rate modified?',NULL);
/*!40000 ALTER TABLE `crm_health_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_roles`
--

DROP TABLE IF EXISTS `usage_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `can_have_children` tinyint(4) DEFAULT NULL,
  `can_edit_crm_core` tinyint(4) DEFAULT NULL,
  `can_edit_crm_status_meta` tinyint(4) DEFAULT NULL,
  `can_edit_descendents` tinyint(4) DEFAULT NULL,
  `can_edit_descendents_resources` tinyint(4) DEFAULT NULL,
  `can_edit_nephews` tinyint(4) DEFAULT NULL,
  `can_edit_nephews_resources` tinyint(4) DEFAULT NULL,
  `can_edit_profiles` tinyint(4) DEFAULT NULL,
  `can_edit_self` tinyint(4) DEFAULT NULL,
  `can_edit_siblings` tinyint(4) DEFAULT NULL,
  `can_edit_siblings_resources` tinyint(4) DEFAULT NULL,
  `can_view_descendents` tinyint(4) DEFAULT NULL,
  `can_view_descendents_resources` tinyint(4) DEFAULT NULL,
  `can_view_nephews` tinyint(4) DEFAULT NULL,
  `can_view_nephews_resources` tinyint(4) DEFAULT NULL,
  `can_view_siblings` tinyint(4) DEFAULT NULL,
  `can_view_siblings_resources` tinyint(4) DEFAULT NULL,
  `can_edit_tags` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_roles`
--

LOCK TABLES `usage_roles` WRITE;
/*!40000 ALTER TABLE `usage_roles` DISABLE KEYS */;
INSERT INTO `usage_roles` VALUES (1,'system',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'developer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'sales agent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'sales support',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'sales coordinator',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'sales assistant',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'administrative assistant',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,'case manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,'group',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `usage_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ownerships`
--

DROP TABLE IF EXISTS `ownerships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ownerships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ownerships`
--

LOCK TABLES `ownerships` WRITE;
/*!40000 ALTER TABLE `ownerships` DISABLE KEYS */;
INSERT INTO `ownerships` VALUES (1,'global'),(2,'user'),(3,'user and descendents');
/*!40000 ALTER TABLE `ownerships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_ltc_benefit_period_options`
--

DROP TABLE IF EXISTS `quoting_ltc_benefit_period_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_ltc_benefit_period_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_ltc_benefit_period_options`
--

LOCK TABLES `quoting_ltc_benefit_period_options` WRITE;
/*!40000 ALTER TABLE `quoting_ltc_benefit_period_options` DISABLE KEYS */;
INSERT INTO `quoting_ltc_benefit_period_options` VALUES (1,'1 year','1NB'),(2,'2 years','2NB'),(3,'3 years','3NB'),(4,'4 years','4NB'),(5,'5 years','5NB'),(6,'6 years','6NB'),(7,'7 years','7NB'),(8,'8 years','8NB'),(9,'10 years','10NB'),(10,'12 years','12NB'),(11,'Lifetime','LIFE');
/*!40000 ALTER TABLE `quoting_ltc_benefit_period_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_spia_income_option_options`
--

DROP TABLE IF EXISTS `quoting_spia_income_option_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_spia_income_option_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_spia_income_option_options`
--

LOCK TABLES `quoting_spia_income_option_options` WRITE;
/*!40000 ALTER TABLE `quoting_spia_income_option_options` DISABLE KEYS */;
INSERT INTO `quoting_spia_income_option_options` VALUES (1,'My life only','lifetime'),(2,'My life + Souse/partner\'s life','lifetime_and_someone'),(3,'Number of years only','set_period');
/*!40000 ALTER TABLE `quoting_spia_income_option_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_citizenships`
--

DROP TABLE IF EXISTS `crm_citizenships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_citizenships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_citizenships`
--

LOCK TABLES `crm_citizenships` WRITE;
/*!40000 ALTER TABLE `crm_citizenships` DISABLE KEYS */;
INSERT INTO `crm_citizenships` VALUES (1,'US Citizen'),(2,'Permanent Resident'),(3,'Visa'),(4,'Other');
/*!40000 ALTER TABLE `crm_citizenships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_beneficiary_or_owner_types`
--

DROP TABLE IF EXISTS `crm_beneficiary_or_owner_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_beneficiary_or_owner_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_beneficiary_or_owner_types`
--

LOCK TABLES `crm_beneficiary_or_owner_types` WRITE;
/*!40000 ALTER TABLE `crm_beneficiary_or_owner_types` DISABLE KEYS */;
INSERT INTO `crm_beneficiary_or_owner_types` VALUES (1,'person'),(2,'trust'),(3,'company');
/*!40000 ALTER TABLE `crm_beneficiary_or_owner_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_tli_category_options`
--

DROP TABLE IF EXISTS `quoting_tli_category_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_tli_category_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `compulife_code` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_tli_category_options`
--

LOCK TABLES `quoting_tli_category_options` WRITE;
/*!40000 ALTER TABLE `quoting_tli_category_options` DISABLE KEYS */;
INSERT INTO `quoting_tli_category_options` VALUES (1,'10 Years','3',NULL,10),(2,'15 Years','4',NULL,15),(3,'20 Years','5',NULL,20),(4,'30 Years','7',NULL,30),(5,'20-Year Return of Premium','K',NULL,20),(6,'30-Year Return of Premium','M',NULL,30),(7,'Lifetime','8',NULL,120);
/*!40000 ALTER TABLE `quoting_tli_category_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_tli_health_class_options`
--

DROP TABLE IF EXISTS `quoting_tli_health_class_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_tli_health_class_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_tli_health_class_options`
--

LOCK TABLES `quoting_tli_health_class_options` WRITE;
/*!40000 ALTER TABLE `quoting_tli_health_class_options` DISABLE KEYS */;
INSERT INTO `quoting_tli_health_class_options` VALUES (1,'Best Class','PP'),(2,'Preferred','P'),(3,'Standard Plus','RP'),(4,'Standard','R');
/*!40000 ALTER TABLE `quoting_tli_health_class_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_clq_templates`
--

DROP TABLE IF EXISTS `marketing_clq_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_clq_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `body` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_clq_templates`
--

LOCK TABLES `marketing_clq_templates` WRITE;
/*!40000 ALTER TABLE `marketing_clq_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_clq_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_activity_types`
--

DROP TABLE IF EXISTS `marketing_activity_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_activity_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_activity_types`
--

LOCK TABLES `marketing_activity_types` WRITE;
/*!40000 ALTER TABLE `marketing_activity_types` DISABLE KEYS */;
INSERT INTO `marketing_activity_types` VALUES (1,'other'),(2,'email'),(3,'phone'),(4,'phone message'),(5,'sms'),(6,'letter');
/*!40000 ALTER TABLE `marketing_activity_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_ltc_inflation_protection_options`
--

DROP TABLE IF EXISTS `quoting_ltc_inflation_protection_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_ltc_inflation_protection_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_ltc_inflation_protection_options`
--

LOCK TABLES `quoting_ltc_inflation_protection_options` WRITE;
/*!40000 ALTER TABLE `quoting_ltc_inflation_protection_options` DISABLE KEYS */;
INSERT INTO `quoting_ltc_inflation_protection_options` VALUES (1,'None','NONE'),(2,'Periodic','PERI'),(3,'Simple','SIMP'),(4,'Compound','COMP'),(5,'2%-Compound','2COMP'),(6,'3%-Compound','3COMP'),(7,'4%-Compound','4COMP');
/*!40000 ALTER TABLE `quoting_ltc_inflation_protection_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagging_tag_rule_fields`
--

DROP TABLE IF EXISTS `tagging_tag_rule_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tagging_tag_rule_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tagging_tag_rule_fields`
--

LOCK TABLES `tagging_tag_rule_fields` WRITE;
/*!40000 ALTER TABLE `tagging_tag_rule_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `tagging_tag_rule_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_ltc_health_class_options`
--

DROP TABLE IF EXISTS `quoting_ltc_health_class_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_ltc_health_class_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_ltc_health_class_options`
--

LOCK TABLES `quoting_ltc_health_class_options` WRITE;
/*!40000 ALTER TABLE `quoting_ltc_health_class_options` DISABLE KEYS */;
INSERT INTO `quoting_ltc_health_class_options` VALUES (1,'Preferred','PREF'),(2,'Standard','STD'),(3,'Substandard I','SUB1'),(4,'Substandard II','SUB2');
/*!40000 ALTER TABLE `quoting_ltc_health_class_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_zones`
--

DROP TABLE IF EXISTS `time_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `offset` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_zones`
--

LOCK TABLES `time_zones` WRITE;
/*!40000 ALTER TABLE `time_zones` DISABLE KEYS */;
INSERT INTO `time_zones` VALUES (1,'America/Chicago',NULL),(2,'America/Denver',NULL),(3,'America/Juneau',NULL),(4,'America/Los_Angeles',NULL),(5,'America/New_York',NULL),(6,'Pacific/Honolulu',NULL);
/*!40000 ALTER TABLE `time_zones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_policy_types`
--

DROP TABLE IF EXISTS `crm_policy_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_policy_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `marketech_product_type_id` int(11) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_policy_types`
--

LOCK TABLES `crm_policy_types` WRITE;
/*!40000 ALTER TABLE `crm_policy_types` DISABLE KEYS */;
INSERT INTO `crm_policy_types` VALUES (1,'Term',1,1,1),(2,'Universal Life',3,2,1),(3,'Whole Life',2,3,1),(4,'Variable Life',3,4,1),(5,'Survivor Term',1,5,1),(6,'Survivor UL',1,6,1),(7,'Guaranteed Issue',2,7,1),(8,'Survivor UL',1,8,1),(9,'Simplified Issue Term',1,9,1),(10,'Simplified Issue UL',1,10,1),(11,'Disability',3,11,1),(12,'Accidental',3,12,1),(13,'Business Expense',3,13,1),(14,'Long-term Care',1,14,1);
/*!40000 ALTER TABLE `crm_policy_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagging_tag_types`
--

DROP TABLE IF EXISTS `tagging_tag_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tagging_tag_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tagging_tag_types`
--

LOCK TABLES `tagging_tag_types` WRITE;
/*!40000 ALTER TABLE `tagging_tag_types` DISABLE KEYS */;
INSERT INTO `tagging_tag_types` VALUES (1,'tracking'),(2,'marketing');
/*!40000 ALTER TABLE `tagging_tag_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reporting_search_fields`
--

DROP TABLE IF EXISTS `reporting_search_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reporting_search_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `current` tinyint(4) DEFAULT NULL,
  `date_range` tinyint(4) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `other_enum_name` varchar(255) DEFAULT NULL,
  `other_enum_field` varchar(255) DEFAULT NULL,
  `text_field` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reporting_search_fields`
--

LOCK TABLES `reporting_search_fields` WRITE;
/*!40000 ALTER TABLE `reporting_search_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `reporting_search_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_note_types`
--

DROP TABLE IF EXISTS `crm_note_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_note_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_note_types`
--

LOCK TABLES `crm_note_types` WRITE;
/*!40000 ALTER TABLE `crm_note_types` DISABLE KEYS */;
INSERT INTO `crm_note_types` VALUES (1,'user created'),(2,'status change'),(3,'follow-up complete'),(4,'transfer to AI'),(5,'critical note change'),(6,'priority note change'),(7,'exam');
/*!40000 ALTER TABLE `crm_note_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_premium_mode_options`
--

DROP TABLE IF EXISTS `quoting_premium_mode_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_premium_mode_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_premium_mode_options`
--

LOCK TABLES `quoting_premium_mode_options` WRITE;
/*!40000 ALTER TABLE `quoting_premium_mode_options` DISABLE KEYS */;
INSERT INTO `quoting_premium_mode_options` VALUES (1,'Annually','YEAR',1),(2,'Semi-annl.','SEMI',1),(3,'Quarterly','QTR',1),(4,'Monthly','MONTH',1);
/*!40000 ALTER TABLE `quoting_premium_mode_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_contract_statuses`
--

DROP TABLE IF EXISTS `usage_contract_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage_contract_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_contract_statuses`
--

LOCK TABLES `usage_contract_statuses` WRITE;
/*!40000 ALTER TABLE `usage_contract_statuses` DISABLE KEYS */;
INSERT INTO `usage_contract_statuses` VALUES (1,'approved'),(2,'pending number'),(3,'active w/ application'),(4,'inactive'),(5,'pending w/ carrier'),(6,'terminated'),(7,'pending w/ agent'),(8,'rejected'),(9,'withdrawn');
/*!40000 ALTER TABLE `usage_contract_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_license_statuses`
--

DROP TABLE IF EXISTS `usage_license_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usage_license_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_license_statuses`
--

LOCK TABLES `usage_license_statuses` WRITE;
/*!40000 ALTER TABLE `usage_license_statuses` DISABLE KEYS */;
INSERT INTO `usage_license_statuses` VALUES (1,'pending'),(2,'approved'),(3,'inactive');
/*!40000 ALTER TABLE `usage_license_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_system_task_types`
--

DROP TABLE IF EXISTS `crm_system_task_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_system_task_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_system_task_types`
--

LOCK TABLES `crm_system_task_types` WRITE;
/*!40000 ALTER TABLE `crm_system_task_types` DISABLE KEYS */;
INSERT INTO `crm_system_task_types` VALUES (1,'email'),(2,'email agent'),(3,'phone dial'),(4,'phone broadcast'),(5,'sms'),(6,'sms agent'),(7,'letter');
/*!40000 ALTER TABLE `crm_system_task_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_activity_statuses`
--

DROP TABLE IF EXISTS `crm_activity_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crm_activity_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_activity_statuses`
--

LOCK TABLES `crm_activity_statuses` WRITE;
/*!40000 ALTER TABLE `crm_activity_statuses` DISABLE KEYS */;
INSERT INTO `crm_activity_statuses` VALUES (1,'complete'),(2,'not attempted'),(3,'left message'),(4,'failed to connect');
/*!40000 ALTER TABLE `crm_activity_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smokers`
--

DROP TABLE IF EXISTS `smokers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smokers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `compulife_value` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smokers`
--

LOCK TABLES `smokers` WRITE;
/*!40000 ALTER TABLE `smokers` DISABLE KEYS */;
INSERT INTO `smokers` VALUES (1,'Never',-1),(2,'Current user',0),(3,'Within the past year',1),(4,'Over 1 year ago',2),(5,'Over 2 years ago',3),(6,'Over 3 years ago',4),(7,'Over 5 years ago',5),(8,'Over 10 years ago',7);
/*!40000 ALTER TABLE `smokers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marital_statuses`
--

DROP TABLE IF EXISTS `marital_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marital_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marital_statuses`
--

LOCK TABLES `marital_statuses` WRITE;
/*!40000 ALTER TABLE `marital_statuses` DISABLE KEYS */;
INSERT INTO `marital_statuses` VALUES (1,'Single'),(2,'Married'),(3,'Divorced'),(4,'Widowed');
/*!40000 ALTER TABLE `marital_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quoting_tli_table_rating_options`
--

DROP TABLE IF EXISTS `quoting_tli_table_rating_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quoting_tli_table_rating_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quoting_tli_table_rating_options`
--

LOCK TABLES `quoting_tli_table_rating_options` WRITE;
/*!40000 ALTER TABLE `quoting_tli_table_rating_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `quoting_tli_table_rating_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'clu_enums'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-26 14:43:13
