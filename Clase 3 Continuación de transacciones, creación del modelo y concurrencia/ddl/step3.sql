-- Tabla de Carrera
CREATE TABLE carrera (
    id_carrera SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de Curso
CREATE TABLE curso (
    id_curso SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_carrera INT REFERENCES carrera(id_carrera) -- Relación con la tabla Carrera
);

-- Tabla de Estudiante
CREATE TABLE estudiante (
    id_estudiante SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de Profesor
CREATE TABLE profesor (
    id_profesor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_tipo INT REFERENCES tipo_profesor(id_tipo) -- Relación con la tabla de tipos de profesores
);

-- Crear tabla para Profesor Titular que hereda de Profesor
CREATE TABLE titular (
    especialidad VARCHAR(50), -- Campo adicional específico para profesores titulares
    codigo tipo_profesor_enum REFERENCES tipo_profesor(codigo) DEFAULT 'TT'
) INHERITS (profesor); -- Indica que esta tabla hereda columnas de la tabla 'profesor'

ALTER TABLE titular ADD CONSTRAINT pk_titular PRIMARY KEY (id_profesor); -- Añadir clave primaria específica

-- Crear tabla para Profesor Interino que hereda de Profesor
CREATE TABLE interino (
    contrato_fecha DATE, -- Campo adicional específico para profesores interinos
    codigo tipo_profesor_enum REFERENCES tipo_profesor(codigo) DEFAULT 'IN'
) INHERITS (profesor); -- Indica que esta tabla hereda columnas de la tabla 'profesor'

ALTER TABLE interino ADD CONSTRAINT pk_interino PRIMARY KEY (id_profesor); -- Añadir clave primaria específica

-- Tabla de Instancia de Curso
CREATE TABLE instancia_curso (
    id_instancia SERIAL PRIMARY KEY,
    id_curso INT REFERENCES curso(id_curso), -- Relación con la tabla curso
    ciclo VARCHAR(10) NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    seccion VARCHAR(10) NOT NULL
);

-- Tabla de Examen
CREATE TABLE examen (
    id_examen SERIAL PRIMARY KEY,
    id_instancia INT REFERENCES instancia_curso(id_instancia) -- Relación con la tabla instancia_curso
);

-- Tabla de Asignación de Estudiantes a Cursos
CREATE TABLE asignacion (
    id_asignacion SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiante(id_estudiante),
    id_instancia INT REFERENCES instancia_curso(id_instancia)
);

-- Tabla de Examen Nota
CREATE TABLE examen_nota (
    id_examen INT REFERENCES examen(id_examen),
    id_estudiante INT REFERENCES estudiante(id_estudiante),
    nota DECIMAL(5,2),
    PRIMARY KEY (id_examen, id_estudiante)
);

-- Tabla de Sala Virtual
CREATE TABLE sala_virtual (
    id_sala SERIAL PRIMARY KEY,
    link VARCHAR(200) NOT NULL
);

-- Tabla de Salón de Clase
CREATE TABLE salon_clase (
    id_salon SERIAL PRIMARY KEY,
    numero VARCHAR(50) NOT NULL
);

-- Tabla para relacionar Instancia de Curso con Sala Virtual
CREATE TABLE instancia_sala_virtual (
    id_instancia INT REFERENCES instancia_curso(id_instancia),
    id_sala INT REFERENCES sala_virtual(id_sala),
    PRIMARY KEY (id_instancia, id_sala)
);

-- Tabla para relacionar Instancia de Curso con Salón de Clase
CREATE TABLE instancia_salon_clase (
    id_instancia INT REFERENCES instancia_curso(id_instancia),
    id_salon INT REFERENCES salon_clase(id_salon),
    PRIMARY KEY (id_instancia, id_salon)
);