/*2.- realizar 2 scripts utilizando en ambos tablas externas, en uno 
haremos un select a la tabla temporal y la insertaremos a otra tabla fisica, 
el segundo utilizara bulk collec*/
CREATE TABLE tabla_externa (
  ID             NUMBER,
  FECHA          VARCHAR2(50),
  TEM_MIN        VARCHAR2(50),
  TEM_MAX        VARCHAR2(50),
  TEM_PROM       VARCHAR2(50)
)
ORGANIZATION EXTERNAL (
  TYPE oracle_loader 
  DEFAULT directory XXEKS_TMP
  access parameters
( records delimited BY newline
  skip 1
  badfile 'tabla_externa.bad'
  logfile 'tabla_externa.log'
  fields terminated BY ','
  missing field VALUES are NULL
)
location ('ClimaTux.csv')
);
DROP TABLE migration_data;DROP TABLE tabla_externa;
CREATE TABLE migration_data (
  ID             NUMBER,
  FECHA          VARCHAR2(50),
  TEM_MIN        VARCHAR2(50),
  TEM_MAX        VARCHAR2(50),
  TEM_PROM       VARCHAR2(50)
)

DECLARE
    TYPE arreglo IS TABLE OF tabla_externa%ROWTYPE;
    l_emp arreglo := arreglo();
    CURSOR c_cursor IS
        SELECT * FROM tabla_externa;
    l_start  NUMBER;
BEGIN
    /*
    ** RECORRIDO Y LLENADO CON FOR LOOP
    */
    l_start := DBMS_UTILITY.get_time;
    FOR empl IN c_cursor LOOP
        l_emp.EXTEND;
        l_emp(l_emp.LAST):= empl;
    END LOOP;
    FOR i IN 1..l_emp.LAST
    LOOP
        INSERT INTO migration_data VALUES l_emp(i);
    END LOOP;
    DBMS_OUTPUT.put_line('Regular (' || l_emp.count || ' rows): ' || 
                       (DBMS_UTILITY.get_time - l_start));
                       
    /*
    ** RECORRIDO Y LLENADO CON BULK
    */
    l_start := DBMS_UTILITY.get_time;
    SELECT *
    BULK COLLECT INTO l_emp
    FROM   tabla_externa;
    FORALL i IN 1..l_emp.LAST
        INSERT INTO migration_data VALUES l_emp(i);
    DBMS_OUTPUT.put_line('Bulk    (' || l_emp.count || ' rows): ' || 
                       (DBMS_UTILITY.get_time - l_start));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
END;
