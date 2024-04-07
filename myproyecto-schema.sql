-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.2.0

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
-- Table structure for table `almacen`
--

DROP TABLE IF EXISTS `almacen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `almacen` (
  `nombre` varchar(40) NOT NULL,
  `direccion` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `Proveedores_cod_proveedor` int NOT NULL,
  PRIMARY KEY (`nombre`),
  KEY `fk_Almacen_Proveedores1_idx` (`Proveedores_cod_proveedor`),
  CONSTRAINT `fk_Almacen_Proveedores1` FOREIGN KEY (`Proveedores_cod_proveedor`) REFERENCES `proveedores` (`cod_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `cod_cliente` int NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellidos` varchar(45) DEFAULT NULL,
  `Domicilio` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Telefono` varchar(10) DEFAULT NULL,
  `Sector` varchar(45) DEFAULT NULL,
  `Zona` varchar(45) DEFAULT NULL,
  `CIF` varchar(45) DEFAULT NULL,
  `Persona_contacto` varchar(45) DEFAULT NULL,
  `Observaciones` varchar(45) DEFAULT NULL,
  `Tarifa_aplicada` int DEFAULT NULL,
  `limite_credito` int DEFAULT NULL,
  `Tipo_pago` varchar(45) DEFAULT NULL,
  `Cuenta_contable` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`cod_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `detalle pedido`
--

DROP TABLE IF EXISTS `detalle pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle pedido` (
  `Producto_cod_producto` int NOT NULL,
  `Pedido_cod_pedido` int NOT NULL,
  `cantidad` int DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT '0.00',
  `unidades_servidas` int DEFAULT NULL,
  `descuento` int DEFAULT NULL,
  PRIMARY KEY (`Producto_cod_producto`,`Pedido_cod_pedido`,`precio`),
  KEY `fk_Producto_has_Pedido_Pedido1` (`Pedido_cod_pedido`),
  CONSTRAINT `fk_Producto_has_Pedido_Pedido1` FOREIGN KEY (`Pedido_cod_pedido`) REFERENCES `pedido` (`cod_pedido`),
  CONSTRAINT `fk_Producto_has_Pedido_Producto1` FOREIGN KEY (`Producto_cod_producto`) REFERENCES `producto` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `cod_empleado` int NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellidos` varchar(45) DEFAULT NULL,
  `Domicilio` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DNI` varchar(45) DEFAULT NULL,
  `Telefono` varchar(10) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Tipo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`cod_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `empleados_negocia_clientes`
--

