/*
** Programa principal
*/
DECLARE
    out_File UTL_FILE.FILE_TYPE;
    conten VARCHAR2(1000);
    i_num NUMBER := 0;
    i_header BOOLEAN:=TRUE;
BEGIN
    out_File := UTL_FILE.FOPEN ('XXEKS_TMP', 'ClimaTux.csv', 'R');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(out_File,conten);
            IF i_header THEN
                i_header := FALSE;
            ELSE
                p_insert_row(conten);
            END IF;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                UTL_FILE.FCLOSE(out_File);
                EXIT;
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
        END;
    END LOOP;
    UTL_FILE.FCLOSE(out_File);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
END;

/*
** Subproceso para insercion de datos
*/

CREATE OR REPLACE PROCEDURE p_insert_row (p_content VARCHAR2) IS
        i_date DATE;
        i_temp_max NUMBER;
        i_temp_min NUMBER;
        i_temp_prom NUMBER;
    BEGIN
         i_date := to_date(substr(p_content,0,instr(p_content,',',1,1)-1), 'DD-MM-YYYY');
         i_temp_max := TO_NUMBER(
                                    substr(p_content,instr(p_content,',',1,1)+1,instr(p_content,',',1,2)-instr(p_content,',',1,1)-1),
                                    '999.99'  
                                );
        i_temp_min := TO_NUMBER(
                                    substr(p_content,instr(p_content,',',1,2)+1,instr(p_content,',',1,3)-instr(p_content,',',1,2)-1),
                                    '999.99'  
                                );
        i_temp_prom := TO_NUMBER(
                                    substr(p_content,instr(p_content,',',1,3)+1,length(p_content)-instr(p_content,',',1,3)),
                                    '999.99'  
                                );
        INSERT INTO weather (fecha,temp_min,temp_max,temp_prom)VALUES (
                                        i_date,
                                        i_temp_min,
                                        i_temp_max,
                                        i_temp_prom
                                    );
    EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
    END;
    

/*
** Definicion de la tabla
*/

CREATE TABLE weather(
    id NUMBER PRIMARY KEY,
    fecha DATE,
    temp_min NUMBER,
    temp_max NUMBER,
    temp_prom NUMBER
);

CREATE SEQUENCE a_increm
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER tri_a_increm
BEFORE INSERT ON weather
FOR EACH ROW
BEGIN
SELECT increm.NEXTVAL INTO :NEW.id from DUAL;
END;
