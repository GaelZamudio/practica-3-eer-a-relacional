-- =====================================================================
-- Pruebas de restricciones: Zona A
-- Responsable: Alejandro
-- Estas instrucciones DEBEN FALLAR. No se incluyen en esquema.sql.
-- Cada prueba lleva: qué restricción viola y el mensaje de error
-- que devuelve el gestor (copiado de la ejecución real).
-- =====================================================================

-- Datos válidos de apoyo (estos SÍ se insertan; las pruebas los necesitan)
INSERT INTO zona (id_zona, colonia, municipio, entidad)
VALUES (1, 'Lindavista', 'Gustavo A. Madero', 'Ciudad de México');
INSERT INTO persona (id_persona, nombres, ap_paterno, ap_materno, telefono, correo, fecha_registro)
VALUES (1, 'Ana', 'López', 'Ruiz', '5512345678', 'ana@correo.com', '2026-10-01');
INSERT INTO hogar_temporal (id_hogar, alias, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (1, 'Casa Ana', 'Av. IPN', '100', '07738', 3, TRUE, 1, 1);

-- Prueba 1. Viola fk_hogar_zona: el hogar se ubica en una zona que no existe.
-- ERROR:  insert or update on table "hogar_temporal" violates foreign key constraint "fk_hogar_zona"
-- DETAIL:  Key (id_zona)=(99) is not present in table "zona".
INSERT INTO hogar_temporal (id_hogar, alias, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (2, 'Casa sin zona', 'Calle 1', '5', '07738', 2, TRUE, 1, 99);

-- Prueba 2. Viola ck_hogar_capacidad: la capacidad máxima debe ser mayor que 0.
-- ERROR:  new row for relation "hogar_temporal" violates check constraint "ck_hogar_capacidad"
-- DETAIL:  Failing row contains (3, Casa llena, Calle 2, 8, 07738, 0, t, 1, 1).
INSERT INTO hogar_temporal (id_hogar, alias, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (3, 'Casa llena', 'Calle 2', '8', '07738', 0, TRUE, 1, 1);

-- Prueba 3. Viola uq_persona_correo: dos personas no pueden tener el mismo correo.
-- ERROR:  duplicate key value violates unique constraint "uq_persona_correo"
-- DETAIL:  Key (correo)=(ana@correo.com) already exists.
INSERT INTO persona (id_persona, nombres, ap_paterno, ap_materno, telefono, correo, fecha_registro)
VALUES (2, 'Luis', 'Pérez', NULL, '5587654321', 'ana@correo.com', '2026-10-02');

-- Prueba 4. Viola NOT NULL en hogar_temporal.id_persona: todo hogar tiene un responsable (1,1).
-- ERROR:  null value in column "id_persona" of relation "hogar_temporal" violates not-null constraint
-- DETAIL:  Failing row contains (4, Casa sin responsable, Calle 3, 9, 07738, 2, t, null, 1).
INSERT INTO hogar_temporal (id_hogar, alias, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (4, 'Casa sin responsable', 'Calle 3', '9', '07738', 2, TRUE, NULL, 1);

-- Prueba 5. Viola fk_rescatista_persona: un rescatista debe ser una persona registrada.
-- ERROR:  insert or update on table "rescatista" violates foreign key constraint "fk_rescatista_persona"
-- DETAIL:  Key (id_persona)=(50) is not present in table "persona".
INSERT INTO rescatista (id_persona, vehiculo_propio, disponibilidad)
VALUES (50, TRUE, 'Fines de semana');

-- Prueba 6. Viola fk_hogar_persona (ON DELETE RESTRICT): no se borra a quien es responsable de un hogar.
-- ERROR:  update or delete on table "persona" violates foreign key constraint "fk_hogar_persona" on table "hogar_temporal"
-- DETAIL:  Key (id_persona)=(1) is still referenced from table "hogar_temporal".
DELETE FROM persona WHERE id_persona = 1;
