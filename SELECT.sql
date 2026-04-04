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
