# Triggers de auditoría — Etapa 05

**Proyecto:** Base de Datos I — Equipo 35
**Caso de estudio:** MateSereño
**Motor:** Microsoft SQL Server 2022
**Script:** `sql/tecnico/03_triggers_auditoria.sql`

## 1. Objetivo

Registrar los cambios que sufre la tabla Producto (modificaciones y bajas) para saber qué precio y qué stock tenía un producto antes del cambio, quién lo hizo y cuándo, y evitar que se eliminen ventas por error.

## 2. Tabla Auditoria_Producto

| Columna | Tipo | Descripción |
|---|---|---|
| `id_auditoria` | INT IDENTITY, PK | Identificador del registro |
| `operacion` | VARCHAR(10) | `UPDATE` o `DELETE` |
| `id_producto` | INT | Producto afectado |
| `precio_anterior` | DECIMAL(12,2) | `precio_lista` antes del cambio |
| `precio_nuevo` | DECIMAL(12,2), NULL | `precio_lista` después del cambio (NULL en `DELETE`) |
| `stock_anterior` | INT | `stock_actual` antes del cambio |
| `fecha_hora` | DATETIME | Momento del cambio (`GETDATE()` por defecto) |
| `usuario` | NVARCHAR(128) | Login que hizo el cambio (`SUSER_SNAME()`) |

`id_producto` no es FK de Producto a propósito: los registros de un producto eliminado tienen que conservarse después de su baja.

## 3. Triggers

### 3.1 TR_Producto_AuditoriaUpdate (AFTER UPDATE sobre Producto)

Guarda, por cada producto modificado, el precio y el stock anteriores (leídos de `deleted`), el precio nuevo (leído de `inserted`) y el usuario. Solo registra cuando cambia `precio_lista` o `stock_actual`, que son los datos que audita la tabla. Un solo `UPDATE` puede modificar varios productos y el trigger se ejecuta una vez por sentencia, por eso se resuelve con un `INSERT ... SELECT` sobre `deleted` e `inserted` unidas por `id_producto`.

### 3.2 TR_Producto_AuditoriaDelete (AFTER DELETE sobre Producto)

Guarda los datos del producto eliminado (leídos de `deleted`) con `precio_nuevo` en NULL.

### 3.3 TR_Venta_BloquearDelete (INSTEAD OF DELETE sobre Venta)

Reemplaza el `DELETE`: muestra el mensaje "No se permite eliminar ventas..." y no borra nada. Para anular una venta se cambia su estado a `'cancelada'`.

## 4. Prueba

El bloque de pruebas está al final del script.

1. **Cambio de precio.** Se crea un producto de prueba (precio 1000, stock 5), se cambia su precio a 1500 y se consulta `Auditoria_Producto`.
   Resultado esperado: una fila `UPDATE` con `precio_anterior` 1000.00, `precio_nuevo` 1500.00 y `stock_anterior` 5.
2. **Baja de producto.** Se elimina el producto de prueba y se vuelve a consultar la auditoría.
   Resultado esperado: además, una fila `DELETE` con `precio_anterior` 1500.00, `precio_nuevo` NULL y `stock_anterior` 5.
3. **Intento de borrar una venta.** Se ejecuta un `DELETE` sobre una venta, dentro de una transacción con `ROLLBACK`.
   Resultado esperado: aparece el mensaje del trigger y la venta sigue estando (el conteo es 1 antes y después).

Resultado obtenido: [COMPLETAR: captura o tabla de `Auditoria_Producto` y de la venta que sigue existiendo]

## 5. Consideraciones

- En un `UPDATE`, `deleted` tiene la fila antes del cambio e `inserted` después; en un `DELETE` solo hay `deleted`.
- Un producto con ventas o promociones no se puede eliminar (sus FK son `ON DELETE NO ACTION`), por eso la prueba usa un producto de prueba y no uno real.
- Los triggers de Producto emparejan `deleted` e `inserted` por `id_producto`, así que se asume que esa clave primaria no se modifica.
- Con `TR_Venta_BloquearDelete` las ventas ya no se eliminan: la definición que había quedado pendiente sobre el borrado físico de ventas queda resuelta a favor de usar el estado `'cancelada'`. Los `ON DELETE CASCADE` de Venta_Detalle, Venta_Pago y Envio dejan de activarse desde Venta.
- SQL Server no permite un `INSTEAD OF DELETE` en una tabla con una FK `ON DELETE CASCADE`. Venta no tiene ninguna (sus FK a Cliente y Vendedor son `ON DELETE NO ACTION`), por eso el trigger se puede crear.
- El DDL de la Etapa III elimina Producto y Venta junto con sus triggers: al volver a ejecutarlo hay que volver a ejecutar este script, y para recargar datos de prueba hay que usar el DDL, no un `DELETE` sobre Venta.
