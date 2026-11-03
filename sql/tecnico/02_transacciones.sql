-- =========================================================
-- Base de Datos I - Equipo 35 - MateSereno
-- Etapa V - 02. Manejo de transacciones
-- Responsable: Agustin Elorrieta
-- Motor: Microsoft SQL Server 2022 Express
-- =========================================================
-- REQUISITOS: ejecutar primero crear_bd.sql y datos_prueba.sql.
-- No ejecutar esos dos scripts de nuevo si hay datos que conservar.
-- Este archivo crea o actualiza un procedimiento y ejecuta pruebas
-- que NO dejan ventas ni cambios de stock permanentes.
-- Las pruebas de error muestran errores ESPERADOS y los capturan.
-- =========================================================

USE MateSerenoDB;
GO

-- =========================================================
-- 1. PROCEDIMIENTO: registrar encabezado, detalle y descontar stock
-- =========================================================
-- Venta.id_venta NO es IDENTITY: se recibe un identificador explicito.
-- Para esta demostracion se registra un solo renglon por venta.
-- El precio historico se toma de Producto.precio_lista al momento
-- de registrar la operacion.
-- La actualizacion de stock incluye una condicion atomica que evita
-- descontar mas unidades que las disponibles.
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaTransaccional
    @id_venta           INT,
    @comprobante        VARCHAR(30),
    @fecha_hora         DATETIME,
    @id_vendedor        INT,
    @id_producto        INT,
    @cantidad           INT,
    @id_cliente         INT = NULL,
    @descuento_aplicado DECIMAL(12,2) = 0,
    @forzar_error       BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @precio_unitario DECIMAL(12,2);

    BEGIN TRY
        IF @cantidad IS NULL OR @cantidad <= 0
            THROW 51001, 'La cantidad debe ser mayor que cero.', 1;

        IF @descuento_aplicado IS NULL OR @descuento_aplicado < 0
            THROW 51002, 'El descuento no puede ser negativo.', 1;

        BEGIN TRANSACTION;

        -- Se conserva el precio y se bloquea el producto mientras
        -- se realiza la venta para evitar modificaciones concurrentes.
        SELECT @precio_unitario = p.precio_lista
        FROM dbo.Producto AS p WITH (UPDLOCK, HOLDLOCK)
        WHERE p.id_producto = @id_producto
          AND p.activo = 1;

        IF @precio_unitario IS NULL
            THROW 51003, 'El producto no existe o esta inactivo.', 1;

        IF @descuento_aplicado > @precio_unitario * @cantidad
            THROW 51004, 'El descuento supera el importe del renglon.', 1;

        -- 1) Encabezado: se registra primero la venta.
        INSERT INTO dbo.Venta
            (id_venta, comprobante, fecha_hora, id_cliente,
             id_vendedor, estado, observaciones)
        VALUES
            (@id_venta, @comprobante, @fecha_hora, @id_cliente,
             @id_vendedor, 'pendiente',
             'Registro mediante transaccion - Etapa V');

        -- Simulacion de un fallo DESPUES del primer INSERT.
        -- La venta anterior debe desaparecer al ejecutar ROLLBACK.
        IF @forzar_error = 1
            THROW 51005, 'Error de prueba provocado despues de insertar Venta.', 1;

        -- 2) Detalle: precio historico y descuento como monto fijo.
        INSERT INTO dbo.Venta_Detalle
            (id_venta, nro_renglon, id_producto,
             cantidad, precio_unitario, descuento_aplicado)
        VALUES
            (@id_venta, 1, @id_producto,
             @cantidad, @precio_unitario, @descuento_aplicado);

        -- 3) Stock: si no alcanzan las unidades, no actualiza nada.
        UPDATE dbo.Producto
        SET stock_actual = stock_actual - @cantidad
        WHERE id_producto = @id_producto
          AND stock_actual >= @cantidad;

        IF @@ROWCOUNT <> 1
            THROW 51006, 'Stock insuficiente: se deshace toda la venta.', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- =========================================================
-- 2. PRUEBA CORRECTA: producto 2, dos unidades
-- =========================================================
-- En la base verificada el producto 2 tiene stock 10.
-- Se espera observar la disminucion a 8 dentro de la prueba.
-- La transaccion exterior se revierte al final para conservar
-- los datos originales. El COMMIT interno NO confirma la exterior.
-- =========================================================
PRINT 'PRUEBA 1 - Venta correcta; stock menor dentro de la transaccion';
SELECT id_producto, stock_actual AS stock_antes
FROM dbo.Producto WHERE id_producto = 2;

BEGIN TRY
    BEGIN TRANSACTION PruebaCorrecta;

    EXEC dbo.sp_RegistrarVentaTransaccional
        @id_venta = 95001,
        @comprobante = 'ET5-95001',
        @fecha_hora = '2026-11-03T10:00:00',
        @id_vendedor = 1,
        @id_producto = 2,
        @cantidad = 2,
        @id_cliente = 1;

    SELECT v.id_venta, v.comprobante, d.id_producto, d.cantidad,
           d.precio_unitario, p.stock_actual AS stock_durante,
           @@TRANCOUNT AS transacciones_abiertas
    FROM dbo.Venta AS v
    INNER JOIN dbo.Venta_Detalle AS d ON d.id_venta = v.id_venta
    INNER JOIN dbo.Producto AS p ON p.id_producto = d.id_producto
    WHERE v.id_venta = 95001;

    -- Limpieza de la demostracion; no se deja una venta ficticia.
    ROLLBACK TRANSACTION PruebaCorrecta;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    SELECT ERROR_NUMBER() AS error_numero, ERROR_MESSAGE() AS error_texto;
