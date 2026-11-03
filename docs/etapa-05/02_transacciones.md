# Etapa V - Manejo de transacciones

**Equipo:** 35  
**Caso:** MateSereño  
**Responsable:** Agustín Elorrieta  
**Motor:** Microsoft SQL Server 2022 Express  
**Script:** `sql/tecnico/02_transacciones.sql`

## 1. Definición y objetivo

Una transacción es un conjunto de operaciones que SQL Server trata como una única unidad. Si se produce un error, se revierten todas las modificaciones mediante `ROLLBACK`. Las propiedades ACID ayudan a mantener la base de datos consistente.

El objetivo en MateSereño es que una venta no pueda quedar registrada a medias: deben completarse el encabezado, el detalle y el descuento del stock, o no debe conservarse ninguno de esos cambios.

## 2. Ventajas y aplicaciones

- **Atomicidad:** evita que quede una venta sin detalle o sin actualización de stock.
- **Consistencia:** respeta las claves, las restricciones y el stock no negativo.
- **Aislamiento:** se bloquea el producto mientras se toma el precio y se actualiza el stock, disminuyendo conflictos entre operaciones simultáneas.
- **Durabilidad:** una venta confirmada con `COMMIT` se mantiene registrada.
- **Mantenimiento:** la lógica de registro queda centralizada en un procedimiento almacenado.

## 3. Implementación en SQL Server Express

Se implementó `dbo.sp_RegistrarVentaTransaccional`, que recibe identificadores de venta, cliente, vendedor y producto, además de cantidad, fecha, comprobante y descuento.

El procedimiento utiliza `BEGIN TRY / BEGIN CATCH`, `BEGIN TRANSACTION`, `COMMIT TRANSACTION`, `ROLLBACK TRANSACTION`, `THROW` y `SET XACT_ABORT ON`. La secuencia es:

1. Validar la cantidad y el descuento.
2. Leer el precio del producto activo con `UPDLOCK` y `HOLDLOCK`.
3. Insertar el encabezado en `Venta`.
4. Insertar un renglón en `Venta_Detalle`, guardando el precio histórico.
5. Descontar el stock con un `UPDATE` condicionado a que alcance la cantidad.
6. Confirmar mediante `COMMIT`, o deshacer mediante `ROLLBACK` si falla alguna parte.

**Particularidades del modelo:** `Venta.id_venta` no es `IDENTITY`, por eso se indica manualmente. La demostración registra un solo renglón por comprobante. El descuento es un monto fijo, no un porcentaje. Las fechas DATETIME de prueba se escriben en formato ISO con `T`.

También se incluye una prueba independiente de transacciones anidadas. En SQL Server, un segundo `BEGIN TRANSACTION` incrementa `@@TRANCOUNT`, pero su `COMMIT` no confirma de forma autónoma los cambios. `SAVE TRANSACTION` permite deshacer únicamente la parte realizada después del punto de guardado.

## 4. Caso concreto aplicado al sistema de ventas

Se utiliza el producto 2 (**Bombilla de Alpaca**) para una venta de dos unidades. En la base que verificamos en SSMS el 03/11/2026, su stock inicial era **10**, por lo que se espera observar **8** unidades dentro de la transacción exitosa y nuevamente **10** después de revertir la demostración.

Se prueban además dos fallos: vender 999 unidades sin stock suficiente y generar intencionalmente un error justo después de insertar el encabezado. En ambos casos, deben quedar cero registros nuevos en `Venta` y `Venta_Detalle`, sin alterarse el stock.

Por último, se utiliza el producto 6 (**Yerba Premium 1 kg**, stock inicial **20**) para demostrar `BEGIN TRANSACTION`, un segundo `BEGIN`, `SAVE TRANSACTION`, `ROLLBACK` parcial y lectura de `@@TRANCOUNT`. Los stocks esperados en los pasos son **20 → 19 → 19 → 17 → 19 → 19 → 20**; los niveles de transacción son **0 → 1 → 1 → 2 → 2 → 1 → 0**.

**Importante:** las demostraciones se revierten para no modificar permanentemente los datos de prueba. La venta exitosa se observa antes del `ROLLBACK` exterior.

## 5. Script de demostración y resultados obtenidos

**Archivo:** `sql/tecnico/02_transacciones.sql`.  
**Fecha de prueba:** 03/11/2026.  
**Entorno:** SQL Server Express, base `MateSerenoDB`, ejecución desde SQL Server Management Studio (SSMS).

| Prueba | Resultado esperado | Resultado observado en SSMS |
|---|---|---|
| 1. Venta correcta (producto 2, dos unidades) | Insertar encabezado y detalle y reducir stock de 10 a 8 dentro de la transacción | Se visualizó la venta `95001`, producto 2, cantidad 2, precio unitario $12.000 y stock 8; `@@TRANCOUNT = 1` en la transacción exterior. **Correcto.** |
| 1. Reversión de la demostración | Recuperar stock 10 y no dejar venta ni detalle | Stock final 10; consultas de conteo: 0 encabezados y 0 detalles. **Correcto.** |
| 2. Stock insuficiente (999 unidades) | Capturar el error y revertir toda la venta | SSMS mostró el error controlado **51006**: «Stock insuficiente: se deshace toda la venta». El control posterior confirmó que no quedaron ventas de prueba. **Correcto.** |
| 3. Error provocado tras insertar `Venta` | Capturar error 51005, revertir encabezado, dejar stock sin cambios | La comprobación final mostró **0 encabezados y 0 detalles** para la venta `95003` y stock del producto 6 igual a 20. **Falta registrar captura del mensaje 51005** para acreditar la causa exacta del error. |
| 4. Transacciones anidadas y `SAVE TRANSACTION` | Revertir la actualización interna y finalmente restaurar el stock | Secuencia observada de stock: **20 → 20 → 19 → 17 → 19 → 19 → 20**; `@@TRANCOUNT`: **0 → 1 → 1 → 2 → 2 → 1 → 0**. **Correcto.** |

**Verificación final independiente:** al terminar la ejecución, se consultaron los productos 2 y 6 y se observaron stocks de **10** y **20**, respectivamente. Las búsquedas de las ventas de prueba **95001, 95002 y 95003**, y de sus detalles, no devolvieron filas. `OBJECT_ID('dbo.sp_RegistrarVentaTransaccional','P')` devolvió el valor no nulo **18099105**, confirmando que el procedimiento quedó creado.

Las pruebas de demostración usan `ROLLBACK` exterior o un `ROLLBACK` por error para no conservar ventas ficticias. El procedimiento queda disponible para su uso posterior. Los resultados están basados en las capturas de SSMS; **no se atribuye al error forzado un número de error hasta verificarlo visualmente**.
