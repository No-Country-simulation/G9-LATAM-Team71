package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Estado;
import com.hackathon.financeai.model.Meta;

import java.time.LocalDateTime;
import java.util.UUID;

public record MetaResumen(
        UUID idMeta,
        String nombre_meta,
        float monto_objetivo,
        LocalDateTime fecha_inicio,
        LocalDateTime fecha_limite,
        float monto_actual,
        Estado estado
) {
    public MetaResumen(Meta meta) {
        this(meta.getId(),
                meta.getNombre(),
                meta.getMontoObjetivo(),
                meta.getFechaInicio(),
                meta.getFechaLimite(),
                meta.getMontoActual(),
                meta.getEstado());
    }
}
