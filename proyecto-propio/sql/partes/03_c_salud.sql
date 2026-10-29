-- Practica 3: Transformacion EER a relacional
-- Zona C: Atencion medica
-- Responsable: Jose
-- Tablas (6): clinica, vacuna, atencion_medica, vacunacion, cirugia,
--             tratamiento
-- Orden: 3 de 3. Requiere animal (zona B) y veterinario (zona A).
-- No se crean tablas sustitutas de animal, persona ni veterinario.

CREATE TABLE clinica (
    id_clinica INT NOT NULL,
    nombre     VARCHAR(100) NOT NULL,
    direccion  VARCHAR(200) NOT NULL,
    telefono   VARCHAR(15) NOT NULL,
    tipo       VARCHAR(30) NOT NULL,
    CONSTRAINT pk_clinica PRIMARY KEY (id_clinica)
);

CREATE TABLE vacuna (
    id_vacuna              INT NOT NULL,
    nombre                 VARCHAR(80) NOT NULL,
    especie_destino        VARCHAR(30) NOT NULL,
    intervalo_refuerzo_dias INT,
    CONSTRAINT pk_vacuna PRIMARY KEY (id_vacuna),
    CONSTRAINT ck_vacuna_intervalo CHECK
        (intervalo_refuerzo_dias IS NULL OR intervalo_refuerzo_dias > 0)
);

CREATE TABLE atencion_medica (
    id_animal     INT NOT NULL,
    num_atencion  INT NOT NULL,
    fecha         DATE NOT NULL,
    tipo          VARCHAR(30) NOT NULL,
    observaciones VARCHAR(300),
    id_persona    INT,
    id_clinica    INT,
    CONSTRAINT pk_atencion_medica PRIMARY KEY (id_animal, num_atencion),
    CONSTRAINT ck_atencion_numero CHECK (num_atencion > 0),
    CONSTRAINT fk_atencion_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_atencion_veterinario FOREIGN KEY (id_persona)
        REFERENCES veterinario (id_persona) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_atencion_clinica FOREIGN KEY (id_clinica)
        REFERENCES clinica (id_clinica) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE vacunacion (
    id_animal          INT NOT NULL,
    num_atencion       INT NOT NULL,
    dosis_num          INT NOT NULL,
    fecha_proxima_dosis DATE,
    id_vacuna          INT NOT NULL,
    CONSTRAINT pk_vacunacion PRIMARY KEY (id_animal, num_atencion),
    CONSTRAINT ck_vacunacion_dosis CHECK (dosis_num > 0),
    CONSTRAINT fk_vacunacion_atencion FOREIGN KEY (id_animal, num_atencion)
        REFERENCES atencion_medica (id_animal, num_atencion)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vacunacion_vacuna FOREIGN KEY (id_vacuna)
        REFERENCES vacuna (id_vacuna) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE cirugia (
    id_animal      INT NOT NULL,
    num_atencion   INT NOT NULL,
    tipo_cirugia   VARCHAR(50) NOT NULL,
    complicaciones VARCHAR(200),
    CONSTRAINT pk_cirugia PRIMARY KEY (id_animal, num_atencion),
    CONSTRAINT fk_cirugia_atencion FOREIGN KEY (id_animal, num_atencion)
        REFERENCES atencion_medica (id_animal, num_atencion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tratamiento (
    id_animal     INT NOT NULL,
    num_atencion  INT NOT NULL,
    diagnostico   VARCHAR(200) NOT NULL,
    duracion_dias INT NOT NULL,
    CONSTRAINT pk_tratamiento PRIMARY KEY (id_animal, num_atencion),
    CONSTRAINT ck_tratamiento_duracion CHECK (duracion_dias > 0),
    CONSTRAINT fk_tratamiento_atencion FOREIGN KEY (id_animal, num_atencion)
        REFERENCES atencion_medica (id_animal, num_atencion)
        ON DELETE CASCADE ON UPDATE CASCADE
);
