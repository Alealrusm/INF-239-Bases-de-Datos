SELECT 
    (SELECT COUNT(*) FROM POSTULACION_R) AS total_postulaciones,
    (SELECT COUNT(*) FROM EMPRESA_EXTERNA_R) AS total_empresas,
    (SELECT COUNT(*) FROM PERSONA_R) AS total_personas,
    (SELECT COUNT(*) FROM INTEGRANTE_POSTULACION_R) AS total_integrantes,
    (SELECT COUNT(*) FROM ETAPA_CRONOGRAMA_R) AS total_etapas;
    
SELECT 
    p.codigo_interno AS 'Código',
    p.nombre_iniciativa AS 'Proyecto',
    e.nombre_empresa AS 'Empresa Cliente',
    s.nombre_sede AS 'Sede USM',
    re.nombre_region AS 'Región Ejecución',
    ri.nombre_region AS 'Región Impacto',
    p.presupuesto_total AS 'Presupuesto'
FROM POSTULACION_R p
JOIN EMPRESA_EXTERNA_R e ON p.rut_empresa = e.rut_empresa
JOIN SEDE_R s ON p.id_sede = s.id_sede
JOIN REGION_R re ON p.id_region_ejecucion = re.id_region
JOIN REGION_R ri ON p.id_region_impacto = ri.id_region;

SELECT 
    i.id_postulacion,
    p.codigo_interno,
    SUM(CASE WHEN per.id_persona = 1 THEN 1 ELSE 0 END) AS total_profesores,
    SUM(CASE WHEN per.id_persona = 2 THEN 1 ELSE 0 END) AS total_estudiantes,
    COUNT(*) AS total_integrantes
FROM INTEGRANTE_POSTULACION_R i
JOIN POSTULACION_R p ON i.id_postulacion = p.id_postulacion
JOIN PERSONA_R per ON i.rut_persona = per.rut_persona
GROUP BY i.id_postulacion, p.codigo_interno
HAVING total_profesores = 3 AND total_estudiantes = 5;

-- 1. Listado general de postulaciones
SELECT
	p.postulacion_n AS 'Postulación N°',
    p.fecha_postulacion AS 'Fecha',
    ti.nombre_iniciativa AS 'Tipo Iniciativa',
    s.nombre_sede AS 'Sede',
	re.nombre_region AS 'Región Ejecución',
    ri.nombre_region AS 'Región Impacto',
    e.nombre_empresa AS 'Empresa',
    p.presupuesto_total AS 'Presupuesto Total'
FROM POSTULACION_R p
JOIN TIPO_INICIATIVA_R ti ON p.id_iniciativa = ti.id_iniciativa
JOIN SEDE_R s ON p.id_sede = s.id_sede
JOIN REGION_R re ON p.id_region_ejecucion = re.id_region
JOIN REGION_R ri ON p.id_region_impacto = ri.id_region
JOIN EMPRESA_EXTERNA_R e ON p.rut_empresa = e.rut_empresa;

-- 2. Postulaciones por región.
SELECT
	e.nombre_empresa AS 'Empresa',
    s.nombre_sede AS 'Sede',
    p.presupuesto_total AS 'Presupuesto Total'
FROM POSTULACION_R p
JOIN EMPRESA_EXTERNA_R e ON p.rut_empresa = e.rut_empresa
JOIN SEDE_R s ON p.id_sede = s.id_sede
JOIN REGION_R r ON p.id_region_ejecucion = r.id_region
WHERE r.nombre_region = 'Libertador General Bernardo O''Higgins';

-- 3. Conteo por tipo de iniciativa
SELECT
	ti.nombre_iniciativa AS 'Tipo',
    COUNT(p.id_postulacion) AS 'Cantidad'
FROM TIPO_INICIATIVA_R ti
LEFT JOIN POSTULACION_R p ON ti.id_iniciativa = p.id_iniciativa
GROUP BY ti.nombre_iniciativa;

-- 4. Equipo de trabajo de una postulación
SELECT
	per.rut_persona AS 'RUT',
    per.nombre_persona AS 'Nombre',
    cp.rol_asumido AS 'Tipo Persona',
    s.nombre_sede AS 'Sede',
    per.email_persona AS 'Email',
    i.funcion_integrante AS 'Rol'
