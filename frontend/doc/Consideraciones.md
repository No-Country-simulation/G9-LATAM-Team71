### Resolviendo tus dudas técnicas (Arquitectura y Flujo)

**1. ¿La información del usuario se guarda al iniciar o se pide en cada pantalla?**

* **Respuesta objetiva:** **No le pidas los datos al backend en cada pantalla.** Eso saturará tu servidor y hará que la app se sienta lenta (latencia).
* **La mejor práctica:** En Flutter, utiliza un manejador de estados (como **Provider, Riverpod o BLoC**). Cuando el usuario hace Login, el backend debe devolver un token y un resumen del usuario. Flutter guarda esto en memoria local. Solo vas a pedir datos al backend cuando haya un cambio real (ej. registrar un nuevo gasto) o cuando necesites una lista muy larga que no cargaste al inicio (usando paginación).

**2. ¿El frontend puede decidir qué mostrar de un JSON?**

* **Respuesta objetiva:** **Sí, y así debe ser (Separación de responsabilidades).**
* **La mejor práctica:** El backend manda el objeto completo (ID, nombre, monto, fecha, categoría, notas). Flutter recibe ese JSON, lo convierte a un modelo de Dart, y en el diseño (UI) tú decides imprimir solo el nombre y el monto. No crees un endpoint en Java para cada diseño de pantalla diferente; el backend sirve datos puros, el frontend decide cómo pintarlos.

**3. ¿El ID lo genera Java antes de mandarlo a la base de datos?**

* **Respuesta objetiva:** **No, el ID lo debe generar la Base de Datos.**
* **La mejor práctica:** Si usas PostgreSQL o MySQL (como asumo por el `init.sql`), la base de datos usa llaves primarias autoincrementables (o UUIDs). En Java (Spring Boot), configuras tu entidad con `@GeneratedValue(strategy = GenerationType.IDENTITY)`. Tú mandas el JSON *sin ID*, Java lo inserta en la BD, la BD le asigna el ID (ej. 54), y Java te devuelve el JSON de respuesta ya con el ID `54` incluido.

**4. ¿Cómo saber si hubo un error en la BD para avisarle al usuario?**

* **Respuesta objetiva:** **Mediante el manejo de Excepciones Globales en Spring Boot.**
* **La mejor práctica:** Si al insertar una transacción la base de datos falla (ej. se cayó la conexión o un dato excede el límite), Java lanzará una excepción (como `DataAccessException`). Debes crear una clase en Spring Boot con la anotación `@ControllerAdvice`. Esta clase "atrapa" el error de la BD y lo transforma automáticamente en el JSON de error estándar que diseñamos antes (con un código HTTP `500` o `400`). Flutter lee ese código HTTP y muestra un `SnackBar` o alerta roja en la pantalla.

**5. ¿Es recomendable guardar una foto del usuario?**

* **Respuesta objetiva:** **Para el MVP del Hackathon: NO.**
* **La mejor práctica:** Subir imágenes implica cambiar tus endpoints de `application/json` a `multipart/form-data`, configurar almacenamiento en OCI Object Storage, manejar permisos de archivos y optimizar el peso de la imagen en Flutter. Es demasiada fricción para una función que no aporta al "Análisis Financiero". **Alternativa:** Genera un avatar automático con las iniciales de su nombre en Flutter.

---

### Mapa de Controladores Recomendado (La Estructura Completa)

Para que el ecosistema funcione de manera fluida, necesitas separar los controladores lógicamente. Aquí tienes la propuesta arquitectónica:

#### 1. Backend (Spring Boot - Java)

Estos son los controladores que debes programar. Actúan como el "director de orquesta".

* **`AuthController` (¡Te faltaba este!)**
* `POST /api/v1/auth/login`: Autentica al usuario y devuelve un token JWT.
* `POST /api/v1/auth/registro`: Crea un usuario nuevo en la base de datos.


* **`UsuarioController`**
* `GET /api/v1/usuarios/perfil`: Obtiene los datos del usuario logueado.


* **`MetaController`**
* `POST /api/v1/metas`: Crea una nueva meta (ej. Ahorro para auto).
* `GET /api/v1/metas`: Lista las metas activas del usuario.
* `PUT /api/v1/metas/{id}`: Actualiza el progreso de una meta.


* **`TransaccionController`**
* `POST /api/v1/transacciones`: Registra un gasto (y opcionalmente llama a Python en segundo plano para clasificarlo).
* `GET /api/v1/transacciones`: Devuelve el historial de gastos (con parámetros de fecha para filtrar).


* **`AnalisisController`**
* `GET /api/v1/analisis/dashboard`: Recopila las transacciones del mes, se las envía a Python, recibe el perfil predictivo, cruza la info con las metas y le devuelve a Flutter el JSON final con las recomendaciones.



#### 2. Ciencia de Datos (Python - FastAPI / Flask)

Python **NO** se conecta a la base de datos. Python es una calculadora inteligente; solo recibe datos, los procesa y los escupe.

* **`ClasificacionController`**
* `POST /api/ia/clasificar`: Recibe una descripción ("Walmart") y devuelve la categoría ("Alimentación").


* **`PrediccionController`**
* `POST /api/ia/perfil-financiero`: Recibe los ingresos y gastos del mes y devuelve si el usuario es "Saludable" o "En Riesgo".



#### 3. Frontend (Flutter)

En Flutter no se llaman "controladores" en el mismo sentido, se manejan a través de **Servicios (Services / Repositories)** que se comunican con tu gestor de estado.

* `AuthService`: Maneja el guardado del token JWT en `SharedPreferences` o `FlutterSecureStorage`.
* `TransactionService`: Hace las peticiones HTTP a Java.
* `AnalysisService`: Trae la información pesada para las gráficas.

---

### Propuesta de Nuevos JSON (Contratos Faltantes)

Aquí tienes los contratos esenciales que debes agregar a tu `API_CONTRACTS.md` para cubrir los casos de uso que mencionaste (Login y Metas).

#### 1. JSON de Autenticación (Login)

**Endpoint:** `POST /api/v1/auth/login`

**Request (Flutter a Java):**

```json
{
  "email": "usuario@correo.com",
  "password": "Password123!"
}

```

**Response 200 OK (Java a Flutter):**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR...", 
  "usuario": {
    "id": 1,
    "nombre": "Juan Pérez",
    "email": "usuario@correo.com"
  }
}

```

*(Nota: Flutter debe guardar el `token` y enviarlo en el header `Authorization: Bearer <token>` en todas las demás peticiones).*

#### 2. JSON de Registro de Meta Financiera

**Endpoint:** `POST /api/v1/metas`

**Request (Flutter a Java - *Sin ID*):**

```json
{
  "nombre_meta": "Fondo de Emergencia",
  "monto_objetivo": 20000.00,
  "fecha_limite": "2026-12-31",
  "categoria_meta": "AHORRO"
}

```

**Response 201 Created (Java a Flutter - *Con ID generado por BD*):**

```json
{
  "id_meta": 42,
  "nombre_meta": "Fondo de Emergencia",
  "monto_objetivo": 20000.00,
  "monto_actual": 0.00,
  "fecha_limite": "2026-12-31",
  "estado": "ACTIVA"
}

```
