package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.RegistrarMetaRequest;
import com.hackathon.financeai.dto.RegistrarMetaResponse;
import com.hackathon.financeai.service.MetaService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/metas")
public class MetaController {

    private final MetaService metaService;

    public MetaController(MetaService metaService) {
        this.metaService = metaService;
    }

    @PostMapping
    public ResponseEntity<RegistrarMetaResponse> registrarMeta(
            @RequestHeader("Usuario-ID") UUID usuarioId,
            @Valid @RequestBody RegistrarMetaRequest request) {

        RegistrarMetaResponse response = metaService.registrarMeta(request, usuarioId);
        
        // Según API_CONTRACTS.md se debe devolver HTTP 201 Created
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/{id}/aportar")
    public ResponseEntity<com.hackathon.financeai.dto.AportarMetaResponse> aportarAMeta(
            @PathVariable("id") UUID idMeta,
            @RequestHeader("Usuario-ID") UUID usuarioId,
            @Valid @RequestBody com.hackathon.financeai.dto.AportarMetaRequest request) {

        com.hackathon.financeai.dto.AportarMetaResponse response = metaService.aportarAMeta(idMeta, usuarioId, request);
        return ResponseEntity.ok(response);
    }
}
