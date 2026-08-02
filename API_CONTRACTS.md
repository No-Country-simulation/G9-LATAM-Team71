## Documentación de Endpoints y Contratos JSON

### Códigos HTTP Estándar
* **200 OK:** Éxito en lectura (`GET`) o actualización.
* **201 Created:** Registro creado exitosamente (`POST`).
* **400 Bad Request:** Error de validación (JSON mal formado).
* **401 Unauthorized:** Token JWT ausente o inválido.
* **500 Internal Error:** Falla en el servidor (Java o Python).

### Contratos para los JSON
Hay una serie de reglas que se deben de cumplir para mantener el orden adecuado para el uso de JSONS

**Tipos de datos (Montos Monetarios):** 
Los valores financieros (`monto`, `valor`, `total_ingresos`, `monto_objetivo`) siempre deben enviarse y recibirse como valores numéricos (`float`).

**Estandarización de fechas**
Toda fecha que se maneja en los JSON debe respetar el formato (`YYYY/MM/DD`).

**Manejo de espacios y formato**
Para que el modelo predictivo y las reglas de negocio funcionen, las claves del JSON que agrupan varias palabras se deberá usar la nomenclatura de `snake_case` junto con las palabras en mayúsculas. 

Los enumerados a usar son los siguientes
  ```
    Categorías
  ALIMENTACION
  TRANSPORTE
  SALUD
  VIVIENDA
  EDUCACION
  OCIO
  SERVICIOS
  DEUDAS
  
    Tipo
  INGRESO
  EGRESO  
  
    Cualidad
  FIJO_VITAL
  FIJO_NO_VITAL
  VARIABLE

    #En el caso de los "INGRESOS" se usarán lo siguiente:
  FIJO
  VARIABLE
  ```

**Manejo de Nulos**
Para evitar excepciones por valores nulos se debe considerar que si un dato no existe se debe omitir en el JSON, o enviarse explícitamente como nulo de forma controlada. Nunca se deberán enviar objetos vacíos o en forma de texto.

### Entorno local
La URL inicial a la que se le añadirán los controladores es la siguiente
    ```
    http://localhost:8080/api/v1
    ```
    
### Autenticación (Login)
* **Endpoint:** `POST /api/v1/auth/login`
* **Request:**
    ```json
    {
      "correo": "usuario@ejemplo.com",
      "contrasena": "Secreta123!" 
    }
    ```
  En la parte del correo se verificará que tenga el formato válido de correo electrónico; por la parte de la contraseña no se aceptarán valores nulos o solo espacios.
* **Response (200 OK):**
    ```json
    {
      "token_acceso": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "tipo_token": "Bearer",
      "expira_en_segundos": 3600,
      "usuario": {
        "id_usuario": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
        "nombre": "Carlos"
      }
    }
    ```

### Registro de Metas Financieras
* **Endpoint:** `POST /api/v1/metas`
* **Headers:** `Authorization: Bearer <token>`
* **Request:**
    ```json
    {
      "nombre": "Fondo de emergencia",
      "monto_objetivo": 20000.00,
      "fecha_limite": "2026-12-31"
    }
    ```
  No se deben aceptar valores vacíos en ningún campo.
* **Response (201 Created):**
    ```json
    {
      "id_meta": "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
      "estado": "ACTIVA", 
      "mensaje": "Meta registrada exitosamente.",
      "progreso_inicial_porcentaje": 0.0
    }
    ```

### Registro de Transacciones
Recibe una transacción. El Back-End guarda el registro y consulta al microservicio de Python para su categorización.
* **Endpoint:** `POST /api/v1/transacciones`
* **Headers:** `Authorization: Bearer <token>`
* **Request:**
    ```json
    {
      "tipo_flujo": "EGRESO",
      "monto": 420.00,
      "fecha": "2026-07-21",
      "descripcion": "Compra en supermercado"
    }
    ```
    No se deben aceptar valores vacíos en ningún campo.
* **Response (201 Created):**
    ```json
    {
      "id_transaccion": "123e4567-e89b-12d3-a456-426614174000",
      "mensaje": "Transacción registrada y clasificada correctamente.",
      "clasificacion_ia": {
        "categoria": "Alimentación",
        "cualidad": "VARIABLE"
      }
    }
    ```

### Análisis y Reporte Financiero
Devuelve el análisis consolidado, separando los gastos por categoría temática y comportamiento. Ideal para el Dashboard o envíos periódicos.
* **Endpoint:** `GET /api/v1/reportes/ultimo`
* **Headers:** `Authorization: Bearer <token>`
* **Response (200 OK):**
    ```json
    {
      "perfil_financiero": "EN_OBSERVACION",
      "resumen_gastos_por_categoria": {
        "Alimentación": 420,
        "Transporte": 300,
        "Ocio": 40
      },
      "analisis_comportamiento": {
        "total_ingresos": 4500,
        "fijo_vital": 300, 
        "fijo_no_vital": 40,
        "variable": 420
      },
      "recomendaciones": [
        "Detectamos $40 en suscripciones FIJO_NO_VITAL recurrentes; cancelarlas acelerará tu meta de ahorro.",
        "Tus gastos VARIABLE representan un porcentaje sano de tus ingresos."
      ]
    }
    ```

### Respuesta Global de Errores (Ejemplo)
Cualquier falla en los endpoints anteriores devolverá esta estructura estandarizada:
* **Response (400 / 401 / 500):**
    ```json
    {
      "error": true,
      "codigo": "ERROR_VALIDACION",
      "mensaje": "El monto de la meta no puede ser un valor negativo."
    }
    ```
