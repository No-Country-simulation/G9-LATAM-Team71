/*
=============================================================================
                SCRIPT DE DATOS DE PRUEBA (SEED) - MVP FINTECH
=============================================================================
Este script inyecta un set de datos robusto para poblar la base de datos y 
permitir la prueba inmediata del Dashboard, Metas, Transacciones y Análisis.

Contraseñas: Todos los usuarios tienen la contraseña "contrasena123"
(Ya hasheada con BCrypt para ser compatible con Spring Security)
*/

-- 1. Limpiar las tablas (Opcional, en caso de correrlo varias veces)
-- Usamos CASCADE para evitar problemas de llaves foráneas
TRUNCATE TABLE usuarios CASCADE;
TRUNCATE TABLE metas CASCADE;
TRUNCATE TABLE transacciones CASCADE;
TRUNCATE TABLE analisis_financieros CASCADE;


-- 2. Insertar Usuarios
INSERT INTO usuarios (id, nombre, apellido, correo, contrasena, ingreso_mensual, frecuencia_ahorro, nivel_endeudamiento, perfil_financiero, fecha_creacion) VALUES
('11111111-1111-1111-1111-111111111111', 'Andre', 'Garcia', 'garciajoseph537@gmail.com', '$2a$12$gYAwZKys4gLqmJAeuIpQr.6xXehuE/5gITtZl3GWZ/ieA/i.ZYgKG', 5000.00, 'MEDIA', 20.00, 'SALUDABLE', '2026-07-01 10:00:00'),
('22222222-2222-2222-2222-222222222222', 'Maria', 'Lopez', 'maria.lopez@example.com', '$2a$12$gYAwZKys4gLqmJAeuIpQr.6xXehuE/5gITtZl3GWZ/ieA/i.ZYgKG', 7500.00, 'ALTA', 10.00, 'SALUDABLE', '2026-07-05 11:30:00'),
('33333333-3333-3333-3333-333333333333', 'Carlos', 'Perez', 'carlos.perez@example.com', '$2a$12$gYAwZKys4gLqmJAeuIpQr.6xXehuE/5gITtZl3GWZ/ieA/i.ZYgKG', 3000.00, 'BAJA', 60.00, 'EN_RIESGO', '2026-07-10 16:20:00');


-- 3. Insertar Metas Financieras
INSERT INTO metas (usuario_id, nombre, monto_objetivo, monto_actual, fecha_inicio, fecha_limite, estado) VALUES
-- Metas de Andre
('11111111-1111-1111-1111-111111111111', 'Fondo de Emergencia', 20000.00, 5000.00, '2026-01-01', '2026-12-31', 'ACTIVA'),
('11111111-1111-1111-1111-111111111111', 'Laptop Nueva (Trabajo)', 15000.00, 15000.00, '2026-03-01', '2026-08-01', 'COMPLETADA'),
('11111111-1111-1111-1111-111111111111', 'Viaje a Cancún', 30000.00, 2500.00, '2026-07-01', '2027-07-01', 'ACTIVA'),
-- Metas de Maria
('22222222-2222-2222-2222-222222222222', 'Auto Nuevo', 200000.00, 50000.00, '2026-01-01', '2028-01-01', 'ACTIVA');


-- 4. Insertar Transacciones (Historial realista para Andre Garcia en el mes actual)
INSERT INTO transacciones (usuario_id, categoria, monto, descripcion, fecha, tipo_flujo, cualidad_flujo) VALUES
-- INGRESOS (Andre)
('11111111-1111-1111-1111-111111111111', 'INGRESO', 5000.00, 'Quincena 1 de Agosto', '2026-08-01 09:00:00', 'INGRESO', 'FIJO'),
('11111111-1111-1111-1111-111111111111', 'INGRESO', 1500.00, 'Venta de Xbox usado', '2026-08-10 14:00:00', 'INGRESO', 'VARIABLE'),

-- EGRESOS: FIJOS VITALES (Andre)
('11111111-1111-1111-1111-111111111111', 'VIVIENDA', 1200.00, 'Renta Mensual del Departamento', '2026-08-02 10:00:00', 'EGRESO', 'FIJO_VITAL'),
('11111111-1111-1111-1111-111111111111', 'SERVICIOS', 250.00, 'Recibo de Luz CFE', '2026-08-05 11:30:00', 'EGRESO', 'FIJO_VITAL'),
('11111111-1111-1111-1111-111111111111', 'SERVICIOS', 150.00, 'Recibo de Agua', '2026-08-05 11:35:00', 'EGRESO', 'FIJO_VITAL'),
('11111111-1111-1111-1111-111111111111', 'ALIMENTACION', 900.00, 'Supermercado Walmart - Despensa', '2026-08-06 18:45:00', 'EGRESO', 'FIJO_VITAL'),

