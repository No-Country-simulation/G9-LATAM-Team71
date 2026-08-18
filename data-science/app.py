from fastapi import FastAPI
from predict import clasificar, TransaccionClasificacion, DatosAnalisis, analizar, Meta,calcular_meta
import pandas as pd
# from schemas import Transaccion

app = FastAPI(
     title="API financiero"
)

# controlador para el predecir la categoria
@app.post("/api/v1/transacciones/predecir")
def clasificar_transaccion(dato: TransaccionClasificacion):
    categoria, cualidad = clasificar(dato.descripcion)
    return {
        "categoria": categoria,
        "cualidad": cualidad
    }

#Controlador para el reporte
@app.post("/api/v1/reportes/ultimo")
def analisis_financiero(datos: DatosAnalisis):
    data = pd.DataFrame([transacciones.model_dump for transacciones in datos.transacciones])
    return analizar(
        data, 
        datos.fecha_inicio,
        datos.fecha_fin
    )

#faltan controladores
@app.post("/metas")
def endpoint_metas(datos: Meta):

    data = pd.DataFrame(
        [t.model_dump() for t in datos.transacciones]
    )

    metas = [
        m.model_dump()
        for m in datos.metas
    ]

    return calcular_meta(
        data,
        metas
    )