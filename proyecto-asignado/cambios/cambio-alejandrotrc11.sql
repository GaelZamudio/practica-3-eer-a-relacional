-- Ejercicio 8. Cambio de esquema por integrante
-- Propuesta: Issue #5 "Explicación a los usuarios mediante IA"
-- Integrante: Rojas Castro Alejandro Tonatiuh (alejandrotrc11)
-- Base de datos: datawarehouse (proyecto Seismic-Data-Visualization-System)

-- 1. Tabla nueva: explicación en lenguaje sencillo generada por IA para un sismo
CREATE TABLE explicacion_sismo (
    id_explicacion    SERIAL        PRIMARY KEY,
    id_sismo          INT           NOT NULL,
    texto             TEXT          NOT NULL,
    version_modelo    VARCHAR(50)   NOT NULL,
    fecha_generacion  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sismo) REFERENCES dim_sismos(id_sismo),
    UNIQUE (id_sismo, version_modelo)
);

-- 2. Resultados del modelo para dos sismos (texto escrito solo con datos del sistema)
INSERT INTO explicacion_sismo (id_sismo, texto, version_modelo) VALUES
(94787, 'El 19 de septiembre de 2017 a las 13:14 (hora del centro) ocurrió un sismo de magnitud 7.1, que se considera fuerte. Se originó a 51 km de profundidad, 8 km al noroeste de Chiautla de Tapia, Puebla. El sistema estima 6.6 millones de personas expuestas en Puebla.', 'claude-opus-5-5'),
(2461,  'El 19 de septiembre de 1985 a las 7:17 de la mañana ocurrió un sismo de magnitud 8.1, que se considera muy fuerte. Se originó a 15 km de profundidad, 45 km al noroeste de La Mira, Michoacán.', 'claude-opus-5-5');
