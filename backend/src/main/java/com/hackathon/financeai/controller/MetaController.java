package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.MetaRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/metas")
public class MetaController {

    @PostMapping
    public ResponseEntity<Map<String, Object>> crearMeta(@Valid @RequestBody MetaRequest request) {
        Map<String, Object> response = new HashMap<>();
        response.put("id_meta", UUID.randomUUID().toString());
        response.put("estado", request.getEstado());
        response.put("mensaje", "Meta registrada exitosamente.");

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}