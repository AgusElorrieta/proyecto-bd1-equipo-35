# Etapa III — Implementación Física

**Proyecto:** Base de Datos I  
**Equipo:** 35  
**Caso de estudio:** MateSereño  
**Motor de base de datos:** Microsoft SQL Server 2022 Express  
**Herramienta utilizada:** SQL Server Management Studio 22  

## 1. Implementación del modelo

En esta etapa se llevó el modelo relacional definido anteriormente a una implementación física utilizando Microsoft SQL Server.

La base de datos creada se denomina:

`MateSerenoDB`

El modelo está compuesto por las siguientes tablas:

- Categoria
- Producto
- Promocion
- Cliente
- Vendedor
- Venta
- Venta_Detalle
- Metodo_Pago
- Venta_Pago
- Envio

## 2. Script DDL

El archivo:

`sql/ddl/crear_bd.sql`

contiene la creación de todas las tablas de la base de datos.

En el script se definieron:

- Claves primarias (PRIMARY KEY).
- Claves foráneas (FOREIGN KEY).
- Restricciones NOT NULL.
- Restricciones UNIQUE.
- Restricciones CHECK.
- Valores DEFAULT.
- Reglas ON UPDATE y ON DELETE.
- Tipos de datos adecuados para cada atributo.

Entre las restricciones implementadas se encuentran el control de stock no negativo, cantidades mayores a cero, códigos de producto únicos, teléfonos de clientes únicos y valores permitidos para estados y modalidades.

## 3. Script DML

El archivo:

`sql/dml/datos_prueba.sql`

contiene la carga inicial de datos utilizada para probar el funcionamiento de la base.

Se incorporaron 8 registros coherentes en cada una de las tablas, respetando las relaciones y claves foráneas establecidas en el modelo.

Los datos representan categorías, productos, promociones, clientes, vendedores, ventas, detalles, métodos de pago, pagos y envíos del caso MateSereño.

## 4. Pruebas realizadas

Los scripts fueron ejecutados utilizando SQL Server Management Studio 22 sobre SQL Server 2022 Express.

La ejecución del DDL permitió crear correctamente las 10 tablas definidas en el modelo.

Posteriormente se ejecutó el DML y se verificó la cantidad de registros cargados mediante consultas COUNT, obteniendo 8 registros en cada tabla.

También se verificaron las claves y restricciones del modelo mediante las herramientas de SQL Server Management Studio.

#### 4.1 Pruebas de Integridad y Restricciones  
Para garantizar la consistencia de los datos, se ejecutaron pruebas de estrés sobre las restricciones de integridad. Las operaciones DML están intrínsecamente ligadas a las restricciones definidas en el DDL, por lo que cualquier intento de inserción que viole una regla hace que la operación falle de inmediato[cite: 22]. 

Las siguientes sentencias fueron ejecutadas y rechazadas correctamente por el motor de SQL Server, por lo que no se incluyeron en el script final de poblado `datos_prueba.sql`:

* **Prueba de CHECK (Stock Negativo):** Se intentó insertar un producto con `stock_actual = -1`. La operación falló protegiendo la restricción `CHECK (stock_actual >= 0)`.
  ```sql
  INSERT INTO Producto (id_producto, codigo, nombre, precio_lista, stock_actual, modalidad_disponible, id_categoria) 
  VALUES (99, 'TEST-01', 'Mate Prueba', 1000.00, -1, 'inmediata', 1);

* **Prueba de CHECK (Cantidad Cero):** Se intentó registrar un detalle de venta con `cantidad = 0`. El motor rechazó la inserción cumpliendo la regla lógica del negocio.
  ```sql
  INSERT INTO Venta_Detalle (id_venta, nro_renglon, id_producto, cantidad, precio_unitario, descuento_aplicado) 
  VALUES (1, 99, 1, 0, 35000.00, 0.00);

* **Prueba de UNIQUE (Código Duplicado):** Se intentó insertar un producto utilizando el código existente M-CAL-01. La operación fue abortada para mantener la unicidad del catálogo.
  ```sql
  INSERT INTO Producto (id_producto, codigo, nombre, precio_lista, stock_actual, modalidad_disponible, id_categoria)
  VALUES (100, 'M-CAL-01', 'Mate Clonado', 1000.00, 5, 'inmediata', 1);

## 5. Orden de ejecución

Para reconstruir la base de datos se deben ejecutar los scripts en el siguiente orden:

1. `sql/ddl/crear_bd.sql`
2. `sql/dml/datos_prueba.sql`

El primer script genera la estructura de la base y el segundo carga los datos de prueba.

## 6. Resultado

La implementación física quedó funcionando correctamente en SQL Server, manteniendo las relaciones y restricciones establecidas durante la etapa de modelado.

Los scripts permiten reconstruir la estructura y los datos de prueba de la base de datos MateSereño.
