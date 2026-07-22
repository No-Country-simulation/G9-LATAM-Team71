## Manejo del repositorio en GitHub ##
En el repositorio se van a manejar 3 ramas principales:
* **Main:** Esta será la rama principal con la versión más estable del proyecto. Aquí se contiene únicamente código que haya sido probado, sea estable y funcional.
* **Develop:** Esta rama nace directamente de la rama `main`, sirve como punto de encuentro donde cada equipo irá integrando directamente su trabajo conforme se vaya terminando. Siempre que se vaya a iniciar una nueva tarea se debe clonar la versión más reciente de la rama `develop`.
* **Feature:** Este apartado será una rama temporal siempre que se quiera iniciar una nueva funcionalidad para aislar el avance y no intervenga con el avance de otros integrantes. Nace a partir de la rama `develop`, siempre debe de llevar un nombre descriptivo. Por ejemplo: `feature/endpoint-login`.
* **Bugfix:** Esta rama es parecida a la rama `feature` ya que es una rama temporal también. Nace igualmente a partir de la rama `develop` con el fin de corregir errores.

### Flujo de comandos con git ###

* **Actualizar:** git checkout develop -> git pull origin develop

* **Crear rama:** git checkout -b feature/mi-nueva-tarea

* **Programar y guardar:** git add . -> git commit -m "feat/nueva-tarea"

* **Subir y para revisión:** git push origin feature/nueva-tarea

Ir a GitHub: Abrir un Pull Request hacia develop para revisión del Ing. de Software.

---

## Entorno con Docker ##

No es necesario instalar las bases de datos manualmente. Usamos Docker para unificar el entorno de todos.

* **Levantar el proyecto (en segundo plano):**
        **Bash**
    ```
    docker-compose up -d
    ```
* **Apagar el proyecto:**
        **Bash**
    ```
    docker-compose down
    ```

* **Ver registros (Logs) en tiempo real:**
        **Bash**
    docker-compose logs -f
        
        # O de un servicio específico:
    ```
    docker-compose logs -f backend
    docker-compose logs -f python-api
    ```

* **Reconstruir y reiniciar un contenedor (tras cambios en código):**
        **Bash**
    ```
    docker-compose up -d --build backend
    ```