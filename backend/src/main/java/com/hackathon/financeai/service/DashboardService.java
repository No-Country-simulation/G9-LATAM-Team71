package com.hackathon.financeai.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackathon.financeai.dto.*;
import com.hackathon.financeai.exception.FintechException;
import com.hackathon.financeai.model.*;
import com.hackathon.financeai.repositories.*;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class DashboardService {

    private final UsuarioRepository usuarioRepository;
    private final TransaccionRepository transaccionRepository;
    private final MetaRepository metaRepository;
    private final AnalisisFinancieroRepository analisisFinancieroRepository;
    private final ObjectMapper objectMapper;

    public DashboardService(
            UsuarioRepository usuarioRepository,
            TransaccionRepository transaccionRepository,
            MetaRepository metaRepository,
            AnalisisFinancieroRepository analisisFinancieroRepository,
            ObjectMapper objectMapper) {
        this.usuarioRepository = usuarioRepository;
        this.transaccionRepository = transaccionRepository;
        this.metaRepository = metaRepository;
        this.analisisFinancieroRepository = analisisFinancieroRepository;
        this.objectMapper = objectMapper;
    }

    public DashboardResponse obtenerDashboardData(UUID usuarioId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new FintechException("USUARIO_NO_ENCONTRADO", "No se encontró el usuario."));

        // 1. Resumen de Usuario
        DashboardResponse.UsuarioResumen usuarioResumen = new DashboardResponse.UsuarioResumen(
                usuario.getId(),
                usuario.getNombre(),
                usuario.getApellido(),
                usuario.getCorreo()
        );

        // 2. Metas Activas
        List<Meta> metas = metaRepository.findByUsuarioId(usuarioId);
        List<MetaResumen> metasActivas = metas.stream()
                .filter(m -> m.getEstado() == Estado.ACTIVA)
                .map(MetaResumen::new)
                .collect(Collectors.toList());

        // 3. Transacciones del mes
        LocalDateTime inicioMes = LocalDateTime.now().with(TemporalAdjusters.firstDayOfMonth()).withHour(0).withMinute(0);
        LocalDateTime finMes = LocalDateTime.now().with(TemporalAdjusters.lastDayOfMonth()).withHour(23).withMinute(59);

        List<Transaccion> todasTransacciones = transaccionRepository.findByUsuarioId(usuarioId);
        
        List<Transaccion> transaccionesDelMes = todasTransacciones.stream()
                .filter(t -> t.getFecha().isAfter(inicioMes) && t.getFecha().isBefore(finMes))
                .collect(Collectors.toList());

        List<TransaccionResumen> transaccionesResumen = transaccionesDelMes.stream()
                .map(t -> new TransaccionResumen(t.getId(), t.getFecha(), t.getDescripcion(), t.getMonto(), t.getTipoFlujo(), t.getCualidadFlujo(), t.getCategoria()))
                .collect(Collectors.toList());

        // 4. Calcular dinero disponible (Ingreso Mensual - Egresos del mes)
        float totalEgresos = (float) transaccionesDelMes.stream()
                .filter(t -> t.getTipoFlujo() == Tipo.EGRESO)
                .mapToDouble(Transaccion::getMonto)
                .sum();
        
        float dineroDisponible = usuario.getIngresoMensual() - totalEgresos;

        // 5. Extraer recomendaciones del último análisis
        List<RecomendacionResumen> recomendaciones = Collections.emptyList();
        var ultimoAnalisisOpt = analisisFinancieroRepository.findFirstByUsuarioIdOrderByFechaCreacionDesc(usuarioId);
        
        if (ultimoAnalisisOpt.isPresent()) {
            Map<String, Object> data = ultimoAnalisisOpt.get().getDataAnalisis();
            if (data.containsKey("recomendaciones")) {
                recomendaciones = objectMapper.convertValue(data.get("recomendaciones"), new TypeReference<List<RecomendacionResumen>>() {});
            }
        }

        // 6. Resumen de Análisis
        DashboardResponse.AnalisisResumen analisisResumen = new DashboardResponse.AnalisisResumen(
                dineroDisponible,
                usuario.getPerfilFinanciero(),
                usuario.getNivelEndeudamiento(),
                usuario.getIngresoMensual(),
                transaccionesResumen,
                recomendaciones
        );

        return new DashboardResponse(usuarioResumen, analisisResumen, metasActivas);
    }
}
