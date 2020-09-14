--CREATE OR REPLACE FUNCTION separate_words(p_key VARCHAR2, p_word VARCHAR2, p_code OUT NUMBER, p_message OUT VARCHAR2)RETURN VARRAY is
DECLARE
    p_word VARCHAR2(100):='hola|adios||estas|mi|taco|esta|feliz|de|';
    p_key VARCHAR2(100):='|';
    i_pos NUMBER:=1;
    i_cont_key NUMBER:= LENGTH(p_word)-LENGTH(REPLACE(p_word,p_key));
    TYPE lista_type IS TABLE OF VARCHAR2(255); 
    tokens lista_type;
BEGIN
    tokens :=lista_type();
    tokens.extend;
    tokens(1):= SUBSTR(p_word,0,INSTR(p_word,p_key,1,1)-1);
    tokens.extend;
    --DBMS_OUTPUT.PUT_LINE(tokens(1));
    FOR inc IN 1..i_cont_key-1 LOOP
        i_pos:=i_pos+1;
        tokens(i_pos):= SUBSTR(p_word,INSTR(p_word,p_key,1,inc)+1,INSTR(p_word,p_key,1,inc+1)-INSTR(p_word,p_key,1,inc)-1);
        tokens.extend;
    END LOOP;
    
    tokens(i_pos+1):=SUBSTR(p_word,INSTR(p_word,p_key,1,i_cont_key)+1,length(p_word)-INSTR(p_word,p_key,1,i_cont_key));
    /*FOR xc IN 1..tokens.last LOOP
        if tokens(xc) is NULL then
            DBMS_OUTPUT.PUT_LINE('--vacio--');
        else
            DBMS_OUTPUT.PUT_LINE('--'||tokens(xc) || '--');
        end if;
    END LOOP;*/
END;

