# Contribución Individual — Etapa 05

**Equipo:** 35
**Integrante:** Lombardi Lucas
**Fecha:** 2026-11-03

## 1. Aporte realizado
Armé el script `sql/tecnico/03_triggers_auditoria.sql`: la tabla `Auditoria_Producto` y tres triggers. Dos sobre Producto (`AFTER UPDATE` y `AFTER DELETE`), que guardan los datos anteriores leídos de `deleted` y el usuario con `SUSER_SNAME()`, y uno `INSTEAD OF DELETE` sobre Venta, que muestra un mensaje y no borra nada. Lo documenté en `docs/etapa-05/03_triggers_auditoria.md`.

## 2. Decisiones en las que participé
- `Auditoria_Producto` no tiene FK a Producto, para que los registros de un producto eliminado se conserven.
- El trigger de `UPDATE` registra solo cuando cambia el precio o el stock, que son los datos que guarda la tabla.
- Con el `INSTEAD OF DELETE` las ventas dejan de borrarse y se anulan con el estado `'cancelada'`, lo que resuelve el punto que había quedado abierto en la etapa 3.

## 3. Problemas o dificultades identificadas
- Un trigger se ejecuta una vez por sentencia, no por fila: un `UPDATE` o `DELETE` de varios productos trae varias filas en `inserted` y `deleted`, por lo que no sirven las variables escalares.
- Un producto con ventas o promociones no se puede eliminar (FK con `ON DELETE NO ACTION`), así que el `AFTER DELETE` no se puede probar con productos reales.
- La prueba de borrado de ventas es riesgosa: sin el trigger, el `DELETE` borraría la venta junto con su detalle, pagos y envío por los `ON DELETE CASCADE`.
- SQL Server no permite un `INSTEAD OF DELETE` en una tabla con una FK `ON DELETE CASCADE`. Venta no tiene ninguna (sus FK a Cliente y Vendedor son `ON DELETE NO ACTION`), por lo que el trigger se puede crear.

## 4. Soluciones o propuestas realizadas
- `INSERT ... SELECT` desde `deleted` (y desde `inserted` en el `UPDATE`, unidas por `id_producto`) para procesar todas las filas de una sola vez.
- Prueba con un producto de prueba que se crea, se modifica y se elimina, sin tocar datos reales.
- Prueba del borrado de venta dentro de `BEGIN TRANSACTION ... ROLLBACK TRANSACTION`, por seguridad.
- `IF EXISTS (SELECT 1 FROM deleted)` en el trigger de Venta, para que el mensaje aparezca solo cuando hay filas.

## 5. Evidencias en el repositorio
- Commit "Agrega triggers de auditoria de etapa 5": [COMPLETAR: link o hash del commit]
- Archivos: `sql/tecnico/03_triggers_auditoria.sql` y `docs/etapa-05/03_triggers_auditoria.md`
- [COMPLETAR: resultado de la ejecución de la prueba (captura de `Auditoria_Producto` y de la venta que sigue existiendo)]

## 6. Reflexión individual
Aprendí que un trigger trabaja sobre conjuntos de filas (`inserted` y `deleted`) y no fila por fila, y que un `INSTEAD OF` reemplaza la operación original: sirve no solo para no borrar, sino para fijar una regla de negocio (las ventas no se eliminan) directamente en la base de datos.
