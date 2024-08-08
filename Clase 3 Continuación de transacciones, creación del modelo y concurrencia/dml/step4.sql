-- Insertar valores en la tabla Carrera
INSERT INTO carrera (nombre) VALUES ('Ingeniería en Sistemas'), ('Ingeniería Civil');

-- Insertar valores en la tabla Curso
INSERT INTO curso (nombre, id_carrera) VALUES ('Bases de Datos', 1), ('Estructuras de Datos', 1);

-- Insertar valores en la tabla Estudiante
INSERT INTO estudiante (nombre) VALUES ('Juan Pérez'), ('María López');

-- Insertar valores en la tabla Profesor
INSERT INTO profesor (nombre, id_tipo) VALUES ('Carlos Sánchez', 1), ('Ana González', 2);

-- Insertar valores en la tabla Instancia de Curso
INSERT INTO instancia_curso (id_curso, ciclo, semestre, seccion) VALUES (1, '2024', '1', 'A');

-- Insertar valores en la tabla Examen
INSERT INTO examen (id_instancia) VALUES (1);

-- Insertar valores en la tabla Asignación
INSERT INTO asignacion (id_estudiante, id_instancia) VALUES (1, 1), (2, 1);

-- Insertar valores en la tabla Examen Nota
INSERT INTO examen_nota (id_examen, id_estudiante, nota) VALUES (1, 1, 85.5), (1, 2, 92.0);

-- Insertar valores en la tabla Sala Virtual
INSERT INTO sala_virtual (link) VALUES ('http://virtualclassroom.com/123'), ('http://virtualclassroom.com/456');

-- Insertar valores en la tabla Salón de Clase
INSERT INTO salon_clase (numero) VALUES ('101A'), ('102B');

-- Insertar valores en la tabla instancia_sala_virtual
INSERT INTO instancia_sala_virtual (id_instancia, id_sala) VALUES (1, 1);

-- Insertar valores en la tabla instancia_salon_clase
INSERT INTO instancia_salon_clase (id_instancia, id_salon) VALUES (1, 1);