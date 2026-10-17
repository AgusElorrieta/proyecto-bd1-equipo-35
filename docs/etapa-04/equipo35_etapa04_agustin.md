# Contribución individual – Etapa IV

**Equipo:** 35  
**Integrante:** Agustín Elorrieta  
**Fecha:** 17/10/2026

## 1. Aporte realizado

En esta etapa me encargué de desarrollar la consulta SQL para generar el comprobante de una venta del sistema MateSereño.

Creé el archivo `sql/consultas/01_comprobante_venta.sql`, que permite consultar una venta mediante su identificador y obtener los datos del comprobante, el cliente, el vendedor y los productos vendidos.

También preparé los archivos de los manifiestos individuales de la Etapa IV para que cada integrante pudiera completar su contribución.

## 2. Decisiones en las que participé

Para realizar la consulta utilicé JOIN para relacionar las tablas Venta, Cliente, Vendedor, Venta_Detalle, Producto y Envio.

Decidí utilizar LEFT JOIN para contemplar las ventas realizadas a consumidores ocasionales y las ventas que podrían no tener un envío asociado.

Para calcular los importes utilicé la cantidad multiplicada por el precio unitario, restando el descuento aplicado. También utilicé SUM con OVER para calcular el subtotal general de la venta sin perder los datos de cada renglón.

## 3. Problemas o dificultades identificadas

Una de las dificultades fue reunir información de varias tablas en una misma consulta y mostrarla de manera ordenada.

También fue necesario revisar cómo estaban definidos los descuentos y los envíos para calcular correctamente el total del comprobante.

## 4. Soluciones realizadas

Revisé la estructura de las tablas y sus relaciones en el script DDL de la etapa anterior.

Después desarrollé la consulta utilizando un identificador de venta como parámetro, para poder consultar distintos comprobantes sin modificar toda la sentencia SQL.

Se realizó una revisión del código y de su correspondencia con el modelo de datos. La ejecución en SQL Server quedó pendiente de verificación.

## 5. Evidencias en el repositorio

- `sql/consultas/01_comprobante_venta.sql`
- `docs/etapa-04/equipo35_etapa04_agustin.md`
- Creación de los manifiestos individuales de la Etapa IV.
- Commit: `4238fc9` — Agrega consulta de comprobante y manifiestos de etapa 4.

## 6. Reflexión individual

Esta etapa me ayudó a comprender mejor cómo utilizar consultas SQL para obtener información útil a partir de varias tablas relacionadas.

También pude practicar el uso de JOIN y funciones de suma para calcular los importes de una venta, y entender cómo se puede generar un comprobante a partir de los datos almacenados en la base.    