# Manifiesto Individual — Etapa III: Implementación Física
**Equipo:** 35
**Proyecto:** MateSereño — Base de Datos I
**Integrante:** Emmanuel Otero
**Etapa:** III

---

**Qué hice:** 
Me encargué de la redacción y actualización de la documentación general del proyecto y del archivo `README.md` principal del repositorio. 
Documenté formalmente que la Etapa III se encuentra finalizada, especifiqué que el motor de base de datos utilizado es SQL Server 2022 Express, 
e indiqué de forma clara las rutas de los archivos generados (`sql/ddl/crear_bd.sql` y `sql/dml/datos_prueba.sql`) junto con las instrucciones 
y el orden estricto para su correcta ejecución.

**En qué participé:** 
Participé en la consolidación del entregable final de la etapa. Mientras mis compañeros se encargaban de codificar las restricciones, los datos 
de prueba y realizar las pruebas de integridad (comprobación de PK, FK, CHECK, etc.), mi rol fue coordinar que todo ese trabajo técnico quedara 
correctamente realizado, referenciado y explicado para que cualquier usuario que clone el repositorio sepa cómo desplegar la base de datos sin errores.

**Qué decisión ayudé a tomar:** 
Ayudé a definir y documentar el flujo de despliegue de la base de datos. Se decidió establecer como regla estricta en el README que el script DDL 
(Data Definition Language) debe ejecutarse en su totalidad antes que el script DML (Data Manipulation Language). Esto es fundamental para 
garantizar que primero se creen las tablas "fuertes" (padres) y luego las "débiles" (hijas), asegurando que al momento de insertar los 8 registros
de prueba por tabla las reglas de integridad referencial (claves foráneas) ya estén operativas.

**Qué problema encontré/resolví:** 
Identifiqué que si simplemente subíamos los scripts SQL al repositorio, un tercero podría intentar ejecutar el poblado de datos (DML) antes de 
tener la estructura completa, o ejecutar los `INSERT` en un orden incorrecto, lo cual causaría errores de violación de Foreign Keys. 
Resolví esto redactando una guía clara de "paso a paso" en la portada del repositorio, eliminando cualquier ambigüedad sobre el proceso de 
instalación y el motor a utilizar.

**Enlaces a la evidencia en GitHub:**
- **Archivo modificado:** `README.md` y `docs/etapa-03/equipo35_etapa03_ema.md`
- **Commit:** `Actualizacion README con implementacion de etapa 3`

**Qué aprendí:** 
Comprendí que la fase de diseño físico no termina únicamente con la escritura de un código SQL libre de errores. La documentación técnica y 
el manual de despliegue son igual de importantes; un esquema relacional perfectamente normalizado y con restricciones robustas no es funcional 
si el equipo no comunica claramente los requerimientos del entorno (SQL Server 2022 Express) y los pasos para compilar la base de datos de forma segura.
