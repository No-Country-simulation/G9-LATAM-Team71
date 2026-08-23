package com.hackathon.financeai.dto;

public record ActualizarPerfilRequest(
    float ingresoMensual,
    float nivelEndeudamiento,
    String frecuenciaAhorro
) {}
