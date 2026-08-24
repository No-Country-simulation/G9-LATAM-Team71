package com.hackathon.financeai.dto;

public record RegistroRequest(
    String nombre,
    String apellido,
    String correo,
    String contrasena
) {}
