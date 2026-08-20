package com.hackathon.financeai.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 100)
    private String apellido;

    @Column(nullable = false, unique = true)
    private String correo;

    @Column(nullable = false)
    private String contrasena;

    @Column(name = "ingreso_mensual", nullable = false, precision = 10, scale = 2)
    private float ingresoMensual = 0.0f;

    @Column(name = "frecuencia_ahorro", nullable = false, length = 50)
    private String frecuenciaAhorro = "MEDIA";

    @Column(name = "nivel_endeudamiento", nullable = false, precision = 5, scale = 2)
    private float nivelEndeudamiento = 0.0f;

    @Column(nullable = false)
    private Boolean activo = true;

    @Enumerated(EnumType.STRING)
    @Column(name = "perfil_financiero", nullable = false, length = 50)
    private PerfilFinanciero perfilFinanciero = PerfilFinanciero.EN_OBSERVACION;

    @Column(columnDefinition = "jsonb")
    private String recomendaciones;

    @Column(name = "fecha_creacion", insertable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    public Usuario() {}

    public Usuario(UUID id, String nombre, String apellido, String correo, String contrasena, float ingresoMensual, String frecuenciaAhorro, float nivelEndeudamiento, Boolean activo, PerfilFinanciero perfilFinanciero, String recomendaciones, LocalDateTime fechaCreacion) {
        this.id = id;
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.contrasena = contrasena;
        this.ingresoMensual = ingresoMensual;
        this.frecuenciaAhorro = frecuenciaAhorro;
        this.nivelEndeudamiento = nivelEndeudamiento;
        this.activo = activo;
        this.perfilFinanciero = perfilFinanciero;
        this.recomendaciones = recomendaciones;
        this.fechaCreacion = fechaCreacion;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }

    public float getIngresoMensual() { return ingresoMensual; }
    public void setIngresoMensual(float ingresoMensual) { this.ingresoMensual = ingresoMensual; }

    public String getFrecuenciaAhorro() { return frecuenciaAhorro; }
    public void setFrecuenciaAhorro(String frecuenciaAhorro) { this.frecuenciaAhorro = frecuenciaAhorro; }

    public float getNivelEndeudamiento() { return nivelEndeudamiento; }
    public void setNivelEndeudamiento(float nivelEndeudamiento) { this.nivelEndeudamiento = nivelEndeudamiento; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }

    public PerfilFinanciero getPerfilFinanciero() { return perfilFinanciero; }
    public void setPerfilFinanciero(PerfilFinanciero perfilFinanciero) { this.perfilFinanciero = perfilFinanciero; }

    public String getRecomendaciones() { return recomendaciones; }
    public void setRecomendaciones(String recomendaciones) { this.recomendaciones = recomendaciones; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}
