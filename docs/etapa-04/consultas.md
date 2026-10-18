# Documentación de Consultas y Casos de Uso — Etapa IV
**Proyecto:** MateSereño - Equipo 35

A continuación se detalla la resolución de las necesidades de información exigidas, indicando la estrategia en SQL Server y el resultado esperado para cada script alojado en `sql/consultas/`.

### 1. Factura / Comprobante
* **Archivo:** `01_comprobante_venta.sql`
* **Necesidad que resuelve:** Generar el detalle completo de un comprobante de venta, consolidando los datos del cliente, vendedor, los renglones de productos, los subtotales parciales y el total acumulado.
* **Estrategia SQL utilizada:** 
  * Combinación de tablas con **INNER JOIN** y **LEFT JOIN** para incluir ventas a consumidores ocasionales o retiros sin costos de envío predefinidos[cite: 15].
  * Se implementó la función de ventana `SUM(...) OVER (PARTITION BY v.id_venta)`[cite: 13]. Esto permite calcular el subtotal general de la venta y añadirlo como columna sin tener que agrupar toda la consulta con `GROUP BY`, evitando así perder el nivel de detalle de cada producto en la factura.
* **Resultado esperado:** Una tabla donde cada fila representa un renglón del comprobante, mostrando la información general repetida y el detalle específico del producto, con una columna calculada para el total a pagar.

### 2. Reportes Agregados (Rendimiento por Vendedor y Categoría)
* **Archivos:** `02_ventas_por_vendedor.sql` y `03_ventas_por_categoria.sql`
* **Necesidad que resuelve:** Cuantificar el volumen de operaciones, unidades comercializadas y dinero recaudado, agrupado por vendedor y por categoría de producto en un rango de fechas, excluyendo operaciones canceladas.
* **Estrategia SQL utilizada:**
  * Ambos scripts utilizan un **LEFT JOIN** partiendo desde las tablas maestras (`Vendedor` y `Categoria`) para asegurar que los elementos sin ventas aparezcan en el resultado con valor 0 en lugar de ser omitidos[cite: 15].
  * En la consulta 03, las ventas válidas se aislaron previamente utilizando una subconsulta en la cláusula FROM (Tabla Derivada)[cite: 15].
  * Se manejaron las fechas con rangos semiabiertos (`>= @desde AND < DATEADD...`) para capturar correctamente los registros `DATETIME`.
* **Resultado esperado:** Tablas resumen ordenadas de mayor a menor recaudación. Los vendedores y categorías sin actividad reflejan la cantidad `0` gracias al uso de `COALESCE` o `ISNULL`.

### 3. Consulta de Negocio Avanzada (Señas Pendientes)
* **Archivo:** `04_ventas_con_saldo_pendiente.sql`
* **Necesidad que resuelve:** Identificar las ventas en estado "señada" que aún tienen un saldo restante por cobrar, calculando la diferencia entre el valor neto de la venta y la suma de los pagos parciales realizados.
* **Estrategia SQL utilizada:**
  * Uso estratégico de subconsultas. Se detectó que unir directamente la tabla `Venta_Detalle` y `Venta_Pago` generaba un producto cartesiano anómalo si la venta tenía varios productos y varios pagos simultáneos[cite: 19]. Para solucionarlo, se aislaron los cálculos totales de los renglones utilizando una subconsulta en el FROM[cite: 15].
  * Filtrado inicial en la cláusula **WHERE** (`estado = 'seniada'`) para reducir las filas antes de agrupar[cite: 18].
  * Filtro condicional post-agrupamiento usando **HAVING**, evaluando lógicamente que la sumatoria de pagos sea menor al total neto calculado de la subconsulta[cite: 15, 18].
* **Resultado esperado:** Un informe detallado de las operaciones pendientes de cancelación total, mostrando cliente, total facturado, montos entregados y el saldo restante exacto.
