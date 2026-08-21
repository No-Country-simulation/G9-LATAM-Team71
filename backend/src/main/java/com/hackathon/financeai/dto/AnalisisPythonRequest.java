package com.hackathon.financeai.dto;

import java.time.LocalDateTime;
import java.util.List;

public record AnalisisPythonRequest(
        LocalDateTime fecha_inicio,
        LocalDateTime fecha_fin,
        List<TransaccionResumen> transacciones,
        List<MetaResumen> metas
) {
}
