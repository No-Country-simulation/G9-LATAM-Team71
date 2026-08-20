package com.hackathon.financeai.dto;

import com.hackathon.financeai.model.Estado;
import java.util.UUID;

public record RegistrarMetaResponse(
        UUID id_meta,
        Estado estado,
        String mensaje
) {}
