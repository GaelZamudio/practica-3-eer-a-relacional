# Contribuir a la Práctica 3

Este documento describe cómo organizar y revisar las contribuciones del equipo para la **Práctica 3: Transformación del modelo entidad-relación extendido al modelo relacional**.

## Organización del trabajo

Cada integrante es responsable de una zona del diagrama EER. El trabajo de cada zona sigue estas fases, en orden:

1. **Inventario (ejercicio 2):** registrar las entidades, atributos, relaciones, cardinalidades, jerarquías y atributos especiales de la zona en el documento compartido de SharePoint.
2. **Transformación (ejercicios 3 a 5 y 6.1):** documentar la regla aplicada a cada elemento y la tabla resultante. Preparar una ficha por tabla con columnas, tipos, clave primaria, claves foráneas y acciones `ON DELETE`/`ON UPDATE`.
3. **SQL (ejercicio 6.2):** traducir las fichas aprobadas a un archivo dentro de `proyecto-propio/sql/partes/` y ejecutarlo en el contenedor del proyecto propio.
4. **Pruebas de restricciones:** agregar instrucciones `INSERT` que el gestor rechace, conservar los mensajes de error y guardar la captura de evidencia correspondiente.
5. **Cierre documental (ejercicios 6.4 y 6.5):** completar en SharePoint el diccionario de datos de la zona y demostrar que la transformación conserva los elementos y las restricciones del modelo EER.
6. **Pull request:** integrar los archivos SQL, las pruebas y la evidencia en la rama `practica3` mediante un PR. Los documentos de SharePoint se exportarán a PDF al cierre del trabajo y se incorporarán al repositorio.

## Responsabilidades por zona

- **Alejandro — Personas y hogares:** Persona, Zona, Hogar temporal, Rescatista, Adoptante y Veterinario voluntario; relaciones `es responsable de` y `ubicado en`; jerarquía de Persona; atributos compuestos, multivaluados y derivados.
- **Gael — Rescate, animal y adopción:** Rescate, Animal, Perro, Gato, Otro y Seguimiento posadopción; relaciones de rescate, estancia, participación, adopción y seguimiento; jerarquía de Animal, relación ternaria y atributo derivado `esterilizado`.
- **José — Atención médica:** Atención médica, Vacunación, Cirugía, Tratamiento, Clínica y Vacuna; relaciones `recibe`, `realizada por`, `se realiza en` y `aplica`; jerarquía de Atención médica y entidad débil correspondiente.

Las zonas comparten entidades y relaciones del modelo. Antes de agregar una clave foránea hacia una tabla que mantiene otra persona, coordinar el nombre, tipo y clave acordados. No se deben duplicar tablas ni redefinir una misma entidad en partes distintas.

## Convenciones para SQL
- Usar minúsculas, snake_case y nombres en español, sin acentos ni espacios.
- Usar nombres de tablas en singular: persona, rescate, atencion_medica.
- Mantener exactamente el mismo nombre para una entidad o atributo compartido entre zonas. No crear variantes como id_animal, animal_id y animal.
- Usar id_<entidad> para identificadores: id_persona, id_rescate.
- Nombrar las claves foráneas igual que la clave referenciada: adoptante.id_persona referencia persona.id_persona.
- Evitar palabras reservadas de SQL como nombres de tablas o columnas. No usar abreviaturas salvo que estén acordadas.
- Escribir una instrucción por línea cuando sea posible y terminar cada sentencia con ;.
- Escribir palabras clave SQL en mayúsculas para facilitar la lectura: CREATE TABLE, PRIMARY KEY, FOREIGN KEY, REFERENCES, CHECK, NOT NULL.

## Ramas y Pull Requests

- La rama de integración de la práctica es `practica3`, creada a partir de la rama principal del repositorio.
- Cada integrante trabaja en una rama propia basada en `practica3`. Llamada `practica3/<nombre_integrante>`.
- Mantener cada rama enfocada en la zona asignada. No incluir cambios ajenos a la práctica.
- Antes de abrir el PR, actualizar la rama con los cambios recientes de `practica3` y resolver conflictos sin sobrescribir el trabajo de otros integrantes.
- Abrir el PR con destino a `practica3`, describir la zona y los archivos incluidos, y enlazar la evidencia relevante.
- Al menos otro integrante debe revisar el PR. Resolver sus comentarios y esperar la aprobación antes de fusionarlo.
- Cada integrante debe dejar confirmaciones propias en fechas distintas, como solicita la práctica. Usar mensajes de commit claros que describan el cambio realizado.

Nombres de ramas:

```text
practica3/gael
practica3/alejandro
practica3/jose
```

Ejemplos de mensajes de commit:

```text
feat(inventario): agrega inventario de personas y hogares
feat(ddl): define tablas de rescate y adopción
fix(transformacion): actualiza diagrama
```

## Ubicación de archivos

- SQL por zona: `practica3/proyecto-propio/sql/partes/`.
- Pruebas de rechazo por zona: junto a las partes SQL, con nombres `pruebas_a.sql`, `pruebas_b.sql` y `pruebas_c.sql`.
- Evidencias: `practica3/evidencias/`, con nombres descriptivos y numeración acordada en el README.
- Documentos finales exportados en PDF: las carpetas `proyecto-propio/` y `proyecto-asignado/` según corresponda.
- Los archivos consolidados `esquema.sql` y `pruebas-de-restricciones.sql` se generan a partir de las partes revisadas. No editarlos por separado de sus fuentes; si cambia una parte, regenerar el consolidado.

Conservar los nombres de archivo y las convenciones del README del equipo. No subir documentos como enlaces externos: los PDF finales deben quedar dentro del repositorio.

## Revisión antes de abrir un PR

Comprueba que:

- Las tablas implementan las fichas aprobadas y usan tipos compatibles con las tablas relacionadas.
- Las claves primarias y foráneas, restricciones y acciones referenciales corresponden al modelo documentado.
- El SQL de la zona se ejecutó sin errores en el contenedor correcto.
- Las pruebas incluyen casos que el gestor rechaza y se guardó la evidencia con el mensaje de error.
- El diccionario y la comprobación de preservación del significado están completos en SharePoint.
- El PR apunta a `practica3`, tiene descripción clara y solicita revisión de otro integrante.
