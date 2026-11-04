# 🧉 Proyecto Base de Datos I — MateSereño

> Sistema de gestión de ventas para un emprendimiento correntino dedicado a la comercialización de mates, termos, bombillas, yerbas y accesorios materos.

---

## 📌 Información del proyecto

**Materia:** Base de Datos I  
**Carrera:** Licenciatura en Sistemas de Información  
**Universidad:** Universidad Nacional del Nordeste (UNNE) — FaCENA  
**Equipo:** 35

### 👥 Integrantes

- Agustin Elorrieta
- Renato Roman
- Emmanuel Otero
- Lucas Lombardi
- Martin Espinoza

---

## 🧉 Caso de estudio: MateSereño

MateSereño es un emprendimiento dedicado a la venta de productos materos premium, incluyendo mates artesanales, termos, bombillas, yerbas, materas y yerberas.

El sistema busca organizar y centralizar la información necesaria para gestionar las operaciones de venta, especialmente en aspectos como:

- Control de stock.
- Registro de clientes y vendedores.
- Conservación de precios de venta e historial de operaciones.
- Promociones y descuentos.
- Pagos parciales, señas y métodos de pago.
- Entregas y envíos.
- Registro detallado de las ventas.

---

## 🎯 Objetivo

Diseñar, normalizar e implementar una **base de datos relacional** capaz de soportar el ciclo de ventas de MateSereño y favorecer:

- La integridad referencial y la consistencia de los datos.
- La reducción de redundancia.
- La trazabilidad de las operaciones.
- La conservación de información histórica.
- La seguridad, la confiabilidad y el rendimiento de las consultas.

---

## 🗂️ Estructura del repositorio

```text
proyecto-bd1-equipo-35/
├── docs/
│   ├── etapa-01/
│   ├── etapa-02/
│   ├── etapa-03/
│   ├── etapa-04/
│   └── etapa-05/
├── sql/
│   ├── ddl/
│   ├── dml/
│   ├── consultas/
│   └── tecnico/
└── README.md
```

---

## 🚀 Etapas del proyecto

| Etapa | Descripción | Estado |
|:---:|---|---|
| I | Requerimientos y dominio del negocio | ✅ Completada |
| II | Modelado conceptual y lógico | ✅ Completada |
| III | Implementación física — DDL y DML | ✅ Completada |
| IV | Consultas y casos de uso | ✅ Completada |
| V | Temas técnicos avanzados | ✅ Completada |

---

## 🧩 Etapa I — Requerimientos

Se analizó el negocio y se definieron el alcance del sistema, los objetos de interés del dominio, las reglas de negocio, las restricciones, las cardinalidades principales y las decisiones iniciales de diseño.

**Documentación:** [`docs/etapa-01/`](docs/etapa-01/)

---

## 🧠 Etapa II — Modelado

Se desarrolló el modelo conceptual y lógico de la base de datos:

- **Diagrama Entidad–Relación (DER):** elaborado con notación de P. Chen mediante ERDPlus.
- **Modelo relacional:** definición de relaciones, claves primarias y claves foráneas.
- **Normalización:** análisis del modelo y documentación del proceso desde la primera hasta la tercera forma normal (1FN, 2FN y 3FN).
- **Decisiones de diseño:** registro de los criterios utilizados para organizar la información y sus relaciones.

**Documentación:** [`docs/etapa-02/`](docs/etapa-02/)

---

## ⚙️ Etapa III — Implementación física (DDL y DML)

Se implementó la base de datos **`MateSerenoDB`** en **Microsoft SQL Server 2022 Express**.

### Script DDL

[`sql/ddl/crear_bd.sql`](sql/ddl/crear_bd.sql)

Define las tablas, claves primarias (`PRIMARY KEY`), claves foráneas (`FOREIGN KEY`), reglas de actualización y eliminación, tipos de datos y restricciones de integridad (`NOT NULL`, `UNIQUE` y `CHECK`).

### Script DML

[`sql/dml/datos_prueba.sql`](sql/dml/datos_prueba.sql)

