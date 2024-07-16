import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

@ManagedBean
@RequestScoped
public class RegistroBeanEmpleado {
    private String nombre;
    private String apellido;
    private String email;
    private String telefono;
    private String puesto;
    private String password;

    public String registrar() {
        try (Connection con = DBConnection.getConnection()) {
            String query = "{CALL insertar_empleado_usuario(?, ?, ?, ?, ?, ?)}";
            try (CallableStatement stmt = con.prepareCall(query)) {
                stmt.setString(1, nombre);
                stmt.setString(2, apellido);
                stmt.setString(3, email);
                stmt.setString(4, telefono);
                stmt.setString(5, puesto);
                stmt.setString(6, password);
                
                stmt.execute();
                FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Registro exitoso", "Empleado registrado correctamente"));
                return "login?faces-redirect=true";
            }
        } catch (Exception e) {
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

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
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

    public String getPuesto() {
        return puesto;
    }

    public void setPuesto(String puesto) {
        this.puesto = puesto;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
