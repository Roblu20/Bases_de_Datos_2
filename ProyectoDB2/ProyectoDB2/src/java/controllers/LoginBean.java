import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import java.io.Serializable;

@ManagedBean
@SessionScoped
public class LoginBean implements Serializable {
    private String email;
    private String password;
    private String userType;

    public String login() {
        Object[] loginResult = UsuarioDAO.loginUsuario(email, password);
        int resultCode = (int) loginResult[0];
        userType = (String) loginResult[1];

        switch (resultCode) {
            case 99:
                // Login exitoso
                if ("cliente".equals(userType)) {
                    return "homeCliente.xhtml?faces-redirect=true";
                } else if ("empleado".equals(userType)) {
                    return "homeEmpleado.xhtml?faces-redirect=true";
                }
            case 50:
                // Usuario no encontrado o inactivo
                // Mostrar mensaje de error
                return "login?faces-redirect=true&error=notfound";
            case 51:
                // Contraseña inválida
                // Mostrar mensaje de error
                return "login?faces-redirect=true&error=invalidpassword";
            default:
                // Error desconocido
                return "login?faces-redirect=true&error=unknown";
        }
    }

    // Getters y setters para email, password y userType
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }
}
