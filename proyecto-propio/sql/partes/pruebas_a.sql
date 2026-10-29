-- =====================================================================
-- Pruebas de restricciones: Zona A
-- Responsable: Alejandro
-- Estas instrucciones DEBEN FALLAR. No se incluyen en esquema.sql.
-- Cada prueba lleva: qué restricción viola y el mensaje de error
-- que devuelve el gestor (copiado de la ejecución real).
-- =====================================================================

INSERT INTO zona (id_zona, colonia, municipio, entidad)
VALUES (1001, 'Lindavista', 'Gustavo A. Madero', 'Ciudad de Mexico');
INSERT INTO persona (id_persona, nombres, ap_paterno, ap_materno, telefono, correo, fecha_registro)
VALUES (1001, 'Ana', 'Lopez', 'Ruiz', '5512345678', 'ana.a1001@example.test', DATE '2026-10-01');
INSERT INTO persona (id_persona, nombres, ap_paterno, telefono, correo, fecha_registro)
VALUES (1002, 'Luis', 'Perez', '5587654321', 'luis.a1002@example.test', DATE '2026-10-02');
INSERT INTO rescatista (id_persona, vehiculo_propio, disponibilidad)
VALUES (1001, TRUE, 'Fines de semana');
INSERT INTO hogar_temporal (id_hogar, alias, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (1001, 'Casa Ana', 'Av. IPN', '100', '07738', 3, TRUE, 1001, 1001);

-- RECHAZO A1: viola fk_hogar_zona; el id_zona referenciado no existe.
INSERT INTO hogar_temporal (id_hogar, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (1002, 'Calle 1', '5', '07738', 2, TRUE, 1001, 1099);

-- RECHAZO A2: viola ck_hogar_capacidad; capacidad_max debe ser mayor que cero.
INSERT INTO hogar_temporal (id_hogar, calle, numero, cp, capacidad_max, activo, id_persona, id_zona)
VALUES (1003, 'Calle 2', '8', '07738', 0, TRUE, 1001, 1001);

-- RECHAZO A3: viola uq_persona_correo; el correo ya existe.
INSERT INTO persona (id_persona, nombres, ap_paterno, telefono, correo, fecha_registro)
VALUES (1003, 'Eva', 'Diaz', '5500000000', 'ana.a1001@example.test', DATE '2026-10-03');

-- RECHAZO A4: viola fk_hogar_persona (ON DELETE RESTRICT).
DELETE FROM persona WHERE id_persona = 1001;