CREATE TABLE foods (
    id NUMBER(10) PRIMARY KEY,
    food_name VARCHAR2(255) NOT NULL
);

CREATE SEQUENCE increm
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER tri_increm
BEFORE INSERT ON foods
FOR EACH ROW
BEGIN
SELECT increm.NEXTVAL INTO :NEW.id from DUAL;
END;

DECLARE
    out_File UTL_FILE.FILE_TYPE;
    conten VARCHAR2(1000);
    i_num NUMBER := 0;
BEGIN
    out_File := UTL_FILE.FOPEN ('XXEKS_TMP', 'test.txt', 'R');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(out_File,conten);
            --DBMS_OUTPUT.PUT_LINE(conten);
            INSERT INTO foods (food_name)
                values (conten);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN EXIT;
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
        END;
    END LOOP;
    UTL_FILE.FCLOSE(out_File);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
END;

select * from foods
