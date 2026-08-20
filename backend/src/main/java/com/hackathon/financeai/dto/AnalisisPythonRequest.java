package com.hackathon.financeai.dto;

import java.time.LocalDateTime;
import java.util.List;

public record AnalisisPythonRequest(
        List<TransaccionResumen> transacciones,
        LocalDateTime fecha_inicio,
        LocalDateTime fecha_fin,
        List<MetaResumen> metas
) {
}
