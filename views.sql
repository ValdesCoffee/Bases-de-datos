SELECT
    c.id_curso,
    c.nombre AS nombre_curso,
    c.codigo,
    COUNT(i.id_estudiante) AS total_estudiantes
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre, c.codigo
HAVING COUNT(i.id_estudiante) > 2
ORDER BY total_estudiantes DESC;

SELECT
    e.id_estudent,
    e.nombre_completo,
    e.carrera,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_estudiante
FROM estudiantes e
JOIN inscripciones i ON e.id_estudent = i.id_estudiante
GROUP BY e.id_estudent, e.nombre_completo, e.carrera
HAVING AVG(i.calificacion_final) > (
    SELECT AVG(calificacion_final)
    FROM inscripciones
)
ORDER BY promedio_estudiante DESC;

SELECT DISTINCT e.carrera
FROM estudiantes e
WHERE e.id_estudent IN (
    SELECT i.id_estudiante
    FROM inscripciones i
    JOIN cursos c ON i.id_curso = c.id_curso
    WHERE c.semestre >= 2
)
ORDER BY e.carrera;


SELECT DISTINCT e.carrera
FROM estudiantes e
WHERE EXISTS (
    SELECT 1
    FROM inscripciones i
    JOIN cursos c ON i.id_curso = c.id_curso
    WHERE i.id_estudiante = e.id_estudent
      AND c.semestre >= 2
)
ORDER BY e.carrera;
SELECT
    c.nombre AS nombre_curso,
    COUNT(i.id_inscripcion)                        AS total_inscritos,
    ROUND(AVG(i.calificacion_final), 2)            AS promedio_calificacion,
    MAX(i.calificacion_final)                      AS calificacion_maxima,
    MIN(i.calificacion_final)                      AS calificacion_minima,
    SUM(i.calificacion_final)                      AS suma_calificaciones,
    c.creditos                                     AS creditos_curso
FROM cursos c
LEFT JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre, c.creditos
ORDER BY total_inscritos DESC;

SELECT
    COUNT(DISTINCT e.id_estudent)                  AS total_estudiantes,
    COUNT(DISTINCT c.id_curso)                     AS total_cursos,
    COUNT(i.id_inscripcion)                        AS total_inscripciones,
    ROUND(AVG(i.calificacion_final), 2)            AS promedio_global,
    MAX(i.calificacion_final)                      AS nota_mas_alta,
    MIN(i.calificacion_final)                      AS nota_mas_baja,
    SUM(i.calificacion_final)                      AS suma_total_notas
FROM estudiantes e
LEFT JOIN inscripciones i ON e.id_estudent = i.id_estudiante
LEFT JOIN cursos c ON i.id_curso = c.id_curso;
