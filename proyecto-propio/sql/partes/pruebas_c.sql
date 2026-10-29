-- =====================================================================
-- Pruebas de restricciones: Zona C
-- Responsable: José
-- Estas instrucciones DEBEN FALLAR. No se incluyen en esquema.sql.
-- Cada prueba lleva: qué restricción viola y el mensaje de error
-- que devuelve el gestor (copiado de la ejecución real).
-- =====================================================================
INSERT INTO animal (nombre) VALUES ('Firulais');

INSERT INTO persona (nombre) VALUES ('Veterinario Prueba');

INSERT INTO veterinario_voluntario (id_persona)
SELECT id_persona FROM persona WHERE nombre = 'Veterinario Prueba' ORDER BY id_persona LIMIT 1;

INSERT INTO clinica (nombre, direccion, telefono, tipo) VALUES ('Clinica Veterinaria Centro', 'Av. Insurgentes 100', '5512345678', 'privada');

INSERT INTO vacuna (nombre, especie_destino, intervalo_refuerzo_dias) VALUES ('Rabia', 'perro', 365);

INSERT INTO atencion_medica (id_animal, num_atencion, fecha, tipo, observaciones, id_persona, id_clinica)
SELECT
    (SELECT id_animal FROM animal WHERE nombre = 'Firulais' ORDER BY id_animal LIMIT 1),
    t.num_atencion,
    t.fecha,
    t.tipo,
    t.observaciones,
    (SELECT id_persona FROM veterinario_voluntario ORDER BY id_persona LIMIT 1),
    (SELECT id_clinica FROM clinica WHERE nombre = 'Clinica Veterinaria Centro' ORDER BY id_clinica LIMIT 1)
FROM (VALUES
    (1, DATE '2026-10-01', 'vacunacion', 'Primera dosis de rabia'),
    (2, DATE '2026-10-05', 'cirugia', 'Esterilizacion programada'),
    (3, DATE '2026-10-10', 'tratamiento', 'Revision por otitis')
) AS t (num_atencion, fecha, tipo, observaciones);

INSERT INTO vacunacion (id_animal, num_atencion, dosis_num, fecha_proxima_dosis, id_vacuna)
SELECT
    a.id_animal,
    a.num_atencion,
    1,
    DATE '2027-10-01',
    (SELECT id_vacuna FROM vacuna WHERE nombre = 'Rabia' ORDER BY id_vacuna LIMIT 1)
FROM atencion_medica a
WHERE a.tipo = 'vacunacion' AND a.observaciones = 'Primera dosis de rabia'
ORDER BY a.id_animal, a.num_atencion
LIMIT 1;

INSERT INTO cirugia (id_animal, num_atencion, tipo_cirugia, complicaciones)
SELECT a.id_animal, a.num_atencion, 'Esterilizacion', 'Ninguna'
FROM atencion_medica a
WHERE a.tipo = 'cirugia' AND a.observaciones = 'Esterilizacion programada'
ORDER BY a.id_animal, a.num_atencion
LIMIT 1;

INSERT INTO tratamiento (id_animal, num_atencion, diagnostico, duracion_dias)
SELECT a.id_animal, a.num_atencion, 'Otitis externa', 10
FROM atencion_medica a
WHERE a.tipo = 'tratamiento' AND a.observaciones = 'Revision por otitis'
ORDER BY a.id_animal, a.num_atencion
LIMIT 1;
