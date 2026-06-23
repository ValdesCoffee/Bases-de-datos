-- AURI VALDES :) CLAN 3 MULATA
-- PRIMERO CREA LAS TABLAS 
-- TABLA (1) estudiantes --
CREATE TABLE estudiantes (
    id_estudent SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    genero VARCHAR(20) NOT NULL,
    carrera VARCHAR(50) NOT NULL,
    identificacion VARCHAR(50) UNIQUE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_deingreso DATE NOT NULL
);
SELECT * FROM estudiantes
-- TABLAS (2) DOCENTES
CREATE TABLE docentes (
  id_docente SERIAL PRIMARY KEY,
  nombre_docente VARCHAR(100),
  correo_institucional VARCHAR(100),
  departamento_academico VARCHAR(100),
  anios_exp NUMERIC
);

-- TABLAS (3) CURSOS
CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    id_docente INTEGER,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(100) UNIQUE NOT NULL,
    creditos SMALLINT CHECK (creditos > 0),
    semestre SMALLINT CHECK (semestre BETWEEN 1 AND 10),
    CONSTRAINT fk_curso_docente
        FOREIGN KEY (id_docente)
        REFERENCES docentes(id_docente)
);
SELECT * FROM cursos
-- TABLA (4) INSCRIPICONES
CREATE TABLE inscripciones (
    id_inscripcion SERIAL PRIMARY KEY,
    id_estudiante INTEGER NOT NULL,
    id_curso INTEGER NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    calificacion_final INTEGER,

    CONSTRAINT fk_inscripcion_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudent),

    CONSTRAINT fk_inscripcion_curso
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso)
);

SELECT * FROM inscripciones;

INSERT INTO estudiantes (
    id_estudent,
    nombre_completo,
    correo_electronico,
    genero,
    identificacion,
    carrera,
    fecha_nacimiento,
    fecha_deingreso
)
VALUES
(1,'Sofia López','sofialopez@gmail.com','F','14454334516','Diseño grafico','2008-12-05','2025-05-03'),
(2,'Diego Ramirez','diegoramirez@gmail.com','M','1445435660','Administracion de empresas','2008-10-05','2025-04-03'),
(3,'Valentina Mora','valentinamora@gmail.com','F','124734516','Quimica','2008-02-05','2025-06-03'),
(4,'Andres Mora','andresmora@gmail.com','M','1453414516','Fisica','2005-06-05','2023-05-03'),
(5,'Camila Rojas','camilarojas@gmail.com','F','14454334517','Diseño grafico','2008-12-05','2025-05-03');
INSERT INTO docentes (
    id_docente,
    nombre_docente,
    correo_institucional,
    departamento_academico,
    anios_exp
)
VALUES
    (1,'Aria Rodriguez','ariar@hotmail.com','Artes visuales',10),
    (2,'Roberto Zapata','robez@hotmail.com','Ciencias basicas',5),
    (3,'Estela Hernandez','estelah@hotmail.com','Ciencias economicas',3),
    (4,'Andres Ibañez','andresi@hotmail.com','Ciencias basicas',2);

--  REALIZANDO LOS CURSOS
INSERT INTO cursos (
    id_curso,
    id_docente,
    nombre,
    codigo,
    creditos,
    semestre
)
VALUES
    (1, 1, 'Historia del arte y diseño', '12564', 5, 6),
    (2, 4, 'Quimica organica', '156452', 8, 1),
    (3, 3, 'Estadistica administrativa', '464558', 3, 3),
    (4, 4, 'Instrumentacion del laboratorio en BIOQUIMICA', '47555', 9, 9);
-- REALIZANDO LAS INSCRIPCIONES 

-- Listar todos los estudiantes con sus inscripciones y cursos (JOIN).
SELECT
    e.nombre_completo,
    c.nombre AS curso,
    i.fecha_inscripcion,
    i.calificacion_final
FROM estudiantes e
INNER JOIN inscripciones i
    ON e.id_estudent = i.id_estudiante
INNER JOIN cursos c
    ON c.id_curso = i.id_curso;
-- Listar cursos dictados por docentes con > 5 años de experiencia.
SELECT
    c.nombre AS curso,
    d.nombre_docente,
    d.anios_exp
FROM cursos c
INNER JOIN docentes d
    ON c.id_docente = d.id_docente
WHERE d.anios_exp > 5;
-- Obtener promedio de calificaciones por curso (GROUP BY + AVG
SELECT
    c.nombre AS curso,
    AVG(i.calificacion_final) AS promedio
FROM cursos c
INNER JOIN inscripciones i
    ON c.id_curso = i.id_curso
GROUP BY c.nombre;

-- Mostrar estudiantes inscritos en más de un curso (HAVING COUNT(*) > 1).
SELECT
    e.nombre_completo,
    COUNT(i.id_curso) AS cantidad_cursos
FROM estudiantes e
INNER JOIN inscripciones i
    ON e.id_estudent = i.id_estudiante
GROUP BY e.id_estudent, e.nombre_completo
HAVING COUNT(i.id_curso) > 1;

-- ALTER TABLE: agregar columna estado_academico
ALTER TABLE estudiantes
ADD COLUMN estado_academico VARCHAR(30);

-- Eliminar un docente y observar el efecto en cursos (revisar ON DELETE en la FK).
ALTER TABLE cursos
DROP CONSTRAINT fk_curso_docente;

ALTER TABLE cursos
ADD CONSTRAINT fk_curso_docente
FOREIGN KEY (id_docente)
REFERENCES docentes(id_docente)
ON DELETE SET NULL;

-- 7. Consultar cursos con más de 2 estudiantes inscritos
SELECT
    c.nombre,
    COUNT(i.id_estudiante) AS total_estudiantes
FROM cursos c
INNER JOIN inscripciones i
    ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre
HAVING COUNT(i.id_estudiante) > 2;
