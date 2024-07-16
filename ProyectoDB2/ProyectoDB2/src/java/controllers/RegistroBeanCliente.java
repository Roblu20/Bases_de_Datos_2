import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

@ManagedBean
@RequestScoped
public class RegistroBeanCliente {
    private String nombre;
    private String apellido1;
    private String apellido2;
    private String email;
    private String telefono;
    private String password;

    public String registrar() {
        try (Connection con = DBConnection.getConnection()) {
            String query = "{CALL insertar_cliente_usuario(?, ?, ?, ?, ?, ?)}";
            try (CallableStatement stmt = con.prepareCall(query)) {
                stmt.setString(1, nombre);
                stmt.setString(2, apellido1);
                stmt.setString(3, apellido2);
                stmt.setString(4, email);
                stmt.setString(5, telefono);
                stmt.setString(6, password);
                
                stmt.execute();
                FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro exitoso", "Cliente registrado correctamente"));
                return "login?faces-redirect=true";
            }
        } catch ( Exception e) {
            e.printStackTrace();
            FacesContext.getCurrentInstance().addMessage(null,
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error", "Error de conexión a la base de datos"));
        }
        return null;
    }

    // Getters y setters
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
}
