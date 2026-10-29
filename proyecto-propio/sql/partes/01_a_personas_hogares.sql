-- =====================================================================
-- Práctica 3: Transformación EER → relacional
-- Zona A: Personas y hogares
-- Responsable: Alejandro
-- Tablas: zona, persona, rescatista, adoptante, veterinario,
--         hogar_temporal, hogar_especie
-- Orden de ejecución: 1 de 3 (no depende de otras zonas)
-- Reglas que aplica: 1 (entidad fuerte), 2 (compuesto: dirección),
--         3 (multivaluado: especies_aceptadas), 4 (1:N), 9 (jerarquía de Persona)
-- Derivado que NO se guarda (documentar en 6.5): /lugares_disponibles
-- Convenciones de nombres, tipos y ON DELETE: ver CONTRIBUTING.md
-- =====================================================================

CREATE TABLE zona (
    id_zona   INT NOT NULL,
    colonia   VARCHAR(80) NOT NULL,
    municipio VARCHAR(80) NOT NULL,
    entidad   VARCHAR(50) NOT NULL,
    CONSTRAINT pk_zona PRIMARY KEY (id_zona)
);

CREATE TABLE persona (
    id_persona     INT NOT NULL,
    nombres        VARCHAR(60) NOT NULL,
    ap_paterno     VARCHAR(50) NOT NULL,
    ap_materno     VARCHAR(50),
    telefono       VARCHAR(15) NOT NULL,
    correo         VARCHAR(100),
    fecha_registro DATE NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (id_persona),
    CONSTRAINT uq_persona_correo UNIQUE (correo)
);

CREATE TABLE rescatista (
    id_persona      INT NOT NULL,
    vehiculo_propio BOOLEAN NOT NULL,
    disponibilidad  VARCHAR(50),
    CONSTRAINT pk_rescatista PRIMARY KEY (id_persona),
    CONSTRAINT fk_rescatista_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE adoptante (
    id_persona     INT NOT NULL,
    tipo_vivienda  VARCHAR(30) NOT NULL,
    tiene_patio    BOOLEAN NOT NULL,
    otras_mascotas BOOLEAN NOT NULL,
    CONSTRAINT pk_adoptante PRIMARY KEY (id_persona),
    CONSTRAINT fk_adoptante_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE veterinario (
    id_persona   INT NOT NULL,
    cedula       VARCHAR(20) NOT NULL,
    especialidad VARCHAR(50),
    CONSTRAINT pk_veterinario PRIMARY KEY (id_persona),
    CONSTRAINT uq_veterinario_cedula UNIQUE (cedula),
    CONSTRAINT fk_veterinario_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE hogar_temporal (
    id_hogar      INT NOT NULL,
    alias         VARCHAR(50),
    calle         VARCHAR(100) NOT NULL,
    numero        VARCHAR(10) NOT NULL,
    cp            CHAR(5) NOT NULL,
    capacidad_max INT NOT NULL,
    activo        BOOLEAN NOT NULL,
    id_persona    INT NOT NULL,
    id_zona       INT NOT NULL,
    CONSTRAINT pk_hogar_temporal PRIMARY KEY (id_hogar),
    CONSTRAINT ck_hogar_capacidad CHECK (capacidad_max > 0),
    CONSTRAINT fk_hogar_persona FOREIGN KEY (id_persona)
        REFERENCES persona (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hogar_zona FOREIGN KEY (id_zona)
        REFERENCES zona (id_zona) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hogar_especie (
    id_hogar INT NOT NULL,
    especie  VARCHAR(30) NOT NULL,
    CONSTRAINT pk_hogar_especie PRIMARY KEY (id_hogar, especie),
    CONSTRAINT fk_hogar_especie_hogar FOREIGN KEY (id_hogar)
        REFERENCES hogar_temporal (id_hogar) ON DELETE CASCADE ON UPDATE CASCADE
);