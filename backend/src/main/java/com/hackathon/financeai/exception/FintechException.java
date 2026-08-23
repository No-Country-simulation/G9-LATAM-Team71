package com.hackathon.financeai.exception;

public class FintechException extends RuntimeException {

    private final String codigo;

    public FintechException(String codigo, String mensaje) {
        // Le pasamos el mensaje a la clase padre (RuntimeException)
        super(mensaje);
        this.codigo = codigo;
    }

    public String getCodigo() {
        return codigo;
    }
}