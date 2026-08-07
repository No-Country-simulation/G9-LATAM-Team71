from pydantic import BaseModel
import joblib

#validacion de tipos de dato
class Transaccion(BaseModel):
    descripcion: str

#cargar modelo
modelo_categoria = joblib.load("models/categoria_champion.pkl")
modelo_cualidad = joblib.load("models/cualidad_champion.pkl")


def limpiar_texto(texto: str) -> str:
    return texto.lower().strip()


def clasificar(descripcion: str):

    descripcion = limpiar_texto(descripcion)

    categoria = modelo_categoria.predict([descripcion])[0]

    cualidad = modelo_cualidad.predict([descripcion])[0]

    return categoria, cualidad