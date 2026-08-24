package com.hackathon.financeai.dto;

import java.util.UUID;

public record GuardarTransaccionResponse(
        UUID id_transaccion,
        String mensaje
) {
}
