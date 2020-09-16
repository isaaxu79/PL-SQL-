/*1.- Probar el funcionamientos de las tablas temporales, */

CREATE GLOBAL TEMPORARY TABLE temp_listado 
(
nombre VARCHAR2(40),
inicio DATE,
termino DATE
)
ON COMMIT PRESERVE ROWS;

DECLARE
BEGIN
    FOR x IN 1..10 LOOP
        INSERT INTO temp_listado(nombre,inicio, termino) VALUES ('Pedro','17-01-10','28-10-10');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('S');
END;

SELECT * FROM temp_listado;