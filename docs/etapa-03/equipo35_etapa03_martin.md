
# Manifiesto Individual - Etapa III: Implementación Física
**Integrante:** Martin Espinoza

**EQUIPO:** 35

**FECHA:** 30/09/2026

### Qué hice
Realicé las pruebas de integridad sobre la base de datos `MateSerenoDB`. Una vez ejecutados los scripts DDL y DML, diseñé un lote de pruebas para verificar que el motor SQL Server aplicara correctamente las restricciones lógicas y referenciales configuradas en las tablas.

### En qué participé
En la auditoría de la estructura de tablas y en la validación de que el poblado inicial de datos (`datos_prueba.sql`) cumpliera con las reglas de negocio sin generar errores de sintaxis o dependencias.

### Qué decisión ayudé a tomar
Definí junto al equipo que las consultas `INSERT` diseñadas para fallar (pruebas de estrés) no debían incluirse comentadas en el script DML principal para mantenerlo limpio. En su lugar, decidí documentar los rechazos del motor en una sub-sección específica dentro del archivo `implementacion.md`.

### Qué problema encontré / resolví
Validé la robustez del modelo forzando errores intencionales. Comprobé exitosamente que el motor bloquea:
* Inserciones con stock negativo (validación de `CHECK`).
* Detalles de venta con cantidades nulas (validación de `CHECK`).
* Duplicación de códigos de producto (validación de `UNIQUE`).

### Enlaces o referencias a la evidencia en GitHub
* Subida del script de poblado inicial `sql/dml/datos_prueba.sql`.
* Documentación de las pruebas de restricciones en la sección 4.1 de `docs/implementacion.md`.

### Qué aprendí
Comprendí de manera práctica cómo las operaciones de manipulación de datos (DML) están completamente subordinadas a las reglas definidas en el DDL[cite: 22]. Aprendí que un diseño físico robusto actúa como un escudo automático que protege la integridad de la base de datos sin depender exclusivamente de la lógica de la aplicación.
