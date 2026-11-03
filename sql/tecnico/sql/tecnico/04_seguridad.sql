-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa V - Temas Técnicos: Seguridad (Usuarios y Roles)
-- Responsable: Emmanuel David Otero
-- Motor: Microsoft SQL Server 2022 Express
-- Prerrequisito: Ejecutar antes 01_procedimientos_funciones.sql
-- =========================================================
USE MateSerenoDB;
GO

-- =========================================================
-- 1. VERIFICACIÓN DEL MODO DE AUTENTICACIÓN (MODO MIXTO)
-- SERVERPROPERTY('IsIntegratedSecurityOnly'):
--   0 = Modo Mixto (Autenticación de Windows y SQL Server)
--   1 = Solo Autenticación de Windows
-- =========================================================
SELECT
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS Es_Solo_Windows,
    CASE
        WHEN SERVERPROPERTY('IsIntegratedSecurityOnly') = 0
            THEN 'OK: Modo Mixto habilitado (Windows y SQL Server)'
        ELSE 'ATENCION: Solo Autenticacion de Windows habilitada'
    END AS Estado_Autenticacion;
GO

-- =========================================================
-- 2. LIMPIEZA PREVIA (PARA PERMITIR RE-EJECUCIÓN DEL SCRIPT)
-- =========================================================
DELETE FROM dbo.Cliente
WHERE telefono IN ('3794000111', '3794998877');
GO

IF DATABASE_PRINCIPAL_ID('usuario_admin') IS NOT NULL
    DROP USER usuario_admin;
IF DATABASE_PRINCIPAL_ID('usuario_lector') IS NOT NULL
    DROP USER usuario_lector;
IF DATABASE_PRINCIPAL_ID('usuario_con_rol') IS NOT NULL
    DROP USER usuario_con_rol;
IF DATABASE_PRINCIPAL_ID('usuario_sin_rol') IS NOT NULL
    DROP USER usuario_sin_rol;
IF DATABASE_PRINCIPAL_ID('rol_consulta_productos') IS NOT NULL
    DROP ROLE rol_consulta_productos;
GO

IF SUSER_ID('login_admin_ms') IS NOT NULL
    DROP LOGIN login_admin_ms;
IF SUSER_ID('login_lector_ms') IS NOT NULL
    DROP LOGIN login_lector_ms;
IF SUSER_ID('login_con_rol_ms') IS NOT NULL
    DROP LOGIN login_con_rol_ms;
IF SUSER_ID('login_sin_rol_ms') IS NOT NULL
    DROP LOGIN login_sin_rol_ms;
GO

-- =========================================================
-- 3. CREACIÓN DE LOGINS Y USUARIOS DE BASE DE DATOS
-- =========================================================
CREATE LOGIN login_admin_ms
    WITH PASSWORD = 'MateAdmin2026!', CHECK_POLICY = OFF;
CREATE LOGIN login_lector_ms
    WITH PASSWORD = 'MateLector2026!', CHECK_POLICY = OFF;
CREATE LOGIN login_con_rol_ms
    WITH PASSWORD = 'MateConRol2026!', CHECK_POLICY = OFF;
CREATE LOGIN login_sin_rol_ms
    WITH PASSWORD = 'MateSinRol2026!', CHECK_POLICY = OFF;
GO

CREATE USER usuario_admin   FOR LOGIN login_admin_ms;
CREATE USER usuario_lector  FOR LOGIN login_lector_ms;
CREATE USER usuario_con_rol FOR LOGIN login_con_rol_ms;
CREATE USER usuario_sin_rol FOR LOGIN login_sin_rol_ms;
GO

-- =========================================================
-- 4. ASIGNACIÓN DE PERMISOS A USUARIOS
-- - usuario_admin: rol fijo db_owner (control total de la BD)
-- - usuario_lector: solo SELECT sobre Cliente y EXECUTE sobre
--   el procedimiento almacenado dbo.sp_InsertarCliente
-- =========================================================
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO

GRANT SELECT ON OBJECT::dbo.Cliente TO usuario_lector;
GRANT EXECUTE ON OBJECT::dbo.sp_InsertarCliente TO usuario_lector;
GO

-- =========================================================
-- 5. PRUEBA 1: INSERT DIRECTO VS. ALTA POR PROCEDIMIENTO
-- Se cambia el contexto de ejecución a 'usuario_lector'
-- sin cerrar la sesión actual mediante EXECUTE AS USER.
-- =========================================================
PRINT '=== INICIO DE PRUEBAS CON usuario_lector ===';
EXECUTE AS USER = 'usuario_lector';

