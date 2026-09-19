\# Manifiesto individual — Etapa II



\*\*Integrante:\*\* Renato Uriel Roman

\*\*Proyecto:\*\* MateSereño — Base de Datos I

\*\*Etapa:\*\* II



\---



\*\*Qué hice:\*\* pasé el DER que armamos en la Etapa I al modelo relacional, usando ERDPlus. Cargué las tablas con sus columnas, marqué las PK y FK, y fui conectando cada tabla con la que le correspondía.



\*\*En qué participé:\*\* en la parte de diseño lógico, o sea, convertir el diagrama entidad-relación en las tablas con sus claves.



\*\*Qué decisión ayudé a tomar:\*\* que venta\_pago tenga su propio id en vez de usar solo la combinación de venta y método de pago, porque si no, no se podían registrar dos pagos con el mismo método en fechas distintas (por ejemplo seña y saldo los dos por transferencia). También quedó que venta\_detalle tiene clave compuesta (id\_venta + nro\_renglon), porque depende de la venta.



\*\*Qué problema encontré/resolví:\*\* al ir conectando las tablas me di cuenta de que había quedado mal armado en algunos lugares (por ejemplo Cliente conectado con Promocion, y Vendedor conectado con Cliente, cosas que no tenían que estar relacionadas). Las fui revisando una por una comparando con las reglas del proyecto hasta que quedó bien.



\*\*Enlaces a GitHub:\*\*

\- Commit: https://github.com/AgusElorrieta/proyecto-bd1-equipo-35/commit/c97ef9b

\- Pull request: no aplica, se subió directo a main



\*\*Qué aprendí:\*\* a pasar el DER a tablas reales, viendo bien cuándo una relación se resuelve con una FK simple y cuándo hace falta una tabla aparte con su propia clave. También aprendí que cuando se cambia una PK compuesta por una simple hay que agregar un UNIQUE para no perder la regla que antes cuidaba esa clave.

