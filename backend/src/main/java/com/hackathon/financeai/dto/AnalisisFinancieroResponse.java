package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.PerfilFinanciero;
import java.util.List;
import java.util.Map;

public class AnalisisFinancieroResponse {

    private PerfilFinanciero perfilFinanciero;
    private Double probabilidad;
    private Map<String, Double> resumenGastos;
    private List<String> recomendaciones;

    // Getters y Setters
    public PerfilFinanciero getPerfilFinanciero() { return perfilFinanciero; }
    public void setPerfilFinanciero(PerfilFinanciero perfilFinanciero) { this.perfilFinanciero = perfilFinanciero; }
    public Double getProbabilidad() { return probabilidad; }
    public void setProbabilidad(Double probabilidad) { this.probabilidad = probabilidad; }
    public Map<String, Double> getResumenGastos() { return resumenGastos; }
    public void setResumenGastos(Map<String, Double> resumenGastos) { this.resumenGastos = resumenGastos; }
    public List<String> getRecomendaciones() { return recomendaciones; }
    public void setRecomendaciones(List<String> recomendaciones) { this.recomendaciones = recomendaciones; }
}
