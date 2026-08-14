package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Tipo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class PrediccionRequest {
    @NotNull(message = "El tipo de flujo es obligatorio")
    private Tipo tipoFlujo;

    @NotNull(message = "El monto es obligatorio")
    private Double monto;

    @NotBlank(message = "La descripción no puede estar vacía")
    private String descripcion;

    public Tipo getTipoFlujo() { return tipoFlujo; }
    public void setTipoFlujo(Tipo tipoFlujo) { this.tipoFlujo = tipoFlujo; }
    public Double getMonto() { return monto; }
    public void setMonto(Double monto) { this.monto = monto; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}
