package com.hackathon.financeai.controller;

import com.hackathon.financeai.model.Usuario;
import com.hackathon.financeai.repositories.UsuarioRepository;
import com.hackathon.financeai.security.JwtService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthController(AuthenticationManager authenticationManager, UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request) {
        String correo = request.get("correo");
        String contrasena = request.get("contrasena");

        // Autentica contra Spring Security
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(correo, contrasena)
        );

        // Si pasa, buscamos al usuario y generamos su token
        Usuario usuario = usuarioRepository.findByCorreo(correo)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        String token = jwtService.generateToken(usuario);

        return ResponseEntity.ok(Map.of(
                "token", token,
                "correo", usuario.getCorreo(),
                "nombre", usuario.getNombre()
        ));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Usuario nuevoUsuario) {
        // Encriptamos la contraseña antes de guardarla
        nuevoUsuario.setContrasena(passwordEncoder.encode(nuevoUsuario.getContrasena()));
        Usuario guardado = usuarioRepository.save(nuevoUsuario);

        String token = jwtService.generateToken(guardado);

        return ResponseEntity.ok(Map.of(
                "mensaje", "Usuario registrado con éxito",
                "token", token
        ));
    }
}