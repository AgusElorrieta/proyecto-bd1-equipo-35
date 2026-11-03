# Manifiesto individual — Etapa V

**Integrante:** Renato Uriel Roman

**Proyecto:** MateSereño — Base de Datos I

**Etapa:** V — Procedimientos y funciones almacenadas

---

**Qué hice:** me tocó procedimientos y funciones. Hice tres procedimientos para dar de alta, modificar y borrar clientes, y cuatro funciones: total de una venta, saldo pendiente, descuento por cliente y una que devuelve las ventas de un cliente. Cargué un lote de clientes con INSERT y otro con el procedimiento, y comparé cuánto tarda cada forma con mil altas.

**Cómo lo resolví:** empecé por el alta, porque la regla más importante es que no se repita el teléfono. El procedimiento busca el próximo id y revisa el teléfono antes de insertar. Para el borrado puse que no deje eliminar un cliente con ventas, porque si no quedarían ventas sin dueño. Las funciones las saqué de la consulta de totales de la Etapa IV, que ya sabía que daba bien. La prueba de las mil altas la hice dentro de una transacción con ROLLBACK para no ensuciar la base.

Cuando lo corrí, las mil altas directas tardaron 27 ms y por procedimiento 53 ms. Los totales y saldos me dieron igual que en la Etapa IV, así que las funciones estaban bien.

**Lo que aprendí:** que el procedimiento tarda casi el doble, pero igual es muy poco y te asegura que no entre un teléfono repetido. También que una función no puede modificar datos, solo devolver algo.
