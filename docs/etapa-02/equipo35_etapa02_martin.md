Manifiesto Individual - Etapa II: Modelado Conceptual y Lógico

Integrante: Martin Espinoza  


1. Qué hice y en qué participé

    Revisión de consistencia: revisión integral de la consistencia entre el Diagrama Entidad-Relación (DER) y la transformación al Modelo Relacional del proyecto.

    Validación de reglas de negocio: Colaboré en la validación de que las restricciones y la estructura lógica reflejaran fielmente las reglas del dominio (como el manejo de pagos fraccionados y productos únicos).

3. Qué decisiones ayudé a tomar

   Clave primaria propia en venta_pago: Modificamos la idea inicial de una clave compuesta (id_venta + metodo_pago_id) para incorporar un id propio (id_venta_pago). Esto permitió cumplir con la regla de negocio que autoriza pagos múltiples usando el mismo método de pago en fechas distintas (ej. seña y saldo por transferencia).

   Clave compuesta en venta_detalle: Se mantuvo la clave compuesta (id_venta + nro_renglon) ya que cada detalle depende existencialmente de la venta y numera sus renglones correspondientes.

   Integridad referencial y cascadas (ON DELETE CASCADE): Definimos las reglas de borrado en cascada para las tablas dependientes de la venta (venta_detalle, venta_pago y envio), protegiendo al mismo tiempo las entidades maestras (cliente, vendedor, producto y categoría).

   Opcionalidad del cliente y exclusividad del envío: Se configuró id_cliente como opcional (permite ventas de mostrador sin registrar cliente) y se estableció una relación 1:1 con restricción UNIQUE en la tabla envio para evitar duplicados en una misma venta.

   Dependencia de promocion: Se estructuró para que dependa obligatoriamente de un producto_id, manteniendo un historial coherente.

4. Qué problema encontré / resolví
   Conflicto en pagos múltiples: Detectamos que restringir los pagos con una clave compuesta impedía registrar abonos sucesivos mediante el mismo medio de pago. La solución del identificador independiente resolvió esta limitación transaccional del negocio.

5. Enlaces o referencias a la evidencia en GitHubCommits y archivos asociados en el repositorio
      Subida y actualización del DER y del Esquema Relacional de la Etapa II.
      Registro de modificaciones en las restricciones de tablas y claves foráneas.

6. Qué aprendí
       Comprendí la importancia de alinear estrictamente las decisiones de diseño lógico con las reglas operativas del mundo real (como los pagos parciales y las políticas de stock), evitando que restricciones técnicas rígidas bloqueen transacciones válidas del negocio.
