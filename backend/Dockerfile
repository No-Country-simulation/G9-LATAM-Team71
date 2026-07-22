# Version de Java 17
FROM eclipse-temurin:17-jre-jammy

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo ejecutable compilado (JAR) al contenedor
# Nota: Se debe compilar el proyecto antes de ejecutar Docker
#       se recomienda renombrar el .jar a app para facilitar todo, si no se quiere cambiar
#       solo cambia el nombre en la parte de abajo
COPY target/fintech-backend-0.0.1-SNAPSHOT.jar app.jar

# Puerto que usa Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación 
ENTRYPOINT ["java", "-jar", "app.jar"]