CREATE DATABASE Restaurante1;
USE Restaurante1;

-- RF-03 Gestión de Clientes
CREATE TABLE Clientes (
    idCliente INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    email VARCHAR(50) NOT NULL UNIQUE,   -- Email utilizado para login
    telefono VARCHAR(20),
    password VARBINARY(256) NOT NULL,    -- Password encriptada para login
    estado BIT DEFAULT 1,                -- Estado para borrado lógico
    PRIMARY KEY (idCliente)
);

-- RF-06 Gestión de Empleados
CREATE TABLE Empleados (
    empleado_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,   -- Email utilizado para login
    telefono VARCHAR(20),
    puesto VARCHAR(50) NOT NULL,
    password VARBINARY(256) NOT NULL,    -- Password encriptada para login
    estado BIT DEFAULT 1,                -- Estado para borrado lógico
    PRIMARY KEY (empleado_id)
);

-- RF-10 Gestión de Mesas
CREATE TABLE Mesas (
    mesa_id INT AUTO_INCREMENT,
    numero_mesa INT NOT NULL UNIQUE,
    capacidad INT NOT NULL,
    ubicacion VARCHAR(50),
    PRIMARY KEY (mesa_id)
);

-- RF-02 Registro de Reservaciones
CREATE TABLE Reservaciones (
    idReservacion INT AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    mesa_id INT NOT NULL,
    num_personas INT NOT NULL,
    PRIMARY KEY (idReservacion),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(idCliente) ON DELETE CASCADE,
    FOREIGN KEY (mesa_id) REFERENCES Mesas(mesa_id) ON DELETE CASCADE
);

-- RF-11 Gestión de Categorías de Menú
CREATE TABLE Categorias_Menu (
    categoria_id INT AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion_categoria TEXT,
    PRIMARY KEY (categoria_id)
);

-- RF-04 Administración de Menús
CREATE TABLE Menus (
    idItem INT AUTO_INCREMENT,
    nombre_item VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    categoria_id INT,
    PRIMARY KEY (idItem),
    FOREIGN KEY (categoria_id) REFERENCES Categorias_Menu(categoria_id) ON DELETE SET NULL
);

-- RF-05 Generación de Reportes
CREATE TABLE Reportes (
    idReporte INT AUTO_INCREMENT,
    reporte_tipo VARCHAR(20) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    PRIMARY KEY (idReporte)
);

-- RF-07 Gestión de Proveedores
CREATE TABLE Proveedores (
    proveedor_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    contacto VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(100),
    PRIMARY KEY (proveedor_id)
);

