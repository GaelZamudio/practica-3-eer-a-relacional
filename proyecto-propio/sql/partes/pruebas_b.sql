-- Pruebas de restricciones: Zona B (Gael)
-- PostgreSQL. Ejecutar despues de crear todo el esquema.
-- Los INSERT marcados como RECHAZO deben ejecutarse por separado y
-- rechazarse. Registrar el mensaje exacto que devuelva el gestor.
-- Datos de apoyo: IDs 2001-2099.

INSERT INTO zona (id_zona, colonia, municipio, entidad)
VALUES (2001, 'Centro', 'Gustavo A. Madero', 'Ciudad de Mexico');
INSERT INTO persona (id_persona, nombres, ap_paterno, telefono, correo, fecha_registro)
VALUES (2001, 'Rene', 'Rescatista', '5511111111', 'rescatista.b2001@example.test', DATE '2026-10-01');
INSERT INTO rescatista (id_persona, vehiculo_propio, disponibilidad)
VALUES (2001, TRUE, 'Diaria');
INSERT INTO persona (id_persona, nombres, ap_paterno, telefono, correo, fecha_registro)
VALUES (2002, 'Ada', 'Adoptante', '5522222222', 'adoptante.b2002@example.test', DATE '2026-10-02');
INSERT INTO adoptante (id_persona, tipo_vivienda, tiene_patio, otras_mascotas)
VALUES (2002, 'casa', TRUE, FALSE);
INSERT INTO hogar_temporal (id_hogar, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (2001, 'Calle de prueba', '1', '07738', 4, TRUE, 2001, 2001);
INSERT INTO rescate (id_rescate, descripcion_lugar, fecha_hora, condicion_inicial, tipo_ingreso, id_zona)
VALUES (2001, 'Parque de prueba', TIMESTAMP '2026-10-03 10:00:00', 'Deshidratacion', 'via publica', 2001);
INSERT INTO animal (id_animal, nombre, especie, sexo, estado_actual, id_rescate)
VALUES (2001, 'Luna', 'perro', 'hembra', 'en_resguardo', 2001);
INSERT INTO perro (id_animal, tamano, nivel_energia, apto_con_ninos)
VALUES (2001, 'mediano', 'moderado', TRUE);
INSERT INTO rescate_rescatista (id_rescate, id_persona)
VALUES (2001, 2001);

-- RECHAZO B1: viola ck_estancia_fechas; fecha_fin es anterior a fecha_inicio.
INSERT INTO estancia (id_animal, id_hogar, id_persona, fecha_inicio, fecha_fin)
VALUES (2001, 2001, 2001, DATE '2026-10-10', DATE '2026-10-09');

-- RECHAZO B2: viola la PK pk_rescate_rescatista; el par ya existe.
INSERT INTO rescate_rescatista (id_rescate, id_persona)
VALUES (2001, 2001);

-- RECHAZO B3: viola fk_solicitud_adoptante; no existe adoptante 2099.
INSERT INTO solicitud_adopcion (id_animal, id_persona, fecha_solicitud, estado)
VALUES (2001, 2099, DATE '2026-10-11', 'pendiente');
