package com.hackathon.financeai.dto;

public class ErrorResponse {
    private Boolean error;
    private String codigo;
    private String mensaje;

    public ErrorResponse(Boolean error, String codigo, String mensaje) {
        this.error = error;
        this.codigo = codigo;
        this.mensaje = mensaje;
    }

    public Boolean getError() { return error; }
    public void setError(Boolean error) { this.error = error; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
}