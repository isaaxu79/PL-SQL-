CREATE VIEW v_manager 
AS SELECT
            emple.first_name || ' ' ||emple.last_name as full_name,
            m.hire_date,
            m.first_name || ' ' ||  m.last_name as manager,
            m.job_id as manager_job,
            emple.job_id as employee_job
        FROM
            employees emple
        INNER JOIN employees m ON m.employee_id = emple.manager_id;

CREATE VIEW v_manager_job AS SELECT  
    v_manager.full_name,
    v_manager.manager,
    v_manager.hire_date,
    v_manager.employee_job,
    job_title as manager_job
FROM jobs
INNER JOIN v_manager ON v_manager.manager_job = job_id;


DECLARE
    CURSOR c_empleados IS
        SELECT 
            v_manager_job.full_name,
            job_title as employee_job,
            v_manager_job.hire_date,
            v_manager_job.manager,
            v_manager_job.manager_job
        FROM jobs
        INNER JOIN v_manager_job ON v_manager_job.employee_job = job_id
        ORDER BY v_manager_job.hire_date;
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
    FOR i_empl in c_empleados
    LOOP
        i_full_name:= RPAD(i_empl.full_name,20);
        i_emp_job:=RPAD(i_empl.employee_job,32);
        i_hire_date :=RPAD(i_empl.hire_date,15);
        i_manager:=RPAD(i_empl.manager,20);
        i_manager_job:=RPAD(i_empl.manager_job,32);
        DBMS_OUTPUT.PUT_LINE(
            i_full_name ||
            i_emp_job ||
            i_hire_date ||
            i_manager ||
            i_manager_job
        );
    END LOOP;
END;