package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.PerfilFinanciero;
import com.hackathon.financeai.model.Transaccion;

import java.util.List;

public record InicioDashboard(
        String nombre,
        String apellido,
        String correo,
        //??
        PerfilFinanciero perfil_financiero,
        float nivel_endeudamiento,
        List<TransaccionSemanal> transacciones_semanales
) {
}
