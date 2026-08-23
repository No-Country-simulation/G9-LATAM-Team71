package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import com.hackathon.financeai.model.PerfilFinanciero;
import com.hackathon.financeai.model.Tipo;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record DashboardResponse(
    UsuarioResumen usuario,
    AnalisisResumen analisis,
    List<MetaResumen> metasActivas
) {
    public record UsuarioResumen(
        UUID id,
        String nombre,
        String apellido,
        String correo
    ) {}

    public record AnalisisResumen(
        float dinero_disponible,
        PerfilFinanciero perfil_financiero,
        float nivel_endeudamiento,
        float ingreso_mensual,
        List<TransaccionResumen> transacciones_del_mes,
        List<RecomendacionResumen> recomendaciones
    ) {}
}
