import pandas as pd
import numpy as np
import json
import joblib
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, accuracy_score

# =====================================================================
# 1. GENERACIÓN DE DATOS SINTÉTICOS (Para entrenar el modelo)
# =====================================================================
# Para predecir si alguien llegará a fin de mes, el modelo necesita 
# aprender de "fotografías" de días anteriores.
def generar_datos_entrenamiento_estres(num_registros=1000):
    np.random.seed(42)
    
    # Simulamos el día del mes en el que se hace la consulta (del 1 al 28)
    dias_del_mes = np.random.randint(1, 29, num_registros)
    
    # Simulamos el ingreso mensual
    ingresos_mensuales = np.random.uniform(800, 5000, num_registros)
    
    # Simulamos el gasto acumulado hasta ese día
    # Lógica: A mayor día del mes, mayor es el gasto acumulado probable
    porcentaje_gasto_base = (dias_del_mes / 30) 
    variacion_gasto = np.random.uniform(0.5, 1.5, num_registros) # Usuarios que gastan menos o más
    gastos_acumulados = ingresos_mensuales * porcentaje_gasto_base * variacion_gasto
    
    df = pd.DataFrame({
        'dia_del_mes': dias_del_mes,
        'ingreso_mensual': ingresos_mensuales,
        'gasto_acumulado': gastos_acumulados
    })
    
    # Feature Engineering (Ingeniería de atributos): 
    # Al modelo le sirve más el porcentaje que el valor absoluto
    df['porcentaje_gastado'] = df['gasto_acumulado'] / df['ingreso_mensual']
    
    # Variable Objetivo (Target): 1 si terminó el mes endeudado (estrés), 0 si no.
    # Lógica sintética: Si en el día evaluado ya gastó mucho para la fecha, tiene estrés.
    limite_saludable_diario = df['dia_del_mes'] / 30
    df['hubo_estres_fin_de_mes'] = np.where(df['porcentaje_gastado'] > (limite_saludable_diario + 0.15), 1, 0)
    
    return df

# =====================================================================
# 2. ENTRENAMIENTO DEL MODELO DE ALERTA
# =====================================================================
print("Generando datos históricos y entrenando modelo de alerta...")
df_historico = generar_datos_entrenamiento_estres(2000)

# Seleccionamos nuestras variables predictoras (Features)
X = df_historico[['dia_del_mes', 'porcentaje_gastado']]
y = df_historico['hubo_estres_fin_de_mes']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Entrenamos la Regresión Logística
modelo_estres = LogisticRegression()
modelo_estres.fit(X_train, y_train)

# Evaluamos
y_pred = modelo_estres.predict(X_test)
print(f"Precisión del modelo de alerta: {accuracy_score(y_test, y_pred):.2f}")

# Guardamos el modelo para OCI / Backend
ruta_modelo_estres = "modelo_alerta_estres.joblib"
joblib.dump(modelo_estres, ruta_modelo_estres)
print(f"Modelo guardado en: {ruta_modelo_estres}\n")


# =====================================================================
# 3. FUNCIÓN DE INFERENCIA PARA LA API REST (El Endpoint)
# =====================================================================
def analizar_riesgo_estres(dia_actual, gasto_acumulado_mes, ingreso_mensual):
    """
    Esta función es la que llamará tu API. Toma los datos en vivo del usuario,
    calcula sus métricas y usa el modelo para devolver un JSON con la alerta.
    """
    # 1. Cargar el modelo
    modelo = joblib.load("modelo_alerta_estres.joblib")
    
    # 2. Preparar los datos tal como los espera el modelo
    porcentaje_gastado = gasto_acumulado_mes / ingreso_mensual if ingreso_mensual > 0 else 1.0
    
    datos_entrada = pd.DataFrame({
        'dia_del_mes': [dia_actual],
        'porcentaje_gastado': [porcentaje_gastado]
    })
    
    # 3. Predecir probabilidad (predict_proba devuelve [prob_clase_0, prob_clase_1])
    probabilidades = modelo.predict_proba(datos_entrada)[0]
    probabilidad_estres = probabilidades[1] * 100 # Porcentaje
    
    # 4. Lógica de negocio para generar la recomendación
    nivel_alerta = "Bajo"
    mensaje = "Tus finanzas van por buen camino este mes."
    
    if probabilidad_estres > 75:
        nivel_alerta = "Crítico"
        mensaje = f"¡ALERTA! Hay un {probabilidad_estres:.0f}% de probabilidad de que te quedes sin liquidez antes de fin de mes. Frena tus gastos variables inmediatamente."
    elif probabilidad_estres > 50:
        nivel_alerta = "Medio"
        mensaje = f"Precaución. Estás gastando más rápido de lo habitual para el día {dia_actual} del mes. Revisa tu presupuesto."

    # 5. Estructurar JSON de salida
    respuesta_json = {
        "indicadores_actuales": {
            "dia_del_mes": dia_actual,
            "porcentaje_ingreso_gastado": round(porcentaje_gastado * 100, 2)
        },
        "analisis_predictivo": {
            "probabilidad_estres_financiero": round(probabilidad_estres, 2),
            "nivel_alerta": nivel_alerta
        },
        "recomendacion_accionable": mensaje
    }
    
    return respuesta_json

# =====================================================================
# 4. PRUEBA DE LA API (Simulación)
# =====================================================================
# Caso 1: Usuario que va bien (Día 15, ha gastado poco)
resultado_sano = analizar_riesgo_estres(dia_actual=15, gasto_acumulado_mes=300, ingreso_mensual=1000)

# Caso 2: Usuario en peligro (Día 10, ya se gastó casi todo)
resultado_peligro = analizar_riesgo_estres(dia_actual=10, gasto_acumulado_mes=800, ingreso_mensual=1000)

print("--- RESPUESTA API: USUARIO SANO ---")
print(json.dumps(resultado_sano, indent=4, ensure_ascii=False))

print("\n--- RESPUESTA API: USUARIO EN PELIGRO ---")
print(json.dumps(resultado_peligro, indent=4, ensure_ascii=False))