package com.hackathon.financeai.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record AportarMetaRequest(
        @NotNull(message = "El monto de aporte es obligatorio")
        @Positive(message = "El monto a aportar debe ser mayor a cero")
        Float monto_aporte
) {}