-- RF-08 Inventario de Productos
CREATE TABLE Inventario (
    producto_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    proveedor_id INT,
    PRIMARY KEY (producto_id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(proveedor_id) ON DELETE SET NULL
);

-- RF-09 Gestión de Pedidos
CREATE TABLE Pedidos (
    pedido_id INT AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    fecha_pedido DATE NOT NULL,
    estado_pedido VARCHAR(20) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pedido_id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(idCliente) ON DELETE CASCADE
);

DELIMITER //

-- Insertar Usuario (Cliente)
CREATE PROCEDURE insertar_cliente_usuario(
    IN p_nombre VARCHAR(50),
    IN p_apellido1 VARCHAR(50),
    IN p_apellido2 VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_telefono VARCHAR(20),
    IN p_clave VARCHAR(256)
)
BEGIN
    DECLARE v_clave_encriptada VARBINARY(256);
    SET v_clave_encriptada = SHA2(p_clave, 256);

    INSERT INTO Clientes (nombre, apellido1, apellido2, email, telefono, password, estado)
    VALUES (p_nombre, p_apellido1, p_apellido2, p_email, p_telefono, v_clave_encriptada, 1);
END //
DELIMITER ;


-- Insertar Usuario (Empleado)
DELIMITER //
CREATE PROCEDURE insertar_empleado_usuario(
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_telefono VARCHAR(20),
    IN p_puesto VARCHAR(50),
    IN p_clave VARCHAR(256)
)
BEGIN
    DECLARE v_clave_encriptada VARBINARY(256);
    SET v_clave_encriptada = SHA2(p_clave, 256);

    INSERT INTO Empleados (nombre, apellido, email, telefono, puesto, password, estado)
    VALUES (p_nombre, p_apellido, p_email, p_telefono, p_puesto, v_clave_encriptada, 1);
END //
DELIMITER ;

-- Procedimiento para actualizar estado de Cliente (borrado lógico)
DELIMITER //
CREATE PROCEDURE desactivar_cliente(
    IN p_idCliente INT
)
BEGIN
    UPDATE Clientes
    SET estado = 0
    WHERE idCliente = p_idCliente;
END //
DELIMITER ;

-- Procedimiento para actualizar estado de Empleado (borrado lógico)
DELIMITER //
CREATE PROCEDURE desactivar_empleado(
    IN p_empleado_id INT
)
BEGIN
    UPDATE Empleados
    SET estado = 0
    WHERE empleado_id = p_empleado_id;
END //
DELIMITER ;

-- Login (para Clientes y Empleados)
DELIMITER //
CREATE PROCEDURE login_usuario(
    IN p_email VARCHAR(50),
    IN p_password VARCHAR(256)
)
BEGIN
    DECLARE v_cliente_id INT;
    DECLARE v_empleado_id INT;
    DECLARE v_storedPassword VARBINARY(256);
    DECLARE v_encryptedPassword VARBINARY(256);
    DECLARE v_userType VARCHAR(10);
    DECLARE v_estado BIT;

    -- Encriptar la contraseña ingresada por el usuario
    SET v_encryptedPassword = SHA2(p_password, 256);

    -- Verificar si el usuario es un cliente
    SELECT idCliente, password, estado INTO v_cliente_id, v_storedPassword, v_estado
    FROM Clientes
    WHERE email = p_email AND estado = 1;

    IF v_cliente_id IS NOT NULL THEN
        SET v_userType = 'cliente';
    ELSE
        -- Verificar si el usuario es un empleado
        SELECT empleado_id, password, estado INTO v_empleado_id, v_storedPassword, v_estado
        FROM Empleados
        WHERE email = p_email AND estado = 1;

        IF v_empleado_id IS NOT NULL THEN
            SET v_userType = 'empleado';
        END IF;
    END IF;

    -- Verificar si el usuario fue encontrado
    IF v_userType IS NULL THEN
        SELECT 50 AS RESULTCODE; -- Usuario no encontrado o inactivo
    ELSE
        -- Verificar la contraseña
        IF v_storedPassword = v_encryptedPassword THEN
            SELECT 99 AS RESULTCODE, v_userType AS USERTYPE; -- Login exitoso
        ELSE
            SELECT 51 AS RESULTCODE; -- Contraseña inválida
        END IF;
    END IF;
END //

DELIMITER ;

-- Inserción de un cliente
CALL insertar_cliente_usuario('Juan', 'Pérez', 'Gómez', 'juan@example.com', '1234567890', 'password123');

-- Inserción de un empleado
CALL insertar_empleado_usuario('Walter', 'Whiite', 'walter@example.com', '211231231', 'Cocinero', 'password111');

-- Login exitoso de un cliente
CALL login_usuario('juan@example.com', 'password123');

-- Login exitoso de un empleado
CALL login_usuario('ana@example.com', 'password456');

-- Usuario no encontrado o inactivo
CALL login_usuario('notfound@example.com', 'password123');
CALL login_usuario('walter@example.com', 'password111');

-- Contraseña inválida
CALL login_usuario('juan@example.com', 'wrongpassword');
-- Borrado lógico cliente
-- CALL desactivar_cliente(1); 

-- Borrado lógico empleado
-- CALL desactivar_empleado(2); 