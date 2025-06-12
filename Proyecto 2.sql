-- ======================================================================== --
--                      Proyeccion de trabajo por la IA        
-- ========================================================================= -- 





-- =========== Cargar los datos ================== --

#crear la base de datos
CREATE DATABASE empelos_ai;

#usar base de datos
USE empelos_AI;

#llamar a la tabla
select * from empleos;

/*
Crear procedimiento almacenado para
la consulta "select * from empelos;
ya que se usara continuamente"
*/
DELIMITER //
CREATE PROCEDURE sel()
BEGIN
    SELECT * FROM empleos;
END //
DELIMITER ;
-- ejecutar el procedimiento
CALL sel;

-- =========== Analisis exploratorio de datos ================== --
#numero de filas
SELECT COUNT(*) AS total_filas
FROM empleos;

/*
#para las columnas
SELECT COUNT(*) AS num_columnas
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'empleos_ai'
  AND table_name = 'empleos';
*/
#mostrar todas las columnas de la tabla
SHOW COLUMNS FROM empelos_ai.empleos;

#contar el numero de columnas
SELECT COUNT(*) AS numero_columnas
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'empelos_ai'
  AND TABLE_NAME = 'empleos';#hay 10 columnas en total

#conocer la estructura e la tabla
describe empleos;
call sel;

#valores nulos en cada columna
SELECT
  SUM(CASE WHEN Job_Title IS NULL THEN 1 ELSE 0 END) AS nulos_Job_Title,
  SUM(CASE WHEN Industry IS NULL THEN 1 ELSE 0 END) AS nulos_Industry,
  SUM(CASE WHEN Company_Size IS NULL THEN 1 ELSE 0 END) AS nulos_Company_Size,
  SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS nulos_Location,
  SUM(CASE WHEN AI_Adoption_Level IS NULL THEN 1 ELSE 0 END) AS nulos_AI_Adoption_Level,
  SUM(CASE WHEN Automation_Risk IS NULL THEN 1 ELSE 0 END) AS nulos_Automation_Risk,
  SUM(CASE WHEN Required_Skills IS NULL THEN 1 ELSE 0 END) AS nulos_Required_Skills,
  SUM(CASE WHEN Salary_USD IS NULL THEN 1 ELSE 0 END) AS nulos_Salary_USD,
  SUM(CASE WHEN Remote_Friendly IS NULL THEN 1 ELSE 0 END) AS nulos_Remote_Friendly,
  SUM(CASE WHEN Job_Growth_Projection IS NULL THEN 1 ELSE 0 END) AS nulos_Job_Growth_Projection
FROM empleos;  #no hay datos nulos en esta tabla




-- =========== Limpieza de datos ================== --

describe empleos;
call sel;

#como toda la data viene limpia en el formato correspondiente de datos, solo reduciremos los decimales del salario ya que es innecesario tener tantos

#cambiar el tipo de dato de salarios
ALTER TABLE empleos
MODIFY COLUMN Salary_USD DECIMAL(10,2);

#actualizar permanetntemente la columna salarios con dos digitos sin redondear, solo truncarlo
UPDATE empleos
SET Salary_USD = TRUNCATE(Salary_USD, 2)
WHERE Salary_USD IS NOT NULL;



-- =========== Analisis de datos y obtencion de infromacion ================== --

#una vez que ya tenemos la data limpia, podemos empezar a extraer informacion de negocio
call sel;

# algunos objetivos que podemos dar:

/*
Job_Title

	Identificar los títulos de trabajo más comunes.

	Analizar la diversidad de roles por industria o ubicación.

Industry

	Determinar cuáles son las industrias con mayor representación.

	Comparar los salarios promedio entre industrias.

Company_Size

	Estudiar la distribución de los tamaños de empresa.

	Ver si existe alguna relación entre tamaño de empresa y nivel de adopción de IA.

Location

	Mapear la distribución geográfica de los empleos.

	Analizar las ubicaciones más amigables con el trabajo remoto.

AI_Adoption_Level

	Explorar cómo varía el nivel de adopción de IA por industria.

	Identificar si las empresas con alta adopción de IA pagan más.

Automation_Risk

	Identificar los roles con mayor y menor riesgo de automatización.

	Estudiar si los trabajos remotos tienen menor riesgo de automatización.

Required_Skills

	Contar las habilidades más frecuentemente requeridas.

	Agrupar habilidades por industria o tipo de trabajo.

Salary_USD

	Analizar la distribución de salarios (mediana, promedio, percentiles).

	Comparar salarios por industria, tamaño de empresa o nivel de adopción de IA.

Remote_Friendly

	Estimar el porcentaje de trabajos que permiten trabajo remoto.

	Ver qué industrias o títulos laborales son más amigables con el trabajo remoto.

Job_Growth_Projection

	Identificar los trabajos con mayor crecimiento proyectado.

	Relacionar crecimiento con adopción de IA, automatización o ubicación.


*/


#primer objetivo

/*
Job_Title

	Identificar los títulos de trabajo más comunes.

	Analizar la diversidad de roles por industria o ubicación.

*/

call sel;

#cantidad de trabajos segun el perfil
SELECT job_Title, COUNT(*) AS cantidad
FROM empleos
GROUP BY job_Title
ORDER BY cantidad DESC;

#comprobar que son 500 titulos de trabajo
SELECT SUM(cantidad) AS total
FROM (
    SELECT COUNT(*) AS cantidad
    FROM empleos
    GROUP BY job_Title
) AS subconsulta;

#segundo objetivo

/*
Industry

	Comparar los salarios promedio entre industrias.

*/

#salario promedio por industria
call sel;
SELECT Industry,
    AVG(Salary_usd) AS Average_Salary
FROM empleos
GROUP BY Industry;

#salario promedio por tamaño de industria
select company_size ,
	avg(salary_usd) as proimedio_tamaño
from empleos
group by company_size;


#tercer objetivo

/*
Company_Size

	Estudiar la distribución de los tamaños de empresa.

	Ver si existe alguna relación entre tamaño de empresa y nivel de adopción de IA.
*/

call sel;

SELECT 
    Company_Size,
    AI_Adoption_Level,
    COUNT(*) AS Total
FROM 
    empleos
GROUP BY 
    Company_Size, AI_Adoption_Level
ORDER BY 
    Company_Size, AI_Adoption_Level;


#cuarto objetivo
/*
Automation_Risk

	Identificar los roles con mayor y menor riesgo de automatización.

	Estudiar si los trabajos remotos tienen menor riesgo de automatización.
    
*/
    
    
call sel;


SELECT 
    Job_Title, Industry, Company_Size, Location, Automation_Risk
FROM 
    empleos
WHERE 
    Automation_Risk = 'High';
    
    
    
/*´
podriamos seguir investigando tantos insights como queramos, pero por cuestiones practicas, aqui se dejará

*/

    