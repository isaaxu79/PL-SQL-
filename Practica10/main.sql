DECLARE
    i_tokens xxeks_upload_info_pkg.lista_type;
    i_rows xxeks_upload_info_pkg.lista_type;
    i_dir VARCHAR2(100):= :p_DIRECTORIO; --XXEKS_TMP
    i_dir_dest VARCHAR2(100):= :p_DIRECTORIO_PROCESADO;
    i_files VARCHAR2(100):= :p_ARCHIVOS;
    i_header BOOLEAN:= TRUE;
    i_table_name VARCHAR2(100):= :p_NOMBRE_TABLA;
    i_index NUMBER:=1;
    i_out_File UTL_FILE.FILE_TYPE;
    i_err_msg VARCHAR2(100);
    i_conten VARCHAR2(500);
    i_err_code NUMBER;--
    i_num_col NUMBER:= 0;
    i_cont NUMBER:= 0;
    i_indx NUMBER:= 0;
    i_num_col_static NUMBER:= 0;
    i_created_table BOOLEAN:=FALSE;
    i_nam xxeks_upload_info_pkg.lista_type;
    i_headers_fail xxeks_upload_info_pkg.lista_type;
    i_type xxeks_upload_info_pkg.lista_type;
    i_type_static xxeks_upload_info_pkg.lista_type;
BEGIN
    i_tokens := xxeks_upload_info_pkg.separate_words(i_files,
                                                    ',',
                                                    i_err_msg,
                                                    i_err_code);
    IF i_err_code > 0 THEN 
        FOR i IN 1..i_tokens.LAST LOOP
            i_header := TRUE;
            i_err_code := 0;
            i_num_col:=0;
            i_indx :=0;
            DBMS_OUTPUT.PUT_LINE('LEYENDO '||i_tokens(i)||'...');
            BEGIN
                i_out_File := UTL_FILE.FOPEN (i_dir, i_tokens(i), 'R');
                LOOP
                    BEGIN
                        UTL_FILE.GET_LINE(i_out_File,i_conten);
                        i_indx := i_indx+1;
                        IF NOT i_created_table THEN 
                            DBMS_OUTPUT.PUT_LINE('CREANDO TABLA...');
                            xxeks_upload_info_pkg.create_table(i_conten,
                                                                i_table_name,
                                                                i_err_msg,
                                                                i_err_code);
                            IF i_err_code = -1 THEN
                                i_created_table := FALSE;
                                DBMS_OUTPUT.PUT_LINE('ERROR EN ESTE ARCHIVO');
                                exit;
                            ELSIF i_err_code = -2 THEN
                                i_created_table := FALSE;
                                exit;
                                DBMS_OUTPUT.PUT_LINE('ERROR AL CREAR LA TABLA');
                            ELSE
                                DBMS_OUTPUT.PUT_LINE('reading headers');
                                i_created_table := TRUE;
                                i_nam := xxeks_upload_info_pkg.get_headers_or_type(i_conten,
                                                                                    i_num_col, 
                                                                                    1 ,
                                                                                    i_err_msg,
                                                                                    i_err_code);
                                
                                i_type := xxeks_upload_info_pkg.get_headers_or_type(i_conten,
                                                                                    i_num_col, 
                                                                                    2 ,
                                                                                    i_err_msg,
                                                                                    i_err_code);
                                i_num_col_static := i_num_col;
                                i_type_static := i_nam;
                                i_header := FALSE;
                            END IF;
                            
                        ELSIF i_header THEN
                            IF i_err_code >= 0 then
                                DBMS_OUTPUT.PUT_LINE('leyendo headers');
                                i_nam := xxeks_upload_info_pkg.get_headers_or_type(i_conten,
                                                                                    i_num_col, 
                                                                                    1 ,
                                                                                    i_err_msg,
                                                                                    i_err_code);
                                
                                i_type := xxeks_upload_info_pkg.get_headers_or_type(i_conten,
                                                                                    i_num_col, 
                                                                                    2 ,
                                                                                    i_err_msg,
                                                                                    i_err_code);
                                i_header :=false;
                            end if;
                        ELSE
                            IF i_err_code >= 0 then
                                xxeks_upload_info_pkg.insert_row(i_conten,
                                                                i_nam, 
                                                                i_table_name, 
                                                                i_tokens(i),
                                                                i_num_col,
                                                                i_err_msg,
                                                                i_err_code, 
                                                                i_indx, 
                                                                i_type);
                            end if;
                        END IF;
                        
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN 
                            UTL_FILE.FCLOSE(i_out_File);
                            EXIT;
                        WHEN OTHERS THEN 
                            DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                            'EN: ' || DBMS_UTILITY.format_error_backtrace);
                            UTL_FILE.FCLOSE(i_out_File);
                            EXIT;
                    END;
                    
                END LOOP;
                BEGIN
                    BEGIN
                        UTL_FILE.FRENAME (
                        src_location  => i_dir,
                        src_filename  => i_tokens(i),
                        dest_location => i_dir_dest,
                        dest_filename => i_tokens(i),
                        overwrite     => FALSE);
                        END;
                EXCEPTION
                    WHEN OTHERS THEN 
                        DBMS_OUTPUT.PUT_LINE('No se pudo mover el archivo, verifica tus permisos');
                END;
            EXCEPTION
                WHEN OTHERS THEN 
                    DBMS_OUTPUT.PUT_LINE('No existe ese archivo en ese directorio');
            END;
            
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE(i_err_msg);
    END IF;
    DBMS_OUTPUT.PUT_LINE(i_err_code || i_num_col);
    IF i_err_code >= 1 THEN
        BEGIN
            xxeks_upload_info_pkg.print_report('Reporte de registros cargados',
                                                i_type_static,
                                                i_num_col_static,
                                                i_table_name,
                                                i_err_msg,
                                                i_err_code);
        EXCEPTION
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('-HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
        END;
        
        BEGIN
            i_headers_fail := xxeks_upload_info_pkg.lista_type();
            i_headers_fail.extend;
            i_headers_fail(1):='Archivo';
            i_headers_fail.extend;
            i_headers_fail(2):='Fila';
            i_headers_fail.extend;
            i_headers_fail(3):='Descripcion';
            xxeks_upload_info_pkg.print_report('Reporte de registros fallidos',
                                                i_headers_fail,
                                                i_num_col_static,
                                                'xxeks_load_fail',
                                                i_err_msg,i_err_code);
        EXCEPTION
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('-HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
        END;
        
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE XXEKS_LOAD_FAIL';
            DBMS_OUTPUT.PUT_LINE('TABLA ELIMINADA');
        EXCEPTION
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('-HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
        END;
    END IF;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('-HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
END;

