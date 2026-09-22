Normalización:
  1FN - Primera Forma Normal  
      El modelo cumple todo en esta primera forma, cada uno de los 10 atributos toman valores atómicos y cada relación tiene su clave primaria definida.
      CATEGORIA: nombre, descripcion y activa toman un único valor atómico por categoría (texto simple y booleano)
      PRODUCTO: todos sus atributos (nombre, material, precio_lista, stock_actual, dias_demora, etc.) toman un único valor por producto.
      PROMOCION: activa, fecha_inicio, fecha_fin, precio_promocional y nombre son atómicos. Cumple.
      CLIENTE: todos los atributos son atómicos, incluido teléfono (un valor único, no una lista). Cumple.
      VENDEDOR: fecha_ingreso, activo, telefono, apellido y nombre son atómicos. Cumple.
      VENTA: observaciones, estado, fecha_hora y comprobante son atómicos. Cumple.
      VENTA_DETALLE: descuento_aplicado, precio_unitario y cantidad son atómicos; tener clave compuesta por dos atributos simples no viola 1FN. Cumple.
      METODO_PAGO: activo, nombre y recargo_porcentaje son atómicos. Cumple.
      VENTA_PAGO: fecha_pago, tipo_pago e importe son atómicos. Cumple.
      ENVIO: costo_envio, direccion, modalidad, estado_envio, fecha_despacho y codigo_postal son atómicos. Cumple.
      
  2FN - Segunda Forma Normal
      Todos los datos que no son la clave principal deben depender por completo de toda la clave, de todas la relaciones del diagrama la única con clave compuesta es VENTA_DETALLE (nro_renglon, id_venta).}
      CATEGORIA: clave simple (id_categoria) se cumple automáticamente al cumplir 1FN, Cumple.
      PRODUCTO: clave simple (id_producto) cumple automáticamente, Cumple.
      PROMOCION: clave simple (id_promocion) cumple automáticamente, Cumple.
      CLIENTE: clave simple (id_cliente) cumple automáticamente, Cumple.
      VENDEDOR: clave simple (id_vendedor) cumple automáticamente, Cumple.
      VENTA: clave simple (id_venta) cumple automáticamente, Cumple.
      VENTA_DETALLE: Dependen de la clave completa, Cumple.
      METODO_PAGO: clave simple (id_metodo_pago) cumple automáticamente, Cumple.
      VENTA_PAGO: clave simple (id_venta_pago) cumple automáticamente, Cumple.
      ENVIO: clave simple (id_envio) es UNIQUE pero acá no forma parte de la PK como en VENTA_DETALLE, Cumple.

  3FN - Tercera Forma Normal
      En esta forma se fija que ningún atributo no clave determine le valor de otro atributo no clave.
      CATEGORIA: nombre, descripcion y activa son propiedades directas e independientes de la categoría; ninguno determina el valor de otro, Cumple.
      PRODUCTO: codigo es clave candidata (UNIQUE), son datos independientes entre sí, no se identifica que uno determine a otro, Cumple.
      PROMOCION: son atributos propios de esa promoción puntual, fecha_inicio no determina precio_promocional ni viceversa, Cumple.
      CLIENTE: localidad determina provincia (una localidad pertenece siempre a una única provincia), dependencia transitiva entre dos atributos no clave, No Cumple.
      VENDEDOR: son datos propios del vendedor, sin dependencia entre ellos, Cumple.
      VENTA: comprobante es clave candidata (no genera problema). estado y fecha_hora son propios de esa venta puntual, Cumple.
      VENTA_DETALLE: cantidad no determina precio_unitario, dos renglones con la misma cantidad pueden tener descuentos distintos, Cumple.
      METODO_PAGO: nombre no determina recargo_porcentaje ni viceversa, Cumple.
      VENTA_PAGO: tipo_pago es independiente de id_metodo_pago, importe y fecha_pago son propios de ese pago puntual. Ninguno determina a otro, Cumple.
      ENVIO: cadena de dependencias transitivas entre atributos no clave, No Cumple. 
