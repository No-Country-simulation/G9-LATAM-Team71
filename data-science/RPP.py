import pandas as pd
import numpy as np
import json
from datetime import datetime

def detectar_cobros_recurrentes(datos_transacciones, fecha_actual_str):
    """
    Analiza el historial de transacciones para detectar gastos fijos o suscripciones
    que ocurren de manera regular, y predice los próximos cobros.
    """
    # 1. Cargar datos y convertir fechas
    df = pd.DataFrame(datos_transacciones)
    df['fecha'] = pd.to_datetime(df['fecha'])
    fecha_actual = pd.to_datetime(fecha_actual_str)
    
    # 2. Filtrar solo Egresos y limpiar descripciones
    df_egresos = df[df['flujo'].str.upper() == 'EGRESO'].copy()
    df_egresos['descripcion_limpia'] = df_egresos['descripcion'].str.strip().str.lower()
    
    # 3. Extraer el día del mes de cada transacción
    df_egresos['dia_del_mes'] = df_egresos['fecha'].dt.day
    
    # 4. Agrupar por descripción para encontrar patrones estadísticos
    patrones = df_egresos.groupby('descripcion_limpia').agg(
        nombre_original=('descripcion', 'first'),
        frecuencia=('id', 'count'),
        monto_promedio=('monto', 'mean'),
        monto_std=('monto', 'std'),
        dia_promedio=('dia_del_mes', 'mean'),
        dia_std=('dia_del_mes', 'std'),
        ultima_fecha_pago=('fecha', 'max')
    ).reset_index()
    
    # 5. Lógica de Detección de Recurrencia
    # - Debe ocurrir al menos 2 veces en el historial
    patrones = patrones[patrones['frecuencia'] >= 2].copy()
    
    # Rellenar valores nulos de desviación estándar (ocurre si solo hay 1 o 2 datos idénticos)
    patrones['dia_std'] = patrones['dia_std'].fillna(0)
    patrones['monto_std'] = patrones['monto_std'].fillna(0)
    
    # - La desviación estándar del día de cobro debe ser baja (tolerancia de +/- 4 días)
    recurrentes = patrones[patrones['dia_std'] <= 4.0].copy()
    
    # 6. Generar las predicciones y alertas
    proximos_cobros = []
    total_estimado = 0
    
    for _, row in recurrentes.iterrows():
        dia_estimado = int(round(row['dia_promedio']))
        monto_estimado = round(row['monto_promedio'], 2)
        
        # Calcular los días faltantes para el próximo cobro
        dia_actual = fecha_actual.day
        if dia_estimado >= dia_actual:
            dias_faltantes = dia_estimado - dia_actual
        else:
            # Si ya pasó este mes, estimamos para el mes siguiente
            dias_en_mes_actual = pd.Period(fecha_actual_str).days_in_month
            dias_faltantes = (dias_en_mes_actual - dia_actual) + dia_estimado
            
        # Asignar un nivel de confianza basado en la varianza temporal
        confianza = "Alta" if row['dia_std'] <= 1.5 else "Media"
        
        total_estimado += monto_estimado
        
        proximos_cobros.append({
            "descripcion": row['nombre_original'],
            "monto_estimado": monto_estimado,
            "dia_mes_habitual": dia_estimado,
            "dias_faltantes": dias_faltantes,
            "nivel_confianza": confianza
        })
        
    # Ordenar por proximidad (los que están por cobrarse antes)
    proximos_cobros = sorted(proximos_cobros, key=lambda x: x['dias_faltantes'])
    
    # 7. Formatear salida para el Endpoint (JSON)
    resultado_json = {
        "fecha_analisis": fecha_actual_str,
        "alertas_cobros_proximos": proximos_cobros,
        "resumen": {
            "total_suscripciones_detectadas": len(proximos_cobros),
            "carga_financiera_estimada": round(total_estimado, 2)
        }
    }
    
    return resultado_json

# ==========================================
# EJEMPLO DE USO (Simulando un histórico)
# ==========================================

historial_transacciones = [
    # Alquiler (Muy regular en monto y fecha)
    {"id": 1, "flujo": "EGRESO", "monto": 800.00, "fecha": "2026-05-02", "descripcion": "Pago Alquiler"},
    {"id": 2, "flujo": "EGRESO", "monto": 800.00, "fecha": "2026-06-01", "descripcion": "Pago Alquiler"},
    {"id": 3, "flujo": "EGRESO", "monto": 800.00, "fecha": "2026-07-02", "descripcion": "Pago Alquiler"},
    
    # Streaming (Regular en monto y fecha)
    {"id": 4, "flujo": "EGRESO", "monto": 15.00, "fecha": "2026-05-15", "descripcion": "Netflix"},
    {"id": 5, "flujo": "EGRESO", "monto": 15.00, "fecha": "2026-06-16", "descripcion": "Netflix"},
    {"id": 6, "flujo": "EGRESO", "monto": 15.00, "fecha": "2026-07-15", "descripcion": "Netflix"},
    
    # Restaurante (Irregular, no debe ser detectado como cita de cobro)
    {"id": 7, "flujo": "EGRESO", "monto": 45.00, "fecha": "2026-05-10", "descripcion": "Pizzeria"},
    {"id": 8, "flujo": "EGRESO", "monto": 50.00, "fecha": "2026-06-25", "descripcion": "Pizzeria"},
    {"id": 9, "flujo": "EGRESO", "monto": 40.00, "fecha": "2026-07-08", "descripcion": "Pizzeria"},
    
    # Ingreso (Debe ser ignorado)
    {"id": 10, "flujo": "INGRESO", "monto": 2000.00, "fecha": "2026-07-01", "descripcion": "Salario"}
]


# Supongamos que el usuario consulta su app el 10 de Agosto de 2026
fecha_hoy = "2026-08-10"

resultado_prediccion = detectar_cobros_recurrentes(historial_transacciones, fecha_hoy)

print(json.dumps(resultado_prediccion, indent=4, ensure_ascii=False))