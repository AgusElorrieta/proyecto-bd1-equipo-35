-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa V
-- Script técnico 03: Triggers de auditoría
-- Motor: Microsoft SQL Server 2022
-- =========================================================
--
-- Contenido:
--   1. Tabla Auditoria_Producto
--   2. TR_Producto_AuditoriaUpdate  (AFTER UPDATE sobre Producto)
--   3. TR_Producto_AuditoriaDelete  (AFTER DELETE sobre Producto)
--   4. TR_Venta_BloquearDelete      (INSTEAD OF DELETE sobre Venta)
--   5. Pruebas
--
-- Se ejecuta después del DDL de la Etapa III. El DDL elimina las
-- tablas Producto y Venta junto con sus triggers: si se vuelve a
-- ejecutar el DDL, hay que volver a ejecutar también este script.
-- =========================================================

USE MateSerenoDB;
GO


-- =========================================================
-- ELIMINACIÓN DE OBJETOS
-- Permite volver a ejecutar el script durante las pruebas.
-- Ojo: al eliminar Auditoria_Producto se pierde su historial.
-- =========================================================

DROP TRIGGER IF EXISTS TR_Venta_BloquearDelete;
DROP TRIGGER IF EXISTS TR_Producto_AuditoriaDelete;
DROP TRIGGER IF EXISTS TR_Producto_AuditoriaUpdate;
DROP TABLE IF EXISTS Auditoria_Producto;
GO


-- =========================================================
-- AUDITORIA_PRODUCTO
-- Sin FK a Producto: los registros de un producto eliminado
-- tienen que sobrevivir a su baja.
-- =========================================================

CREATE TABLE Auditoria_Producto (
    id_auditoria INT IDENTITY(1,1) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(12,2) NOT NULL,
    precio_nuevo DECIMAL(12,2) NULL,
    stock_anterior INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT GETDATE(),
    usuario NVARCHAR(128) NOT NULL,

    CONSTRAINT PK_Auditoria_Producto
        PRIMARY KEY (id_auditoria),

    CONSTRAINT CK_AuditoriaProducto_Operacion
        CHECK (operacion IN ('UPDATE', 'DELETE'))
);
GO


-- =========================================================
-- TR_PRODUCTO_AUDITORIAUPDATE
-- Después de modificar Producto, guarda el precio y el stock
-- anteriores (tabla deleted) y el precio nuevo (tabla inserted).
-- Solo registra si cambió precio_lista o stock_actual.
-- Un UPDATE puede afectar varias filas y el trigger se ejecuta una
-- vez por sentencia: se resuelve con un solo INSERT ... SELECT.
-- Se asume que id_producto (PK) no se modifica, porque es la
-- columna que empareja deleted con inserted.
-- =========================================================

CREATE TRIGGER TR_Producto_AuditoriaUpdate
ON Producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria_Producto
        (operacion, id_producto, precio_anterior, precio_nuevo, stock_anterior, usuario)
    SELECT
        'UPDATE',
        d.id_producto,
        d.precio_lista,
        i.precio_lista,
        d.stock_actual,
        SUSER_SNAME()
    FROM deleted AS d
    INNER JOIN inserted AS i
            ON i.id_producto = d.id_producto
    WHERE d.precio_lista <> i.precio_lista
       OR d.stock_actual <> i.stock_actual;
END;
GO


-- =========================================================
-- TR_PRODUCTO_AUDITORIADELETE
-- Después de eliminar un Producto, guarda sus datos (tabla deleted).
-- precio_nuevo queda en NULL porque no hay un precio posterior.
-- =========================================================

CREATE TRIGGER TR_Producto_AuditoriaDelete
ON Producto
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria_Producto
        (operacion, id_producto, precio_anterior, precio_nuevo, stock_anterior, usuario)
    SELECT
        'DELETE',
        d.id_producto,
        d.precio_lista,
        NULL,
        d.stock_actual,
        SUSER_SNAME()
    FROM deleted AS d;
