from fastapi import FastAPI, APIRouter
from predict import clasificar, TransaccionClasificacion, DatosAnalisis, analizar, Meta,calcular_meta
import pandas as pd

app = FastAPI(
     title="API financiero"
)

from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi import Request
import traceback

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    print("VALIDATION ERROR:", exc.errors(), flush=True)
    print("BODY:", exc.body, flush=True)
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors(), "body": exc.body}
    )

router = APIRouter(prefix="/api/v1")

# controlador para el predecir la categoria
@router.post("/transacciones/predecir")
def clasificar_transaccion(dato: TransaccionClasificacion):
    categoria, cualidad = clasificar(dato.descripcion)
    return {
        "categoria": categoria,
        "cualidad": cualidad
    }

#Controlador para el reporte
@router.post("/analisis")
def analisis_financiero(datos: DatosAnalisis):
    data = pd.DataFrame([transacciones.model_dump(by_alias=True) for transacciones in datos.transacciones])
    return analizar(
        data, 
        datos.fecha_inicio,
        datos.fecha_fin,
        datos.metas
    )

app.include_router(router)