Contiene los registros de prueba utilizados para comprobar las relaciones entre las tablas y las restricciones del modelo.

### Orden de ejecución inicial

1. `sql/ddl/crear_bd.sql`
2. `sql/dml/datos_prueba.sql`

> **Precaución:** estos scripts pueden recrear tablas o limpiar datos. Deben ejecutarse en una base de pruebas; no volver a ejecutarlos sobre información que se desea conservar.

**Documentación:** [`docs/etapa-03/`](docs/etapa-03/)

---

## 📊 Etapa IV — Consultas y casos de uso

Se desarrollaron consultas SQL para responder a necesidades operativas y de análisis de las ventas.

| Archivo | Necesidad que resuelve |
|---|---|
| [`01_comprobante_venta.sql`](sql/consultas/01_comprobante_venta.sql) | Comprobante de venta con encabezado, detalle, subtotal por renglón y total final. |
| [`02_ventas_por_vendedor.sql`](sql/consultas/02_ventas_por_vendedor.sql) | Reporte de cantidad de ventas y facturación por vendedor en un período. |
| [`03_ventas_por_categoria.sql`](sql/consultas/03_ventas_por_categoria.sql) | Reporte de unidades vendidas y facturación por categoría. |
| [`04_ventas_con_saldo_pendiente.sql`](sql/consultas/04_ventas_con_saldo_pendiente.sql) | Consulta avanzada para identificar ventas con pagos parciales y saldos pendientes. |
| [`validar_etapa4.sql`](sql/consultas/validar_etapa4.sql) | Consultas auxiliares para comprobar la coherencia de los resultados. |

Se aplicaron operaciones `JOIN`, funciones de agregación, agrupamiento y filtros según la necesidad de cada reporte.

**Documentación:** [`docs/etapa-04/`](docs/etapa-04/)

---

## 🔧 Etapa V — Temas técnicos avanzados

Se abordaron cinco mecanismos de SQL Server para reforzar la confiabilidad, la seguridad, la mantenibilidad y el rendimiento del sistema.

### 1. Procedimientos y funciones almacenadas

Se desarrollaron rutinas almacenadas para centralizar operaciones y cálculos del negocio, evitando repetir lógica SQL en distintos lugares.

- **Script:** [`sql/tecnico/01_procedimientos_funciones.sql`](sql/tecnico/01_procedimientos_funciones.sql)
- **Documentación:** [`docs/etapa-05/01_procedimientos_funciones.md`](docs/etapa-05/01_procedimientos_funciones.md)

### 2. Manejo de transacciones

Se implementó un procedimiento que registra el encabezado de una venta, incorpora su detalle y actualiza el stock dentro de una transacción, utilizando `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK` y `TRY/CATCH`.

Se realizaron pruebas de venta correcta, stock insuficiente, error forzado después de insertar el encabezado y transacciones anidadas mediante `SAVE TRANSACTION`. Las pruebas verificaron que, ante los errores, no quedaran ventas ni detalles parciales y se conservara el stock original.

- **Script:** [`sql/tecnico/02_transacciones.sql`](sql/tecnico/02_transacciones.sql)
- **Documentación:** [`docs/etapa-05/02_transacciones.md`](docs/etapa-05/02_transacciones.md)

### 3. Triggers de auditoría

Se trabajó con disparadores para registrar cambios en los productos, incluyendo datos anteriores y posteriores, fecha, operación y usuario. También se contempló un mecanismo de control para impedir la eliminación directa de ventas.

- **Script:** [`sql/tecnico/03_triggers_auditoria.sql`](sql/tecnico/03_triggers_auditoria.sql)
- **Documentación:** [`docs/etapa-05/03_triggers_auditoria.md`](docs/etapa-05/03_triggers_auditoria.md)

### 4. Seguridad y permisos

Se abordó el control de acceso mediante usuarios, roles y permisos, diferenciando operaciones de lectura, modificación y ejecución de procedimientos almacenados.

