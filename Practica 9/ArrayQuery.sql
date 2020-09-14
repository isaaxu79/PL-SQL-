/*
crear un cursor donde hagamos una consultas de empleados y departamentos, nombre departamento, nombre empleado concatenado, salario, fecha contratacion
cargar en un arreglo, y lo vamos a insertar en una tabla customizada (nombre departamento, nombre empleado concatenado, salario, fecha contratacion)
(tip: se pueden realizar insert directos de arreglos a una tabla,)
se puede realizar insert de los registros uno por uno.
*/

DECLARE
    CURSOR c_emp_depto IS
        SELECT
            d.department_name depto,
            e.first_name || ' ' || e.last_name name,
            e.salary salario,
            e.hire_date fecha
        FROM
            employees e,
            departments d
        WHERE
            d.department_id = e.department_id;
    TYPE lista_type IS TABLE OF c_emp_depto%ROWTYPE;
    lista lista_type;
BEGIN
    OPEN c_emp_depto;
    LOOP
        FETCH c_emp_depto BULK COLLECT INTO lista;
        EXIT WHEN c_emp_depto%NOTFOUND;
    END LOOP;
    CLOSE c_emp_depto;
    
    FOR i IN lista.FIRST..lista.last LOOP
        INSERT INTO custom_employees(depto, full_name,salary,hire_date) VALUES(lista(i).depto,lista(i).name, lista(i).salario,lista(i).fecha);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
END;

CREATE TABLE custom_employees(
    id NUMBER PRIMARY KEY,
    depto VARCHAR(100),
    full_name VARCHAR(100),
    salary NUMBER(8,2),
    hire_date DATE
);

CREATE SEQUENCE sq_c_empl
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER tri_sq_c_emp
BEFORE INSERT ON custom_employees
FOR EACH ROW
BEGIN
SELECT sq_c_empl.NEXTVAL INTO :NEW.id from DUAL;
END;