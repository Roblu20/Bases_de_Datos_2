DELIMITER //

CREATE PROCEDURE EncryptPassword(IN rawPassword VARCHAR(256), OUT encryptedPassword VARBINARY(256))
BEGIN
    SET encryptedPassword = SHA2(rawPassword, 256);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE RegisterCliente(
    IN nombre VARCHAR(50),
    IN apellido1 VARCHAR(50),
    IN apellido2 VARCHAR(50),
    IN email VARCHAR(50),
    IN telefono VARCHAR(20),
    IN rawPassword VARCHAR(256),
    IN esAdmin BOOLEAN
)
BEGIN
    DECLARE encryptedPassword VARBINARY(256);
    CALL EncryptPassword(rawPassword, encryptedPassword);

    INSERT INTO Clientes (nombre, apellido1, apellido2, email, telefono, password, estado)
    VALUES (nombre, apellido1, apellido2, email, telefono, encryptedPassword, 1);

    
        -- lógica para asignar roles de administrador
        
    
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ValidateLogin(
    IN email VARCHAR(50),
    IN rawPassword VARCHAR(256),
    OUT isValid BOOLEAN
)
BEGIN
    DECLARE encryptedPassword VARBINARY(256);
    DECLARE storedPassword VARBINARY(256);

    CALL EncryptPassword(rawPassword, encryptedPassword);

    SELECT password INTO storedPassword FROM Clientes WHERE email = email;

    IF encryptedPassword = storedPassword THEN
        SET isValid = TRUE;
    ELSE
        SET isValid = FALSE;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetCliente(IN idCliente INT)
BEGIN
    SELECT * FROM Clientes WHERE idCliente = idCliente AND estado = 1;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateCliente(
    IN idCliente INT,
    IN nombre VARCHAR(50),
    IN apellido1 VARCHAR(50),
    IN apellido2 VARCHAR(50),
    IN email VARCHAR(50),
    IN telefono VARCHAR(20),
    IN rawPassword VARCHAR(256)
)
BEGIN
    DECLARE encryptedPassword VARBINARY(256);
    CALL EncryptPassword(rawPassword, encryptedPassword);

    UPDATE Clientes 
    SET nombre = nombre, 
        apellido1 = apellido1, 
        apellido2 = apellido2, 
        email = email, 
        telefono = telefono, 
        password = encryptedPassword 
    WHERE idCliente = idCliente;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteCliente(IN idCliente INT)
BEGIN
    UPDATE Clientes 
    SET estado = 0 
    WHERE idCliente = idCliente;
END //

DELIMITER ;
