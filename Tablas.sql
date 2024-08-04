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
    estado BIT DEFAULT 1, -- 1 = activo, 0 = inactivo
    PRIMARY KEY (categoria_id)
);

-- RF-04 Administración de Menús
CREATE TABLE Menus (
    idItem INT AUTO_INCREMENT,
    nombre_item VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    categoria_id INT,
    estado BIT DEFAULT 1, -- 1 = activo, 0 = inactivo
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

CREATE TABLE Bitacora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(50) NOT NULL,
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    usuario_tipo ENUM('cliente', 'empleado'),
    tabla VARCHAR(50)
);
