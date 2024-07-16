package controllers;

import clases.Cliente;
import clases.DBConnection;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;

@ManagedBean
@RequestScoped
public class MasterController {

    private Connection connection;
    private ClienteController clienteController;
    private String loginEmail;
    private String loginPassword;
    private String nombre;
    private String apellido1;
    private String apellido2;
    private String email;
    private String telefono;
    private String password;

    public MasterController() {
        try {
            this.connection = DBConnection.getConnection();
            this.clienteController = new ClienteController(connection);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Getters and Setters
    public String getLoginEmail() {
        return loginEmail;
    }

    public void setLoginEmail(String loginEmail) {
        this.loginEmail = loginEmail;
    }

    public String getLoginPassword() {
        return loginPassword;
    }

    public void setLoginPassword(String loginPassword) {
        this.loginPassword = loginPassword;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido1() {
        return apellido1;
    }

    public void setApellido1(String apellido1) {
        this.apellido1 = apellido1;
    }

    public String getApellido2() {
        return apellido2;
    }

    public void setApellido2(String apellido2) {
        this.apellido2 = apellido2;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void login() {
        try {
            Cliente cliente = clienteController.getClienteByEmail(loginEmail);
            if (cliente != null && verifyPassword(loginPassword, cliente.getPassword())) {
                FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Login exitoso", "Bienvenido " + cliente.getNombre()));
            } else {
                FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Login fallido", "Correo o contraseña incorrectos"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", "Ha ocurrido un error con la base de datos"));
        }
    }

    public void register() {
        try {
            Cliente cliente = new Cliente();
            cliente.setNombre(nombre);
            cliente.setApellido1(apellido1);
            cliente.setApellido2(apellido2);
            cliente.setEmail(email);
            cliente.setTelefono(telefono);
            cliente.setPassword(encryptPassword(password));

            System.out.println("Nombre: " + nombre);
            System.out.println("Apellido1: " + apellido1);
            System.out.println("Apellido2: " + apellido2);
            System.out.println("Email: " + email);
            System.out.println("Telefono: " + telefono);

            clienteController.createCliente(cliente);
            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro exitoso", "Cliente registrado correctamente"));
        } catch (SQLException e) {
            e.printStackTrace();
            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", "Ha ocurrido un error con la base de datos"));
        }
    }

    private boolean verifyPassword(String rawPassword, byte[] encryptedPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedPassword = md.digest(rawPassword.getBytes());
            return MessageDigest.isEqual(hashedPassword, encryptedPassword);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return false;
        }
    }

    private byte[] encryptPassword(String rawPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return md.digest(rawPassword.getBytes());
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}
