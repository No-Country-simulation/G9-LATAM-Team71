import json
import math
from datetime import datetime
from dateutil.relativedelta import relativedelta

def modelar_y_gamificar_meta(datos_usuario, datos_meta, fecha_actual_str):
    """
    Proyecta la fecha de cumplimiento de una meta financiera y genera 
    mensajes gamificados para motivar al usuario a mejorar sus finanzas.
    """
    # 1. Extraer variables
    ingreso = datos_usuario.get('ingreso_mensual', 0.0)
    gasto_promedio = datos_usuario.get('gasto_mensual_promedio', 0.0)
    
    monto_objetivo = datos_meta.get('monto_objetivo', 0.0)
    monto_actual = datos_meta.get('monto_actual', 0.0) # Lo que ya tiene ahorrado
    nombre_meta = datos_meta.get('nombre', 'Meta')
    fecha_limite_str = datos_meta.get('fecha_limite')
    
    fecha_actual = datetime.strptime(fecha_actual_str, "%Y-%m-%d")
    fecha_limite = datetime.strptime(fecha_limite_str, "%Y-%m-%d")
    
    # 2. Cálculos base de la proyección
    capacidad_ahorro_mensual = ingreso - gasto_promedio
    monto_faltante = monto_objetivo - monto_actual
    
    # Calcular meses restantes hasta la fecha límite "oficial" de la base de datos
    diferencia_fechas = relativedelta(fecha_limite, fecha_actual)
    meses_limite = diferencia_fechas.years * 12 + diferencia_fechas.months + (1 if diferencia_fechas.days > 0 else 0)
    
    if meses_limite <= 0:
        meses_limite = 1 # Evitar división por cero si la fecha ya pasó o es este mes
        
    ahorro_necesario_mensual = monto_faltante / meses_limite

    # 3. Modelado Predictivo: ¿Cuándo lo logrará realmente a su ritmo actual?
    if capacidad_ahorro_mensual > 0:
        meses_proyectados = math.ceil(monto_faltante / capacidad_ahorro_mensual)
        fecha_proyectada = fecha_actual + relativedelta(months=meses_proyectados)
        probabilidad_exito = 95.0 if meses_proyectados <= meses_limite else max(10.0, 100 - ((meses_proyectados - meses_limite) * 5))
    else:
        meses_proyectados = -1 # Infinito (no está ahorrando)
        fecha_proyectada = None
        probabilidad_exito = 0.0

    # 4. Motor de Gamificación (Asignación de "Misiones" y "Rangos")
    estado_mision = ""
    rango_financiero = ""
    mensaje_gamificado = ""
    
    if capacidad_ahorro_mensual <= 0:
        estado_mision = "PELIGRO"
        rango_financiero = "Hierro"
        mensaje_gamificado = f"¡Misión en riesgo! Actualmente tus gastos superan tus ingresos. Para desbloquear el logro '{nombre_meta}', necesitas recortar gastos y generar al menos ${ahorro_necesario_mensual:.2f} de ahorro mensual."
        
    elif meses_proyectados <= meses_limite:
        estado_mision = "EXCELENTE"
        rango_financiero = "Platino"
        meses_anticipacion = meses_limite - meses_proyectados
        
        if meses_anticipacion > 0:
            mensaje_gamificado = f"¡Racha ganadora! Al ritmo actual, conseguirás '{nombre_meta}' {meses_anticipacion} meses antes de lo planeado. Tu Matchmaking Rating (MMR) financiero está por los cielos."
        else:
            mensaje_gamificado = f"¡Vas exacto a tiempo para conseguir '{nombre_meta}'! Mantén tu capacidad de ahorro mensual de ${capacidad_ahorro_mensual:.2f} para asegurar la victoria."
            
    else:
        estado_mision = "ATRASADO"
        rango_financiero = "Plata"
        esfuerzo_extra = ahorro_necesario_mensual - capacidad_ahorro_mensual
        mensaje_gamificado = f"Estás perdiendo terreno en la misión '{nombre_meta}'. Proyectamos que terminarás {meses_proyectados - meses_limite} meses tarde. Misión secundaria: Reduce tus gastos variables para ahorrar ${esfuerzo_extra:.2f} extra al mes y volver al juego."

    # 5. Construir JSON de respuesta
    respuesta_json = {
        "meta": nombre_meta,
        "progreso_actual": {
            "monto_objetivo": round(monto_objetivo, 2),
            "monto_faltante": round(monto_faltante, 2),
            "porcentaje_completado": round((monto_actual / monto_objetivo) * 100, 2)
        },
        "analisis_proyeccion": {
            "capacidad_ahorro_actual": round(capacidad_ahorro_mensual, 2),
            "meses_estimados_fin": meses_proyectados,
            "fecha_estimada_fin": fecha_proyectada.strftime("%Y-%m-%d") if fecha_proyectada else "Indefinida",
            "probabilidad_exito_a_tiempo": round(probabilidad_exito, 2)
        },
        "gamificacion": {
            "rango_actual": rango_financiero,
            "estado": estado_mision,
            "mensaje_motivacional": mensaje_gamificado
        }
    }
    
    return json.dumps(respuesta_json, indent=4, ensure_ascii=False)


# ==========================================
# EJEMPLO DE USO 
# ==========================================

# El usuario gana 1500, pero sus gastos fijos y variables promedian 1300.
# Le sobran 200 al mes (capacidad de ahorro).
usuario_mock = {
    "ingreso_mensual": 1500.00,
    "gasto_mensual_promedio": 1300.00 
}

# Su meta es un fondo de emergencia de 800, tiene 0, y quiere lograrlo en 3 meses.
# Matemáticamente necesita 266.66 al mes. Como solo le sobran 200, está atrasado.
meta_mock = {
    "nombre": "Fondo de emergencia",
    "monto_objetivo": 800.00,
    "monto_actual": 0.00,
    "fecha_limite": "2026-11-10" # Aprox 3 meses desde la fecha de consulta
}

fecha_hoy = "2026-08-10"

resultado = modelar_y_gamificar_meta(usuario_mock, meta_mock, fecha_hoy)
print(resultado)