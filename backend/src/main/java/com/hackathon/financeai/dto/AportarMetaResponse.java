package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Estado;
import java.util.UUID;

public record AportarMetaResponse(
        UUID id_meta,
        float monto_actual,
        float porcentaje_avance,
        Estado estado,
        String mensaje,
        UUID id_transaccion_generada
) {}
