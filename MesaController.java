
package controllers;

import clases.Mesa;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MesaController {
    
    private Connection connection;

    public MesaController(Connection connection) {
        this.connection = connection;
    }

    public void createMesa(Mesa mesa) throws SQLException {
        String sql = "{CALL CreateMesa(?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, mesa.getNumeroMesa());
            stmt.setInt(2, mesa.getCapacidad());
            stmt.setString(3, mesa.getUbicacion());
            stmt.execute();
        }
    }

    public Mesa getMesa(int mesaId) throws SQLException {
        String sql = "{CALL GetMesa(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, mesaId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Mesa mesa = new Mesa();
                mesa.setMesaId(rs.getInt("mesa_id"));
                mesa.setNumeroMesa(rs.getInt("numero_mesa"));
                mesa.setCapacidad(rs.getInt("capacidad"));
                mesa.setUbicacion(rs.getString("ubicacion"));
                return mesa;
            } else {
                return null;
            }
        }
    }

    public List<Mesa> getAllMesas() throws SQLException {
        List<Mesa> mesas = new ArrayList<>();
        String sql = "{CALL GetAllMesas()}";
        try (CallableStatement stmt = connection.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Mesa mesa = new Mesa();
                mesa.setMesaId(rs.getInt("mesa_id"));
                mesa.setNumeroMesa(rs.getInt("numero_mesa"));
                mesa.setCapacidad(rs.getInt("capacidad"));
                mesa.setUbicacion(rs.getString("ubicacion"));
                mesas.add(mesa);
            }
        }
        return mesas;
    }

    public void updateMesa(Mesa mesa) throws SQLException {
        String sql = "{CALL UpdateMesa(?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, mesa.getMesaId());
            stmt.setInt(2, mesa.getNumeroMesa());
            stmt.setInt(3, mesa.getCapacidad());
            stmt.setString(4, mesa.getUbicacion());
            stmt.execute();
        }
    }

    public void deleteMesa(int mesaId) throws SQLException {
        String sql = "{CALL DeleteMesa(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, mesaId);
            stmt.execute();
        }
    }
}
