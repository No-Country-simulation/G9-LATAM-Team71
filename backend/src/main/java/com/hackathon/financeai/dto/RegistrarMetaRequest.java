package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Estado;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record RegistrarMetaRequest(
        @NotBlank(message = "El nombre de la meta es obligatorio")
        String nombre,
        
        @NotNull(message = "El monto objetivo es obligatorio")
        @Positive(message = "El monto objetivo debe ser mayor a cero")
        float monto_objetivo,
        
        @NotNull(message = "La fecha límite es obligatoria")
        @Future(message = "La fecha límite debe ser en el futuro")
        LocalDateTime fecha_limite,
        
        @NotNull(message = "El estado es obligatorio")
        Estado estado
) {}
