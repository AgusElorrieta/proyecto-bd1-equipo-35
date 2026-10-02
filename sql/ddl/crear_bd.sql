-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- Etapa III - Implementación Física
-- Motor: Microsoft SQL Server 2022
-- =========================================================

IF DB_ID('MateSerenoDB') IS NULL
    CREATE DATABASE MateSerenoDB;
GO

USE MateSerenoDB;
GO


-- =========================================================
-- ELIMINACIÓN DE TABLAS
-- Permite volver a ejecutar el script durante las pruebas.
-- Se eliminan primero las tablas que dependen de otras.
-- =========================================================

DROP TABLE IF EXISTS Envio;
DROP TABLE IF EXISTS Venta_Pago;
DROP TABLE IF EXISTS Venta_Detalle;
DROP TABLE IF EXISTS Promocion;
DROP TABLE IF EXISTS Venta;
DROP TABLE IF EXISTS Metodo_Pago;
DROP TABLE IF EXISTS Vendedor;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Producto;
DROP TABLE IF EXISTS Categoria;
GO


-- =========================================================
-- CATEGORIA
-- =========================================================

CREATE TABLE Categoria (
    id_categoria INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(250) NULL,
    activa BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Categoria
        PRIMARY KEY (id_categoria)
);
GO


-- =========================================================
-- PRODUCTO
-- =========================================================

