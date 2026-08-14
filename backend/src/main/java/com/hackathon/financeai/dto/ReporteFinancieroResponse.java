package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.PerfilFinanciero;
import java.util.List;
import java.util.Map;

public class ReporteFinancieroResponse {

    private PerfilFinanciero perfilFinanciero;
    private Map<String, Double> resumenGastosPorCategoria;
    private AnalisisComportamiento analisisComportamiento;
    private List<String> recomendaciones;

    public PerfilFinanciero getPerfilFinanciero() { return perfilFinanciero; }
    public void setPerfilFinanciero(PerfilFinanciero perfilFinanciero) { this.perfilFinanciero = perfilFinanciero; }

    public Map<String, Double> getResumenGastosPorCategoria() { return resumenGastosPorCategoria; }
    public void setResumenGastosPorCategoria(Map<String, Double> resumenGastosPorCategoria) { this.resumenGastosPorCategoria = resumenGastosPorCategoria; }

    public AnalisisComportamiento getAnalisisComportamiento() { return analisisComportamiento; }
    public void setAnalisisComportamiento(AnalisisComportamiento analisisComportamiento) { this.analisisComportamiento = analisisComportamiento; }

    public List<String> getRecomendaciones() { return recomendaciones; }
    public void setRecomendaciones(List<String> recomendaciones) { this.recomendaciones = recomendaciones; }

    public static class AnalisisComportamiento {
        private Double totalIngresos;
        private Double fijoVital;
        private Double fijoNoVital;
        private Double variable;

        public Double getTotalIngresos() { return totalIngresos; }
        public void setTotalIngresos(Double totalIngresos) { this.totalIngresos = totalIngresos; }

        public Double getFijoVital() { return fijoVital; }
        public void setFijoVital(Double fijoVital) { this.fijoVital = fijoVital; }

        public Double getFijoNoVital() { return fijoNoVital; }
        public void setFijoNoVital(Double fijoNoVital) { this.fijoNoVital = fijoNoVital; }

        public Double getVariable() { return variable; }
        public void setVariable(Double variable) { this.variable = variable; }
    }
}