## Requisitos para el FrontEnd 

Para la parte de la funcionalidad estuve pensando en 3 "pantallas" o casos principales. Quisiera que me des retroalimentación, si es viable hacerlo en máximo dos semanas, las implicaciones que lleva y si en dado caso es viable y lo ves bien, me gustaría que actualices el stack tecnológico a usar y el plan de trabajo para poder dividirlo con otro compañero.

1. Dashboard: Aquí se encontrará la información inicial de algunos gastos hechos durante la semana (gráficos y cosas por el estilo). De aquí se podría desplegar otra sub-pantalla que nos serviría para registrar los gastos; para registrarlos simplemente nos pediría el monto y la descripción para mandar todo al backend y luego al modelo. Una vez que se procese todo y que se haya hecho la predicción, pienso que se puede abrir una ventana donde habrá un resumen de los datos, esto con el fin de que el usuario pudiera cambiar los datos que guste, en caso de que el modelo se haya equivocado en algo (esto eliminaría la necesidad de usar una probabilidad), pudiendo así guardar con un botón todo.

ACLARACIÓN: Es importante mencionar que habrá un menú desplegable de tipo "hamburguesa", en este menú habrá los siguientes apartados:
- Información del usuario
- Inicio/Dashboard
- Metas
- Situación
Cada ventana podrá tener acceso al menú de hamburguesa para desplazarse entre pantallas.

2. Metas: Aquí principalmente será una lista de todas las metas. Primeramente será una lista "comprimida", podremos hacer click en cada meta para "agrandar" cada una y poder ver las características de cada una. En la parte inferior (al igual que para registrar los gastos) habrá un botón que nos servirá para registrar metas donde nos pedirá los datos correspondientes en una sub-pantalla diferente.

3. Situación: En esta tercera pantalla se verá la situación actual del usuario, poniendo en práctica todos los consejos para mejorar las finanzas del usuario.

Es importante también mencionar que se hará uso de las notificaciones como recordatorio y para hacer saber al usuario que un cierto día, cada cierto tiempo se le hará llegar un resumen (aquí se actualizará la parte de la situación) con los consejos, etc. Por ejemplo, todos los domingos a las 8 p.m. llegará una notificación con el resumen semanal.


## Plan de trabajo

### Stack Tecnológico Actualizado (Front-End)

No agregaremos librerías locas, mantendremos el proyecto esbelto para que compile rápido y no tenga errores de versiones.

* **Framework:** Flutter (Dart).
* **Navegación:** `Drawer` nativo de Flutter (para el menú hamburguesa).
* **Gráficos del Dashboard:** Paquete `fl_chart` (es el estándar de la industria, gratuito y se ve muy profesional).
* **Pop-ups y Ventanas:** `showModalBottomSheet` nativo de Flutter (para que la pantalla de confirmación de la IA y el formulario de gastos salgan de abajo hacia arriba, se ve muy moderno).
* **Peticiones y Alertas:** Paquetes `http` (para la API) y `firebase_messaging` (para las notificaciones).

---

###  Plan de Trabajo

Para llegar vivos a la demostración, tienen que trabajar en paralelo sin pisarse los archivos. Se van a dividir así:

**Estructura y UI**

Tu objetivo es que la aplicación se vea bien y se pueda navegar, aunque los botones no guarden nada todavía.

* Crear la estructura del proyecto y el `Drawer` (Menú hamburguesa) que esté presente en todas las vistas.
* Maquetar la pantalla **Dashboard**: Usar `fl_chart` para poner una gráfica de pastel o de barras simulada (datos de prueba quemados en código).
* Maquetar la pantalla **Situación**: Tarjetas visuales con textos de consejo (datos de prueba).
* Maquetar la pantalla **Metas**: Usar el `ExpansionTile` para la lista desplegable.
* Diseñar las ventanas modales (`showModalBottomSheet`) que se usarán para los formularios de entrada.



### Conexiones, Formularios y Firebase

Tu objetivo es que los datos fluyan. Eres el puente entre lo que el Desarrollador A dibuja y la API de Spring Boot.

* Configurar el proyecto en **Firebase Console** e inicializar `firebase_messaging` en Flutter para capturar el *Device Token*.
* Crear el formulario funcional de **Agregar Gasto** y conectar el botón a la API mediante el paquete `http`.
* Crear la lógica de la **Ventana de Confirmación de IA**: Recibir la predicción, mostrarla en el modal que hizo el Desarrollador A, y hacer el `POST` final de guardado.
* Crear el formulario funcional de **Registro de Metas** y conectarlo por `http`.
* Configurar los "escuchadores" de notificaciones push para que el celular muestre las alertas cuando Spring Boot las envíe.