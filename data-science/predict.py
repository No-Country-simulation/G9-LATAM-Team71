from pydantic import BaseModel
from datetime import date
import joblib
import pandas as pd

#cargar modelo
modelo_categoria = joblib.load("models/categoria_champion.pkl")
modelo_cualidad = joblib.load("models/cualidad_champion.pkl")

#validacion de tipos de dato
class TransaccionClasificacion(BaseModel):
    descripcion: str

#validacion de transaccion
class TransaccionAnalisis(BaseModel):
    fecha: date
    descripcion: str
    monto: float
    tipo: str
    categoria: str
    cualidad: str

#validacion de meta
class Meta(BaseModel):
    id_meta: int  # id de cada meta
    monto_objetivo: float
    fecha_inicio: date
    fecha_limite: date
    estado: str

#validacion de muchas transacciones
class DatosAnalisis(BaseModel):
    transacciones: list[TransaccionAnalisis]
    fecha_inicio: date
    fecha_fin: date
    meta: list[Meta]

def limpiar_texto(texto: str) -> str:
    return texto.lower().strip()


def clasificar(descripcion: str):

    descripcion = limpiar_texto(descripcion)

    categoria = modelo_categoria.predict([descripcion])[0]

    cualidad = modelo_cualidad.predict([descripcion])[0]

    return categoria, cualidad

#
# Periodo analisis
#

def seleccionar_periodo(data,fecha_inicio,fecha_fin):
    data = data.copy()

    data["fecha"] = pd.to_datetime(data["fecha"])

    return data[
        (data["fecha"] >= fecha_inicio) &
        (data["fecha"] <= fecha_fin)
    ]

#calcular varioacion actual y anterior
def calcular_variacion(actual, anterior):
    return actual - anterior

#
#indicadores 
#
def calcular_tasa_ahorro(data):

    ingresos = data[data["tipo"] == "INGRESO"]["monto"].sum()
    egresos = data[data["tipo"] == "EGRESO"]["monto"].sum()

    if ingresos == 0:
        return 0

    ahorro = ingresos - egresos

    return (ahorro / ingresos) * 100


def calcular_nivel_endeudamiento(data):

    ingresos = data[data["tipo"] == "INGRESO"]["monto"].sum()
    deudas = data[
        (data["tipo"] == "EGRESO") &
        (data["categoria"] == "Deudas")
    ]["monto"].sum()

    if ingresos == 0:
        return 0

    return (deudas / ingresos) * 100


def calcular_porcentaje_ingreso_gastado(data):

    ingresos = data[
        data["tipo"] == "INGRESO"
    ]["monto"].sum()

    egresos = data[
        data["tipo"] == "EGRESO"
    ]["monto"].sum()

    if ingresos == 0:
        return 0

    return (egresos / ingresos) * 100

def categoria_mayor_gasto(data):
    gastos_controlables = data[
        (data["tipo"] == "EGRESO") &
        (data["cualidad"] != "FIJO_VITAL")
    ]
    if gastos_controlables.empty:
        return {
        "categoria_mayor": None,
        "porcentaje_categoria": 0
    }

    gastos_categoria = (
        gastos_controlables
        .groupby("categoria")["monto"]
        .sum()
        .sort_values(ascending=False)
    )

    total_gastos = gastos_categoria.sum()

    categoria = gastos_categoria.index[0]

    porcentaje = (
        gastos_categoria.iloc[0] /
        total_gastos
    ) * 100

    return {
        "categoria_mayor": categoria,
        "porcentaje_categoria": porcentaje
    }

def gasto_promedio(data):
    # gasto_promedio
    gastos_controlables = data[                 #SEconsidera 
      (data["tipo"] == "EGRESO") &
      (data["cualidad"] != "FIJO_VITAL")
    ]
  
    return gastos_controlables["monto"].mean()

#
# Comparacion
#
def calcular_variacion(actual, anterior):

    return actual - anterior

