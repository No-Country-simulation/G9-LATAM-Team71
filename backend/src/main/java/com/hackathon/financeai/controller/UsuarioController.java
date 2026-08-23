package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.ActualizarPerfilRequest;
import com.hackathon.financeai.model.Usuario;
import com.hackathon.financeai.repositories.UsuarioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/usuarios")
public class UsuarioController {

    private final UsuarioRepository usuarioRepository;

    public UsuarioController(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @PutMapping("/perfil")
    public ResponseEntity<Void> actualizarPerfil(
            @RequestHeader("Usuario-ID") UUID usuarioId,
            @RequestBody ActualizarPerfilRequest request) {
        
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
                
        usuario.setIngresoMensual(request.ingresoMensual());
        usuario.setNivelEndeudamiento(request.nivelEndeudamiento());
        usuario.setFrecuenciaAhorro(request.frecuenciaAhorro());
        
        usuarioRepository.save(usuario);
        
        return ResponseEntity.ok().build();
    }
}
