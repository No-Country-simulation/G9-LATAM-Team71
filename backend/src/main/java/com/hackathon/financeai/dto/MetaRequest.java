package com.hackathon.financeai.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.hackathon.financeai.model.Estado;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class MetaRequest {
    @NotBlank(message = "El nombre de la meta es obligatorio")
    private String nombre;

    @NotNull(message = "El monto objetivo es obligatorio")
    private Double montoObjetivo;

    @NotNull(message = "La fecha límite es obligatoria")
    @JsonFormat(pattern = "yyyy/MM/dd")
    private LocalDate fechaLimite;

    @NotNull(message = "El estado es obligatorio")
    private Estado estado;

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public Double getMontoObjetivo() { return montoObjetivo; }
    public void setMontoObjetivo(Double montoObjetivo) { this.montoObjetivo = montoObjetivo; }
    public LocalDate getFechaLimite() { return fechaLimite; }
    public void setFechaLimite(LocalDate fechaLimite) { this.fechaLimite = fechaLimite; }
    public Estado getEstado() { return estado; }
    public void setEstado(Estado estado) { this.estado = estado; }
}