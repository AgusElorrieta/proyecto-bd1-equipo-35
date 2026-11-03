-- =========================================================
-- Proyecto Base de Datos I - Equipo 35 - MateSereño
-- Etapa V - Temas tecnicos
-- 01. Procedimientos y funciones almacenadas
-- Responsable: Renato Roman
-- Motor: Microsoft SQL Server 2022 Express
-- =========================================================
-- Ejecutar con la base cargada (crear_bd.sql + datos_prueba.sql).
-- El script se puede correr mas de una vez: los objetos se crean
-- con CREATE OR ALTER y la seccion 3 limpia antes sus datos de prueba.
-- =========================================================

USE MateSerenoDB;
GO

-- =========================================================
-- 1. PROCEDIMIENTOS ALMACENADOS (alta, modificacion y baja de Cliente)
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Alta de cliente
-- Cliente.id_cliente no es IDENTITY, asi que el procedimiento
-- calcula el siguiente id. El UPDLOCK evita que dos altas al
-- mismo tiempo tomen el mismo numero.
-- Controla que el telefono no exista (RN-01: el cliente se
-- identifica por su telefono de WhatsApp).
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_InsertarCliente
    @telefono   VARCHAR(30),
    @nombre     VARCHAR(80),
    @apellido   VARCHAR(80),
    @email      VARCHAR(120) = NULL,
    @localidad  VARCHAR(100) = NULL,
    @provincia  VARCHAR(100) = NULL,
    @id_cliente INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Cliente WHERE telefono = @telefono)
    BEGIN
        RAISERROR('Ya existe un cliente con el telefono %s.', 16, 1, @telefono);
        RETURN;
    END

    INSERT INTO Cliente (id_cliente, telefono, nombre, apellido, email, localidad, provincia, fecha_alta)
    SELECT ISNULL(MAX(id_cliente), 0) + 1,
           @telefono, @nombre, @apellido, @email, @localidad, @provincia,
           CAST(GETDATE() AS DATE)
    FROM Cliente WITH (UPDLOCK, HOLDLOCK);

    SELECT @id_cliente = id_cliente FROM Cliente WHERE telefono = @telefono;
END;
GO

-- ---------------------------------------------------------
-- 1.2 Modificacion de cliente
-- Solo cambia los datos que se pasan; los parametros en NULL
-- dejan el valor que ya tenia.
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_ModificarCliente
    @id_cliente INT,
    @telefono   VARCHAR(30)  = NULL,
    @nombre     VARCHAR(80)  = NULL,
    @apellido   VARCHAR(80)  = NULL,
    @email      VARCHAR(120) = NULL,
    @localidad  VARCHAR(100) = NULL,
    @provincia  VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
    BEGIN
        RAISERROR('No existe el cliente %d.', 16, 1, @id_cliente);
        RETURN;
    END

    IF @telefono IS NOT NULL
       AND EXISTS (SELECT 1 FROM Cliente
                   WHERE telefono = @telefono AND id_cliente <> @id_cliente)
    BEGIN
        RAISERROR('El telefono %s ya pertenece a otro cliente.', 16, 1, @telefono);
        RETURN;
    END

    UPDATE Cliente
    SET telefono  = ISNULL(@telefono,  telefono),
        nombre    = ISNULL(@nombre,    nombre),
        apellido  = ISNULL(@apellido,  apellido),
        email     = ISNULL(@email,     email),
        localidad = ISNULL(@localidad, localidad),
        provincia = ISNULL(@provincia, provincia)
    WHERE id_cliente = @id_cliente;
END;
GO

