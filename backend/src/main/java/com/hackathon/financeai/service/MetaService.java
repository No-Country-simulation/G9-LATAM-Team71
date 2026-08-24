package com.hackathon.financeai.service;

import com.hackathon.financeai.dto.RegistrarMetaRequest;
import com.hackathon.financeai.dto.RegistrarMetaResponse;
import com.hackathon.financeai.exception.FintechException;
import com.hackathon.financeai.model.Meta;
import com.hackathon.financeai.model.Usuario;
import com.hackathon.financeai.repositories.MetaRepository;
import com.hackathon.financeai.repositories.UsuarioRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class MetaService {

    private final MetaRepository metaRepository;
    private final UsuarioRepository usuarioRepository;
    private final com.hackathon.financeai.repositories.TransaccionRepository transaccionRepository;

    public MetaService(MetaRepository metaRepository, UsuarioRepository usuarioRepository, com.hackathon.financeai.repositories.TransaccionRepository transaccionRepository) {
        this.metaRepository = metaRepository;
        this.usuarioRepository = usuarioRepository;
        this.transaccionRepository = transaccionRepository;
    }

    public RegistrarMetaResponse registrarMeta(RegistrarMetaRequest request, UUID usuarioId) {
        // 1. Buscar al usuario
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new FintechException("USUARIO_NO_ENCONTRADO", "El usuario especificado no existe."));

        // 2. Mapear DTO a Entidad
        Meta meta = new Meta();
        meta.setUsuario(usuario);
        meta.setNombre(request.nombre());
        meta.setMontoObjetivo(request.monto_objetivo());
        
        // Reglas de negocio iniciales:
        meta.setMontoActual(0.0f); // Toda meta comienza en 0
        meta.setFechaInicio(LocalDateTime.now()); // La fecha de inicio es el día en que se registra
        
        meta.setFechaLimite(request.fecha_limite());
        meta.setEstado(request.estado());
        meta.setActivo(true); 

        // 3. Persistir en Base de Datos
        try {
            Meta metaGuardada = metaRepository.save(meta);
            return new RegistrarMetaResponse(
                    metaGuardada.getId(),
                    metaGuardada.getEstado(),
                    "Meta registrada exitosamente."
            );
        } catch (Exception e) {
            throw new FintechException("ERROR_BD_META", "Ocurrió un error al intentar guardar la meta financiera.");
        }
    }

    public com.hackathon.financeai.dto.AportarMetaResponse aportarAMeta(UUID idMeta, UUID idUsuario, com.hackathon.financeai.dto.AportarMetaRequest request) {
        Meta meta = metaRepository.findById(idMeta)
                .orElseThrow(() -> new FintechException("META_NO_ENCONTRADA", "No se encontró la meta especificada."));

        if (!meta.getUsuario().getId().equals(idUsuario)) {
            throw new FintechException("ACCESO_DENEGADO", "La meta no pertenece al usuario.");
        }

        if (meta.getEstado() != com.hackathon.financeai.model.Estado.ACTIVA) {
            throw new FintechException("META_INACTIVA", "No se pueden realizar aportes a una meta que no está ACTIVA.");
        }

        // Validate available funds
        float totalIngresos = (float) transaccionRepository.findByUsuarioId(idUsuario).stream()
                .filter(t -> t.getTipoFlujo() == com.hackathon.financeai.model.Tipo.INGRESO)
                .mapToDouble(com.hackathon.financeai.model.Transaccion::getMonto)
                .sum();
                
        float totalEgresos = (float) transaccionRepository.findByUsuarioId(idUsuario).stream()
                .filter(t -> t.getTipoFlujo() == com.hackathon.financeai.model.Tipo.EGRESO)
                .mapToDouble(com.hackathon.financeai.model.Transaccion::getMonto)
                .sum();
        
        float dineroDisponible = totalIngresos - totalEgresos;

        if (dineroDisponible < request.monto_aporte()) {
            throw new FintechException("FONDOS_INSUFICIENTES", "No tienes suficiente dinero disponible. Tienes $" + String.format("%.2f", dineroDisponible));
        }

        meta.setMontoActual(meta.getMontoActual() + request.monto_aporte());
        
        String mensaje = "Aporte registrado correctamente.";
        if (meta.getMontoActual() >= meta.getMontoObjetivo()) {
            meta.setEstado(com.hackathon.financeai.model.Estado.COMPLETADA);
            mensaje = "¡Felicidades! Has completado tu meta financiera.";
        }

        // Registrar la transacción como EGRESO de AHORRO
        com.hackathon.financeai.model.Transaccion transaccion = new com.hackathon.financeai.model.Transaccion();
        transaccion.setUsuario(meta.getUsuario());
        transaccion.setCategoria(com.hackathon.financeai.model.Categoria.AHORRO);
        transaccion.setMonto(request.monto_aporte());
        transaccion.setDescripcion("Ahorro en la meta: " + meta.getNombre());
        transaccion.setTipoFlujo(com.hackathon.financeai.model.Tipo.EGRESO);
        transaccion.setCualidadFlujo(com.hackathon.financeai.model.Cualidad.VARIABLE);
        transaccion.setFecha(LocalDateTime.now());
        transaccion.setActivo(true);
        
        try {
            transaccionRepository.save(transaccion);
            metaRepository.save(meta);
        } catch(Exception e) {
            throw new FintechException("ERROR_BD", "Ocurrió un error al procesar el aporte.");
        }

        float porcentaje = (meta.getMontoActual() / meta.getMontoObjetivo()) * 100;
        if (porcentaje > 100) porcentaje = 100f;

        return new com.hackathon.financeai.dto.AportarMetaResponse(
                meta.getId(),
                meta.getMontoActual(),
                porcentaje,
                meta.getEstado(),
                mensaje,
                transaccion.getId()
        );
    }
}
