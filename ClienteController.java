
package controllers;

import clases.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteController {
    
    private Connection connection;

    public ClienteController(Connection connection) {
        this.connection = connection;
    }

    public void createCliente(Cliente cliente) throws SQLException {
        String sql = "{CALL insertar_cliente_usuario(?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setString(1, cliente.getNombre());
            stmt.setString(2, cliente.getApellido1());
            stmt.setString(3, cliente.getApellido2());
            stmt.setString(4, cliente.getEmail());
            stmt.setString(5, cliente.getTelefono());
            stmt.setBytes(6, cliente.getPassword()); // Assumes password is already encrypted
            stmt.execute();
        }
    }

    public Cliente getCliente(int idCliente) throws SQLException {
        String sql = "{CALL GetCliente(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("idCliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido1(rs.getString("apellido1"));
                cliente.setApellido2(rs.getString("apellido2"));
                cliente.setEmail(rs.getString("email"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setPassword(rs.getBytes("password"));
                cliente.setEstado(rs.getBoolean("estado"));
                return cliente;
            } else {
                return null;
            }
        }
    }

    public List<Cliente> getAllClientes() throws SQLException {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "{CALL GetAllClientes()}";
        try (CallableStatement stmt = connection.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("idCliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido1(rs.getString("apellido1"));
                cliente.setApellido2(rs.getString("apellido2"));
                cliente.setEmail(rs.getString("email"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setPassword(rs.getBytes("password"));
                cliente.setEstado(rs.getBoolean("estado"));
                clientes.add(cliente);
            }
        }
        return clientes;
    }

    public void updateCliente(Cliente cliente) throws SQLException {
        String sql = "{CALL UpdateCliente(?, ?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, cliente.getIdCliente());
            stmt.setString(2, cliente.getNombre());
            stmt.setString(3, cliente.getApellido1());
            stmt.setString(4, cliente.getApellido2());
            stmt.setString(5, cliente.getEmail());
            stmt.setString(6, cliente.getTelefono());
            stmt.setBytes(7, cliente.getPassword()); // Assumes password is already encrypted
            stmt.execute();
        }
    }

    public void deleteCliente(int idCliente) throws SQLException {
        String sql = "{CALL desactivar_cliente(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, idCliente);
            stmt.execute();
        }
    }
}