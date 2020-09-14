DECLARE
    cursor c_empleados
    IS
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
        DBMS_OUTPUT.PUT_LINE('Hubo un error');
END;
