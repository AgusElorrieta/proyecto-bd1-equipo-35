-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Etapa V - Optimización con Índices
-- Responsable: Martin Espinoza
-- Motor: Microsoft SQL Server 2022
-- =========================================================

USE MateSerenoDB;
GO

-- 1. CREACIÓN DE TABLA AISLADA PARA PRUEBAS
DROP TABLE IF EXISTS Venta_Historica;
CREATE TABLE Venta_Historica (
    id INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED, -- PK no agrupada para poder jugar con el Clustered Index
    fecha_hora DATETIME NOT NULL,
    id_cliente INT NOT NULL,
    total DECIMAL(12,2) NOT NULL
);
GO

-- 2. CARGA MASIVA DE 1 MILLÓN DE REGISTROS
-- Se utiliza una CTE (Common Table Expression) en cascada para generar 
-- 1.000.000 de filas en segundos sin usar lentos ciclos WHILE.
PRINT 'Iniciando carga de 1 millón de registros...';
WITH 
  L0   AS (SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS (SELECT 1 AS c FROM L0 A CROSS JOIN L0 B),
  L2   AS (SELECT 1 AS c FROM L1 A CROSS JOIN L1 B),
  L3   AS (SELECT 1 AS c FROM L2 A CROSS JOIN L2 B),
  L4   AS (SELECT 1 AS c FROM L3 A CROSS JOIN L3 B),
  L5   AS (SELECT 1 AS c FROM L4 A CROSS JOIN L4 B),
  Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
INSERT INTO Venta_Historica (fecha_hora, id_cliente, total)
SELECT TOP 1000000
    DATEADD(MINUTE, n, '2020-01-01 00:00:00'), -- Fechas incrementales
    (n % 500) + 1,                             -- Clientes del 1 al 500
    CAST((ABS(CHECKSUM(NEWID())) % 100000) / 100.0 AS DECIMAL(12,2)) -- Totales aleatorios
FROM Nums;
PRINT 'Carga finalizada.';
GO

-- =========================================================
-- PRUEBAS DE RENDIMIENTO
-- =========================================================

-- Activar estadísticas de tiempo y lecturas de disco
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

DECLARE @fecha_inicio DATETIME = '2021-01-01T00:00:00';
DECLARE @fecha_fin DATETIME = '2021-01-31T23:59:59';

-- PRUEBA A: Búsqueda sin índice (Table Scan)
PRINT '--- PRUEBA A: SIN ÍNDICE SOBRE FECHA ---';
SELECT id, fecha_hora, total 
FROM Venta_Historica 
WHERE fecha_hora >= @fecha_inicio AND fecha_hora <= @fecha_fin;
GO

-- PRUEBA B: Búsqueda con Índice Agrupado (Clustered Index Seek)
PRINT '--- PRUEBA B: CON ÍNDICE AGRUPADO ---';
CREATE CLUSTERED INDEX CIX_VentaHistorica_Fecha ON Venta_Historica(fecha_hora);
GO

DECLARE @fecha_inicio DATETIME = '2021-01-01T00:00:00';
DECLARE @fecha_fin DATETIME = '2021-01-31T23:59:59';

SELECT id, fecha_hora, total 
FROM Venta_Historica 
WHERE fecha_hora >= @fecha_inicio AND fecha_hora <= @fecha_fin;
GO

-- PRUEBA C: Búsqueda con Índice No Agrupado Cubierto (Non-Clustered with INCLUDE)
PRINT '--- PRUEBA C: CON ÍNDICE CUBIERTO (INCLUDE) ---';
-- Eliminamos el agrupado para probar la otra estrategia
DROP INDEX CIX_VentaHistorica_Fecha ON Venta_Historica;
GO

-- Creamos el índice cubierto (incluye 'total' para no tener que ir a buscarlo a la tabla)
CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cover 
ON Venta_Historica(fecha_hora) 
INCLUDE (total);
GO

DECLARE @fecha_inicio DATETIME = '2021-01-01T00:00:00';
DECLARE @fecha_fin DATETIME = '2021-01-31T23:59:59';

SELECT id, fecha_hora, total 
FROM Venta_Historica 
WHERE fecha_hora >= @fecha_inicio AND fecha_hora <= @fecha_fin;
GO

-- Apagar estadísticas
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
