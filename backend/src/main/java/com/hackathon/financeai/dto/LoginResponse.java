package com.hackathon.financeai.dto;

public class LoginResponse {
    private String tokenAcceso;
    private String tipoToken;
    private UsuarioDTO usuario;

    public LoginResponse(String tokenAcceso, String tipoToken, UsuarioDTO usuario) {
        this.tokenAcceso = tokenAcceso;
        this.tipoToken = tipoToken;
        this.usuario = usuario;
    }

    public String getTokenAcceso() { return tokenAcceso; }
    public String getTipoToken() { return tipoToken; }
    public UsuarioDTO getUsuario() { return usuario; }

    public static class UsuarioDTO {
        private String idUsuario;
        private String nombre;
        private String correo;

        public UsuarioDTO(String idUsuario, String nombre, String correo) {
            this.idUsuario = idUsuario;
            this.nombre = nombre;
            this.correo = correo;
        }

        public String getIdUsuario() { return idUsuario; }
        public String getNombre() { return nombre; }
        public String getCorreo() { return correo; }
    }
}