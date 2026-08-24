# Imagen base de Python 3.11
FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo de dependencias (requirements.txt)
COPY requirements.txt .

# Librerías (Pandas, Scikit-Learn, FastAPI, etc.)
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código fuente del modelo
COPY . .

# Exponer el puerto de la API de Python
EXPOSE 5000

# Comando para iniciar el servidor (Ejemplo usando Uvicorn para FastAPI)
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "5000"]