import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public static Object[] loginUsuario(String email, String password) {
        int resultCode = 0;
        String userType = null;
        try (Connection con = DBConnection.getConnection()) {
            String query = "{CALL login_usuario(?, ?)}";
            try (CallableStatement stmt = con.prepareCall(query)) {
                stmt.setString(1, email);
                stmt.setString(2, password);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        resultCode = rs.getInt("RESULTCODE");
                        if (resultCode == 99) {
                            userType = rs.getString("USERTYPE");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Object[] { resultCode, userType };
    }
}