CREATE TABLE Producto (
    id_producto INT NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(300) NULL,
    material VARCHAR(80) NULL,
    precio_lista DECIMAL(12,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    modalidad_disponible VARCHAR(30) NOT NULL,
    dias_demora INT NOT NULL DEFAULT 0,
    requiere_senia BIT NOT NULL DEFAULT 0,
    porcentaje_senia DECIMAL(5,2) NOT NULL DEFAULT 0,
    activo BIT NOT NULL DEFAULT 1,
    id_categoria INT NOT NULL,

    CONSTRAINT PK_Producto
        PRIMARY KEY (id_producto),

    CONSTRAINT UQ_Producto_Codigo
        UNIQUE (codigo),

    CONSTRAINT FK_Producto_Categoria
        FOREIGN KEY (id_categoria)
        REFERENCES Categoria(id_categoria)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT CK_Producto_Precio
        CHECK (precio_lista >= 0),

    CONSTRAINT CK_Producto_Stock
        CHECK (stock_actual >= 0),

    CONSTRAINT CK_Producto_DiasDemora
        CHECK (dias_demora >= 0),

    CONSTRAINT CK_Producto_Modalidad
        CHECK (
            modalidad_disponible IN (
                'inmediata',
                'con_demora',
                'por_encargue'
            )
        ),

    CONSTRAINT CK_Producto_PorcentajeSenia
        CHECK (porcentaje_senia BETWEEN 0 AND 100),

    CONSTRAINT CK_Producto_SeniaConsistente
        CHECK (
            (requiere_senia = 0 AND porcentaje_senia = 0) OR
            (requiere_senia = 1 AND porcentaje_senia > 0)
        )
);
GO


-- =========================================================
-- PROMOCION
-- =========================================================

CREATE TABLE Promocion (
    id_promocion INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    precio_promocional DECIMAL(12,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activa BIT NOT NULL DEFAULT 1,
    id_producto INT NOT NULL,

    CONSTRAINT PK_Promocion
        PRIMARY KEY (id_promocion),

    CONSTRAINT FK_Promocion_Producto
        FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT CK_Promocion_Precio
        CHECK (precio_promocional >= 0),

    CONSTRAINT CK_Promocion_Fechas
        CHECK (fecha_fin >= fecha_inicio)
);
GO


-- =========================================================
-- CLIENTE
-- =========================================================

CREATE TABLE Cliente (
    id_cliente INT NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    email VARCHAR(120) NULL,
    localidad VARCHAR(100) NULL,
    provincia VARCHAR(100) NULL,
    fecha_alta DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Cliente
        PRIMARY KEY (id_cliente),

    CONSTRAINT UQ_Cliente_Telefono
        UNIQUE (telefono)
);
GO


-- =========================================================
-- VENDEDOR
-- =========================================================

CREATE TABLE Vendedor (
    id_vendedor INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    telefono VARCHAR(30) NULL,
    fecha_ingreso DATE NOT NULL,
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Vendedor
        PRIMARY KEY (id_vendedor)
);
GO


-- =========================================================
-- VENTA
-- =========================================================

CREATE TABLE Venta (
    id_venta INT NOT NULL,
    comprobante VARCHAR(30) NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT GETDATE(),
    id_cliente INT NULL,
    id_vendedor INT NOT NULL,
    estado VARCHAR(20) NOT NULL,
    observaciones VARCHAR(300) NULL,

    CONSTRAINT PK_Venta
        PRIMARY KEY (id_venta),

    CONSTRAINT UQ_Venta_Comprobante
        UNIQUE (comprobante),

    CONSTRAINT FK_Venta_Cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Venta_Vendedor
        FOREIGN KEY (id_vendedor)
        REFERENCES Vendedor(id_vendedor)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT CK_Venta_Estado
        CHECK (
            estado IN (
                'pendiente',
                'seniada',
                'pagada',
                'entregada',
                'cancelada'
            )
        )
);
GO


-- =========================================================
-- VENTA_DETALLE
-- =========================================================

CREATE TABLE Venta_Detalle (
    id_venta INT NOT NULL,
    nro_renglon INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento_aplicado DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT PK_Venta_Detalle
        PRIMARY KEY (id_venta, nro_renglon),

    CONSTRAINT FK_VentaDetalle_Venta
        FOREIGN KEY (id_venta)
        REFERENCES Venta(id_venta)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_VentaDetalle_Producto
        FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT UQ_VentaDetalle_Producto
        UNIQUE (id_venta, id_producto),

    CONSTRAINT CK_VentaDetalle_Renglon
        CHECK (nro_renglon > 0),

    CONSTRAINT CK_VentaDetalle_Cantidad
        CHECK (cantidad > 0),

    CONSTRAINT CK_VentaDetalle_Precio
        CHECK (precio_unitario >= 0),

    CONSTRAINT CK_VentaDetalle_Descuento
        CHECK (descuento_aplicado >= 0),

    CONSTRAINT CK_VentaDetalle_DescuentoMaximo
        CHECK (descuento_aplicado <= precio_unitario * cantidad)
);
GO


-- =========================================================
-- METODO_PAGO
-- =========================================================

CREATE TABLE Metodo_Pago (
    id_metodo_pago INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    recargo_porcentaje DECIMAL(5,2) NOT NULL DEFAULT 0,
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Metodo_Pago
        PRIMARY KEY (id_metodo_pago),

    CONSTRAINT UQ_MetodoPago_Nombre
        UNIQUE (nombre),

    CONSTRAINT CK_MetodoPago_Recargo
        CHECK (recargo_porcentaje >= 0)
);
GO


-- =========================================================
-- VENTA_PAGO
-- =========================================================

CREATE TABLE Venta_Pago (
    id_venta_pago INT NOT NULL,
    id_venta INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    importe DECIMAL(12,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    tipo_pago VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Venta_Pago
        PRIMARY KEY (id_venta_pago),

    CONSTRAINT FK_VentaPago_Venta
        FOREIGN KEY (id_venta)
        REFERENCES Venta(id_venta)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_VentaPago_Metodo
        FOREIGN KEY (id_metodo_pago)
        REFERENCES Metodo_Pago(id_metodo_pago)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT CK_VentaPago_Importe
        CHECK (importe > 0),

    CONSTRAINT CK_VentaPago_Tipo
        CHECK (
            tipo_pago IN (
                'senia',
                'saldo',
                'total'
            )
        )
);
GO


-- =========================================================
-- ENVIO
-- =========================================================

CREATE TABLE Envio (
    id_envio INT NOT NULL,
    id_venta INT NOT NULL,
    modalidad VARCHAR(30) NOT NULL,
    direccion VARCHAR(200) NULL,
    localidad VARCHAR(100) NULL,
    provincia VARCHAR(100) NULL,
    codigo_postal VARCHAR(15) NULL,
    costo_envio DECIMAL(12,2) NOT NULL DEFAULT 0,
    fecha_despacho DATE NULL,
    estado_envio VARCHAR(30) NOT NULL,

    CONSTRAINT PK_Envio
        PRIMARY KEY (id_envio),

    CONSTRAINT UQ_Envio_Venta
        UNIQUE (id_venta),

    CONSTRAINT FK_Envio_Venta
        FOREIGN KEY (id_venta)
        REFERENCES Venta(id_venta)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT CK_Envio_Costo
        CHECK (costo_envio >= 0),

    CONSTRAINT CK_Envio_Modalidad
        CHECK (
            modalidad IN (
                'retiro',
                'entrega_coordinada',
                'envio_domicilio'
            )
        ),

    CONSTRAINT CK_Envio_Estado
        CHECK (
            estado_envio IN (
                'pendiente',
                'preparando',
                'despachado',
                'entregado'
            )
        )
);
GO
