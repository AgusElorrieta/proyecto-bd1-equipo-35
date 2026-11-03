### Manifiesto individual -- Etapa V
**Equipo:** 35   **Integrante:** Emmanuel David Otero   **Fecha:** 2026-11-03

#### 1. Aporte realizado
En esta etapa final del proyecto me encargué del desarrollo, prueba y documentación del tema técnico de **Seguridad (Usuarios, Roles y Permisos)** sobre la base de datos `MateSerenoDB` en SQL Server 2022 Express (`sql/tecnico/04_seguridad.sql` y `docs/etapa-05/04_seguridad.md`).
El trabajo incluyó la verificación del modo de autenticación mixto de la instancia, la creación de inicios de sesión y usuarios con distintos niveles de acceso (`usuario_admin` y `usuario_lector`), la demostración del control de altas mediante procedimientos almacenados frente a inserciones directas, y la implementación de seguridad basada en roles con `rol_consulta_productos` comparando `usuario_con_rol` contra `usuario_sin_rol`.
Adicionalmente, realicé la revisión y limpieza del archivo `docs/etapa-04/consultas.md` para eliminar marcas residuales de edición de la etapa anterior.

#### 2. Decisiones en las que participé
Participé en la coordinación del orden de integración de los scripts técnicos de la Etapa V y en el diseño del esquema de permisos para `MateSereño`:
- Se definió que el script de seguridad (`04_seguridad.sql`) se ejecute con posterioridad al de procedimientos y funciones almacenadas (`01_procedimientos_funciones.sql`), dado que el perfil restringido `usuario_lector` requiere que exista previamente el objeto `dbo.sp_InsertarCliente` para otorgarle el permiso `EXECUTE`.
- Se decidió utilizar las instrucciones `EXECUTE AS USER = '...'` y `REVERT` junto con bloques `TRY...CATCH` para ejecutar todas las pruebas de permisos en un único script continuo sin necesidad de desconectar la sesión actual en SQL Server Management Studio.
- Se optó por encapsular las pruebas fallidas (Error 229 de permiso denegado) dentro de bloques `BEGIN TRY ... BEGIN CATCH` para que el evaluador pueda ejecutar el script completo de una sola vez y visualizar en la grilla de resultados tanto los bloqueos de seguridad como las operaciones exitosas.

#### 3. Problemas o dificultades identificadas
Durante el desarrollo identifiqué tres aspectos técnicos a resolver:
1. Existía una dependencia directa entre el script de seguridad y el procedimiento `dbo.sp_InsertarCliente` creado en el primer tema técnico, por lo que ejecutar los scripts fuera de orden generaba un error de objeto inexistente al intentar aplicar el `GRANT EXECUTE`.
2. Al probar operaciones no autorizadas (como el `INSERT` directo de `usuario_lector` sobre `Cliente` o el `SELECT` de `usuario_sin_rol` sobre `Producto`), el error de seguridad de nivel 14 (Error 229) podía interrumpir la lectura fluida del lote si no se capturaba adecuadamente o dejar la sesión bajo el contexto del usuario restringido si no se ejecutaba `REVERT`.
3. Si el script se ejecutaba más de una vez en el mismo servidor de pruebas, la creación de logins, usuarios y roles arrojaba error por duplicidad de nombres.

#### 4. Soluciones o propuestas realizadas
Para garantizar que el script sea totalmente reproducible y libre de fallos:
- Incorporé un bloque inicial de limpieza condicional (`IF DATABASE_PRINCIPAL_ID(...) IS NOT NULL` y `IF SUSER_ID(...) IS NOT NULL`) que elimina los usuarios, el rol y los logins de prueba antes de recrearlos.
- Encapsulé cada intento de acceso no autorizado en estructuras `TRY...CATCH` que devuelven el usuario activo (`USER_NAME()`), el número de error (`ERROR_NUMBER()`) y el detalle del bloqueo (`ERROR_MESSAGE()`), asegurando que siempre se ejecute la cláusula `REVERT` al finalizar cada bloque de prueba.
- Comprobé mediante `SERVERPROPERTY('IsIntegratedSecurityOnly') = 0` que el servidor operara en modo mixto y documenté los cinco apartados requeridos y las conclusiones en `docs/etapa-05/04_seguridad.md`.

#### 5. Evidencias en el repositorio
Archivos relacionados con mi aporte:
- `sql/tecnico/04_seguridad.sql`
- `docs/etapa-05/04_seguridad.md`
- `docs/etapa-05/equipo35_etapa05_ema.md`
- `docs/etapa-04/consultas.md`

Commits relacionados:
- `Quita marcas de cita en consultas de etapa 4`
- `Agrega manejo de permisos de etapa 5`

#### 6. Reflexión individual
En esta última etapa comprendí cómo se articulan los distintos componentes avanzados de una base de datos relacional en un entorno de producción real. En particular, comprobé que los procedimientos almacenados no solo sirven para reutilizar código o mejorar el rendimiento, sino que constituyen una herramienta 
central de seguridad: gracias a la cadena de propiedad (*Ownership Chaining*), es posible permitir que un usuario operativo registre información validada mediante `EXECUTE` sin concederle jamás permisos de escritura directa (`INSERT`, `UPDATE`, `DELETE`) sobre las tablas físicas del modelo.
