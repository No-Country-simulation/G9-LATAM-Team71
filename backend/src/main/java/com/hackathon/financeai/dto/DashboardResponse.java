package com.hackathon.financeai.dto;

import java.util.List;

public class DashboardResponse {
    private UsuarioInfo usuario;
    private AnalisisDashboard analisis;
    private List<MetaActiva> metasActivas;

    public DashboardResponse(UsuarioInfo usuario, AnalisisDashboard analisis, List<MetaActiva> metasActivas) {
        this.usuario = usuario;
        this.analisis = analisis;
        this.metasActivas = metasActivas;
    }

    public UsuarioInfo getUsuario() { return usuario; }
    public AnalisisDashboard getAnalisis() { return analisis; }
    public List<MetaActiva> getMetasActivas() { return metasActivas; }

    public static class UsuarioInfo {
        private String id;
        private String nombre;
        private String apellido;
        private String correo;

        public UsuarioInfo(String id, String nombre, String apellido, String correo) {
            this.id = id;
            this.nombre = nombre;
            this.apellido = apellido;
            this.correo = correo;
        }

        public String getId() { return id; }
        public String getNombre() { return nombre; }
        public String getApellido() { return apellido; }
        public String getCorreo() { return correo; }
    }

    public static class AnalisisDashboard {
        private Double dineroDisponible;
        private String perfilFinanciero;
        private Double nivelEndeudamiento;
        private Double ingresoMensual;
        private List<TransaccionDTO> transaccionesDelMes;
        private List<String> recomendaciones;

        public Double getDineroDisponible() { return dineroDisponible; }
        public void setDineroDisponible(Double dineroDisponible) { this.dineroDisponible = dineroDisponible; }
        public String getPerfilFinanciero() { return perfilFinanciero; }
        public void setPerfilFinanciero(String perfilFinanciero) { this.perfilFinanciero = perfilFinanciero; }
        public Double getNivelEndeudamiento() { return nivelEndeudamiento; }
        public void setNivelEndeudamiento(Double nivelEndeudamiento) { this.nivelEndeudamiento = nivelEndeudamiento; }
        public Double getIngresoMensual() { return ingresoMensual; }
        public void setIngresoMensual(Double ingresoMensual) { this.ingresoMensual = ingresoMensual; }
        public List<TransaccionDTO> getTransaccionesDelMes() { return transaccionesDelMes; }
        public void setTransaccionesDelMes(List<TransaccionDTO> transaccionesDelMes) { this.transaccionesDelMes = transaccionesDelMes; }
        public List<String> getRecomendaciones() { return recomendaciones; }
        public void setRecomendaciones(List<String> recomendaciones) { this.recomendaciones = recomendaciones; }
    }

    public static class MetaActiva {
        private Integer idMeta;
        private String nombreMeta;
        private Double montoObjetivo;
        private Double montoActual;
        private Double progresoPorcentaje;

        public MetaActiva(Integer idMeta, String nombreMeta, Double montoObjetivo, Double montoActual, Double progresoPorcentaje) {
            this.idMeta = idMeta;
            this.nombreMeta = nombreMeta;
            this.montoObjetivo = montoObjetivo;
            this.montoActual = montoActual;
            this.progresoPorcentaje = progresoPorcentaje;
        }

        public Integer getIdMeta() { return idMeta; }
        public String getNombreMeta() { return nombreMeta; }
        public Double getMontoObjetivo() { return montoObjetivo; }
        public Double getMontoActual() { return montoActual; }
        public Double getProgresoPorcentaje() { return progresoPorcentaje; }
    }
}