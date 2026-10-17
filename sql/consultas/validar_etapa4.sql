-- =========================================================
-- Proyecto Base de Datos I - Equipo 35 - MateSereño
-- Etapa IV - Validacion de las consultas
-- Responsable: Renato Roman
-- Ejecutar con la base cargada (crear_bd.sql + datos_prueba.sql)
-- =========================================================
USE MateSerenoDB;
GO

-- ---------------------------------------------------------
-- PRUEBA 1: totales de venta (lo que tiene que dar el comprobante)
-- Esperado: 35000, 16000, 93500, 61000, 25500, 24000, 66500, 7500
-- ---------------------------------------------------------
SELECT v.id_venta, v.comprobante, v.estado,
       SUM(d.cantidad * d.precio_unitario - d.descuento_aplicado) AS neto,
       ISNULL(e.costo_envio, 0) AS envio,
       SUM(d.cantidad * d.precio_unitario - d.descuento_aplicado)
         + ISNULL(e.costo_envio, 0) AS total
FROM Venta v
     INNER JOIN Venta_Detalle d ON d.id_venta = v.id_venta
     LEFT  JOIN Envio e         ON e.id_venta = v.id_venta
GROUP BY v.id_venta, v.comprobante, v.estado, e.costo_envio
ORDER BY v.id_venta;
GO

-- ---------------------------------------------------------
-- PRUEBA 2: caso de borde, una venta senada con dos renglones.
-- Se agrega un segundo producto a la venta 3 DENTRO de una
-- transaccion y al final se deshace con ROLLBACK, asi el dato
-- no queda en la base.
--
-- Esperado para la venta 3: total 101500, pagado 67500, falta 34000.
-- La version original de la consulta 04 devolvia 93500 y 26000,
-- porque agrupaba por renglon y no por venta.
-- ---------------------------------------------------------
BEGIN TRANSACTION;

INSERT INTO Venta_Detalle (id_venta, nro_renglon, id_producto, cantidad, precio_unitario, descuento_aplicado)
VALUES (3, 2, 6, 1, 8000.00, 0.00);

SELECT v.id_venta,
       v.comprobante,
       d.neto + ISNULL(e.costo_envio, 0)                   AS total_venta,
       SUM(vp.importe)                                     AS total_pagado,
       d.neto + ISNULL(e.costo_envio, 0) - SUM(vp.importe) AS saldo_pendiente
FROM Venta v
     INNER JOIN (SELECT id_venta,
                        SUM(cantidad * precio_unitario - descuento_aplicado) AS neto
                 FROM Venta_Detalle
                 GROUP BY id_venta) d ON d.id_venta = v.id_venta
     INNER JOIN Venta_Pago vp ON vp.id_venta = v.id_venta
     LEFT  JOIN Envio e       ON e.id_venta  = v.id_venta
WHERE v.estado = 'seniada'
GROUP BY v.id_venta, v.comprobante, d.neto, e.costo_envio
HAVING SUM(vp.importe) < d.neto + ISNULL(e.costo_envio, 0)
ORDER BY v.id_venta;

ROLLBACK TRANSACTION;
GO

-- Comprobacion de que el ROLLBACK dejo la base como estaba:
-- la venta 3 tiene que volver a tener 1 solo renglon.
SELECT COUNT(*) AS renglones_venta_3 FROM Venta_Detalle WHERE id_venta = 3;
GO
