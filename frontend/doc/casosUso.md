Para manejar de mejor manera los casos de uso los separé por "pantallas", son los siguientes:

## Dashboard

**Iniciar el Dashboard:** Durante este caso se considera toda la información inicial que es necesaria para mostrar en el dashboard, que sería toda la información de un usuario en cuestión (id, nombre apellido, correo, ingreso, perfil, nivel de endeudamiento, recomendaciones), así como una lista de sus transacciones de los últimos 7 días.
**Realizar la predicción**: Como se hace primero la predicción para traer la información antes de mandarlo a la base de datos, primero se manda el monto, la descrición y el tipo de transacción al backend, este realiza las validaciones y manda la información al modelo de predicción; una vez realizada la información se le regresará al usuario la información de la transacción (descripción, tipo, monto, cualidad y categoría) con el fin de que el usuario cheque que la información sea correcta y en dado caso de que quiera modificar algo, lo haga.
**Guardar transacción**: Este es el seguimiento del caso anterior, cuando el usuario ya tiene la información correcta manda la información nuevamente al backend para que se guarde en la base de datos, es necesario validar nuevamente la información antes de guardarla para evitar errores; aquí se guarda toda la información de una transacción (id de usuario, tipo, cualidad, categoría, fecha, monto, descripción).


## Pantalla de metas

**Cargar metas:** La cuestión en esta pantalla es que al entrar carguen todas las metas del usuario en un listado, por lo que necesitamos tener la lista de metas que coincidan con el id del usuario; se debe cargar la información de las metas (nombre, monto, fecha, estado).
**Registrar meta:** Esta función es parecida a la de registrar gasto, aunque esta solo se manda al backend para validar y guardar en la base de datos. La idea es que el usuario registre una meta financiera con la información correspondiente (nombre, monto, fecha estimada, estado).


## Situación financiera

**Cargar situación:** En esta parte al igual que con las metas, se debe de mostrar la información y algunas métricas del usuario, como cuánto ha gastado en la semana, una gráfica de pastel para mostrar las categorías que ha gastado, mostrar en qué cualidad ha gastado y ese tipo de cosas. Por lo que se espera que venga información de las transacciones del usuario (categoria, monto, descripción, fecha, tipo, cualidad) y las recomendaciones que tenga el usuario, ya que se planea mostrar algunas.