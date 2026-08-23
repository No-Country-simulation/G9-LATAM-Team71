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

            // 1. Instanciamos la entidad vacía
            Transaccion transaccion = new Transaccion();

            // 2. Mapeamos los datos extrayéndolos del record (sin el prefijo "get")
            transaccion.setUsuario(user);
            transaccion.setMonto(request.monto());
            transaccion.setDescripcion(request.descripcion());
            transaccion.setFecha(request.fecha());
            transaccion.setCategoria(request.categoria());
            transaccion.setTipoFlujo(request.tipo_flujo());
            transaccion.setCualidadFlujo(request.cualidad_flujo());
            // El DTO no incluye esRecurrente, lo inicializamos en false
            transaccion.setActivo(true);

            // 3. Guardamos la entidad en PostgreSQL a través del repositorio
            Transaccion transaccionGuardada = transaccionRepository.save(transaccion);

            // 4. Retornamos el DTO de respuesta con el ID autogenerado
            return new GuardarTransaccionResponse(
                    transaccionGuardada.getId(),
                    "Transacción registrada exitosamente."
            );

        } catch (FintechException e) {
            // Permitimos que nuestra excepción personalizada pase sin ser alterada
            throw e;
        } catch (Exception e) {
            // 5. Capturamos errores de base de datos u otros inesperados
            throw new FintechException(
                    "ERROR_BASE_DATOS",
                    "No se pudo guardar la transacción. Por favor, intente nuevamente."
            );
        }
    }
}