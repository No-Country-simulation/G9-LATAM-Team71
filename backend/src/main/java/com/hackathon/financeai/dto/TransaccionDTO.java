package com.hackathon.financeai.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class TransaccionDTO {

    @NotBlank(message = "La descripción no puede estar vacía")
    private String descripcion;

    @NotNull(message = "El valor es obligatorio")
    private Double valor;

    // Getters y Setters
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public Double getValor() { return valor; }
    public void setValor(Double valor) { this.valor = valor; }
}