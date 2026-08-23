package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.*;
import com.hackathon.financeai.service.TransaccionService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
// 1. RUTA BASE: Todo lo que entre a /api/v1/transacciones llega a este archivo
@RequestMapping("/api/v1/transacciones")
public class TransaccionController {

    private final TransaccionService transaccionService;

    public TransaccionController(TransaccionService transaccionService) {
        this.transaccionService = transaccionService;
    }

    /**
     * ENDPOINT 1: PREDICCIÓN (Fase 1)
     * Ruta final: POST /api/v1/transacciones/predecir
     */
    @PostMapping("/predecir")
    public ResponseEntity<ClasificarTransaccionResponse> predecir(
            @Valid @RequestBody ClasificarTransaccionRequest request) {

        // El controlador no hace cálculos, solo le pasa el paquete al Servicio
        ClasificacionPythonResponse pythonResponse = transaccionService.clasificarGasto(request);
        ClasificarTransaccionResponse response = new ClasificarTransaccionResponse(
                request.tipoFlujo(),
                request.monto(),
                request.descripcion(),
                pythonResponse);

        // Retorna HTTP 200 OK
        return ResponseEntity.ok(response);
    }

    /**
     * ENDPOINT 2: GUARDADO DEFINITIVO (Fase 2)
     * Ruta final: POST /api/v1/transacciones
     * (No ponemos nada dentro de @PostMapping porque queremos usar la ruta base exacta)
     */
    @PostMapping
    public ResponseEntity<GuardarTransaccionResponse> guardar(
        // Esto se va a eliminar, solo es para probar, realmente se tiene que hacer mediante el token jeje
        @RequestHeader("Usuario-ID") UUID idUsuario,
        @Valid @RequestBody GuardarTransaccionRequest request) {

        // Le pasamos el paquete al Servicio para que lo guarde en PostgreSQL
        GuardarTransaccionResponse response = transaccionService.guardarTransaccion(request, idUsuario);

        // Retorna HTTP 201 Created (El estándar cuando se inserta un nuevo registro)
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}