def calcular_variacion_porcentual(actual, anterior):
    if anterior ==0:
        return None
    return ((actual - anterior)/anterior)*100

    
# perfil financiero
def clasificar_perfil(tasa_ahorro, nivel_endeudamiento, porcentaje_ingreso_gastado):

    if nivel_endeudamiento >= 40:
        perfil = "Endeudado"
        descripcion = "El usuario presenta un nivel elevado de endeudamiento."

    elif tasa_ahorro >= 20 and nivel_endeudamiento < 30:
        perfil = "Ahorrador"
        descripcion = "El usuario presenta una buena capacidad de ahorro y un nivel de endeudamiento controlado."

    elif porcentaje_ingreso_gastado >= 90:
        perfil = "Gasto elevado"
        descripcion = "La mayor parte de los ingresos del usuario se destina a gastos."

    else:
        perfil = "Equilibrado"
        descripcion = "El usuario mantiene un comportamiento financiero relativamente equilibrado."

    return {
        "perfil": perfil,
        "descripcion": descripcion
    }


#
#Recomendaciones
#
def recomendacion_ahorro(tasa_ahorro):

    if tasa_ahorro < 5:

        return {
            "tipo": "AHORRO",
            "prioridad": "ALTA",
            "mensaje": (
                "Tu capacidad de ahorro es baja. "
                "Considera revisar tus gastos variables "
                "para encontrar oportunidades de ahorro."
            )
        }

    elif tasa_ahorro < 15:

        return {
            "tipo": "AHORRO",
            "prioridad": "MEDIA",
            "mensaje": (
                "Tu tasa de ahorro podría mejorar. "
                "Considera establecer una cantidad fija "
                "para ahorrar cada mes."
            )
        }

    return None

def recomendacion_gastos(porcentaje_gastado):

    if porcentaje_gastado >= 95:

        return {
            "tipo": "GASTOS",
            "prioridad": "ALTA",
            "mensaje": (
                "La mayor parte de tus ingresos está siendo "
                "utilizada en gastos. Revisa especialmente "
                "tus gastos variables."
            )
        }

    elif porcentaje_gastado >= 85:

        return {
            "tipo": "GASTOS",
            "prioridad": "MEDIA",
            "mensaje": (
                "Tus gastos representan una proporción elevada "
                "de tus ingresos. Considera revisar tus gastos "
                "no esenciales."
            )
        }

    return None


def recomendacion_categoria(categoria, porcentaje):
    if porcentaje >= 40:

        return {
            "tipo": "GASTOS",
            "prioridad": "MEDIA",
            "mensaje": (
                f"{categoria} representa el {porcentaje:.1f}% "
                "de tus gastos. Revisa esta categoría para "
                "identificar posibles gastos que puedas reducir."
            )
        }

    return None


def recomendacion_deuda(nivel_endeudamiento):

    if nivel_endeudamiento >= 40:

        return {
            "tipo": "DEUDAS",
            "prioridad": "ALTA",
            "mensaje": (
                "Tu nivel de endeudamiento es elevado. "
                "Considera priorizar el pago de tus deudas "
                "antes de asumir nuevos compromisos."
            )
        }

    elif nivel_endeudamiento >= 30:

        return {
            "tipo": "DEUDAS",
            "prioridad": "MEDIA",
            "mensaje": (
                "Tu nivel de endeudamiento merece atención. "
                "Procura mantener bajo control tus nuevas "
                "obligaciones."
            )
        }

    return None


def recomendacion_variacion_gasto(variacion_porcentual):

    if variacion_porcentual is None:
        return None

    if variacion_porcentual >= 15:

        return {
            "tipo": "GASTOS",
            "prioridad": "ALTA",
            "mensaje": (
                f"Tus gastos aumentaron un "
                f"{variacion_porcentual:.1f}% respecto al "
                "período anterior. Revisa qué categorías "
                "contribuyeron a este incremento."
            )
        }

    return None

