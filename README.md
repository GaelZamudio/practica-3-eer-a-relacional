# Instituto Politécnico Nacional
## Escuela Superior de Cómputo (ESCOM)

**Asignatura:** Bases de Datos  
**Grupo:** 3BV1  
**Práctica 3:** Modelo EER a Relacional

---

### Integrantes del Equipo
- **Espinosa Ramirez José Luis**
- **Rojas Castro Alejandro Tonatiuh**
- **Zamudio Monroy Gael Armando**

---

## Descripción de la Práctica

El objetivo principal de esta práctica es transformar el diseño conceptual obtenido en la **Práctica 2 (Modelo Entidad-Relación Extendido - EER)** a un **esquema relacional** implementado en **PostgreSQL**, preservando la semántica, cardinalidades, jerarquías de generalización/especialización, atributos compuestos, multivaluados, derivados y restricciones de integridad.

Adicionalmente, se incluye el análisis y extensión de esquema para el **proyecto asignado** (*Seismic Data Visualization System*), implementando propuestas de cambio a nivel DDL con sus respectivas evidencias de ejecución.

---

## División de Zonas y Responsabilidades

Para el desarrollo del **proyecto propio** (Sistema de Rescate, Cuidado y Adopción de Animales), el modelo EER se dividió en tres zonas colaborativas:

| Zona | Responsable | Módulos y Entidades Principales |
| :--- | :--- | :--- |
| **Zona A: Personas y Hogares** | **Alejandro Rojas** | Entidad `persona` y su jerarquía (`rescatista`, `adoptante`, `veterinario`), `hogar_temporal`, atributo multivaluado `hogar_especie` y catálogo de `zona`. |
| **Zona B: Rescate, Animal y Adopción** | **Gael Zamudio** | Entidades `rescate`, `animal` y su especialización (`perro`, `gato`, `otro`), relaciones de estancia en hogares, adopciones y `seguimiento_posadopcion`. |
| **Zona C: Atención Médica y Salud** | **José Luis Espinosa** | Jerarquía de `atencion_medica` (`vacunacion`, `cirugia`, `tratamiento`), `clinica`, catálogo de `vacuna`, entidad débil y recetas. |

---

## Instrucciones de Ejecución

### 1. Proyecto Propio (Esquema Completo)

Para desplegar la base de datos relacional del proyecto propio en PostgreSQL:

```bash
# Ejecutar el contenedor y mediante la BD de PostgreSQL ejecutar el esquema consolidado:
psql -U postgres -d postgres -f proyecto-propio/sql/esquema.sql
```

Alternativamente, si se desea ejecutar por módulos en orden de dependencia:
```bash
psql -U postgres -d postgres -f proyecto-propio/sql/partes/01_a_personas_hogares.sql
psql -U postgres -d postgres -f proyecto-propio/sql/partes/02_b_rescate_animal_adopcion.sql
psql -U postgres -d postgres -f proyecto-propio/sql/partes/03_c_salud.sql
```

### 2. Pruebas de Integridad y Restricciones

Cada zona incluye pruebas con instrucciones `INSERT` formuladas para validar que el gestor rechace violaciones a las reglas del negocio (claves foráneas inválidas, valores nulos prohibidos, unicidad o checks):

```bash
psql -U postgres -d postgres -f proyecto-propio/sql/partes/pruebas_a.sql
psql -U postgres -d postgres -f proyecto-propio/sql/partes/pruebas_b.sql
psql -U postgres -d postgres -f proyecto-propio/sql/partes/pruebas_c.sql
```



## Evidencias de Ejecución

En la carpeta [`evidencias/`](file:///c:/Users/Gael/OneDrive/Escritorio/practica-3-eer-a-relacional/evidencias) se encuentran los respaldos visuales de:
1. Creación exitosa de tablas y listado en PostgreSQL (`\dt`).
2. Comprobación y rechazo controlado de restricciones de integridad (`NOT NULL`, `UNIQUE`, `FOREIGN KEY`, `CHECK`).
3. Creación y consulta de nuevas estructuras en el esquema del proyecto asignado.
