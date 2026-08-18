package com.hackathon.financeai.model;

import com.hackathon.financeai.dto.GuardarTransaccionRequest;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "transacciones")
public class Transaccion {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private Categoria categoria;

    @Column(nullable = false, precision = 10, scale = 2)
    private float monto;

    @Column(nullable = false)
    private String descripcion;

    @Column(nullable = false, insertable = false, updatable = false)
    private LocalDateTime fecha;

    @Column(nullable = false)
    private Boolean activo = true;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_flujo", nullable = false, length = 10)
    private Tipo tipoFlujo;

    @Enumerated(EnumType.STRING)
    @Column(name = "cualidad_flujo", length = 20)
    private Cualidad cualidadFlujo;

    public Transaccion() {}

    public Transaccion(UUID id, Usuario usuario, Categoria categoria, float monto, String descripcion, LocalDateTime fecha, Boolean activo, Tipo tipoFlujo, Cualidad cualidadFlujo) {
        this.id = id;
        this.usuario = usuario;
        this.categoria = categoria;
        this.monto = monto;
        this.descripcion = descripcion;
        this.fecha = fecha;
        this.activo = activo;
        this.tipoFlujo = tipoFlujo;
        this.cualidadFlujo = cualidadFlujo;
    }

    public Transaccion(GuardarTransaccionRequest request){
        this.categoria = request.categoria();
        this.monto = request.monto();
        this.descripcion = request.descripcion();
        this.fecha = LocalDateTime.now();
        this.activo = true;
        this.tipoFlujo = request.tipo_flujo();
        this.cualidadFlujo = request.cualidad_flujo();
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }

    public float getMonto() { return monto; }
    public void setMonto(float monto) { this.monto = monto; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public LocalDateTime getFecha() { return fecha; }
    public void setFecha(LocalDateTime fecha) { this.fecha = fecha; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }

    public Tipo getTipoFlujo() { return tipoFlujo; }
    public void setTipoFlujo(Tipo tipoFlujo) { this.tipoFlujo = tipoFlujo; }

    public Cualidad getCualidadFlujo() { return cualidadFlujo; }
    public void setCualidadFlujo(Cualidad cualidadFlujo) { this.cualidadFlujo = cualidadFlujo; }
}
