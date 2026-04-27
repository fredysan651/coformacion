-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: coformacion1
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `acompañamiento_estudiantil_coformacion`
--

DROP TABLE IF EXISTS `acompañamiento_estudiantil_coformacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acompañamiento_estudiantil_coformacion` (
  `acompanamiento_id` int NOT NULL AUTO_INCREMENT,
  `estudiante_id` int NOT NULL COMMENT 'Relación con el estudiante',
  `proceso_id` int DEFAULT NULL COMMENT 'Relación con el proceso de práctica específico',
  `docente_id` int DEFAULT NULL COMMENT 'Quién realiza el acompañamiento (Tabla docentes)',
  `empresa_id` int DEFAULT NULL COMMENT 'Quién realiza el acompañamiento (Tabla empresas)',
  `nombre_tutor_empresa` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `cargo_tutor_empresa` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `telefono_tutor_empresa` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `email_tutor_empresa` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `corte_id` int DEFAULT NULL COMMENT 'Relación con la tabla cortes_coformacion',
  PRIMARY KEY (`acompanamiento_id`),
  KEY `acompañamiento_estudiantil_coformacion_ibfk_1` (`estudiante_id`),
  KEY `acompañamiento_estudiantil_coformacion_ibfk_2` (`proceso_id`),
  KEY `acompañamiento_estudiantil_coformacion_ibfk_3` (`docente_id`),
  KEY `acompañamiento_estudiantil_coformacion_ibfk_4` (`empresa_id`),
  KEY `acompañamiento_estudiantil_coformacion_ibfk_5` (`corte_id`),
  CONSTRAINT `acompañamiento_estudiantil_coformacion_ibfk_1` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`),
  CONSTRAINT `acompañamiento_estudiantil_coformacion_ibfk_2` FOREIGN KEY (`proceso_id`) REFERENCES `procesos_coformacion` (`proceso_id`),
  CONSTRAINT `acompañamiento_estudiantil_coformacion_ibfk_3` FOREIGN KEY (`docente_id`) REFERENCES `docentes` (`docente_id`),
  CONSTRAINT `acompañamiento_estudiantil_coformacion_ibfk_4` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`),
  CONSTRAINT `acompañamiento_estudiantil_coformacion_ibfk_5` FOREIGN KEY (`corte_id`) REFERENCES `cortes_coformacion` (`corte_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acompañamiento_estudiantil_coformacion`
--

LOCK TABLES `acompañamiento_estudiantil_coformacion` WRITE;
/*!40000 ALTER TABLE `acompañamiento_estudiantil_coformacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `acompañamiento_estudiantil_coformacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add coformacion',7,'add_coformacion'),(26,'Can change coformacion',7,'change_coformacion'),(27,'Can delete coformacion',7,'delete_coformacion'),(28,'Can view coformacion',7,'view_coformacion'),(29,'Can add empresas',8,'add_empresas'),(30,'Can change empresas',8,'change_empresas'),(31,'Can delete empresas',8,'delete_empresas'),(32,'Can view empresas',8,'view_empresas'),(33,'Can add estado proceso',9,'add_estadoproceso'),(34,'Can change estado proceso',9,'change_estadoproceso'),(35,'Can delete estado proceso',9,'delete_estadoproceso'),(36,'Can view estado proceso',9,'view_estadoproceso'),(37,'Can add estados cartera',10,'add_estadoscartera'),(38,'Can change estados cartera',10,'change_estadoscartera'),(39,'Can delete estados cartera',10,'delete_estadoscartera'),(40,'Can view estados cartera',10,'view_estadoscartera'),(41,'Can add facultades',11,'add_facultades'),(42,'Can change facultades',11,'change_facultades'),(43,'Can delete facultades',11,'delete_facultades'),(44,'Can view facultades',11,'view_facultades'),(45,'Can add materias nucleo',12,'add_materiasnucleo'),(46,'Can change materias nucleo',12,'change_materiasnucleo'),(47,'Can delete materias nucleo',12,'delete_materiasnucleo'),(48,'Can view materias nucleo',12,'view_materiasnucleo'),(49,'Can add niveles ingles',13,'add_nivelesingles'),(50,'Can change niveles ingles',13,'change_nivelesingles'),(51,'Can delete niveles ingles',13,'delete_nivelesingles'),(52,'Can view niveles ingles',13,'view_nivelesingles'),(53,'Can add permisos',14,'add_permisos'),(54,'Can change permisos',14,'change_permisos'),(55,'Can delete permisos',14,'delete_permisos'),(56,'Can view permisos',14,'view_permisos'),(57,'Can add plantillas correo',15,'add_plantillascorreo'),(58,'Can change plantillas correo',15,'change_plantillascorreo'),(59,'Can delete plantillas correo',15,'delete_plantillascorreo'),(60,'Can view plantillas correo',15,'view_plantillascorreo'),(61,'Can add promociones',16,'add_promociones'),(62,'Can change promociones',16,'change_promociones'),(63,'Can delete promociones',16,'delete_promociones'),(64,'Can view promociones',16,'view_promociones'),(65,'Can add roles',17,'add_roles'),(66,'Can change roles',17,'change_roles'),(67,'Can delete roles',17,'delete_roles'),(68,'Can view roles',17,'view_roles'),(69,'Can add sectores economicos',18,'add_sectoreseconomicos'),(70,'Can change sectores economicos',18,'change_sectoreseconomicos'),(71,'Can delete sectores economicos',18,'delete_sectoreseconomicos'),(72,'Can view sectores economicos',18,'view_sectoreseconomicos'),(73,'Can add tamanos empresa',19,'add_tamanosempresa'),(74,'Can change tamanos empresa',19,'change_tamanosempresa'),(75,'Can delete tamanos empresa',19,'delete_tamanosempresa'),(76,'Can view tamanos empresa',19,'view_tamanosempresa'),(77,'Can add tipos actividad',20,'add_tiposactividad'),(78,'Can change tipos actividad',20,'change_tiposactividad'),(79,'Can delete tipos actividad',20,'delete_tiposactividad'),(80,'Can view tipos actividad',20,'view_tiposactividad'),(81,'Can add tipos contacto',21,'add_tiposcontacto'),(82,'Can change tipos contacto',21,'change_tiposcontacto'),(83,'Can delete tipos contacto',21,'delete_tiposcontacto'),(84,'Can view tipos contacto',21,'view_tiposcontacto'),(85,'Can add tipos documento',22,'add_tiposdocumento'),(86,'Can change tipos documento',22,'change_tiposdocumento'),(87,'Can delete tipos documento',22,'delete_tiposdocumento'),(88,'Can view tipos documento',22,'view_tiposdocumento'),(89,'Can add contactos empresa',23,'add_contactosempresa'),(90,'Can change contactos empresa',23,'change_contactosempresa'),(91,'Can delete contactos empresa',23,'delete_contactosempresa'),(92,'Can view contactos empresa',23,'view_contactosempresa'),(93,'Can add estudiantes',24,'add_estudiantes'),(94,'Can change estudiantes',24,'change_estudiantes'),(95,'Can delete estudiantes',24,'delete_estudiantes'),(96,'Can view estudiantes',24,'view_estudiantes'),(97,'Can add objetivos aprendizaje',25,'add_objetivosaprendizaje'),(98,'Can change objetivos aprendizaje',25,'change_objetivosaprendizaje'),(99,'Can delete objetivos aprendizaje',25,'delete_objetivosaprendizaje'),(100,'Can view objetivos aprendizaje',25,'view_objetivosaprendizaje'),(101,'Can add ofertas empresas',26,'add_ofertasempresas'),(102,'Can change ofertas empresas',26,'change_ofertasempresas'),(103,'Can delete ofertas empresas',26,'delete_ofertasempresas'),(104,'Can view ofertas empresas',26,'view_ofertasempresas'),(105,'Can add historial comunicaciones',27,'add_historialcomunicaciones'),(106,'Can change historial comunicaciones',27,'change_historialcomunicaciones'),(107,'Can delete historial comunicaciones',27,'delete_historialcomunicaciones'),(108,'Can view historial comunicaciones',27,'view_historialcomunicaciones'),(109,'Can add proceso coformacion',28,'add_procesocoformacion'),(110,'Can change proceso coformacion',28,'change_procesocoformacion'),(111,'Can delete proceso coformacion',28,'delete_procesocoformacion'),(112,'Can view proceso coformacion',28,'view_procesocoformacion'),(113,'Can add documentos proceso',29,'add_documentosproceso'),(114,'Can change documentos proceso',29,'change_documentosproceso'),(115,'Can delete documentos proceso',29,'delete_documentosproceso'),(116,'Can view documentos proceso',29,'view_documentosproceso'),(117,'Can add programas',30,'add_programas'),(118,'Can change programas',30,'change_programas'),(119,'Can delete programas',30,'delete_programas'),(120,'Can view programas',30,'view_programas'),(121,'Can add calendario actividades',31,'add_calendarioactividades'),(122,'Can change calendario actividades',31,'change_calendarioactividades'),(123,'Can delete calendario actividades',31,'delete_calendarioactividades'),(124,'Can view calendario actividades',31,'view_calendarioactividades'),(125,'Can add roles permisos',32,'add_rolespermisos'),(126,'Can change roles permisos',32,'change_rolespermisos'),(127,'Can delete roles permisos',32,'delete_rolespermisos'),(128,'Can view roles permisos',32,'view_rolespermisos'),(129,'Can add docentes',33,'add_docentes'),(130,'Can change docentes',33,'change_docentes'),(131,'Can delete docentes',33,'delete_docentes'),(132,'Can view docentes',33,'view_docentes'),(133,'Can add cortes coformacion',34,'add_cortescoformacion'),(134,'Can change cortes coformacion',34,'change_cortescoformacion'),(135,'Can delete cortes coformacion',34,'delete_cortescoformacion'),(136,'Can view cortes coformacion',34,'view_cortescoformacion'),(137,'Can add procesos coformacion',35,'add_procesoscoformacion'),(138,'Can change procesos coformacion',35,'change_procesoscoformacion'),(139,'Can delete procesos coformacion',35,'delete_procesoscoformacion'),(140,'Can view procesos coformacion',35,'view_procesoscoformacion'),(141,'Can add acompanamiento estudiantil coformacion',36,'add_acompanamientoestudiantilcoformacion'),(142,'Can change acompanamiento estudiantil coformacion',36,'change_acompanamientoestudiantilcoformacion'),(143,'Can delete acompanamiento estudiantil coformacion',36,'delete_acompanamientoestudiantilcoformacion'),(144,'Can view acompanamiento estudiantil coformacion',36,'view_acompanamientoestudiantilcoformacion');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendario_actividades`
--

DROP TABLE IF EXISTS `calendario_actividades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendario_actividades` (
  `actividad_id` int NOT NULL AUTO_INCREMENT,
  `tipo_act_id` int NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `proceso_id` int DEFAULT NULL,
  `ubicacion` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `estado` enum('Pendiente','En Proceso','Completada','Cancelada') COLLATE utf8mb4_spanish_ci DEFAULT 'Pendiente',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actividad_id`),
  KEY `tipo_act_id` (`tipo_act_id`),
  KEY `proceso_id` (`proceso_id`),
  KEY `idx_calendario_fechas` (`fecha_inicio`,`fecha_fin`,`estado`),
  CONSTRAINT `calendario_actividades_ibfk_1` FOREIGN KEY (`tipo_act_id`) REFERENCES `tipos_actividad` (`tipo_act_id`),
  CONSTRAINT `calendario_actividades_ibfk_2` FOREIGN KEY (`proceso_id`) REFERENCES `procesos_coformacion` (`proceso_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendario_actividades`
--

LOCK TABLES `calendario_actividades` WRITE;
/*!40000 ALTER TABLE `calendario_actividades` DISABLE KEYS */;
INSERT INTO `calendario_actividades` VALUES (1,1,'Capacitación Inicial','Inducción al sistema y normas','2024-06-10 08:00:00','2024-06-10 12:00:00',1,'Auditorio Principal','Pendiente','2025-06-11 23:00:10','2025-06-11 23:00:10'),(2,2,'Seguimiento Primer Mes','Evaluación de desempeño','2024-07-10 10:00:00','2024-07-10 12:00:00',1,'Sala de reuniones','Pendiente','2025-06-11 23:00:10','2025-06-11 23:00:10');
/*!40000 ALTER TABLE `calendario_actividades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coformacion`
--

DROP TABLE IF EXISTS `coformacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coformacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `identificacion` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `rol` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identificacion` (`identificacion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coformacion`
--

LOCK TABLES `coformacion` WRITE;
/*!40000 ALTER TABLE `coformacion` DISABLE KEYS */;
INSERT INTO `coformacion` VALUES (1,'Ana María Rodríguez','1234567890','Coordinadora',1,'2025-06-12 10:00:00'),(2,'Carlos Eduardo Gómez','2345678901','Supervisor',1,'2025-06-12 10:00:00'),(3,'Laura Patricia Sánchez','3456789012','Asesora',1,'2025-06-12 10:00:00'),(4,'Juan David Martínez','4567890123','Tutor',1,'2025-06-12 10:00:00'),(5,'María Fernanda López','5678901234','Coordinadora',1,'2025-06-12 10:00:00');
/*!40000 ALTER TABLE `coformacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contactos_empresa`
--

DROP TABLE IF EXISTS `contactos_empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contactos_empresa` (
  `contacto_id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `cargo` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `area` varchar(100) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `celular` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `tipo` enum('Prácticas','Talento Humano','Tutor','Otros') COLLATE utf8mb4_spanish_ci NOT NULL,
  `es_principal` tinyint(1) DEFAULT '0',
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contacto_id`),
  KEY `empresa_id` (`empresa_id`),
  CONSTRAINT `contactos_empresa_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contactos_empresa`
--

LOCK TABLES `contactos_empresa` WRITE;
/*!40000 ALTER TABLE `contactos_empresa` DISABLE KEYS */;
INSERT INTO `contactos_empresa` VALUES (1,1,'Laura Gómez','Coordinadora TI','Tecnología','6013214567','3009876543','laura@soldigital.com','Tutor',1,1,'2025-06-11 23:00:10','2025-06-11 23:00:10'),(2,2,'Carlos Ramírez','Director Académico','Académica','6024567890','3101234567','carlos@ileduc.org','Prácticas',1,1,'2025-06-11 23:00:10','2025-06-11 23:00:10');
/*!40000 ALTER TABLE `contactos_empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cortes_coformacion`
--

DROP TABLE IF EXISTS `cortes_coformacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cortes_coformacion` (
  `corte_id` int NOT NULL AUTO_INCREMENT,
  `numero_corte` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha_inicio_corte` date NOT NULL,
  `fecha_finalizacion_corte` date NOT NULL,
  PRIMARY KEY (`corte_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cortes_coformacion`
--

LOCK TABLES `cortes_coformacion` WRITE;
/*!40000 ALTER TABLE `cortes_coformacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `cortes_coformacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_general_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(36,'coformacion','acompanamientoestudiantilcoformacion'),(31,'coformacion','calendarioactividades'),(7,'coformacion','coformacion'),(23,'coformacion','contactosempresa'),(34,'coformacion','cortescoformacion'),(33,'coformacion','docentes'),(29,'coformacion','documentosproceso'),(8,'coformacion','empresas'),(9,'coformacion','estadoproceso'),(10,'coformacion','estadoscartera'),(24,'coformacion','estudiantes'),(11,'coformacion','facultades'),(27,'coformacion','historialcomunicaciones'),(12,'coformacion','materiasnucleo'),(13,'coformacion','nivelesingles'),(25,'coformacion','objetivosaprendizaje'),(26,'coformacion','ofertasempresas'),(14,'coformacion','permisos'),(15,'coformacion','plantillascorreo'),(28,'coformacion','procesocoformacion'),(35,'coformacion','procesoscoformacion'),(30,'coformacion','programas'),(16,'coformacion','promociones'),(17,'coformacion','roles'),(32,'coformacion','rolespermisos'),(18,'coformacion','sectoreseconomicos'),(19,'coformacion','tamanosempresa'),(20,'coformacion','tiposactividad'),(21,'coformacion','tiposcontacto'),(22,'coformacion','tiposdocumento'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-06-12 04:10:36.976963'),(2,'auth','0001_initial','2025-06-12 04:10:37.401060'),(3,'admin','0001_initial','2025-06-12 04:10:37.639153'),(4,'admin','0002_logentry_remove_auto_add','2025-06-12 04:10:37.646155'),(5,'admin','0003_logentry_add_action_flag_choices','2025-06-12 04:10:37.652155'),(6,'contenttypes','0002_remove_content_type_name','2025-06-12 04:10:37.742864'),(7,'auth','0002_alter_permission_name_max_length','2025-06-12 04:10:37.793801'),(8,'auth','0003_alter_user_email_max_length','2025-06-12 04:10:37.815806'),(9,'auth','0004_alter_user_username_opts','2025-06-12 04:10:37.821808'),(10,'auth','0005_alter_user_last_login_null','2025-06-12 04:10:37.872819'),(11,'auth','0006_require_contenttypes_0002','2025-06-12 04:10:37.874820'),(12,'auth','0007_alter_validators_add_error_messages','2025-06-12 04:10:37.880820'),(13,'auth','0008_alter_user_username_max_length','2025-06-12 04:10:37.934817'),(14,'auth','0009_alter_user_last_name_max_length','2025-06-12 04:10:37.990820'),(15,'auth','0010_alter_group_name_max_length','2025-06-12 04:10:38.007823'),(16,'auth','0011_update_proxy_permissions','2025-06-12 04:10:38.014824'),(17,'auth','0012_alter_user_first_name_max_length','2025-06-12 04:10:38.065836'),(18,'sessions','0001_initial','2025-06-12 04:10:38.096855'),(19,'coformacion','0001_initial','2025-12-01 15:41:02.195876'),(20,'coformacion','0002_empresas_actividad_economica_empresas_ciudad_and_more','2025-12-01 15:41:02.198305'),(21,'coformacion','0003_update_ofertas_empresas','2025-12-01 15:41:02.200135'),(22,'coformacion','0004_alter_ofertasempresas_apoyo_economico_and_more','2025-12-01 15:41:02.201941'),(23,'coformacion','0005_add_logo_url_to_empresas','2025-12-01 15:41:02.203816'),(24,'coformacion','0006_add_descripcion_fechas_to_ofertas','2025-12-01 15:41:02.206139'),(25,'coformacion','0007_add_ofrece_apoyo','2025-12-01 15:41:02.208087'),(26,'coformacion','0008_create_proceso_coformacion','2025-12-01 15:43:57.016837'),(27,'coformacion','0009_add_brinda_eps','2026-03-31 14:04:08.865790'),(28,'coformacion','0010_sync_with_database','2026-03-31 14:04:32.505817'),(29,'coformacion','0011_add_foto_to_estudiantes','2026-04-14 16:50:58.804181'),(30,'coformacion','0012_create_missing_tables','2026-04-14 16:57:10.361681'),(31,'coformacion','0013_create_proceso_coformacion_table','2026-04-17 14:23:28.062273'),(32,'coformacion','0014_create_procesos_coformacion_table','2026-04-17 14:23:28.086731');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docentes`
--

DROP TABLE IF EXISTS `docentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docentes` (
  `docente_id` int NOT NULL AUTO_INCREMENT,
  `nombre_completo_docente` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `cargo_docente` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `telefono_docente` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `email_docente` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`docente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docentes`
--

LOCK TABLES `docentes` WRITE;
/*!40000 ALTER TABLE `docentes` DISABLE KEYS */;
/*!40000 ALTER TABLE `docentes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documentos_proceso`
--

DROP TABLE IF EXISTS `documentos_proceso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_proceso` (
  `documento_id` int NOT NULL AUTO_INCREMENT,
  `proceso_id` int NOT NULL,
  `tipo_doc_id` int NOT NULL,
  `url_documento` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha_envio` datetime NOT NULL,
  `fecha_revision` datetime DEFAULT NULL,
  `fecha_aprobacion` datetime DEFAULT NULL,
  `estado` enum('Pendiente','En Revisión','Aprobado','Devuelto') COLLATE utf8mb4_spanish_ci DEFAULT 'Pendiente',
  `observaciones` text COLLATE utf8mb4_spanish_ci,
  `revisado_por` int DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`documento_id`),
  KEY `proceso_id` (`proceso_id`),
  KEY `revisado_por` (`revisado_por`),
  KEY `idx_documentos_estado` (`estado`,`fecha_envio`),
  KEY `idx_docs_tipo_estado` (`tipo_doc_id`,`estado`),
  CONSTRAINT `documentos_proceso_ibfk_1` FOREIGN KEY (`proceso_id`) REFERENCES `procesos_coformacion` (`proceso_id`),
  CONSTRAINT `documentos_proceso_ibfk_2` FOREIGN KEY (`tipo_doc_id`) REFERENCES `tipos_documento` (`tipo_doc_id`),
  CONSTRAINT `documentos_proceso_ibfk_3` FOREIGN KEY (`revisado_por`) REFERENCES `roles` (`rol_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documentos_proceso`
--

LOCK TABLES `documentos_proceso` WRITE;
/*!40000 ALTER TABLE `documentos_proceso` DISABLE KEYS */;
INSERT INTO `documentos_proceso` VALUES (1,1,1,'https://uni.edu.co/docs/carta_presentacion_maria.pdf','2024-06-01 00:00:00',NULL,NULL,'Pendiente',NULL,NULL,'2025-06-11 23:00:10','2025-06-11 23:00:10'),(2,1,2,'https://uni.edu.co/docs/convenio_maria.pdf','2024-06-03 00:00:00',NULL,NULL,'Pendiente',NULL,NULL,'2025-06-11 23:00:10','2025-06-11 23:00:10'),(3,2,1,'https://uni.edu.co/docs/carta_presentacion_juan.pdf','2024-06-05 00:00:00',NULL,NULL,'Pendiente',NULL,NULL,'2025-06-11 23:00:10','2025-06-11 23:00:10');
/*!40000 ALTER TABLE `documentos_proceso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `empresa_id` int NOT NULL AUTO_INCREMENT,
  `nit_empresa` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `razon_social` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre_comercial` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `sector_id` int NOT NULL,
  `tamano_id` int NOT NULL,
  `direccion_empresa` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre_persona_contacto_empresa` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `numero_persona_contacto_empresa` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `ciudad_empresa` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `departamento_empresa` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `cargo_persona_contacto_empresa` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `telefono_empresa` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `email_empresa` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `sitio_web` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `cuota_sena` int DEFAULT NULL,
  `numero_empleados` int DEFAULT NULL,
  `estado_convenio` enum('Vigente','No Vigente','En Trámite') COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'En Trámite',
  `fecha_convenio` date DEFAULT NULL,
  `convenio_url` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `actividad_economica` text COLLATE utf8mb4_spanish_ci NOT NULL,
  `horario_laboral` text COLLATE utf8mb4_spanish_ci,
  `trabaja_sabado` tinyint(1) DEFAULT '0',
  `observaciones` text COLLATE utf8mb4_spanish_ci,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ciudad` varchar(100) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `imagen_url_base64` text COLLATE utf8mb4_spanish_ci,
  PRIMARY KEY (`empresa_id`),
  KEY `tamano_id` (`tamano_id`),
  KEY `idx_empresa_sector` (`sector_id`,`estado_convenio`),
  KEY `idx_empresa_estado` (`estado_convenio`,`estado`),
  CONSTRAINT `empresas_ibfk_1` FOREIGN KEY (`sector_id`) REFERENCES `sectores_economicos` (`sector_id`),
  CONSTRAINT `empresas_ibfk_2` FOREIGN KEY (`tamano_id`) REFERENCES `tamanos_empresa` (`tamano_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

LOCK TABLES `empresas` WRITE;
/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
INSERT INTO `empresas` VALUES (12,'901.234.567-8','Soluciones Tecnológicas Globales S.A.S.','SoluTech Global',1,2,'Carrera 15 # 93-60 Oficina 402','María Fernanda González','3109876543','Bogotá','Cundinamarca','Gerente de Talento Humano','6012345678','contacto@solutech.com.co','https://www.solutech.com.co',3,50,'Vigente','2024-01-15','https://drive.google.com/convenio1','Desarrollo de software y consultoría en sistemas informáticos.','Lunes a Viernes 8:00 AM - 5:30 PM',0,'Empresa interesada en aprendices de etapa productiva.',1,'2025-11-24 15:04:22','2025-11-24 15:04:22',NULL,NULL);
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_proceso`
--

DROP TABLE IF EXISTS `estado_proceso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_proceso` (
  `estado_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`estado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_proceso`
--

LOCK TABLES `estado_proceso` WRITE;
/*!40000 ALTER TABLE `estado_proceso` DISABLE KEYS */;
/*!40000 ALTER TABLE `estado_proceso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_cartera`
--

DROP TABLE IF EXISTS `estados_cartera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_cartera` (
  `estado_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`estado_id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_cartera`
--

LOCK TABLES `estados_cartera` WRITE;
/*!40000 ALTER TABLE `estados_cartera` DISABLE KEYS */;
INSERT INTO `estados_cartera` VALUES (1,'Al día'),(3,'Mora grave'),(2,'Mora leve');
/*!40000 ALTER TABLE `estados_cartera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_proceso`
--

DROP TABLE IF EXISTS `estados_proceso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_proceso` (
  `estado_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `color` varchar(7) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `orden` int NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`estado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_proceso`
--

LOCK TABLES `estados_proceso` WRITE;
/*!40000 ALTER TABLE `estados_proceso` DISABLE KEYS */;
INSERT INTO `estados_proceso` VALUES (1,'Pendiente','Proceso iniciado','#FFA500',1,1,'2025-06-11 22:47:33'),(2,'En Revisión','Documentos en revisión','#FFD700',2,1,'2025-06-11 22:47:33'),(3,'Aprobado','Proceso aprobado','#32CD32',3,1,'2025-06-11 22:47:33'),(4,'Rechazado','Proceso no aprobado','#FF0000',4,1,'2025-06-11 22:47:33'),(5,'Finalizado','Proceso completado','#4169E1',5,1,'2025-06-11 22:47:33');
/*!40000 ALTER TABLE `estados_proceso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `estudiante_id` int NOT NULL AUTO_INCREMENT,
  `codigo_estudiante` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `tipo_documento` enum('CC','CE','PAS','TI') COLLATE utf8mb4_spanish_ci NOT NULL,
  `numero_documento` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `apellidos` varchar(300) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `nombres` varchar(300) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `programa_id` int NOT NULL,
  `jornada` enum('Diurna','Nocturna','Mixta') COLLATE utf8mb4_spanish_ci NOT NULL,
  `semestre` int NOT NULL,
  `promocion_id` int DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `nivel_ingles_id` int DEFAULT NULL,
  `genero` enum('M','F','O') COLLATE utf8mb4_spanish_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `celular` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `email_institucional` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `email_personal` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `ciudad` varchar(100) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `foto_url` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `promedio_acumulado` decimal(3,2) DEFAULT NULL,
  `estado` enum('Activo','Inactivo','Graduado','Retirado') COLLATE utf8mb4_spanish_ci DEFAULT 'Activo',
  `fecha_ingreso` date NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `estado_cartera_id` int DEFAULT NULL,
  `empresa_id` int DEFAULT NULL,
  `eps_id` int DEFAULT NULL,
  `foto` varchar(100) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`estudiante_id`),
  UNIQUE KEY `codigo_estudiante` (`codigo_estudiante`),
  UNIQUE KEY `numero_documento` (`numero_documento`),
  UNIQUE KEY `email_institucional` (`email_institucional`),
  KEY `idx_estudiante_programa` (`programa_id`,`semestre`),
  KEY `nivel_ingles_id` (`nivel_ingles_id`),
  KEY `estado_cartera_id` (`estado_cartera_id`),
  KEY `promocion_id` (`promocion_id`),
  KEY `idx_estudiante_email` (`email_institucional`),
  KEY `empresa_id` (`empresa_id`),
  KEY `fk_estudiantes_eps` (`eps_id`),
  CONSTRAINT `estudiantes_ibfk_1` FOREIGN KEY (`programa_id`) REFERENCES `programas` (`programa_id`),
  CONSTRAINT `estudiantes_ibfk_2` FOREIGN KEY (`nivel_ingles_id`) REFERENCES `niveles_ingles` (`nivel_id`),
  CONSTRAINT `estudiantes_ibfk_3` FOREIGN KEY (`estado_cartera_id`) REFERENCES `estados_cartera` (`estado_id`),
  CONSTRAINT `estudiantes_ibfk_4` FOREIGN KEY (`promocion_id`) REFERENCES `promociones` (`promocion_id`),
  CONSTRAINT `estudiantes_ibfk_5` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_estudiantes_eps` FOREIGN KEY (`eps_id`) REFERENCES `estudiantes_eps` (`eps_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `estudiantes_chk_1` CHECK (((`semestre` > 0) and (`semestre` <= 12)))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
INSERT INTO `estudiantes` VALUES (1,'EST001','CC','10000001','Pérez','María',1,'Diurna',5,1,'2002-04-12',3,'F','123456','3214567890','maria.perez@uni.edu.co','mariap@gmail.com','Calle 123','Bogotá',NULL,4.20,'Activo','2022-01-15','2025-06-11 23:00:10','2026-04-21 15:43:29',1,1,1,'fotos_estudiantes/OIP.jpg'),(2,'EST002','CC','10000002','Pérez','Juan ',2,'Nocturna',3,2,'2001-08-25',2,'M','321324','3001234567','juan.torres@uni.edu.co','juant@hotmail.com','Cra 45','Medellín',NULL,3.80,'Activo','2023-01-20','2025-06-11 23:00:10','2025-11-26 11:20:04',2,2,NULL,NULL),(3,'TEST_USER','CC','99999999','Perez Gomez','Juan Carlos',3,'Diurna',1,NULL,'2000-01-01',NULL,'M',NULL,'3001234567','juan.perez@test.com',NULL,NULL,NULL,NULL,NULL,'Activo','2023-01-01','2025-11-27 14:41:56','2025-11-27 14:41:56',NULL,NULL,NULL,NULL),(5,'1234','CC','1031808572','Ramirez','Juan Pablo',1,'Diurna',3,3,'2006-10-23',1,'M','0758624','3132652494','jaguillon@uniempresarial.edu.co','ramirezjuanpablo@gmail.com','cra 113','Bogotá','',3.80,'Inactivo','2024-06-15','2025-11-27 16:15:26','2025-11-27 16:15:26',1,NULL,NULL,NULL),(6,'99887755','CC','99887755','Student','Debug Save',5,'Diurna',1,NULL,'2000-01-01',NULL,'M',NULL,'3001234567','debug.save@test.com',NULL,NULL,NULL,NULL,NULL,'Activo','2023-01-01','2025-11-27 16:17:19','2025-11-27 16:17:19',NULL,NULL,NULL,NULL),(7,'99887744','CC','99887744','Student 2','Debug Save 2',6,'Diurna',1,NULL,'2000-01-01',NULL,'M',NULL,'3001234567','debug.save2@test.com',NULL,NULL,NULL,NULL,NULL,'Activo','2023-01-01','2025-11-27 16:28:08','2025-11-27 16:28:08',NULL,NULL,NULL,NULL),(8,'TEST20251127','CC','12345678901','Pérez','Juan',1,'Diurna',1,NULL,'2000-01-15',NULL,'M',NULL,'3001234567','juan.perez@test.edu.co',NULL,NULL,NULL,NULL,NULL,'Activo','2024-01-01','2025-11-27 16:36:27','2025-11-27 16:36:27',NULL,NULL,NULL,NULL),(9,'TEST20251127B','CC','98765432101','García','Carlos',1,'Diurna',2,NULL,'1999-05-20',NULL,'M',NULL,'3109876543','carlos.garcia@test.edu.co',NULL,NULL,NULL,NULL,NULL,'Activo','2024-01-15','2025-11-27 16:37:22','2025-11-27 16:37:22',NULL,NULL,NULL,NULL),(10,'TEST20251127C','CC','99887766551','Sánchez','Fernando',1,'Diurna',3,NULL,'1998-03-25',NULL,'M',NULL,'3125559999','fernando.sanchez@test.edu.co',NULL,NULL,NULL,NULL,NULL,'Activo','2024-01-01','2025-11-27 16:41:51','2025-11-27 16:41:51',NULL,NULL,NULL,NULL),(11,'ANGULAR001','CC','12345678999','User','Test',1,'Diurna',1,NULL,'2000-01-01',NULL,'M','','3001234567','test@test.edu.co','','','','',NULL,'Activo','2024-01-01','2025-11-27 16:42:10','2025-11-27 16:42:10',NULL,NULL,NULL,NULL),(12,'TEST_b9ecaaa5','CC','1000b9ecaaa5','User','Test',1,'Diurna',1,NULL,'2000-01-01',NULL,'M',NULL,'3001234567','testb9ecaaa5@test.edu.co',NULL,NULL,NULL,NULL,NULL,'Activo','2024-01-01','2025-11-27 16:48:52','2025-11-27 16:48:52',NULL,NULL,NULL,NULL),(13,'1234454','CC','103180','Ramirez','Juan Pablo',1,'Diurna',3,3,'2006-10-23',1,'M','0758624','3132652494','j.aguillon@uniempresarial.edu.co','ramirezjuanpablo@gmail.com','cra 113','Bogotá',NULL,3.80,'Activo','2024-06-15','2025-11-27 16:50:34','2025-12-01 16:04:07',1,NULL,NULL,NULL),(14,'24759','CC','24758624','Aguillon Ramirez','Lian Maria',2,'Mixta',1,NULL,'2004-08-24',NULL,'F','314758621','3132652494','laguillon@uniempresarial.edu.co','aguillonlina@gmail.com','cra 113','Bogotá',NULL,3.80,'Activo','2024-06-15','2025-11-27 16:52:33','2025-11-27 16:52:33',1,NULL,NULL,NULL),(15,'123','CC','1031808752','Aguillon Ramirez','Juan Pablo',1,'Diurna',5,1,'2004-08-24',1,'M','3202059185','3132652494','jaaguillon@uniempresarial.edu.co','aguillonlina@gmail.com','cra 113','Bogotá',NULL,3.80,'Activo','2024-06-15','2025-12-04 17:07:38','2025-12-04 17:07:38',1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes_eps`
--

DROP TABLE IF EXISTS `estudiantes_eps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes_eps` (
  `eps_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`eps_id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes_eps`
--

LOCK TABLES `estudiantes_eps` WRITE;
/*!40000 ALTER TABLE `estudiantes_eps` DISABLE KEYS */;
INSERT INTO `estudiantes_eps` VALUES (1,'eps ejemplo','1');
/*!40000 ALTER TABLE `estudiantes_eps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facultades`
--

DROP TABLE IF EXISTS `facultades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facultades` (
  `facultad_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`facultad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facultades`
--

LOCK TABLES `facultades` WRITE;
/*!40000 ALTER TABLE `facultades` DISABLE KEYS */;
INSERT INTO `facultades` VALUES (1,'Facultad de Ingeniería',1,'2025-06-11 23:00:10'),(2,'Facultad de Ciencias Sociales',1,'2025-06-11 23:00:10'),(3,'Facultad Test',1,'2025-11-27 14:41:56'),(4,'Facultad Debug',1,'2025-11-27 15:29:29');
/*!40000 ALTER TABLE `facultades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_comunicaciones`
--

DROP TABLE IF EXISTS `historial_comunicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_comunicaciones` (
  `comunicacion_id` int NOT NULL AUTO_INCREMENT,
  `proceso_id` int NOT NULL,
  `plantilla_id` int NOT NULL,
  `fecha_envio` datetime NOT NULL,
  `destinatarios` text COLLATE utf8mb4_spanish_ci NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `contenido` text COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` enum('Enviado','Error','Pendiente') COLLATE utf8mb4_spanish_ci DEFAULT 'Pendiente',
  `error_mensaje` text COLLATE utf8mb4_spanish_ci,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comunicacion_id`),
  KEY `proceso_id` (`proceso_id`),
  KEY `plantilla_id` (`plantilla_id`),
  CONSTRAINT `historial_comunicaciones_ibfk_1` FOREIGN KEY (`proceso_id`) REFERENCES `procesos_coformacion` (`proceso_id`),
  CONSTRAINT `historial_comunicaciones_ibfk_2` FOREIGN KEY (`plantilla_id`) REFERENCES `plantillas_correo` (`plantilla_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_comunicaciones`
--

LOCK TABLES `historial_comunicaciones` WRITE;
/*!40000 ALTER TABLE `historial_comunicaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_comunicaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias_nucleo`
--

DROP TABLE IF EXISTS `materias_nucleo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materias_nucleo` (
  `materia_id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `programa_id` int NOT NULL,
  `semestre` int NOT NULL,
  `creditos` int NOT NULL,
  `horas_teoricas` int DEFAULT NULL,
  `horas_practicas` int DEFAULT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`materia_id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `programa_id` (`programa_id`),
  CONSTRAINT `materias_nucleo_ibfk_1` FOREIGN KEY (`programa_id`) REFERENCES `programas` (`programa_id`),
  CONSTRAINT `materias_nucleo_chk_1` CHECK (((`semestre` > 0) and (`semestre` <= 12)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias_nucleo`
--

LOCK TABLES `materias_nucleo` WRITE;
/*!40000 ALTER TABLE `materias_nucleo` DISABLE KEYS */;
/*!40000 ALTER TABLE `materias_nucleo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `niveles_ingles`
--

DROP TABLE IF EXISTS `niveles_ingles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `niveles_ingles` (
  `nivel_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`nivel_id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles_ingles`
--

LOCK TABLES `niveles_ingles` WRITE;
/*!40000 ALTER TABLE `niveles_ingles` DISABLE KEYS */;
INSERT INTO `niveles_ingles` VALUES (1,'A1'),(2,'A2'),(3,'B1'),(4,'B2'),(5,'C1');
/*!40000 ALTER TABLE `niveles_ingles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objetivos_aprendizaje`
--

DROP TABLE IF EXISTS `objetivos_aprendizaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objetivos_aprendizaje` (
  `objetivo_id` int NOT NULL AUTO_INCREMENT,
  `materia_id` int NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci NOT NULL,
  `tipo` enum('General','Específico') COLLATE utf8mb4_spanish_ci NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`objetivo_id`),
  KEY `materia_id` (`materia_id`),
  CONSTRAINT `objetivos_aprendizaje_ibfk_1` FOREIGN KEY (`materia_id`) REFERENCES `materias_nucleo` (`materia_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objetivos_aprendizaje`
--

LOCK TABLES `objetivos_aprendizaje` WRITE;
/*!40000 ALTER TABLE `objetivos_aprendizaje` DISABLE KEYS */;
/*!40000 ALTER TABLE `objetivos_aprendizaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofertasempresas`
--

DROP TABLE IF EXISTS `ofertasempresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ofertasempresas` (
  `idOferta` int NOT NULL AUTO_INCREMENT,
  `nacional` enum('No','Si') COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombreTutor` varchar(40) COLLATE utf8mb4_spanish_ci NOT NULL,
  `apoyoEconomico` decimal(10,2) NOT NULL,
  `modalidad` enum('Presencial','Virtual','Híbrido') COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombreEmpresa` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `empresa_id` int NOT NULL,
  `programa_id` int DEFAULT NULL,
  `Ofrece_apoyo` varchar(3) COLLATE utf8mb4_spanish_ci DEFAULT 'No',
  `brinda_eps` enum('Si','No') COLLATE utf8mb4_spanish_ci DEFAULT 'No',
  PRIMARY KEY (`idOferta`),
  KEY `empresa_id` (`empresa_id`),
  KEY `programa_id` (`programa_id`),
  CONSTRAINT `ofertasempresas_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`),
  CONSTRAINT `ofertasempresas_ibfk_2` FOREIGN KEY (`programa_id`) REFERENCES `programas` (`programa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofertasempresas`
--

LOCK TABLES `ofertasempresas` WRITE;
/*!40000 ALTER TABLE `ofertasempresas` DISABLE KEYS */;
INSERT INTO `ofertasempresas` VALUES (1,'Si','Laura Gómez',1200000.00,'Presencial','SolDigital',1,1,'No','No'),(2,'No','Carlos Ramírez',800000.00,'Virtual','ILEDUC',2,2,'No','No'),(3,'Si','Juan',500000.00,'Híbrido','SoluTech Global',12,1,'Si','No'),(4,'Si','Maria',250000.00,'Presencial','SoluTech Global',12,2,'Si','No'),(5,'Si','Pablo',0.00,'Presencial','SoluTech Global',12,1,'No','No'),(6,'No','Pablo',850000.00,'Virtual','SoluTech Global',12,2,'Si','No'),(7,'Si','Pedro',0.00,'Híbrido','SoluTech Global',12,1,'No','No'),(8,'Si','Martin',1000000.00,'Presencial','SoluTech Global',12,1,'Si','No'),(9,'Si','Pedro Pablo',150000.00,'Híbrido','SoluTech Global',12,1,'Si','Si');
/*!40000 ALTER TABLE `ofertasempresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permisos` (
  `permiso_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `modulo` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`permiso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantillas_correo`
--

DROP TABLE IF EXISTS `plantillas_correo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantillas_correo` (
  `plantilla_id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `cuerpo` text COLLATE utf8mb4_spanish_ci NOT NULL,
  `variables` text COLLATE utf8mb4_spanish_ci,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`plantilla_id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantillas_correo`
--

LOCK TABLES `plantillas_correo` WRITE;
/*!40000 ALTER TABLE `plantillas_correo` DISABLE KEYS */;
INSERT INTO `plantillas_correo` VALUES (1,'INI001','Bienvenida Estudiante','Bienvenido(a) al proceso de coformación','Hola {{nombre}}, bienvenido al proceso...',NULL,1,'2025-06-11 23:00:10','2025-06-11 23:00:10'),(2,'REV001','Documentos en Revisión','Revisión de documentos enviados','Estimado(a) {{nombre}}, tus documentos están en revisión...',NULL,1,'2025-06-11 23:00:10','2025-06-11 23:00:10');
/*!40000 ALTER TABLE `plantillas_correo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proceso_coformacion`
--

DROP TABLE IF EXISTS `proceso_coformacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proceso_coformacion` (
  `proceso_id` int NOT NULL AUTO_INCREMENT,
  `estudiante_id` int NOT NULL,
  `empresa_id` int NOT NULL,
  `oferta_id` int NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado_id` int DEFAULT NULL,
  `observaciones` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`proceso_id`),
  KEY `proceso_coformacion_estudiante_id_fk` (`estudiante_id`),
  KEY `proceso_coformacion_empresa_id_fk` (`empresa_id`),
  KEY `proceso_coformacion_oferta_id_fk` (`oferta_id`),
  KEY `proceso_coformacion_estado_id_fk` (`estado_id`),
  CONSTRAINT `proceso_coformacion_empresa_id_fk` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`) ON DELETE CASCADE,
  CONSTRAINT `proceso_coformacion_estado_id_fk` FOREIGN KEY (`estado_id`) REFERENCES `estado_proceso` (`estado_id`),
  CONSTRAINT `proceso_coformacion_estudiante_id_fk` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`),
  CONSTRAINT `proceso_coformacion_oferta_id_fk` FOREIGN KEY (`oferta_id`) REFERENCES `ofertasempresas` (`idOferta`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proceso_coformacion`
--

LOCK TABLES `proceso_coformacion` WRITE;
/*!40000 ALTER TABLE `proceso_coformacion` DISABLE KEYS */;
INSERT INTO `proceso_coformacion` VALUES (1,1,12,1,'2026-01-15','2026-06-15',NULL,'');
/*!40000 ALTER TABLE `proceso_coformacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procesos_coformacion`
--

DROP TABLE IF EXISTS `procesos_coformacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procesos_coformacion` (
  `proceso_id` int NOT NULL AUTO_INCREMENT,
  `estudiante_id` int NOT NULL,
  `empresa_id` int NOT NULL,
  `estado_id` int NOT NULL,
  `fecha_inicio_fase_coformacion` date NOT NULL,
  `fecha_fin_fase_practica` date DEFAULT NULL,
  `fecha_ingreso_empresa` date DEFAULT NULL,
  `fecha_finalizacion_empresa` date DEFAULT NULL,
  `fecha_carta_presentacion` date DEFAULT NULL,
  `horario` text COLLATE utf8mb4_spanish_ci,
  `forma_de_pago` decimal(10,2) DEFAULT '0.00',
  `trabaja_sabado` tinyint(1) DEFAULT '0',
  `salario` decimal(10,2) DEFAULT NULL,
  `modalidad_vinculacion` enum('Presencial','Virtual','Híbrido') COLLATE utf8mb4_spanish_ci NOT NULL,
  `carta_presentacion_enviada` enum('Si','No') COLLATE utf8mb4_spanish_ci NOT NULL,
  `carta_presentacion_recibida` enum('Si','No') COLLATE utf8mb4_spanish_ci NOT NULL,
  `modalidad_coformacion` enum('Presencial','Virtual','Híbrido') COLLATE utf8mb4_spanish_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_spanish_ci,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`proceso_id`),
  KEY `estudiante_id` (`estudiante_id`),
  KEY `empresa_id` (`empresa_id`),
  KEY `idx_proceso_fechas` (`fecha_inicio_fase_coformacion`,`fecha_fin_fase_practica`),
  KEY `idx_proceso_estado_empresa` (`estado_id`,`empresa_id`),
  CONSTRAINT `procesos_coformacion_ibfk_1` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`),
  CONSTRAINT `procesos_coformacion_ibfk_2` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`),
  CONSTRAINT `procesos_coformacion_ibfk_3` FOREIGN KEY (`estado_id`) REFERENCES `estados_proceso` (`estado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procesos_coformacion`
--

LOCK TABLES `procesos_coformacion` WRITE;
/*!40000 ALTER TABLE `procesos_coformacion` DISABLE KEYS */;
INSERT INTO `procesos_coformacion` VALUES (3,2,3,1,'2025-11-24',NULL,NULL,NULL,NULL,NULL,0.00,0,NULL,'Presencial','No','No','Presencial','Hoja de vida enviada, pendiente de entrevista.','2025-11-24 15:04:22','2025-11-24 15:04:22');
/*!40000 ALTER TABLE `procesos_coformacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programas`
--

DROP TABLE IF EXISTS `programas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programas` (
  `programa_id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_spanish_ci NOT NULL,
  `facultad_id` int NOT NULL,
  `duracion_semestres` int NOT NULL,
  `modalidad` enum('Presencial','Virtual','Híbrido') COLLATE utf8mb4_spanish_ci NOT NULL,
  `nivel` enum('Técnico','Tecnólogo','Profesional','Especialización','Maestría') COLLATE utf8mb4_spanish_ci NOT NULL,
  `resolucion_registro` varchar(100) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`programa_id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `facultad_id` (`facultad_id`),
  CONSTRAINT `programas_ibfk_1` FOREIGN KEY (`facultad_id`) REFERENCES `facultades` (`facultad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programas`
--

LOCK TABLES `programas` WRITE;
/*!40000 ALTER TABLE `programas` DISABLE KEYS */;
INSERT INTO `programas` VALUES (1,'ING01','Ingeniería de Sistemas',1,10,'Presencial','Profesional','1234-AB','2022-01-10',1,'2025-06-11 23:00:10','2025-06-11 23:00:10'),(2,'SOC01','Trabajo Social',2,8,'Virtual','Profesional','5678-CD','2021-05-15',1,'2025-06-11 23:00:10','2025-06-11 23:00:10'),(3,'TEST001','Programa Test',3,10,'Presencial','Profesional',NULL,NULL,1,'2025-11-27 14:41:56','2025-11-27 14:41:56'),(4,'DEBUG001','Programa Debug',4,10,'Presencial','Profesional',NULL,NULL,1,'2025-11-27 15:29:29','2025-11-27 15:29:29'),(5,'DEBUG002','Programa Debug 2',4,10,'Presencial','Profesional',NULL,NULL,1,'2025-11-27 16:17:19','2025-11-27 16:17:19'),(6,'DEBUG003','Programa Debug 3',4,10,'Presencial','Profesional',NULL,NULL,1,'2025-11-27 16:28:08','2025-11-27 16:28:08');
/*!40000 ALTER TABLE `programas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promociones`
--

DROP TABLE IF EXISTS `promociones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promociones` (
  `promocion_id` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`promocion_id`),
  UNIQUE KEY `descripcion` (`descripcion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promociones`
--

LOCK TABLES `promociones` WRITE;
/*!40000 ALTER TABLE `promociones` DISABLE KEYS */;
INSERT INTO `promociones` VALUES (1,'2023-I'),(2,'2023-II'),(3,'2024-I');
/*!40000 ALTER TABLE `promociones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `rol_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rol_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrador','Acceso completo al sistema',1,'2025-06-11 22:47:33','2025-06-11 22:47:33'),(2,'Coordinador','Gestión de procesos de coformación',1,'2025-06-11 22:47:33','2025-06-11 22:47:33'),(3,'Docente','Seguimiento a estudiantes',1,'2025-06-11 22:47:33','2025-06-11 22:47:33'),(4,'Estudiante','Acceso a su perfil y documentos',1,'2025-06-11 22:47:33','2025-06-11 22:47:33'),(5,'Empresa','Acceso a perfiles y procesos',1,'2025-06-11 22:47:33','2025-06-11 22:47:33');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_permisos`
--

DROP TABLE IF EXISTS `roles_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_permisos` (
  `rol_id` int NOT NULL,
  `permiso_id` int NOT NULL,
  `fecha_asignacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rol_id`,`permiso_id`),
  KEY `permiso_id` (`permiso_id`),
  CONSTRAINT `roles_permisos_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`rol_id`) ON DELETE CASCADE,
  CONSTRAINT `roles_permisos_ibfk_2` FOREIGN KEY (`permiso_id`) REFERENCES `permisos` (`permiso_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_permisos`
--

LOCK TABLES `roles_permisos` WRITE;
/*!40000 ALTER TABLE `roles_permisos` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles_permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sectores_economicos`
--

DROP TABLE IF EXISTS `sectores_economicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sectores_economicos` (
  `sector_id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sector_id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sectores_economicos`
--

LOCK TABLES `sectores_economicos` WRITE;
/*!40000 ALTER TABLE `sectores_economicos` DISABLE KEYS */;
INSERT INTO `sectores_economicos` VALUES (1,'TI01','Tecnología',NULL,1,'2025-06-11 23:00:10'),(2,'EDU01','Educación',NULL,1,'2025-06-11 23:00:10');
/*!40000 ALTER TABLE `sectores_economicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tamanos_empresa`
--

DROP TABLE IF EXISTS `tamanos_empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tamanos_empresa` (
  `tamano_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_spanish_ci NOT NULL,
  `rango_empleados` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `rango_activos` varchar(100) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tamano_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tamanos_empresa`
--

LOCK TABLES `tamanos_empresa` WRITE;
/*!40000 ALTER TABLE `tamanos_empresa` DISABLE KEYS */;
INSERT INTO `tamanos_empresa` VALUES (1,'Microempresa','1-10 empleados',NULL,1,'2025-06-11 22:47:33'),(2,'Pequeña','11-50 empleados',NULL,1,'2025-06-11 22:47:33'),(3,'Mediana','51-200 empleados',NULL,1,'2025-06-11 22:47:33'),(4,'Grande','Más de 200 empleados',NULL,1,'2025-06-11 22:47:33');
/*!40000 ALTER TABLE `tamanos_empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_actividad`
--

DROP TABLE IF EXISTS `tipos_actividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_actividad` (
  `tipo_act_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `color` varchar(7) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tipo_act_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_actividad`
--

LOCK TABLES `tipos_actividad` WRITE;
/*!40000 ALTER TABLE `tipos_actividad` DISABLE KEYS */;
INSERT INTO `tipos_actividad` VALUES (1,'Capacitación','Sesiones de formación para estudiantes','#00CED1',1,'2025-06-11 23:00:10'),(2,'Seguimiento','Revisión de avance del estudiante','#FFD700',1,'2025-06-11 23:00:10');
/*!40000 ALTER TABLE `tipos_actividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_contacto`
--

DROP TABLE IF EXISTS `tipos_contacto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_contacto` (
  `tipo_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`tipo_id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_contacto`
--

LOCK TABLES `tipos_contacto` WRITE;
/*!40000 ALTER TABLE `tipos_contacto` DISABLE KEYS */;
INSERT INTO `tipos_contacto` VALUES (4,'Apoyo Administrativo'),(3,'Coordinador'),(2,'Responsable Empresarial'),(1,'Tutor Académico');
/*!40000 ALTER TABLE `tipos_contacto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_documento`
--

DROP TABLE IF EXISTS `tipos_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_documento` (
  `tipo_doc_id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_spanish_ci,
  `es_obligatorio` tinyint(1) DEFAULT '1',
  `formato_url` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tipo_doc_id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_documento`
--

LOCK TABLES `tipos_documento` WRITE;
/*!40000 ALTER TABLE `tipos_documento` DISABLE KEYS */;
INSERT INTO `tipos_documento` VALUES (1,'DOC001','Carta de Presentación','Documento inicial de contacto con la empresa',1,NULL,1,'2025-06-11 23:00:10'),(2,'DOC002','Convenio Firmado','Convenio entre institución y empresa',1,NULL,1,'2025-06-11 23:00:10');
/*!40000 ALTER TABLE `tipos_documento` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-26 21:47:19
