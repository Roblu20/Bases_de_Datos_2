
package clases;

import java.util.Date;

public class Reporte {
    
    private int idReporte;
    private String reporteTipo;
    private Date fechaInicio;
    private Date fechaFin;

    public int getIdReporte() {
        return idReporte;
    }

    public void setIdReporte(int idReporte) {
        this.idReporte = idReporte;
    }

    public String getReporteTipo() {
        return reporteTipo;
    }

    public void setReporteTipo(String reporteTipo) {
        this.reporteTipo = reporteTipo;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }
}
