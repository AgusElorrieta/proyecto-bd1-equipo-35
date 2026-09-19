# Contribución individual -- Etapa 02

**Equipo:** 35  
**Integrante:** Agustin Elorrieta  
**Fecha:** 2026-09-18

## 1. Aporte realizado

En esta etapa me encargué principalmente de armar el DER en ERDPlus y de pasar ese diseño al modelo relacional.

También organicé la estructura de la etapa 2 dentro del repositorio para que cada integrante del grupo pudiera trabajar sobre una parte distinta sin pisar el trabajo de los demás.

## 2. Decisiones en las que participé

Participé en la definición de las entidades, relaciones y cardinalidades del sistema.

También revisé cómo representar correctamente Venta_Detalle, Venta_Pago, Promocion y Envio, y cómo llevar esas relaciones al modelo relacional usando claves primarias y foráneas.

## 3. Problemas o dificultades identificadas

La principal dificultad fue entender bien la diferencia entre el DER y el modelo relacional.

Al principio había algunas claves foráneas puestas directamente en el DER y también algunas relaciones generadas por ERDPlus que no quedaban como esperábamos.

## 4. Soluciones o propuestas realizadas

Fuimos revisando las entidades y relaciones una por una hasta separar correctamente el modelo conceptual del modelo relacional.

Después corregí las claves y conexiones en ERDPlus y dejamos el modelo más ordenado y consistente con lo que habíamos definido en la primera etapa.

## 5. Evidencias en el repositorio

Archivos relacionados con mi aporte:

- `docs/etapa-02/der/der.png`
- `docs/etapa-02/modelo-relacional/modelo-relacional.png`
- `docs/etapa-02/modelo-relacional/modelo-relacional.md`

Commits relacionados:

- `Crea estructura de documentacion para etapa 2`
- `Agrega DER de MateSereno`
- `Agrega imagen del modelo relacional`
- `Documenta modelo relacional`

## 6. Reflexión individual

En esta etapa entendí mejor cómo pasar de un problema real a un modelo de base de datos.

Sobre todo me ayudó a entender la diferencia entre las relaciones del DER y las claves foráneas del modelo relacional, y por qué es importante revisar bien las cardinalidades antes de pasar a las tablas.