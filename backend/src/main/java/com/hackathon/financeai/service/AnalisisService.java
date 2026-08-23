package com.hackathon.financeai.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackathon.financeai.dto.*;
import com.hackathon.financeai.exception.FintechException;
import com.hackathon.financeai.model.AnalisisFinanciero;
import com.hackathon.financeai.model.Meta;
import com.hackathon.financeai.model.Transaccion;
import com.hackathon.financeai.model.Usuario;
import com.hackathon.financeai.repositories.AnalisisFinancieroRepository;
import com.hackathon.financeai.repositories.MetaRepository;
import com.hackathon.financeai.repositories.TransaccionRepository;
import com.hackathon.financeai.repositories.UsuarioRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class AnalisisService {

    private static final Logger log = LoggerFactory.getLogger(AnalisisService.class);

    private final String pythonBaseUrl;
    private final RestTemplate restTemplate;
    private final AnalisisFinancieroRepository analisisFinancieroRepository;
    private final TransaccionRepository transaccionRepository;
    private final MetaRepository metaRepository;
    private final UsuarioRepository usuarioRepository;
    private final ObjectMapper objectMapper;

    public AnalisisService(
            @Value("${python.service.base-url}") String pythonBaseUrl,
            RestTemplate restTemplate,
            AnalisisFinancieroRepository analisisFinancieroRepository,
            TransaccionRepository transaccionRepository,
            MetaRepository metaRepository,
            UsuarioRepository usuarioRepository,
            ObjectMapper objectMapper) {
        this.pythonBaseUrl = pythonBaseUrl;
        this.restTemplate = restTemplate;
        this.analisisFinancieroRepository = analisisFinancieroRepository;
        this.transaccionRepository = transaccionRepository;
        this.metaRepository = metaRepository;
        this.usuarioRepository = usuarioRepository;
        this.objectMapper = objectMapper;
    }

    public void generarAnalisisParaUsuario(UUID usuarioId) {
        // 1. Validar existencia del usuario
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new FintechException("USUARIO_NO_ENCONTRADO", "No se encontró el usuario con ID: " + usuarioId));

        // 2. Definir rango exacto del mes actual (primer y último segundo del mes)
        LocalDateTime inicioMes = LocalDateTime.now().with(TemporalAdjusters.firstDayOfMonth()).withHour(0).withMinute(0).withSecond(0);
        LocalDateTime finMes = LocalDateTime.now().with(TemporalAdjusters.lastDayOfMonth()).withHour(23).withMinute(59).withSecond(59);

        // 3. Mapear transacciones (o filtrar por fecha si el repositorio lo soporta)
        List<Transaccion> transacciones = transaccionRepository.findByUsuarioId(usuarioId);
        List<TransaccionResumen> transaccionesDato = transacciones.stream()
                .map(t -> new TransaccionResumen(
                        t.getId(),
                        t.getFecha(),
                        t.getDescripcion(),
                        t.getMonto(),
                        t.getTipoFlujo(),
                        t.getCualidadFlujo(),
                        t.getCategoria()))
                .collect(Collectors.toList());

        // 4. Mapear metas del usuario
        List<Meta> metas = metaRepository.findByUsuarioId(usuarioId);
        List<MetaResumen> metasDato = metas.stream()
                .map(MetaResumen::new)
                .collect(Collectors.toList());

        // 5. Ensamblar Request
        AnalisisPythonRequest request = new AnalisisPythonRequest(inicioMes, finMes, transaccionesDato, metasDato);

        try {
            String endpoint = pythonBaseUrl + "/analisis";

            // 6. Consumir API de Python
            ResponseEntity<AnalisisPythonResponse> response = restTemplate.postForEntity(
                    endpoint,
                    request,
                    AnalisisPythonResponse.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                // Convertir la respuesta tipada a Map para la columna JSONB
                Map<String, Object> dataMap = objectMapper.convertValue(
                        response.getBody(),
                        new TypeReference<Map<String, Object>>() {}
                );

                AnalisisFinanciero analisis = new AnalisisFinanciero();
                analisis.setUsuario(usuario);
                analisis.setFechaCreacion(LocalDateTime.now());
                analisis.setDataAnalisis(dataMap);

                analisisFinancieroRepository.save(analisis);
                System.out.println("✅ Análisis financiero exitosamente generado y guardado para usuario: " + usuarioId);
            }
        } catch (Exception e) {
            throw new FintechException("ERROR_API_ANALISIS", "No se pudo generar el análisis financiero. Detalle: " + e.getMessage());
        }
    }

    public Map<String, Object> obtenerUltimoAnalisis(UUID usuarioId) {
        return analisisFinancieroRepository.findFirstByUsuarioIdOrderByFechaCreacionDesc(usuarioId)
                .map(AnalisisFinanciero::getDataAnalisis)
                .orElseThrow(() -> new FintechException("SIN_ANALISIS", "El usuario aún no tiene análisis financieros generados."));
    }
}