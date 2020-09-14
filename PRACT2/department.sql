CREATE VIEW v_departments AS 
SELECT 
    d.department_name,
    e.first_name || ' ' || e.last_name as name_manager,
    d.location_id,
    d.department_id
FROM DEPARTMENTS d
INNER JOIN employees e ON e.employee_id = d.manager_id;


CREATE VIEW v_department_address AS SELECT 
    v_departments.department_name,
    v_departments.department_id,
    v_departments.name_manager,
    l.street_address,
    l.postal_code,
    l.city,
    l.state_province,
    l.country_id
FROM locations l
INNER JOIN v_departments ON l.location_id = v_departments.location_id;

CREATE VIEW v_department_info AS SELECT
    v_department_address.department_name,
    v_department_address.department_id,
    v_department_address.name_manager,
    v_department_address.street_address,
    v_department_address.postal_code,
    v_department_address.city,
    v_department_address.state_province,
    c.country_name
FROM countries c
INNER JOIN v_department_address ON c.country_id = v_department_address.country_id;

CREATE VIEW v_departm_empl AS SELECT
    department_id,
    count(department_id) AS total_emp,
    round(avg(salary),2) as prom_salary
FROM employees
where department_id IS NOT NULL
group by department_id;

DECLARE
    CURSOR c_depart IS
        SELECT
            v_department_info.department_name,
            v_department_info.name_manager,
            v_department_info.street_address,
            v_department_info.postal_code,
            v_department_info.city,
            v_department_info.state_province,
            v_department_info.country_name,
            v_departm_empl.total_emp,
            v_departm_empl.prom_salary
        FROM v_department_info
        INNER JOIN v_departm_empl ON v_department_info.department_id = v_departm_empl.department_id
        ORDER BY v_department_info.department_name, v_department_info.name_manager;
    i_department_name VARCHAR2(100);
    i_name_manager VARCHAR2(100);
    i_street_address VARCHAR2(100);
    i_postal_code VARCHAR2(100):='V';
    i_city VARCHAR2(100);
    i_state_province VARCHAR2(100):='V';
    i_country_name VARCHAR2(100);
    i_total_emp VARCHAR2(100);
    i_prom_salary VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('DEPARTAMENTO',25) ||
        RPAD('MANAGER',20) ||   
        RPAD('CALLE',32) ||
        RPAD('C.P.',20) || 
        RPAD('CIUDAD',32) ||
        RPAD('ESTADO',20) ||
        RPAD('PAIS',32) ||
        RPAD('PERSONAL',9) ||
        RPAD('SALARIO PROM',12)
    );
    FOR i_depart IN c_depart
    LOOP
        i_department_name := RPAD(i_depart.department_name,25);
        i_name_manager := RPAD(i_depart.name_manager,20);
        i_street_address := RPAD(i_depart.street_address,32);
        i_city := RPAD(i_depart.city,32);
        i_state_province := RPAD(i_depart.state_province,20);
        i_country_name := RPAD(i_depart.country_name,32);
        i_total_emp := RPAD(i_depart.total_emp,9);
        i_prom_salary := TO_CHAR(i_depart.prom_salary,'$999999999.99');
        IF i_postal_code = NULL THEN
            i_depart.postal_code :='v';
        END IF;
        i_postal_code := RPAD(i_depart.postal_code,20);
        DBMS_OUTPUT.PUT_LINE(
            i_department_name ||
            i_name_manager ||
            i_street_address ||
            i_postal_code ||
            i_city ||
            i_state_province ||
            i_country_name ||
            i_total_emp ||
            i_prom_salary
        );
    END LOOP;
END;
