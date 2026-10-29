-- Practica 3: Transformacion EER a relacional
-- Zona B: Rescate, animal y adopcion
-- Responsable: Gael
-- Tablas (10): rescate, rescate_rescatista, animal, perro, gato, otro,
--              estancia, solicitud_adopcion, adopcion, seguimiento
-- Orden: 2 de 3. Requiere las tablas zona, rescatista, adoptante y
-- hogar_temporal de la zona A. La zona C depende de animal.
-- Los identificadores INT se proporcionan al insertar; no se generan
-- automaticamente, de acuerdo con el inventario comun.

CREATE TABLE rescate (
    id_rescate       INT NOT NULL,
    descripcion_lugar VARCHAR(200) NOT NULL,
    fecha_hora       TIMESTAMP NOT NULL,
    condicion_inicial VARCHAR(200) NOT NULL,
    tipo_ingreso     VARCHAR(30) NOT NULL,
    id_zona          INT NOT NULL,
    CONSTRAINT pk_rescate PRIMARY KEY (id_rescate),
    CONSTRAINT fk_rescate_zona FOREIGN KEY (id_zona)
        REFERENCES zona (id_zona) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE animal (
    id_animal             INT NOT NULL,
    nombre                VARCHAR(50),
    especie               VARCHAR(30) NOT NULL,
    sexo                  VARCHAR(10) NOT NULL,
    fecha_nacimiento_aprox DATE,
    color                 VARCHAR(50),
    senas                 VARCHAR(200),
    estado_actual         VARCHAR(30) NOT NULL,
    id_rescate            INT NOT NULL,
    id_madre              INT,
    CONSTRAINT pk_animal PRIMARY KEY (id_animal),
    CONSTRAINT ck_animal_especie CHECK (especie IN ('perro', 'gato', 'otro')),
    CONSTRAINT ck_animal_sexo CHECK (sexo IN ('macho', 'hembra')),
    CONSTRAINT ck_animal_no_es_su_madre CHECK (id_madre IS NULL OR id_madre <> id_animal),
    CONSTRAINT fk_animal_rescate FOREIGN KEY (id_rescate)
        REFERENCES rescate (id_rescate) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_animal_madre FOREIGN KEY (id_madre)
        REFERENCES animal (id_animal) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE perro (
    id_animal      INT NOT NULL,
    tamano         VARCHAR(20) NOT NULL,
    nivel_energia  VARCHAR(20) NOT NULL,
    apto_con_ninos BOOLEAN NOT NULL,
    CONSTRAINT pk_perro PRIMARY KEY (id_animal),
    CONSTRAINT fk_perro_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE gato (
    id_animal     INT NOT NULL,
    resultado_fiv BOOLEAN,
    resultado_felv BOOLEAN,
    CONSTRAINT pk_gato PRIMARY KEY (id_animal),
    CONSTRAINT fk_gato_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE otro (
    id_animal           INT NOT NULL,
    descripcion_especie VARCHAR(100) NOT NULL,
    cuidados_especiales VARCHAR(200),
    CONSTRAINT pk_otro PRIMARY KEY (id_animal),
    CONSTRAINT fk_otro_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE rescate_rescatista (
    id_rescate INT NOT NULL,
    id_persona INT NOT NULL,
    CONSTRAINT pk_rescate_rescatista PRIMARY KEY (id_rescate, id_persona),
    CONSTRAINT fk_rescate_rescatista_rescate FOREIGN KEY (id_rescate)
        REFERENCES rescate (id_rescate) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rescate_rescatista_rescatista FOREIGN KEY (id_persona)
        REFERENCES rescatista (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE estancia (
    id_animal   INT NOT NULL,
    id_hogar    INT NOT NULL,
    id_persona  INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin   DATE,
    motivo_salida VARCHAR(100),
    CONSTRAINT pk_estancia PRIMARY KEY (id_animal, id_hogar, id_persona, fecha_inicio),
    CONSTRAINT ck_estancia_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT fk_estancia_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estancia_hogar FOREIGN KEY (id_hogar)
        REFERENCES hogar_temporal (id_hogar) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_estancia_rescatista FOREIGN KEY (id_persona)
        REFERENCES rescatista (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE solicitud_adopcion (
    id_animal        INT NOT NULL,
    id_persona       INT NOT NULL,
    fecha_solicitud  DATE NOT NULL,
    estado           VARCHAR(20) NOT NULL,
    observaciones    VARCHAR(200),
    CONSTRAINT pk_solicitud_adopcion PRIMARY KEY (id_animal, id_persona, fecha_solicitud),
    CONSTRAINT fk_solicitud_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_adoptante FOREIGN KEY (id_persona)
        REFERENCES adoptante (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE adopcion (
    id_animal       INT NOT NULL,
    id_persona      INT NOT NULL,
    fecha_adopcion  DATE NOT NULL,
    fecha_devolucion DATE,
    motivo_devolucion VARCHAR(200),
    CONSTRAINT pk_adopcion PRIMARY KEY (id_animal, id_persona, fecha_adopcion),
    CONSTRAINT ck_adopcion_fechas CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_adopcion),
    CONSTRAINT fk_adopcion_animal FOREIGN KEY (id_animal)
        REFERENCES animal (id_animal) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_adopcion_adoptante FOREIGN KEY (id_persona)
        REFERENCES adoptante (id_persona) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE seguimiento (
    id_animal         INT NOT NULL,
    id_persona        INT NOT NULL,
    fecha_adopcion    DATE NOT NULL,
    num_seguimiento   INT NOT NULL,
    fecha             DATE NOT NULL,
    medio             VARCHAR(30) NOT NULL,
    estado_del_animal VARCHAR(200) NOT NULL,
    observaciones     VARCHAR(200),
    CONSTRAINT pk_seguimiento PRIMARY KEY
        (id_animal, id_persona, fecha_adopcion, num_seguimiento),
    CONSTRAINT ck_seguimiento_numero CHECK (num_seguimiento > 0),
    CONSTRAINT fk_seguimiento_adopcion FOREIGN KEY
        (id_animal, id_persona, fecha_adopcion)
        REFERENCES adopcion (id_animal, id_persona, fecha_adopcion)
        ON DELETE CASCADE ON UPDATE CASCADE
);