END;
GO


-- =========================================================
-- TR_VENTA_BLOQUEARDELETE
-- Reemplaza el DELETE sobre Venta: muestra un mensaje y no borra
-- nada. Las ventas se anulan cambiando su estado a 'cancelada'.
--
-- SQL Server no permite un INSTEAD OF DELETE en una tabla que tenga
-- una FK con ON DELETE CASCADE. Las FK de Venta hacia Cliente y
-- Vendedor son ON DELETE NO ACTION, por eso este trigger se puede
-- crear.
-- =========================================================

CREATE TRIGGER TR_Venta_BloquearDelete
ON Venta
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted)
        PRINT 'No se permite eliminar ventas. Para anular una venta, cambie su estado a ''cancelada''.';
END;
GO


-- =========================================================
-- PRUEBAS
-- Se ejecutan una vez creados los triggers. Cada prueba es un
-- bloque independiente.
-- =========================================================

-- ---------------------------------------------------------
-- Prueba 1: Producto (AFTER UPDATE y AFTER DELETE)
-- Se crea un producto de prueba para no tocar datos reales (un
-- producto con ventas o promociones no se puede eliminar por las FK).
-- Se cambia su precio y después se lo elimina.
-- ---------------------------------------------------------
DECLARE @ultima_auditoria INT = (SELECT COALESCE(MAX(id_auditoria), 0) FROM Auditoria_Producto);
DECLARE @id_producto INT = (SELECT COALESCE(MAX(id_producto), 0) + 1 FROM Producto);
DECLARE @id_categoria INT = (SELECT TOP 1 id_categoria FROM Categoria ORDER BY id_categoria);

INSERT INTO Producto (id_producto, codigo, nombre, precio_lista, stock_actual, modalidad_disponible, id_categoria)
VALUES (@id_producto, 'TEST-AUDIT', 'Producto de prueba auditoria', 1000.00, 5, 'inmediata', @id_categoria);

-- Cambio de precio (dispara TR_Producto_AuditoriaUpdate)
UPDATE Producto
SET precio_lista = 1500.00
WHERE id_producto = @id_producto;

-- Esperado: 1 fila UPDATE con precio_anterior 1000.00, precio_nuevo 1500.00 y stock_anterior 5
SELECT * FROM Auditoria_Producto WHERE id_auditoria > @ultima_auditoria ORDER BY id_auditoria;

-- Baja (dispara TR_Producto_AuditoriaDelete)
DELETE FROM Producto WHERE id_producto = @id_producto;

-- Esperado: además, 1 fila DELETE con precio_anterior 1500.00, precio_nuevo NULL y stock_anterior 5
SELECT * FROM Auditoria_Producto WHERE id_auditoria > @ultima_auditoria ORDER BY id_auditoria;
GO


-- ---------------------------------------------------------
-- Prueba 2: Venta (INSTEAD OF DELETE)
-- Se intenta borrar una venta: el trigger muestra el mensaje y no
-- borra nada. Va dentro de una transacción con ROLLBACK por seguridad:
-- si el trigger no estuviera creado, el borrado (con su CASCADE sobre
-- detalle, pagos y envío) se deshace igual.
-- ---------------------------------------------------------
BEGIN TRANSACTION;

DECLARE @id_venta INT = (SELECT TOP 1 id_venta FROM Venta ORDER BY id_venta);

-- Esperado: 1
SELECT COUNT(*) AS existe_antes FROM Venta WHERE id_venta = @id_venta;

-- Esperado: mensaje del trigger en la pestaña Mensajes
DELETE FROM Venta WHERE id_venta = @id_venta;

-- Esperado: 1 (la venta sigue estando)
SELECT COUNT(*) AS existe_despues FROM Venta WHERE id_venta = @id_venta;

ROLLBACK TRANSACTION;
GO
