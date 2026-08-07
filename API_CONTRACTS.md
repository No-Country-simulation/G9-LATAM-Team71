# Documentación de Endpoints y Contratos JSON

## Códigos HTTP Estándar
* **200 OK:** Éxito en lectura (`GET`) o actualización.
* **201 Created:** Registro creado exitosamente (`POST`).
* **400 Bad Request:** Error de validación (JSON mal formado).
* **401 Unauthorized:** Token JWT ausente o inválido.
* **500 Internal Error:** Falla en el servidor (Java o Python).

## Contratos para los JSON
En este apartado se encuentran las reglas que se deben de cumplir para mantener el orden adecuado para el uso de JSONS

**Tipos de datos (Montos Monetarios):** 
Los valores financieros (`monto`, `valor`, `total_ingresos`, `monto_objetivo`) siempre deben enviarse y recibirse como valores numéricos (`float`).

**Estandarización de fechas**
Toda fecha que se maneja en los JSON debe respetar el formato (`YYYY/MM/DD`).

**Manejo de espacios y formato**
Para que el modelo predictivo y las reglas de negocio funcionen, las claves del JSON que agrupan varias palabras se deberá usar la nomenclatura de `snake_case` junto con las palabras en minúsculas.

**Enumerados y claves**
Las claves del JSON (enumerados) a usar son los siguientes:
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
  Es importante respetar el uso de mayúsculas y el formato de `snake_case`.

**Manejo de Nulos**
Para evitar excepciones por valores nulos se debe considerar que si un dato no existe se debe omitir en el JSON, o enviarse explícitamente como nulo de forma controlada. Nunca se deberán enviar objetos vacíos o en forma de texto.

## Entorno local
La URL inicial a la que se le añadirán los controladores es la siguiente
    ```
    http://localhost:8080/api/v1
    ```
    
### Autenticación (Login)
* **Frontend Controller:** `AuthService.login()`
* **Backend Endpoint:** `POST /api/v1/auth/login`
* **Request:**
  ```json
  {
    "correo": "usuario@ejemplo.com",
    "contrasena": "Secreta123!"
  }
  ```
* **Response (200 OK):**
  ```json
  {
    "token_acceso": "eyJhbGciOiJIUzI1NiIsInR...",
    "tipo_token": "Bearer",
    "usuario": {
      "id_usuario": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "nombre": "Carlos",
      "correo": "usuario@ejemplo.com"
    }
  }
  ```

  #### Iniciar el Dashboard
Carga la información principal del usuario y sus transacciones recientes (últimos 7 días). Todo se consolida en un solo endpoint para evitar latencias en la app.

* **Frontend Controller:** `DashboardService.getDashboardData()`
* **Backend Endpoint:** `GET /api/v1/analisis/dashboard`
* **Headers:** `Authorization: Bearer <token>`
* **Response (200 OK):**
  ```json
  {
    "usuario": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "nombre": "Carlos",
      "apellido": "Pérez",
      "correo": "usuario@ejemplo.com",
    },
    "analisis": {
      "dinero_disponible": 27000.00,
      "perfil_financiero": "EN_OBSERVACION",
      "nivel_endeudamiento": 15.50,
      "ingreso_mensual": 4500.00,
      "transacciones_del_mes": [
        {
          "id": "123e4567-e89b-12d3-a456-426614174000",
          "descripcion": "Supermercado",
          "monto": 420.00,
          "fecha": "2026-08-01T14:30:00",
          "tipo_flujo": "EGRESO",
          "cualidad_flujo": "VARIABLE",
          "categoria": "ALIMENTACION"
        }
      ],
      "recomendaciones": [
        "Monitorear los gastos recurrentes de entretenimiento",
        "Considera ahorrar un poco más en Ocio."
      ]
    },
    "metas_activas": [
      {
        "id_meta": 42,
        "nombre_meta": "Fondo de Emergencia",
        "monto_objetivo": 20000.00,
        "monto_actual": 5000.00,
        "progreso_porcentaje": 25.0
      },
      {
        "id_meta": 45,
        "nombre_meta": "Laptop Nueva",
        "monto_objetivo": 15000.00,
        "monto_actual": 15000.00,
        "progreso_porcentaje": 100.0
      }
    ]
  }
  ```

### Realizar Predicción (Fase 1 del registro de transacción)
El usuario captura un gasto. Flutter envía la información al backend para validar, el backend la reenvía a Python (`ClasificacionController`) para proponer una clasificación, y se le regresa a Flutter para que el usuario la confirme en la ventana emergente.

* **Frontend Controller:** `TransactionService.predictTransaction()`
* **Backend Endpoint:** `POST /api/v1/transacciones/predecir`
* **Request:**
  ```json
  {
    "tipo_flujo": "EGRESO",
    "monto": 420.00,
    "descripcion": "Walmart Despensa"
  }
  ```
* **Response (200 OK):**
  ```json
  {
    "tipo_flujo": "EGRESO",
    "monto": 420.00,
    "descripcion": "Walmart Despensa",
    "prediccion": {
      "categoria": "ALIMENTACION",
      "cualidad": "VARIABLE"
    }
  }
  ```

### Guardar Transacción (Fase 2 del registro de transacción)
El usuario confirma la predicción (o modifica datos manualmente en pantalla) y presiona guardar.

* **Frontend Controller:** `TransactionService.saveTransaction()`
* **Backend Endpoint:** `POST /api/v1/transacciones`
* **Request:**
  ```json
  {
    "tipo_flujo": "EGRESO",
    "cualidad_flujo": "VARIABLE",
    "categoria": "ALIMENTACION",
    "fecha": "2026-08-07T12:00:00",
    "monto": 420.00,
    "descripcion": "Walmart Despensa"
  }
  ```
* **Response (201 Created):**
  ```json
  {
    "id_transaccion": "123e4567-e89b-12d3-a456-426614174000",
    "mensaje": "Transacción registrada exitosamente."
  }
  ```

### Registrar Metas Financiera
Crea una meta financiera nueva en la base de datos.

* **Frontend Controller:** `GoalService.createGoal()`
* **Backend Endpoint:** `POST /api/v1/metas`
* **Request:**
  ```json
  {
    "nombre": "Comprar Laptop",
    "monto_objetivo": 15000.00,
    "fecha_limite": "2027-02-15",
    "estado": "ACTIVA"
  }
  ```
* **Response (201 Created):**
  ```json
  {
    "id_meta": "8a2deb4d-5c7e-4bad-9bdd-3b0d7b3dcb6a",
    "estado": "ACTIVA",
    "mensaje": "Meta registrada exitosamente."
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
