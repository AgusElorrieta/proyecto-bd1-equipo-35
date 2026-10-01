# Contribución individual -- Etapa 03

**Equipo:** 35  
**Integrante:** Agustin Elorrieta  
**Fecha:** 2026-09-30  

## 1. Aporte realizado

En esta etapa me encargué principalmente de llevar el modelo relacional que habíamos realizado anteriormente a una base de datos funcionando en SQL Server.

Preparé el script DDL con la creación de las tablas, claves primarias, claves foráneas y restricciones. También armé el script DML con los datos de prueba necesarios para comprobar el funcionamiento de la base.

Además instalé y configuré SQL Server 2022 Express y SQL Server Management Studio para poder ejecutar y probar los scripts.

## 2. Decisiones en las que participé

Participé en la elección de los tipos de datos adecuados para los atributos y en la definición de distintas restricciones de integridad.

Por ejemplo, se decidió utilizar restricciones para evitar stock negativo, cantidades menores o iguales a cero, códigos de productos repetidos y valores inválidos en estados o modalidades.

También se mantuvieron las relaciones y claves definidas durante la etapa anterior al momento de llevarlas a SQL Server.

## 3. Problemas o dificultades identificadas

Una de las principales dificultades fue pasar del modelo relacional de ERDPlus a una implementación física real, ya que en el modelo anterior no estaban definidos de forma precisa todos los tipos de datos.

También tuve que familiarizarme con SQL Server y SSMS, ya que hasta ese momento había trabajado principalmente con el diseño del modelo y no con su implementación completa.

## 4. Soluciones o propuestas realizadas

Se revisó cada tabla por separado y se asignaron tipos de datos acordes a la información almacenada, utilizando tipos como `INT`, `VARCHAR`, `DECIMAL`, `DATE`, `DATETIME` y `BIT`.

Después ejecuté el script DDL en SQL Server y verifiqué que las 10 tablas se crearan correctamente.

Por último, cargué datos de prueba mediante el script DML y comprobé que se insertaran 8 registros en cada tabla respetando las relaciones y restricciones definidas.

## 5. Evidencias en el repositorio

Archivos relacionados con mi aporte:

- `sql/ddl/crear_bd.sql`
- `sql/dml/datos_prueba.sql`
- `docs/etapa-03/implementacion.md`

Commit relacionado:

- `Implementa DDL y DML de la etapa 3`

## 6. Reflexión individual

En esta etapa pude entender mejor la diferencia entre diseñar una base de datos y llevar ese diseño a una implementación real.

Lo que más me ayudó fue ver cómo las claves, cardinalidades y reglas que habíamos definido anteriormente terminan transformándose en `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK` y otras restricciones dentro de SQL Server.