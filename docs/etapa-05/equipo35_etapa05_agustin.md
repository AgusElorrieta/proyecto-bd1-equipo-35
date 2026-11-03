# Manifiesto individual - Etapa V

**Equipo:** 35  
**Integrante:** Agustín Elorrieta  
**Caso:** MateSereño  
**Fecha:** 03/11/2026

## 1. Aporte realizado

Me encargué del tema de manejo de transacciones. Preparé `sql/tecnico/02_transacciones.sql` con un procedimiento para registrar el encabezado y el detalle de una venta, y actualizar el stock dentro de una misma transacción. También preparé las pruebas de una venta correcta, falta de stock, error provocado tras el primer INSERT y transacciones anidadas con un punto de guardado.

## 2. Decisiones en las que participé

Se decidió usar `TRY/CATCH`, `COMMIT` y `ROLLBACK` para que una venta no quede incompleta si alguna operación falla. El descuento de stock se hace con una condición que impide vender más unidades de las disponibles. Se conservaron los nombres de tablas y restricciones del modelo de las etapas anteriores.

## 3. Problemas o dificultades identificadas

Fue necesario tener en cuenta que el identificador de Venta no se genera automáticamente y que una venta involucra varias tablas relacionadas. También hubo que diferenciar las transacciones anidadas de los puntos de guardado: un `COMMIT` interno no confirma por sí solo la transacción exterior.

## 4. Soluciones o propuestas realizadas

Se preparó un procedimiento que permite deshacer todos los cambios cuando falta stock o se provoca un error después de insertar el encabezado. Para las demostraciones se usan transacciones exteriores que se revierten al final, de manera que no queden ventas ficticias en la base de datos. Ejecuté el script en SQL Server Express y verifiqué que la venta correcta disminuyera temporalmente el stock de 10 a 8, que el error de stock insuficiente activara el ROLLBACK y que la transacción anidada recuperara los valores originales mediante un punto de guardado. También comprobé que no quedaran ventas ni detalles ficticios después de las pruebas. Quedó pendiente registrar la captura del número de error de la prueba forzada.

## 5. Evidencias en el repositorio

- `sql/tecnico/02_transacciones.sql`
- `docs/etapa-05/02_transacciones.md`
- `docs/etapa-05/equipo35_etapa05_agustin.md`
- Commit: **agregar el identificador real después de subir los archivos**.

## 6. Reflexión individual

Esta etapa me ayudó a entender por qué las transacciones son importantes cuando una operación afecta varias tablas. No basta con insertar una venta: también tiene que quedar su detalle y descontarse el stock correctamente. Aprendí la diferencia entre confirmar una operación completa y deshacer los cambios cuando algo falla.
