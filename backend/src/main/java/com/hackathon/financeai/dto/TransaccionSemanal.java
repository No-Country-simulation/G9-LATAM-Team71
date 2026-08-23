package com.hackathon.financeai.dto;

import java.time.LocalDateTime;

public record TransaccionSemanal(
        float monto,
        LocalDateTime fecha,
        String descripcion
) {
}
