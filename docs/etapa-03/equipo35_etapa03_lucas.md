# Contribución Individual — Etapa 03

**Equipo:** 35
**Integrante:** Lombardi Lucas
**Fecha:** 2026-09-30

## 1. Aporte realizado
Revisé las restricciones de integridad (PK, FK, UNIQUE, CHECK, NOT NULL, DEFAULT) del script DDL de la Etapa 3 Implementación Física, SQL Server 2022, verificando que reflejen correctamente las reglas de negocio del modelo relacional normalizado en la Etapa 2.

## 2. Decisiones en las que participé
Validé el criterio de `ON DELETE` adoptado y las dos restricciones UNIQUE agregadas en esta etapa que no estaban en el modelo original (`nombre` en Metodo_Pago y `(id_venta, id_producto)` en Venta_Detalle).

## 3. Problemas o dificultades identificadas
Encontré dos reglas de negocio que ya estaban implícitas en el modelo pero que el DDL todavía no forzaba:
- En Producto, nada impedía una combinación inconsistente entre `requiere_senia` y `porcentaje_senia`.
- En Venta_Detalle, `descuento_aplicado` podía superar el subtotal del renglón y dejar un importe final negativo.

## 4. Soluciones o propuestas realizadas
Propuse una restricción CHECK para cada problema detectado:
- `CK_Producto_SeniaConsistente`: exige `porcentaje_senia > 0` únicamente cuando `requiere_senia = 1`.
- `CK_VentaDetalle_DescuentoMaximo`: `descuento_aplicado <= precio_unitario * cantidad`.

El detalle completo de cada ALTER TABLE queda documentado en el informe técnico de la revisión, dentro del repositorio.

## 5. Evidencias en el repositorio
- sql/ddl/crear_bd.sql

## 6. Reflexión individual
Esta revisión me mostró que una restricción puede estar "completa" en el sentido estructural (todas las PK y FK bien puestas) y aun así dejar pasar reglas de negocio reales si no se las piensa explícitamente: varias de las que encontré no eran errores de sintaxis, sino supuestos que nadie había puesto por escrito todavía.
