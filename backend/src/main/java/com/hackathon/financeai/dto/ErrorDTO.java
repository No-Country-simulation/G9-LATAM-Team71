package com.hackathon.financeai.dto;

public record ErrorDTO(
        boolean error,
        String codigo,
        String mensaje
) {}