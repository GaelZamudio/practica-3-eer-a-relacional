-- =============================================================================
-- Archivo: cambio-gael.sql
-- Propuesta: Detección de Periodos Anómalos de Actividad Sísmica con ML
-- =============================================================================

-- 1. Dimensión de Modelos de Machine Learning
CREATE TABLE IF NOT EXISTS dim_modelo_ml (
    id_modelo INT PRIMARY KEY,
    algoritmo VARCHAR(100) NOT NULL,
    hiperparametros TEXT,
    fecha_entrenamiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    periodo_entrenamiento VARCHAR(100)
);

-- 2. Dimensión de Tiempo para Periodos Mensuales
CREATE TABLE IF NOT EXISTS dim_tiempo_periodo (
    id_tiempo_periodo INT PRIMARY KEY,
    anio INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20),
    trimestre INT
);

-- 3. Tabla de Hechos: Anomalías de Actividad Sísmica por Zona y Mes
CREATE TABLE IF NOT EXISTS fact_anomalia_actividad (
    id_anomalia SERIAL PRIMARY KEY,
    id_zonas INT NOT NULL,
    id_tiempo_periodo INT NOT NULL,
    n_sismos INT NOT NULL DEFAULT 0,
    mag_max DOUBLE PRECISION,
    mag_media DOUBLE PRECISION,
    prof_media DOUBLE PRECISION,
    puntaje_anomalia DOUBLE PRECISION,
    es_anomalo BOOLEAN NOT NULL DEFAULT FALSE,
    id_modelo INT NOT NULL,
    descripcion_anomalia VARCHAR(255),
    CONSTRAINT fk_anomalia_zonas FOREIGN KEY (id_zonas) REFERENCES dim_zonas(id_zonas),
    CONSTRAINT fk_anomalia_periodo FOREIGN KEY (id_tiempo_periodo) REFERENCES dim_tiempo_periodo(id_tiempo_periodo),
    CONSTRAINT fk_anomalia_modelo FOREIGN KEY (id_modelo) REFERENCES dim_modelo_ml(id_modelo)
);

-- 4. Índices para optimización de consultas
CREATE INDEX IF NOT EXISTS idx_anomalia_zona_periodo ON fact_anomalia_actividad (id_zonas, id_tiempo_periodo);
CREATE INDEX IF NOT EXISTS idx_anomalia_filtro ON fact_anomalia_actividad (es_anomalo, puntaje_anomalia DESC);

-- 5. Datos muestra para validación (Septiembre 1985 y Septiembre 2017)
INSERT INTO dim_modelo_ml (id_modelo, algoritmo, hiperparametros, periodo_entrenamiento)
VALUES (1, 'IsolationForest', 'contamination=0.02, n_estimators=150, features=[n_sismos, mag_max, mag_media, prof_media]', '1980-2024 (M>=4.0)')
ON CONFLICT (id_modelo) DO NOTHING;

INSERT INTO dim_tiempo_periodo (id_tiempo_periodo, anio, mes, nombre_mes, trimestre)
VALUES 
    (198509, 1985, 9, 'Septiembre', 3),
    (201709, 2017, 9, 'Septiembre', 3)
ON CONFLICT (id_tiempo_periodo) DO NOTHING;

-- Inserción muestra vinculada a Oaxaca (id_zonas = 20) y CDMX/Guerrero (id_zonas = 12)
INSERT INTO fact_anomalia_actividad 
    (id_zonas, id_tiempo_periodo, n_sismos, mag_max, mag_media, prof_media, puntaje_anomalia, es_anomalo, id_modelo, descripcion_anomalia)
VALUES 
    (20, 201709, 1425, 8.2, 4.65, 38.4, 4.82, TRUE, 1, '4.8 veces más sismos de lo esperado (Enjambre/Réplicas Sismo Tehuantepec M8.2)'),
    (12, 198509, 185, 8.1, 4.88, 22.1, 3.95, TRUE, 1, '4.0 veces más sismos de lo esperado (Secuencia sismo Michoacán/Costas M8.1)')
ON CONFLICT DO NOTHING;