
package controllers;

import clases.Reservacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservacionController {
    
    private Connection connection;

    public ReservacionController(Connection connection) {
        this.connection = connection;
    }

    public void createReservacion(Reservacion reservacion) throws SQLException {
        String sql = "{CALL CreateReservacion(?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, reservacion.getClienteId());
            stmt.setDate(2, new java.sql.Date(reservacion.getFecha().getTime()));
            stmt.setTime(3, reservacion.getHora());
            stmt.setInt(4, reservacion.getMesaId());
            stmt.setInt(5, reservacion.getNumPersonas());
            stmt.execute();
        }
    }

    public Reservacion getReservacion(int idReservacion) throws SQLException {
        String sql = "{CALL GetReservacion(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, idReservacion);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Reservacion reservacion = new Reservacion();
                reservacion.setIdReservacion(rs.getInt("idReservacion"));
                reservacion.setClienteId(rs.getInt("cliente_id"));
                reservacion.setFecha(rs.getDate("fecha"));
                reservacion.setHora(rs.getTime("hora"));
                reservacion.setMesaId(rs.getInt("mesa_id"));
                reservacion.setNumPersonas(rs.getInt("num_personas"));
                return reservacion;
            } else {
                return null;
            }
        }
    }

    public List<Reservacion> getAllReservaciones() throws SQLException {
        List<Reservacion> reservaciones = new ArrayList<>();
        String sql = "{CALL GetAllReservaciones()}";
        try (CallableStatement stmt = connection.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Reservacion reservacion = new Reservacion();
                reservacion.setIdReservacion(rs.getInt("idReservacion"));
                reservacion.setClienteId(rs.getInt("cliente_id"));
                reservacion.setFecha(rs.getDate("fecha"));
                reservacion.setHora(rs.getTime("hora"));
                reservacion.setMesaId(rs.getInt("mesa_id"));
                reservacion.setNumPersonas(rs.getInt("num_personas"));
                reservaciones.add(reservacion);
            }
        }
        return reservaciones;
    }

    public void updateReservacion(Reservacion reservacion) throws SQLException {
        String sql = "{CALL UpdateReservacion(?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, reservacion.getIdReservacion());
            stmt.setInt(2, reservacion.getClienteId());
            stmt.setDate(3, new java.sql.Date(reservacion.getFecha().getTime()));
            stmt.setTime(4, reservacion.getHora());
            stmt.setInt(5, reservacion.getMesaId());
            stmt.setInt(6, reservacion.getNumPersonas());
            stmt.execute();
        }
    }

    public void deleteReservacion(int idReservacion) throws SQLException {
        String sql = "{CALL DeleteReservacion(?)}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
            stmt.setInt(1, idReservacion);
            stmt.execute();
        }
    }
}