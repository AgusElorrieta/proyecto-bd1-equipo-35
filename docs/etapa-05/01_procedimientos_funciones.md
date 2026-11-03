# Procedimientos y funciones almacenadas

Script: `sql/tecnico/01_procedimientos_funciones.sql`

## 1. Definición y objetivo

Un **procedimiento almacenado** es un bloque de T-SQL guardado en la base con un nombre, que recibe parámetros y se ejecuta con `EXEC`. Puede insertar, modificar o borrar datos y controlar errores.

Una **función** también se guarda en la base, pero devuelve un valor (escalar) o una tabla, y se usa dentro de un `SELECT`. No puede modificar datos.

El objetivo en MateSereño es que las altas, cambios y bajas de clientes pasen siempre por las mismas reglas, y que los cálculos que se repiten (total de una venta, saldo, descuento) estén escritos una sola vez.

## 2. Ventajas y aplicaciones

- Las reglas quedan guardadas en la base, no dependen de quien haga la consulta.
- Se puede dar permiso de ejecutar un procedimiento sin dar permiso sobre la tabla (lo usa el tema de seguridad).
- El plan de ejecución se reutiliza.
- No hay que repetir código: el total de una venta de la Etapa IV ahora es una función.

## 3. Implementación en SQL Server Express

| Objeto | Tipo | Qué hace |
|---|---|---|
| `sp_InsertarCliente` | Procedimiento | Calcula el próximo `id_cliente` (con `UPDLOCK`) y rechaza un teléfono repetido (RN-01). |
| `sp_ModificarCliente` | Procedimiento | Cambia solo los datos que se pasan; los que van en NULL quedan como estaban. |
| `sp_EliminarCliente` | Procedimiento | Borra un cliente solo si no tiene ventas. |
| `fn_TotalVenta` | Función escalar | Suma cantidad × precio unitario − descuento de los detalles de una venta. |
| `fn_SaldoPendiente` | Función escalar | Total menos lo pagado; 0 si la venta está cancelada. |
| `fn_DescuentoCliente` | Función escalar | 10 % si compró más de $80.000, 5 % si más de $50.000. |
| `fn_VentasDeCliente` | Función de tabla | Devuelve las ventas de un cliente con total y saldo. |

Los errores se lanzan con `THROW 50000`, así el mensaje aparece claro en SSMS.

## 4. Caso aplicado a MateSereño

- **Lote con INSERT directo:** clientes 9 a 12.
- **Lote por procedimiento:** clientes 13 a 16 con `EXEC sp_InsertarCliente`.
- **Teléfono repetido:** se intenta cargar un cliente con el 3794111111 (de Juan Pérez) y el procedimiento lo rechaza.
- **Modificación:** al cliente 10 se le cargó email y se lo pasó a Corrientes; al 16 se le cambió el teléfono.
- **Baja:** el 12 se borra sin problema; el 1 no, porque tiene ventas.

## 5. Resultados obtenidos

Mensajes de error esperados:

```
Mensaje 50000 ... sp_InsertarCliente: Ya existe un cliente con el telefono 3794111111.
Mensaje 50000 ... sp_EliminarCliente: El cliente 1 tiene ventas registradas y no se puede eliminar.
```

Totales y saldos con las funciones:

| Venta | Estado | Total | Saldo |
|---|---|---|---|
| FC-0001 | entregada | 35.000 | 0 |
| FC-0002 | pagada | 16.000 | 0 |
| FC-0003 | seniada | 93.500 | 26.000 |
| FC-0004 | entregada | 61.000 | 0 |
| FC-0005 | seniada | 25.500 | 12.750 |
| FC-0006 | cancelada | 24.000 | 0 |
| FC-0007 | seniada | 66.500 | 47.000 |
| FC-0008 | entregada | 7.500 | 0 |

Descuentos: Carlos López 10 %, Ana Martínez 5 %, Diego Romero 5 %, el resto 0 %.

`fn_VentasDeCliente(3)` devuelve la FC-0003 con total 93.500 y saldo 26.000.

### Comparación de eficiencia

Mil altas de clientes dentro de una transacción que después se deshace (no queda ningún cliente de prueba: `clientes_de_prueba_que_quedaron = 0`).

| Forma | Tiempo |
|---|---|
| INSERT directo | 27 ms |
| Por `sp_InsertarCliente` | 53 ms |

El procedimiento tarda casi el doble porque por cada alta busca el próximo id y revisa que el teléfono no exista. Igual es muy poco, unos 0,03 ms por cliente, y a cambio no entra nunca un teléfono repetido.

Para los totales, el cálculo directo con `SUM` y con `fn_TotalVenta` dieron 0–1 ms: con 8 ventas no hay diferencia. Con muchas filas la función escalar sería más lenta, porque se ejecuta una vez por fila.

## Conclusiones

Para altas, cambios y bajas que tienen reglas (como no repetir el teléfono) conviene usar procedimientos aunque tarden un poco más. Las funciones hacen las consultas más cortas, pero si la tabla es muy grande es mejor hacer el cálculo directo.
