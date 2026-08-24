package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.DashboardResponse;
import com.hackathon.financeai.service.DashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/analisis/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping
    public ResponseEntity<DashboardResponse> getDashboardData(
            @RequestHeader("Usuario-ID") UUID usuarioId) {

        DashboardResponse response = dashboardService.obtenerDashboardData(usuarioId);
        return ResponseEntity.ok(response);
    }
}
