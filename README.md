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
| III | Implementación física — DDL y DML | 🚧 En desarrollo |
| IV | Consultas y casos de uso | ⏳ Pendiente |
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

**Etapa III — Implementación física — DDL y DML**

**Próximos objetivos:**
*   **Creación de Scripts DDL:** Codificar las sentencias `CREATE TABLE` para construir la base de datos relacional, definiendo correctamente los tipos de datos, Claves Primarias (PK) y Claves Foráneas (FK).
*   **Implementación de Restricciones:** Traducir las reglas de negocio a restricciones de base de datos (ej. restricciones `CHECK` para los estados de venta, `UNIQUE` para teléfonos, y reglas de borrado en cascada).
*   **Creación de Scripts DML:** Generar las sentencias `INSERT` para poblar las tablas con datos de prueba iniciales (clientes, productos, ventas, etc.).
*   **Organización del Repositorio:** Guardar los scripts generados en las carpetas correspondientes (`sql/ddl/` y `sql/dml/`).
*   **Manifiesto Individual:** Preparar y documentar la participación individual para la entrega del miércoles 30/09.

---

<p align="center">
  <b>Proyecto Base de Datos I — Equipo 35</b><br>
  <i>MateSereño 🧉</i>
</p>
