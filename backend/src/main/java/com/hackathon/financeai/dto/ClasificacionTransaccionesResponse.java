package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Categoria;
import java.util.List;

public class ClasificacionTransaccionesResponse {
// Nota: Si en algún momento se prefiere devolver la categoría como un simple texto libre en lugar de un Enum
// solo hay que cambiar private Categoria categoria; por private String categoria
    private List<TransaccionClasificada> transacciones;

    // Getters y Setters
    public List<TransaccionClasificada> getTransacciones() {
        return transacciones;
    }

    public void setTransacciones(List<TransaccionClasificada> transacciones) {
        this.transacciones = transacciones;
    }

    // Clase interna para representar la transacción con su categoría asignada
    public static class TransaccionClasificada {
        private String descripcion;
        private Double valor;
        private Categoria categoria;

        public TransaccionClasificada() {}

        public TransaccionClasificada(String descripcion, Double valor, Categoria categoria) {
            this.descripcion = descripcion;
            this.valor = valor;
            this.categoria = categoria;
        }

        // Getters y Setters
        public String getDescripcion() { return descripcion; }
        public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

        public Double getValor() { return valor; }
        public void setValor(Double valor) { this.valor = valor; }

        public Categoria getCategoria() { return categoria; }
        public void setCategoria(Categoria categoria) { this.categoria = categoria; }
    }
}