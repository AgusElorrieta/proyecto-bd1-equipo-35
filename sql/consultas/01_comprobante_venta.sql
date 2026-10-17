
-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa IV - Consulta de comprobante de venta
-- Responsable: Agustin
-- Motor: Microsoft SQL Server 2022
-- =========================================================

USE MateSerenoDB;
GO

-- Cambiar este valor para consultar otra venta.
DECLARE @id_venta INT = 1;

-- =========================================================
-- COMPROBANTE DE VENTA
-- Encabezado, detalle, subtotales y total final.
-- =========================================================

SELECT
    -- Datos generales de la venta
    v.id_venta,
    v.comprobante,
    v.fecha_hora,

    CASE
        WHEN c.id_cliente IS NULL
            THEN 'Consumidor ocasional'
        ELSE CONCAT(c.nombre, ' ', c.apellido)
    END AS cliente,

    CONCAT(ve.nombre, ' ', ve.apellido) AS vendedor,
    v.estado,

    -- Detalle de los productos
    vd.nro_renglon,
    p.codigo AS codigo_producto,
    p.nombre AS producto,
    vd.cantidad,
    vd.precio_unitario,
    vd.descuento_aplicado,

    -- Subtotal de cada renglón
    (vd.cantidad * vd.precio_unitario
        - vd.descuento_aplicado) AS subtotal_renglon,

    -- Suma de todos los renglones de la venta
    SUM(
        vd.cantidad * vd.precio_unitario
        - vd.descuento_aplicado
    ) OVER (
        PARTITION BY v.id_venta
    ) AS subtotal_venta,

    -- Costo de envío (0 si no tiene)
    ISNULL(e.costo_envio, 0) AS costo_envio,

    -- Total final incluyendo el envío
    SUM(
        vd.cantidad * vd.precio_unitario
        - vd.descuento_aplicado
    ) OVER (
        PARTITION BY v.id_venta
    ) + ISNULL(e.costo_envio, 0) AS total_final

FROM Venta v

LEFT JOIN Cliente c
    ON v.id_cliente = c.id_cliente

INNER JOIN Vendedor ve
    ON v.id_vendedor = ve.id_vendedor

INNER JOIN Venta_Detalle vd
    ON v.id_venta = vd.id_venta

INNER JOIN Producto p
    ON vd.id_producto = p.id_producto

LEFT JOIN Envio e
    ON v.id_venta = e.id_venta

WHERE v.id_venta = @id_venta

ORDER BY vd.nro_renglon;
GO