END CATCH;

SELECT id_producto, stock_actual AS stock_despues
FROM dbo.Producto WHERE id_producto = 2;
SELECT COUNT(*) AS ventas_prueba_que_quedaron
FROM dbo.Venta WHERE id_venta = 95001;
SELECT COUNT(*) AS detalles_prueba_que_quedaron
FROM dbo.Venta_Detalle WHERE id_venta = 95001;
GO

-- =========================================================
-- 3. PRUEBA INCORRECTA: stock insuficiente
-- =========================================================
-- Intenta vender 999 unidades del producto 2.
-- Debe fallar el UPDATE, ejecutarse ROLLBACK y quedar 0
-- registros tanto en Venta como en Venta_Detalle.
-- =========================================================
PRINT 'PRUEBA 2 - Stock insuficiente; rollback completo';
BEGIN TRY
    EXEC dbo.sp_RegistrarVentaTransaccional
        @id_venta = 95002,
        @comprobante = 'ET5-95002',
        @fecha_hora = '2026-11-03T10:05:00',
        @id_vendedor = 1,
        @id_producto = 2,
        @cantidad = 999,
        @id_cliente = 1;
    PRINT 'ATENCION: esta operacion no deberia completarse.';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS error_esperado,
           ERROR_MESSAGE() AS descripcion_error;
END CATCH;

SELECT (SELECT COUNT(*) FROM dbo.Venta WHERE id_venta = 95002) AS encabezados,
       (SELECT COUNT(*) FROM dbo.Venta_Detalle WHERE id_venta = 95002) AS detalles,
       (SELECT stock_actual FROM dbo.Producto WHERE id_producto = 2) AS stock_final;
GO

-- =========================================================
-- 4. PRUEBA INCORRECTA: fallo FORZADO tras insertar Venta
-- =========================================================
-- Demuestra que un error intermedio deshace el primer INSERT.
-- =========================================================
PRINT 'PRUEBA 3 - Error forzado despues de insertar encabezado';
BEGIN TRY
    EXEC dbo.sp_RegistrarVentaTransaccional
        @id_venta = 95003,
        @comprobante = 'ET5-95003',
        @fecha_hora = '2026-11-03T10:10:00',
        @id_vendedor = 1,
        @id_producto = 6,
        @cantidad = 1,
        @id_cliente = 1,
        @forzar_error = 1;
    PRINT 'ATENCION: esta operacion no deberia completarse.';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS error_esperado,
           ERROR_MESSAGE() AS descripcion_error;
END CATCH;

SELECT (SELECT COUNT(*) FROM dbo.Venta WHERE id_venta = 95003) AS encabezados,
       (SELECT COUNT(*) FROM dbo.Venta_Detalle WHERE id_venta = 95003) AS detalles,
       (SELECT stock_actual FROM dbo.Producto WHERE id_producto = 6) AS stock_final;
GO

-- =========================================================
-- 5. TRANSACCION ANIDADA CON SAVE TRANSACTION
-- =========================================================
-- SQL Server no confirma transacciones internas de forma separada.
-- ROLLBACK a un SAVEPOINT deshace solo los cambios posteriores
-- y NO disminuye @@TRANCOUNT.
-- En la base verificada el producto 6 comienza con stock 20.
-- =========================================================
PRINT 'PRUEBA 4 - Transaccion anidada y punto de guardado';
SELECT @@TRANCOUNT AS nivel_inicial,
       stock_actual AS stock_inicial
FROM dbo.Producto WHERE id_producto = 6;

BEGIN TRY
    BEGIN TRANSACTION TranExterior;
    SELECT '1. BEGIN exterior' AS paso, @@TRANCOUNT AS nivel,
           stock_actual FROM dbo.Producto WHERE id_producto = 6;

    UPDATE dbo.Producto
    SET stock_actual = stock_actual - 1
    WHERE id_producto = 6 AND stock_actual >= 1;
    IF @@ROWCOUNT <> 1
        THROW 51007, 'No hay stock para la prueba de transaccion anidada.', 1;

    SAVE TRANSACTION PuntoGuardado;
    SELECT '2. SAVE exterior (-1)' AS paso, @@TRANCOUNT AS nivel,
           stock_actual FROM dbo.Producto WHERE id_producto = 6;

    BEGIN TRANSACTION TranInterior;
    UPDATE dbo.Producto
    SET stock_actual = stock_actual - 2
    WHERE id_producto = 6 AND stock_actual >= 2;
    IF @@ROWCOUNT <> 1
        THROW 51008, 'No hay stock para la parte interna de la prueba.', 1;

    SELECT '3. BEGIN interior (-2 mas)' AS paso, @@TRANCOUNT AS nivel,
           stock_actual FROM dbo.Producto WHERE id_producto = 6;

    ROLLBACK TRANSACTION PuntoGuardado;
    SELECT '4. ROLLBACK solo a SAVE' AS paso, @@TRANCOUNT AS nivel,
           stock_actual FROM dbo.Producto WHERE id_producto = 6;

    COMMIT TRANSACTION; -- solo baja @@TRANCOUNT de 2 a 1
    SELECT '5. COMMIT interior' AS paso, @@TRANCOUNT AS nivel,
           stock_actual FROM dbo.Producto WHERE id_producto = 6;

    ROLLBACK TRANSACTION TranExterior;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    SELECT ERROR_NUMBER() AS error_numero, ERROR_MESSAGE() AS error_texto;
END CATCH;

SELECT '6. Fin: todo restaurado' AS paso,
       @@TRANCOUNT AS nivel_final,
       stock_actual AS stock_final
FROM dbo.Producto WHERE id_producto = 6;
GO
