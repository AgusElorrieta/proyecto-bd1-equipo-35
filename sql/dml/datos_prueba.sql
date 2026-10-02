-- =========================================================
-- Proyecto Base de Datos I - Equipo 35
-- Caso de estudio: MateSereño
-- SCRIPT DML: POBLADO DE LA BASE DE DATOS
-- =========================================================

USE MateSerenoDB;
GO



INSERT INTO Categoria (id_categoria, nombre, descripcion, activa) VALUES
(1, 'Mates de Calabaza', 'Mates tradicionales de calabaza', 1),
(2, 'Mates de Madera', 'Mates de algarrobo y palo santo', 1),
(3, 'Termos Acero', 'Termos de acero inoxidable primera marca', 1),
(4, 'Bombillas Alpaca', 'Bombillas artesanales de alpaca', 1),
(5, 'Bombillas Acero', 'Bombillas de acero quirúrgico', 1),
(6, 'Materas', 'Bolsos y mochilas materas de cuero', 1),
(7, 'Yerberas', 'Latas y recipientes para yerba mate', 1),
(8, 'Accesorios', 'Cepillos, despolvilladores y repuestos', 1);

INSERT INTO Metodo_Pago (id_metodo_pago, nombre, recargo_porcentaje, activo) VALUES
(1, 'Efectivo', 0.00, 1),
(2, 'Transferencia Bancaria', 0.00, 1),
(3, 'Mercado Pago - Dinero en cuenta', 0.00, 1),
(4, 'Mercado Pago - Tarjeta Crédito', 10.00, 1),
(5, 'Tarjeta de Débito', 0.00, 1),
(6, 'Tarjeta de Crédito 3 Cuotas', 15.00, 1),
(7, 'MODO', 0.00, 1),
(8, 'Ualá', 0.00, 1);

INSERT INTO Cliente (id_cliente, telefono, nombre, apellido, email, localidad, provincia, fecha_alta) VALUES
(1, '3794111111', 'Juan', 'Pérez', 'juan@email.com', 'Corrientes', 'Corrientes', '2026-01-15'),
(2, '3794222222', 'María', 'Gómez', 'maria@email.com', 'Resistencia', 'Chaco', '2026-02-10'),
(3, '1143333333', 'Carlos', 'López', 'carlos@email.com', 'CABA', 'Buenos Aires', '2026-03-05'),
(4, '3764444444', 'Ana', 'Martínez', 'ana@email.com', 'Posadas', 'Misiones', '2026-04-20'),
(5, '3715555555', 'Pedro', 'Sánchez', 'pedro@email.com', 'Formosa', 'Formosa', '2026-05-12'),
(6, '3416666666', 'Lucía', 'Fernández', 'lucia@email.com', 'Rosario', 'Santa Fe', '2026-06-30'),
(7, '3517777777', 'Diego', 'Romero', 'diego@email.com', 'Córdoba', 'Córdoba', '2026-07-18'),
(8, '3794888888', 'Sofía', 'Alonso', 'sofia@email.com', 'Goya', 'Corrientes', '2026-08-22');

INSERT INTO Vendedor (id_vendedor, nombre, apellido, telefono, fecha_ingreso, activo) VALUES
(1, 'Martín', 'Espinoza', '3794000001', '2025-01-10', 1),
(2, 'Renato', 'Roman', '3794000002', '2025-01-15', 1),
(3, 'Agustín', 'Elorrieta', '3794000003', '2025-02-01', 1),
(4, 'Emmanuel', 'Ottero', '3794000004', '2025-02-20', 1),
(5, 'Lucas', 'Lombardi', '3794000005', '2025-03-10', 1),
(6, 'Valeria', 'Ríos', '3794000006', '2025-06-01', 1),
(7, 'Marcos', 'Díaz', '3794000007', '2025-08-15', 1),
(8, 'Julieta', 'Sosa', '3794000008', '2026-01-05', 1);



INSERT INTO Producto (id_producto, codigo, nombre, descripcion, material, precio_lista, stock_actual, modalidad_disponible, dias_demora, requiere_senia, porcentaje_senia, activo, id_categoria) VALUES
(1, 'M-CAL-01', 'Mate Imperial Cincelado', 'Pieza única con virola', 'Calabaza/Alpaca', 35000.00, 1, 'inmediata', 0, 0, 0.00, 1, 1),
(2, 'M-MAD-02', 'Mate Camionero Algarrobo', 'Camionero de boca ancha', 'Algarrobo', 22000.00, 5, 'inmediata', 0, 0, 0.00, 1, 2),
(3, 'T-STA-01', 'Termo Stanley 1L', 'Clásico verde', 'Acero', 85000.00, 0, 'por_encargue', 30, 1, 50.00, 1, 3),
(4, 'T-TER-02', 'Termo Termolar 1L', 'Pico cebador rojo', 'Acero', 55000.00, 3, 'inmediata', 0, 0, 0.00, 1, 3),
(5, 'B-ALP-01', 'Bombilla Pico Loro', 'Cincelada a mano', 'Alpaca', 18000.00, 2, 'inmediata', 0, 0, 0.00, 1, 4),
(6, 'B-ACE-02', 'Bombilla Resorte', 'Clásica desarmable', 'Acero', 8000.00, 15, 'inmediata', 0, 0, 0.00, 1, 5),
(7, 'MAT-CUE-01', 'Matera Premium', 'Mochila 100% cuero vacuno', 'Cuero', 65000.00, 0, 'con_demora', 10, 1, 30.00, 1, 6),
(8, 'ACC-DES-01', 'Despolvillador', 'Filtro plástico', 'Plástico', 4500.00, 20, 'inmediata', 0, 0, 0.00, 1, 8);

