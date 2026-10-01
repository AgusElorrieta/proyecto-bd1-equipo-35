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

## 5. Orden de ejecución

Para reconstruir la base de datos se deben ejecutar los scripts en el siguiente orden:

1. `sql/ddl/crear_bd.sql`
2. `sql/dml/datos_prueba.sql`

El primer script genera la estructura de la base y el segundo carga los datos de prueba.

## 6. Resultado

La implementación física quedó funcionando correctamente en SQL Server, manteniendo las relaciones y restricciones establecidas durante la etapa de modelado.

Los scripts permiten reconstruir la estructura y los datos de prueba de la base de datos MateSereño.