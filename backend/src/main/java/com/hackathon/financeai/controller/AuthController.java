package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.LoginRequest;
import com.hackathon.financeai.dto.LoginResponse;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse.UsuarioDTO mockUser = new LoginResponse.UsuarioDTO(
                "f47ac10b-58cc-4372-a567-0e02b2c3d479",
                "Carlos",
                request.getCorreo()
        );
        LoginResponse response = new LoginResponse("eyJhbGciOiJIUzI1NiIsInR...", "Bearer", mockUser);
        return ResponseEntity.ok(response);
    }
}