#
#Generar recomendaciones
#
def generar_recomendaciones(
    tasa_ahorro,
    porcentaje_gastado,
    categoria_mayor_gasto,
    porcentaje_categoria,
    nivel_endeudamiento,
    variacion_gasto
):

    recomendaciones = []

    recomendaciones_posibles = [

        recomendacion_ahorro(tasa_ahorro),

        recomendacion_gastos(porcentaje_gastado),

        recomendacion_categoria(
            categoria_mayor_gasto,
            porcentaje_categoria
        ),

        recomendacion_deuda(
            nivel_endeudamiento
        ),

        recomendacion_variacion_gasto(
            variacion_gasto
        )
    ]

    for recomendacion in recomendaciones_posibles:

        if recomendacion is not None:
            recomendaciones.append(recomendacion)

    return recomendaciones



def analizar(data, fecha_inicio, fecha_fin):
    #obtener rango de fecha para calculo
    fecha_inicio = pd.Timestamp(fecha_inicio)
    fecha_fin = pd.Timestamp(fecha_fin)

    data_actual = seleccionar_periodo(
        data,
        fecha_inicio,
        fecha_fin
    )

    #Anterior

    duracion = fecha_fin - fecha_inicio

    fecha_fin_anterior = (
        fecha_inicio - pd.Timedelta(days=1)
    )

    fecha_inicio_anterior = (
        fecha_fin_anterior - duracion
    )

    data_anterior = seleccionar_periodo(
        data,
        fecha_inicio_anterior,
        fecha_fin_anterior
    )

    tasa_ahorro_actual = calcular_tasa_ahorro(
        data_actual
    )

    nivel_endeudamiento_actual = calcular_nivel_endeudamiento(
        data_actual
    )

    porcentaje_gastado_actual = (
        calcular_porcentaje_ingreso_gastado(
            data_actual
        )
    )

    categoria_porcentaje_mayor_gasto_actual = (
        categoria_mayor_gasto(
            data_actual
        )
    )

    gasto_promedio_actual = gasto_promedio(
        data_actual
    )

    # 
    # Indicadores anteriores
    #

    tasa_ahorro_anterior = calcular_tasa_ahorro(
        data_anterior
    )

    nivel_endeudamiento_anterior = (
        calcular_nivel_endeudamiento(
            data_anterior
        )
    )

    gasto_promedio_anterior = (
        gasto_promedio(
            data_anterior
        )
    )

    porcentaje_gastado_anterior = (
        calcular_porcentaje_ingreso_gastado(
            data_anterior
        )
    )

    categoria_porcentaje_mayor_gasto_anterior = (
        categoria_mayor_gasto(
            data_anterior
        )
    )
    variacion_gasto = calcular_variacion(
        gasto_promedio_actual,
        gasto_promedio_anterior
    )

    variacion_gasto_porcentual = (calcular_variacion_porcentual(
        gasto_promedio_actual, gasto_promedio_anterior
        )
    )


    comparacion = {

        "tasa_ahorro": {
            "actual": tasa_ahorro_actual,
            "anterior": tasa_ahorro_anterior,
            "variacion": calcular_variacion(
                tasa_ahorro_actual,
                tasa_ahorro_anterior
            )
        },

        "nivel_endeudamiento": {
            "actual": nivel_endeudamiento_actual,
            "anterior": nivel_endeudamiento_anterior,
            "variacion": calcular_variacion(
                nivel_endeudamiento_actual,
                nivel_endeudamiento_anterior
            )
        },

        "porcentaje_ingreso_gastado": {
            "actual": porcentaje_gastado_actual,
            "anterior": porcentaje_gastado_anterior,
            "variacion": calcular_variacion(
                porcentaje_gastado_actual,
                porcentaje_gastado_anterior
            )
        },

        "gasto_promedio": {
            "actual": gasto_promedio_actual,
            "anterior": gasto_promedio_anterior,
            "variacion": variacion_gasto,
            "variacion_porcentual": variacion_gasto_porcentual
        },

        "categoria_mayor_gasto": {
            "actual": categoria_porcentaje_mayor_gasto_actual["categoria_mayor"],
            "anterior": categoria_porcentaje_mayor_gasto_anterior["categoria_mayor"],
            "cambio": (
                categoria_porcentaje_mayor_gasto_actual["categoria_mayor"]
                != categoria_porcentaje_mayor_gasto_anterior["categoria_mayor"]
            )
        }
    }

    # 
    # PERFIL
    #

    perfil = clasificar_perfil(
        tasa_ahorro_actual,
        nivel_endeudamiento_actual,
        porcentaje_gastado_actual
    )

    #
    # RECOMENDACIONES
    #

    recomendaciones = generar_recomendaciones(
        tasa_ahorro_actual,
        porcentaje_gastado_actual,
        categoria_porcentaje_mayor_gasto_actual["categoria_mayor"],
        categoria_porcentaje_mayor_gasto_actual["porcentaje_categoria"],
        nivel_endeudamiento_actual,
        variacion_gasto_porcentual
    )


    # 
    # RESULTADO
    #

    return {

        "periodo": {
            "inicio": fecha_inicio.date(),
            "fin": fecha_fin.date()
        },

        "indicadores": {

            "tasa_ahorro": tasa_ahorro_actual,

            "nivel_endeudamiento":
                nivel_endeudamiento_actual,

            "porcentaje_ingreso_gastado":
                porcentaje_gastado_actual,

            "categoria_mayor_gasto":
                categoria_porcentaje_mayor_gasto_actual["categoria_mayor"],

            "porcentaje_categoria_mayor_gasto":
                categoria_porcentaje_mayor_gasto_actual["porcentaje_categoria"],

            "gasto_promedio":
                gasto_promedio_actual
        },
        "comparacion_periodo_anterior":
            comparacion,

        "perfil_financiero":
            perfil,

        "recomendaciones":
            recomendaciones
    }

