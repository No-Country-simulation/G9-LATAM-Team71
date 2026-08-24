package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.PerfilFinanciero;

import java.time.LocalDateTime;
import java.util.List;

public record AnalisisPythonResponse(
    Periodo periodo,
    Indicadores indicadores,
    ComparacionPeriodoAnterior comparacion_periodo_anterior,
    PerfilFinancieroDTO perfil_financiero,
    List<RecomendacionResumen> recomendaciones,
    List<MetaAnalisis> metas
) {
    public record Periodo(
        LocalDateTime inicio,
        LocalDateTime fin
    ) {}

    public record Indicadores(
        float tasa_ahorro,
        float nivel_endeudamiento,
        float porcentaje_ingreso_gastado,
        Categoria categoria_mayor_gasto,
        float porcentaje_categoria_mayor_gasto,
        float gasto_promedio
    ) {}

    public record Variacion(
        float actual,
        float anterior,
        float variacion
    ) {}

    public record VariacionExtendida(
        float actual,
        float anterior,
        float variacion,
        float variacion_porcentual
    ) {}

    public record CategoriaCambio(
        Categoria actual,
        Categoria anterior,
        boolean cambio
    ) {}

    public record ComparacionPeriodoAnterior(
        Variacion tasa_ahorro,
        Variacion nivel_endeudamiento,
        Variacion porcentaje_ingreso_gastado,
        VariacionExtendida gasto_promedio_controlable,
        VariacionExtendida gasto_promedio,
        CategoriaCambio categoria_mayor_gasto
    ) {}

    public record PerfilFinancieroDTO(
        PerfilFinanciero perfil,
        String descripcion
    ) {}

    public record MetaAnalisis(
        String nombre_meta,
        float monto_objetivo,
        float monto_actual,
        float monto_restante,
        String progreso,
        float ahorro_mensual_necesario,
        String fecha_inicio,
        String fecha_limite
    ) {}
}
