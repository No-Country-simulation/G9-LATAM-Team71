package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.DashboardResponse;
import com.hackathon.financeai.dto.ReporteFinancieroResponse;
import com.hackathon.financeai.model.PerfilFinanciero;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class AnalisisYReporteController {

    @GetMapping("/analisis/dashboard")
    public ResponseEntity<DashboardResponse> obtenerDashboard() {
        DashboardResponse.UsuarioInfo usuario = new DashboardResponse.UsuarioInfo(
                "f47ac10b-58cc-4372-a567-0e02b2c3d479", "Carlos", "Pérez", "usuario@ejemplo.com"
        );

        DashboardResponse.AnalisisDashboard analisis = new DashboardResponse.AnalisisDashboard();
        analisis.setDineroDisponible(27000.00);
        analisis.setPerfilFinanciero(PerfilFinanciero.EN_OBSERVACION.name());
        analisis.setNivelEndeudamiento(15.50);
        analisis.setIngresoMensual(4500.00);
        analisis.setTransaccionesDelMes(new ArrayList<>());
        analisis.setRecomendaciones(List.of(
                "Monitorear los gastos recurrentes de entretenimiento",
                "Considera ahorrar un poco más en Ocio."
        ));

        DashboardResponse.MetaActiva meta1 = new DashboardResponse.MetaActiva(42, "Fondo de Emergencia", 20000.00, 5000.00, 25.0);
        DashboardResponse.MetaActiva meta2 = new DashboardResponse.MetaActiva(45, "Laptop Nueva", 15000.00, 15000.00, 100.0);

        DashboardResponse response = new DashboardResponse(usuario, analisis, List.of(meta1, meta2));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/reportes/ultimo")
    public ResponseEntity<ReporteFinancieroResponse> obtenerReporte() {
        ReporteFinancieroResponse response = new ReporteFinancieroResponse();
        response.setPerfilFinanciero(PerfilFinanciero.EN_OBSERVACION);

        Map<String, Double> gastos = new HashMap<>();
        gastos.put("ALIMENTACION", 420.0);
        gastos.put("TRANSPORTE", 300.0);
        gastos.put("OCIO", 40.0);
        response.setResumenGastosPorCategoria(gastos);

        ReporteFinancieroResponse.AnalisisComportamiento comp = new ReporteFinancieroResponse.AnalisisComportamiento();
        comp.setTotalIngresos(4500.0);
        comp.setFijoVital(300.0);
        comp.setFijoNoVital(40.0);
        comp.setVariable(420.0);
        response.setAnalisisComportamiento(comp);

        response.setRecomendaciones(List.of(
                "Detectamos $40 en suscripciones FIJO_NO_VITAL recurrentes; cancelarlas acelerará tu meta de ahorro.",
                "Tus gastos VARIABLE representan un porcentaje sano de tus ingresos."
        ));

        return ResponseEntity.ok(response);
    }
}