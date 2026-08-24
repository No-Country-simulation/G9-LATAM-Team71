# Documentación Extendida de API, Controladores y Contratos JSON

Este documento consolida la arquitectura de los controladores en todas las capas (Frontend, Backend, Data Science) y define los contratos JSON basados en los casos de uso principales. Toma como base la información de la base de datos, el flujo inicial de los JSON y las especificaciones de diseño.

---

## 1. Estándares Globales

* **Códigos HTTP:**
  * `200 OK`: Éxito en lectura (`GET`) o actualización.
  * `201 Created`: Registro creado exitosamente (`POST`).
  * `400 Bad Request`: Error de validación (JSON mal formado).
  * `401 Unauthorized`: Token JWT ausente o inválido.
  * `500 Internal Error`: Falla en el servidor (Base de datos, Java o Python).
* **Tipos de Datos:** Valores financieros (`monto`, `ingreso_mensual`, `monto_objetivo`, `nivel_endeudamiento`) siempre se envían como numéricos (`float`/`decimal`).
* **Fechas:** Formato estándar `YYYY-MM-DD` o `YYYY-MM-DDTHH:mm:ss` para transacciones específicas.
* **Manejo de Nulos:** Omitir la clave si el valor es nulo, o enviarlo explícitamente como `null`. No enviar strings u objetos vacíos.
* **Formato de Claves:** `snake_case` y en minúsculas.
* **Enumeradores Principales:**
  * `Categorias`: ALIMENTACION, TRANSPORTE, SALUD, VIVIENDA, EDUCACION, OCIO, SERVICIOS, OTROS.
  * `Tipo_flujo`: INGRESO, EGRESO.
  * `Cualidad_flujo`: FIJO_VITAL, FIJO_NO_VITAL, VARIABLE (para EGRESO). FIJO, VARIABLE (para INGRESO).

---

## 2. Mapa de Controladores (Arquitectura)

Para satisfacer los casos de uso, la comunicación y las responsabilidades se dividen en 3 ecosistemas principales.

### 2.1 Backend (Java / Spring Boot)
Actúa como director de orquesta y se conecta directamente a la Base de Datos (PostgreSQL).
* **`AuthController`**: Maneja la autenticación (Login) y el registro inicial.
* **`UsuarioController`**: Obtiene y actualiza la información del perfil del usuario logueado.
* **`TransaccionController`**: Gestiona el flujo doble de las transacciones (primero validar/predecir apoyándose en Python, luego guardar en la BD definitivamente).
* **`MetaController`**: Administra el CRUD de las metas.
* **`AnalisisController`**: Genera métricas complejas, gráficas y recomendaciones unificadas (combinando llamadas a Python y consultas propias) para alimentar el Dashboard y la Situación.

### 2.2 Data Science (Python / FastAPI)
Microservicio dedicado puramente al procesamiento de modelos y lógica de negocio predictiva. No se conecta a la base de datos directamente, solo es consultado por Java.
* **`ClasificacionController`**: Recibe datos crudos de un gasto y devuelve a qué categoría y cualidad predice que pertenece.
* **`PrediccionController`**: Analiza agrupaciones de datos de un usuario para evaluar el perfil financiero y dictaminar recomendaciones generales.

### 2.3 Frontend (Flutter / Dart)
Servicios (Repositories) que gestionan las peticiones HTTP y manejan el estado dentro de la aplicación móvil.
* **`AuthService`**: Login, registro y almacenamiento local seguro del Token JWT en el dispositivo.
* **`DashboardService`**: Consumo de la información agregada (perfil, transacciones recientes) para mostrar en la pantalla inicial.
* **`TransactionService`**: Controla el formulario y el flujo en dos pasos de los gastos (Enviar datos a predecir -> Mostrar PopUp de IA -> Guardar definitivamente).
* **`GoalService`**: Comunicación con el Backend para traer y enviar información de la pantalla de Metas.
* **`SituationService`**: Petición de métricas agrupadas para las gráficas (`fl_chart`) y consejos.

---

## 3. Casos de Uso y Contratos JSON

### CASO 0: Autenticación (Login)
Requerido antes de cualquier otra acción en la aplicación.

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

---

### CASO 1: Pantalla Dashboard

#### A. Iniciar el Dashboard
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
      "ingreso_mensual": 4500.00,
      "perfil_financiero": "SALUDABLE",
      "nivel_endeudamiento": 15.50
    },
    "recomendaciones": [
      "Buen control de gastos esta semana.",
      "Considera ahorrar un poco más en Ocio."
    ],
    "transacciones_recientes": [
      {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "tipo_flujo": "EGRESO",
        "cualidad_flujo": "VARIABLE",
        "categoria": "ALIMENTACION",
        "fecha": "2026-08-01T14:30:00",
        "monto": 420.00,
        "descripcion": "Supermercado"
      }
    ]
  }
  ```

#### B. Realizar Predicción (Fase 1 del Gasto)
El usuario captura un gasto. Flutter envía la información al backend, el backend la reenvía a Python (`ClasificacionController`) para proponer una clasificación, y se le regresa a Flutter para que el usuario la confirme en la ventana emergente.

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

#### C. Guardar Transacción (Fase 2 del Gasto)
El usuario confirma la predicción (o modifica datos manualmente en la UI) y presiona guardar.

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

---

### CASO 2: Pantalla de Metas

#### A. Cargar Metas
Devuelve el listado completo de metas activas del usuario logueado en base a su Token.

* **Frontend Controller:** `GoalService.getGoals()`
* **Backend Endpoint:** `GET /api/v1/metas`
* **Response (200 OK):**
  ```json
  [
    {
      "id": "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
      "nombre": "Fondo de emergencia",
      "monto_objetivo": 20000.00,
      "monto_actual": 5000.00,
      "fecha_limite": "2026-12-31",
      "estado": "ACTIVA"
    }
  ]
  ```

#### B. Registrar Meta
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

---

### CASO 3: Pantalla de Situación Financiera

#### A. Cargar Situación
Esta pantalla obtiene métricas detalladas y la composición matemática del gasto para rellenar los `fl_chart` (gráficas de pastel, barras). 

* **Frontend Controller:** `SituationService.getFinancialSituation()`
* **Backend Endpoint:** `GET /api/v1/analisis/situacion`
* **Response (200 OK):**
  ```json
  {
    "resumen_semanal": {
      "total_ingresos": 0.00,
      "total_gastos": 1250.00
    },
    "distribucion_categorias": {
      "ALIMENTACION": 800.00,
      "TRANSPORTE": 200.00,
      "OCIO": 250.00
    },
    "distribucion_cualidades": {
      "FIJO_VITAL": 200.00,
      "FIJO_NO_VITAL": 250.00,
      "VARIABLE": 800.00
    },
    "recomendaciones": [
      "Tus gastos VARIABLES superan tu promedio. Intenta reducirlos la próxima semana.",
      "El gasto en OCIO representa un 20% de tus salidas de esta semana."
    ]
  }
  ```

---

### Respuesta Global de Errores
Cualquier falla lógica (JSON malo, datos fuera de rango) devolverá un bloque estandarizado. Manejado por `@ControllerAdvice` en Spring Boot.

* **Response (400 / 401 / 500):**
  ```json
  {
    "error": true,
    "codigo": "ERROR_VALIDACION",
    "mensaje": "El monto de la meta no puede ser un valor negativo."
  }
  ```
