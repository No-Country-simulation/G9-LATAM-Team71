# Plan de Implementación Frontend - Hackatón Wallet App

Este plan describe la reestructuración y desarrollo del Frontend de la aplicación móvil basada en las especificaciones del Hackatón, utilizando Flutter y siguiendo el diseño de los assets y capturas de pantalla proporcionados.

## User Review Required

> [!IMPORTANT]
> He notado que los archivos fuente de Flutter (`lib/`, `pubspec.yaml`, etc.) no están presentes actualmente en el directorio raíz del proyecto (`/frontend`). El plan asume que reconstruiremos la estructura básica siguiendo las nuevas especificaciones.
>
> [!WARNING]
> La navegación se centralizará en un `Drawer` (menú hamburguesa) y un `AppScaffold` personalizado para mantener la consistencia en todas las pantallas.

## Proposed Changes

### 1. Configuración Base del Proyecto

#### [NEW] [pubspec.yaml](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/pubspec.yaml)
*   Definir dependencias: `nb_utils`, `fl_chart`, `http`, `firebase_messaging`, `firebase_core`, `intl`.
*   Configurar todos los assets en la carpeta `assets/`.

#### [NEW] [main.dart](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/lib/main.dart)
*   Inicializar `WidgetsFlutterBinding`.
*   Inicializar `nb_utils` y `Firebase`.
*   Configurar el tema global (basado en `WAPrimaryColor`).

---

### 2. Navegación y Estructura Global

#### [NEW] [AppScaffold.dart](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/lib/component/AppScaffold.dart)
*   Widget base que contiene el `AppBar`, el `Drawer` y el cuerpo dinámico.
*   Implementar el menú hamburguesa con las opciones: **Información del usuario**, **Dashboard**, **Metas**, **Situación**.

---

### 3. Pantallas Principales (Maquetado)

#### [NEW] [DashboardScreen.dart](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/lib/screen/DashboardScreen.dart)
*   Resumen de gastos semanales.
*   Integración de `fl_chart` (Gráfico de barras/pastel).
*   Lista de transacciones recientes.
*   Botón flotante para abrir el modal de "Registrar Gasto".

#### [NEW] [MetasScreen.dart](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/lib/screen/MetasScreen.dart)
*   Lista de metas utilizando `ExpansionTile` para vista comprimida/expandida.
*   Barra de progreso para cada meta.
*   Botón para registrar nuevas metas.

#### [NEW] [SituacionScreen.dart](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/lib/screen/SituacionScreen.dart)
*   Tarjetas informativas con consejos financieros.
*   Resumen de salud financiera actual.

---

### 4. Formularios y Modales

#### [NEW] [ExpenseFormModal.dart](file:///C:/Users/garci/Documentos/Fintech/G9-LATAM-Team71/frontend/lib/component/ExpenseFormModal.dart)
*   Uso de `showModalBottomSheet`.
*   Campos: Monto, Descripción, Categoría (Enum).
*   Ventana de confirmación de IA (Simulada para el maquetado).

## Verification Plan

### Manual Verification
1.  Verificar que la aplicación inicie correctamente sin errores de compilación.
2.  Comprobar que el `Drawer` permita navegar entre las 3 pantallas principales.
3.  Verificar que el gráfico en el Dashboard se renderice correctamente.
4.  Confirmar que las metas se expandan al hacer clic.
5.  Probar la apertura de los modales desde los botones correspondientes.
