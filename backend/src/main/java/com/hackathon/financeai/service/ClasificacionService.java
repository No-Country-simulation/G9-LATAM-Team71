package com.hackathon.financeai.service;

import com.hackathon.financeai.dto.ClasificacionTransaccionesRequest;
import com.hackathon.financeai.dto.ClasificacionTransaccionesResponse;
import com.hackathon.financeai.dto.TransaccionDTO;
import com.hackathon.financeai.model.Categoria;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
public class ClasificacionService {

    public ClasificacionTransaccionesResponse procesarClasificacion(ClasificacionTransaccionesRequest request) {
        List<ClasificacionTransaccionesResponse.TransaccionClasificada> listaClasificada = new ArrayList<>();

        // Iteramos sobre las transacciones que llegan en el JSON
        for (TransaccionDTO transaccion : request.getTransacciones()) {

            // Reutilizamos la misma lógica de palabras clave de Dev 2
            Categoria categoriaAsignada = clasificarPorPalabrasClave(transaccion.getDescripcion());

            // Creamos el objeto de respuesta por cada transacción
            ClasificacionTransaccionesResponse.TransaccionClasificada clasificada =
                    new ClasificacionTransaccionesResponse.TransaccionClasificada(
                            transaccion.getDescripcion(),
                            transaccion.getMonto(), // Usamos getMonto() por los nuevos contratos
                            categoriaAsignada
                    );

            listaClasificada.add(clasificada);
        }

        ClasificacionTransaccionesResponse response = new ClasificacionTransaccionesResponse();
        response.setTransacciones(listaClasificada);
        return response;
    }

    // TAREA 3: Lógica coordinada con Dev 2 para usar las mismas palabras clave
    private Categoria clasificarPorPalabrasClave(String descripcion) {
        if (descripcion == null || descripcion.isBlank()) {
            return Categoria.SERVICIOS; // Categoría por defecto
        }

        String texto = descripcion.toLowerCase(Locale.ROOT);

        if (texto.contains("supermercado") || texto.contains("comida")) {
            return Categoria.ALIMENTACION;
        }
        if (texto.contains("combustible") || texto.contains("uber")) {
            return Categoria.TRANSPORTE;
        }
        if (texto.contains("streaming") || texto.contains("cine")) {
            return Categoria.OCIO;
        }

        // Si no coincide con nada, usamos SERVICIOS como comodín en lugar del string "OTROS"
        return Categoria.SERVICIOS;
    }
}
