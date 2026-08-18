/*
=============================================================================
                INICIALIZACIÓN DE LA BASE DE DATOS - MVP FINTECH
         Estándar: UPPERCASE_SNAKE_CASE para enumeradores sistémicos
=============================================================================
*/
-- Habilitar extensión nativa para la generación automática de llaves criptográficas UUIDv4
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL, -- Longitud adecuada para hashes (BCrypt/Argon2)
    ingreso_mensual DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    frecuencia_ahorro VARCHAR(50) NOT NULL DEFAULT 'MEDIA', -- Declaración inicial (BAJA / MEDIA / ALTA)
    nivel_endeudamiento DECIMAL(5,2) NOT NULL DEFAULT 0.00, -- Almacena porcentaje exacto (Ej: 35.50%)
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    -- Campos administrados por el pipeline predictivo
    perfil_financiero VARCHAR(50) NOT NULL DEFAULT 'NO_EVALUADO',
    recomendaciones JSONB, -- Almacenamiento indexable para el historial de reportes
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Candados de integridad a nivel motor base de datos
    CONSTRAINT chk_perfil CHECK (perfil_financiero IN ('SALUDABLE', 'EN_OBSERVACION', 'EN_RIESGO', 'NO_EVALUADO'))
);

-- Metas
CREATE TABLE IF NOT EXISTS metas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    monto_objetivo DECIMAL(10,2) NOT NULL,
    monto_actual DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    fecha_limite DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Restricciones y reglas referenciales
    CONSTRAINT fk_usuario_meta FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    CONSTRAINT chk_estado_meta CHECK (estado IN ('ACTIVA', 'COMPLETADA', 'ABANDONADA'))
);

-- Transacciones
CREATE TABLE IF NOT EXISTS transacciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    categoria VARCHAR(30) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Métricas del comportamiento y sentido del flujo financiero
    tipo_flujo VARCHAR(10) NOT NULL,
    cualidad_flujo VARCHAR(20), 
    
    -- Llaves foráneas y reglas de eliminación
    CONSTRAINT fk_usuario_transaccion FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    
    -- Candados condicionales para la integridad del dinero
    CONSTRAINT chk_tipo_flujo CHECK (tipo_flujo IN ('INGRESO', 'EGRESO')),
    CONSTRAINT chk_cualidad_flujo CHECK (
        (tipo_flujo = 'EGRESO' AND cualidad_flujo IN ('FIJO_VITAL', 'FIJO_NO_VITAL', 'VARIABLE')) OR
        (tipo_flujo = 'INGRESO' AND cualidad_flujo IN ('FIJO_VITAL', 'VARIABLE'))
    )
);

-- INDICES
CREATE INDEX IF NOT EXISTS idx_transacciones_usuario ON transacciones(usuario_id);
CREATE INDEX IF NOT EXISTS idx_metas_usuario ON metas(usuario_id);