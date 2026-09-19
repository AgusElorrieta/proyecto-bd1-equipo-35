# Modelo Relacional — MateSereño

**Proyecto:** Base de Datos I  
**Equipo:** 35  
**Caso de estudio:** MateSereño  

## 1. Introducción

A partir del Diagrama Entidad-Relación se realizó la transformación al modelo relacional.

El modelo resultante está compuesto por relaciones que representan las entidades del dominio y sus vínculos mediante claves primarias (PK) y claves foráneas (FK).

---

## 2. Relaciones

### CATEGORIA

CATEGORIA(
- **id_categoria PK**
- nombre
- descripcion
- activa
)

La clave primaria `id_categoria` identifica de manera única cada categoría del catálogo.

---

### PRODUCTO

PRODUCTO(
- **id_producto PK**
- dias_demora
- modalidad_disponible
- requiere_senia
- codigo UNIQUE
- porcentaje_senia
- nombre
- descripcion
- material
- activo
- precio_lista
- stock_actual
- **id_categoria FK**
)

**Clave foránea:**

`id_categoria` → CATEGORIA(`id_categoria`)

Cada producto pertenece a una categoría, mientras que una categoría puede contener varios productos.

El atributo `codigo` posee una restricción de unicidad para evitar la existencia de productos con el mismo código.

---

### PROMOCION

PROMOCION(
- **id_promocion PK**
- activa
- fecha_fin
- fecha_inicio
- precio_promocional
- nombre
- **id_producto FK**
)

**Clave foránea:**

`id_producto` → PRODUCTO(`id_producto`)

Cada promoción corresponde a un único producto, mientras que un producto puede registrar diferentes promociones a lo largo del tiempo.

---

### CLIENTE

CLIENTE(
- **id_cliente PK**
- nombre
- apellido
- provincia
- localidad
- telefono UNIQUE
- email
- fecha_alta
)

La clave primaria `id_cliente` identifica cada cliente.

El atributo `telefono` es único, ya que se utiliza como dato identificador del comprador dentro del negocio.

---

### VENDEDOR

VENDEDOR(
- **id_vendedor PK**
- fecha_ingreso
- activo
- telefono
- apellido
- nombre
)

La clave primaria `id_vendedor` identifica de manera única a cada vendedor.

---

### VENTA

VENTA(
- **id_venta PK**
- comprobante UNIQUE
- observaciones
- estado
- fecha_hora
- **id_vendedor FK**
- **id_cliente FK**
)

**Claves foráneas:**

`id_vendedor` → VENDEDOR(`id_vendedor`)

`id_cliente` → CLIENTE(`id_cliente`)

Cada venta es registrada por un vendedor y puede estar asociada a un cliente registrado. También se admiten ventas a consumidores ocasionales sin cliente registrado.

El número de comprobante posee una restricción `UNIQUE`, por lo que no pueden existir dos ventas con el mismo número de comprobante.

---

### VENTA_DETALLE

VENTA_DETALLE(
- **nro_renglon PK**
- **id_venta PK, FK**
- descuento_aplicado
- precio_unitario
- **id_producto FK**
- cantidad
)

**Clave primaria compuesta:**

(`nro_renglon`, `id_venta`)

**Claves foráneas:**

`id_venta` → VENTA(`id_venta`)

`id_producto` → PRODUCTO(`id_producto`)

VENTA_DETALLE representa cada producto incluido dentro de una venta.

La combinación de `id_venta` y `nro_renglon` permite identificar de manera única cada detalle dentro de una venta.

El atributo `precio_unitario` conserva el precio efectivamente aplicado al momento de realizar la operación, evitando que posteriores cambios en el precio del producto modifiquen el historial de ventas.

---

### METODO_PAGO

METODO_PAGO(
- **id_metodo_pago PK**
- activo
- nombre
- recargo_porcentaje
)

La clave primaria `id_metodo_pago` identifica cada método de pago disponible, por ejemplo efectivo, transferencia o Mercado Pago.

---

### VENTA_PAGO

VENTA_PAGO(
- **id_venta_pago PK**
- fecha_pago
- tipo_pago
- importe
- **id_metodo_pago FK**
- **id_venta FK**
)

**Claves foráneas:**

`id_metodo_pago` → METODO_PAGO(`id_metodo_pago`)

`id_venta` → VENTA(`id_venta`)

Esta relación permite registrar los distintos pagos asociados a una venta.

Una misma venta puede poseer varios pagos, permitiendo representar operaciones con seña y saldo, incluso utilizando diferentes métodos de pago.

---

### ENVIO

ENVIO(
- **id_envio PK**
- costo_envio
- localidad
- direccion
- modalidad
- estado_envio
- fecha_despacho
- codigo_postal
- provincia
- **id_venta FK, UNIQUE**
)

**Clave foránea:**

`id_venta` → VENTA(`id_venta`)

El atributo `id_venta` también posee una restricción `UNIQUE`, garantizando que una venta no pueda tener más de un registro de envío.

Esto representa la relación 1:1 definida entre VENTA y ENVIO.

---

## 3. Resumen de claves foráneas

| Relación | Clave foránea | Referencia |
|---|---|---|
| PRODUCTO | id_categoria | CATEGORIA(id_categoria) |
| PROMOCION | id_producto | PRODUCTO(id_producto) |
| VENTA | id_cliente | CLIENTE(id_cliente) |
| VENTA | id_vendedor | VENDEDOR(id_vendedor) |
| VENTA_DETALLE | id_venta | VENTA(id_venta) |
| VENTA_DETALLE | id_producto | PRODUCTO(id_producto) |
| VENTA_PAGO | id_venta | VENTA(id_venta) |
| VENTA_PAGO | id_metodo_pago | METODO_PAGO(id_metodo_pago) |
| ENVIO | id_venta | VENTA(id_venta) |

---

## 4. Esquema general

CATEGORIA 1:N PRODUCTO

PRODUCTO 1:N PROMOCION

CLIENTE 1:N VENTA

VENDEDOR 1:N VENTA

VENTA 1:N VENTA_DETALLE

PRODUCTO 1:N VENTA_DETALLE

VENTA 1:N VENTA_PAGO

METODO_PAGO 1:N VENTA_PAGO

VENTA 1:1 ENVIO

---

## 5. Resultado

La transformación del DER al modelo relacional permite representar las entidades y relaciones del dominio mediante tablas vinculadas a través de claves primarias y foráneas.

El modelo mantiene separada la información correspondiente a clientes, productos, ventas, pagos, promociones y envíos, permitiendo conservar la integridad de las relaciones y reduciendo la redundancia de información.