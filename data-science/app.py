from fastapi import FastAPI
from predict import clasificar, TransaccionClasificacion, DatosAnalisis, analizar, Meta,calcular_meta
import pandas as pd
# from schemas import Transaccion

app = FastAPI(
     title="API financiero"
)
    
@app.post("/clasificar")                        # controlador para el modelo
def clasificar_transaccion(dato: TransaccionClasificacion):
    categoria, cualidad = clasificar(dato.descripcion)
    return {
        "categoria": categoria,
        "cualidad": cualidad
    }
@app.post("/analizar")
def analisis_financiero(datos: DatosAnalisis):
    data = pd.DataFrame([transacciones.model_dump for transacciones in datos.transacciones])
    return analizar(
        data, 
        datos.fecha_inicio,
        datos.fecha_fin,
        datos.metas
    )

#faltan controladores
# @app.post("/metas")
# def endpoint_metas(datos: Meta):

#     data = pd.DataFrame(
#         [t.model_dump() for t in datos.transacciones]
#     )

#     metas = [
#         m.model_dump()
#         for m in datos.metas
#     ]

#     return calcular_meta(
#         data,
#         metas
#     )