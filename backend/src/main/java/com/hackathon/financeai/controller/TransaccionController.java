package com.hackathon.financeai.controller;

import com.hackathon.financeai.dto.PrediccionRequest;
import com.hackathon.financeai.dto.PrediccionResponse;
import com.hackathon.financeai.dto.TransaccionDTO;
import com.hackathon.financeai.model.Categoria;
import com.hackathon.financeai.model.Cualidad;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/transacciones")
public class TransaccionController {

    @PostMapping("/predecir")
    public ResponseEntity<PrediccionResponse> predecir(@Valid @RequestBody PrediccionRequest request) {
        // Mock que simula la respuesta de Python para que Frontend no se bloquee
        PrediccionResponse.PrediccionDetalle detalle = new PrediccionResponse.PrediccionDetalle(
                Categoria.ALIMENTACION, Cualidad.VARIABLE
        );
        PrediccionResponse response = new PrediccionResponse(
                request.getTipoFlujo(), request.getMonto(), request.getDescripcion(), detalle
        );
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> guardarTransaccion(@Valid @RequestBody TransaccionDTO request) {
        Map<String, Object> response = new HashMap<>();
        response.put("id_transaccion", UUID.randomUUID().toString());
        response.put("mensaje", "Transacción registrada exitosamente.");

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}