- **Script:** [`sql/tecnico/04_seguridad.sql`](sql/tecnico/04_seguridad.sql)
- **Documentación:** [`docs/etapa-05/04_seguridad.md`](docs/etapa-05/04_seguridad.md)

### 5. Optimización de consultas mediante índices

Se preparó un caso de prueba con una tabla de ventas históricas para comparar el acceso a los datos sin índice, con índice agrupado y con índice de cobertura. Las mediciones de rendimiento se documentan por separado, ya que dependen del entorno donde se ejecuten.

- **Script:** [`sql/tecnico/05_indices.sql`](sql/tecnico/05_indices.sql)
- **Documentación:** [`docs/etapa-05/05_indices.md`](docs/etapa-05/05_indices.md)

### Orden de ejecución recomendado

Una vez creada y cargada `MateSerenoDB`, los scripts de la etapa se organizan de este modo:

1. `sql/tecnico/01_procedimientos_funciones.sql`
2. `sql/tecnico/02_transacciones.sql`
3. `sql/tecnico/03_triggers_auditoria.sql`
4. `sql/tecnico/04_seguridad.sql`
5. `sql/tecnico/05_indices.sql`

Este orden refleja las dependencias previstas entre los scripts, especialmente la utilización de procedimientos en las pruebas de seguridad. **Antes de ejecutar cada archivo, consultar sus instrucciones y realizar las pruebas en un entorno controlado.** Algunos scripts crean objetos, usuarios, permisos o grandes volúmenes de datos.

**Documentación y manifiestos individuales:** [`docs/etapa-05/`](docs/etapa-05/)

---

## 🗃️ Entidades principales

El modelo contempla diez tablas:

- `Categoria`
- `Producto`
- `Promocion`
- `Cliente`
- `Vendedor`
- `Venta`
- `Venta_Detalle`
- `Metodo_Pago`
- `Venta_Pago`
- `Envio`

---

## 🔗 Relaciones principales

- `Categoria` 1:N `Producto`
- `Producto` 1:N `Promocion`
- `Cliente` 1:N `Venta` (el cliente puede ser opcional en una venta)
- `Vendedor` 1:N `Venta`
- `Venta` 1:N `Venta_Detalle`
- `Producto` 1:N `Venta_Detalle`
- `Venta` N:M `Metodo_Pago`, mediante `Venta_Pago`
- `Venta` 1:0..1 `Envio`

---

## 🛠️ Tecnologías y herramientas

- Microsoft SQL Server 2022 Express.
- SQL Server Management Studio (SSMS).
- SQL / T-SQL.
- ERDPlus.
- Git y GitHub.
- Markdown para documentación y manifiestos individuales.

---

## 📚 Organización de la documentación

La carpeta [`docs/`](docs/) contiene los materiales elaborados para cada etapa y los manifiestos individuales de sus integrantes.

La carpeta [`sql/`](sql/) agrupa los scripts según su propósito:

- `ddl/`: definición de tablas y restricciones.
- `dml/`: carga de datos de prueba.
- `consultas/`: comprobantes, reportes y consultas de negocio.
- `tecnico/`: procedimientos, funciones, transacciones, triggers, seguridad e índices.

---

## 👨‍💻 Trabajo colaborativo

El proyecto utiliza Git y GitHub para mantener un historial de cambios y facilitar la colaboración entre los integrantes del Equipo 35.

Las contribuciones se registran mediante commits, archivos compartidos y manifiestos individuales. Los *issues* y *pull requests* pueden utilizarse cuando corresponda para organizar revisiones y mejoras.

---

## 📄 Estado actual

Las **cinco etapas previstas del proyecto** se encuentran documentadas y organizadas en este repositorio, desde el análisis inicial y el modelado hasta la implementación SQL, las consultas de negocio y los temas técnicos avanzados.

La base de datos utilizada es **`MateSerenoDB`**, sobre **Microsoft SQL Server 2022 Express**. Los resultados de las pruebas y las decisiones de implementación se desarrollan en los documentos de cada etapa.

---

**Proyecto Base de Datos I — Equipo 35**  
*MateSereño 🧉*
