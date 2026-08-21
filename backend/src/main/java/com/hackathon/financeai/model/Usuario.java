package com.hackathon.financeai.model;

import jakarta.persistence.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "usuarios")
public class Usuario implements UserDetails {

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
    private BigDecimal ingresoMensual = BigDecimal.ZERO;

    @Column(name = "frecuencia_ahorro", nullable = false, length = 50)
    private String frecuenciaAhorro = "MEDIA";

    @Column(name = "nivel_endeudamiento", nullable = false, precision = 5, scale = 2)
    private BigDecimal nivelEndeudamiento = BigDecimal.ZERO;

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

    public Usuario(UUID id, String nombre, String apellido, String correo, String contrasena, BigDecimal ingresoMensual, String frecuenciaAhorro, BigDecimal nivelEndeudamiento, Boolean activo, PerfilFinanciero perfilFinanciero, String recomendaciones, LocalDateTime fechaCreacion) {
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

    // --- GETTERS Y SETTERS ORIGINALES ---

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

    public BigDecimal getIngresoMensual() { return ingresoMensual; }
    public void setIngresoMensual(BigDecimal ingresoMensual) { this.ingresoMensual = ingresoMensual; }

    public String getFrecuenciaAhorro() { return frecuenciaAhorro; }
    public void setFrecuenciaAhorro(String frecuenciaAhorro) { this.frecuenciaAhorro = frecuenciaAhorro; }

    public BigDecimal getNivelEndeudamiento() { return nivelEndeudamiento; }
    public void setNivelEndeudamiento(BigDecimal nivelEndeudamiento) { this.nivelEndeudamiento = nivelEndeudamiento; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }

    public PerfilFinanciero getPerfilFinanciero() { return perfilFinanciero; }
    public void setPerfilFinanciero(PerfilFinanciero perfilFinanciero) { this.perfilFinanciero = perfilFinanciero; }

    public String getRecomendaciones() { return recomendaciones; }
    public void setRecomendaciones(String recomendaciones) { this.recomendaciones = recomendaciones; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    // --- MÉTODOS OBLIGATORIOS DE SPRING SECURITY (UserDetails) ---

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(); // Por ahora no usaremos roles complejos, devolvemos una lista vacía
    }

    @Override
    public String getPassword() {
        return this.contrasena; // Le indicamos a Spring que este es el campo de la contraseña
    }

    @Override
    public String getUsername() {
        return this.correo; // Le indicamos a Spring que usamos el correo como identificador principal
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return this.activo != null ? this.activo : true; // Lo conectamos con tu campo 'activo'
    }
}