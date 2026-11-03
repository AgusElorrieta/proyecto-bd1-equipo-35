# Manifiesto individual — Etapa V

**Integrante:** Renato Uriel Roman

**Proyecto:** MateSereño — Base de Datos I

**Etapa:** V — Procedimientos y funciones almacenadas

---

**Qué hice:** armé el script de procedimientos y funciones. Hice tres procedimientos para dar de alta, modificar y borrar clientes, y cuatro funciones: total de una venta, saldo pendiente, descuento por cliente y una que devuelve las ventas de un cliente. Cargué un lote de clientes con INSERT y otro con el procedimiento, y comparé cuánto tarda cada forma con mil altas.

**Cómo lo resolví:** empecé por el alta, porque la regla más importante es que no se repita el teléfono. El procedimiento busca el próximo id y revisa el teléfono antes de insertar. Para el borrado puse que no deje eliminar un cliente con ventas, porque si no quedarían ventas sin dueño. Las funciones las saqué de la consulta de totales de la Etapa IV, que ya sabía que daba bien. La prueba de las mil altas la hice dentro de una transacción con ROLLBACK para no ensuciar la base.

**Resultados:** el INSERT directo tardó 27 ms y el procedimiento 53 ms. Los totales y saldos dieron igual que en la Etapa IV.

**Lo que aprendí:** que un procedimiento es más lento que un INSERT directo, pero la diferencia es mínima y a cambio te asegura que se cumplan las reglas. También que una función no puede modificar datos, solo devolver un resultado.
