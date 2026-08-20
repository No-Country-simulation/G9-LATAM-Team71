package com.hackathon.financeai.service;

import com.hackathon.financeai.dto.*;
import com.hackathon.financeai.exception.FintechException;
import com.hackathon.financeai.model.Transaccion;
import com.hackathon.financeai.model.Usuario;
import com.hackathon.financeai.repositories.TransaccionRepository;
import com.hackathon.financeai.repositories.UsuarioRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;

import java.util.UUID;

@Service
public class TransaccionService {
    private final RestTemplate restTemplate;

    // Spring Boot inyecta aquí la URL que pusiste en el properties
    @Value("${python.service.base-url}")
    private String pythonBaseUrl;

    private final TransaccionRepository transaccionRepository;
    private final UsuarioRepository usuarioRepository;

    public TransaccionService(TransaccionRepository transaccionRepository, UsuarioRepository usuarioRepository) {
        this.restTemplate = new RestTemplate();
        this.transaccionRepository = transaccionRepository;
        this.usuarioRepository = usuarioRepository;
    }

    // Este es el metodo que hace la llamada HTTP a Python
    public ClasificacionPythonResponse clasificarGasto(ClasificarTransaccionRequest requestData) {
        String endpoint = pythonBaseUrl + "/transacciones/predecir";

        try {
            // Java hace un POST a Python y convierte la respuesta JSON a tu DTO automáticamente
            ResponseEntity<ClasificacionPythonResponse> response = restTemplate.postForEntity(
                    endpoint,
                    requestData,
                    ClasificacionPythonResponse.class
            );
            return response.getBody();

        } catch (Exception e) {
            throw new FintechException("ERROR_API_PYTHON", "El servicio de predicción no está disponible: " + e.getMessage());
        }
    }

    public GuardarTransaccionResponse guardarTransaccion(GuardarTransaccionRequest request, UUID idUsuario) {
        try {
            Usuario user = usuarioRepository.findById(idUsuario)
                    .orElseThrow(() -> new FintechException("USUARIO_NO_ENCONTRADO", "El usuario no existe."));

            Transaccion transaccion = new Transaccion(request);
            transaccion.setUsuario(user);

            // 2. Guardamos la entidad en PostgreSQL a través del repositorio
            Transaccion transaccionGuardada = transaccionRepository.save(transaccion);

            // 3. Retornamos el DTO de respuesta con el ID autogenerado
            return new GuardarTransaccionResponse(
                    transaccionGuardada.getId(),
                    "Transacción registrada exitosamente."
            );

        } catch (Exception e) {
            // 4. Si la base de datos se cae, lanzamos nuestra excepción para que el Front-End reciba el JSON de error estándar
            throw new FintechException(
                    "ERROR_BASE_DATOS",
                    "No se pudo guardar la transacción. Por favor, intente nuevamente."
            );
        }
    }
}