-- 3. TABLAS CON DEPENDENCIAS DE 2DO NIVEL

INSERT INTO Promocion (id_promocion, nombre, precio_promocional, fecha_inicio, fecha_fin, activa, id_producto) VALUES
(1, 'Oferta Algarrobo', 19000.00, '2026-09-01', '2026-09-30', 1, 2),
(2, 'Termolar Flash', 49999.00, '2026-09-15', '2026-09-20', 1, 4),
(3, 'Semana del Acero', 7000.00, '2026-08-01', '2026-08-31', 0, 6),
(4, 'Combo Filtro', 3500.00, '2026-09-01', '2026-10-31', 1, 8),
(5, 'Cyber Mate Imperial', 30000.00, '2026-11-01', '2026-11-05', 0, 1),
(6, 'Seña Adelantada Stanley', 80000.00, '2026-09-01', '2026-12-31', 1, 3),
(7, 'Día de la Madre Alpaca', 15000.00, '2026-10-01', '2026-10-20', 1, 5),
(8, 'Lanzamiento Matera', 55000.00, '2026-07-01', '2026-07-15', 0, 7);

INSERT INTO Venta (id_venta, comprobante, fecha_hora, id_cliente, id_vendedor, estado, observaciones) VALUES
(1, 'FC-0001', '2026-09-10T10:30:00', 1, 1, 'entregada', 'Venta mostrador normal'),
(2, 'FC-0002', '2026-09-11T11:15:00', 2, 2, 'pagada', 'Coordinar retiro'),
(3, 'FC-0003', '2026-09-12T16:45:00', 3, 3, 'seniada', 'Termo por encargue'),
(4, 'FC-0004', '2026-09-13T09:20:00', 4, 4, 'entregada', 'Envío por correo'),
(5, 'FC-0005', '2026-09-14T18:00:00', 5, 5, 'seniada', 'Senia del 50%, resta saldo'),
(6, 'FC-0006', '2026-09-15T12:10:00', 6, 1, 'cancelada', 'Cliente se arrepintió'),
(7, 'FC-0007', '2026-09-16T14:30:00', 7, 2, 'seniada', 'Matera personalizada'),
(8, 'FC-0008', '2026-09-17T17:00:00', 8, 3, 'entregada', 'Regalo de cumpleaños');

-- 4. TABLAS CON DEPENDENCIAS DE 3ER NIVEL

INSERT INTO Venta_Detalle (id_venta, nro_renglon, id_producto, cantidad, precio_unitario, descuento_aplicado) VALUES
(1, 1, 1, 1, 35000.00, 0.00),
(2, 1, 2, 1, 19000.00, 3000.00), 
(3, 1, 3, 1, 85000.00, 0.00),
(4, 1, 4, 1, 55000.00, 0.00),
(5, 1, 5, 1, 18000.00, 0.00),
(6, 1, 6, 2, 8000.00, 0.00),
(7, 1, 7, 1, 65000.00, 0.00),
(8, 1, 8, 1, 3500.00, 1000.00); 

INSERT INTO Venta_Pago (id_venta_pago, id_venta, id_metodo_pago, importe, fecha_pago, tipo_pago) VALUES
(1, 1, 1, 35000.00, '2026-09-10', 'total'),
(2, 2, 2, 16000.00, '2026-09-11', 'total'),
(3, 3, 2, 42500.00, '2026-09-12', 'senia'),
(4, 4, 3, 61000.00, '2026-09-13', 'total'),
(5, 5, 2, 12750.00, '2026-09-14', 'senia'),
(6, 3, 1, 25000.00, '2026-09-20', 'saldo'),
(7, 7, 4, 19500.00, '2026-09-16', 'senia'),
(8, 8, 1, 7500.00, '2026-09-17', 'total');

INSERT INTO Envio (id_envio, id_venta, modalidad, direccion, localidad, provincia, codigo_postal, costo_envio, fecha_despacho, estado_envio) VALUES
(1, 1, 'retiro', 'Mostrador', 'Corrientes', 'Corrientes', '3400', 0.00, '2026-09-10', 'entregado'),
(2, 2, 'retiro', 'Mostrador', 'Corrientes', 'Corrientes', '3400', 0.00, NULL, 'pendiente'),
(3, 3, 'envio_domicilio', 'Av. 9 de Julio 123', 'CABA', 'Buenos Aires', '1001', 8500.00, NULL, 'preparando'),
(4, 4, 'envio_domicilio', 'Calle Falsa 456', 'Posadas', 'Misiones', '3300', 6000.00, '2026-09-14', 'despachado'),
(5, 5, 'envio_domicilio', 'Rivadavia 789', 'Formosa', 'Formosa', '3600', 7500.00, NULL, 'pendiente'),
(6, 6, 'envio_domicilio', 'San Martín 321', 'Rosario', 'Santa Fe', '2000', 8000.00, NULL, 'pendiente'),
(7, 7, 'entrega_coordinada', 'Plaza Cabral', 'Corrientes', 'Corrientes', '3400', 1500.00, NULL, 'preparando'),
(8, 8, 'envio_domicilio', 'Belgrano 654', 'Goya', 'Corrientes', '3450', 5000.00, '2026-09-18', 'despachado');
GO
