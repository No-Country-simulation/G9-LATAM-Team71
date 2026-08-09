package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.AnalisisFinancieroRequest;
import com.hackathon.financeai.dto.AnalisisFinancieroResponse;
import com.hackathon.financeai.service.AnalisisService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/analisis-financiero")
public class AnalisisController {

    private final AnalisisService analisisService;

    public AnalisisController(AnalisisService analisisService) {
        this.analisisService = analisisService;
    }

    @PostMapping
    public ResponseEntity<AnalisisFinancieroResponse> analizar(@Valid @RequestBody AnalisisFinancieroRequest request) {
        return ResponseEntity.ok(analisisService.procesarAnalisis(request));
    }
}