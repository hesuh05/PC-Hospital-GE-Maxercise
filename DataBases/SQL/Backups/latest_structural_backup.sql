CREATE DATABASE  IF NOT EXISTS `hospital_230028` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hospital_230028`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hospital_230028
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '8cb2df57-b846-11f0-83a8-ece3acb58681:1-176061,
b9484adc-edd3-11f0-9b0d-b96ae439718d:1-178350,
fbd456b3-0ada-11f1-a706-18c04d92525f:1-25537';

--
-- Table structure for table `tbb_ge_organo_inventario`
--

DROP TABLE IF EXISTS `tbb_ge_organo_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ge_organo_inventario` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Organo_ID` int unsigned NOT NULL,
  `Codigo_Rastreo` varchar(20) NOT NULL,
  `Fecha_Procuracion` datetime NOT NULL,
  `Fecha_Expiracion` datetime NOT NULL,
  `Estado` enum('Disponible','Reservado','En Trasplante','Usado','Descartado') NOT NULL DEFAULT 'Disponible',
  `Etnia` varchar(100) NOT NULL,
  `Grupo_Sanguineo` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `Metodo_Preservacion` varchar(100) DEFAULT NULL,
  `Observaciones` text,
  `Fecha_Registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `Estatus` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Codigo_Rastreo` (`Codigo_Rastreo`),
  KEY `fk_inv_organo` (`Organo_ID`),
  CONSTRAINT `fk_inv_organo` FOREIGN KEY (`Organo_ID`) REFERENCES `tbc_ge_organos` (`ID`),
  CONSTRAINT `chk_tiempos_viables` CHECK ((`Fecha_Expiracion` > `Fecha_Procuracion`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_ge_quejas_sugerencias`
--

DROP TABLE IF EXISTS `tbb_ge_quejas_sugerencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ge_quejas_sugerencias` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Tipo` enum('queja','sugerencia') NOT NULL,
  `Descripcion` text NOT NULL,
  `Estado` varchar(30) NOT NULL,
  `Persona_Fisica_ID` int unsigned NOT NULL,
  `Departamento_ID` int unsigned NOT NULL,
  `Fecha_Accion` datetime DEFAULT NULL,
  `Personal_Revisor_ID` int unsigned DEFAULT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  KEY `fk_qs_persona` (`Persona_Fisica_ID`),
  KEY `fk_qs_departamento` (`Departamento_ID`),
  KEY `fk_qs_revisor` (`Personal_Revisor_ID`),
  CONSTRAINT `fk_qs_departamento` FOREIGN KEY (`Departamento_ID`) REFERENCES `tbc_hr_departamentos` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_qs_persona` FOREIGN KEY (`Persona_Fisica_ID`) REFERENCES `tbb_hr_personas_fisicas` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_accion_revisor` CHECK (((`Fecha_Accion` is null) or (`Personal_Revisor_ID` is not null))),
  CONSTRAINT `chk_estado_queja` CHECK (((`Tipo` <> _utf8mb4'queja') or (`Estado` in (_utf8mb4'registrada',_utf8mb4'en_revision',_utf8mb4'en_proceso',_utf8mb4'resuelta',_utf8mb4'cerrada_sin_accion',_utf8mb4'rechazada')))),
  CONSTRAINT `chk_estado_sugerencia` CHECK (((`Tipo` <> _utf8mb4'sugerencia') or (`Estado` in (_utf8mb4'recibida',_utf8mb4'en_revision',_utf8mb4'evaluada',_utf8mb4'implementada',_utf8mb4'descartada'))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_hr_departamentos`
--

DROP TABLE IF EXISTS `tbb_hr_departamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_hr_departamentos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_hr_personal`
--

DROP TABLE IF EXISTS `tbb_hr_personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_hr_personal` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Departamento_ID` int unsigned NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL,
  `Numero_Empleado` int DEFAULT NULL,
  `Puesto` varchar(80) NOT NULL,
  `Tipo_Contrato` enum('BASE','EVENTUAL','HONORARIOS') NOT NULL,
  `Fecha_Ingreso` date NOT NULL,
  `Fecha_Baja` date DEFAULT NULL,
  `Salario` decimal(10,2) DEFAULT NULL,
  `Fecha_Actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `numero_empleado_UNIQUE` (`Numero_Empleado`),
  KEY `fk_personal_departamentos_idx` (`Departamento_ID`),
  CONSTRAINT `fk_personal_departamentos` FOREIGN KEY (`Departamento_ID`) REFERENCES `tbc_hr_departamentos` (`ID`),
  CONSTRAINT `Persona_Fisica_Id` FOREIGN KEY (`ID`) REFERENCES `tbb_hr_personas_fisicas` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_hr_personal_medico`
--

DROP TABLE IF EXISTS `tbb_hr_personal_medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_hr_personal_medico` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_hr_personas`
--

DROP TABLE IF EXISTS `tbb_hr_personas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_hr_personas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `tipo` enum('Fisica','Moral') NOT NULL DEFAULT 'Fisica',
  `rfc` varchar(14) DEFAULT NULL,
  `pais_origen` varchar(50) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_personas_rfc` (`rfc`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_personas_AFTER_INSERT` AFTER INSERT ON `tbb_hr_personas` FOR EACH ROW BEGIN
    INSERT INTO tbi_bitacora (Nombre_Tabla, Usuario, Operacion, Descripcion)
    VALUES (
        'tbb_personas',
        USER(),
        'Insert',
        CONCAT('Se ha insertado una nueva persona con el ID: ', NEW.id)
    );
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_personas_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_hr_personas` FOR EACH ROW BEGIN
    SET NEW.fecha_actualizacion = NOW();
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_personas_AFTER_UPDATE` AFTER UPDATE ON `tbb_hr_personas` FOR EACH ROW BEGIN
    INSERT INTO tbi_bitacora (Nombre_Tabla, Usuario, Operacion, Descripcion)
    VALUES (
        'tbb_personas',
        USER(),
        'Update',
        CONCAT('Se han actualizado los datos de la persona con el ID: ', NEW.id)
    );
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_personas_BEFORE_DELETE` BEFORE DELETE ON `tbb_hr_personas` FOR EACH ROW BEGIN
    INSERT INTO tbi_bitacora (Nombre_Tabla, Usuario, Operacion, Descripcion)
    VALUES (
        'tbb_personas',
        USER(),
        'Delete',
        CONCAT('Se ha borrado la persona con el ID: ', OLD.id)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_hr_personas_fisicas`
--

DROP TABLE IF EXISTS `tbb_hr_personas_fisicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_hr_personas_fisicas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `titulo_cortesia` varchar(40) DEFAULT NULL,
  `nombre` varchar(45) NOT NULL,
  `primer_apellido` varchar(45) NOT NULL,
  `segundo_apellido` varchar(45) DEFAULT NULL,
  `genero` enum('H','M','N/B') NOT NULL DEFAULT 'N/B',
  `fecha_nacimiento` date NOT NULL,
  `curp` varchar(18) DEFAULT NULL,
  `grupo_sanguineo` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_personas_fisicas_curp` (`curp`),
  CONSTRAINT `fk_persona_1` FOREIGN KEY (`ID`) REFERENCES `tbb_hr_personas` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_defunciones`
--

DROP TABLE IF EXISTS `tbb_md_defunciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_defunciones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_diagnosticos`
--

DROP TABLE IF EXISTS `tbb_md_diagnosticos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_diagnosticos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_documentos_oficiales`
--

DROP TABLE IF EXISTS `tbb_md_documentos_oficiales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_documentos_oficiales` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_expedientes_medicos`
--

DROP TABLE IF EXISTS `tbb_md_expedientes_medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_expedientes_medicos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_nacimientos`
--

DROP TABLE IF EXISTS `tbb_md_nacimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_nacimientos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_notas_medicas`
--

DROP TABLE IF EXISTS `tbb_md_notas_medicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_notas_medicas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_pacientes`
--

DROP TABLE IF EXISTS `tbb_md_pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_pacientes` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `estatus_medico` varchar(150) DEFAULT NULL,
  `estatus_vida` enum('Vivo','Finado','Coma','Vegetativo','Desconocido') NOT NULL DEFAULT 'Desconocido',
  `fecha_ultima_citamedica` datetime DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  `situacion_medica` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `fk_persona_fisica` FOREIGN KEY (`ID`) REFERENCES `tbb_hr_personas_fisicas` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_md_tratamientos`
--

DROP TABLE IF EXISTS `tbb_md_tratamientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_md_tratamientos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_mr_personas_morales`
--

DROP TABLE IF EXISTS `tbb_mr_personas_morales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_mr_personas_morales` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  `razon_social` varchar(45) DEFAULT NULL,
  `tipo` varchar(45) DEFAULT NULL,
  `fecha_creacion` varchar(45) DEFAULT NULL,
  `responsabilidad` varchar(100) DEFAULT NULL,
  `capacidad_juridica` varchar(100) DEFAULT NULL,
  `patrimonio` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_mr_proveedores`
--

DROP TABLE IF EXISTS `tbb_mr_proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_mr_proveedores` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_mr_transacciones_financieras`
--

DROP TABLE IF EXISTS `tbb_mr_transacciones_financieras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_mr_transacciones_financieras` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_ms_dietas`
--

DROP TABLE IF EXISTS `tbb_ms_dietas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ms_dietas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_ms_transfusiones_sanguineas`
--

DROP TABLE IF EXISTS `tbb_ms_transfusiones_sanguineas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ms_transfusiones_sanguineas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_ms_traslados`
--

DROP TABLE IF EXISTS `tbb_ms_traslados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ms_traslados` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_ms_valoraciones`
--

DROP TABLE IF EXISTS `tbb_ms_valoraciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ms_valoraciones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbb_ph_recetas_medicas`
--

DROP TABLE IF EXISTS `tbb_ph_recetas_medicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_ph_recetas_medicas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ge_areas`
--

DROP TABLE IF EXISTS `tbc_ge_areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ge_areas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(80) NOT NULL,
  `Descripcion` text,
  `Espacio_ID` int unsigned NOT NULL,
  `Personal_Responsable_ID` int unsigned NOT NULL,
  `Area_Superior_ID` int unsigned DEFAULT NULL,
  `Estatus_Operacion` enum('Activa','Inactiva','Suspendida','Cancelada') NOT NULL DEFAULT 'Activa',
  `Total_Empleados` int unsigned NOT NULL DEFAULT '0',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nombre` (`Nombre`),
  UNIQUE KEY `uq_ge_areas_nombre` (`Nombre`),
  KEY `fk_areasuperior` (`Area_Superior_ID`),
  KEY `fk_ge_espacio` (`Espacio_ID`),
  KEY `fk_ge_personal_responsable` (`Personal_Responsable_ID`),
  CONSTRAINT `fk_ge_area_superior` FOREIGN KEY (`Area_Superior_ID`) REFERENCES `tbc_ge_areas` (`ID`),
  CONSTRAINT `fk_ge_areas_superior` FOREIGN KEY (`Area_Superior_ID`) REFERENCES `tbc_ge_areas` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ge_espacio` FOREIGN KEY (`Espacio_ID`) REFERENCES `tbc_mr_espacios` (`ID`),
  CONSTRAINT `fk_ge_personal_responsable` FOREIGN KEY (`Personal_Responsable_ID`) REFERENCES `tbb_hr_personal` (`ID`),
  CONSTRAINT `chk_ge_areas_empleados` CHECK ((`Total_Empleados` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ge_organos`
--

DROP TABLE IF EXISTS `tbc_ge_organos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ge_organos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(80) NOT NULL,
  `Descripcion` text,
  `Funcion` text,
  `Sistema` varchar(45) DEFAULT NULL,
  `Aparato` varchar(45) DEFAULT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ge_patologias`
--

DROP TABLE IF EXISTS `tbc_ge_patologias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ge_patologias` (
  `Patologia_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(150) NOT NULL,
  `Nombre_Cientifico` varchar(150) NOT NULL,
  `Descripcion` text,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`Patologia_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ge_servicios`
--

DROP TABLE IF EXISTS `tbc_ge_servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ge_servicios` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Area_ID` int unsigned NOT NULL,
  `Nombre` varchar(80) NOT NULL,
  `Descripcion` text,
  `Nivel` enum('Basico','Especializado','Alta Especialidad') NOT NULL DEFAULT 'Basico',
  `Costo` tinyint NOT NULL DEFAULT '0',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  KEY `fk_servicio_area_idx` (`Area_ID`),
  CONSTRAINT `fk_servicio_area` FOREIGN KEY (`Area_ID`) REFERENCES `tbc_ge_areas` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_ge_servicios_costo` CHECK ((`Costo` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ge_tipos_patologias`
--

DROP TABLE IF EXISTS `tbc_ge_tipos_patologias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ge_tipos_patologias` (
  `Tipo_Patologia_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(80) NOT NULL,
  `Descripcion` text,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`Tipo_Patologia_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_hr_departamentos`
--

DROP TABLE IF EXISTS `tbc_hr_departamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_hr_departamentos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(80) NOT NULL,
  `Descripcion` text,
  `Area_ID` int unsigned NOT NULL,
  `Responsable_Personal_ID` int unsigned NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  KEY `fk_departamentos_area` (`Area_ID`),
  KEY `fk_departamentos_responsable` (`Responsable_Personal_ID`),
  CONSTRAINT `fk_departamentos_area` FOREIGN KEY (`Area_ID`) REFERENCES `tbc_ge_areas` (`ID`),
  CONSTRAINT `fk_departamentos_responsable` FOREIGN KEY (`Responsable_Personal_ID`) REFERENCES `tbb_hr_personal` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_md_signos_vitales`
--

DROP TABLE IF EXISTS `tbc_md_signos_vitales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_md_signos_vitales` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_mr_equipamientos`
--

DROP TABLE IF EXISTS `tbc_mr_equipamientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_mr_equipamientos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_mr_espacios`
--

DROP TABLE IF EXISTS `tbc_mr_espacios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_mr_espacios` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ms_cirugias`
--

DROP TABLE IF EXISTS `tbc_ms_cirugias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ms_cirugias` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ms_servicios_medicos`
--

DROP TABLE IF EXISTS `tbc_ms_servicios_medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ms_servicios_medicos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbc_ph_medicamentos`
--

DROP TABLE IF EXISTS `tbc_ph_medicamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ph_medicamentos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ge_aprobaciones`
--

DROP TABLE IF EXISTS `tbd_ge_aprobaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ge_aprobaciones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Personal_ID` int unsigned NOT NULL,
  `Servicio_ID` int unsigned NOT NULL,
  `Estatus_Aprobacion` enum('Registrado','Aprobado','Rechazado','En espera','Cancelado') DEFAULT 'Registrado',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Servicio_Descripcion` int NOT NULL,
  `Estatus` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `fk_aprobaciones_descripcion_idx` (`Servicio_Descripcion`),
  KEY `fk_aprobaciones_servicio_idx` (`Servicio_ID`),
  KEY `fk_aprobaciones_personal_idx` (`Personal_ID`),
  CONSTRAINT `fk_aprobaciones_personal` FOREIGN KEY (`Personal_ID`) REFERENCES `tbb_hr_personal` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_aprobaciones_servicio` FOREIGN KEY (`Servicio_ID`) REFERENCES `tbc_ge_servicios` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ge_patologias_tipos`
--

DROP TABLE IF EXISTS `tbd_ge_patologias_tipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ge_patologias_tipos` (
  `Patologia_Tipo_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Patologia_ID` int unsigned NOT NULL,
  `Tipo_Patologia_ID` int unsigned NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`Patologia_Tipo_ID`),
  KEY `fk_patologia_maestra` (`Patologia_ID`),
  KEY `fk_tipo_clasificacion` (`Tipo_Patologia_ID`),
  CONSTRAINT `fk_patologia_maestra` FOREIGN KEY (`Patologia_ID`) REFERENCES `tbc_ge_patologias` (`Patologia_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_tipo_clasificacion` FOREIGN KEY (`Tipo_Patologia_ID`) REFERENCES `tbc_ge_tipos_patologias` (`Tipo_Patologia_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ge_solicitudes_servicios`
--

DROP TABLE IF EXISTS `tbd_ge_solicitudes_servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ge_solicitudes_servicios` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Servicio_ID` int unsigned NOT NULL,
  `Persona_ID` int unsigned NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  KEY `fk_solicitud_servicio` (`Servicio_ID`),
  KEY `fk_solicitud_persona` (`Persona_ID`),
  CONSTRAINT `fk_solicitud_persona` FOREIGN KEY (`Persona_ID`) REFERENCES `tbb_hr_personas` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_solicitud_servicio` FOREIGN KEY (`Servicio_ID`) REFERENCES `tbc_ge_servicios` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_hr_horarios`
--

DROP TABLE IF EXISTS `tbd_hr_horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_hr_horarios` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_md_padecimientos`
--

DROP TABLE IF EXISTS `tbd_md_padecimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_md_padecimientos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_mr_accesos`
--

DROP TABLE IF EXISTS `tbd_mr_accesos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_mr_accesos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Persona_ID` int unsigned NOT NULL,
  `Fecha_Registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `Espacio_ID` int unsigned NOT NULL,
  `Tipo` enum('Entrada','Salida') NOT NULL DEFAULT 'Entrada',
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Personal_ID_autoriza` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_mr_inventario_equipamientos`
--

DROP TABLE IF EXISTS `tbd_mr_inventario_equipamientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_mr_inventario_equipamientos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ms_campanias`
--

DROP TABLE IF EXISTS `tbd_ms_campanias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ms_campanias` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(150) NOT NULL,
  `Descripcion` text NOT NULL,
  `Departamento_ID` int unsigned NOT NULL,
  `Personal_ID_Responsable` int unsigned NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Fin` datetime DEFAULT NULL,
  `Estatus_Realizacion` enum('Programada','Realizada','Finalizada','Cancelada','Aprobada','Activa','Inactiva') DEFAULT 'Programada',
  `Estatus` bit(1) DEFAULT b'1',
  `Tipo` enum('Preventiva','Diagnostica','Terapeutica','Especializada','General') NOT NULL DEFAULT 'General',
  `Observaciones` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ms_citas_medicas`
--

DROP TABLE IF EXISTS `tbd_ms_citas_medicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ms_citas_medicas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ph_inventario_medicamentos`
--

DROP TABLE IF EXISTS `tbd_ph_inventario_medicamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ph_inventario_medicamentos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbd_ph_lotes_medicamentos`
--

DROP TABLE IF EXISTS `tbd_ph_lotes_medicamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_ph_lotes_medicamentos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbi_bitacora`
--

DROP TABLE IF EXISTS `tbi_bitacora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbi_bitacora` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Descripcion` text NOT NULL,
  `Usuario` varchar(80) NOT NULL,
  `Nombre_Tabla` varchar(80) NOT NULL,
  `Fecha_Hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Operacion` enum('Insert','Update','Delete') NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3489731 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vista_tablas`
--

DROP TABLE IF EXISTS `vista_tablas`;
/*!50001 DROP VIEW IF EXISTS `vista_tablas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_tablas` AS SELECT 
 1 AS `entidad`,
 1 AS `tabla`,
 1 AS `tipo_jerarquia`,
 1 AS `percepcion`,
 1 AS `tipo_dependencia`,
 1 AS `tipo_nomenclatura`,
 1 AS `dueño`,
 1 AS `editor`,
 1 AS `lector`,
 1 AS `sin_acceso`,
 1 AS `total_registros`,
 1 AS `tamanio_aproximado_MB`,
 1 AS `total_columnas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_grants_por_roles`
--

DROP TABLE IF EXISTS `vw_grants_por_roles`;
/*!50001 DROP VIEW IF EXISTS `vw_grants_por_roles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_grants_por_roles` AS SELECT 
 1 AS `linea`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_roles_usuarios`
--

DROP TABLE IF EXISTS `vw_roles_usuarios`;
/*!50001 DROP VIEW IF EXISTS `vw_roles_usuarios`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_roles_usuarios` AS SELECT 
 1 AS `usuario`,
 1 AS `host`,
 1 AS `roles_asignados`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'hospital_230028'
--

--
-- Dumping routines for database 'hospital_230028'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_apellido_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_apellido_random`() RETURNS varchar(60) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE r INT;

    -- Índice seguro: 1 a 80
    SET r = FLOOR(RAND() * 80) + 1;

    RETURN CASE r
        WHEN 1 THEN 'García'
        WHEN 2 THEN 'Hernández'
        WHEN 3 THEN 'Martínez'
        WHEN 4 THEN 'López'
        WHEN 5 THEN 'González'
        WHEN 6 THEN 'Pérez'
        WHEN 7 THEN 'Ramírez'
        WHEN 8 THEN 'Flores'
        WHEN 9 THEN 'Torres'
        WHEN 10 THEN 'Cruz'
        WHEN 11 THEN 'Reyes'
        WHEN 12 THEN 'Morales'
        WHEN 13 THEN 'Vázquez'
        WHEN 14 THEN 'Castillo'
        WHEN 15 THEN 'Jiménez'
        WHEN 16 THEN 'Rojas'
        WHEN 17 THEN 'Mendoza'
        WHEN 18 THEN 'Ortiz'
        WHEN 19 THEN 'Chávez'
        WHEN 20 THEN 'Aguilar'
        WHEN 21 THEN 'Sánchez'
        WHEN 22 THEN 'Romero'
        WHEN 23 THEN 'Álvarez'
        WHEN 24 THEN 'Ruiz'
        WHEN 25 THEN 'Delgado'
        WHEN 26 THEN 'Guerrero'
        WHEN 27 THEN 'Navarro'
        WHEN 28 THEN 'Ramos'
        WHEN 29 THEN 'Medina'
        WHEN 30 THEN 'Vega'
        WHEN 31 THEN 'Salazar'
        WHEN 32 THEN 'Pacheco'
        WHEN 33 THEN 'Ibarra'
        WHEN 34 THEN 'Montoya'
        WHEN 35 THEN 'Aguirre'
        WHEN 36 THEN 'Valdez'
        WHEN 37 THEN 'Carrillo'
        WHEN 38 THEN 'Peña'
        WHEN 39 THEN 'Soto'
        WHEN 40 THEN 'Campos'
        WHEN 41 THEN 'Cervantes'
        WHEN 42 THEN 'Mejía'
        WHEN 43 THEN 'Fuentes'
        WHEN 44 THEN 'Guzmán'
        WHEN 45 THEN 'Zamora'
        WHEN 46 THEN 'Padilla'
        WHEN 47 THEN 'Escobar'
        WHEN 48 THEN 'Luna'
        WHEN 49 THEN 'Arias'
        WHEN 50 THEN 'Cortés'
        WHEN 51 THEN 'Figueroa'
        WHEN 52 THEN 'Núñez'
        WHEN 53 THEN 'Acosta'
        WHEN 54 THEN 'Peralta'
        WHEN 55 THEN 'Solís'
        WHEN 56 THEN 'Treviño'
        WHEN 57 THEN 'Cárdenas'
        WHEN 58 THEN 'Palacios'
        WHEN 59 THEN 'Márquez'
        WHEN 60 THEN 'Rosales'
        WHEN 61 THEN 'Beltrán'
        WHEN 62 THEN 'Saucedo'
        WHEN 63 THEN 'Zúñiga'
        WHEN 64 THEN 'Coronado'
        WHEN 65 THEN 'Villanueva'
        WHEN 66 THEN 'Franco'
        WHEN 67 THEN 'Molina'
        WHEN 68 THEN 'Cuevas'
        WHEN 69 THEN 'Esparza'
        WHEN 70 THEN 'Rentería'
        WHEN 71 THEN 'Bustamante'
        WHEN 72 THEN 'Gallegos'
        WHEN 73 THEN 'Tapia'
        WHEN 74 THEN 'Pineda'
        WHEN 75 THEN 'León'
        WHEN 76 THEN 'Arellano'
        WHEN 77 THEN 'Toledo'
        WHEN 78 THEN 'Camacho'
        WHEN 79 THEN 'Olvera'
        WHEN 80 THEN 'Bautista'
        ELSE 'X'  -- blindaje absoluto
    END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_clasificar_edad_por_dias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_clasificar_edad_por_dias`(
    p_edad_dias INT
) RETURNS varchar(30) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    IF p_edad_dias IS NULL OR p_edad_dias < 0 THEN
        RETURN NULL;
    END IF;

    RETURN
        CASE
            WHEN p_edad_dias <= 28 THEN 'neonato'
            WHEN p_edad_dias <= 1824 THEN 'infante'
            WHEN p_edad_dias <= 4015 THEN 'niñez'
            WHEN p_edad_dias <= 4745 THEN 'preadolescente'
            WHEN p_edad_dias <= 6570 THEN 'adolescente'
            WHEN p_edad_dias <= 8030 THEN 'joven'
            WHEN p_edad_dias <= 14235 THEN 'adulto joven'
            WHEN p_edad_dias <= 21535 THEN 'adulto'
            ELSE 'adulto mayor'
        END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_codigo_rastreo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_codigo_rastreo`() RETURNS varchar(20) CHARSET utf8mb4
    DETERMINISTIC
BEGIN

RETURN CONCAT(
'ORG',
SUBSTRING(REPLACE(UUID(),'-',''),1,8)
);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_decidir_titulo_profesional` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_decidir_titulo_profesional`(
    p_edad INT,
    p_modo INT
) RETURNS varchar(20) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_modo INT;
    DECLARE v_titulo VARCHAR(20);

    /* NULL = random */
    SET v_modo = IFNULL(p_modo, 0);

    /* Menores de edad profesional */
    IF p_edad < 23 THEN
        RETURN NULL;
    END IF;

    /* Ninguno */
    IF v_modo = -1 THEN
        RETURN NULL;
    END IF;

    /* Random: moneda */
    IF v_modo = 0 AND RAND() >= 0.5 THEN
        RETURN NULL;
    END IF;

    /* Elegibles siempre reciben título */
    SET v_titulo =
        CASE
            WHEN p_edad >= 30 THEN
                ELT(FLOOR(RAND()*4)+1,
                    'Lic.', 'Ing.', 'Mtro.', 'Dr.')
            WHEN p_edad >= 26 THEN
                ELT(FLOOR(RAND()*3)+1,
                    'Lic.', 'Ing.', 'Mtro.')
            ELSE
                ELT(FLOOR(RAND()*2)+1,
                    'Lic.', 'Ing.')
        END;

    RETURN v_titulo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_etnia_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_etnia_random`() RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    DECLARE v_rand FLOAT;
    SET v_rand = RAND();

    RETURN CASE
        WHEN v_rand < 0.70 THEN 'Mestizo'
        WHEN v_rand < 0.90 THEN 'Indigena'
        WHEN v_rand < 0.94 THEN 'Europeo'
        WHEN v_rand < 0.97 THEN 'Afrodescendiente'
        WHEN v_rand < 0.99 THEN 'Asiatico'
        ELSE 'Medio Oriente'
    END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_fecha_expiracion_organo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_fecha_expiracion_organo`(
    p_fecha_proc DATETIME,
    p_organo INT
) RETURNS datetime
    DETERMINISTIC
BEGIN

    DECLARE v_horas INT;
    DECLARE v_offset INT;

    SET v_horas = fn_horas_viabilidad_organo(p_organo);

    -- mínimo 1 hora para cumplir CHECK
    SET v_offset = FLOOR(RAND()*v_horas) + 1;

    RETURN DATE_ADD(
        p_fecha_proc,
        INTERVAL v_offset HOUR
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_fecha_nacimiento_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_fecha_nacimiento_random`(
    p_edad_min INT,
    p_edad_max INT
) RETURNS date
    DETERMINISTIC
BEGIN
    DECLARE v_min INT;
    DECLARE v_max INT;
    DECLARE v_dias INT;

    SET v_min = IFNULL(p_edad_min, 0);
    SET v_max = IFNULL(p_edad_max, 120);

    SET v_dias =
        FLOOR(RAND() * ((v_max - v_min + 1) * 365))
        + (v_min * 365);

    RETURN DATE_SUB(CURDATE(), INTERVAL v_dias DAY);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_fecha_procuracion_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_fecha_procuracion_random`() RETURNS datetime
    DETERMINISTIC
BEGIN

    RETURN DATE_SUB(
        NOW(),
        INTERVAL FLOOR(RAND()*48) HOUR
    );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_fecha_valida` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_fecha_valida`(p_fecha DATE) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    RETURN p_fecha IS NOT NULL
       AND p_fecha <= CURDATE()
       AND p_fecha >= '1900-01-01';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_curp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_curp`(
    p_nombre VARCHAR(60),
    p_ap_p VARCHAR(60),
    p_ap_m VARCHAR(60),
    p_fecha_nacimiento DATE,
    p_genero ENUM('H','M','N/B')
) RETURNS char(18) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_ap_p VARCHAR(60);
    DECLARE v_ap_m VARCHAR(60);
    DECLARE v_nom  VARCHAR(60);

    DECLARE v_c1 CHAR(1);
    DECLARE v_c2 CHAR(1);
    DECLARE v_c3 CHAR(1);

    /* Normalización RENAPO (acentos y Ñ) */
    SET v_ap_p = UPPER(IFNULL(p_ap_p,'X'));
    SET v_ap_m = UPPER(IFNULL(p_ap_m,'X'));
    SET v_nom  = UPPER(IFNULL(p_nombre,'X'));

    SET v_ap_p = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(v_ap_p,'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U');
    SET v_ap_m = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(v_ap_m,'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U');
    SET v_nom  = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(v_nom ,'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U');

    SET v_ap_p = REPLACE(v_ap_p,'Ñ','X');
    SET v_ap_m = REPLACE(v_ap_m,'Ñ','X');
    SET v_nom  = REPLACE(v_nom ,'Ñ','X');

    /* Consonantes internas reales */
    SET v_c1 = IFNULL(REGEXP_SUBSTR(SUBSTRING(v_ap_p,2),'[BCDFGHJKLMNPQRSTVWXYZ]'),'X');
    SET v_c2 = IFNULL(REGEXP_SUBSTR(SUBSTRING(v_ap_m,2),'[BCDFGHJKLMNPQRSTVWXYZ]'),'X');
    SET v_c3 = IFNULL(REGEXP_SUBSTR(SUBSTRING(v_nom ,2),'[BCDFGHJKLMNPQRSTVWXYZ]'),'X');

    RETURN CONCAT(
        LEFT(v_ap_p,1),
        IFNULL(REGEXP_SUBSTR(SUBSTRING(v_ap_p,2),'[AEIOU]'),'X'),
        LEFT(v_ap_m,1),
        LEFT(v_nom,1),
        DATE_FORMAT(p_fecha_nacimiento,'%y%m%d'),
        IF(p_genero='H','H','M'),
        'NE',
        v_c1, v_c2, v_c3,
        CHAR(FLOOR(65 + RAND()*26)),
        FLOOR(RAND()*10)
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_dias_edad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_dias_edad`(
    p_tipo_edad VARCHAR(20),
    p_edad_min INT,
    p_edad_max INT
) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_total_dias INT;
    
    /* ============================================================
       PRIORIDAD 1: TIPO DE EDAD ESPECÍFICO
       Genera edad en DÍAS según la categoría solicitada
       ============================================================ */
    IF p_tipo_edad IS NOT NULL THEN
        SET v_total_dias =
            CASE p_tipo_edad
				/* 0 dias */
				WHEN 'recien nacido' THEN
					0

                /* 0 – 28 días  |  0 – 0 años */
                WHEN 'neonato' THEN 
                    FLOOR(RAND() * 29)

                /* 29 – 1824 días  |  1 mes – 4 años */
                WHEN 'infante' THEN 
                    FLOOR(RAND() * (1824 - 29 + 1)) + 29

                /* 1825 – 4015 días  |  5 – 10 años */
                WHEN 'niñez' THEN   
                    FLOOR(RAND() * (4015 - 1825 + 1)) + 1825

                /* 4016 – 4745 días  |  11 – 12 años */
                WHEN 'preadolescente' THEN 
                    FLOOR(RAND() * (4745 - 4016 + 1)) + 4016

                /* 4746 – 6570 días  |  13 – 17 años */
                WHEN 'adolescente' THEN 
                    FLOOR(RAND() * (6570 - 4746 + 1)) + 4746

                /* 0 – 6570 días  |  0 – 17 años (TODAS LAS CATEGORÍAS PEDIÁTRICAS) */
                WHEN 'pediatrico' THEN 
                    FLOOR(RAND() * (6570 + 1))

                /* 6571 – 8030 días  |  18 – 22 años */
                WHEN 'joven' THEN 
                    FLOOR(RAND() * (8030 - 6571 + 1)) + 6571

                /* 8031 – 14235 días  |  23 – 39 años */
                WHEN 'adulto joven' THEN 
                    FLOOR(RAND() * (14235 - 8031 + 1)) + 8031

                /* 14236 – 21535 días  |  40 – 59 años */
                WHEN 'adulto' THEN 
                    FLOOR(RAND() * (21535 - 14236 + 1)) + 14236

                /* 21536 – 43800 días  |  60 – 120 años */
                WHEN 'adulto mayor' THEN 
                    FLOOR(RAND() * (43800 - 21536 + 1)) + 21536

                ELSE NULL
            END;

        RETURN v_total_dias;
    END IF;

    /* ============================================================
       PRIORIDAD 2: RANGO PERSONALIZADO (EN AÑOS)
       Convierte rango de años a días automáticamente
       ============================================================ */
    IF p_edad_min IS NOT NULL OR p_edad_max IS NOT NULL THEN
        SET v_total_dias =
            FLOOR(
                RAND() *
                ((IFNULL(p_edad_max,120) - IFNULL(p_edad_min,0) + 1) * 365)
            )
            + IFNULL(p_edad_min,0) * 365;

        RETURN v_total_dias;
    END IF;

   /* ============================================================
   PRIORIDAD 3: TOTALMENTE ALEATORIO (DISTRIBUCIÓN REALISTA)
   Hospital con 50 años de operación

   Distribución simulada:
   -----------------------------------------
   5%   Neonatos
   8%   Infantes
   7%   Niñez
   5%   Preadolescente
   5%   Adolescente
   10%  Joven
   25%  Adulto joven
   25%  Adulto
   10%  Adulto mayor
   -----------------------------------------
   Total = 100%
   ============================================================ */

SET @v_rand := RAND();

IF @v_rand < 0.05 THEN
    -- 5% Neonatos (0–28 días)
    SET v_total_dias = FLOOR(RAND() * 29);

ELSEIF @v_rand < 0.13 THEN
    -- 8% Infantes (29–1824 días)
    SET v_total_dias = FLOOR(RAND() * (1824 - 29 + 1)) + 29;

ELSEIF @v_rand < 0.20 THEN
    -- 7% Niñez (5–10 años)
    SET v_total_dias = FLOOR(RAND() * (4015 - 1825 + 1)) + 1825;

ELSEIF @v_rand < 0.25 THEN
    -- 5% Preadolescente (11–12 años)
    SET v_total_dias = FLOOR(RAND() * (4745 - 4016 + 1)) + 4016;

ELSEIF @v_rand < 0.30 THEN
    -- 5% Adolescente (13–17 años)
    SET v_total_dias = FLOOR(RAND() * (6570 - 4746 + 1)) + 4746;

ELSEIF @v_rand < 0.40 THEN
    -- 10% Joven (18–22 años)
    SET v_total_dias = FLOOR(RAND() * (8030 - 6571 + 1)) + 6571;

ELSEIF @v_rand < 0.65 THEN
    -- 25% Adulto joven (23–39 años)
    SET v_total_dias = FLOOR(RAND() * (14235 - 8031 + 1)) + 8031;

ELSEIF @v_rand < 0.90 THEN
    -- 25% Adulto (40–59 años)
    SET v_total_dias = FLOOR(RAND() * (21535 - 14236 + 1)) + 14236;

ELSE
    -- 10% Adulto mayor (60–120 años)
    SET v_total_dias = FLOOR(RAND() * (43800 - 21536 + 1)) + 21536;
END IF;

RETURN v_total_dias;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_estado_organo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_estado_organo`(
    p_modo INT,
    p_forzado VARCHAR(30)
) RETURNS varchar(30) CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    DECLARE v_rand FLOAT;

    IF p_modo = -1 THEN
        RETURN NULL;
    END IF;

    IF p_modo = 1 THEN
        RETURN p_forzado;
    END IF;

    SET v_rand = RAND();

    RETURN CASE
        WHEN v_rand < 0.45 THEN 'Disponible'
        WHEN v_rand < 0.65 THEN 'Reservado'
        WHEN v_rand < 0.75 THEN 'En Trasplante'
        WHEN v_rand < 0.95 THEN 'Usado'
        ELSE 'Descartado'
    END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_estatus_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_estatus_medico`(
    p_edad INT,
    p_estatus_vida ENUM('Vivo','Finado','Coma','Vegetativo','Desconocido'),
    p_modo INT,
    p_estatus_forzado VARCHAR(50)
) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_rand FLOAT;
    
    IF p_modo = -1 THEN
        RETURN NULL;
    END IF;

    IF p_modo = 1 THEN
        RETURN p_estatus_forzado;
    END IF;
    
    /* -------------------------
   ESTATUS DE VIDA CRÍTICO
	--------------------------*/
	IF p_estatus_vida = 'Finado' THEN
		RETURN NULL;
	END IF;

	IF p_estatus_vida = 'Vegetativo' THEN
		RETURN 'Estado vegetativo';
	END IF;

	IF p_estatus_vida = 'Coma' THEN
		SET v_rand = RAND();
		RETURN CASE
			WHEN v_rand < 0.70 THEN 'Coma'
			ELSE 'Coma inducido'
		END;
	END IF;


    /* -------------------------
       MODO
    --------------------------*/
    

    SET v_rand = RAND();

    /* -------------------------
       VIVO → POR EDAD
    --------------------------*/
    IF p_edad < 18 THEN
        RETURN CASE
            WHEN v_rand < 0.50 THEN 'Estable'
            WHEN v_rand < 0.70 THEN 'En tratamiento'
            WHEN v_rand < 0.90 THEN 'Recuperación'
            WHEN v_rand < 0.98 THEN 'Hospitalización general'
            ELSE 'Observación pediátrica'
        END;

    ELSEIF p_edad < 60 THEN
        RETURN CASE
            WHEN v_rand < 0.60 THEN 'Estable'
            WHEN v_rand < 0.80 THEN 'En tratamiento'
            WHEN v_rand < 0.95 THEN 'Recuperación'
            ELSE 'Hospitalización general'
        END;

    ELSE
        RETURN CASE
            WHEN v_rand < 0.40 THEN 'Estable'
            WHEN v_rand < 0.60 THEN 'En tratamiento'
            WHEN v_rand < 0.75 THEN 'Recuperación'
            WHEN v_rand < 0.85 THEN 'Hospitalización general'
            WHEN v_rand < 0.95 THEN 'Crónico controlado'
            ELSE 'Cuidados paliativos'
        END;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_estatus_vida` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_estatus_vida`(
    p_estatus_vida ENUM('Vivo','Finado','Coma','Vegetativo','Desconocido')
) RETURNS enum('Vivo','Finado','Coma','Vegetativo','Desconocido') CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_rand FLOAT;
    
    IF p_estatus_vida IS NOT NULL THEN
        RETURN p_estatus_vida;
    END IF;

    SET v_rand = RAND();

    RETURN CASE
    WHEN v_rand < 0.965 THEN 'Vivo'              -- 96.5%
    WHEN v_rand < 0.990 THEN 'Finado'            -- 2.5%
    WHEN v_rand < 0.994 THEN 'Coma'              -- 0.4%
    WHEN v_rand < 0.997 THEN 'Vegetativo'        -- 0.3%
    ELSE 'Desconocido'                           -- 0.3%
END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_etnia_modo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_etnia_modo`(
    p_modo INT,
    p_etnia_forzada VARCHAR(100)
) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    IF p_modo = -1 THEN
        RETURN NULL;
    END IF;

    IF p_modo = 1 THEN
        RETURN p_etnia_forzada;
    END IF;

    RETURN fn_etnia_random();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_grupo_sanguineo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_grupo_sanguineo`() RETURNS enum('A+','A-','B+','B-','AB+','AB-','O+','O-') CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_rand FLOAT;
    SET v_rand = RAND();

    RETURN CASE
        WHEN v_rand < 0.5909 THEN 'O+'
        WHEN v_rand < 0.8532 THEN 'A+'     -- 0.5909 + 0.2623
        WHEN v_rand < 0.9385 THEN 'B+'     -- 0.8532 + 0.0853
        WHEN v_rand < 0.9558 THEN 'AB+'    -- 0.9385 + 0.0173
        WHEN v_rand < 0.9758 THEN 'O-'     -- 0.9558 + 0.02
        WHEN v_rand < 0.9879 THEN 'A-'     -- 0.9758 + 0.0121
        WHEN v_rand < 0.9919 THEN 'B-'     -- 0.9879 + 0.004
        ELSE 'AB-'                         -- 0.9919 + 0.0008
    END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_grupo_sanguineo_modo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_grupo_sanguineo_modo`(
    p_modo INT,
    p_forzado ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-')
) RETURNS enum('A+','A-','B+','B-','AB+','AB-','O+','O-') CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    IF p_modo = -1 THEN
        RETURN NULL;
    END IF;

    IF p_modo = 1 THEN
        RETURN p_forzado;
    END IF;

    RETURN fn_generar_grupo_sanguineo();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_observacion_organo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_observacion_organo`(
    p_estado VARCHAR(30),
    p_modo INT
) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    DECLARE v_rand FLOAT;

    IF p_modo = -1 THEN
        RETURN NULL;
    END IF;

    IF p_modo = 1 THEN
        RETURN CASE p_estado
            WHEN 'Disponible' THEN 'Órgano viable para trasplante'
            WHEN 'Reservado' THEN 'Órgano asignado a receptor'
            WHEN 'En Trasplante' THEN 'Órgano en quirófano'
            WHEN 'Usado' THEN 'Trasplante realizado'
            ELSE 'Órgano descartado por evaluación médica'
        END;
    END IF;

    SET v_rand = RAND();

    IF v_rand < 0.60 THEN
        RETURN NULL;
    END IF;

    RETURN CASE p_estado
        WHEN 'Disponible' THEN 'Órgano viable para trasplante'
        WHEN 'Reservado' THEN 'Órgano asignado a receptor'
        WHEN 'En Trasplante' THEN 'Órgano en quirófano'
        WHEN 'Usado' THEN 'Trasplante realizado'
        ELSE 'Órgano descartado por evaluación médica'
    END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_rfc_pf` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_rfc_pf`(
    p_nombre VARCHAR(60),
    p_ap_p VARCHAR(60),
    p_ap_m VARCHAR(60),
    p_fecha_nacimiento DATE
) RETURNS char(14) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT(
        RPAD(LEFT(UPPER(IFNULL(p_ap_p,'X')),2),2,'X'),
        RPAD(LEFT(UPPER(IFNULL(p_ap_m,'X')),1),1,'X'),
        RPAD(LEFT(UPPER(IFNULL(p_nombre,'X')),1),1,'X'),
        DATE_FORMAT(p_fecha_nacimiento,'%y%m%d'),
        CHAR(FLOOR(65 + RAND()*26)),
        CHAR(FLOOR(65 + RAND()*26)),
        FLOOR(RAND()*10),
        CHAR(FLOOR(65 + RAND()*26)) 
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_generar_situacion_medica` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_generar_situacion_medica`(
p_edad INT,
    p_modo INT,
    p_situacion_forzada VARCHAR(150)
) RETURNS varchar(150) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_rand FLOAT;

    -- SIN situación médica (forzado)
    IF p_modo = -1 THEN
        RETURN NULL;
    END IF;

    -- FORZADA (tests COVID / Diabetes)
    IF p_modo = 1 THEN
        RETURN p_situacion_forzada;
    END IF;

    -- ALEATORIA
    SET v_rand = RAND();

    -- PEDIÁTRICO
    IF p_edad < 18 THEN
        RETURN CASE
            WHEN v_rand < 0.80 THEN NULL
            WHEN v_rand < 0.92 THEN 'Asma'
            WHEN v_rand < 0.98 THEN 'COVID-19'
            ELSE 'Diabetes'
        END;

    -- ADULTO
    ELSEIF p_edad < 60 THEN
        RETURN CASE
            WHEN v_rand < 0.65 THEN NULL
            WHEN v_rand < 0.70 THEN 'COVID-19'
            WHEN v_rand < 0.82 THEN 'Diabetes'
            ELSE 'Hipertensión'
        END;

    -- ADULTO MAYOR
    ELSE
        RETURN CASE
            WHEN v_rand < 0.45 THEN NULL
            WHEN v_rand < 0.49 THEN 'COVID-19'
            WHEN v_rand < 0.71 THEN 'Diabetes'
            ELSE 'Hipertensión'
        END;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genera_bandera` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_genera_bandera`() RETURNS tinyint(1)
    DETERMINISTIC
begin
	declare v_bandera BOOLEAN default false;
    declare v_pivote int default 0;
    set v_pivote = fn_numero_aleatorio_rangos(0,100);
    IF v_pivote<=50 THEN
		SET v_bandera = true;
	ELSE
		SET v_bandera = false;
	END IF;
return v_bandera;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genera_bandera_porcentaje` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_genera_bandera_porcentaje`(v_porcentaje int) RETURNS tinyint(1)
    DETERMINISTIC
begin
	RETURN RAND()<(v_porcentaje/100);
End ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genero_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_genero_random`() RETURNS enum('H','M','N/B') CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_rand FLOAT;
    SET v_rand = RAND();

    RETURN CASE
        WHEN v_rand < 0.385 THEN 'H'
        WHEN v_rand < 0.899 THEN 'M'
        ELSE 'N/B'
    END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genero_valido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_genero_valido`(p_genero VARCHAR(3)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    RETURN p_genero IN ('H','M','N/B');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_horas_viabilidad_organo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_horas_viabilidad_organo`(
    p_organo INT
) RETURNS int
    DETERMINISTIC
BEGIN

    RETURN CASE p_organo
        WHEN 2 THEN 6   -- Corazon
        WHEN 3 THEN 8   -- Pulmon Derecho
        WHEN 4 THEN 8   -- Pulmon Izquierdo
        WHEN 5 THEN 15  -- Higado
        WHEN 7 THEN 18  -- Pancreas
        WHEN 9 THEN 36  -- Rinon Derecho
        WHEN 10 THEN 36 -- Rinon Izquierdo
        WHEN 11 THEN 10 -- Intestino Delgado
        ELSE 24
    END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_metodo_preservacion_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_metodo_preservacion_random`() RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    DECLARE v_rand FLOAT;
    SET v_rand = RAND();

    RETURN CASE
        WHEN v_rand < 0.70 THEN 'Preservación en frío'
        WHEN v_rand < 0.90 THEN 'Perfusión hipotérmica'
        ELSE 'Máquina de perfusión'
    END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_nombre_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_nombre_random`(p_genero ENUM('H','M','N/B')) RETURNS varchar(60) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_genero ENUM('H','M','N/B');

    SET v_genero = IFNULL(p_genero,'H');

    IF v_genero = 'M' THEN
        RETURN ELT(
            CEILING(RAND() * 30),
            'Ana','María','Luisa','Carmen','Patricia','Laura','Sofía',
            'Fernanda','Paola','Valeria','Daniela','Gabriela','Andrea',
            'Alejandra','Mónica','Claudia','Rosa','Elena','Adriana',
            'Verónica','Natalia','Itzel','Ximena','Renata','Camila',
            'Julieta','Jimena','Montserrat','Ariana','Lucía'
        );
    ELSE
        RETURN ELT(
            CEILING(RAND() * 30),
            'Juan','José','Carlos','Luis','Miguel','Jorge','Pedro',
            'Fernando','Ricardo','Daniel','Alejandro','Manuel','Andrés',
            'Sergio','Francisco','Raúl','Eduardo','Hugo','Iván','Óscar',
            'Emilio','Diego','Ángel','Roberto','Mario','Joaquín',
            'Sebastián','Leonardo','Matías','Gael'
        );
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_numero_aleatorio_rangos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_numero_aleatorio_rangos`(v_limite_inferior int, v_limite_superior INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_numero_generado INT;
    SET v_numero_generado = FLOOR(Rand()* (v_limite_superior-v_limite_inferior-1)+v_limite_inferior);
    SET @numero_generado = v_numero_generado;
    return @numero_generado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_organo_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_organo_random`() RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_rand FLOAT;
    SET v_rand = RAND();

    RETURN CASE
        WHEN v_rand < 0.30 THEN 9   -- Rinon Derecho
        WHEN v_rand < 0.60 THEN 10  -- Rinon Izquierdo
        WHEN v_rand < 0.80 THEN 5   -- Higado
        WHEN v_rand < 0.88 THEN 2   -- Corazon
        WHEN v_rand < 0.93 THEN 3   -- Pulmon Derecho
        WHEN v_rand < 0.98 THEN 4   -- Pulmon Izquierdo
        WHEN v_rand < 0.99 THEN 7   -- Pancreas
        ELSE 11                     -- Intestino Delgado
    END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_alta_organo_inventario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_organo_inventario`(
    IN p_organo_id INT,
    IN p_codigo VARCHAR(30),
    IN p_fecha_proc DATETIME,
    IN p_fecha_exp DATETIME,
    IN p_estado VARCHAR(30),
    IN p_etnia VARCHAR(100),
    IN p_grupo VARCHAR(5),
    IN p_metodo VARCHAR(100),
    IN p_observacion TEXT
)
BEGIN

    DECLARE v_codigo VARCHAR(30);
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_ok BOOLEAN DEFAULT FALSE;

    WHILE v_ok = FALSE DO

        SET v_intentos = v_intentos + 1;

        IF v_intentos > 5 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='No se pudo generar Codigo_Rastreo único';
        END IF;

        -- si viene código lo usamos, si no generamos
        SET v_codigo =
            IF(p_codigo IS NULL,
               fn_codigo_rastreo(),
               p_codigo);

        BEGIN

            DECLARE CONTINUE HANDLER FOR 1062
            BEGIN
                SET v_ok = FALSE;
            END;

            INSERT INTO tbb_ge_organo_inventario
            (
                Organo_ID,
                Codigo_Rastreo,
                Fecha_Procuracion,
                Fecha_Expiracion,
                Estado,
                Etnia,
                Grupo_Sanguineo,
                Metodo_Preservacion,
                Observaciones
            )
            VALUES
            (
                p_organo_id,
                v_codigo,
                p_fecha_proc,
                p_fecha_exp,
                p_estado,
                p_etnia,
                p_grupo,
                p_metodo,
                p_observacion
            );

            SET v_ok = TRUE;

        END;

    END WHILE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_alta_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_paciente`(
    IN p_id_persona INT,
    IN p_estatus_medico VARCHAR(150),
    IN p_estatus_vida ENUM('Vivo','Finado','Coma','Vegetativo','Desconocido'),
    IN p_situacion_medica VARCHAR(150)
)
BEGIN
    -- VALIDACIONES
    IF p_id_persona IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID persona requerido para paciente';
    END IF;

    IF p_estatus_vida IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estatus de vida requerido';
    END IF;

    INSERT INTO tbb_md_pacientes (
		ID,
		estatus_medico,
		estatus_vida,
		situacion_medica,
		fecha_ultima_citamedica,
		fecha_registro,
		fecha_actualizacion,
		estatus
	) VALUES (
		p_id_persona,
		p_estatus_medico,
		p_estatus_vida,
		p_situacion_medica,
		NULL,
		NOW(),
		NOW(),
		1
	);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_alta_paciente_completo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_paciente_completo`(
    IN p_titulo VARCHAR(40),
    IN p_nombre VARCHAR(60),
    IN p_ap_p VARCHAR(60),
    IN p_ap_m VARCHAR(60),
    IN p_genero ENUM('H','M','N/B'),
    IN p_fecha_nacimiento DATE,
    IN p_estatus_medico VARCHAR(150),
    IN p_estatus_vida ENUM('Vivo','Finado','Coma','Vegetativo','Desconocido'),
    IN p_situacion_medica VARCHAR(150),
    IN p_grupo_sanguineo ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-')
)
BEGIN
    DECLARE v_id_persona INT;
    DECLARE v_rfc VARCHAR(14);
    DECLARE v_curp VARCHAR(18);
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_ok BOOLEAN DEFAULT FALSE;
    DECLARE v_edad INT;

    SET v_edad = TIMESTAMPDIFF(YEAR, p_fecha_nacimiento, CURDATE());

    IF p_nombre IS NULL OR p_ap_p IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Datos personales incompletos';
    END IF;

    WHILE v_ok = FALSE DO
        SET v_intentos = v_intentos + 1;

        IF v_intentos > 5 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se pudo generar RFC/CURP único';
        END IF;

        IF v_edad >= 18 THEN
            SET v_rfc = fn_generar_rfc_pf(
                p_nombre,
                p_ap_p,
                p_ap_m,
                p_fecha_nacimiento
            );
        ELSE
            SET v_rfc = NULL;
        END IF;

        SET v_curp = fn_generar_curp(
            p_nombre,
            p_ap_p,
            p_ap_m,
            p_fecha_nacimiento,
            p_genero
        );

        BEGIN
            DECLARE CONTINUE HANDLER FOR 1062
            BEGIN
                SET v_ok = FALSE;
            END;

            CALL sp_alta_persona(
                'Física',
                v_rfc,
                'México',
                v_id_persona
            );

            CALL sp_alta_persona_fisica(
                v_id_persona,
                p_titulo,
                p_nombre,
                p_ap_p,
                p_ap_m,
                p_genero,
                p_fecha_nacimiento,
                v_curp,
                p_grupo_sanguineo
            );

            CALL sp_alta_paciente(
				v_id_persona,
				p_estatus_medico,
				p_estatus_vida,
				p_situacion_medica
			);

            SET v_ok = TRUE;
        END;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_alta_persona` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_persona`(
    IN  p_tipo ENUM('Física','Moral'),
    IN  p_rfc VARCHAR(14),
    IN  p_pais_origen VARCHAR(50),
    OUT p_id_persona INT
)
BEGIN
    -- VALIDACIONES
    IF p_tipo IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de persona requerido';
    END IF;

    IF p_rfc IS NOT NULL AND LENGTH(p_rfc) < 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RFC inválido';
    END IF;

    IF p_pais_origen IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'País de origen requerido';
    END IF;

    INSERT INTO tbb_hr_personas (
        tipo,
        rfc,
        pais_origen,
        fecha_registro,
        fecha_actualizacion,
        estatus
    ) VALUES (
        p_tipo,
        p_rfc,
        p_pais_origen,
        NOW(),
        NOW(),
        1
    );

    SET p_id_persona = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_alta_persona_fisica` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_persona_fisica`(
    IN p_id_persona INT,
    IN p_titulo VARCHAR(40),
    IN p_nombre VARCHAR(60),
    IN p_ap_p VARCHAR(60),
    IN p_ap_m VARCHAR(60),
    IN p_genero ENUM('H','M','N/B'),
    IN p_fecha_nacimiento DATE,
    IN p_curp VARCHAR(18),
    IN p_grupo_sanguineo ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-')  -- nuevo parámetro
)
BEGIN
    -- VALIDACIONES
    IF p_id_persona IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID persona requerido';
    END IF;

    IF p_nombre IS NULL OR p_ap_p IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nombre y apellido paterno obligatorios';
    END IF;

    IF p_fecha_nacimiento IS NULL OR p_fecha_nacimiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fecha de nacimiento inválida';
    END IF;

    IF p_curp IS NULL OR LENGTH(p_curp) <> 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CURP inválido';
    END IF;

    INSERT INTO tbb_hr_personas_fisicas (
        ID,
        titulo_cortesia,
        nombre,
        primer_apellido,
        segundo_apellido,
        genero,
        fecha_nacimiento,
        curp,
        grupo_sanguineo,
        fecha_registro,
        fecha_actualizacion,
        estatus
    ) VALUES (
        p_id_persona,
        p_titulo,
        p_nombre,
        p_ap_p,
        p_ap_m,
        p_genero,
        p_fecha_nacimiento,
        p_curp,
        p_grupo_sanguineo,  -- ahora se asigna aquí
        NOW(),
        NOW(),
        1
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_organo_inventario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_organo_inventario`(
    IN p_cantidad INT,
    IN p_organo_id INT,
    IN p_grupo_sanguineo ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
    IN p_modo_grupo_sanguineo INT,
    IN p_estado VARCHAR(30),
    IN p_modo_estado INT,
    IN p_etnia VARCHAR(100),
    IN p_modo_etnia INT,
    IN p_metodo_preservacion VARCHAR(100),
    IN p_modo_observaciones INT
)
BEGIN

    DECLARE i INT DEFAULT 0;
    DECLARE v_batch_count INT DEFAULT 0;
    DECLARE v_batch_size INT DEFAULT 1000;

    DECLARE v_organo INT;
    DECLARE v_etnia VARCHAR(100);
    DECLARE v_estado_final VARCHAR(30);
    DECLARE v_grupo VARCHAR(5);
    DECLARE v_fecha_proc DATETIME;
    DECLARE v_fecha_exp DATETIME;
    DECLARE v_metodo VARCHAR(100);
    DECLARE v_codigo VARCHAR(30);
    DECLARE v_observacion TEXT;

    -- -------------------------------------------------
-- VALIDACIÓN DE CANTIDAD
-- -------------------------------------------------

IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La cantidad debe ser mayor a 0';
END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE ÓRGANO
-- -------------------------------------------------

IF p_organo_id IS NOT NULL THEN

    IF NOT EXISTS (
        SELECT 1
        FROM tbc_ge_organos
        WHERE ID = p_organo_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El órgano especificado no existe';
    END IF;

END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE MODOS
-- -------------------------------------------------

IF p_modo_grupo_sanguineo IS NOT NULL
AND p_modo_grupo_sanguineo NOT IN (-1,0,1) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo grupo sanguineo inválido (-1,0,1)';
END IF;

IF p_modo_estado IS NOT NULL
AND p_modo_estado NOT IN (-1,0,1) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo estado inválido (-1,0,1)';
END IF;

IF p_modo_etnia IS NOT NULL
AND p_modo_etnia NOT IN (-1,0,1) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo etnia inválido (-1,0,1)';
END IF;

IF p_modo_observaciones IS NOT NULL
AND p_modo_observaciones NOT IN (-1,0,1) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo observaciones inválido (-1,0,1)';
END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE GRUPO SANGUÍNEO
-- -------------------------------------------------

IF p_modo_grupo_sanguineo = 1 AND p_grupo_sanguineo IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Debe especificar grupo sanguíneo cuando modo=1';
END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE ESTADO
-- -------------------------------------------------

IF p_modo_estado = 1 AND p_estado IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Debe especificar estado cuando modo=1';
END IF;

IF p_estado IS NOT NULL AND p_estado NOT IN
(
'Disponible',
'Reservado',
'En Trasplante',
'Usado',
'Descartado'
) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Estado de órgano inválido';
END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE ETNIA
-- -------------------------------------------------

IF p_modo_etnia = 1 AND (p_etnia IS NULL OR LENGTH(TRIM(p_etnia)) = 0) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Debe especificar etnia cuando modo=1';
END IF;

IF p_etnia IS NOT NULL AND LENGTH(p_etnia) > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Etnia excede longitud máxima (100)';
END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE MÉTODO DE PRESERVACIÓN
-- -------------------------------------------------

IF p_metodo_preservacion IS NOT NULL
AND LENGTH(p_metodo_preservacion) > 100 THEN

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Metodo de preservacion excede longitud máxima (100)';

END IF;


-- -------------------------------------------------
-- VALIDACIÓN DE CONSISTENCIA ENTRE MODO Y PARÁMETRO
-- -------------------------------------------------

IF p_modo_estado = -1 AND p_estado IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo estado=-1 pero se envió estado';
END IF;

IF p_modo_grupo_sanguineo = -1 AND p_grupo_sanguineo IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo grupo sanguineo=-1 pero se envió grupo';
END IF;

IF p_modo_etnia = -1 AND p_etnia IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Modo etnia=-1 pero se envió etnia';
END IF;
    SET @MODO_CARGA_MASIVA = 1;

    SET AUTOCOMMIT=0;
    SET FOREIGN_KEY_CHECKS=0;
    SET UNIQUE_CHECKS=0;

    START TRANSACTION;

    WHILE i < p_cantidad DO

        SET v_organo =
            IF(p_organo_id IS NULL,
               fn_organo_random(),
               p_organo_id);

        SET v_grupo =
            fn_generar_grupo_sanguineo_modo(
                p_modo_grupo_sanguineo,
                p_grupo_sanguineo
            );

        SET v_estado_final =
            fn_generar_estado_organo(
                p_modo_estado,
                p_estado
            );

        SET v_fecha_proc = fn_fecha_procuracion_random();

        SET v_fecha_exp =
            fn_fecha_expiracion_organo(
                v_fecha_proc,
                v_organo
            );

        SET v_metodo =
            IF(p_metodo_preservacion IS NULL,
               fn_metodo_preservacion_random(),
               p_metodo_preservacion);


        SET v_observacion =
            fn_generar_observacion_organo(
                v_estado_final,
                p_modo_observaciones
            );
            
            SET v_etnia =
    fn_generar_etnia_modo(
        p_modo_etnia,
        p_etnia
    );

        CALL sp_alta_organo_inventario(
            v_organo,
            NULL,
            v_fecha_proc,
            v_fecha_exp,
            v_estado_final,
            v_etnia,
            v_grupo,
            v_metodo,
            v_observacion
        );

        SET i = i + 1;
        SET v_batch_count = v_batch_count + 1;

        IF v_batch_count >= v_batch_size THEN
            COMMIT;
            START TRANSACTION;
            SET v_batch_count = 0;
        END IF;

    END WHILE;

    COMMIT;

    SET @MODO_CARGA_MASIVA = NULL;

    SET FOREIGN_KEY_CHECKS=1;
    SET UNIQUE_CHECKS=1;
    SET AUTOCOMMIT=1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_pacientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_pacientes`(
    IN p_cantidad INT,
    IN p_c_genero ENUM('H','M','N/B'),
    IN p_edad_minima INT,
    IN p_edad_maxima INT,
    IN p_estatus_vida ENUM('Vivo','Finado','Coma','Vegetativo','Desconocido'),
    IN p_modo_estatus_medico INT,
    IN p_estatus_medico VARCHAR(150),
    IN p_tipo_edad VARCHAR(20),
    IN p_modo_situacion_medica INT,
    IN p_situacion_medica VARCHAR(150),
    IN p_modo_titulo INT
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_batch_count INT DEFAULT 0;
    DECLARE v_batch_size INT DEFAULT 1000;

    DECLARE v_genero_final ENUM('H','M','N/B');
    DECLARE v_estatus_vida_final ENUM('Vivo','Finado','Coma','Vegetativo','Desconocido');
    DECLARE v_estatus_medico_final VARCHAR(150);
    DECLARE v_situacion_medica_final VARCHAR(150);

    DECLARE v_total_dias INT;
    DECLARE v_fecha_nacimiento DATE;
    DECLARE v_edad INT;

    DECLARE v_nombre VARCHAR(60);
    DECLARE v_ap_p VARCHAR(60);
    DECLARE v_ap_m VARCHAR(60);
    DECLARE v_titulo VARCHAR(40);
    DECLARE v_grupo_sanguineo ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-');

    DECLARE v_edad_min INT;
    DECLARE v_edad_max INT;
    DECLARE v_tipo_edad_final VARCHAR(20);
	
    
    -- ------------------------------------------------------------------
    -- VALIDACIONES GENERALES
    -- ------------------------------------------------------------------
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad debe ser mayor a 0';
    END IF;

    IF p_edad_minima IS NOT NULL AND (p_edad_minima < 0 OR p_edad_minima > 120) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Edad mínima fuera de rango (0–120)';
    END IF;

    IF p_edad_maxima IS NOT NULL AND (p_edad_maxima < 0 OR p_edad_maxima > 120) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Edad máxima fuera de rango (0–120)';
    END IF;

    IF p_edad_minima IS NOT NULL AND p_edad_maxima IS NOT NULL AND p_edad_minima > p_edad_maxima THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Edad mínima mayor que edad máxima';
    END IF;

    IF p_modo_titulo IS NOT NULL AND p_modo_titulo NOT IN (-1,1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modo de título inválido (-1, NULL, 1)';
    END IF;

    IF p_modo_estatus_medico IS NOT NULL AND p_modo_estatus_medico NOT IN (-1,1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modo de estatus médico inválido (-1, NULL, 1)';
    END IF;

    IF p_modo_situacion_medica IS NOT NULL
    AND p_modo_situacion_medica NOT IN (-1, 0, 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Modo de situación médica inválido (-1, 0, 1)';
    END IF;


    IF p_tipo_edad IS NOT NULL AND p_tipo_edad NOT IN (
        'recien nacido', 'neonato','infante','niñez',
        'preadolescente', 'adolescente','joven',
        'adulto joven', 'adulto','adulto mayor','pediatrico'
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de edad inválido';
    END IF;

    -- ------------------------------------------------------------------
    -- NORMALIZACIÓN DE REGLAS DE EDAD
    -- ------------------------------------------------------------------
    IF p_edad_minima IS NOT NULL OR p_edad_maxima IS NOT NULL THEN
        SET v_tipo_edad_final = NULL;
        SET v_edad_min = IF(p_edad_minima IS NULL, 0, p_edad_minima);
        SET v_edad_max = IF(p_edad_maxima IS NULL, 120, p_edad_maxima);
    ELSE
        SET v_edad_min = NULL;
        SET v_edad_max = NULL;
        SET v_tipo_edad_final = p_tipo_edad;
    END IF;

    SET @MODO_CARGA_MASIVA = 1;

    SET AUTOCOMMIT = 0;
    SET FOREIGN_KEY_CHECKS = 0;
    SET UNIQUE_CHECKS = 0;

    START TRANSACTION;

    WHILE i < p_cantidad DO

        SET v_genero_final = IF(p_c_genero IS NULL, fn_genero_random(), p_c_genero);

        SET v_total_dias = fn_generar_dias_edad(v_tipo_edad_final, v_edad_min, v_edad_max);
        SET v_fecha_nacimiento = DATE_SUB(CURDATE(), INTERVAL v_total_dias DAY);
        SET v_edad = TIMESTAMPDIFF(YEAR, v_fecha_nacimiento, CURDATE());
		SET v_situacion_medica_final = fn_generar_situacion_medica(
			v_edad,
			p_modo_situacion_medica,
			p_situacion_medica
		);


        SET v_estatus_vida_final = fn_generar_estatus_vida(p_estatus_vida);

		SET v_estatus_medico_final = fn_generar_estatus_medico(
			v_edad,
			v_estatus_vida_final,
			p_modo_estatus_medico,
			p_estatus_medico
		);


        SET v_nombre = fn_nombre_random(v_genero_final);
        SET v_ap_p = fn_apellido_random();
        SET v_ap_m = fn_apellido_random();
        SET v_titulo = fn_decidir_titulo_profesional(v_edad, p_modo_titulo);
        SET v_grupo_sanguineo = fn_generar_grupo_sanguineo();

        CALL sp_alta_paciente_completo(
            v_titulo,
            v_nombre,
            v_ap_p,
            v_ap_m,
            v_genero_final,
            v_fecha_nacimiento,
            v_estatus_medico_final,
            v_estatus_vida_final,
            v_situacion_medica_final,
            v_grupo_sanguineo
        );

        SET i = i + 1;
        SET v_batch_count = v_batch_count + 1;

        IF v_batch_count >= v_batch_size THEN
            COMMIT;
            START TRANSACTION;
            SET v_batch_count = 0;
        END IF;

    END WHILE;

    COMMIT;

    SET @MODO_CARGA_MASIVA = NULL;
    SET FOREIGN_KEY_CHECKS = 1;
    SET UNIQUE_CHECKS = 1;
    SET AUTOCOMMIT = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vista_tablas`
--

/*!50001 DROP VIEW IF EXISTS `vista_tablas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_tablas` AS with `percepciones` as (select `information_schema`.`t`.`TABLE_SCHEMA` AS `TABLE_SCHEMA`,`information_schema`.`t`.`TABLE_NAME` AS `TABLE_NAME`,(case when (`information_schema`.`t`.`TABLE_NAME` like '%ge_quejas_sugerencias%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%hr_departamentos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%hr_personal_medico%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%hr_personal%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%hr_personas_fisicas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%hr_personas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%md_defunciones%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%md_diagnosticos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%md_documentos_oficiales%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%md_expedientes_medicos%') then 'Mixta' when (`information_schema`.`t`.`TABLE_NAME` like '%md_nacimientos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%md_notas_medicas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%md_pacientes%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%md_tratamientos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_personas_morales%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_proveedores%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_transacciones_financieras%') then 'Mixta' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_dietas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_transfusiones_sanguineas%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_traslados%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_valoraciones%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ph_recetas_medicas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_areas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_organos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_patologias_tipos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_tipos_patologias%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_patologias%') then 'Mixta' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_servicios%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%md_signos_vitales%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_equipamientos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_espacios%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_cirugias%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_servicios_medicos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ph_medicamentos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_aprobaciones%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ge_solicitudes_servicios%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%hr_horarios%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%md_padecimientos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_accesos%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%mr_inventario_equipamientos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_campanias%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ms_citas_medicas%') then 'Conceptual' when (`information_schema`.`t`.`TABLE_NAME` like '%ph_inventario_medicamentos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%ph_lotes_medicamentos%') then 'Fisica' when (`information_schema`.`t`.`TABLE_NAME` like '%bitacora%') then 'Conceptual' end) AS `percepcion` from `information_schema`.`TABLES` `t` where ((`information_schema`.`t`.`TABLE_SCHEMA` = database()) and (`information_schema`.`t`.`TABLE_NAME` like 'tb%_%_%'))) select upper(replace(substr(`information_schema`.`t`.`TABLE_NAME`,(locate('_',`information_schema`.`t`.`TABLE_NAME`,(locate('_',`information_schema`.`t`.`TABLE_NAME`) + 1)) + 1)),'_',' ')) AS `entidad`,`information_schema`.`t`.`TABLE_NAME` AS `tabla`,(case when (exists(select 1 from (`information_schema`.`KEY_COLUMN_USAGE` `k` join `information_schema`.`COLUMNS` `c` on(((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`c`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`c`.`TABLE_NAME`) and (`information_schema`.`k`.`COLUMN_NAME` = `information_schema`.`c`.`COLUMN_NAME`)))) where ((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`) and (`information_schema`.`c`.`COLUMN_KEY` = 'PRI') and (`information_schema`.`k`.`REFERENCED_TABLE_NAME` is not null))) and exists(select 1 from (`information_schema`.`KEY_COLUMN_USAGE` `k` join `information_schema`.`COLUMNS` `c` on(((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`c`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`c`.`TABLE_NAME`) and (`information_schema`.`k`.`COLUMN_NAME` = `information_schema`.`c`.`COLUMN_NAME`)))) where ((`information_schema`.`k`.`REFERENCED_TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`REFERENCED_TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`) and (`information_schema`.`c`.`COLUMN_KEY` = 'PRI')))) then 'Super entidad & Sub entidad' when exists(select 1 from (`information_schema`.`KEY_COLUMN_USAGE` `k` join `information_schema`.`COLUMNS` `c` on(((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`c`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`c`.`TABLE_NAME`) and (`information_schema`.`k`.`COLUMN_NAME` = `information_schema`.`c`.`COLUMN_NAME`)))) where ((`information_schema`.`k`.`REFERENCED_TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`REFERENCED_TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`) and (`information_schema`.`c`.`COLUMN_KEY` = 'PRI'))) then 'Super entidad' when exists(select 1 from (`information_schema`.`KEY_COLUMN_USAGE` `k` join `information_schema`.`COLUMNS` `c` on(((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`c`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`c`.`TABLE_NAME`) and (`information_schema`.`k`.`COLUMN_NAME` = `information_schema`.`c`.`COLUMN_NAME`)))) where ((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`) and (`information_schema`.`c`.`COLUMN_KEY` = 'PRI') and (`information_schema`.`k`.`REFERENCED_TABLE_NAME` is not null))) then 'Sub entidad' else 'Generica' end) AS `tipo_jerarquia`,`p`.`percepcion` AS `percepcion`,(case when exists(select 1 from (`information_schema`.`KEY_COLUMN_USAGE` `k` join `information_schema`.`COLUMNS` `c` on(((`information_schema`.`c`.`TABLE_SCHEMA` = `information_schema`.`k`.`TABLE_SCHEMA`) and (`information_schema`.`c`.`TABLE_NAME` = `information_schema`.`k`.`TABLE_NAME`) and (`information_schema`.`c`.`COLUMN_NAME` = `information_schema`.`k`.`COLUMN_NAME`)))) where ((`information_schema`.`k`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`information_schema`.`k`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`) and (`information_schema`.`c`.`COLUMN_KEY` = 'PRI') and (`information_schema`.`k`.`REFERENCED_TABLE_NAME` is not null))) then 'Debil' else 'Fuerte' end) AS `tipo_dependencia`,(case when (`information_schema`.`t`.`TABLE_NAME` like 'tbc_%') then 'Catalogo' when (`information_schema`.`t`.`TABLE_NAME` like 'tbd_%') then 'Derivada' else 'Base' end) AS `tipo_nomenclatura`,(select `p`.`GRANTEE` from (select `sp`.`GRANTEE` AS `GRANTEE`,`sp`.`PRIVILEGE_TYPE` AS `PRIVILEGE_TYPE` from `information_schema`.`SCHEMA_PRIVILEGES` `sp` where (`sp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) union all select `tp`.`GRANTEE` AS `GRANTEE`,`tp`.`PRIVILEGE_TYPE` AS `PRIVILEGE_TYPE` from `information_schema`.`TABLE_PRIVILEGES` `tp` where ((`tp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`tp`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`))) `p` group by `p`.`GRANTEE` having ((sum((`p`.`PRIVILEGE_TYPE` = 'SELECT')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` = 'INSERT')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` = 'UPDATE')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` = 'DELETE')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` = 'ALTER')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` = 'REFERENCES')) > 0)) limit 1) AS `dueño`,(select group_concat(`p`.`GRANTEE` separator ',') from (select `sp`.`GRANTEE` AS `GRANTEE`,`sp`.`PRIVILEGE_TYPE` AS `PRIVILEGE_TYPE` from `information_schema`.`SCHEMA_PRIVILEGES` `sp` where (`sp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) union all select `tp`.`GRANTEE` AS `GRANTEE`,`tp`.`PRIVILEGE_TYPE` AS `PRIVILEGE_TYPE` from `information_schema`.`TABLE_PRIVILEGES` `tp` where ((`tp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`tp`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`))) `p` group by `p`.`GRANTEE` having ((sum((`p`.`PRIVILEGE_TYPE` = 'SELECT')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` in ('INSERT','UPDATE','DELETE'))) > 0) and (sum((`p`.`PRIVILEGE_TYPE` = 'ALTER')) = 0))) AS `editor`,(select group_concat(`p`.`GRANTEE` separator ',') from (select `sp`.`GRANTEE` AS `GRANTEE`,`sp`.`PRIVILEGE_TYPE` AS `PRIVILEGE_TYPE` from `information_schema`.`SCHEMA_PRIVILEGES` `sp` where (`sp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) union all select `tp`.`GRANTEE` AS `GRANTEE`,`tp`.`PRIVILEGE_TYPE` AS `PRIVILEGE_TYPE` from `information_schema`.`TABLE_PRIVILEGES` `tp` where ((`tp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`tp`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`))) `p` group by `p`.`GRANTEE` having ((sum((`p`.`PRIVILEGE_TYPE` = 'SELECT')) > 0) and (sum((`p`.`PRIVILEGE_TYPE` in ('INSERT','UPDATE','DELETE','ALTER','REFERENCES'))) = 0))) AS `lector`,(select group_concat(`r`.`role` separator ',') from (select '\'developer\'@\'%\'' AS `role` union select '\'ge_user\'@\'%\'' AS `'ge_user'@'%'` union select '\'hr_user\'@\'%\'' AS `'hr_user'@'%'` union select '\'md_user\'@\'%\'' AS `'md_user'@'%'` union select '\'mr_user\'@\'%\'' AS `'mr_user'@'%'` union select '\'ms_user\'@\'%\'' AS `'ms_user'@'%'` union select '\'ph_user\'@\'%\'' AS `'ph_user'@'%'` union select '\'medic\'@\'%\'' AS `'medic'@'%'` union select '\'nurse\'@\'%\'' AS `'nurse'@'%'` union select '\'patient\'@\'%\'' AS `'patient'@'%'`) `r` where `r`.`role` in (select distinct `p`.`GRANTEE` from (select `sp`.`GRANTEE` AS `GRANTEE` from `information_schema`.`SCHEMA_PRIVILEGES` `sp` where (`sp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) union select `tp`.`GRANTEE` AS `GRANTEE` from `information_schema`.`TABLE_PRIVILEGES` `tp` where ((`tp`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`tp`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`))) `p`) is false) AS `sin_acceso`,`information_schema`.`t`.`TABLE_ROWS` AS `total_registros`,round((((`information_schema`.`t`.`DATA_LENGTH` + `information_schema`.`t`.`INDEX_LENGTH`) / 1024) / 1024),2) AS `tamanio_aproximado_MB`,(select count(0) from `information_schema`.`COLUMNS` `c` where ((`information_schema`.`c`.`TABLE_SCHEMA` = `information_schema`.`t`.`TABLE_SCHEMA`) and (`information_schema`.`c`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`))) AS `total_columnas` from (`information_schema`.`TABLES` `t` left join `percepciones` `p` on((`p`.`TABLE_NAME` = `information_schema`.`t`.`TABLE_NAME`))) where ((`information_schema`.`t`.`TABLE_SCHEMA` = 'hospital_230028') and (`information_schema`.`t`.`TABLE_NAME` like 'tb%_%_%')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_grants_por_roles`
--

/*!50001 DROP VIEW IF EXISTS `vw_grants_por_roles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_grants_por_roles` AS select '---------------- GERENCIA ----------------' AS `linea` union all select concat('GRANT ',group_concat(distinct `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` order by `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` ASC separator ', '),' ON `',`information_schema`.`table_privileges`.`TABLE_SCHEMA`,'`.`',`information_schema`.`table_privileges`.`TABLE_NAME`,'` TO ',`information_schema`.`table_privileges`.`GRANTEE`,';') AS `Name_exp_2` from `information_schema`.`TABLE_PRIVILEGES` where (`information_schema`.`table_privileges`.`GRANTEE` like '\'ge_user\'@%') group by `information_schema`.`table_privileges`.`GRANTEE`,`information_schema`.`table_privileges`.`TABLE_SCHEMA`,`information_schema`.`table_privileges`.`TABLE_NAME` union all select '---------------- RECURSOS HUMANOS ----------------' AS `---------------- RECURSOS HUMANOS ----------------` union all select concat('GRANT ',group_concat(distinct `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` order by `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` ASC separator ', '),' ON `',`information_schema`.`table_privileges`.`TABLE_SCHEMA`,'`.`',`information_schema`.`table_privileges`.`TABLE_NAME`,'` TO ',`information_schema`.`table_privileges`.`GRANTEE`,';') AS `Name_exp_4` from `information_schema`.`TABLE_PRIVILEGES` where (`information_schema`.`table_privileges`.`GRANTEE` like '\'hr_user\'@%') group by `information_schema`.`table_privileges`.`GRANTEE`,`information_schema`.`table_privileges`.`TABLE_SCHEMA`,`information_schema`.`table_privileges`.`TABLE_NAME` union all select '---------------- RECURSOS MATERIALES ----------------' AS `---------------- RECURSOS MATERIALES ----------------` union all select concat('GRANT ',group_concat(distinct `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` order by `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` ASC separator ', '),' ON `',`information_schema`.`table_privileges`.`TABLE_SCHEMA`,'`.`',`information_schema`.`table_privileges`.`TABLE_NAME`,'` TO ',`information_schema`.`table_privileges`.`GRANTEE`,';') AS `Name_exp_6` from `information_schema`.`TABLE_PRIVILEGES` where (`information_schema`.`table_privileges`.`GRANTEE` like '\'mr_user\'@%') group by `information_schema`.`table_privileges`.`GRANTEE`,`information_schema`.`table_privileges`.`TABLE_SCHEMA`,`information_schema`.`table_privileges`.`TABLE_NAME` union all select '---------------- SERVICIOS M  DICOS ----------------' AS `---------------- SERVICIOS M  DICOS ----------------` union all select concat('GRANT ',group_concat(distinct `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` order by `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` ASC separator ', '),' ON `',`information_schema`.`table_privileges`.`TABLE_SCHEMA`,'`.`',`information_schema`.`table_privileges`.`TABLE_NAME`,'` TO ',`information_schema`.`table_privileges`.`GRANTEE`,';') AS `Name_exp_8` from `information_schema`.`TABLE_PRIVILEGES` where (`information_schema`.`table_privileges`.`GRANTEE` like '\'ms_user\'@%') group by `information_schema`.`table_privileges`.`GRANTEE`,`information_schema`.`table_privileges`.`TABLE_SCHEMA`,`information_schema`.`table_privileges`.`TABLE_NAME` union all select '---------------- REGISTROS M  DICOS ----------------' AS `---------------- REGISTROS M  DICOS ----------------` union all select concat('GRANT ',group_concat(distinct `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` order by `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` ASC separator ', '),' ON `',`information_schema`.`table_privileges`.`TABLE_SCHEMA`,'`.`',`information_schema`.`table_privileges`.`TABLE_NAME`,'` TO ',`information_schema`.`table_privileges`.`GRANTEE`,';') AS `Name_exp_10` from `information_schema`.`TABLE_PRIVILEGES` where (`information_schema`.`table_privileges`.`GRANTEE` like '\'md_user\'@%') group by `information_schema`.`table_privileges`.`GRANTEE`,`information_schema`.`table_privileges`.`TABLE_SCHEMA`,`information_schema`.`table_privileges`.`TABLE_NAME` union all select '---------------- FARMACIA ----------------' AS `---------------- FARMACIA ----------------` union all select concat('GRANT ',group_concat(distinct `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` order by `information_schema`.`table_privileges`.`PRIVILEGE_TYPE` ASC separator ', '),' ON `',`information_schema`.`table_privileges`.`TABLE_SCHEMA`,'`.`',`information_schema`.`table_privileges`.`TABLE_NAME`,'` TO ',`information_schema`.`table_privileges`.`GRANTEE`,';') AS `Name_exp_12` from `information_schema`.`TABLE_PRIVILEGES` where (`information_schema`.`table_privileges`.`GRANTEE` like '\'ph_user\'@%') group by `information_schema`.`table_privileges`.`GRANTEE`,`information_schema`.`table_privileges`.`TABLE_SCHEMA`,`information_schema`.`table_privileges`.`TABLE_NAME` union all select '---------------- DEVELOPER ----------------' AS `---------------- DEVELOPER ----------------` union all select concat('GRANT ',convert(group_concat(`privileges`.`priv` separator ', ') using utf8mb3),' ON `',`privileges`.`Db`,'`.* TO \'',`privileges`.`User`,'\'@\'',convert(`privileges`.`Host` using utf8mb3),'\';') AS `Name_exp_14` from (select `mysql`.`db`.`User` AS `User`,`mysql`.`db`.`Host` AS `Host`,`mysql`.`db`.`Db` AS `Db`,(case when (`mysql`.`db`.`Select_priv` = 'Y') then 'SELECT' end) AS `priv` from `mysql`.`db` where ((`mysql`.`db`.`User` = 'developer') and (`mysql`.`db`.`Db` = 'hospital_230028')) union all select `mysql`.`db`.`User` AS `User`,`mysql`.`db`.`Host` AS `Host`,`mysql`.`db`.`Db` AS `Db`,(case when (`mysql`.`db`.`Insert_priv` = 'Y') then 'INSERT' end) AS `CASE WHEN Insert_priv='Y' THEN 'INSERT' END` from `mysql`.`db` where ((`mysql`.`db`.`User` = 'developer') and (`mysql`.`db`.`Db` = 'hospital_230028')) union all select `mysql`.`db`.`User` AS `User`,`mysql`.`db`.`Host` AS `Host`,`mysql`.`db`.`Db` AS `Db`,(case when (`mysql`.`db`.`Update_priv` = 'Y') then 'UPDATE' end) AS `CASE WHEN Update_priv='Y' THEN 'UPDATE' END` from `mysql`.`db` where ((`mysql`.`db`.`User` = 'developer') and (`mysql`.`db`.`Db` = 'hospital_230028')) union all select `mysql`.`db`.`User` AS `User`,`mysql`.`db`.`Host` AS `Host`,`mysql`.`db`.`Db` AS `Db`,(case when (`mysql`.`db`.`Delete_priv` = 'Y') then 'DELETE' end) AS `CASE WHEN Delete_priv='Y' THEN 'DELETE' END` from `mysql`.`db` where ((`mysql`.`db`.`User` = 'developer') and (`mysql`.`db`.`Db` = 'hospital_230028')) union all select `mysql`.`db`.`User` AS `User`,`mysql`.`db`.`Host` AS `Host`,`mysql`.`db`.`Db` AS `Db`,(case when (`mysql`.`db`.`Create_priv` = 'Y') then 'CREATE' end) AS `CASE WHEN Create_priv='Y' THEN 'CREATE' END` from `mysql`.`db` where ((`mysql`.`db`.`User` = 'developer') and (`mysql`.`db`.`Db` = 'hospital_230028')) union all select `mysql`.`db`.`User` AS `User`,`mysql`.`db`.`Host` AS `Host`,`mysql`.`db`.`Db` AS `Db`,(case when (`mysql`.`db`.`Alter_priv` = 'Y') then 'ALTER' end) AS `CASE WHEN Alter_priv='Y' THEN 'ALTER' END` from `mysql`.`db` where ((`mysql`.`db`.`User` = 'developer') and (`mysql`.`db`.`Db` = 'hospital_230028'))) `privileges` where (`privileges`.`priv` is not null) group by `privileges`.`User`,`privileges`.`Host`,`privileges`.`Db` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_roles_usuarios`
--

/*!50001 DROP VIEW IF EXISTS `vw_roles_usuarios`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_roles_usuarios` AS select `u`.`User` AS `usuario`,`u`.`Host` AS `host`,ifnull(group_concat(concat(`r`.`TO_USER`,'@',convert(`r`.`TO_HOST` using utf8mb3)) order by `r`.`TO_USER` ASC separator ', '),'SIN ROLES') AS `roles_asignados` from (`mysql`.`user` `u` left join `mysql`.`role_edges` `r` on(((`u`.`User` = `r`.`FROM_USER`) and (`u`.`Host` = `r`.`FROM_HOST`)))) where ((`u`.`User` like '%user%') or (`u`.`User` = 'developer')) group by `u`.`User`,`u`.`Host` order by `u`.`User`,`u`.`Host` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-26 23:39:41