def calcular_meta(data, metas):
# 
    data = data.copy()

    data["fecha"] = pd.to_datetime(data["fecha"])

    # --------------------------------
    # SOLO TRANSACCIONES DE AHORRO
    # --------------------------------

    data_ahorro = data[
        data["categoria"].str.upper() == "AHORRO"
    ].copy()

    resultados = []

    # Fecha actual
    fecha_actual = pd.Timestamp.today().normalize()

    # --------------------------------
    # RECORRER CADA META
    # --------------------------------

    for meta in metas:

        id_meta = meta["id_meta"]
        monto_objetivo = meta["monto_objetivo"]
        fecha_inicio = pd.Timestamp(meta["fecha_inicio"])
        fecha_limite = pd.Timestamp(meta["fecha_limite"])

        # --------------------------------
        # TRANSACCIONES DE ESTA META
        # --------------------------------

        transacciones_meta = data_ahorro[
            data_ahorro["descripcion"].astype(str)
            == str(id_meta)
        ]

        # --------------------------------
        # MONTO ACTUAL
        # --------------------------------

        monto_actual = transacciones_meta["monto"].sum()

        # --------------------------------
        # PROGRESO
        # --------------------------------

        if monto_objetivo > 0:

            progreso = (
                monto_actual /
                monto_objetivo
            ) * 100

        else:

            progreso = 0

        # Evitar que muestre más de 100%
        progreso = min(progreso, 100)

        # --------------------------------
        # MONTO RESTANTE
        # --------------------------------

        monto_restante = max(
            monto_objetivo - monto_actual,
            0
        )

        # --------------------------------
        # MESES RESTANTES
        # --------------------------------

        if fecha_actual >= fecha_limite:

            meses_restantes = 0

        else:

            meses_restantes = (
                (fecha_limite.year - fecha_actual.year) * 12
                + (fecha_limite.month - fecha_actual.month)
            )

        # --------------------------------
        # AHORRO MENSUAL NECESARIO
        # --------------------------------

        if meses_restantes > 0:

            ahorro_mensual_necesario = (
                monto_restante /
                meses_restantes
            )

        else:

            ahorro_mensual_necesario = 0

        # --------------------------------
        # RESULTADO
        # --------------------------------

        resultados.append({

            "id_meta": id_meta,

            "monto_objetivo":
                monto_objetivo,

            "monto_actual":
                monto_actual,

            "monto_restante":
                monto_restante,

            "progreso":
                round(progreso, 2),

            "fecha_inicio":
                fecha_inicio.date(),

            "fecha_limite":
                fecha_limite.date(),

            "meses_restantes":
                meses_restantes,

            "ahorro_mensual_necesario":
                round(ahorro_mensual_necesario, 2)
        })

    return resultados

    }
