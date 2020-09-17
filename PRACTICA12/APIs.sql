CREATE OR REPLACE PACKAGE xxeks_nomina_pkg
AS
    TYPE lista_type IS TABLE OF VARCHAR2(500);
    FUNCTION separate_words(p_word VARCHAR2, 
                            p_key VARCHAR2, 
                            x_err_msg OUT VARCHAR2, 
                            x_err_code OUT NUMBER) RETURN lista_type;
                            
    PROCEDURE crear_empleado(p_data_empl lista_type, p_err_code NUMBER, p_err_msg VARCHAR2);
END;

CREATE OR REPLACE PACKAGE BODY xxeks_nomina_pkg
AS
    FUNCTION separate_words(p_word VARCHAR2, 
                            p_key VARCHAR2, 
                            x_err_msg OUT VARCHAR2, 
                            x_err_code OUT NUMBER) 
                            RETURN lista_type IS
        i_tokens lista_type;
        i_pos NUMBER:=1;
        i_cont_key NUMBER:= LENGTH(p_word)-LENGTH(REPLACE(p_word,p_key));
    BEGIN
        i_tokens :=lista_type();
        i_tokens.extend;
        i_tokens(1):= SUBSTR(p_word,0,INSTR(p_word,p_key,1,1)-1);
        i_tokens.extend;

        FOR inc IN 1..i_cont_key-1 LOOP
            i_pos:=i_pos+1;
            i_tokens(i_pos):= SUBSTR(
                                    p_word,
                                    INSTR(p_word,p_key,1,inc)+1,
                                    INSTR(p_word,p_key,1,inc+1)-INSTR(p_word,p_key,1,inc)-1);
            i_tokens.extend;
        END LOOP;

        i_tokens(i_pos+1):=SUBSTR(p_word,INSTR(p_word,p_key,1,i_cont_key)+1,length(p_word)-INSTR(p_word,p_key,1,i_cont_key));
        x_err_msg := 'Sin errores';
        x_err_code := 1;
        RETURN i_tokens;
    EXCEPTION
        WHEN OTHERS THEN
            x_err_msg := 'Error al separar las palabras';
            x_err_code := -1;
            RETURN i_tokens;
    END;
    
    PROCEDURE crear_empleado(p_data_empl lista_type, p_err_code NUMBER, p_err_msg VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('holi');
        -- INSERT INTO xxeks_direccion() VALUES ();
        -- INSERT INTO xxeks_empleados() VALUES (); --como contacto
        -- INSERT INTO xxeks_empleados() VALUES (); --como empleado
    EXCEPTION 
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('');
    END;
END;