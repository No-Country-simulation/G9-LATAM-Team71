import json

def generar_recetas_financieras(datos_usuario, resumen_gastos, meta_activa=None):
    """
    Genera un JSON con recomendaciones accionables basadas en el perfil, 
    nivel de deuda, distribución de gastos y metas activas del usuario.
    """
    perfil = datos_usuario.get('perfil_financiero', 'EN_OBSERVACION')
    ingreso = datos_usuario.get('ingreso_mensual', 0.0)
    deuda = datos_usuario.get('nivel_endeudamiento', 0.0)
    
    recetas = []
    
    # ---------------------------------------------------------
    # 1. REGLAS TRANSVERSALES (Basadas en Deuda)
    # ---------------------------------------------------------
    if deuda > 40:
        pago_sugerido = round(ingreso * 0.20, 2)
        recetas.append({
            "tipo_alerta": "CRITICA",
            "categoria": "Desendeudamiento",
            "titulo": "Plan de Choque contra Deudas",
            "accion_sugerida": f"Tu nivel de endeudamiento ({deuda}%) es alto. Destina estrictamente ${pago_sugerido} de tus ingresos de este mes para abonar a la deuda con mayor tasa de interés."
        })

    # ---------------------------------------------------------
    # 2. REGLAS ESPECÍFICAS POR PERFIL FINANCIERO
    # ---------------------------------------------------------
    if perfil == 'SALUDABLE':
        recetas.append({
            "tipo_alerta": "OPORTUNIDAD",
            "categoria": "Crecimiento",
            "titulo": "Pon tu liquidez a trabajar",
            "accion_sugerida": "Tus finanzas son estables y tienes flujo de caja positivo. Considera automatizar una transferencia hacia un instrumento de inversión o cuenta de ahorro de alto rendimiento."
        })
        
        if meta_activa and meta_activa.get('estado') == 'Activa':
            recetas.append({
                "tipo_alerta": "MOTIVACION",
                "categoria": "Metas",
                "titulo": f"Acelera tu objetivo: {meta_activa.get('nombre')}",
                "accion_sugerida": "Tienes margen para aportar un 10% extra este mes a tu meta y alcanzarla antes de lo previsto."
            })

    elif perfil == 'EN_OBSERVACION':
        # Buscamos la categoría de gasto "variable" más alta para sugerir un recorte
        # Excluimos gastos fijos vitales como vivienda, salud y deudas
        categorias_excluidas = ['VIVIENDA', 'SALUD', 'DEUDA', 'ALIMENTACION']
        gastos_variables = {k: v for k, v in resumen_gastos.items() if k.upper() not in categorias_excluidas}
        
        if gastos_variables:
            # Encontrar la categoría donde más gasta
            cat_fuga = max(gastos_variables, key=gastos_variables.get)
            gasto_actual = gastos_variables[cat_fuga]
            
            # Sugerir un recorte del 15%
            meta_reduccion = round(gasto_actual * 0.85, 2)
            ahorro_potencial = round(gasto_actual - meta_reduccion, 2)
            
            recetas.append({
                "tipo_alerta": "OPTIMIZACION",
                "categoria": "Control de Gastos",
                "titulo": f"Reto de recorte en {cat_fuga.capitalize()}",
                "accion_sugerida": f"Este mes gastaste ${gasto_actual} en {cat_fuga.capitalize()}. Tu reto es limitarte a ${meta_reduccion} el próximo mes. Esos ${ahorro_potencial} salvados mejorarán tu flujo."
            })

    elif perfil == 'EN_RIESGO':
        recetas.append({
            "tipo_alerta": "SUPERVIVENCIA",
            "categoria": "Contención",
            "titulo": "Congela los gastos variables",
            "accion_sugerida": "Tu liquidez está en riesgo. Elimina temporalmente cualquier gasto en las categorías de 'Ocio' y 'Servicios' no esenciales hasta recuperar la estabilidad."
        })
        
        # Validar si tiene un fondo de emergencia configurado
        if not meta_activa or meta_activa.get('nombre', '').lower() != 'fondo de emergencia':
            recetas.append({
                "tipo_alerta": "CRITICA",
                "categoria": "Prevención",
                "titulo": "Prioridad de Supervivencia",
                "accion_sugerida": "Es urgente que crees una Meta Financiera llamada 'Fondo de emergencia'. Fija un objetivo inicial modesto, como $500, para evitar recurrir a deudas ante imprevistos."
            })

    # ---------------------------------------------------------
    # 3. EMPAQUETADO PARA LA BASE DE DATOS (JSONB)
    # ---------------------------------------------------------
    documento_recomendaciones = {
        "total_recomendaciones": len(recetas),
        "recetas": recetas
    }
    
    return json.dumps(documento_recomendaciones, ensure_ascii=False, indent=4)

# ==========================================
# EJEMPLO DE USO 1: Usuario "En Riesgo"
# ==========================================
usuario_riesgo = {
    "ingreso_mensual": 1000.00,
    "perfil_financiero": "EN_RIESGO",
    "nivel_endeudamiento": 45.0 # Porcentaje
}

resumen_riesgo = {
    "VIVIENDA": 400.0,
    "ALIMENTACION": 300.0,
    "OCIO": 150.0,
    "DEUDA": 250.0
}

meta_riesgo = {
    "nombre": "Comprar consola",
    "estado": "Activa"
}

json_resultado_riesgo = generar_recetas_financieras(usuario_riesgo, resumen_riesgo, meta_riesgo)

print("--- RESULTADO PARA USUARIO EN RIESGO ---")
print(json_resultado_riesgo)


# ==========================================
# EJEMPLO DE USO 2: Usuario "En Observación"
# ==========================================
usuario_obs = {
    "ingreso_mensual": 2000.00,
    "perfil_financiero": "EN_OBSERVACION",
    "nivel_endeudamiento": 15.0
}

# Aquí detectará que gasta mucho en Ocio
resumen_obs = {
    "VIVIENDA": 600.0,
    "ALIMENTACION": 400.0,
    "OCIO": 350.0,
    "TRANSPORTE": 150.0
}

json_resultado_obs = generar_recetas_financieras(usuario_obs, resumen_obs, None)

print("\n--- RESULTADO PARA USUARIO EN OBSERVACIÓN ---")
print(json_resultado_obs)