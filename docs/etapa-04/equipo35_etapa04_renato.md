# Contribución individual – Etapa IV

**Equipo:** 35  
**Integrante:** Renato Uriel Roman  
**DNI:** 45.844.979  
**Fecha:** 17/10/2026

## 1. Aporte realizado

Hice el reporte de ventas por categoría (`sql/consultas/03_ventas_por_categoria.sql`) y revisé las consultas de mis compañeros.

El reporte muestra por cada categoría cuántas ventas tuvo, cuántas unidades se vendieron y el total facturado entre dos fechas. No cuenta las ventas canceladas.

Para revisar las otras consultas las corrí con los datos de prueba de la etapa anterior. Como en la Etapa III ya había controlado los importes de cada venta, sabía qué números tenían que salir. El comprobante de Agustín y el reporte por vendedor de Lucas dieron bien. La de saldo pendiente también daba bien, pero le encontré un problema que explico más abajo.

## 2. Decisiones en las que participé

Arranqué la consulta desde la tabla Categoria con LEFT JOIN para que aparezcan también las categorías que no vendieron nada, con 0. Si no, Bombillas Acero y Yerberas no salían en el reporte.

Las ventas que se cuentan (sin canceladas y dentro de las fechas) las filtré en una subconsulta aparte. Si ese filtro va en el WHERE, las categorías sin ventas desaparecen igual.

Para las fechas no usé BETWEEN porque fecha_hora es DATETIME y la venta del 17/09 a las 17:00 quedaba afuera. Lo hice con `fecha_hora >= @desde AND fecha_hora < DATEADD(DAY, 1, @hasta)`.

## 3. Problemas que encontré

La consulta de saldo pendiente agrupaba por los datos de cada renglón (cantidad, precio y descuento). Con los datos que tenemos no se nota, porque todas las ventas tienen un solo producto. Pero si una venta tiene dos productos, el total sale mal.

Para probarlo le agregué un segundo producto a la venta 3. El total tenía que pasar a 101500 y el saldo a 34000, y la consulta seguía mostrando 93500 y 26000.

## 4. Cómo lo resolví

Cambié la consulta para que primero sume el detalle de cada venta en una subconsulta y después lo junte con los pagos. Dejé el HAVING que había usado Ema. Ahora con el producto agregado da 101500 y 34000, y con los datos normales sigue dando lo mismo que antes.

La prueba la hice dentro de una transacción con ROLLBACK para que el producto agregado no quede guardado en la base. La dejé en un script por si alguien la quiere repetir.

## 5. Lo que aprendí

Que la consulta dé bien con los datos de prueba no quiere decir que esté bien. Hay que pensar qué casos todavía no están cargados y probarlos.

También que no conviene juntar en el mismo JOIN los renglones y los pagos de una venta, porque se multiplican las filas entre sí. Es mejor sumar cada cosa por separado y después unirlas.
