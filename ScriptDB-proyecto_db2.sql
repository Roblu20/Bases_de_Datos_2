CREATE DATABASE IF NOT EXISTS `proyecto_db2`;
USE `proyecto_db2`;

-- Tablas
DROP TABLE IF EXISTS `categorias_menu`;
CREATE TABLE `categorias_menu` (
  `categoria_id` int NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(50) NOT NULL,
  `descripcion_categoria` text,
  PRIMARY KEY (`categoria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido1` varchar(50) NOT NULL,
  `apellido2` varchar(50) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `password` varbinary(256) NOT NULL,
  `estado` bit(1) DEFAULT b'1',
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `empleados`;
CREATE TABLE `empleados` (
  `empleado_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `puesto` varchar(50) NOT NULL,
  `password` varbinary(256) NOT NULL,
  `estado` bit(1) DEFAULT b'1',
  PRIMARY KEY (`empleado_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `inventario`;
CREATE TABLE `inventario` (
  `producto_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `proveedor_id` int DEFAULT NULL,
  PRIMARY KEY (`producto_id`),
  KEY `proveedor_id` (`proveedor_id`),
  CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`proveedor_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `idItem` int NOT NULL AUTO_INCREMENT,
  `nombre_item` varchar(100) NOT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  `categoria_id` int DEFAULT NULL,
  PRIMARY KEY (`idItem`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `menus_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias_menu` (`categoria_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `mesas`;
CREATE TABLE `mesas` (
  `mesa_id` int NOT NULL AUTO_INCREMENT,
  `numero_mesa` int NOT NULL,
  `capacidad` int NOT NULL,
  `ubicacion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`mesa_id`),
  UNIQUE KEY `numero_mesa` (`numero_mesa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE `pedidos` (
  `pedido_id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `fecha_pedido` date NOT NULL,
  `estado_pedido` varchar(20) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`pedido_id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`idCliente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE `proveedores` (
  `proveedor_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `contacto` varchar(50) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`proveedor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `reportes`;
CREATE TABLE `reportes` (
  `idReporte` int NOT NULL AUTO_INCREMENT,
  `reporte_tipo` varchar(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  PRIMARY KEY (`idReporte`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `reservaciones`;
CREATE TABLE `reservaciones` (
  `idReservacion` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `mesa_id` int NOT NULL,
  `num_personas` int NOT NULL,
  PRIMARY KEY (`idReservacion`),
  KEY `cliente_id` (`cliente_id`),
  KEY `mesa_id` (`mesa_id`),
  CONSTRAINT `reservaciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`idCliente`) ON DELETE CASCADE,
  CONSTRAINT `reservaciones_ibfk_2` FOREIGN KEY (`mesa_id`) REFERENCES `mesas` (`mesa_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Procedimientos almacenados
DELIMITER ;;

CREATE PROCEDURE `CreateMesa`(
    IN numero_mesa INT,
    IN capacidad INT,
    IN ubicacion VARCHAR(50)
)
BEGIN
    INSERT INTO Mesas (numero_mesa, capacidad, ubicacion)
    VALUES (numero_mesa, capacidad, ubicacion);
END;;

CREATE PROCEDURE `CreateReservacion`(
    IN cliente_id INT,
    IN fecha DATE,
    IN hora TIME,
    IN mesa_id INT,
    IN num_personas INT
)
BEGIN
    INSERT INTO Reservaciones (cliente_id, fecha, hora, mesa_id, num_personas)
    VALUES (cliente_id, fecha, hora, mesa_id, num_personas);
END;;

CREATE PROCEDURE `DeleteMesa`(IN mesa_id INT)
BEGIN
    DELETE FROM Mesas WHERE mesa_id = mesa_id;
END;;

CREATE PROCEDURE `DeleteReservacion`(IN idReservacion INT)
BEGIN
    DELETE FROM Reservaciones WHERE idReservacion = idReservacion;
END;;

CREATE PROCEDURE `desactivar_cliente`(
    IN p_idCliente INT
)
BEGIN
    UPDATE Clientes SET estado = 0 WHERE idCliente = p_idCliente;
END;;

CREATE PROCEDURE `desactivar_empleado`(
    IN p_empleado_id INT
)
BEGIN
    UPDATE Empleados SET estado = 0 WHERE empleado_id = p_empleado_id;
END;;

CREATE PROCEDURE `EncryptPassword`(
    IN rawPassword VARCHAR(256), 
    OUT encryptedPassword VARBINARY(256)
)
BEGIN
    SET encryptedPassword = SHA2(rawPassword, 256);
END;;

CREATE PROCEDURE `GetMesa`(IN mesa_id INT)
BEGIN
    SELECT * FROM Mesas WHERE mesa_id = mesa_id;
END;;

CREATE PROCEDURE `GetReservacion`(IN idReservacion INT)
BEGIN
    SELECT * FROM Reservaciones WHERE idReservacion = idReservacion;
END;;

CREATE PROCEDURE `insertar_cliente_usuario`(
    IN p_nombre VARCHAR(50),
    IN p_apellido1 VARCHAR(50),
    IN p_apellido2 VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_telefono VARCHAR(20),
    IN p_clave VARCHAR(256)
)
BEGIN
    DECLARE v_clave_encriptada VARBINARY(256);
    CALL EncryptPassword(p_clave, v_clave_encriptada);

    INSERT INTO Clientes (nombre, apellido1, apellido2, email, telefono, password, estado)
    VALUES (p_nombre, p_apellido1, p_apellido2, p_email, p_telefono, v_clave_encriptada, 1);
END;;

CREATE PROCEDURE `insertar_empleado_usuario`(
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_telefono VARCHAR(20),
    IN p_puesto VARCHAR(50),
    IN p_clave VARCHAR(256)
)
BEGIN
    DECLARE v_clave_encriptada VARBINARY(256);
    CALL EncryptPassword(p_clave, v_clave_encriptada);

    INSERT INTO Empleados (nombre, apellido, email, telefono, puesto, password, estado)
    VALUES (p_nombre, p_apellido, p_email, p_telefono, p_puesto, v_clave_encriptada, 1);
END