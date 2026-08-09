package com.hackathon.financeai.service;

import com.hackathon.financeai.dto.AnalisisFinancieroRequest;
import com.hackathon.financeai.dto.AnalisisFinancieroResponse;
import com.hackathon.financeai.dto.TransaccionDTO;
import com.hackathon.financeai.model.PerfilFinanciero;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class AnalisisService {

    private static final double UMBRAL_ENDEUDAMIENTO_ALTO = 40.0;
    private static final double UMBRAL_ENDEUDAMIENTO_BAJO = 30.0;
    private static final double PROBABILIDAD_EN_RIESGO = 0.85;
    private static final double PROBABILIDAD_SALUDABLE = 0.92;
    private static final double PROBABILIDAD_EN_OBSERVACION = 0.78;

    public AnalisisFinancieroResponse procesarAnalisis(AnalisisFinancieroRequest request) {
        Map<String, Double> resumenGastos = resumirGastos(request.getTransacciones());
        PerfilEvaluado perfilEvaluado = evaluarPerfilFinanciero(
                request.getNivelEndeudamiento(),
                request.getFrecuenciaAhorro()
        );
        List<String> recomendaciones = generarRecomendaciones(perfilEvaluado.perfil(), resumenGastos);

        AnalisisFinancieroResponse response = new AnalisisFinancieroResponse();
        response.setPerfilFinanciero(perfilEvaluado.perfil());
        response.setProbabilidad(perfilEvaluado.probabilidad());
        response.setResumenGastos(resumenGastos);
        response.setRecomendaciones(recomendaciones);
        return response;
    }

    private Map<String, Double> resumirGastos(List<TransaccionDTO> transacciones) {
        Map<String, Double> resumen = new LinkedHashMap<>();

        for (TransaccionDTO transaccion : transacciones) {
            String categoria = clasificarDescripcion(transaccion.getDescripcion());
            resumen.merge(categoria, transaccion.getValor(), Double::sum);
        }

        return resumen;
    }

    private String clasificarDescripcion(String descripcion) {
        String texto = descripcion.toLowerCase(Locale.ROOT);

        if (contieneAlguna(texto, "supermercado", "comida")) {
            return "ALIMENTACION";
        }
        if (contieneAlguna(texto, "combustible", "uber")) {
            return "TRANSPORTE";
        }
        if (contieneAlguna(texto, "streaming", "cine")) {
            return "OCIO";
        }
        return "OTROS";
    }

    private PerfilEvaluado evaluarPerfilFinanciero(Double nivelEndeudamiento, String frecuenciaAhorro) {
        // Punto único de reemplazo para una llamada futura a un modelo Python por RestClient/RestTemplate.
        double endeudamiento = nivelEndeudamiento != null ? nivelEndeudamiento : 0.0;
        String ahorro = frecuenciaAhorro != null ? frecuenciaAhorro.trim().toLowerCase(Locale.ROOT) : "";

        if (endeudamiento > UMBRAL_ENDEUDAMIENTO_ALTO) {
            return new PerfilEvaluado(PerfilFinanciero.EN_RIESGO, PROBABILIDAD_EN_RIESGO);
        }

        if (endeudamiento <= UMBRAL_ENDEUDAMIENTO_BAJO
                && ("alta".equals(ahorro) || "frecuente".equals(ahorro))) {
            return new PerfilEvaluado(PerfilFinanciero.SALUDABLE, PROBABILIDAD_SALUDABLE);
        }

        return new PerfilEvaluado(PerfilFinanciero.EN_OBSERVACION, PROBABILIDAD_EN_OBSERVACION);
    }

    private List<String> generarRecomendaciones(PerfilFinanciero perfil, Map<String, Double> resumenGastos) {
        if (perfil == PerfilFinanciero.EN_RIESGO) {
            String categoriaMayorGasto = obtenerCategoriaMayorGasto(resumenGastos);
            return List.of("Reduce el gasto en " + categoriaMayorGasto + " porque es la categoría con mayor acumulado.");
        }

        return List.of(
                "Controla los gastos recurrentes y revisa suscripciones o consumos periódicos.",
                "Incrementa tu ahorro mensual de forma constante."
        );
    }

    private String obtenerCategoriaMayorGasto(Map<String, Double> resumenGastos) {
        return resumenGastos.entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("otros");
    }

    private boolean contieneAlguna(String texto, String... palabrasClave) {
        for (String palabraClave : palabrasClave) {
            if (texto.contains(palabraClave)) {
                return true;
            }
        }
        return false;
    }

    private record PerfilEvaluado(PerfilFinanciero perfil, double probabilidad) {}
}