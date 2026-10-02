-- =========================================================
-- Proyecto Base de Datos I - Equipo 35 - MateSereño
-- Etapa III - Verificacion de los datos de prueba
-- Ejecutar DESPUES de crear_bd.sql y datos_prueba.sql
-- =========================================================

USE MateSerenoDB;
GO

-- 1) Cantidad de registros por tabla. Las diez tienen que dar 8.
SELECT 'Categoria' AS tabla, COUNT(*) AS registros FROM Categoria
UNION ALL SELECT 'Producto',      COUNT(*) FROM Producto
UNION ALL SELECT 'Promocion',     COUNT(*) FROM Promocion
UNION ALL SELECT 'Cliente',       COUNT(*) FROM Cliente
UNION ALL SELECT 'Vendedor',      COUNT(*) FROM Vendedor
UNION ALL SELECT 'Metodo_Pago',   COUNT(*) FROM Metodo_Pago
UNION ALL SELECT 'Venta',         COUNT(*) FROM Venta
UNION ALL SELECT 'Venta_Detalle', COUNT(*) FROM Venta_Detalle
UNION ALL SELECT 'Venta_Pago',    COUNT(*) FROM Venta_Pago
UNION ALL SELECT 'Envio',         COUNT(*) FROM Envio;
GO


-- 2) Total de cada venta contra lo efectivamente cobrado.
--    La columna control tiene que decir OK en las ocho filas.
SELECT  v.id_venta,
        v.comprobante,
        v.estado,
        d.cantidad * d.precio_unitario - d.descuento_aplicado AS neto,
        e.costo_envio,
        d.cantidad * d.precio_unitario - d.descuento_aplicado + e.costo_envio AS total,
        ISNULL(p.cobrado, 0) AS cobrado,
        CASE
            WHEN v.estado = 'cancelada' AND ISNULL(p.cobrado,0) > 0
                THEN 'ERROR: cancelada con pago'
            WHEN v.estado = 'pendiente' AND ISNULL(p.cobrado,0) > 0
                THEN 'ERROR: pendiente con pago'
            WHEN v.estado IN ('pagada','entregada')
                 AND ISNULL(p.cobrado,0) <> d.cantidad * d.precio_unitario
                                          - d.descuento_aplicado + e.costo_envio
                THEN 'ERROR: cobrado no coincide con el total'
            WHEN v.estado = 'seniada'
                 AND NOT (ISNULL(p.cobrado,0) > 0
                     AND ISNULL(p.cobrado,0) < d.cantidad * d.precio_unitario
                                             - d.descuento_aplicado + e.costo_envio)
                THEN 'ERROR: senia fuera de rango'
            ELSE 'OK'
        END AS control
FROM Venta v
     INNER JOIN Venta_Detalle d ON d.id_venta = v.id_venta
     INNER JOIN Envio         e ON e.id_venta = v.id_venta
     LEFT  JOIN (SELECT id_venta, SUM(importe) AS cobrado
                 FROM Venta_Pago GROUP BY id_venta) p ON p.id_venta = v.id_venta
ORDER BY v.id_venta;
GO


-- 3) Senias contra el porcentaje que tiene cargado cada producto.
SELECT  v.id_venta,
        pr.nombre                AS producto,
        pr.porcentaje_senia,
        pr.precio_lista,
        pr.precio_lista * pr.porcentaje_senia / 100 AS senia_esperada,
        vp.importe                                   AS senia_cargada,
        CASE WHEN vp.importe = pr.precio_lista * pr.porcentaje_senia / 100
             THEN 'OK' ELSE 'REVISAR' END AS control
FROM Venta_Pago vp
     INNER JOIN Venta         v  ON v.id_venta    = vp.id_venta
     INNER JOIN Venta_Detalle d  ON d.id_venta    = v.id_venta
     INNER JOIN Producto      pr ON pr.id_producto = d.id_producto
WHERE vp.tipo_pago = 'senia' AND pr.requiere_senia = 1;
GO


-- 4) Claves foraneas huerfanas. Las cuatro consultas tienen que dar 0 filas.
SELECT 'Producto sin categoria' AS problema, p.id_producto AS id
FROM Producto p LEFT JOIN Categoria c ON c.id_categoria = p.id_categoria
WHERE c.id_categoria IS NULL
UNION ALL
SELECT 'Venta sin vendedor', v.id_venta
FROM Venta v LEFT JOIN Vendedor ve ON ve.id_vendedor = v.id_vendedor
WHERE ve.id_vendedor IS NULL
UNION ALL
SELECT 'Detalle sin producto', d.id_venta
FROM Venta_Detalle d LEFT JOIN Producto p ON p.id_producto = d.id_producto
WHERE p.id_producto IS NULL
UNION ALL
SELECT 'Pago sin metodo', vp.id_venta_pago
FROM Venta_Pago vp LEFT JOIN Metodo_Pago m ON m.id_metodo_pago = vp.id_metodo_pago
WHERE m.id_metodo_pago IS NULL;
GO


-- 5) Promociones vigentes al mismo tiempo sobre un mismo producto.
--    Tiene que dar 0 filas.
SELECT p1.id_producto, p1.nombre AS promo_1, p2.nombre AS promo_2
FROM Promocion p1
     INNER JOIN Promocion p2
        ON p1.id_producto = p2.id_producto
       AND p1.id_promocion < p2.id_promocion
       AND p1.fecha_inicio <= p2.fecha_fin
       AND p2.fecha_inicio <= p1.fecha_fin;
GO
