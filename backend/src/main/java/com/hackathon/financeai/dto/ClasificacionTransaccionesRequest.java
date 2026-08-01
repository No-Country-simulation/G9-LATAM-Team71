package com.hackathon.financeai.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import java.util.List;

public class ClasificacionTransaccionesRequest {

    @NotEmpty(message = "La lista de transacciones no puede estar vacía")
    @Valid
    private List<TransaccionDTO> transacciones;

    // Getters y Setters
    public List<TransaccionDTO> getTransacciones() {
        return transacciones;
    }

    public void setTransacciones(List<TransaccionDTO> transacciones) {
        this.transacciones = transacciones;
    }
}
