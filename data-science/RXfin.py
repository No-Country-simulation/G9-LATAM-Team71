import pandas as pd
import json
import matplotlib.pyplot as plt


def generar_radiografia_gastos(datos_transacciones, ingreso_mensual):
    """
    Analiza las transacciones de un usuario para generar una radiografía 
    de sus gastos fijos vs variables y su impacto en el ingreso.
    """
    # 1. Convertir los datos a un DataFrame de Pandas
    df = pd.DataFrame(datos_transacciones)
    
    # 2. Filtrar únicamente los egresos (asegurando que coincida con tu ENUM)
    # Asumimos que la columna se llama 'flujo' o 'tipo_flujo' según tu diagrama
    df_gastos = df[df['flujo'].str.upper() == 'EGRESO'].copy()
    
    # 3. Agrupar los montos por la 'cualidad_flujo'
    # Agrupamos y sumamos los montos para cada categoría de cualidad
    resumen_gastos = df_gastos.groupby('cualidad_flujo')['monto'].sum().to_dict()
    
    # Asegurarnos de que las tres claves existan en el diccionario, incluso si son 0
    cualidades_enum = ['FIJO_VITAL', 'FIJO_NO_VITAL', 'VARIABLE']
    for cualidad in cualidades_enum:
        if cualidad not in resumen_gastos:
            resumen_gastos[cualidad] = 0.0
            
    # 4. Calcular métricas clave
    gasto_total = sum(resumen_gastos.values())
    dinero_libre = ingreso_mensual - gasto_total
    
    porcentaje_vital = (resumen_gastos['FIJO_VITAL'] / ingreso_mensual) * 100 if ingreso_mensual > 0 else 0
    porcentaje_variable = (resumen_gastos['VARIABLE'] / ingreso_mensual) * 100 if ingreso_mensual > 0 else 0
    
    # 5. Generar alerta o estado de riesgo (Lógica de negocio simple)
    alerta = "Ninguna"
    if porcentaje_vital > 50:
        alerta = "Tus gastos fijos vitales consumen más del 50% de tus ingresos. Tienes poco margen de maniobra."
    elif porcentaje_variable > 30:
        alerta = "Tus gastos variables son altos. Revisa fugas de dinero en esta categoría."
    
    # 6. Estructurar la respuesta para la API (Formato JSON-ready)
    resultado = {
        "ingreso_mensual": round(ingreso_mensual, 2),
        "gasto_total": round(gasto_total, 2),
        "dinero_libre_restante": round(dinero_libre, 2),
        "desglose_cualidad": {
            k: round(v, 2) for k, v in resumen_gastos.items()
        },
        "indicadores": {
            "porcentaje_ingreso_fijo_vital": round(porcentaje_vital, 2),
            "porcentaje_ingreso_variable": round(porcentaje_variable, 2)
        },
        "alerta_automatica": alerta
    }
    
    return resultado

# ==========================================
# EJEMPLO DE USO (Simulando datos de la BD)
# ==========================================

transacciones_usuario_mock = [
    {"id": 1, "monto": 400.00, "flujo": "EGRESO", "cualidad_flujo": "FIJO_VITAL", "descripcion": "Alquiler"},
    {"id": 2, "monto": 150.00, "flujo": "EGRESO", "cualidad_flujo": "FIJO_VITAL", "descripcion": "Supermercado"},
    {"id": 3, "monto": 50.00, "flujo": "EGRESO", "cualidad_flujo": "FIJO_NO_VITAL", "descripcion": "Suscripción Streaming"},
    {"id": 4, "monto": 120.00, "flujo": "EGRESO", "cualidad_flujo": "VARIABLE", "descripcion": "Cena restaurante"},
    {"id": 5, "monto": 80.00, "flujo": "EGRESO", "cualidad_flujo": "VARIABLE", "descripcion": "Ropa"},
    {"id": 6, "monto": 1000.00, "flujo": "INGRESO", "cualidad_flujo": "FIJO_VITAL", "descripcion": "Salario"} # Este será ignorado por el filtro
]

ingreso_usuario = 1000.00

# Ejecutar el análisis
radiografia_json = generar_radiografia_gastos(transacciones_usuario_mock, ingreso_usuario)

# Imprimir el resultado tal como lo devolvería tu API
print(json.dumps(radiografia_json, indent=4, ensure_ascii=False))