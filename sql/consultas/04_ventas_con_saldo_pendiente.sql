-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa IV - Consulta de ventas con saldo pendiente
-- Responsable: Emmanuel David Otero
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

    -- Total de la venta (neto del detalle + costo de envío)
    (vd.cantidad * vd.precio_unitario - vd.descuento_aplicado)
        + ISNULL(e.costo_envio, 0) AS total_venta,

    -- Suma de los pagos registrados para la venta
    SUM(vp.importe) AS total_pagado,

    -- Saldo pendiente por cobrar
    ((vd.cantidad * vd.precio_unitario - vd.descuento_aplicado)
        + ISNULL(e.costo_envio, 0)) - SUM(vp.importe) AS saldo_pendiente
FROM Venta v
INNER JOIN Cliente c
    ON v.id_cliente = c.id_cliente
INNER JOIN Venta_Detalle vd
    ON v.id_venta = vd.id_venta
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
    vd.cantidad,
    vd.precio_unitario,
    vd.descuento_aplicado,
    e.costo_envio
HAVING SUM(vp.importe) < (
    (vd.cantidad * vd.precio_unitario - vd.descuento_aplicado)
    + ISNULL(e.costo_envio, 0)
)
ORDER BY v.id_venta;
GO
