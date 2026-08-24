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

### Configuración Inicial de Perfil
Permite actualizar la información inicial del usuario (ingreso mensual, nivel de endeudamiento y frecuencia de ahorro) para que el Dashboard y las Metas puedan realizar cálculos correctos. Es llamado cuando el ingreso mensual está en 0.

* **Frontend Controller:** `ApiService.actualizarPerfil()`
* **Backend Endpoint:** `PUT /api/v1/usuarios/perfil`
* **Headers:** 
  * `Authorization: Bearer <token>`
  * `Usuario-ID: <uuid>`
* **Request:**
  ```json
  {
    "ingresoMensual": 15000.0,
    "nivelEndeudamiento": 2000.0,
    "frecuenciaAhorro": "MENSUAL"
  }
  ```
* **Response (200 OK):** *(Sin cuerpo)*

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

### Aportar a Meta Financiera
Añade dinero a una meta financiera existente. Automáticamente genera una transacción de egreso con categoría `AHORRO` descontándolo del dinero disponible. Si se alcanza el monto objetivo, la meta cambia su estado a `COMPLETADA`.

* **Frontend Controller:** `GoalService.addFunds()`
* **Backend Endpoint:** `POST /api/v1/metas/{id_meta}/aportar`
* **Request:**
  ```json
  {
    "monto_aporte": 500.00
  }
  ```
* **Response (200 OK):**
  ```json
  {
    "id_meta": "8a2deb4d-5c7e-4bad-9bdd-3b0d7b3dcb6a",
    "monto_actual": 5500.00,
    "porcentaje_avance": 36.66,
    "estado": "ACTIVA",
    "mensaje": "Aporte registrado correctamente.",
    "id_transaccion_generada": "e89b-12d3-a456-426614174000"
  }
  ```


### Análisis y Reporte Financiero (Histórico)
Devuelve el último análisis financiero generado para el usuario por el motor de Python, estructurado y persistido en formato JSONB. Ideal para la vista detallada de finanzas.
* **Endpoint:** `GET /api/v1/analisis/ultimo`
* **Headers:** `Authorization: Bearer <token>`
* **Response (200 OK):**
  ```json
  {
    "periodo": {
      "inicio": "2026-08-01",
      "fin": "2026-08-31"
    },
    "indicadores": {
      "tasa_ahorro": 18.5,
      "nivel_endeudamiento": 12.3,
      "porcentaje_ingreso_gastado": 76.4,
      "categoria_mayor_gasto": "OCIO",
      "porcentaje_categoria_mayor_gasto": 35.2,
      "gasto_promedio": 850.0
    },
    "comparacion_periodo_anterior": {
      "tasa_ahorro": { "actual": 18.5, "anterior": 15.2, "variacion": 3.3 },
      "nivel_endeudamiento": { "actual": 12.3, "anterior": 14.8, "variacion": -2.5 },
      "porcentaje_ingreso_gastado": { "actual": 76.4, "anterior": 81.2, "variacion": -4.8 },
      "gasto_promedio_controlable": { "actual": 620.0, "anterior": 540.0, "variacion": 80.0, "variacion_porcentual": 14.81 },
      "gasto_promedio": { "actual": 850.0, "anterior": 790.0, "variacion": 60.0, "variacion_porcentual": 7.59 },
      "categoria_mayor_gasto": { "actual": "OCIO", "anterior": "TRANSPORTE", "cambio": true }
    },
    "perfil_financiero": {
      "perfil": "Ahorrador",
      "descripcion": "El usuario presenta una buena capacidad de ahorro y un nivel de endeudamiento controlado."
    },
    "recomendaciones": [
      {
        "tipo": "GASTOS",
        "prioridad": "MEDIA",
        "mensaje": "Tus gastos controlables aumentaron un 14.8% respecto al período anterior."
      }
    ],
    "metas": [
      {
        "nombre_meta": "Fondo de Emergencia",
        "monto_objetivo": 12000.0,
        "monto_actual": 7500.0,
        "monto_restante": 4500.0,
        "progreso": "62.25%",
        "ahorro_mensual_necesario": 1500.0,
        "fecha_inicio": "2026-06-01",
        "fecha_limite": "2026-12-31"
      }
    ]
  }
  ```

### Generación Manual de Análisis Financiero
Fuerza al motor a procesar las transacciones y metas actuales del usuario para generar un nuevo registro histórico en base de datos.
* **Endpoint:** `POST /api/v1/analisis/generar`
* **Headers:** `Authorization: Bearer <token>`
* **Response (200 OK):** *(Sin cuerpo)*

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

## API Interna: Comunicación Backend (Java) -> Data Science (Python)
Esta sección describe los contratos de los endpoints expuestos por el microservicio de Python, los cuales son consumidos internamente por el Backend en Java. El Frontend de Flutter NO debe interactuar directamente con estos endpoints.

### 1. Motor de Clasificación de Transacciones
Endpoint encargado de predecir la categoría y cualidad de un gasto con base en su descripción.
* **Backend Endpoint (Python):** `POST /transacciones/predecir`
* **Request (Enviado por Java):**
  ```json
  {
    "tipo_flujo": "EGRESO",
    "monto": 420.00,
    "descripcion": "Walmart Despensa"
  }
  ```
* **Response (Devuelto a Java):**
  ```json
  {
    "categoria": "ALIMENTACION",
    "cualidad": "VARIABLE"
  }
  ```

### 2. Motor de Análisis y Perfilamiento Financiero
Endpoint que recibe el historial mensual del usuario y retorna un análisis profundo, indicadores y recomendaciones personalizadas.
* **Backend Endpoint (Python):** `POST /analisis`
* **Request (Enviado por Java):**
  ```json
  {
    "fecha_inicio": "2026-08-01T00:00:00",
    "fecha_fin": "2026-08-31T23:59:59",
    "transacciones": [
      {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "fecha": "2026-08-07T12:00:00",
        "descripcion": "Walmart Despensa",
        "monto": 420.00,
        "tipo_flujo": "EGRESO",
        "cualidad_flujo": "VARIABLE",
        "categoria": "ALIMENTACION"
      }
    ],
    "metas": [
      {
        "id_meta": "8a2deb4d-5c7e-4bad-9bdd-3b0d7b3dcb6a",
        "nombre_meta": "Comprar Laptop",
        "monto_objetivo": 15000.0,
        "monto_actual": 0.0,
        "fecha_inicio": "2026-08-01T00:00:00",
        "fecha_limite": "2027-02-15T00:00:00",
        "estado": "ACTIVA"
      }
    ]
  }
  ```
* **Response (Devuelto a Java):**
*(El Response es el mismo JSON hiper-detallado de Análisis y Reporte Financiero documentado en la sección anterior, que incluye `periodo`, `indicadores`, `comparacion_periodo_anterior`, `perfil_financiero`, `recomendaciones` y `metas`).*

