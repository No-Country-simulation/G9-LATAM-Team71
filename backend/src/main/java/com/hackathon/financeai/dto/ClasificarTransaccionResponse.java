package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Tipo;


public record ClasificarTransaccionResponse(
        Tipo tipoFlujo,
        float monto,
        String descripcion,
        ClasificacionPythonResponse prediccion
) {}