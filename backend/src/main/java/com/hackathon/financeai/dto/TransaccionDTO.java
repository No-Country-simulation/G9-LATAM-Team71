package com.hackathon.financeai.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import com.hackathon.financeai.model.Tipo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class TransaccionDTO {

    private String idTransaccion;

    @NotNull(message = "El tipo de flujo es obligatorio")
    private Tipo tipoFlujo;

    private Cualidad cualidadFlujo;

    private Categoria categoria;

    @NotNull(message = "La fecha es obligatoria")
    @JsonFormat(pattern = "yyyy/MM/dd")
    private LocalDate fecha;

    @NotNull(message = "El monto es obligatorio")
    private Double monto;

    @NotBlank(message = "La descripción no puede estar vacía")
    private String descripcion;

    public TransaccionDTO() {}

    // Getters y Setters
    public String getIdTransaccion() { return idTransaccion; }
    public void setIdTransaccion(String idTransaccion) { this.idTransaccion = idTransaccion; }

    public Tipo getTipoFlujo() { return tipoFlujo; }
    public void setTipoFlujo(Tipo tipoFlujo) { this.tipoFlujo = tipoFlujo; }

    public Cualidad getCualidadFlujo() { return cualidadFlujo; }
    public void setCualidadFlujo(Cualidad cualidadFlujo) { this.cualidadFlujo = cualidadFlujo; }

    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }

    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

    public Double getMonto() { return monto; }
    public void setMonto(Double monto) { this.monto = monto; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}