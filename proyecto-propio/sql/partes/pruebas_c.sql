-- Pruebas de restricciones: Zona C (Jose)
-- PostgreSQL. Ejecutar despues de crear todo el esquema.
-- Los INSERT marcados como RECHAZO deben ejecutarse por separado y
-- rechazarse. Registrar el mensaje exacto que devuelva el gestor.
-- Datos de apoyo: IDs 3001-3099.

INSERT INTO zona (id_zona, colonia, municipio, entidad)
VALUES (3001, 'Prueba', 'Gustavo A. Madero', 'Ciudad de Mexico');
INSERT INTO persona (id_persona, nombres, ap_paterno, telefono, correo, fecha_registro)
VALUES (3001, 'Vera', 'Veterinaria', '5533333333', 'veterinaria.c3001@example.test', DATE '2026-10-01');
INSERT INTO veterinario (id_persona, cedula, especialidad)
VALUES (3001, 'CED-C3001', 'Medicina veterinaria');
INSERT INTO rescate (id_rescate, descripcion_lugar, fecha_hora, condicion_inicial, tipo_ingreso, id_zona)
VALUES (3001, 'Lugar de prueba', TIMESTAMP '2026-10-02 09:00:00', 'Estable', 'via publica', 3001);
INSERT INTO animal (id_animal, nombre, especie, sexo, estado_actual, id_rescate)
VALUES (3001, 'Sol', 'gato', 'hembra', 'en_resguardo', 3001);
INSERT INTO gato (id_animal, resultado_fiv, resultado_felv)
VALUES (3001, NULL, NULL);
INSERT INTO clinica (id_clinica, nombre, direccion, telefono, tipo)
VALUES (3001, 'Clinica de prueba', 'Calle 3', '5544444444', 'privada');
INSERT INTO vacuna (id_vacuna, nombre, especie_destino, intervalo_refuerzo_dias)
VALUES (3001, 'Vacuna de prueba', 'gato', 365);
INSERT INTO atencion_medica (id_animal, num_atencion, fecha, tipo, id_persona, id_clinica)
VALUES (3001, 1, DATE '2026-10-03', 'vacunacion', 3001, 3001);

INSERT INTO atencion_medica (id_animal, num_atencion, fecha, tipo, id_persona, id_clinica)
VALUES (3001, 2, DATE '2026-10-04', 'vacunacion', 3001, 3001);

-- RECHAZO C1: viola ck_vacuna_intervalo; intervalo no puede ser cero.
INSERT INTO vacuna (id_vacuna, nombre, especie_destino, intervalo_refuerzo_dias)
VALUES (3002, 'Intervalo invalido', 'gato', 0);

-- RECHAZO C2: viola ck_atencion_numero; num_atencion debe ser mayor que cero.
INSERT INTO atencion_medica (id_animal, num_atencion, fecha, tipo)
VALUES (3001, 0, DATE '2026-10-04', 'consulta');

-- RECHAZO C3: viola fk_vacunacion_vacuna; no existe id_vacuna 3099.
INSERT INTO vacunacion (id_animal, num_atencion, dosis_num, id_vacuna)
VALUES (3001, 2, 1, 3099);