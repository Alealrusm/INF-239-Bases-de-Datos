DROP DATABASE IF EXISTS ct_usm_postulaciones;
CREATE DATABASE ct_usm_postulaciones;
USE ct_usm_postulaciones;

SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE IF NOT EXISTS ESTADO_POSTULACION_R (
    id_estado_postulacion INT NOT NULL,
    nombre_postulacion VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_estado_postulacion),
    UNIQUE (nombre_postulacion)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS TIPO_INICIATIVA_R (
    id_iniciativa INT NOT NULL,
    nombre_iniciativa VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_iniciativa),
    UNIQUE (nombre_iniciativa)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS CARGO_PERSONA_R (
    id_persona INT NOT NULL, -- Actua como ID de Cargo/Rol
    rol_asumido VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_persona),
    UNIQUE (rol_asumido)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS REGION_R (
    id_region INT NOT NULL,
    nombre_region VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_region),
    UNIQUE (nombre_region)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS SEDE_R (
    id_sede INT NOT NULL,
    nombre_sede VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_sede),
    UNIQUE (nombre_sede)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS TAMANO_EMPRESA_R (
    id_tamano INT NOT NULL,
    tamano_empresa VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_tamano),
    UNIQUE (tamano_empresa)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS EMPRESA_EXTERNA_R (
    rut_empresa VARCHAR(20) NOT NULL,
    nombre_empresa VARCHAR(255) NOT NULL,
    nombre_representante VARCHAR(255) NOT NULL,
    mail_representante VARCHAR(255) NOT NULL,
    telefono_representante VARCHAR(20) NOT NULL,
    convenio_usm BOOLEAN NOT NULL, 
    id_tamano INT NOT NULL,
    PRIMARY KEY (rut_empresa),
    CONSTRAINT fk_empresa_tamano FOREIGN KEY (id_tamano) REFERENCES TAMANO_EMPRESA_R (id_tamano)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS PERSONA_R (
    rut_persona VARCHAR(20) NOT NULL,
    nombre_persona VARCHAR(255) NOT NULL,
    email_persona VARCHAR(255) NOT NULL,
    telefono_persona VARCHAR(20),
    id_persona INT NOT NULL, -- FK a CARGO_PERSONA_R
    PRIMARY KEY (rut_persona),
    CONSTRAINT fk_persona_cargo FOREIGN KEY (id_persona) REFERENCES CARGO_PERSONA_R (id_persona)
) ENGINE = InnoDB;

-- Tabla Principal
CREATE TABLE IF NOT EXISTS POSTULACION_R (
    id_postulacion INT NOT NULL AUTO_INCREMENT,
    postulacion_n INT NOT NULL,
    codigo_interno VARCHAR(255) NOT NULL,
    presupuesto_total DECIMAL(12,2) NOT NULL,
    fecha_postulacion DATE NOT NULL,
    nombre_iniciativa VARCHAR(255) NOT NULL,
    objetivo_iniciativa VARCHAR(255) NOT NULL,
    descripcion_iniciativa VARCHAR(255) NOT NULL,
    resultados_iniciativa VARCHAR(255) NOT NULL,
    rut_empresa VARCHAR(20) NOT NULL,
    id_iniciativa INT NOT NULL,
    id_estado_postulacion INT NOT NULL,
    id_region_ejecucion INT NOT NULL,
    id_region_impacto INT NOT NULL,
    id_sede INT NOT NULL,
    PRIMARY KEY (id_postulacion),
    UNIQUE (postulacion_n),
    UNIQUE (codigo_interno),
    CONSTRAINT fk_post_empresa FOREIGN KEY (rut_empresa) REFERENCES EMPRESA_EXTERNA_R (rut_empresa),
    CONSTRAINT fk_post_tipo FOREIGN KEY (id_iniciativa) REFERENCES TIPO_INICIATIVA_R (id_iniciativa),
    CONSTRAINT fk_post_estado FOREIGN KEY (id_estado_postulacion) REFERENCES ESTADO_POSTULACION_R (id_estado_postulacion),
    CONSTRAINT fk_post_reg_ejec FOREIGN KEY (id_region_ejecucion) REFERENCES REGION_R (id_region),
    CONSTRAINT fk_post_reg_impac FOREIGN KEY (id_region_impacto) REFERENCES REGION_R (id_region),
    CONSTRAINT fk_post_sede FOREIGN KEY (id_sede) REFERENCES SEDE_R (id_sede)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ETAPA_CRONOGRAMA_R (
    id_etapa INT NOT NULL,
    nombre_etapa VARCHAR(255) NOT NULL,
    plazo_semanas INT NOT NULL,
    entregable VARCHAR(255) NOT NULL,
    id_postulacion INT NOT NULL,
    PRIMARY KEY (id_etapa),
    CONSTRAINT fk_etapa_postulacion FOREIGN KEY (id_postulacion) REFERENCES POSTULACION_R (id_postulacion)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS DOCUMENTO_ADJUNTO_R (
    id_documento INT NOT NULL,
    nombre_documento VARCHAR(255) NOT NULL,
    ruta_documento VARCHAR(255) NOT NULL,
    id_postulacion INT NOT NULL,
    PRIMARY KEY (id_documento),
    CONSTRAINT fk_doc_postulacion FOREIGN KEY (id_postulacion) REFERENCES POSTULACION_R (id_postulacion)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS INTEGRANTE_POSTULACION_R (
    funcion_integrante VARCHAR(255) NOT NULL,
    departamento_o_area VARCHAR(255) NOT NULL,
    id_sede INT NOT NULL,
    rut_persona VARCHAR(20) NOT NULL,
    id_postulacion INT NOT NULL,
    PRIMARY KEY (rut_persona, id_postulacion),
    CONSTRAINT fk_integ_sede FOREIGN KEY (id_sede) REFERENCES SEDE_R (id_sede),
    CONSTRAINT fk_integ_persona FOREIGN KEY (rut_persona) REFERENCES PERSONA_R (rut_persona),
    CONSTRAINT fk_integ_postulacion FOREIGN KEY (id_postulacion) REFERENCES POSTULACION_R (id_postulacion)
) ENGINE = InnoDB;

INSERT INTO REGION_R (id_region, nombre_region) VALUES
(1, 'Arica y Parinacota'), (2, 'Tarapacá'), (3, 'Antofagasta'), (4, 'Atacama'),
(5, 'Coquimbo'), (6, 'Valparaíso'), (7, 'Metropolitana de Santiago'), (8, 'Libertador General Bernardo O''Higgins'),
(9, 'Maule'), (10, 'Ñuble'), (11, 'Biobío'), (12, 'La Araucanía'),
(13, 'Los Ríos'), (14, 'Los Lagos'), (15, 'Aysén del General Carlos Ibáñez del Campo'), (16, 'Magallanes y de la Antártica Chilena');

INSERT INTO SEDE_R (id_sede, nombre_sede) VALUES
(1, 'Casa Central Valparaíso'),
(2, 'Campus Santiago Vitacura'),
(3, 'Campus Santiago San Joaquín'),
(4, 'Sede Viña del Mar'),
(5, 'Sede Concepción');

INSERT INTO TAMANO_EMPRESA_R VALUES (1, 'Microempresa'), (2, 'Mediana'), (3, 'Grande');

INSERT INTO TIPO_INICIATIVA_R VALUES (1, 'Nueva'), (2, 'Existente');

INSERT INTO CARGO_PERSONA_R VALUES (1, 'Profesor'), (2, 'Estudiante');

INSERT INTO ESTADO_POSTULACION_R VALUES (1, 'En Revisión'), (2, 'Aprobada'), (3, 'Rechazada'), (4, 'Cerrada');

INSERT INTO POSTULACION_R (postulacion_n, codigo_interno, presupuesto_total, fecha_postulacion, nombre_iniciativa, objetivo_iniciativa, descripcion_iniciativa, resultados_iniciativa, rut_empresa, id_iniciativa, id_estado_postulacion, id_region_ejecucion, id_region_impacto, id_sede) VALUES
(101, 'INF-01', 5000000, '2026-01-10', 'Redes IoT', 'Monitoreo', 'Sensores en campo', 'Reporte mensual', '76.123.456-1', 1, 1, 1, 12, 1),
(102, 'INF-02', 8000000, '2026-01-15', 'IA en Minería', 'Optimizar', 'Algoritmos predictivos', 'Menos fallas', '77.987.654-K', 2, 2, 2, 11, 2),
(103, 'INF-03', 3500000, '2026-01-20', 'Riego Smart', 'Ahorro agua', 'Válvulas wifi', 'Ahorro 20%', '88.456.789-2', 1, 3, 3, 10, 3),
(104, 'INF-04', 12000000, '2026-02-01', 'Logística 4.0', 'Trazabilidad', 'Blockchain carga', 'Cero pérdidas', '90.111.222-3', 2, 4, 4, 9, 4),
(105, 'INF-05', 4500000, '2026-02-10', 'Panel Solar', 'Energía limpia', 'Instalación sede', 'Autosustento', '76.555.444-5', 1, 1, 5, 8, 5),
(106, 'INF-06', 6000000, '2026-02-15', 'App Salud', 'Telemedicina', 'Android/iOS', '1000 usuarios', '99.000.111-0', 2, 2, 6, 7, 1),
(107, 'INF-07', 9500000, '2026-03-01', 'Ciberseguridad', 'Protección', 'Auditoría externa', 'Certificación', '76.123.456-1', 1, 3, 7, 6, 2),
(108, 'INF-08', 2000000, '2026-03-05', 'Taller Programación', 'Enseñar', 'Python básico', '50 alumnos', '99.000.111-0', 2, 4, 8, 5, 3),
(109, 'INF-09', 7200000, '2026-03-10', 'Drones Agrícolas', 'Mapeo', 'Vuelos térmicos', 'Mapa de suelos', '88.456.789-2', 1, 1, 9, 4, 4),
(110, 'INF-10', 15000000, '2026-03-15', 'Data Center', 'Storage', 'Servidores nuevos', 'Alta disponibilidad', '76.123.456-1', 2, 2, 10, 3, 5);

INSERT INTO EMPRESA_EXTERNA_R (rut_empresa, nombre_empresa, nombre_representante, mail_representante, telefono_representante, convenio_usm, id_tamano) VALUES
('76.123.456-1', 'Tech Solutions Chile', 'Juan Pérez', 'jperez@tech.cl', '+56911111111', 1, 1),
('77.987.654-K', 'Minera del Norte', 'Ana Silva', 'asilva@minera.cl', '+56922222222', 0, 2),
('88.456.789-2', 'AgroExport Ltda', 'Carlos Ruiz', 'cruiz@agro.cl', '+56933333333', 1, 3),
('90.111.222-3', 'Logística Valpo', 'Sofía Jara', 'sjara@log.cl', '+56944444444', 0, 1),
('76.555.444-5', 'Energía Solar SpA', 'Roberto Gómez', 'rgomez@solar.cl', '+56955555555', 1, 2),
('99.000.111-0', 'Consultores USM', 'Lucía Paz', 'lpaz@consul.cl', '+56966666666', 0, 3);

INSERT INTO ETAPA_CRONOGRAMA_R (id_etapa, nombre_etapa, plazo_semanas, entregable, id_postulacion) VALUES
(1, 'Inicio', 2, 'Plan', 1), (2, 'Desarrollo', 8, 'Prototipo', 1), (3, 'Cierre', 2, 'Informe', 1),
(4, 'Inicio', 2, 'Plan', 2), (5, 'Desarrollo', 8, 'Prototipo', 2), (6, 'Cierre', 2, 'Informe', 2),
(7, 'Inicio', 2, 'Plan', 3), (8, 'Desarrollo', 8, 'Prototipo', 3), (9, 'Cierre', 2, 'Informe', 3),
(10, 'Inicio', 2, 'Plan', 4), (11, 'Desarrollo', 8, 'Prototipo', 4), (12, 'Cierre', 2, 'Informe', 4),
(13, 'Inicio', 2, 'Plan', 5), (14, 'Desarrollo', 8, 'Prototipo', 5), (15, 'Cierre', 2, 'Informe', 5),
(16, 'Inicio', 2, 'Plan', 6), (17, 'Desarrollo', 8, 'Prototipo', 6), (18, 'Cierre', 2, 'Informe', 6),
(19, 'Inicio', 2, 'Plan', 7), (20, 'Desarrollo', 8, 'Prototipo', 7), (21, 'Cierre', 2, 'Informe', 7),
(22, 'Inicio', 2, 'Plan', 8), (23, 'Desarrollo', 8, 'Prototipo', 8), (24, 'Cierre', 2, 'Informe', 8),
(25, 'Inicio', 2, 'Plan', 9), (26, 'Desarrollo', 8, 'Prototipo', 9), (27, 'Cierre', 2, 'Informe', 9),
(28, 'Inicio', 2, 'Plan', 10), (29, 'Desarrollo', 8, 'Prototipo', 10), (30, 'Cierre', 2, 'Informe', 10);

INSERT INTO PERSONA_R (rut_persona, nombre_persona, email_persona, telefono_persona, id_persona) VALUES
-- Profesores Base
('15.432.891-2', 'Dr. Ricardo Vega', 'ricardo.vega@usm.cl', '+56988776655', 1),
('12.654.321-K', 'Mg. Julia Castro', 'julia.castro@usm.cl', '+56977665544', 1),
('14.789.456-0', 'Dr. Alberto Ruiz', 'alberto.ruiz@usm.cl', '+56966554433', 1),
-- Estudiantes Base
('20.455.123-1', 'Matías Ignacio Soto', 'matias.soto@usm.cl', '+569100101', 2),
('21.002.345-K', 'Valentina Paz Herrera', 'valentina.herrera@usm.cl', '+569100102', 2),
('19.888.765-4', 'Ian Villalobos', 'Ian.Villalobos@usm.cl', '+569100103', 2),
('20.123.987-5', 'Sofía Elena Jara', 'sofia.jara@usm.cl', '+569100104', 2),
('21.444.555-6', 'Diego Andrés Iturriaga', 'diego.iturriaga@usm.cl', '+569100105', 2),
('20.765.432-1', 'Catalina Rivas', 'catalina.rivas@usm.cl', '+569200101', 2),
('21.987.123-K', 'Nicolás Arancibia', 'nicolas.arancibia@usm.cl', '+569200102', 2),
('19.555.444-3', 'Beatriz Sáez', 'beatriz.saez@usm.cl', '+569200103', 2),
('20.111.222-9', 'Carlos Ibáñez', 'carlos.ibanez@usm.cl', '+569200104', 2),
('21.333.444-0', 'Elena Moreno', 'elena.moreno@usm.cl', '+569200105', 2),
('20.900.800-7', 'Joaquín Godoy', 'joaquin.godoy@usm.cl', '+569300101', 2),
('21.121.232-1', 'Fernanda Valdés', 'fernanda.valdes@usm.cl', '+569300102', 2),
('19.999.000-K', 'Gabriel Rozas', 'gabriel.rozas@usm.cl', '+569300103', 2),
('20.444.333-2', 'Martina Osorio', 'martina.osorio@usm.cl', '+569300104', 2),
('21.555.666-8', 'Benjamín Farías', 'benjamin.farias@usm.cl', '+569300105', 2),
('20.101.202-3', 'Sebastián Lagos', 'sebastian.lagos@usm.cl', '+569400101', 2),
('21.303.404-5', 'Camila Espinoza', 'camila.espinoza@usm.cl', '+569400102', 2),
('19.444.888-9', 'Felipe Vicencio', 'felipe.vicencio@usm.cl', '+569400103', 2),
('20.555.777-K', 'Paula Venegas', 'paula.venegas@usm.cl', '+569400104', 2),
('21.666.999-0', 'Ignacio Tello', 'ignacio.tello@usm.cl', '+569400105', 2),
('20.333.111-2', 'Raimundo Larraín', 'raimundo.larrain@usm.cl', '+569500101', 2),
('21.222.888-7', 'Constanza Pizarro', 'constanza.pizarro@usm.cl', '+569500102', 2),
('19.111.777-K', 'Jorge Donoso', 'jorge.donoso@usm.cl', '+569500103', 2),
('20.888.666-5', 'Francisca Silva', 'francisca.silva@usm.cl', '+569500104', 2),
('21.777.444-3', 'Lucas Mardones', 'lucas.mardones@usm.cl', '+569500105', 2);

INSERT INTO INTEGRANTE_POSTULACION_R (funcion_integrante, departamento_o_area, id_sede, rut_persona, id_postulacion) VALUES
-- Postulación 1: Redes IoT
('Director', 'Telemática', 1, '15.432.891-2', 1), ('Investigador', 'Informática', 1, '12.654.321-K', 1), ('Asesor', 'Física', 1, '14.789.456-0', 1),
('Desarrollador', 'Telemática', 1, '20.455.123-1', 1), ('Analista', 'Telemática', 1, '21.002.345-K', 1), ('Tester', 'Telemática', 1, '19.888.765-4', 1),
('Documentador', 'Telemática', 1, '20.123.987-5', 1), ('Soporte', 'Telemática', 1, '21.444.555-6', 1),

-- Postulación 2: IA en Minería
('Director', 'Telemática', 2, '15.432.891-2', 2), ('Investigador', 'Informática', 2, '12.654.321-K', 2), ('Asesor', 'Física', 2, '14.789.456-0', 2),
('Desarrollador', 'Informática', 2, '20.765.432-1', 2), ('Analista', 'Informática', 2, '21.987.123-K', 2), ('Tester', 'Informática', 2, '19.555.444-3', 2),
('Documentador', 'Informática', 2, '20.111.222-9', 2), ('Soporte', 'Informática', 2, '21.333.444-0', 2),

-- Postulación 3: Riego Smart
('Director', 'Telemática', 3, '15.432.891-2', 3), ('Investigador', 'Informática', 3, '12.654.321-K', 3), ('Asesor', 'Física', 3, '14.789.456-0', 3),
('Desarrollador', 'Obras Civiles', 3, '20.900.800-7', 3), ('Analista', 'Obras Civiles', 3, '21.121.232-1', 3), ('Tester', 'Obras Civiles', 3, '19.999.000-K', 3),
('Documentador', 'Obras Civiles', 3, '20.444.333-2', 3), ('Soporte', 'Obras Civiles', 3, '21.555.666-8', 3),

-- Postulación 4: Logística 4.0
('Director', 'Telemática', 4, '15.432.891-2', 4), ('Investigador', 'Informática', 4, '12.654.321-K', 4), ('Asesor', 'Física', 4, '14.789.456-0', 4),
('Desarrollador', 'Industrias', 4, '20.101.202-3', 4), ('Analista', 'Industrias', 4, '21.303.404-5', 4), ('Tester', 'Industrias', 4, '19.444.888-9', 4),
('Documentador', 'Industrias', 4, '20.555.777-K', 4), ('Soporte', 'Industrias', 4, '21.666.999-0', 4),

-- Postulación 5: Panel Solar
('Director', 'Telemática', 5, '15.432.891-2', 5), ('Investigador', 'Informática', 5, '12.654.321-K', 5), ('Asesor', 'Física', 5, '14.789.456-0', 5),
('Desarrollador', 'Eléctrica', 5, '20.333.111-2', 5), ('Analista', 'Eléctrica', 5, '21.222.888-7', 5), ('Tester', 'Eléctrica', 5, '19.111.777-K', 5),
('Documentador', 'Eléctrica', 5, '20.888.666-5', 5), ('Soporte', 'Eléctrica', 5, '21.777.444-3', 5),

-- Postulación 6: App Salud 
('Director', 'Telemática', 1, '15.432.891-2', 6), ('Investigador', 'Informática', 1, '12.654.321-K', 6), ('Asesor', 'Física', 1, '14.789.456-0', 6),
('Desarrollador', 'Telemática', 1, '20.455.123-1', 6), ('Analista', 'Telemática', 1, '21.002.345-K', 6), ('Tester', 'Telemática', 1, '19.888.765-4', 6),
('Documentador', 'Telemática', 1, '20.123.987-5', 6), ('Soporte', 'Telemática', 1, '21.444.555-6', 6),

-- Postulación 7: Ciberseguridad 
('Director', 'Telemática', 2, '15.432.891-2', 7), ('Investigador', 'Informática', 2, '12.654.321-K', 7), ('Asesor', 'Física', 2, '14.789.456-0', 7),
('Desarrollador', 'Informática', 2, '20.765.432-1', 7), ('Analista', 'Informática', 2, '21.987.123-K', 7), ('Tester', 'Informática', 2, '19.555.444-3', 7),
('Documentador', 'Informática', 2, '20.111.222-9', 7), ('Soporte', 'Informática', 2, '21.333.444-0', 7),

-- Postulación 8: Taller Programación 
('Director', 'Telemática', 3, '15.432.891-2', 8), ('Investigador', 'Informática', 3, '12.654.321-K', 8), ('Asesor', 'Física', 3, '14.789.456-0', 8),
('Desarrollador', 'Obras Civiles', 3, '20.900.800-7', 8), ('Analista', 'Obras Civiles', 3, '21.121.232-1', 8), ('Tester', 'Obras Civiles', 3, '19.999.000-K', 8),
('Documentador', 'Obras Civiles', 3, '20.444.333-2', 8), ('Soporte', 'Obras Civiles', 3, '21.555.666-8', 8),

-- Postulación 9: Drones Agrícolas 
('Director', 'Telemática', 4, '15.432.891-2', 9), ('Investigador', 'Informática', 4, '12.654.321-K', 9), ('Asesor', 'Física', 4, '14.789.456-0', 9),
('Desarrollador', 'Industrias', 4, '20.101.202-3', 9), ('Analista', 'Industrias', 4, '21.303.404-5', 9), ('Tester', 'Industrias', 4, '19.444.888-9', 9),
('Documentador', 'Industrias', 4, '20.555.777-K', 9), ('Soporte', 'Industrias', 4, '21.666.999-0', 9),

-- Postulación 10: Data Center 
('Director', 'Telemática', 5, '15.432.891-2', 10), ('Investigador', 'Informática', 5, '12.654.321-K', 10), ('Asesor', 'Física', 5, '14.789.456-0', 10),
('Desarrollador', 'Eléctrica', 5, '20.333.111-2', 10), ('Analista', 'Eléctrica', 5, '21.222.888-7', 10), ('Tester', 'Eléctrica', 5, '19.111.777-K', 10),
('Documentador', 'Eléctrica', 5, '20.888.666-5', 10), ('Soporte', 'Eléctrica', 5, '21.777.444-3', 10);

INSERT INTO DOCUMENTO_ADJUNTO_R (id_documento, nombre_documento, ruta_documento, id_postulacion) VALUES
(1, 'iot_plan.pdf', '/vol1/d1.pdf', 1), (2, 'ia_minas.pdf', '/vol1/d2.pdf', 2),
(3, 'riego.pdf', '/vol1/d3.pdf', 3), (4, 'log_block.pdf', '/vol1/d4.pdf', 4),
(5, 'solar.pdf', '/vol1/d5.pdf', 5), (6, 'salud_app.pdf', '/vol1/d6.pdf', 6),
(7, 'audit_ciber.pdf', '/vol1/d7.pdf', 7), (8, 'python_curriculo.pdf', '/vol1/d8.pdf', 8),
(9, 'dron_map.pdf', '/vol1/d9.pdf', 9), (10, 'dc_storage.pdf', '/vol1/d10.pdf', 10);

SET FOREIGN_KEY_CHECKS = 1;