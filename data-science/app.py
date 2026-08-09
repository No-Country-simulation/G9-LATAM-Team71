from fastapi import FastAPI
from predict import clasificar, Transaccion
# from schemas import Transaccion

app = FastAPI(
     title="API financiero"
)
    
@app.post("/clasificar")
def clasificar_transaccion(dato: Transaccion):
    categoria, cualidad = clasificar(dato.descripcion)
    return {
        "categoria": categoria,
        "cualidad": cualidad
    }
