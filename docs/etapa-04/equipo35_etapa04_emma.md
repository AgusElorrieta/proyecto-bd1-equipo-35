### Contribución individual -- Etapa 04
**Equipo:** 35   **Integrante:** Emmanuel Otero   **Fecha:** 2026-10-17

#### 1. Aporte realizado
En esta etapa me encargué principalmente del desarrollo y prueba de la consulta de negocio avanzada del proyecto 
(`sql/consultas/04_ventas_con_saldo_pendiente.sql`) sobre la base de datos `MateSerenoDB` en SQL Server 2022.
Esta consulta permite identificar las ventas en estado `seniada` que todavía poseen saldo pendiente de cobro, 
mostrando los datos del comprobante, el cliente, el total de la operación (renglones menos descuento más envío), 
el monto ya abonado y el saldo restante a pagar.

#### 2. Decisiones en las que participé
Participé en la definición de la estructura de la consulta para combinar las cinco tablas requeridas 
(`Venta`, `Cliente`, `Venta_Detalle`, `Venta_Pago` y `Envio`) respetando el orden lógico de procesamiento en SQL:
- Se decidió utilizar `WHERE v.estado = 'seniada'` para filtrar tempranamente las filas correspondientes a ventas señadas antes de realizar el agrupamiento.
- Se utilizó `LEFT JOIN` hacia la tabla `Envio` combinado con la función `ISNULL(e.costo_envio, 0)` para contemplar ventas sin costo de envío sin afectar el cálculo aritmético del total.
- Se aplicó la cláusula `HAVING` luego del `GROUP BY` para comparar el resultado agregado `SUM(vp.importe)` contra el total calculado de la venta.

#### 3. Problemas o dificultades identificadas
Una de las principales dificultades fue asegurar que el cálculo del total de la venta en la condición del `HAVING` coincidiera 
exactamente con la lógica de negocio validada en la Etapa III (donde `descuento_aplicado` es un monto fijo y no un porcentaje, 
y al neto del detalle se le debe sumar el `costo_envio`).
Además, fue necesario contemplar qué ocurría en las comparaciones si `costo_envio` resultaba nulo o si no se filtraban previamente 
otros estados como `pendiente` o `cancelada`.

#### 4. Soluciones o propuestas realizadas
Tomé como referencia las reglas verificadas en `verificar_datos.sql` y el formato estandarizado del equipo en `01_comprobante_venta.sql`.
Incorporé la expresión `(vd.cantidad * vd.precio_unitario - vd.descuento_aplicado) + ISNULL(e.costo_envio, 0)` para obtener el total 
exacto de cada venta y la contrasté con `SUM(vp.importe)` tanto en el `SELECT` (para obtener el `saldo_pendiente`) como en la cláusula `HAVING`.
Por último, probé la consulta sobre los datos cargados en `MateSerenoDB` y verifiqué que devolviera correctamente las ventas 3, 5 y 7.

#### 5. Evidencias en el repositorio
Archivos relacionados con mi aporte:
- `sql/consultas/04_ventas_con_saldo_pendiente.sql`
- `docs/etapa-04/equipo35_etapa04_emma.md`

Commit relacionado:
- `Agrega consulta de ventas con saldo pendiente`
- `Agrega manifiesto individual etapa 4`

#### 6. Reflexión individual
En esta etapa pude comprender en la práctica cómo responden las consultas SQL a las problemáticas reales planteadas en la Etapa I, específicamente el control de señas y pagos parciales.
Además, me ayudó a afianzar el uso combinado de múltiples `JOIN`, funciones de agregación (`SUM`), agrupamientos (`GROUP BY`) y la diferencia entre filtrar registros individuales con `WHERE` y filtrar resultados agrupados con `HAVING`.
