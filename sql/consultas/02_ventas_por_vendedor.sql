-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa IV
-- Consulta 02: Ventas por vendedor entre dos fechas
-- Motor: Microsoft SQL Server 2022
-- =========================================================

USE MateSerenoDB;
GO

DECLARE @desde DATE = '2026-09-10';
DECLARE @hasta DATE = '2026-09-17';

SELECT
    ve.id_vendedor,
    ve.apellido + ', ' + ve.nombre AS vendedor,
    COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
    COALESCE(SUM(d.cantidad * d.precio_unitario - d.descuento_aplicado), 0) AS total_vendido
FROM Vendedor ve
LEFT JOIN Venta v
       ON v.id_vendedor = ve.id_vendedor
      AND v.estado <> 'cancelada'
      AND v.fecha_hora >= @desde
      AND v.fecha_hora <  DATEADD(DAY, 1, @hasta)
LEFT JOIN Venta_Detalle d
       ON d.id_venta = v.id_venta
GROUP BY ve.id_vendedor, ve.apellido, ve.nombre
ORDER BY total_vendido DESC, ve.apellido, ve.nombre;
GO
