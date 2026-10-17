# Contribución Individual — Etapa 04

**Equipo:** 35
**Integrante:** Lombardi Lucas

**Fecha:** 2026-10-17

## 1. Aporte realizado
Armé la consulta `sql/consultas/02_ventas_por_vendedor.sql`, el reporte de ventas por vendedor: devuelve la cantidad de ventas (`COUNT`) y el total vendido (`SUM`) de cada vendedor entre dos fechas (`@desde` y `@hasta`), excluye las ventas canceladas e incluye con `LEFT JOIN` a los vendedores que no vendieron nada, que aparecen con 0.

## 2. Decisiones en las que participé
- Definí el "total vendido" como la suma de `cantidad * precio_unitario - descuento_aplicado` de los renglones, porque Venta no guarda un total. No incluye el costo de envío ni el recargo del método de pago.
- Usé variables `@desde` y `@hasta` en lugar de un `BETWEEN` directo sobre `fecha_hora`.
- No filtré por `activo` en Vendedor: un vendedor dado de baja que vendió en el período tiene que figurar en el reporte.

## 3. Problemas o dificultades identificadas
- Al unir Venta con Venta_Detalle, cada venta se repite una vez por renglón, por lo que un `COUNT` común contaría de más.
- Si los filtros de estado y fecha van en el `WHERE`, los vendedores sin ventas desaparecen del resultado (el `LEFT JOIN` termina funcionando como `INNER JOIN`).
- `fecha_hora` es `DATETIME`: un `BETWEEN` hasta el 17/09 dejaría afuera las ventas hechas ese día después de las 00:00.

## 4. Soluciones o propuestas realizadas
- `COUNT(DISTINCT v.id_venta)` para contar cada venta una sola vez.
- Condiciones de estado y fecha dentro del `ON` del `LEFT JOIN`, y `COALESCE(SUM(...), 0)` para que los vendedores sin ventas muestren 0.
- Rango semiabierto: `fecha_hora >= @desde AND fecha_hora < DATEADD(DAY, 1, @hasta)`.

## 5. Evidencias en el repositorio
- Commit `sql/consultas/02_ventas_por_vendedor.sql`

## 6. Reflexión individual
Aprendí que en un `LEFT JOIN` los filtros sobre la tabla de la derecha van en el `ON` y no en el `WHERE`, y que contar sobre un join con detalle exige `COUNT(DISTINCT ...)`. Son errores que no tiran error de sintaxis: el resultado simplemente sale mal.
