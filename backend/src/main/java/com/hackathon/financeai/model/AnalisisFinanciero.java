package com.hackathon.financeai.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "analisis_financieros")
public class AnalisisFinanciero {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion = LocalDateTime.now();

    // Aquí se encapsula TODO el JSON completo sin importar qué tan profundo sea
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "data_analisis", columnDefinition = "jsonb", nullable = false)
    private Map<String, Object> dataAnalisis;

    public AnalisisFinanciero() {}

    public AnalisisFinanciero(UUID id, Usuario usuario, LocalDateTime fechaCreacion, Map<String, Object> dataAnalisis) {
        this.id = id;
        this.usuario = usuario;
        this.fechaCreacion = fechaCreacion;
        this.dataAnalisis = dataAnalisis;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public Map<String, Object> getDataAnalisis() { return dataAnalisis; }
    public void setDataAnalisis(Map<String, Object> dataAnalisis) { this.dataAnalisis = dataAnalisis; }
}
