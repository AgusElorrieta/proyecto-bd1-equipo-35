# Contribución individual -- Etapa 03

**Equipo:** 35  
**Integrante:** Emmanuel Ottero  
**Fecha:** 2026-09-30  

## 1. Aporte realizado

En esta etapa me encargué principalmente de la redacción y actualización de la documentación general del proyecto y del archivo `README.md` principal del repositorio. 

Documenté formalmente que la Etapa III se encuentra finalizada, especifiqué que el motor de base de datos utilizado es SQL Server 2022 Express, e indiqué de forma clara las rutas de los scripts generados (`sql/ddl/crear_bd.sql` y `sql/dml/datos_prueba.sql`).

## 2. Decisiones en las que participé

Participé en la consolidación del entregable final y ayudé a definir el flujo de despliegue de la base de datos en el repositorio. 

Se decidió establecer como regla estricta (y dejarlo documentado) que el script DDL debe ejecutarse en su totalidad antes que el script DML. Esto garantiza que primero se creen las tablas con sus claves primarias y foráneas, asegurando que al momento de insertar los datos de prueba las reglas de integridad ya estén operativas.

## 3. Problemas o dificultades identificadas

Identifiqué que si simplemente subíamos los scripts SQL a las carpetas, cualquier persona (o el evaluador) que clone el repositorio podría intentar ejecutar el poblado de datos (DML) antes de tener la estructura completa, o ejecutar los `INSERT` en un orden incorrecto.

Esto hubiera causado errores inmediatos de violación de Foreign Keys o de tablas inexistentes.

## 4. Soluciones o propuestas realizadas

Para resolver este problema, redacté una guía de "paso a paso" directamente en la portada del repositorio (`README.md`). 

De esta forma, eliminé cualquier ambigüedad sobre el proceso de instalación, especificando claramente el orden de ejecución estricto de los scripts para que la base de datos se compile sin arrojar errores.

## 5. Evidencias en el repositorio

Archivos relacionados con mi aporte:

- `README.md`
- `docs/etapa-03/equipo35_etapa03_ema.md`

Commit relacionado:

- `Actualiza README con implementacion de etapa 3`

## 6. Reflexión individual

En esta etapa comprendí que la fase de diseño físico no termina únicamente con la escritura de un código SQL libre de errores. 

La documentación técnica y el manual de despliegue son igual de importantes; un esquema relacional perfectamente normalizado y con restricciones robustas no es funcional si no comunicamos claramente los requerimientos del entorno y los pasos para compilar la base de datos de forma segura.
