# Asistente Fintech MVP - G9-LATAM-Team71

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)

> **Asistente financiero personal inteligente. Sin términos complejos, solo decisiones inteligentes.**

## Visión General del Proyecto

Esta solución es un MVP Fintech diseñado para el mercado latinoamericano. El objetivo principal es trascender la confusión de los usuarios al registrar sus transacciones y gastos; busca ser un **asistente de salud financiera** proactivo. 

Entendemos que las finanzas personales pueden ser abrumadoras para el usuario común. Por eso, nuestra aplicación evalúa el comportamiento del usuario frente a una **Meta Financiera** específica, calcula el costo de oportunidad de sus hábitos y ofrece recomendaciones de mejora en lenguaje sencillo.

### Características Principales
* **Clasificación Inteligente:** Nuestro modelo de predicción lee el concepto del gasto y lo clasifica automáticamente.
* **Enfoque en Metas:** No solo se grafica tu dinero; te decimos si ese gasto en café retrasa tu meta de "Fondo de Emergencia".
* **Reportes Proactivos:** Evaluaciones periódicas que te indican qué categorías reducir sin usar un lenguaje financiero complicado.

---

## Arquitectura del Sistema (Microservicios)

Para garantizar un rendimiento fluido y escalabilidad, el sistema adopta una arquitectura basada en microservicios, separando las responsabilidades de ingeniería y ciencia de datos:

1. **Spring Boot - Java:** Maneja la lógica de negocio, la seguridad, la persistencia en base de datos PostgreSQL y la comunicación con el cliente.
2. **Prediction API con Python:** Microservicio dedicado exclusivamente a la Ciencia de Datos. Recibe las transacciones crudas del API con Java, aplica modelos de predicción y devuelve perfiles predictivos al instante.
3. **Infraestructura OCI:**
   * **OCI Compute:** Alojamiento centralizado de los contenedores Docker.
   * **OCI Object Storage:** Repositorio dinámico para almacenar los archivos serializados del modelo de IA (`.pkl`), permitiendo mejoras en las predicciones sin recompilar el código.

---

## Documentación y Flujo de Trabajo

Para mantener el orden y la integridad del proyecto, hemos separado la documentación técnica. **Por favor, consulta los siguientes enlaces antes de comenzar a contribuir:**

* 🔗 **[Contratos de API y JSON (API_CONTRACTS.md)](./API_CONTRACTS.md):** Contiene todas las rutas de los endpoints, códigos HTTP, y las estructuras JSON requeridas para comunicar el Frontend, el Backend y el modelo de IA.
* 🔗 **[Guía de Contribución y Docker (CONTRIBUTING.md)](./CONTRIBUTING.md):** Detalla nuestra estrategia de ramas (Git Flow: `main`, `develop`, `feature`, `bugfix`) y los comandos exactos de Docker para levantar el entorno local.

---
