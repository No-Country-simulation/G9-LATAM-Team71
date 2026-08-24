package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;

import java.util.UUID;

public record ClasificacionPythonResponse(
        Categoria categoria,
        Cualidad cualidad
) {}
