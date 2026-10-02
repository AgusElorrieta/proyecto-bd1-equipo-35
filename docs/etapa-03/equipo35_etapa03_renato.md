# Manifiesto individual — Etapa III

**Integrante:** Renato Uriel Roman  
**DNI:** 45.844.979  
**Equipo:** 35  
**Proyecto:** MateSereño — Base de Datos I  
**Etapa:** III

**Qué hice:** me tocó revisar los datos de prueba del archivo sql/dml/datos_prueba.sql. Primero quise ejecutar el DDL para levantar la base y me encontré con que no corría, así que lo corregí en mi copia local para poder seguir. Una vez creada la base cargué el DML y verifiqué con COUNT que las diez tablas quedaran con 8 registros cada una. Después fui controlando que los datos cerraran entre sí: que los IDs de las claves foráneas existieran en la tabla referenciada, que los importes de los pagos coincidieran con el total de cada venta, que las señas fueran el porcentaje que tiene cargado el producto y que el estado de cada venta se correspondiera con lo que figuraba cobrado.

**En qué participé:** en el control de calidad de la etapa, revisando el poblado de la base y corrigiendo las inconsistencias que encontré.

**Qué decisión ayudé a tomar:** cómo calcular el importe que se registra en Venta_Pago. Quedó que el pago tiene que coincidir con el neto del renglón menos el descuento más el costo del envío, porque antes había pagos cargados contra el precio de lista sin descontar nada. También quedó que una venta cancelada no puede tener pagos asociados, ya que el modelo no tiene forma de representar una devolución.

**Qué problema encontré/resolví:** encontré seis problemas y los corregí.

1. En la venta 2 el renglón tenía 19000 con un descuento de 3000, o sea 16000 netos, pero el pago estaba cargado por 19000. Lo bajé a 16000.
2. La venta 4 tenía un envío de 6000 que no estaba sumado en el pago. Pasé el importe de 55000 a 61000.
3. La venta 8 arrastraba los dos errores juntos: no restaba el descuento de 1000 ni sumaba el envío de 5000. El pago quedó en 7500.
4. La venta 5 figuraba como pendiente pero tenía un pago de tipo seña de 1000, que no es ningún porcentaje del total. La pasé a seniada y puse la seña en 12750, que es el 50% de los 25500 que suma la venta.
5. La venta 6 está cancelada y tenía igual un pago de 16000 registrado. Lo saqué, y para no perder el registro reasigné esa fila como un pago de saldo de 25000 sobre la venta 3, que estaba señada. Así queda además un caso de venta con dos pagos en fechas distintas, que es lo que justifica que Venta_Pago sea una entidad asociativa.
6. Este lo encontré recién al ejecutar. El INSERT de Venta cortaba con el error 242, que la conversión de varchar a datetime daba un valor fuera de intervalo, y atrás caían Venta_Detalle, Venta_Pago y Envio por clave foránea. Las fechas estaban escritas como '2026-09-10 10:30:00' y la columna fecha_hora es DATETIME. Para ese tipo SQL Server interpreta el literal según el idioma de la instancia, y la mía está en español, o sea día/mes/año, entonces leía 2026 como día y se iba de rango. Las fechas de Cliente y Vendedor no fallaban porque esas columnas son DATE y ahí el formato AAAA-MM-DD se lee siempre igual. Lo resolví poniendo las fechas en ISO 8601 con la T en el medio, '2026-09-10T10:30:00', que es independiente del idioma y entra bien en cualquier instancia.

Los errores del DDL que mencioné al principio son estos. Faltaban dos comas entre restricciones, una en Producto entre CK_Producto_PorcentajeSenia y CK_Producto_SeniaConsistente, y otra en Venta_Detalle entre CK_VentaDetalle_Descuento y CK_VentaDetalle_DescuentoMaximo. Además faltaba un paréntesis de cierre en el CHECK de CK_Producto_SeniaConsistente y el script arranca con USE MateSerenoDB sin crear antes la base. Lo avisé al grupo para que lo corrija quien armó el DDL.

**Enlaces a GitHub:**
- Commit: (completar)
- Pull request: no aplica, se subió directo a main

**Qué aprendí:** que un script puede correr sin dar ningún error y aun así tener los datos mal. El motor te controla que la clave foránea exista y que el importe sea mayor a cero, pero no se da cuenta de que una venta cancelada tenga un pago encima, ni de que el importe cobrado no coincida con lo que dice el detalle. Esas reglas quedan afuera de lo declarativo y hay que verificarlas a mano o con triggers.

Lo del formato de fecha me sorprendió, porque es un error que no se ve leyendo el script. Depende del idioma que tenga configurado la instancia, así que a un compañero le puede andar y a vos no. Desde ahora las fechas con hora las escribo siempre en ISO 8601.

Y me quedó claro que los datos de prueba no son relleno. Si están mal cargados, las consultas de la Etapa IV van a devolver números que no cierran y el error va a aparecer recién ahí, cuando sea más difícil de encontrar. Para no revisar a ojo armé un script de verificación con los COUNT, el total de cada venta contra lo cobrado, las señas contra el porcentaje del producto, las claves foráneas huérfanas y las promociones superpuestas.
