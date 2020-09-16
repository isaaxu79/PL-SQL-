
DECLARE
    TYPE arreglo IS TABLE OF employees%ROWTYPE;
    l_emp arreglo := arreglo();
    CURSOR c_cursor IS
        SELECT * FROM employees;
    l_start  NUMBER;
BEGIN
    l_start := DBMS_UTILITY.get_time;
    FOR empl IN c_cursor LOOP
        l_emp.EXTEND;
        l_emp(l_emp.LAST):= empl;
    END LOOP;
    DBMS_OUTPUT.put_line('Regular (' || l_emp.count || ' rows): ' || 
                       (DBMS_UTILITY.get_time - l_start));
    l_start := DBMS_UTILITY.get_time;
    SELECT *
    BULK COLLECT INTO l_emp
    FROM   employees;
    DBMS_OUTPUT.put_line('Bulk    (' || l_emp.count || ' rows): ' || 
                       (DBMS_UTILITY.get_time - l_start));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('');
END;