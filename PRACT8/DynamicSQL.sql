--CREATE OR REPLACE PROCEDURE demo(p_salary IN NUMBER) AS 
DECLARE
    cursor_name INTEGER;
    rows_processed INTEGER;
    sql_str VARCHAR2(255);
    col_cnt INTEGER;
    rec_tab DBMS_SQL.DESC_TAB;
    varvar varchar2(500);
    i_na varchar2(500);
BEGIN
    cursor_name := dbms_sql.open_cursor;
    sql_str := 'SELECT employees.first_name || '' '' ||employees.last_name as s, departments.department_name FROM employees, departments where departments.department_id = employees.department_id';
    DBMS_SQL.PARSE(cursor_name, sql_str,
                  DBMS_SQL.NATIVE);
    rows_processed := DBMS_SQL.EXECUTE(cursor_name);
    DBMS_OUTPUT.PUT_LINE('********exito******');
    DBMS_SQL.DESCRIBE_COLUMNS(cursor_name, col_cnt, rec_tab);
    --DBMS_OUTPUT.PUT_LINE(col_cnt);
    FOR i IN 1..col_cnt
    LOOP
        DBMS_SQL.DEFINE_COLUMN(cursor_name, i, varvar, 500);
    END LOOP;
    LOOP 
        IF DBMS_SQL.FETCH_ROWS(cursor_name)>0 THEN
            DBMS_SQL.COLUMN_VALUE(cursor_name, 1, i_na);
            DBMS_SQL.COLUMN_VALUE(cursor_name, 2, varvar); 
            DBMS_OUTPUT.PUT_LINE(rpad(varvar,20)||rpad(i_na,15));
        ELSE 
            EXIT; 
        END IF; 
    END LOOP; 
    DBMS_SQL.CLOSE_CURSOR(cursor_name);
    DBMS_OUTPUT.PUT_LINE('----');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_SQL.CLOSE_CURSOR(cursor_name);
        DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
END;

/*
SELECT e.first_name || e.last_name,
d.department_name
FROM employees e, departments d
where d.department_id = e.department_id*/