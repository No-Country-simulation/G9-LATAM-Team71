package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.ClasificacionTransaccionesRequest;
import com.hackathon.financeai.dto.ClasificacionTransaccionesResponse;
import com.hackathon.financeai.service.ClasificacionService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/clasificacion-transacciones")
public class ClasificacionController {

    private final ClasificacionService clasificacionService;

    public ClasificacionController(ClasificacionService clasificacionService) {
        this.clasificacionService = clasificacionService;
    }

    @PostMapping
    public ResponseEntity<ClasificacionTransaccionesResponse> clasificar(@Valid @RequestBody ClasificacionTransaccionesRequest request) {
        return ResponseEntity.ok(clasificacionService.procesarClasificacion(request));
    }
}