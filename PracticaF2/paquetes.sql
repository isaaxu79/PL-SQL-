CREATE OR REPLACE PACKAGE xxeks_upload_info_pkg
AS
    TYPE lista_type IS TABLE OF VARCHAR2(500);
    FUNCTION separate_words(p_word VARCHAR2, 
                            p_key VARCHAR2, 
                            x_err_msg OUT VARCHAR2, 
                            x_err_code OUT NUMBER) RETURN lista_type;
                            
    PROCEDURE create_table(p_instrn VARCHAR2, 
                            p_table_name VARCHAR2, 
                            x_err_msg OUT VARCHAR2, 
                            x_err_code OUT NUMBER);
                            
    FUNCTION get_headers_or_type(p_instrn VARCHAR2, 
                                p_ncols OUT NUMBER, 
                                p_vars NUMBER, 
                                x_err_msg OUT VARCHAR2, 
                                x_err_code OUT NUMBER) RETURN lista_type;
                                
    PROCEDURE insert_row(p_word VARCHAR2, 
                        p_headers lista_type, 
                        p_tab_name VARCHAR2, 
                        p_file VARCHAR2, 
                        p_cols NUMBER, 
                        x_err_msg OUT VARCHAR2, 
                        x_err_code OUT NUMBER, 
                        p_idx_col NUMBER,
                        p_types_data lista_type);

    PROCEDURE print_report(p_title VARCHAR2,
                                p_heads lista_type,
                                p_num_col NUMBER,
                                p_name_table VARCHAR2, 
                                x_err_msg OUT VARCHAR2, 
                                x_err_code OUT NUMBER);
END;

