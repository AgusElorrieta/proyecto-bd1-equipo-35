# Contribución individual – Etapa IV

**Equipo:** 35  
**Integrante:** Martin Espinoza  
**Fecha:** 17/10/2026

## 1. Aporte realizado
Integración final del repositorio y la redacción de la documentación técnica. Creé el archivo `docs/etapa-04/consultas.md` para explicar formalmente las estrategias lógicas (funciones de ventana, subconsultas en el FROM y agrupamientos condicionales) aplicadas por mis compañeros. Además, actualicé el `README.md` cerrando el ciclo del proyecto y catalogando el directorio de consultas.

## 2. Decisiones en las que participé
* Definimos entregar dos variantes para cubrir el "Reporte Agregado" (Ventas por Vendedor y Ventas por Categoría). Decidí documentar ambos resaltando el uso de `LEFT JOIN` y cómo aislar los cálculos en subconsultas protege la exactitud de funciones agregadas como `SUM()`
* Documenté de manera explícita la distinción teórica aplicada en la consulta 04, donde el `WHERE` actúa filtrando filas individuales antes de la agregación, y el `HAVING` actúa descartando registros basándose en el resultado final

## 3. Problemas o dificultades identificadas
* Durante la revisión de la consulta 04 ("Saldo Pendiente"), identificamos un defecto estructural grave inicial: unir simultáneamente las tablas de detalle y de pagos mediante un `JOIN` directo generaba un producto cartesiano. Esto multiplicaba las filas y los importes en aquellas ventas que poseían múltiples renglones y múltiples pagos, invalidando el cálculo lógico.

## 4. Soluciones o propuestas realizadas
* Validé e integré en la documentación la solución técnica aplicada mediante el script `validar_etapa4.sql`: utilizar una subconsulta como tabla derivada en el FROM. Al aislar la sumatoria de los renglones previamente, se eliminó la duplicidad cartesiana antes de hacer el cruce final con la tabla de pagos.

## 5. Evidencias en el repositorio
* Archivo creado: `docs/etapa-04/consultas.md`
* Archivo actualizado: `README.md` 
* Archivo personal: `docs/etapa-04/equipo35_etapa04_martin.md`
* Commit sugerido para la subida: `docs: agregar documentacion de consultas, readme y manifiesto de Martin`

## 6. Reflexión individual
Documentar y auditar el código del equipo me permitió consolidar mi entendimiento sobre el Orden Lógico de Procesamiento (OLP) en SQL. Entendí los riesgos de generar productos cartesianos no deseados al cruzar múltiples tablas dependientes, y aprendí que las subconsultas en la cláusula FROM son una herramienta invaluable para pre-procesar y estabilizar conjuntos de datos antes de unirlos al bloque principal de la consulta.
