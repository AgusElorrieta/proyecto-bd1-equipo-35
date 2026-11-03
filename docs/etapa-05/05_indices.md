# Tema Técnico: Optimización con Índices


## 1. Descripción y Fundamentos
En bases de datos con alto volumen transaccional, buscar información filtrando por fechas (como reportes mensuales) sin estructuras de optimización obliga al motor a leer físicamente toda la tabla (*Table Scan*). La implementación de índices estructurados (Agrupados y No Agrupados con `INCLUDE`) reduce drásticamente las lecturas lógicas de disco (I/O) y el uso de CPU. Se implementó una tabla aislada `Venta_Historica` cargada con 1.000.000 de registros para demostrar empíricamente esta mejora.

## 2. Demostración y Pruebas
Las pruebas se midieron activando `SET STATISTICS IO ON` y `SET STATISTICS TIME ON`. Se buscó un rango de fechas de un mes completo.

* **Prueba A (Sin índice sobre la fecha):**
  Al no tener la fecha indexada, el plan de ejecución muestra un *Table Scan*. El motor debió leer las páginas de datos del millón de registros para encontrar las coincidencias. Altos tiempos de CPU y lecturas lógicas elevadas.
* **Prueba B (Índice Agrupado / Clustered):**
  Se creó `CIX_VentaHistorica_Fecha`. El plan de ejecución cambió a *Clustered Index Seek*. El motor navegó directamente por el árbol B-Tree ordenado físicamente por fecha. Las lecturas lógicas cayeron drásticamente, mejorando el tiempo de respuesta.
* **Prueba C (Índice Cubierto con INCLUDE):**
  Tras borrar el agrupado, se creó `IX_VentaHistorica_Fecha_Cover INCLUDE (total)`. El plan mostró un *Index Seek (NonClustered)*. Al usar `INCLUDE`, el índice contiene en sus hojas el campo `total`. El motor resolvió toda la consulta solo leyendo el índice, sin necesidad de hacer *Key Lookups* hacia la tabla física.