print(f'''Meta: compra laptop, \nobjetivo: {monto_objetivo}\nahorrado: {monto_actual}
restante: {monto_objetivo - monto_actual}
ahorro promedio: {ahorro_promedio_mensual}
tiempo estimado: {meses_estimados.round()} meses''')

'''

meta id en la descripcion

LA transaccion es lo que usare

{
  "periodo": {
    "mes": 8,
    "año": 2026
  },

  "indicadores": {      # reporte financiero
    "tasa_ahorro": 20.5,
    "nivel_endeudamiento": 15.2,
    "porcentaje_ingreso_gastado": 79.5,
    "categoria_mayor_gasto": "Vivienda",
    "gasto_promedio_controlable": 562.50,
    "ahorro_promedio_mensual": 2300.00
  },

  "comparacion_periodo_anterior": {
    "tasa_ahorro": {
      "actual": 20.5,
      "anterior": 17.0,
      "variacion": 3.5
    },
    "nivel_endeudamiento": {
      "actual": 15.2,
      "anterior": 18.4,
      "variacion": -3.2
    },
    "porcentaje_ingreso_gastado": {
      "actual": 79.5,
      "anterior": 82.0,
      "variacion": -2.5
    },
    "gasto_promedio_controlable": {
      "actual": 562.50,
      "anterior": 620.00,
      "variacion": -9.27
    }
  },

  "patrones_consumo": [         # pedido del no country
    {
      "tipo": "mayor_gasto",        #gasto del periodo
      "descripcion": "La categoría con mayor gasto fue Vivienda.",
      "categoria": "Vivienda",
      "porcentaje": 45.3
    },
    {
      "tipo": "gasto_variable",
      "descripcion": "Una proporción considerable de los gastos corresponde a gastos variables.",
      "porcentaje": 38.7
    }
  ],

  "perfil_financiero": {
    "perfil": "Ahorrador",
    "descripcion": "El usuario presenta una buena capacidad de ahorro y un nivel de endeudamiento moderado."
  },
  "metas_financieras": [
    {
        "id": 1,
        "nombre": "Laptop",
        "monto_objetivo": 20000,
        "monto_actual": 6500,
        "monto_faltante": 13500,
        "progreso": 32.5,
        "ahorro_promedio_mensual": 2300,
        "meses_estimados": 5.87,                #suponiendo que el calculo de esto es mensual
        "fecha_objetivo": "2026-12-31",
        "estado": "EN_PROGRESO"
    },
    {
        "id": 2,
        "nombre": "Laptop",
        "monto_objetivo":40000,
        "monto_actual": 13000,
        "monto_faltante": 27000,
        "progreso": 12.5,
        "ahorro_promedio_mensual": 2300,
        "meses_estimados": 5.87,                #suponiendo que el calculo de esto es mensual
        "fecha_objetivo": "2026-12-31",
        "estado": "EN_PROGRESO"
    }
  ],
  "recomendaciones": [
    {
      "tipo": "AHORRO",
      "prioridad": "ALTA",
      "mensaje": "Tu tasa de ahorro podría mejorar. Considera reducir gastos variables."
    },
    {
      "tipo": "GASTOS",
      "prioridad": "MEDIA",
      "mensaje": "Vivienda representa una proporción importante de tus gastos."
    }
  ]
}
'''