CREATE OR REPLACE PACKAGE BODY xxeks_upload_info_pkg AS
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
    
    PROCEDURE create_table(p_instrn VARCHAR2, 
                            p_table_name VARCHAR2, 
                            x_err_msg OUT VARCHAR2, 
                            x_err_code OUT NUMBER) 
    IS
        i_headers_with_type lista_type;
        i_temp_h lista_type;
        cursor_name INTEGER;
        i_sql_query VARCHAR2(500):='CREATE TABLE ' || p_table_name || '(';
    BEGIN
        i_headers_with_type := separate_words(p_instrn,'|',x_err_msg,x_err_code);
        IF x_err_code > 0 then
            FOR i IN 1..i_headers_with_type.LAST LOOP
                i_temp_h := separate_words(i_headers_with_type(i),'/',x_err_msg,x_err_code);
                IF x_err_code > 0 AND i_temp_h.LAST = 2 THEN
                    IF i = i_headers_with_type.LAST THEN
                        i_sql_query := i_sql_query || i_temp_h(1)||' '|| i_temp_h(2) || ' NOT NULL)';
                    ELSE
                        i_sql_query := i_sql_query || i_temp_h(1)||' '|| i_temp_h(2) || ' NOT NULL, ';
                    END IF;
                    x_err_code :=1;
                ELSE
                    x_err_msg := 'Error Al Crear la tabla';
                    x_err_code := -1;
                    EXIT;
                END IF;
            END LOOP;
            IF x_err_code > 0 THEN
                DBMS_OUTPUT.PUT_LINE(i_sql_query);
                EXECUTE IMMEDIATE i_sql_query;
                /*cursor_name := dbms_sql.open_cursor;
                DBMS_SQL.PARSE(cursor_name, i_sql_query,
                              DBMS_SQL.NATIVE);
                DBMS_SQL.EXECUTE(cursor_name);
                DBMS_SQL.CLOSE_CURSOR(cursor_name);*/
                EXECUTE IMMEDIATE 'CREATE TABLE xxeks_load_fail(file_name VARCHAR2(200), n_row NUMBER, description VARCHAR2(200))';
                DBMS_OUTPUT.PUT_LINE('TABLA CREADA');
            END IF;
        else
            x_err_msg := 'Error Al Crear la tabla';
            x_err_code := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            x_err_code := 3;
            DBMS_SQL.CLOSE_CURSOR(cursor_name);
            DBMS_OUTPUT.PUT_LINE('tabla existente' );
            x_err_msg := 'Error Al Crear la tabla';
    END;
    
    FUNCTION get_headers_or_type(p_instrn VARCHAR2, 
                                p_ncols OUT NUMBER, 
                                p_vars NUMBER, 
                                x_err_msg OUT VARCHAR2, 
                                x_err_code OUT NUMBER) RETURN lista_type
    IS
        i_head lista_type;
        i_hs lista_type;
        i_heads lista_type;
        i_null BOOLEAN:=FALSE;
    BEGIN
        i_heads := lista_type();
        p_ncols :=0; 
        i_head := separate_words(p_instrn,'|',x_err_msg, x_err_code);
        IF x_err_code >= 0 then
            FOR i IN 1..i_head.LAST LOOP
                IF x_err_code >= 0 then
                    i_hs := separate_words(i_head(i),'/',x_err_msg, x_err_code);
                    i_heads.extend;
                    i_heads(i):= i_hs(p_vars);
                    p_ncols := p_ncols +1;
                END IF;
            END LOOP;
        END IF;
        IF x_err_code < 0 then
            DBMS_OUTPUT.PUT_LINE('error');
            x_err_code :=-1;
            p_ncols := 0;
            i_heads.extend;
            i_heads(1):='sin';
            RETURN i_heads;
        ELSE
            RETURN i_heads;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('error');
    END;
    
    PROCEDURE insert_row(p_word VARCHAR2, 
                        p_headers lista_type, 
                        p_tab_name VARCHAR2,
                        p_file VARCHAR2,
                        p_cols NUMBER, 
                        x_err_msg OUT VARCHAR2, 
                        x_err_code OUT NUMBER,
                        p_idx_col NUMBER,
                        p_types_data lista_type)
    IS
        i_vals lista_type;
        i_missing lista_type;
        i_values VARCHAR2(500):='(';
        i_err_value VARCHAR2(500):='';
        i_mis BOOLEAN := FALSE;
        i_sql_query VARCHAR2(500):='INSERT INTO ';
        i_head VARCHAR2(500):='(';
        i_cont NUMBER := 1;
        i_query_err VARCHAR2(500):='(';
        curso INTEGER;
        rows_processed INTEGER;
    BEGIN
        i_missing := lista_type();
        i_vals := separate_words(p_word,'|',x_err_msg,x_err_code);
        IF x_err_code > 0 THEN
            FOR i IN 1..i_vals.LAST LOOP
                IF i_vals(i) IS NOT NULL THEN
                    IF i = i_vals.LAST THEN
                        
                        IF p_types_data(i) = 'NUMBER' THEN
                            i_values  := i_values || i_vals(i) || ')';
                        ELSE
                            i_values  := i_values || '''' || i_vals(i) || ''')';
                        END IF;
                    ELSE
                        IF p_types_data(i) = 'NUMBER' THEN
                            i_values  := i_values || i_vals(i) || ',';
                        ELSE
                            i_values  := i_values || '''' || i_vals(i) || ''',';
                        END IF;
                    END IF;
                ELSE
                    i_missing.extend;
                    i_missing(i_cont):= p_headers(i);
                    i_mis := TRUE;
                    i_cont := i_cont+1;
                END IF;
            END LOOP;
            IF i_mis THEN
                FOR x IN 1..i_missing.LAST LOOP
                    i_err_value := i_err_value || '|' || i_missing(x);
                END LOOP;
                i_query_err:= i_query_err || '''' || p_file || ''', ' || p_idx_col || ', ''' || i_err_value || ''')';
                i_sql_query:= i_sql_query || 'xxeks_load_fail (file_name,n_row,description) VALUES' || i_query_err;
                DBMS_OUTPUT.PUT_LINE(i_sql_query);
                EXECUTE IMMEDIATE i_sql_query;  
            ELSE
                FOR ix IN 1..p_headers.LAST LOOP
                    IF ix = p_headers.LAST THEN
                        i_head := i_head || p_headers(ix) || ')';
                    ELSE
                        i_head := i_head || p_headers(ix) || ', ';
                    END IF;
                END LOOP;
                i_sql_query := i_sql_query || p_tab_name || ' ' || i_head ||' VALUES ' || i_values;
                DBMS_OUTPUT.PUT_LINE(i_sql_query);
                
                EXECUTE IMMEDIATE i_sql_query;
                
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS 
            THEN DBMS_OUTPUT.PUT_LINE('ERROR');
                --DBMS_SQL.CLOSE_CURSOR(curso);
                x_err_code := -1;
                x_err_msg := 'error al insertar los datos';
    END;
    
    PROCEDURE print_report(p_title VARCHAR2,
                                p_heads lista_type,
                                p_num_col NUMBER, 
                                p_name_table VARCHAR2, 
                                x_err_msg OUT VARCHAR2, 
                                x_err_code OUT NUMBER)
    IS
        cursor_name INTEGER;
        rows_processed INTEGER;
        sql_str VARCHAR2(255);
        col_cnt INTEGER;
        rec_tab DBMS_SQL.DESC_TAB;
        varvar varchar2(500);
        i_headers varchar2(500):='';
        i_na varchar2(500):='';
        i_cont_rows NUMBER:=0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(LPAD(RPAD(p_title,60,'*'),100,'*'));
        DBMS_OUTPUT.PUT_LINE('Tabla: '||p_name_table);
        FOR xc IN 1..p_heads.LAST LOOP
            i_headers := i_headers || rpad(p_heads(xc),20);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(i_headers);
        cursor_name := dbms_sql.open_cursor;
        sql_str := 'SELECT * FROM ' || p_name_table;
        DBMS_SQL.PARSE(cursor_name, sql_str,
                      DBMS_SQL.NATIVE);
        rows_processed := DBMS_SQL.EXECUTE(cursor_name);
        DBMS_SQL.DESCRIBE_COLUMNS(cursor_name, col_cnt, rec_tab);
        
        FOR i IN 1..col_cnt
        LOOP
            DBMS_SQL.DEFINE_COLUMN(cursor_name, i, varvar, 500);
        END LOOP;
        LOOP 
            IF DBMS_SQL.FETCH_ROWS(cursor_name)>0 THEN
                FOR i IN 1..p_num_col LOOP
                    DBMS_SQL.COLUMN_VALUE(cursor_name, i, varvar);
                    i_na := i_na || rpad(varvar,20);
                END LOOP;
                DBMS_OUTPUT.put_line(i_na);
                i_cont_rows := i_cont_rows + 1;
                i_na := '';
            ELSE 
                EXIT; 
            END IF; 
        END LOOP; 
        DBMS_SQL.CLOSE_CURSOR(cursor_name);
        DBMS_OUTPUT.PUT_LINE(CHR(10)||'Total de registros cargados exitosamente: ' || i_cont_rows);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('ERROR AL MOSTRAR LOS DATOS' || SQLERRM);
            DBMS_SQL.CLOSE_CURSOR(cursor_name);
    END;
END;