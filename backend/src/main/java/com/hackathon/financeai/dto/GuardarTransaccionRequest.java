package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import com.hackathon.financeai.model.Tipo;

import java.time.LocalDateTime;
import java.util.UUID;

public record GuardarTransaccionRequest(
        Tipo tipo_flujo,
        Cualidad cualidad_flujo,
        Categoria categoria,
        LocalDateTime fecha,
        float monto,
        String descripcion
) {
    public GuardarTransaccionRequest(ClasificarTransaccionResponse response) {
        this(
                response.tipoFlujo(),
                response.prediccion().cualidad(),
                response.prediccion().categoria(),
                LocalDateTime.now(),
                response.monto(),
                response.descripcion());
    }
}
