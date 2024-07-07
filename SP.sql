
USE Restaurante1;

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


DELIMITER ;
-- Crear una categoria de menu
DELIMITER //
CREATE PROCEDURE crear_categoria_menu(
    IN p_nombre_categoria VARCHAR(50),
    IN p_descripcion_categoria TEXT
)
BEGIN
    INSERT INTO Categorias_Menu (nombre_categoria, descripcion_categoria)
    VALUES (p_nombre_categoria, p_descripcion_categoria);
END //
DELIMITER ;

-- Leer todas las categorias del menu
DELIMITER //
CREATE PROCEDURE leer_categorias_menu()
BEGIN
    SELECT * FROM Categorias_Menu WHERE estado = 1;
END //
DELIMITER ;

-- Leer una categoría de menú por ID
DELIMITER //
CREATE PROCEDURE leer_categoria_menu_por_id(
    IN p_categoria_id INT
)
BEGIN
    SELECT * FROM Categorias_Menu WHERE categoria_id = p_categoria_id AND estado = 1;
END //
DELIMITER ;

-- Actualizar una categoría de menú
DELIMITER //
CREATE PROCEDURE actualizar_categoria_menu(
    IN p_categoria_id INT,
    IN p_nombre_categoria VARCHAR(50),
    IN p_descripcion_categoria TEXT
)
BEGIN
    UPDATE Categorias_Menu
    SET nombre_categoria = p_nombre_categoria,
        descripcion_categoria = p_descripcion_categoria
    WHERE categoria_id = p_categoria_id AND estado = 1;
END //
DELIMITER ;

-- Eliminar una categoría de menú (Borrado Lógico)
DELIMITER //
CREATE PROCEDURE eliminar_categoria_menu(
    IN p_categoria_id INT
)
BEGIN
    UPDATE Categorias_Menu
    SET estado = 0
    WHERE categoria_id = p_categoria_id;
END //
DELIMITER ;

-- Crear un ítem del menú
DELIMITER //
CREATE PROCEDURE crear_menu_item(
    IN p_nombre_item VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10, 2),
    IN p_categoria_id INT
)
BEGIN
    INSERT INTO Menus (nombre_item, descripcion, precio, categoria_id)
    VALUES (p_nombre_item, p_descripcion, p_precio, p_categoria_id);
END //
DELIMITER ;

-- Leer todos los ítems del menú
DELIMITER //
CREATE PROCEDURE leer_menu_items()
BEGIN
    SELECT * FROM Menus WHERE estado = 1;
END //
DELIMITER ;

-- Leer un ítem del menú por ID
DELIMITER //
CREATE PROCEDURE leer_menu_item_por_id(
    IN p_idItem INT
)
BEGIN
    SELECT * FROM Menus WHERE idItem = p_idItem AND estado = 1;
END //
DELIMITER ;

-- Actualizar un ítem del menú
DELIMITER //
CREATE PROCEDURE actualizar_menu_item(
    IN p_idItem INT,
    IN p_nombre_item VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10, 2),
    IN p_categoria_id INT
)
BEGIN
    UPDATE Menus
    SET nombre_item = p_nombre_item,
        descripcion = p_descripcion,
        precio = p_precio,
        categoria_id = p_categoria_id
    WHERE idItem = p_idItem AND estado = 1;
END //
DELIMITER ;

-- Eliminar un ítem del menú (Borrado Lógico)
DELIMITER //
CREATE PROCEDURE eliminar_menu_item(
    IN p_idItem INT
)
BEGIN
    UPDATE Menus
    SET estado = 0
    WHERE idItem = p_idItem;
END //
DELIMITER ;

-- TEST CATEGORIAS_MENU
-- Crear una categoría de menú
CALL crear_categoria_menu('Entradas', 'Platos para empezar la comida');

-- Leer todas las categorías de menú
CALL leer_categorias_menu();

-- Leer una categoría de menú por ID
CALL leer_categoria_menu_por_id(1);

-- Actualizar una categoría de menú
CALL actualizar_categoria_menu(1, 'Platos Principales', 'Platos principales del menú');

-- Eliminar una categoría de menú
CALL eliminar_categoria_menu(1);

-- TEST MENUS
-- Crear un ítem del menú
CALL crear_menu_item('Pizza', 'Deliciosa pizza con queso y pepperoni', 12.99, 1);

-- Leer todos los ítems del menú
CALL leer_menu_items();

-- Leer un ítem del menú por ID
CALL leer_menu_item_por_id(1);

-- Actualizar un ítem del menú
CALL actualizar_menu_item(1, 'Pizza Margarita', 'Pizza con queso mozzarella y albahaca', 13.99, 1);

-- Eliminar un ítem del menú
CALL eliminar_menu_item(1);