-- 5.1) Verificación de usuario en sesión y lectura de Cliente (Permitido)
SELECT
    USER_NAME() AS Usuario_Actual,
    COUNT(*)    AS Total_Clientes_Antes
FROM dbo.Cliente;

-- 5.2) Intento de INSERT directo sobre la tabla Cliente (Debe FALLAR con Error 229)
BEGIN TRY
    PRINT 'Intentando INSERT directo sobre dbo.Cliente con usuario_lector...';
    INSERT INTO dbo.Cliente (id_cliente, telefono, nombre, apellido, email, localidad, provincia, fecha_alta)
    VALUES (99, '3794000111', 'Intento', 'Directo', 'directo@matesereno.com', 'Corrientes', 'Corrientes', '2026-11-03');
END TRY
BEGIN CATCH
    SELECT
        USER_NAME()     AS Usuario_Actual,
        ERROR_NUMBER()  AS Codigo_Error,
        ERROR_MESSAGE() AS Mensaje_Error_Insert_Directo;
END CATCH;

-- 5.3) Alta de cliente invocando dbo.sp_InsertarCliente (Debe FUNCIONAR)
BEGIN TRY
    PRINT 'Ejecutando dbo.sp_InsertarCliente con usuario_lector...';
    EXEC dbo.sp_InsertarCliente
        @telefono  = '3794998877',
        @nombre    = 'Valeria',
        @apellido  = 'Gomez',
        @email     = 'valeria.gomez@correo.com',
        @localidad = 'Corrientes',
        @provincia = 'Corrientes';

    SELECT
        USER_NAME() AS Usuario_Actual,
        id_cliente,
        telefono,
        nombre,
        apellido,
        email,
        localidad,
        provincia,
        fecha_alta
    FROM dbo.Cliente
    WHERE telefono = '3794998877';
END TRY
BEGIN CATCH
    SELECT
        USER_NAME()     AS Usuario_Actual,
        ERROR_NUMBER()  AS Codigo_Error,
        ERROR_MESSAGE() AS Mensaje_Error_Procedimiento;
END CATCH;

-- Restaurar el contexto de seguridad original
REVERT;
PRINT 'Contexto restaurado tras REVERT: ' + USER_NAME();
GO

-- =========================================================
-- 6. CREACIÓN DE ROL DE SOLO LECTURA Y COMPARACIÓN DE USUARIOS
-- - rol_consulta_productos: permiso SELECT únicamente sobre Producto
-- - Se asigna a usuario_con_rol y se compara contra usuario_sin_rol
-- =========================================================
CREATE ROLE rol_consulta_productos;
GO

GRANT SELECT ON OBJECT::dbo.Producto TO rol_consulta_productos;
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO

-- 6.1) Prueba con usuario_con_rol (Pertenece a rol_consulta_productos)
PRINT '=== PRUEBA CON usuario_con_rol ===';
EXECUTE AS USER = 'usuario_con_rol';

-- Consulta sobre Producto (Permitido por el rol)
SELECT
    USER_NAME() AS Usuario_Actual,
    id_producto,
    codigo,
    nombre,
    precio_lista
FROM dbo.Producto;

-- Intento de consulta sobre otra tabla no autorizada, ej. Venta (Debe FALLAR con Error 229)
BEGIN TRY
    SELECT * FROM dbo.Venta;
END TRY
BEGIN CATCH
    SELECT
        USER_NAME()     AS Usuario_Actual,
        ERROR_NUMBER()  AS Codigo_Error,
        ERROR_MESSAGE() AS Mensaje_Bloqueo_Otra_Tabla;
END CATCH;

REVERT;
GO

-- 6.2) Prueba con usuario_sin_rol (No pertenece a rol_consulta_productos)
PRINT '=== PRUEBA CON usuario_sin_rol ===';
EXECUTE AS USER = 'usuario_sin_rol';

-- Intento de consulta sobre Producto (Debe FALLAR con Error 229)
BEGIN TRY
    SELECT
        id_producto,
        codigo,
        nombre,
        precio_lista
    FROM dbo.Producto;
END TRY
BEGIN CATCH
    SELECT
        USER_NAME()     AS Usuario_Actual,
        ERROR_NUMBER()  AS Codigo_Error,
        ERROR_MESSAGE() AS Mensaje_Error_Sin_Rol;
END CATCH;

REVERT;
PRINT 'Contexto final restaurado: ' + USER_NAME();
GO
