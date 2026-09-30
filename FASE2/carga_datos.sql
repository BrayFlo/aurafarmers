CREATE TABLE especialidades (
    id_especialidad SERIAL PRIMARY KEY,
    nombre_especialidad VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE pacientes (
    id_paciente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(10) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    direccion VARCHAR(255),
    contacto_emergencia VARCHAR(100),
    telefono_emergencia VARCHAR(15),
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE medicos (
    id_medico SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    cedula_profesional VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_especialidad INT NOT NULL REFERENCES especialidades(id_especialidad)
);

CREATE TABLE expedientes_base (
    id_expediente SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL UNIQUE REFERENCES pacientes(id_paciente),
    tipo_sangre VARCHAR(5),
    alergias TEXT,
    antecedentes_patologicos TEXT,
    antecedentes_heredofamiliares TEXT,
    fecha_apertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE citas (
    id_cita SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL REFERENCES pacientes(id_paciente),
    id_medico INT NOT NULL REFERENCES medicos(id_medico),
    fecha_hora TIMESTAMP NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    notas TEXT,
    CONSTRAINT unique_medico_horario UNIQUE (id_medico, fecha_hora)
);



CREATE TABLE notas_consulta (
    id_nota SERIAL PRIMARY KEY,
    id_expediente INT NOT NULL REFERENCES expedientes_base(id_expediente),
    id_medico INT NOT NULL REFERENCES medicos(id_medico),
    id_cita INT UNIQUE REFERENCES citas(id_cita),
    fecha_consulta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    peso DECIMAL(5,2),
    talla DECIMAL(4,2),
    presion_arterial VARCHAR(10),
    temperatura DECIMAL(4,1),
    sintomas TEXT NOT NULL,
    diagnostico TEXT NOT NULL
);


CREATE TABLE recetas (
    id_receta SERIAL PRIMARY KEY,
    id_nota INT NOT NULL REFERENCES notas_consulta(id_nota),
    fecha_emision TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vigencia_dias INT NOT NULL DEFAULT 30,
    indicaciones_generales TEXT
);

CREATE TABLE estudios_laboratorio (
    id_estudio SERIAL PRIMARY KEY,
    id_nota INT NOT NULL REFERENCES notas_consulta(id_nota),
    tipo_estudio VARCHAR(100) NOT NULL,
    fecha_solicitud DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_resultado DATE,
    estado VARCHAR(20) NOT NULL,
    resultado TEXT,
    archivo_url VARCHAR(255)
);


CREATE TABLE detalle_recetas (
    id_detalle SERIAL PRIMARY KEY,
    id_receta INT NOT NULL REFERENCES recetas(id_receta),
    num_item INT NOT NULL,
    medicamento VARCHAR(150) NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion VARCHAR(50) NOT NULL,
    CONSTRAINT unique_receta_item UNIQUE (id_receta, num_item)
);

-- ============================================================
-- 1. ESPECIALIDADES
-- ============================================================

INSERT INTO especialidades (nombre_especialidad, descripcion)
VALUES
('Medicina General', 'Atención médica general'),
('Cardiología', 'Especialidad del corazón'),
('Pediatría', 'Atención médica infantil'),
('Dermatología', 'Enfermedades de la piel'),
('Ginecología', 'Salud femenina');


-- ============================================================
-- 2. PACIENTES
-- ============================================================

INSERT INTO pacientes (
    nombre,
    apellido_paterno,
    apellido_materno,
    fecha_nacimiento,
    genero,
    telefono,
    email,
    direccion,
    contacto_emergencia,
    telefono_emergencia
)
VALUES
('Juan', 'García', 'López', '1998-05-12', 'Masculino',
 '5512345678', 'juan.garcia@gmail.com', 'Av. Central 123',
 'María García', '5587654321'),

('María', 'Hernández', 'Pérez', '2001-08-20', 'Femenino',
 '5523456789', 'maria.hernandez@gmail.com', 'Calle Juárez 45',
 'Carlos Hernández', '5598765432'),

('Carlos', 'Martínez', 'Ramírez', '1985-02-10', 'Masculino',
 '5534567890', 'carlos.martinez@gmail.com', 'Calle Reforma 78',
 'Ana Martínez', '5576543210'),

('Ana', 'López', 'González', '1995-11-03', 'Femenino',
 '5545678901', 'ana.lopez@gmail.com', 'Av. Universidad 56',
 'Luis López', '5565432109'),

('Luis', 'Rodríguez', 'Torres', '1978-07-25', 'Masculino',
 '5556789012', 'luis.rodriguez@gmail.com', 'Calle Hidalgo 90',
 'Laura Rodríguez', '5554321098');


-- ============================================================
-- 3. MÉDICOS
-- ============================================================

INSERT INTO medicos (
    nombre,
    apellido_paterno,
    apellido_materno,
    cedula_profesional,
    email,
    telefono,
    estado,
    id_especialidad
)
VALUES
('Roberto', 'Sánchez', 'Gómez', 'MED000001',
 'roberto.sanchez@clinica.com', '5511111111', 'Activo', 1),

('Laura', 'Ramírez', 'Flores', 'MED000002',
 'laura.ramirez@clinica.com', '5522222222', 'Activo', 2),

('Miguel', 'Torres', 'Díaz', 'MED000003',
 'miguel.torres@clinica.com', '5533333333', 'Activo', 3),

('Patricia', 'Gómez', 'Morales', 'MED000004',
 'patricia.gomez@clinica.com', '5544444444', 'Activo', 4),

('Fernando', 'Flores', 'Rivera', 'MED000005',
 'fernando.flores@clinica.com', '5555555555', 'Activo', 5);


-- ============================================================
-- 4. EXPEDIENTES
-- Un expediente por paciente
-- ============================================================

INSERT INTO expedientes_base (
    id_paciente,
    tipo_sangre,
    alergias,
    antecedentes_patologicos,
    antecedentes_heredofamiliares
)
VALUES
(1, 'O+', 'Ninguna conocida',
 'Sin antecedentes relevantes',
 'Sin antecedentes familiares relevantes'),

(2, 'A+', 'Penicilina',
 'Asma',
 'Antecedentes de hipertensión'),

(3, 'B+', 'Ninguna conocida',
 'Hipertensión',
 'Antecedentes cardiovasculares'),

(4, 'O-', 'Polen',
 'Gastritis',
 'Antecedentes de diabetes'),

(5, 'AB+', 'Mariscos',
 'Diabetes tipo 2',
 'Antecedentes de diabetes');


-- ============================================================
-- 5. CITAS
-- ============================================================

INSERT INTO citas (
    id_paciente,
    id_medico,
    fecha_hora,
    motivo,
    estado,
    notas
)
VALUES
(1, 1, '2026-10-01 09:00:00',
 'Consulta general', 'Completada',
 'Consulta de rutina'),

(2, 2, '2026-10-02 10:00:00',
 'Dolor en el pecho', 'Completada',
 'Paciente refiere molestias'),

(3, 3, '2026-10-03 11:00:00',
 'Revisión médica', 'Completada',
 'Revisión general'),

(4, 4, '2026-10-04 12:00:00',
 'Problemas de piel', 'Completada',
 'Presenta irritación'),

(5, 5, '2026-10-05 13:00:00',
 'Consulta de seguimiento', 'Completada',
 'Seguimiento de tratamiento');


-- ============================================================
-- 6. NOTAS DE CONSULTA
-- ============================================================

INSERT INTO notas_consulta (
    id_expediente,
    id_medico,
    id_cita,
    peso,
    talla,
    presion_arterial,
    temperatura,
    sintomas,
    diagnostico
)
VALUES
(1, 1, 1,
 72.50, 1.75, '120/80', 36.5,
 'Dolor de cabeza ocasional',
 'Cefalea tensional'),

(2, 2, 2,
 65.30, 1.68, '130/85', 36.7,
 'Dolor leve en el pecho',
 'Dolor muscular'),

(3, 3, 3,
 82.10, 1.78, '140/90', 36.6,
 'Dolor de cabeza y mareos',
 'Hipertensión'),

(4, 4, 4,
 58.40, 1.62, '118/76', 36.8,
 'Irritación y comezón',
 'Dermatitis'),

(5, 5, 5,
 90.20, 1.80, '135/85', 37.0,
 'Sed frecuente y cansancio',
 'Diabetes tipo 2');


-- ============================================================
-- 7. RECETAS
-- ============================================================

INSERT INTO recetas (
    id_nota,
    vigencia_dias,
    indicaciones_generales
)
VALUES
(1, 30, 'Tomar después de los alimentos.'),
(2, 15, 'Tomar con abundante agua.'),
(3, 30, 'Tomar diariamente a la misma hora.'),
(4, 10, 'Aplicar según indicaciones médicas.'),
(5, 30, 'Seguir dieta recomendada y tratamiento.');


-- ============================================================
-- 8. DETALLE DE RECETAS
-- Un medicamento por receta
-- ============================================================

INSERT INTO detalle_recetas (
    id_receta,
    num_item,
    medicamento,
    dosis,
    frecuencia,
    duracion
)
VALUES
(1, 1, 'Paracetamol', '500 mg',
 'Cada 8 horas', '3 días'),

(2, 1, 'Ibuprofeno', '400 mg',
 'Cada 12 horas', '5 días'),

(3, 1, 'Losartán', '50 mg',
 'Cada 24 horas', '30 días'),

(4, 1, 'Loratadina', '10 mg',
 'Cada 24 horas', '10 días'),

(5, 1, 'Metformina', '850 mg',
 'Cada 12 horas', '30 días');


-- ============================================================
-- 9. ESTUDIOS DE LABORATORIO
-- ============================================================

INSERT INTO estudios_laboratorio (
    id_nota,
    tipo_estudio,
    fecha_solicitud,
    fecha_resultado,
    estado,
    resultado,
    archivo_url
)
VALUES
(1, 'Biometría hemática', '2026-10-01', '2026-10-02',
 'Completado', 'Resultados dentro de parámetros normales.', NULL),

(2, 'Química sanguínea', '2026-10-02', '2026-10-03',
 'Completado', 'Valores normales.', NULL),

(3, 'Perfil lipídico', '2026-10-03', '2026-10-04',
 'Completado', 'Colesterol ligeramente elevado.', NULL),

(4, 'Examen general de orina', '2026-10-04', '2026-10-05',
 'Completado', 'Sin alteraciones significativas.', NULL),

(5, 'Glucosa en sangre', '2026-10-05', '2026-10-06',
 'Completado', 'Glucosa elevada.', NULL);

INSERT INTO citas (
    id_paciente,
    id_medico,
    fecha_hora,
    motivo,
    estado,
    notas
)
SELECT
    (floor(random() * 5) + 1)::int,
    (floor(random() * 5) + 1)::int,
    TIMESTAMP '2026-01-01 08:00:00'
        + (gs * INTERVAL '1 hour'),
    (ARRAY[
        'Consulta general',
        'Revisión médica',
        'Dolor de cabeza',
        'Dolor abdominal',
        'Seguimiento médico'
    ])[floor(random() * 5 + 1)::int],
    (ARRAY[
        'Programada',
        'Completada',
        'Cancelada'
    ])[floor(random() * 3 + 1)::int],
    'Cita generada para prueba de volumen'
FROM generate_series(1, 10000) AS gs;
