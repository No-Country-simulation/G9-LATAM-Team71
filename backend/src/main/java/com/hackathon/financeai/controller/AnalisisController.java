package com.hackathon.financeai.controller;

import com.hackathon.financeai.service.AnalisisService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/analisis")
public class AnalisisController {

    private final AnalisisService analisisService;

    public AnalisisController(AnalisisService analisisService) {
        this.analisisService = analisisService;
    }

    @GetMapping("/ultimo")
    public ResponseEntity<Map<String, Object>> getUltimoAnalisis(
            @RequestHeader("Usuario-ID") UUID usuarioId) {
        
        Map<String, Object> ultimoAnalisis = analisisService.obtenerUltimoAnalisis(usuarioId);
        return ResponseEntity.ok(ultimoAnalisis);
    }

    @PostMapping("/generar")
    public ResponseEntity<Void> generarAnalisisManual(
            @RequestHeader("Usuario-ID") UUID usuarioId) {
        
        analisisService.generarAnalisisParaUsuario(usuarioId);
        return ResponseEntity.ok().build();
    }
}
