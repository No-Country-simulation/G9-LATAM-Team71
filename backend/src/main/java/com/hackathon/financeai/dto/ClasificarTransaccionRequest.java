package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Tipo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.util.UUID;

public record ClasificarTransaccionRequest(

        @NotNull(message = "El tipo de flujo es obligatorio")
        Tipo tipoFlujo,

        @NotNull(message = "El monto es obligatorio")
        @Positive(message = "El monto debe ser un valor positivo")
        float monto,

        @NotBlank(message = "La descripción no puede estar vacía")
        String descripcion
) {}