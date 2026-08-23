package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import com.hackathon.financeai.model.Tipo;

import java.time.LocalDateTime;
import java.util.UUID;

public record TransaccionResumen(
        UUID id,
        LocalDateTime fecha,
        String descripcion,
        float monto,
        Tipo tipo_flujo,
        Cualidad cualidad_flujo,
        Categoria categoria
) {}
