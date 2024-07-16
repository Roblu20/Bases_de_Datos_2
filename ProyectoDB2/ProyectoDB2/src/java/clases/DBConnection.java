import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws Exception {
        Connection conn = null;
        try {
            // Paso 1
            Class.forName("com.mysql.jdbc.Driver");

            // Paso 2
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/restaurante1?serverTimezone=UTC&zeroDateTimeBehavior=convertToNull", "root", "root");
            System.out.println("CONEXION: " + conn);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new Exception("Error al conectar a la base de datos", e);
        }
        return conn;
    }
}
