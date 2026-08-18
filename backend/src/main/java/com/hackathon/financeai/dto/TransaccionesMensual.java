package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import com.hackathon.financeai.model.Tipo;

import java.time.LocalDateTime;
import java.util.UUID;

public record TransaccionesMensual(
        UUID id,
        String descripcion,
        float monto,
        LocalDateTime fecha,
        Tipo tipo_flujo,
        Cualidad cualidad_flujo,
        Categoria categoria
) {
}
