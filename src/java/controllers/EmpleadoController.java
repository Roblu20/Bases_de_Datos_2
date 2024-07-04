
package controllers;

import clases.Empleado;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoController {
    
    private Connection connection;

    public EmpleadoController(Connection connection) {
        this.connection = connection;
    }

    public void createEmpleado(Empleado empleado) throws SQLException {
        String sql = "{CALL insertar_empleado_usuario(?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setString(1, empleado.getNombre());
            stmt.setString(2, empleado.getApellido());
            stmt.setString(3, empleado.getEmail());
            stmt.setString(4, empleado.getTelefono());
            stmt.setString(5, empleado.getPuesto());
            stmt.setBytes(6, empleado.getPassword()); // Assumes password is already encrypted
            stmt.execute();
        }
    }

    public Empleado getEmpleado(int empleadoId) throws SQLException {
        String sql = "{CALL GetEmpleado(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, empleadoId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Empleado empleado = new Empleado();
                empleado.setEmpleadoId(rs.getInt("empleado_id"));
                empleado.setNombre(rs.getString("nombre"));
                empleado.setApellido(rs.getString("apellido"));
                empleado.setEmail(rs.getString("email"));
                empleado.setTelefono(rs.getString("telefono"));
                empleado.setPuesto(rs.getString("puesto"));
                empleado.setPassword(rs.getBytes("password"));
                empleado.setEstado(rs.getBoolean("estado"));
                return empleado;
            } else {
                return null;
            }
        }
    }

    public List<Empleado> getAllEmpleados() throws SQLException {
        List<Empleado> empleados = new ArrayList<>();
        String sql = "{CALL GetAllEmpleados()}";
        try (CallableStatement stmt = connection.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Empleado empleado = new Empleado();
                empleado.setEmpleadoId(rs.getInt("empleado_id"));
                empleado.setNombre(rs.getString("nombre"));
                empleado.setApellido(rs.getString("apellido"));
                empleado.setEmail(rs.getString("email"));
                empleado.setTelefono(rs.getString("telefono"));
                empleado.setPuesto(rs.getString("puesto"));
                empleado.setPassword(rs.getBytes("password"));
                empleado.setEstado(rs.getBoolean("estado"));
                empleados.add(empleado);
            }
        }
        return empleados;
    }

    public void updateEmpleado(Empleado empleado) throws SQLException {
        String sql = "{CALL UpdateEmpleado(?, ?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, empleado.getEmpleadoId());
            stmt.setString(2, empleado.getNombre());
            stmt.setString(3, empleado.getApellido());
            stmt.setString(4, empleado.getEmail());
            stmt.setString(5, empleado.getTelefono());
            stmt.setString(6, empleado.getPuesto());
            stmt.setBytes(7, empleado.getPassword()); // Assumes password is already encrypted
            stmt.execute();
        }
    }

    public void deleteEmpleado(int empleadoId) throws SQLException {
        String sql = "{CALL desactivar_empleado(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, empleadoId);
            stmt.execute();
        }
    }
}
