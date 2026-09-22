Manifiesto Individual - Etapa II: Modelado Conceptual y Lógico

Integrante: Lombardi Lucas

Que Hice
  Realice el analisis de la normalizacion del modelo relacional para las diez relaciones del sistema, verificando el cumplimiento de cada forma de relacion por relacion, justificando para el informe del proyecto.

En que participe
  Participé en la revisión del modelo relacional resultante de la transformación del DER, validando que las claves primarias, claves foráneas y restricciones 
  (UNIQUE, clave compuesta en VENTA_DETALLE) estuvieran correctamente reflejadas antes de aplicar el análisis de formas normales.

Que decision ayude a tomar
  Identifique un punto para tratar acerca de la dependencia transitiva detectada en CLIENTE y ENVIO, como una simplificacion aceptada del modelo, o si conviene descomponerla en tablas para cumplir 3FN en sentido estricto.

Qué problema encontré/resolví

  Detecté que CLIENTE y ENVIO no cumplen 3FN en sentido estricto, por la dependencia transitiva entre localidad y provincia (agravada por codigo_postal en ENVIO). 
  Propuse como solución extraer la jerarquía geográfica a tablas propias vinculadas por FK, dejando a criterio del equipo si aplicarla o documentarla como decisión de diseño.

Enlaces o referencias a la evidencia en GitHub
  
  Subida de la documentacion de la normalizacion del modelo relacional en docs/etapa-02/normalizacion.md

Qué aprendí

  Aprendí que normalizar no es solo chequear una lista de reglas contra el esquema, sino razonar sobre el significado real de los datos que es detectar 
  una dependencia transitiva como la geográfica requiere entender la semántica del dominio

