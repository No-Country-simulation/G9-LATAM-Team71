package com.hackathon.financeai.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "metas")
public class Meta {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(name = "monto_objetivo", nullable = false)
    private float montoObjetivo;

    @Column(name = "monto_actual", nullable = false)
    private float montoActual = 0.0f;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDateTime fechaInicio;

    @Column(name = "fecha_limite", nullable = false)
    private LocalDateTime fechaLimite;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Estado estado = Estado.ACTIVA;

    @Column(nullable = false)
    private Boolean activo = true;

    public Meta() {}

    public Meta(UUID id, Usuario usuario, String nombre, float montoObjetivo, float montoActual, LocalDateTime fechaInicio, LocalDateTime fechaLimite, Estado estado, Boolean activo) {
        this.id = id;
        this.usuario = usuario;
        this.nombre = nombre;
        this.montoObjetivo = montoObjetivo;
        this.montoActual = montoActual;
        this.fechaInicio = fechaInicio;
        this.fechaLimite = fechaLimite;
        this.estado = estado;
        this.activo = activo;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public float getMontoObjetivo() { return montoObjetivo; }
    public void setMontoObjetivo(float montoObjetivo) { this.montoObjetivo = montoObjetivo; }

    public float getMontoActual() { return montoActual; }
    public void setMontoActual(float montoActual) { this.montoActual = montoActual; }

    public LocalDateTime getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDateTime fechaInicio) { this.fechaInicio = fechaInicio; }

    public LocalDateTime getFechaLimite() { return fechaLimite; }
    public void setFechaLimite(LocalDateTime fechaLimite) { this.fechaLimite = fechaLimite; }

    public Estado getEstado() { return estado; }
    public void setEstado(Estado estado) { this.estado = estado; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }
}
