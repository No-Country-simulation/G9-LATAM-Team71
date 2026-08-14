package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import com.hackathon.financeai.model.Tipo;

public class PrediccionResponse {
    private Tipo tipoFlujo;
    private Double monto;
    private String descripcion;
    private PrediccionDetalle prediccion;

    public PrediccionResponse(Tipo tipoFlujo, Double monto, String descripcion, PrediccionDetalle prediccion) {
        this.tipoFlujo = tipoFlujo;
        this.monto = monto;
        this.descripcion = descripcion;
        this.prediccion = prediccion;
    }

    public Tipo getTipoFlujo() { return tipoFlujo; }
    public Double getMonto() { return monto; }
    public String getDescripcion() { return descripcion; }
    public PrediccionDetalle getPrediccion() { return prediccion; }

    public static class PrediccionDetalle {
        private Categoria categoria;
        private Cualidad cualidad;

        public PrediccionDetalle(Categoria categoria, Cualidad cualidad) {
            this.categoria = categoria;
            this.cualidad = cualidad;
        }

        public Categoria getCategoria() { return categoria; }
        public Cualidad getCualidad() { return cualidad; }
    }
}