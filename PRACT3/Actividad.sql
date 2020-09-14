/*
** Realizar una consulta que muestre el nombre con formato 'APELLIDO, NOMBRE', mayusculas todo el nombre,
** Email debera ser en formato 'mail@gmail.com', minusculas todo el valor,
** hire_date debera formato '01 de enero, 20' minusculas
** salario, $999.999,00000 formato extranjero.
** calcular monto comision, $999.999,00000 formato extranjero, --duda
** Departamento, imprimir el nombre del departamento en español, primera letra en mayusculas.
** Pais, si es mx, MEXICO, US- ESTADOS UNIDOS, otros valores, EXTRAGERO
** Region en español, Mayusculas.
** Parametros, Region EUR, AME, ASI, MEA
** Fecha 'YY-MM-DD'
*/

-- SELECT * FROM employees
-- SELECT department_name FROM departments group by department_name
-- SELECT * FROM departments
-- SELECT * FROM locations
-- SELECT * FROM regions
-- SELECT * FROM countries

    SELECT 
        UPPER(e.last_name || ', ' || e.first_name) NOMBRE,
        CONCAT(LOWER(e.email),'@gmail.com') CORREO,
        TO_CHAR(e.hire_date, 'DD Month, YY') FECHA_CONTRATO,
        TO_CHAR(e.salary,'L99G999D9999MI','NLS_NUMERIC_CHARACTERS = '',.''NLS_CURRENCY = ''$'' ') SALARIO,
        NVL2(
            e.commission_pct,
            TO_CHAR(e.salary*e.commission_pct,'L99G999D9999MI','NLS_NUMERIC_CHARACTERS = '',.''NLS_CURRENCY = ''$'' '),
            0
        ) COMISION,
        CASE d.department_name 
            WHEN 'Administration' THEN 'Administracion'
            WHEN 'Treasury' THEN 'Tesorería'
            WHEN 'Accounting' THEN 'Contabilidad'
            WHEN 'Manufacturing' THEN 'Manufactura'
            WHEN 'Construction' THEN 'Construccion'
            WHEN 'Government Sales' THEN 'Ventas Gubernamentales'
            WHEN 'Purchasing' THEN 'Compras'
            WHEN 'Human Resources' THEN 'Recursos Humanos'
            WHEN 'IT' THEN 'Tecnologias De La Informacion'
            WHEN 'Public Relations' THEN 'Relaciones Publicas'
            WHEN 'Executive' THEN 'Ejecutivo'
            WHEN 'Benefits' THEN 'Prestaciones'
            WHEN 'Shipping' THEN 'Envios'
            WHEN 'Corporate Tax' THEN 'Impuestos Corporativos'
            WHEN 'Contracting' THEN 'Contratación'
            WHEN 'NOC' THEN 'Centro De Operaciones De Red'
            WHEN 'Retail Sales' THEN 'Ventas Al Por Menor'
            WHEN 'Recruiting' THEN 'Reclutamiento'
            WHEN 'Payroll' THEN 'Nómina'
            WHEN 'Control And Credit' THEN 'Control Y Credito'
            WHEN 'Shareholder Services' THEN 'Servicios Al Accionista'
            WHEN 'Sales' THEN 'Ventas'
            WHEN 'Finance' THEN 'Finanzas'
            WHEN 'Marketing' THEN 'Marketing'
            WHEN 'IT Helpdesk' THEN 'Servicio De Ayuda Informatica'
            WHEN 'Operations' THEN 'Operaciones'
            WHEN 'IT Support' THEN 'Soporte Técnico'
            END DEPARTAMENTO,
        DECODE(c.country_id,'MX','Mexico','US','Estados Unidos','Extranjero') Pais,
        UPPER(DECODE(r.region_name,'Europe','Europa','Middle East and Africa','Medio Oriente Y Africa',r.region_name)) Region
    FROM 
        employees e,
        departments d,
        locations l,
        countries c,
        regions r
    WHERE
        d.department_id= e.department_id AND
        l.location_id = d.location_id AND
        c.country_id = l.country_id AND
        r.region_id = c.region_id AND
        r.region_name = DECODE(TO_CHAR(:p_country),'EUR','Europe','AME','Americas','ASI','Asia','MEA','Middle East and Africa') AND
        TO_DATE(e.hire_date,'YY-MM-DD') < TO_DATE(:p_date,'yy-mm-dd')
    order by e.hire_date;
        
/*
** Imprimir la region(español), pais (mx, MEXICO, US- ESTADOS UNIDOS, otros valores, EXTRAGERO)
** departamento (mayusculas), hire_date(MM-YYYY), suma de los salarios, $999.999,00000 formato extranjero,
*/

SELECT
    DECODE(r.region_name,'Europe','Europa','Middle East and Africa','Medio Oriente Y Africa',r.region_name) Region,
    DECODE(c.country_id,'MX','Mexico','US','Estados Unidos','Extranjero') Pais,
    d.department_name departamento,
    TO_CHAR(e.hire_date,'MM-YYYY') Fecha,
    TO_CHAR(sum(e.salary),'L99G999D9999MI','NLS_NUMERIC_CHARACTERS = '',.''NLS_CURRENCY = ''$'' ') SALARIO
FROM
    regions r,
    employees e,
    countries c,
    locations l,
    departments d
WHERE 
    d.department_id = e.department_id and
    l.location_id = d.location_id and
    c.country_id = l.country_id and
    r.region_id = c.region_id
group by 
    TO_CHAR(e.hire_date,'MM-YYYY'),
    d.department_name,
    DECODE(c.country_id,'MX','Mexico','US','Estados Unidos','Extranjero'),
    DECODE(r.region_name,'Europe','Europa','Middle East and Africa','Medio Oriente Y Africa',r.region_name);
 