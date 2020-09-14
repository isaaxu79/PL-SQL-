CREATE OR REPLACE PACKAGE xxeks_reportes_pkg
AS
    PROCEDURE p_report_employees(o_error_message OUT VARCHAR2,o_error_code OUT NUMBER);
    PROCEDURE p_report_department(o_error_message OUT VARCHAR2,o_error_code OUT NUMBER);
    PROCEDURE p_report_emplo_manager(o_error_message OUT VARCHAR2,o_error_code OUT NUMBER);
    PROCEDURE p_report_emplo_depto(p_country VARCHAR2, p_date VARCHAR2, o_error_message OUT VARCHAR2,o_error_code OUT NUMBER);
    PROCEDURE p_report_region_depto(o_error_message OUT VARCHAR2,o_error_code OUT NUMBER);
    PROCEDURE p_report_employees_detailed(p_nombre VARCHAR2, p_empresa VARCHAR2, p_departamento VARCHAR2, p_fecha VARCHAR2,o_error_message OUT VARCHAR2,o_error_code OUT NUMBER);
END;

CREATE OR REPLACE PACKAGE BODY xxeks_reportes_pkg 
AS  
    PROCEDURE p_report_employees(o_error_message OUT VARCHAR2,o_error_code OUT NUMBER) IS
        cursor c_empleados IS
            SELECT *
            FROM employees;
        i_name VARCHAR2(100);
        i_last_name VARCHAR2(100);
        i_email VARCHAR2(100);
        i_phone VARCHAR2(100);
        i_hire_date VARCHAR2(100);
        i_date VARCHAR2(100);
        i_salary VARCHAR2(100);
    BEGIN
        /*
        ** Impresion de encabezados
        */
        DBMS_OUTPUT.PUT_LINE(
            RPAD('NOMBRE',15) ||
            RPAD('APELLIDO',15) ||
            RPAD('CORREO',15) ||   
            RPAD('NUMERO',15) ||
            RPAD('FECHA',10) || 
            RPAD('SALARIO',12)
        );
        
         FOR r_empleados IN c_empleados
         LOOP
            i_name := RPAD(r_empleados.first_name,15);
            i_last_name := RPAD(r_empleados.last_name,15);
            i_email := RPAD(r_empleados.email,15);
            i_phone := RPAD(r_empleados.phone_number,15);
            i_phone := REPLACE(i_phone,'.','-');
            i_hire_date := TO_CHAR(r_empleados.hire_date,'DD-MM-YYYY');
            i_date := RPAD(i_hire_date,10);
            i_salary := TO_CHAR(r_empleados.salary,'$999999999.99');
            DBMS_OUTPUT.PUT_LINE(
                i_name ||
                i_last_name ||
                i_email ||
                i_phone ||
                i_date ||
                i_salary
                );
         END LOOP;
    EXCEPTION
        WHEN OTHERS THEN 
            o_error_message :='MURIO EN LA PARTE FINAL';           
            DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE);
    END;
    
    PROCEDURE p_report_department IS
        CURSOR c_departments IS
            SELECT 
                d.department_name departamento,
                m.first_name || ' ' || m.last_name as name_manager,
                l.street_address calle,
                DECODE(l.postal_code,NULL,'Sin codigo', l.postal_code) cp,
                l.city ciudad,
                DECODE(l.state_province,NULL,'Sin Estado',l.state_province) estado,
                c.country_name pais,
                count(e.first_name) total_emp,
                round(avg(e.salary),2) prom_sal
            FROM 
                departments d,
                employees m,
                locations l,
                countries c,
                employees e
            WHERE
                m.employee_id = d.manager_id AND
                l.location_id = d.location_id AND
                c.country_id = l.country_id AND
                e.department_id = d.department_id
            GROUP BY 
                d.department_name,
                m.first_name || ' ' || m.last_name,
                l.street_address,
                DECODE(l.postal_code,NULL,'Sin codigo', l.postal_code),
                l.city,
                DECODE(l.state_province,NULL,'Sin Estado',l.state_province),
                c.country_name
            ORDER BY d.department_name, 2;
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
        FOR i_depart IN c_departments
        LOOP
            i_department_name := RPAD(i_depart.departamento,25);
            i_name_manager := RPAD(i_depart.name_manager,20);
            i_street_address := RPAD(i_depart.calle,32);
            i_city := RPAD(i_depart.ciudad,32);
            i_state_province := RPAD(i_depart.estado,20);
            i_country_name := RPAD(i_depart.pais,32);
            i_total_emp := RPAD(i_depart.total_emp,9);
            i_prom_salary := TO_CHAR(i_depart.prom_sal,'$999999999.99');
            i_postal_code := RPAD(i_depart.cp,20);
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
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE);
    END;
    
    PROCEDURE p_report_emplo_manager IS
        CURSOR c_emplo_manag IS
            SELECT
                e.first_name || ' ' ||e.last_name nombre,
                e.hire_date fecha,
                j_e.job_title empleo_emp,
                m.first_name || ' ' ||  m.last_name manager,
                j_m.job_title empleo_man
            FROM 
                employees e,
                employees m,
                jobs j_e,
                jobs j_m
            WHERE
                m.employee_id = e.manager_id AND
                j_m.job_id = m.job_id AND
                j_e.job_id = e.job_id;
        
        i_full_name VARCHAR2(100);
        i_emp_job VARCHAR2(100);
        i_hire_date VARCHAR2(100);
        i_manager VARCHAR2(100);
        i_manager_job VARCHAR2(100);
    BEGIN
        /*
        ** Impresion de encabezados
        */
        DBMS_OUTPUT.PUT_LINE(
            RPAD('NOMBRE',20) ||
            RPAD('PUESTO',32) ||   
            RPAD('FECHA INGRESO',15) ||
            RPAD('MANAGER',20) || 
            RPAD('PUESTO MANAGER',32)
        );
        FOR i_empl in c_emplo_manag
        LOOP
            i_full_name:= RPAD(i_empl.nombre,20);
            i_emp_job:=RPAD(i_empl.empleo_emp,32);
            i_hire_date :=RPAD(i_empl.fecha,15);
            i_manager:=RPAD(i_empl.manager,20);
            i_manager_job:=RPAD(i_empl.empleo_man,32);
            DBMS_OUTPUT.PUT_LINE(
                i_full_name ||
                i_emp_job ||
                i_hire_date ||
                i_manager ||
                i_manager_job
            );
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE);
    END;
    
    PROCEDURE p_report_emplo_depto(p_country VARCHAR2, p_date VARCHAR2) IS
        CURSOR c_emplo_dep IS
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
                r.region_name = DECODE(TO_CHAR(p_country),'EUR','Europe','AME','Americas','ASI','Asia','MEA','Middle East and Africa') AND
                TO_DATE(e.hire_date,'YY-MM-DD') < TO_DATE(p_date,'yy-mm-dd')
            order by e.hire_date;
        
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('NOMBRE',20) ||
            RPAD('CORREO',32) ||   
            RPAD('FECHA INGRESO',15) ||
            RPAD('SALARIO',15) || 
            RPAD('COMISION',32)||
            RPAD('DEPARTAMENTO',20) || 
            RPAD('PAIS',25) || 
            RPAD('REGION',32)
        );
        FOR i_emp IN c_emplo_dep LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(i_emp.nombre,20) ||
                RPAD(i_emp.correo,32) ||   
                RPAD(i_emp.fecha_contrato,15) ||
                RPAD(i_emp.salario,15) || 
                RPAD(i_emp.comision,32)||
                RPAD(i_emp.departamento,20) || 
                RPAD(i_emp.pais,25) || 
                RPAD(i_emp.region,32)
            );
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
    END;
    
    PROCEDURE p_report_region_depto IS
        CURSOR c_region_depto IS
            SELECT
                DECODE(r.region_name,'Europe','Europa','Middle East and Africa','Medio Oriente Y Africa',r.region_name) Region,
                DECODE(c.country_id,'MX','Mexico','US','Estados Unidos','Extranjero') Pais,
                d.department_name departamento,
                TO_CHAR(e.hire_date,'MM-YYYY') Fecha,
                sum(e.salary) SALARIO
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
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('REGION',20) ||
            RPAD('PAIS',25) ||   
            RPAD('DEPARTAMENTO',32) ||
            RPAD('FECHA',15) || 
            RPAD('SALARIO',15)
        );
        FOR i_reg_dept IN c_region_depto LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(i_reg_dept.region,20) ||
                RPAD(i_reg_dept.pais,25) ||   
                RPAD(i_reg_dept.departamento,32) ||
                RPAD(i_reg_dept.fecha,15) || 
                RPAD(TO_CHAR(i_reg_dept.salario,'L99G999D9999MI','NLS_NUMERIC_CHARACTERS = '',.''NLS_CURRENCY = ''$'' '),15)
            );    
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
    END;

    PROCEDURE p_report_employees_detailed(p_nombre VARCHAR2, p_empresa VARCHAR2, p_departamento VARCHAR2, p_fecha VARCHAR2) IS
        i_ejecut  VARCHAR2(100):= 'Ejecutado por: ' || p_nombre;
        i_date VARCHAR2(100) := 'Fecha de ejecucion: ' || LOWER(TO_CHAR(sysdate,'DD-FMMON-YYYY HH24:MI:SS'));
        i_fecha DATE := TO_DATE(p_fecha,'MM-YYYY');
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
                NVL(d.department_name,'X') = NVL(p_departamento,NVL(d.department_name,'X'));
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
        DBMS_OUTPUT.PUT_LINE('La empresa ' || p_empresa || ' tiene un total de ' || i_emp_total || ' empleado(s).');
        DBMS_OUTPUT.PUT_LINE('El total de salarios pagados a la fecha ' || TO_CHAR(i_fecha,'MM-YYYY') || ' es de :$ ' || TO_CHAR(i_total_mont,'999,999.99'));
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
    END;
END;