-- ---------------------------------------------------------
-- 1.3 Baja de cliente
-- Un cliente con ventas no se puede borrar: se perderia el
-- historial (RN-17). En ese caso devuelve un mensaje claro en
-- lugar del error generico de clave foranea.
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_EliminarCliente
    @id_cliente INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
    BEGIN
        RAISERROR('No existe el cliente %d.', 16, 1, @id_cliente);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Venta WHERE id_cliente = @id_cliente)
    BEGIN
        RAISERROR('El cliente %d tiene ventas registradas y no se puede eliminar.', 16, 1, @id_cliente);
        RETURN;
    END

    DELETE FROM Cliente WHERE id_cliente = @id_cliente;
END;
GO


-- =========================================================
-- 2. FUNCIONES ALMACENADAS
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Total de una venta: neto de todos los renglones + envio.
-- La tabla Venta no guarda el total (es un dato derivado), asi
-- que esta funcion es el unico lugar donde se calcula.
-- ---------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_TotalVenta (@id_venta INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @neto  DECIMAL(12,2);
    DECLARE @envio DECIMAL(12,2);

    SELECT @neto = ISNULL(SUM(cantidad * precio_unitario - descuento_aplicado), 0)
    FROM Venta_Detalle
    WHERE id_venta = @id_venta;

    SELECT @envio = costo_envio
    FROM Envio
    WHERE id_venta = @id_venta;

    RETURN @neto + ISNULL(@envio, 0);
END;
GO

-- ---------------------------------------------------------
-- 2.2 Saldo pendiente de una venta: total - lo pagado.
-- Una venta cancelada no tiene nada por cobrar.
-- ---------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_SaldoPendiente (@id_venta INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Venta WHERE id_venta = @id_venta AND estado = 'cancelada')
        RETURN 0;

    RETURN dbo.fn_TotalVenta(@id_venta)
           - ISNULL((SELECT SUM(importe) FROM Venta_Pago WHERE id_venta = @id_venta), 0);
END;
GO

-- ---------------------------------------------------------
-- 2.3 Descuento para clientes frecuentes, segun lo comprado.
-- Montos adaptados a los datos de prueba:
--   mas de 80000 acumulado -> 10 %
--   mas de 50000 acumulado ->  5 %
--   el resto               ->  0 %
-- No cuenta las ventas canceladas.
-- ---------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_DescuentoCliente (@id_cliente INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @acumulado DECIMAL(14,2);

    SELECT @acumulado = ISNULL(SUM(dbo.fn_TotalVenta(id_venta)), 0)
    FROM Venta
    WHERE id_cliente = @id_cliente
      AND estado <> 'cancelada';

    RETURN CASE
               WHEN @acumulado > 80000 THEN 10
               WHEN @acumulado > 50000 THEN 5
               ELSE 0
           END;
END;
GO

-- ---------------------------------------------------------
-- 2.4 Funcion que devuelve una tabla: las ventas de un cliente
-- con su total y su saldo. Se usa como si fuera una tabla.
-- ---------------------------------------------------------
CREATE OR ALTER FUNCTION dbo.fn_VentasDeCliente (@id_cliente INT)
RETURNS TABLE
AS
RETURN
(
    SELECT v.id_venta,
           v.comprobante,
           v.fecha_hora,
           v.estado,
           dbo.fn_TotalVenta(v.id_venta)     AS total,
           dbo.fn_SaldoPendiente(v.id_venta) AS saldo_pendiente
    FROM Venta v
    WHERE v.id_cliente = @id_cliente
);
GO


-- =========================================================
-- 3. LOTES DE DATOS: INSERT DIRECTO Y POR PROCEDIMIENTO
-- =========================================================

-- Limpieza por si el script ya se corrio antes (solo los clientes
-- de prueba de esta seccion, que no tienen ventas).
DELETE FROM Cliente WHERE telefono LIKE '379490000_' OR telefono LIKE '379491000_';
GO

-- 3.1 Lote con INSERT directo (clientes 9 a 12)
INSERT INTO Cliente (id_cliente, telefono, nombre, apellido, email, localidad, provincia, fecha_alta) VALUES
( 9, '3794900001', 'Martina',  'Quiroga', 'martina.quiroga@gmail.com', 'Corrientes',  'Corrientes', '2026-10-01'),
(10, '3794900002', 'Facundo',  'Vera',    NULL,                        'Esquina',     'Corrientes', '2026-10-03'),
(11, '3794900003', 'Agustina', 'Romero',  'agus.romero@gmail.com',     'Resistencia', 'Chaco',      '2026-10-07'),
(12, '3794900004', 'Lautaro',  'Galarza', 'lautaro.g@hotmail.com',     'Posadas',     'Misiones',   '2026-10-12');
GO

-- 3.2 Lote invocando al procedimiento (clientes 13 a 16)
EXEC dbo.sp_InsertarCliente @telefono = '3794910001', @nombre = 'Brenda',  @apellido = 'Sosa',
     @email = 'brenda.sosa@gmail.com', @localidad = 'Corrientes', @provincia = 'Corrientes';
EXEC dbo.sp_InsertarCliente @telefono = '3794910002', @nombre = 'Ignacio', @apellido = 'Leiva',
     @localidad = 'Santo Tome', @provincia = 'Corrientes';
EXEC dbo.sp_InsertarCliente @telefono = '3794910003', @nombre = 'Milagros', @apellido = 'Benitez',
     @email = 'mili.benitez@gmail.com', @localidad = 'Formosa', @provincia = 'Formosa';
EXEC dbo.sp_InsertarCliente @telefono = '3794910004', @nombre = 'Tomas',   @apellido = 'Acuna',
     @localidad = 'Goya', @provincia = 'Corrientes';
GO

-- 3.3 El procedimiento rechaza un telefono repetido
--     (tiene que mostrar el mensaje en rojo y no insertar nada)
EXEC dbo.sp_InsertarCliente @telefono = '3794111111', @nombre = 'Repetido', @apellido = 'Prueba';
GO

SELECT id_cliente, telefono, nombre, apellido, email, localidad, fecha_alta
FROM Cliente
WHERE id_cliente >= 9
ORDER BY id_cliente;
-- Esperado: 8 clientes nuevos, del 9 al 16. "Repetido" no aparece.
GO


-- =========================================================
-- 4. UPDATE Y DELETE INVOCANDO A LOS PROCEDIMIENTOS
-- =========================================================

-- 4.1 Modificar: Facundo Vera (10) carga su email y se muda
EXEC dbo.sp_ModificarCliente @id_cliente = 10,
     @email = 'facu.vera@gmail.com', @localidad = 'Corrientes';

-- 4.2 Modificar: Tomas Acuna cambia de telefono
DECLARE @id_tomas INT = (SELECT id_cliente FROM Cliente WHERE telefono = '3794910004');
EXEC dbo.sp_ModificarCliente @id_cliente = @id_tomas, @telefono = '3794910005';
GO

-- 4.3 Eliminar: Lautaro Galarza (12) no tiene ventas -> se borra
EXEC dbo.sp_EliminarCliente @id_cliente = 12;

-- 4.4 Eliminar: Juan Perez (1) tiene ventas -> el procedimiento lo impide
EXEC dbo.sp_EliminarCliente @id_cliente = 1;
GO

SELECT id_cliente, telefono, nombre, apellido, email, localidad
FROM Cliente
WHERE id_cliente IN (1, 10, 12)
   OR telefono IN ('3794910004', '3794910005')
ORDER BY id_cliente;
-- Esperado: el 10 con email y localidad Corrientes, Tomas con el
-- telefono terminado en 5, el 12 ya no esta y el 1 sigue estando.
GO


-- =========================================================
-- 5. PRUEBAS DE LAS FUNCIONES
-- =========================================================

-- 5.1 Total y saldo de cada venta
SELECT id_venta,
       comprobante,
       estado,
       dbo.fn_TotalVenta(id_venta)     AS total,
       dbo.fn_SaldoPendiente(id_venta) AS saldo_pendiente
FROM Venta
ORDER BY id_venta;
-- Esperado (total / saldo):
--  1: 35000/0   2: 16000/0   3: 93500/26000   4: 61000/0
--  5: 25500/12750   6: 24000/0 (cancelada)   7: 66500/47000   8: 7500/0
GO

-- 5.2 Descuento de cada cliente
SELECT id_cliente,
       nombre + ' ' + apellido               AS cliente,
       dbo.fn_DescuentoCliente(id_cliente)   AS descuento_pct
FROM Cliente
ORDER BY descuento_pct DESC, id_cliente;
-- Esperado: Carlos Lopez (3) 10 %; Ana Martinez (4) y Diego Romero (7) 5 %;
-- el resto 0 %.
GO

-- 5.3 Funcion de tabla: ventas de Carlos Lopez
SELECT * FROM dbo.fn_VentasDeCliente(3);
-- Esperado: FC-0003, seniada, total 93500, saldo 26000.
GO


-- =========================================================
-- 6. COMPARACION DE EFICIENCIA
-- Operacion directa contra procedimiento y funcion.
-- Todo corre dentro de una transaccion que al final se deshace
-- (ROLLBACK), asi los 2000 clientes de prueba no quedan en la base.
-- =========================================================
SET NOCOUNT ON;

BEGIN TRANSACTION;

DECLARE @i  INT;
DECLARE @t0 DATETIME2;
DECLARE @ms_directo INT, @ms_procedimiento INT;
DECLARE @tel VARCHAR(30);

-- 6.1 Mil altas con INSERT directo
SET @i = 1;
SET @t0 = SYSDATETIME();
WHILE @i <= 1000
BEGIN
    SET @tel = CONCAT('5', RIGHT(CONCAT('000000000', @i), 9));
    INSERT INTO Cliente (id_cliente, telefono, nombre, apellido, fecha_alta)
    SELECT ISNULL(MAX(id_cliente), 0) + 1, @tel, 'Prueba', 'Directo', CAST(GETDATE() AS DATE)
    FROM Cliente;
    SET @i += 1;
END
SET @ms_directo = DATEDIFF(MILLISECOND, @t0, SYSDATETIME());

-- 6.2 Mil altas por el procedimiento
SET @i = 1;
SET @t0 = SYSDATETIME();
WHILE @i <= 1000
BEGIN
    SET @tel = CONCAT('6', RIGHT(CONCAT('000000000', @i), 9));
    EXEC dbo.sp_InsertarCliente @telefono = @tel, @nombre = 'Prueba', @apellido = 'Procedimiento';
    SET @i += 1;
END
SET @ms_procedimiento = DATEDIFF(MILLISECOND, @t0, SYSDATETIME());

SELECT @ms_directo       AS ms_1000_insert_directos,
       @ms_procedimiento AS ms_1000_insert_por_procedimiento;

ROLLBACK TRANSACTION;
GO

-- Comprobacion: el ROLLBACK no dejo ningun cliente de prueba.
SELECT COUNT(*) AS clientes_de_prueba_que_quedaron
FROM Cliente
WHERE apellido IN ('Directo', 'Procedimiento');
-- Esperado: 0
GO

-- 6.3 Calculo del total de las ventas: escrito en la consulta
--     contra usando la funcion. Mirar la pestaña Mensajes.
SET STATISTICS TIME ON;

SELECT v.id_venta,
       SUM(d.cantidad * d.precio_unitario - d.descuento_aplicado)
         + ISNULL(MAX(e.costo_envio), 0) AS total
FROM Venta v
     INNER JOIN Venta_Detalle d ON d.id_venta = v.id_venta
     LEFT  JOIN Envio e         ON e.id_venta = v.id_venta
GROUP BY v.id_venta;

SELECT id_venta, dbo.fn_TotalVenta(id_venta) AS total
FROM Venta;

SET STATISTICS TIME OFF;
GO
