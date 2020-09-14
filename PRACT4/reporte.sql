--Select *  from employees;

DECLARE
    i_ejecut  VARCHAR2(100):= 'Ejecutado por: ' || :p_nombre;
    i_date VARCHAR2(100) := 'Fecha de ejecucion: ' || LOWER(TO_CHAR(sysdate,'DD-FMMON-YYYY HH24:MI:SS'));
    i_empresa VARCHAR2(100) := :p_empresa;
    i_departamento VARCHAR2(100):= :p_departamento;
    i_fecha DATE := TO_DATE(:p_fecha,'MM-YYYY');
    i_emp_depart  VARCHAR2(100);
    i_reg_depart VARCHAR2(100);
    i_emp_total NUMBER:=0;
    i_em_dep_c NUMBER := 0;
    i_mon NUMBER := 0;
    i_total_mont NUMBER := 0;
    CURSOR c_dep_reg IS 
        SELECT 
             d.department_name DEPARTAMENTO,
             l.street_address|| ' ' || l.postal_code || ' ' || l.city || ', ' || l.state_province || ', ' || c.country_name direccion,
             r.region_name Region
        FROM 
            departments d,
            locations l,
            countries c,
            regions r
        WHERE
            l.location_id = d.location_id and
            c.country_id  = l.country_id and 
            r.region_id = c.region_id AND 
            NVL(d.department_name,'X') = NVL(i_departamento,NVL(d.department_name,'X'));
    CURSOR c_empl_dep IS
        SELECT
            e.first_name || ' ' || e.last_name empleado,
            m.last_name || ', ' || e.first_name manager,
            e.salary salario,
            d.department_name departamento,
            r.region_name region
        FROM
            employees e,
            employees m,
            departments d,
            locations l,
            countries c,
            regions r
        WHERE
            m.employee_id = e.employee_id and
            d.department_id(+) = e.department_id and
            l.location_id = d.location_id AND
            c.country_id = l.country_id and
            r.region_id = c.region_id and
            TRUNC(e.hire_date , 'Month') <= i_fecha;
        
BEGIN
    DBMS_OUTPUT.PUT_LINE(i_ejecut || LPAD(i_date,60)|| CHR(10));
    DBMS_OUTPUT.put_line(LPAD('Reporte Detalle Empleados',50));
    FOR r_depart IN c_dep_reg LOOP
        i_em_dep_c := 0;
        i_mon := 0;
        i_emp_depart := CASE  r_depart.departamento
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
                            END;
                            --DECODE(r_depart.region,'Europe','Europa','Middle East and Africa','Medio Oriente Y Africa',r_depart.region)
        i_reg_depart := UPPER(
                                CASE r_depart.region 
                                    WHEN 'Europe' THEN 'Europa'
                                    WHEN 'Middle East and Africa' THEN 'Medio Oriente Y Africa'
                                    WHEN 'Americas' THEN 'America'
                                    ELSE r_depart.region
                                END
                            );
        DBMS_OUTPUT.PUT_LINE(RPAD('Departamento: ' ||i_emp_depart,60) || 'Region: ' || i_reg_depart);
        DBMS_OUTPUT.put_line(CHR(10) || 'Direccion: ' || r_depart.direccion);
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 
                            RPAD('Nombre Completo',25) ||
                            RPAD('Manager',25) ||
                            RPAD('Salario',15));
        FOR e_dep IN c_empl_dep LOOP
            IF r_depart.departamento = e_dep.departamento and r_depart.region = e_dep.region THEN 
                DBMS_OUTPUT.PUT_LINE(
                                    RPAD(e_dep.empleado,25) ||
                                    RPAD(e_dep.manager,25) ||
                                    RPAD('$'||TO_CHAR(e_dep.salario,'999,999.99'),15)
                                );
                i_emp_total := i_emp_total +1;
                i_em_dep_c := i_em_dep_c + 1;
                i_mon := i_mon + e_dep.salario;
            END IF;
        END LOOP;
        i_total_mont := i_total_mont + i_mon;
        DBMS_OUTPUT.PUT_LINE(RPAD(CHR(10) || 'Total empleado depto: ' || '_'|| i_em_dep_c ||'_' ,50)||
                            RPAD('Monto total:$ ' || TO_CHAR(i_mon,'999,999.99'),30));
        DBMS_OUTPUT.PUT_LINE(RPAD(' ',90,'-'));
    END LOOP;
    DBMS_OUTPUT.put_line(RPAD('Sumarizados',20));
    DBMS_OUTPUT.PUT_LINE('La empresa ' || i_empresa || ' tiene un total de ' || i_emp_total || ' empleado(s).');
    DBMS_OUTPUT.PUT_LINE('El total de salarios pagados a la fecha ' || TO_CHAR(i_fecha,'MM-YYYY') || ' es de :$ ' || TO_CHAR(i_total_mont,'999,999.99'));
END;

