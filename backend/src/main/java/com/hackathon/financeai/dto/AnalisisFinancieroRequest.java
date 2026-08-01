package com.hackathon.financeai.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public class AnalisisFinancieroRequest {

    @NotNull(message = "El ingreso mensual es obligatorio")
    private Double ingresoMensual;

    @NotNull(message = "El nivel de endeudamiento es obligatorio")
    private Double nivelEndeudamiento;

    @NotBlank(message = "La frecuencia de ahorro es obligatoria")
    private String frecuenciaAhorro;

    @NotEmpty(message = "La lista de transacciones no puede estar vacía")
    @Valid
    private List<TransaccionDTO> transacciones;

    // Getters y Setters
    public Double getIngresoMensual() { return ingresoMensual; }
    public void setIngresoMensual(Double ingresoMensual) { this.ingresoMensual = ingresoMensual; }
    public Double getNivelEndeudamiento() { return nivelEndeudamiento; }
    public void setNivelEndeudamiento(Double nivelEndeudamiento) { this.nivelEndeudamiento = nivelEndeudamiento; }
    public String getFrecuenciaAhorro() { return frecuenciaAhorro; }
    public void setFrecuenciaAhorro(String frecuenciaAhorro) { this.frecuenciaAhorro = frecuenciaAhorro; }
    public List<TransaccionDTO> getTransacciones() { return transacciones; }
    public void setTransacciones(List<TransaccionDTO> transacciones) { this.transacciones = transacciones; }
}