-- EGRESOS: FIJOS NO VITALES (Andre)
('11111111-1111-1111-1111-111111111111', 'SERVICIOS', 120.00, 'Suscripción Netflix Premium', '2026-08-03 14:00:00', 'EGRESO', 'FIJO_NO_VITAL'),
('11111111-1111-1111-1111-111111111111', 'SERVICIOS', 90.00, 'Spotify Plan Familiar', '2026-08-04 10:00:00', 'EGRESO', 'FIJO_NO_VITAL'),
('11111111-1111-1111-1111-111111111111', 'SERVICIOS', 350.00, 'Mensualidad Gimnasio SmartFit', '2026-08-02 08:00:00', 'EGRESO', 'FIJO_NO_VITAL'),

-- EGRESOS: VARIABLES (Andre)
('11111111-1111-1111-1111-111111111111', 'OCIO', 450.00, 'Cena en Restaurante Italiano', '2026-08-08 21:00:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'TRANSPORTE', 500.00, 'Carga de Gasolina Magna', '2026-08-09 17:30:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'SALUD', 600.00, 'Consulta Médica General', '2026-08-11 12:00:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'SALUD', 150.00, 'Medicamentos Farmacia San Pablo', '2026-08-11 12:45:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'ALIMENTACION', 85.00, 'Café Mocca Venti - Starbucks', '2026-08-15 08:30:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'ALIMENTACION', 220.00, 'Uber Eats - Tacos', '2026-08-16 22:00:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'OCIO', 300.00, 'Boletos de Cine y Palomitas', '2026-08-18 19:30:00', 'EGRESO', 'VARIABLE'),

-- EGRESOS: DEUDAS E INVERSIONES (Andre)
('11111111-1111-1111-1111-111111111111', 'DEUDAS', 1500.00, 'Pago Mensual Tarjeta de Crédito Nu', '2026-08-12 16:00:00', 'EGRESO', 'FIJO_NO_VITAL'),
('11111111-1111-1111-1111-111111111111', 'INVERSION', 500.00, 'Aporte a Fondo de Emergencia', '2026-08-14 10:00:00', 'EGRESO', 'VARIABLE'),
('11111111-1111-1111-1111-111111111111', 'INVERSION', 250.00, 'Aporte a Viaje a Cancún', '2026-08-14 10:05:00', 'EGRESO', 'VARIABLE'),

-- Transacciones Usuario 2 (Para tener ruido extra en la DB)
('22222222-2222-2222-2222-222222222222', 'INGRESO', 7500.00, 'Sueldo', '2026-08-01 10:00:00', 'INGRESO', 'FIJO'),
('22222222-2222-2222-2222-222222222222', 'VIVIENDA', 2000.00, 'Renta', '2026-08-02 09:00:00', 'EGRESO', 'FIJO_VITAL');


-- 5. Insertar Análisis Financiero pre-procesado para Andre
INSERT INTO analisis_financieros (usuario_id, fecha_creacion, data_analisis) VALUES
('11111111-1111-1111-1111-111111111111', '2026-08-20 23:59:59', '{
    "periodo": {
      "inicio": "2026-08-01",
      "fin": "2026-08-31"
    },
    "indicadores": {
      "tasa_ahorro": 18.5,
      "nivel_endeudamiento": 12.3,
      "porcentaje_ingreso_gastado": 76.4,
      "categoria_mayor_gasto": "OCIO",
      "porcentaje_categoria_mayor_gasto": 35.2,
      "gasto_promedio": 850.0
    },
    "comparacion_periodo_anterior": {
      "tasa_ahorro": { "actual": 18.5, "anterior": 15.2, "variacion": 3.3 },
      "nivel_endeudamiento": { "actual": 12.3, "anterior": 14.8, "variacion": -2.5 },
      "porcentaje_ingreso_gastado": { "actual": 76.4, "anterior": 81.2, "variacion": -4.8 },
      "gasto_promedio_controlable": { "actual": 620.0, "anterior": 540.0, "variacion": 80.0, "variacion_porcentual": 14.81 },
      "gasto_promedio": { "actual": 850.0, "anterior": 790.0, "variacion": 60.0, "variacion_porcentual": 7.59 },
      "categoria_mayor_gasto": { "actual": "OCIO", "anterior": "TRANSPORTE", "cambio": true }
    },
    "perfil_financiero": {
      "perfil": "Ahorrador",
      "descripcion": "El usuario presenta una buena capacidad de ahorro y un nivel de endeudamiento controlado."
    },
    "recomendaciones": [
      {
        "tipo": "GASTOS",
        "prioridad": "MEDIA",
        "mensaje": "Cuidado con los gastos variables en OCIO. Consumieron el 35% de tus egresos esta quincena."
      },
      {
        "tipo": "AHORRO",
        "prioridad": "ALTA",
        "mensaje": "Has superado un hito: ya tienes más del 20% guardado para tu Fondo de Emergencia."
      }
    ],
    "metas": [
      {
        "id_meta": "00000000-0000-0000-0000-000000000000",
        "monto_objetivo": 12000.0,
        "monto_actual": 7500.0,
        "monto_restante": 4500.0,
        "fecha_inicio": "2026-06-01",
        "fecha_limite": "2026-12-31"
      }
    ]
}');
