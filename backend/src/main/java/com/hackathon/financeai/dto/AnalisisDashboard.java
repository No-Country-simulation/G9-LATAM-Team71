package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.PerfilFinanciero;

import java.util.List;

public record AnalisisDashboard(
        float dinero_disponible,
        PerfilFinanciero perfil_financiero,
        float nivel_endeudamiento,
        float ingreso_mensual,
        List<TransaccionesMensual> transacciones_del_mes,
        List<String> recomendaciones
) {
}
