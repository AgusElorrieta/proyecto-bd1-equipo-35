-- =========================================================
-- Proyecto Base de Datos I - Equipo 35 - MateSereño
-- Etapa IV - Consultas
-- 03. Reporte de ventas por categoria en un rango de fechas
-- Responsable: Renato Roman
-- Motor: Microsoft SQL Server 2022
-- =========================================================
-- Necesidad: saber que categoria de productos se vende mas en un
-- periodo, para decidir que reponer y que promocionar.
-- Estrategia: LEFT JOIN desde Categoria para que aparezcan tambien
-- las categorias sin ventas (con 0), y una subconsulta que filtra
-- antes las ventas validas del rango (sin canceladas).
-- =========================================================

USE MateSerenoDB;
GO

DECLARE @desde DATE = '2026-09-10';
DECLARE @hasta DATE = '2026-09-17';

SELECT  c.id_categoria,
        c.nombre                              AS categoria,
        COUNT(DISTINCT r.id_venta)            AS cantidad_ventas,
        ISNULL(SUM(r.cantidad), 0)            AS unidades_vendidas,
        ISNULL(SUM(r.neto), 0)                AS total_facturado
FROM Categoria c
     LEFT JOIN Producto p
            ON p.id_categoria = c.id_categoria
     LEFT JOIN (
            -- renglones de ventas validas dentro del rango
            SELECT d.id_producto,
                   d.id_venta,
                   d.cantidad,
                   d.cantidad * d.precio_unitario - d.descuento_aplicado AS neto
            FROM Venta_Detalle d
                 INNER JOIN Venta v ON v.id_venta = d.id_venta
            WHERE v.estado <> 'cancelada'
              AND v.fecha_hora >= @desde
              AND v.fecha_hora <  DATEADD(DAY, 1, @hasta)
       ) r
            ON r.id_producto = p.id_producto
GROUP BY c.id_categoria, c.nombre
ORDER BY total_facturado DESC;
GO

-- Resultado esperado con los datos de prueba (rango 10/09 al 17/09):
--  Termos Acero        2 ventas  2 u.  140000
--  Materas             1         1      65000
--  Mates de Calabaza   1         1      35000
--  Bombillas Alpaca    1         1      18000
--  Mates de Madera     1         1      16000
--  Accesorios          1         1       2500
--  Bombillas Acero     0         0          0   (su unica venta esta cancelada)
--  Yerberas            0         0          0   (no tiene productos)
--  Total general: 276500
