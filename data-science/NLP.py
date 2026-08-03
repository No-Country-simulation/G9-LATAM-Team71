import pandas as pd
import re
import joblib
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, accuracy_score


# 1. Cargar los datos
# Asegúrate de que el archivo CSV esté en el mismo directorio que este script
df = pd.read_csv("financeai_datos_entrenamiento.csv")

# 2. Limpieza básica de texto
# Esto ayuda a estandarizar descripciones (ej. "Uber", "UBER", "uber!!!")
def limpiar_texto(texto):
    if not isinstance(texto, str):
        return ""
    texto = texto.lower() # Convertir a minúsculas
    texto = re.sub(r'[^\w\s]', '', texto) # Eliminar puntuación
    texto = re.sub(r'\d+', '', texto) # (Opcional) Eliminar números
    return texto.strip()

# Aplicar la limpieza a la columna de descripciones
df['descripcion_limpia'] = df['descripcion'].apply(limpiar_texto)

# 3. Separar los datos (Features y Target)
X = df['descripcion_limpia']
y = df['categoria']

# Dividir en conjunto de entrenamiento (80%) y prueba (20%)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# 4. Construir el Pipeline
# El Pipeline ejecuta los pasos en orden. Primero vectoriza el texto, luego clasifica.
modelo_nlp = Pipeline([
    # TfidfVectorizer convierte el texto en una matriz numérica basada en la frecuencia de las palabras
    ('vectorizador', TfidfVectorizer(ngram_range=(1, 2), max_features=5000)), 
    # RandomForest es un modelo robusto que maneja muy bien este tipo de clasificaciones
    ('clasificador', RandomForestClassifier(n_estimators=100, random_state=42))
])

# 5. Entrenar el modelo
print("Entrenando el modelo...")
modelo_nlp.fit(X_train, y_train)

# 6. Evaluar el rendimiento
y_pred = modelo_nlp.predict(X_test)
print("\n--- Resultados de la Evaluación ---")
print(f"Precisión (Accuracy): {accuracy_score(y_test, y_pred):.2f}\n")
print("Reporte de Clasificación:")
print(classification_report(y_test, y_pred))

# 7. Serializar y guardar el modelo (Para el despliegue de la API y OCI)
ruta_modelo = "modelo_clasificador_transacciones.joblib"
joblib.dump(modelo_nlp, ruta_modelo)
print(f"\nModelo guardado exitosamente como: {ruta_modelo}")

# 8. Prueba de Inferencia Rápida (Cómo lo usaría tu API)
# Simulamos un JSON entrante con nuevas transacciones
nuevas_transacciones = [
    "Uber viaje al trabajo",
    "Compra en Supermercado Walmart",
    "Pago de Netflix y Spotify",
    "Consulta medica cardiologo"
]

# Limpiamos las nuevas entradas usando la misma función
transacciones_limpias = [limpiar_texto(t) for t in nuevas_transacciones]

# Hacemos la predicción cargando el modelo (como lo haría el backend)
modelo_cargado = joblib.load(ruta_modelo)
predicciones = modelo_cargado.predict(transacciones_limpias)

print("\n--- Prueba de Inferencia (API) ---")
for transaccion, categoria in zip(nuevas_transacciones, predicciones):
    print(f"Transacción: '{transaccion}' -> Categoría asignada: {categoria}")