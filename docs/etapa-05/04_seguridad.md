# Etapa V — Seguridad: Usuarios, Roles y Permisos

**Proyecto:** MateSereño — Base de Datos I  
**Equipo:** 35  
**Responsable:** Emmanuel David Otero  
**Motor:** Microsoft SQL Server 2022 Express  
**Script asociado:** `sql/tecnico/04_seguridad.sql`

---

## 1. Definición y objetivo

La seguridad en un Sistema Gestor de Bases de Datos (SGBD) comprende los mecanismos de **autenticación** (verificación de la identidad de quien se conecta a la instancia mediante un *Login*) y **autorización** (control granular de las operaciones que cada *Usuario* o *Rol* puede ejecutar sobre los objetos de una base de datos específica mediante sentencias DCL: `GRANT`, `DENY` y `REVOKE`).

El objetivo principal de este apartado es implementar el **principio de mínimo privilegio** en la base de datos `MateSerenoDB`, garantizando que cada perfil operativo acceda únicamente a las tablas y operaciones estrictamente necesarias para su función, y delegando las modificaciones sensibles a procedimientos almacenados controlados en lugar de permitir escritura directa sobre las tablas físicas.

---

## 2. Ventajas y aplicaciones

1. **Principio de mínimo privilegio:** Reduce la superficie de riesgo ante errores humanos o accesos no autorizados al impedir que usuarios de consulta o atención al público modifiquen o eliminen registros directamente (`INSERT`, `UPDATE`, `DELETE`).
2. **Encapsulamiento y cadena de propiedad (*Ownership Chaining*):** Al otorgar permiso `EXECUTE` sobre un procedimiento almacenado (`dbo.sp_InsertarCliente`) sin conceder permiso `INSERT` directo sobre la tabla `Cliente`, el motor valida el permiso sobre el procedimiento y ejecuta la inserción bajo las reglas y validaciones definidas por el propietario del esquema (`dbo`).
3. **Administración escalable mediante roles:** Agrupar permisos dentro de un rol (`rol_consulta_productos`) permite administrar políticas de acceso por perfil de puesto en lugar de configurar privilegios individuales usuario por usuario.
4. **Pruebas seguras de contexto sin cierre de sesión:** El uso de `EXECUTE AS USER = '...'` y `REVERT` permite al administrador auditar y verificar el comportamiento exacto de cada perfil de seguridad dentro de una misma sesión de trabajo.

---

## 3. Implementación en SQL Server Express

En Microsoft SQL Server 2022 Express, el esquema de seguridad se organiza en dos niveles jerárquicos:

* **Nivel de Instancia (Servidor):**
  * **Modo de Autenticación Mixto:** Permite tanto inicios de sesión integrados con Windows como inicios de sesión propios de SQL Server con usuario y contraseña. Se verifica mediante la función de sistema `SERVERPROPERTY('IsIntegratedSecurityOnly')`, donde el valor `0` confirma que el modo mixto se encuentra activo (mientras que `1` indica solo autenticación de Windows).
  * **Inicios de sesión (`LOGIN`):** Se crean con `CREATE LOGIN` para permitir la autenticación frente al servidor.
* **Nivel de Base de Datos (`MateSerenoDB`):**
  * **Usuarios (`USER`):** Se mapean a los inicios de sesión mediante `CREATE USER ... FOR LOGIN ...`.
  * **Roles fijos y personalizados (`ROLE`):** Se utiliza `ALTER ROLE db_owner ADD MEMBER ...` para perfiles de administración total, y `CREATE ROLE` junto con `GRANT SELECT ON ...` para perfiles personalizados de solo lectura.
  * **Control de contexto:** Las instrucciones `EXECUTE AS USER` y `REVERT` cambian temporalmente el token de seguridad de la sesión activa para comprobar los permisos efectivos de cada cuenta.

---

## 4. Caso concreto aplicado a MateSereño

En la operatoria diaria de **MateSereño**, intervienen distintos perfiles de acceso sobre `MateSerenoDB`:

1. **Administrador de la base de datos (`usuario_admin`):** Miembro del rol fijo `db_owner`, con control total sobre la estructura, mantenimiento y datos del sistema.
2. **Operador de mostrador / atención (`usuario_lector`):** Necesita consultar el padrón de clientes (`SELECT` sobre `dbo.Cliente`) y registrar nuevos compradores cuando realizan un pedido. Sin embargo, por seguridad no debe tener permiso de escritura libre (`INSERT`, `UPDATE` o `DELETE` directo) sobre la tabla `Cliente`. Para resolverlo, se le otorga únicamente `EXECUTE` sobre `dbo.sp_InsertarCliente`, obligando a que toda alta pase por el procedimiento almacenado desarrollado para el sistema.
3. **Consulta de catálogo (`rol_consulta_productos`):** Rol diseñado para vendedores o consultores de stock que solo requieren visualizar el catálogo de productos (`SELECT` sobre `dbo.Producto`). Se compara el comportamiento entre un usuario miembro del rol (`usuario_con_rol`) y otro sin membresía (`usuario_sin_rol`).

---

## 5. Script de demostración y resultados obtenidos

El script `sql/tecnico/04_seguridad.sql` ejecuta la configuración completa y las pruebas de validación:

### 5.1. Verificación del modo mixto
```sql
SELECT SERVERPROPERTY('IsIntegratedSecurityOnly') AS Es_Solo_Windows;
