# 🧉 Proyecto Base de Datos I — MateSereño

> Sistema de gestión de ventas para un emprendimiento correntino dedicado a la comercialización de mates, termos, bombillas, yerbas y accesorios materos.

---

## 📌 Información del proyecto

**Materia:** Base de Datos I  
**Carrera:** Licenciatura en Sistemas de Información  
**Universidad:** Universidad Nacional del Nordeste — FaCENA  
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

El sistema propuesto busca organizar y centralizar la información necesaria para gestionar correctamente las operaciones de venta, especialmente en aspectos como:

- Control de stock
- Registro de clientes
- Gestión de vendedores
- Historial de precios
- Promociones
- Pagos parciales y señas
- Métodos de pago
- Entregas y envíos
- Registro detallado de ventas

---

## 🎯 Objetivo

Diseñar, normalizar e implementar una **base de datos relacional** capaz de soportar el ciclo completo de ventas de MateSereño.

El proyecto busca garantizar:

- Integridad referencial
- Consistencia de los datos
- Reducción de redundancia
- Trazabilidad de las operaciones
- Conservación de información histórica

---

## 🗂️ Estructura del repositorio

proyecto-bd1-equipo-35/  
│  
├── docs/  
│   ├── etapa-01/  
│   ├── etapa-02/  
│   ├── etapa-03/  
│   ├── etapa-04/  
│   └── etapa-05/  
│  
├── sql/  
│   ├── ddl/  
│   ├── dml/  
│   ├── consultas/  
│   └── tecnico/  
│  
└── README.md  

---

## 🚀 Etapas del proyecto

| Etapa | Descripción | Estado |
|---|---|---|
| I | Requerimientos y dominio del negocio | ✅ Completada |
| II | Modelado conceptual y lógico | ✅ Completada |
| III | Implementación física — DDL y DML | ✅ Completada |
| IV | Consultas y casos de uso | ✅ Implementada |
| V | Temas técnicos avanzados | ⏳ Pendiente |

---

## 🧩 Etapa I — Requerimientos

Durante esta etapa se realizó el análisis inicial del negocio y se definieron:

- Alcance del sistema
- Objetos de interés del dominio
- Reglas de negocio
- Restricciones
- Cardinalidades principales
- Decisiones iniciales de modelado

El documento correspondiente se encuentra en:

`docs/etapa-01/`

---

## 🧠 Etapa II — Modelado

La segunda etapa contempla:

### Diagrama Entidad–Relación

Se construirá un DER utilizando **notación P. Chen** mediante **ERDPlus**.

### Modelo Relacional

Se realizará la transformación del DER a relaciones, indicando:

- Claves primarias
- Claves foráneas
- Relaciones entre tablas

### Normalización

El modelo será documentado hasta alcanzar la **Tercera Forma Normal (3FN)**.

Proceso:

Modelo inicial → 1FN → 2FN → 3FN


---

## ⚙️ Etapa III — Implementación física — DDL y DML

Esta tercera etapa consiste en la construcción de la base de datos en **SQL Server 2022 Express**, contemplando:

### Script DDL (Data Definition Language)
Se encarga de la creación de tablas y restricciones, incluyendo:
- Creación de la estructura e integridad referencial (PRIMARY KEY, FOREIGN KEY con reglas de borrado/modificación).
- Definición correcta de tipos de datos (VARCHAR, DECIMAL, DATETIME, etc.).
- Implementación de restricciones formales (NOT NULL, UNIQUE, CHECK).

### Script DML (Data Manipulation Language)
Se encarga de la carga y modificación de datos[cite: 1], abordando:
- Poblado inicial de la base de datos con 8 registros coherentes por tabla para comprobación.
- Verificación en la inserción para asegurar que las restricciones de integridad operen correctamente.

### Ubicación y ejecución
Los scripts correspondientes se encuentran en la carpeta `sql/` y deben ejecutarse en el siguiente orden estricto:

1. `sql/ddl/crear_bd.sql`
2. `sql/dml/datos_prueba.sql`

---

## 📊 Etapa IV — Consultas y Casos de Uso

En esta etapa se desarrollaron los scripts SQL para resolver las necesidades de información analítica y operativa del negocio. 

### Listado de Consultas SQL
Los archivos se encuentran alojados en el directorio `sql/consultas/`:
1. `01_comprobante_venta.sql`: Detalle completo de factura y subtotales mediante funciones de ventana.
2. `02_ventas_por_vendedor.sql`: Reporte agregado de rendimiento comercial por vendedor.
3. `03_ventas_por_categoria.sql`: Reporte agregado de unidades y facturación por categoría.
4. `04_ventas_con_saldo_pendiente.sql`: Consulta avanzada con control de señas, deducción de pagos y saldos.
* `validar_etapa4.sql`: Script de validación transaccional utilizado para la auditoría de totales cruzados.

---

## 🗃️ Entidades principales

El modelo contempla actualmente las siguientes entidades:

- CATEGORIA
- PRODUCTO
- PROMOCION
- CLIENTE
- VENDEDOR
- VENTA
- VENTA_DETALLE
- METODO_PAGO
- VENTA_PAGO
- ENVIO

---

## 🔗 Relaciones principales

- CATEGORIA 1:N PRODUCTO
- PRODUCTO 1:N PROMOCION
- CLIENTE 1:N VENTA
- VENDEDOR 1:N VENTA
- VENTA 1:N VENTA_DETALLE
- PRODUCTO 1:N VENTA_DETALLE
- VENTA N:M METODO_PAGO mediante VENTA_PAGO
- VENTA 1:1 ENVIO

---

## 🛠️ Tecnologías y herramientas

- Git
- GitHub
- ERDPlus
- SQL
- Sistema Gestor de Base de Datos a definir en etapas posteriores

---

## 📚 Organización de la documentación

La carpeta `docs/` contiene el desarrollo conceptual y documental de cada etapa.

La carpeta `sql/` contendrá los scripts correspondientes a:

- `ddl/` → creación de tablas y restricciones
- `dml/` → carga y modificación de datos
- `consultas/` → consultas SQL del sistema
- `tecnico/` → procedimientos, triggers, seguridad, índices y otros mecanismos avanzados

---

## 👨‍💻 Trabajo colaborativo

El proyecto utiliza Git y GitHub para mantener la trazabilidad de los aportes realizados por cada integrante.

Durante las distintas etapas se utilizarán:

- Commits
- Issues
- Pull Requests
- Archivos de contribución individual

Esto permite registrar de forma clara la participación de cada miembro del equipo.

---

## 📄 Estado actual

Actualmente el equipo se encuentra trabajando en la:

**Etapa V: Implementación de temas técnicos**

**Próximos objetivos:**
* Descripción breve de cada uno de los temas tècnicos y fundamentos de aplicación en el caso de estudio desarrollado
* Script SQL de implementación en el motor de bases de datos
* Script SQL o resumen explicativo (en caso de corresponder) de demostración de utilización de cada tema técnico implementado.
* Temas técnicos: Procedimientos y funciones almacenadas; Manejo de transacciones; Triggers de auditorías; Seguridad; Índices (optimización)
*   **Manifiesto Individual:** Preparar y documentar la participación individual de la Etapa V.

---

<p align="center">
  <b>Proyecto Base de Datos I — Equipo 35</b><br>
  <i>MateSereño 🧉</i>
</p>
