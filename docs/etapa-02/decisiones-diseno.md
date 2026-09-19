# Decisiones de diseño — Etapa II

Estas son las decisiones que fuimos tomando al pasar el DER de MateSereño al modelo relacional.

## venta_pago con id propio

Al principio la idea era que la PK de venta_pago fuera la combinación de id_venta y metodo_pago_id, pero nos dimos cuenta que eso rompía una regla del negocio: una venta se puede pagar en partes usando el mismo método más de una vez (por ejemplo seña por transferencia un día y el saldo por transferencia en otro día). Con esa clave compuesta no se podía cargar el segundo pago porque ya existía esa combinación. La solución fue agregarle un id propio (id_venta_pago) como PK y dejar id_venta y metodo_pago_id solo como FK.

## venta_detalle con clave compuesta

Acá sí dejamos la clave compuesta, id_venta + nro_renglon, porque cada detalle depende directamente de una venta, no existe uno sin la otra. El nro_renglon numera los productos dentro de esa venta y junto con el id_venta identifica cada fila.

## Baja en cascada

venta_detalle, venta_pago y envio dependen de venta, entonces si se borra una venta se tienen que borrar también sus detalles, pagos y envío. Por eso pusimos ON DELETE CASCADE en esas tres relaciones. En el resto de las tablas no, porque cliente, vendedor, producto y categoría son cosas que tienen que seguir existiendo aunque se borre una venta puntual.

## Cliente opcional en venta

id_cliente en venta lo dejamos como FK que puede ser null, porque el negocio permite vender sin registrar el cliente (venta mostrador). El vendedor en cambio sí es obligatorio siempre.

## Envío 1 a 1 con venta

Una venta tiene como mucho un envío, entonces venta_id en envio lo pusimos como FK y también UNIQUE, para que no se pueda cargar dos veces un envío para la misma venta.

## Promoción depende de producto

promocion tiene su propia PK pero necesita sí o sí un producto_id, porque una promoción no existe sin estar asociada a un producto. Al revés no, un producto puede no tener ninguna promoción y no pasa nada.
