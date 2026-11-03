# Contribución individual – Etapa V

**Equipo:** 35  
**Integrante:** Martin Espinoza  
**Fecha:** 03/11/2026

## 1. Aporte realizado
investigar e implementar el mecanismo de optimización con índices. Desarrollé el script `sql/tecnico/05_indices.sql` donde creé una tabla masiva de pruebas con 1.000.000 de registros (`Venta_Historica`) y ejecuté mediciones de rendimiento contrastando búsquedas sin índice, con índice agrupado y con índice no agrupado cubierto (`INCLUDE`). Además, documenté los resultados en `05_indices.md` y actualicé el `README.md` para cerrar la Etapa V.

## 2. Decisiones en las que participé
* Decidí utilizar una tabla histórica paralela generada por script en lugar de alterar las tablas de producción del modelo (`Venta`), protegiendo la integridad de las pruebas de mis compañeros.
* Decidí implementar la cláusula `INCLUDE` en la tercera prueba, demostrando que un índice cubierto es la estrategia ideal para consultas selectivas porque evita los costosos *Key Lookups*.

## 3. Problemas o dificultades identificadas
* Cargar 1.000.000 de registros utilizando bucles `WHILE` tradicionales en T-SQL es un proceso muy lento que bloquea el motor.

## 4. Soluciones o propuestas realizadas
* Resolví la carga masiva implementando una expresión CTE (Common Table Expression) con `CROSS JOIN` en cascada. Esta técnica en memoria generó el millón de filas incrementales en cuestión de segundos, demostrando eficiencia técnica.

## 5. Evidencias en el repositorio
* Archivo SQL: `sql/tecnico/05_indices.sql`
* Documentación: `docs/etapa-05/05_indices.md`
* Archivo actualizado: `README.md`
* Commit sugerido: `Agrega optimizacion con indices de etapa 5`

## 6. Reflexión individual
A través de las directivas `STATISTICS IO` y `STATISTICS TIME`, comprendí empíricamente cómo el motor lee los datos. Aprendí que un índice no agrupado tradicional requiere un "salto" extra hacia la tabla real para buscar campos no indexados, pero si usamos `INCLUDE` para "cubrir" la consulta, el motor encuentra todo en la estructura del índice, reduciendo la entrada/salida (I/O) al mínimo.
