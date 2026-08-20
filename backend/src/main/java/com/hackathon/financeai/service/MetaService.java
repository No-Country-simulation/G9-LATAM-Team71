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

    public MetaService(MetaRepository metaRepository, UsuarioRepository usuarioRepository) {
        this.metaRepository = metaRepository;
        this.usuarioRepository = usuarioRepository;
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
}