FROM INTEGRANTE_POSTULACION_R i
JOIN PERSONA_R per ON i.rut_persona = per.rut_persona
JOIN CARGO_PERSONA_R cp ON per.id_persona = cp.id_persona
JOIN SEDE_R s ON i.id_sede = s.id_sede
JOIN POSTULACION_R p ON i.id_postulacion = p.id_postulacion
WHERE p.codigo_interno = 'INF-01';

-- 5. Empresas con postulaciones y convenio.
SELECT 
	e.nombre_empresa AS 'Empresa',
    te.tamano_empresa AS 'Tamaño',
    CASE WHEN e.convenio_usm = 1 THEN 'Si' ELSE 'NO' END AS 'Convenio'
FROM EMPRESA_EXTERNA_R e
JOIN TAMANO_EMPRESA_R te ON e.id_tamano = te.id_tamano
LEFT JOIN POSTULACION_R p ON e.rut_empresa = p.rut_empresa
GROUP BY e.rut_empresa
ORDER BY COUNT(p.id_postulacion) DESC;

-- 6. Postulaciones con presupuesto sobre el promedio.
SELECT 
	p.postulacion_n AS 'Postulación N°',
	e.nombre_empresa AS 'Empresa',
    p.presupuesto_total AS 'Presupuesto Total'
FROM POSTULACION_R p
JOIN EMPRESA_EXTERNA_R e ON p.rut_empresa = e.rut_empresa
WHERE p.presupuesto_total > (SELECT AVG(presupuesto_total) FROM POSTULACION_R)
ORDER BY p.presupuesto_total DESC;

-- 7. Cantidad de integrantes por postulaci´on y tipo
SELECT 
	p.postulacion_n AS 'Postulación N°',
    cp.rol_asumido AS 'Tipo Persona',
    COUNT(i.rut_persona) AS 'Cantidad'
FROM INTEGRANTE_POSTULACION_R i
JOIN PERSONA_R per ON i.rut_persona = per.rut_persona
JOIN CARGO_PERSONA_R cp ON per.id_persona = cp.id_persona
JOIN POSTULACION_R p ON i.id_postulacion = p.id_postulacion
GROUP BY p.postulacion_n, cp.rol_asumido;

-- 8. Postulaciones que no cumplen el m´ınimo de equipo.
SELECT 
	p.postulacion_n AS 'Postulación N°',
    SUM(CASE WHEN per.id_persona = 1 THEN 1 ELSE 0 END) AS 'Cantidad Profesores',
    SUM(CASE WHEN per.id_persona = 2 THEN 1 ELSE 0 END) AS 'Cantidad Estudiantes'
FROM POSTULACION_R p
JOIN INTEGRANTE_POSTULACION_R i ON p.id_postulacion = i.id_postulacion
JOIN PERSONA_R per ON i.rut_persona = per.rut_persona
GROUP BY p.postulacion_n
HAVING SUM(CASE WHEN per.id_persona = 1 THEN 1 ELSE 0 END) < 3 OR 
	   SUM(CASE WHEN per.id_persona = 2 THEN 1 ELSE 0 END) < 5;

--  9. Empresas sin postulaciones registradas.
SELECT 
	e.nombre_empresa AS 'Empresa',
    e.rut_empresa AS 'RUT',
    te.tamano_empresa AS 'Tamaño'
FROM EMPRESA_EXTERNA_R e
JOIN TAMANO_EMPRESA_R te ON e.id_tamano = te.id_tamano
LEFT JOIN POSTULACION_R p ON e.rut_empresa = p.rut_empresa
WHERE p.id_postulacion IS NULL;

-- 10. Postulaciones que exceden el plazo m´aximo.
SELECT
	p.postulacion_n AS 'Postulación N°',
    p.codigo_interno AS 'Código',
    COUNT(ec.id_etapa) AS 'Total Etapas',
    SUM(ec.plazo_semanas) AS 'Total Semanas'
FROM POSTULACION_R p
JOIN ETAPA_CRONOGRAMA_R ec ON p.id_postulacion = ec.id_postulacion
GROUP BY p.id_postulacion
HAVING SUM(ec.plazo_semanas) > 36
ORDER BY SUM(ec.plazo_semanas) DESC;