DROP TABLE IF EXISTS `empleados_negocia_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados_negocia_clientes` (
  `Empleados_cod_empleado` int NOT NULL,
  `Clientes_cod_cliente` int NOT NULL,
  `tipo_comision` varchar(45) DEFAULT NULL,
  `porcentaje_comision` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`Empleados_cod_empleado`,`Clientes_cod_cliente`),
  KEY `fk_Empleados_has_Clientes_Clientes1_idx` (`Clientes_cod_cliente`),
  KEY `fk_Empleados_has_Clientes_Empleados1_idx` (`Empleados_cod_empleado`),
  CONSTRAINT `fk_Empleados_has_Clientes_Clientes1` FOREIGN KEY (`Clientes_cod_cliente`) REFERENCES `clientes` (`cod_cliente`),
  CONSTRAINT `fk_Empleados_has_Clientes_Empleados1` FOREIGN KEY (`Empleados_cod_empleado`) REFERENCES `empleados` (`cod_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `familia`
--

DROP TABLE IF EXISTS `familia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `familia` (
  `cod_familia` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`cod_familia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `historico_negociaciones`
--

DROP TABLE IF EXISTS `historico_negociaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_negociaciones` (
  `Empleados_cod_empleado` int NOT NULL,
  `Clientes_cod_cliente` int NOT NULL,
  `tipo_comision` varchar(45) DEFAULT NULL,
  `porcentaje_comision` decimal(10,0) DEFAULT NULL,
  `fecha_cambio` date NOT NULL,
  PRIMARY KEY (`Empleados_cod_empleado`,`Clientes_cod_cliente`,`fecha_cambio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `historico_precios`
--

DROP TABLE IF EXISTS `historico_precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_precios` (
  `cod_producto` int NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `precio_compra` double DEFAULT NULL,
  `precio_venta` double DEFAULT NULL,
  `fecha_modificacion` date NOT NULL,
  PRIMARY KEY (`cod_producto`,`fecha_modificacion`),
  CONSTRAINT `historico_precios_ibfk_1` FOREIGN KEY (`cod_producto`) REFERENCES `producto` (`cod_producto`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `num_factura` int NOT NULL,
  `Fecha_emision` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `Importe` double DEFAULT NULL,
  `Pedido_cod_pedido` int DEFAULT NULL,
  PRIMARY KEY (`num_factura`),
  KEY `fk_Pago_Pedido1_idx` (`Pedido_cod_pedido`),
  CONSTRAINT `fk_Pago_Pedido1` FOREIGN KEY (`Pedido_cod_pedido`) REFERENCES `pedido` (`cod_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `cod_pedido` int NOT NULL,
  `Fecha_pedido` date DEFAULT NULL,
  `Fecha_servir` date DEFAULT NULL,
  `Importe` double DEFAULT NULL,
  `Estado` varchar(45) DEFAULT NULL,
  `Clientes_cod_cliente` int NOT NULL,
  `Empleados_cod_empleado` int DEFAULT NULL,
  PRIMARY KEY (`cod_pedido`),
  KEY `fk_Pedido_Clientes1_idx` (`Clientes_cod_cliente`),
  KEY `pedido_FK` (`Empleados_cod_empleado`),
  CONSTRAINT `fk_Pedido_Clientes1` FOREIGN KEY (`Clientes_cod_cliente`) REFERENCES `clientes` (`cod_cliente`),
  CONSTRAINT `pedido_FK` FOREIGN KEY (`Empleados_cod_empleado`) REFERENCES `empleados` (`cod_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `cod_producto` int NOT NULL,
  `Precio_compra` double DEFAULT NULL,
  `Precio_venta` double DEFAULT NULL,
  `Tipo_IVA` double DEFAULT NULL,
  `cod_familia` int NOT NULL,
  `Proveedores_cod_proveedor` int NOT NULL,
  `nombre` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`cod_producto`),
  KEY `fk_Producto_Proveedores1_idx` (`Proveedores_cod_proveedor`),
  KEY `fk_Producto_Familia1_idx` (`cod_familia`),
  KEY `producto_cod_producto_IDX` (`cod_producto`,`nombre`,`Precio_compra`,`Precio_venta`,`Tipo_IVA`,`cod_familia`,`Proveedores_cod_proveedor`) USING BTREE,
  CONSTRAINT `fk_Producto_Familia1` FOREIGN KEY (`cod_familia`) REFERENCES `familia` (`cod_familia`),
  CONSTRAINT `fk_Producto_Proveedores1` FOREIGN KEY (`Proveedores_cod_proveedor`) REFERENCES `proveedores` (`cod_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='		';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `producto_has_almacen`
--

DROP TABLE IF EXISTS `producto_has_almacen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto_has_almacen` (
  `Producto_cod_producto` int NOT NULL,
  `nombre_alamacen` varchar(40) NOT NULL,
  `Stock` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Producto_cod_producto`,`nombre_alamacen`),
  KEY `fk_Producto_has_Almacen_Almacen1_idx` (`nombre_alamacen`),
  KEY `fk_Producto_has_Almacen_Producto1_idx` (`Producto_cod_producto`),
  CONSTRAINT `fk_Producto_has_Almacen_Almacen1` FOREIGN KEY (`nombre_alamacen`) REFERENCES `almacen` (`nombre`),
  CONSTRAINT `fk_Producto_has_Almacen_Producto1` FOREIGN KEY (`Producto_cod_producto`) REFERENCES `producto` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `cod_proveedor` int NOT NULL,
  `CIF` varchar(45) DEFAULT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `direccion` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `pais` varchar(45) DEFAULT NULL,
  `actividad` varchar(45) DEFAULT NULL,
  `nombre_proveedor` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`cod_proveedor`),
  KEY `proveedores_cod_proveedor_IDX` (`cod_proveedor`,`nombre_proveedor`,`CIF`,`telefono`,`email`,`direccion`,`pais`,`actividad`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;
