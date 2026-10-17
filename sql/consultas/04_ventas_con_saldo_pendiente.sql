-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa IV - Consulta de ventas con saldo pendiente
-- Responsable: Emmanuel David Otero
-- Revision: Renato Roman (el detalle se suma por venta en una
--           subconsulta, para que funcione con varios renglones)
-- Motor: Microsoft SQL Server 2022
-- =========================================================
USE MateSerenoDB;
GO

-- =========================================================
-- VENTAS SEÑADAS CON SALDO PENDIENTE DE COBRO
-- Muestra cliente, total de la venta, monto pagado y saldo
-- restante para las ventas señadas que aún no se cancelaron
-- en su totalidad (deben salir las ventas 3, 5 y 7).
-- =========================================================
SELECT
    v.id_venta,
    v.comprobante,
    v.fecha_hora,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    v.estado,

    -- Total de la venta (neto de todos los renglones + costo de envío)
    d.neto + ISNULL(e.costo_envio, 0) AS total_venta,

    -- Suma de los pagos registrados para la venta
    SUM(vp.importe) AS total_pagado,

    -- Saldo pendiente por cobrar
    d.neto + ISNULL(e.costo_envio, 0) - SUM(vp.importe) AS saldo_pendiente
FROM Venta v
INNER JOIN Cliente c
    ON v.id_cliente = c.id_cliente
-- El detalle se suma antes, en una subconsulta: una fila por venta.
-- Si se une Venta_Detalle directo, una venta con varios renglones
-- se parte en varios grupos y el total sale por renglón.
INNER JOIN (
    SELECT id_venta,
           SUM(cantidad * precio_unitario - descuento_aplicado) AS neto
    FROM Venta_Detalle
    GROUP BY id_venta
) d
    ON v.id_venta = d.id_venta
INNER JOIN Venta_Pago vp
    ON v.id_venta = vp.id_venta
LEFT JOIN Envio e
    ON v.id_venta = e.id_venta
WHERE v.estado = 'seniada'
GROUP BY
    v.id_venta,
    v.comprobante,
    v.fecha_hora,
    c.nombre,
    c.apellido,
    v.estado,
    d.neto,
    e.costo_envio
HAVING SUM(vp.importe) < d.neto + ISNULL(e.costo_envio, 0)
ORDER BY v.id_venta;
GO
