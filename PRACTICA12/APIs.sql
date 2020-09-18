CREATE OR REPLACE PACKAGE xxeks_nomina_pkg
AS
    TYPE lista_type IS TABLE OF VARCHAR2(500);
    FUNCTION separate_words(p_word VARCHAR2, 
                            p_key VARCHAR2, 
                            x_err_msg OUT VARCHAR2, 
                            x_err_code OUT NUMBER) RETURN lista_type;
                            
    PROCEDURE crear_empleado(p_data_empl lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2);
    
    PROCEDURE asignar_manager(p_data lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2);
    
    PROCEDURE crear_asignacion(p_data lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2);
    
    PROCEDURE delete_data_empl(p_data lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2);
    
    PROCEDURE massive_upload_dirs;
    
    PROCEDURE massive_upload_ctlg;
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
        i_tokens(1):= LOWER(SUBSTR(p_word,0,INSTR(p_word,p_key,1,1)-1));
        i_tokens.extend;

        FOR inc IN 1..i_cont_key-1 LOOP
            i_pos:=i_pos+1;
            i_tokens(i_pos):= LOWER(SUBSTR(
                                    p_word,
                                    INSTR(p_word,p_key,1,inc)+1,
                                    INSTR(p_word,p_key,1,inc+1)-INSTR(p_word,p_key,1,inc)-1));
            i_tokens.extend;
        END LOOP;

        i_tokens(i_pos+1):=LOWER(SUBSTR(p_word,INSTR(p_word,p_key,1,i_cont_key)+1,length(p_word)-INSTR(p_word,p_key,1,i_cont_key)));
        x_err_msg := 'Sin errores';
        x_err_code := 1;
        RETURN i_tokens;
    EXCEPTION
        WHEN OTHERS THEN
            x_err_msg := 'Error al separar las palabras';
            x_err_code := -1;
            RETURN i_tokens;
    END;
    
    PROCEDURE crear_empleado(p_data_empl lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2) AS
        i_sql_ins_dir VARCHAR2(500):='INSERT INTO xxeks_direccion(calle,codigo_postal,n_interior,n_exterior,colonia,estado,pais) VALUES (';
        
        i_sql_ins_cont VARCHAR2(500):='INSERT INTO xxeks_empleados(nombre,apellido_p,apellido_m,'||
                                                                    'edad,sexo,telefono,salario,fecha_ingreso,'||
                                                                    'fecha_baja,tipo,contacto_id,manager_id,direccion_id) VALUES (';
        
        i_sql_ins_emp VARCHAR2(500):='INSERT INTO xxeks_empleados(nombre,apellido_p,apellido_m,'||
                                                                    'edad,sexo,telefono,salario,fecha_ingreso,'||
                                                                    'fecha_baja,tipo,contacto_id,manager_id,direccion_id) VALUES (';
        i_id_dir NUMBER;
        i_id_cont NUMBER;
    BEGIN
        p_err_code := -1;
        FOR idx IN 18..p_data_empl.LAST LOOP
            IF idx = p_data_empl.LAST THEN
                i_sql_ins_dir := i_sql_ins_dir || '''' || p_data_empl(idx) ||''')';
            ELSIF idx > 18 AND idx < 22  THEN
                i_sql_ins_dir := i_sql_ins_dir || p_data_empl(idx) || ', ';
            ELSE
                i_sql_ins_dir := i_sql_ins_dir || '''' || p_data_empl(idx) ||''', ';
            END IF;
        END LOOP;
        EXECUTE IMMEDIATE i_sql_ins_dir;
        i_id_dir := sq_xxeks_direccion.currval;
        
        p_err_code := -2;
        FOR idx IN 11..17 LOOP
            IF idx = 17 THEN
                i_sql_ins_cont := i_sql_ins_cont || 'NULL, NULL, NULL, ''' || p_data_empl(idx) ||''',NULL,NULL,NULL)';
            ELSIF idx = 14 THEN
                i_sql_ins_cont := i_sql_ins_cont || p_data_empl(idx) || ', ';
            ELSE
                i_sql_ins_cont := i_sql_ins_cont || '''' || p_data_empl(idx) ||''', ';
            END IF;
        END LOOP;
        EXECUTE IMMEDIATE i_sql_ins_cont;
        i_id_cont:= sq_xxeks_empleados.currval;
        
        p_err_code := -3;
        FOR idx IN 1..10 LOOP
            IF idx = 10 THEN
                i_sql_ins_emp := i_sql_ins_emp || '''' || p_data_empl(idx) ||''', '||i_id_cont || ', NULL, '  || i_id_dir ||')';
            ELSIF idx = 4 OR idx = 7 THEN
                i_sql_ins_emp := i_sql_ins_emp || p_data_empl(idx) || ', ';
            ELSE
                i_sql_ins_emp := i_sql_ins_emp || '''' || p_data_empl(idx) ||''', ';
            END IF;
        END LOOP;
        
        EXECUTE IMMEDIATE i_sql_ins_emp;
        commit;
        p_err_code:= 1;
        p_err_msg:= 'Sin errores, empleado creado';
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK;
            IF p_err_code = -1 THEN
                p_err_msg := 'Error al crear la direccion, deshaciendo cambios';
            ELSIF p_err_code = -2 THEN
                p_err_msg := 'Error al crear el contacto, deshaciendo cambios';
            ELSIF p_err_code = -3 THEN
                p_err_msg := 'Error al crear el empleado, deshaciendo cambios';
            END IF;
    END;

    PROCEDURE asignar_manager(p_data lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2) AS
        id_manager NUMBER;
        id_empleado NUMBER;
    BEGIN
        p_err_code :=-1;
        SELECT empleado_id INTO id_manager
        FROM  xxeks_empleados
        WHERE nombre = p_data(1) and apellido_p =p_data(2) and apellido_m=p_data(3) AND tipo='manager';
        p_err_code :=-2;
        SELECT empleado_id INTO id_empleado
        FROM  xxeks_empleados
        WHERE nombre = p_data(4) and apellido_p =p_data(5) and apellido_m=p_data(6);
        p_err_code :=-3;
        UPDATE xxeks_empleados
        SET manager_id= id_manager
        WHERE empleado_id=id_empleado;
        COMMIT;
        p_err_code :=0;
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK;
            IF p_err_code =-1 THEN
                p_err_msg:= 'error al encontrar al manager o hay mas de uno con el mismo nombre';
            ELSIF p_err_code =-2 THEN
                p_err_msg:= 'error al encontrar al empleado o hay mas de uno con el mismo nombre';
            ELSIF p_err_code =-3 THEN
                p_err_msg:= 'NO SE PUDO ACTUALIZAR AL EMPLEADO';
            END IF;
    END;

    PROCEDURE crear_asignacion(p_data lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2) AS
        i_id_empleado NUMBER;
    BEGIN
        p_err_code:=-1;
        SELECT empleado_id INTO i_id_empleado
            FROM xxeks_empleados
            WHERE nombre = p_data(4) and apellido_p=p_data(5) and apellido_m=p_data(6) and tipo <> 'contacto';
        p_err_code:=-2;
        UPDATE xxeks_asignaciones
            SET status = 0
            WHERE empleado_id = i_id_empleado;
        p_err_code:=-3;
        INSERT INTO xxeks_asignaciones(fecha_inicio,fecha_fin,descripcion,status,empleado_id) 
            VALUES (TO_DATE(p_data(1),'dd-mm-yy'), TO_DATE(p_data(2),'dd-mm-yy'),p_data(3),1,i_id_empleado);
        COMMIT;
        p_err_code:=1;
        p_err_msg:='Asignacion creada sin errores';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            IF p_err_code = -1 THEN
                p_err_msg:='error al buscar el empleado, deshaciendo cambios';
            ELSIF p_err_code = -2 THEN
                p_err_msg:='error al actualizar lo registros de asignacion, deshaciendo cambios';
            ELSIF p_err_code = -3 THEN
                p_err_msg:='error al guardar asignacion, deshaciendo cambios';
            END IF;
    END;

    PROCEDURE delete_data_empl(p_data lista_type, p_err_code OUT NUMBER, p_err_msg OUT VARCHAR2) AS
    i_id_emp NUMBER;
    i_id_dir NUMBER;
    i_id_cont NUMBER;
    BEGIN
        p_err_code := -1;
        SELECT empleado_id, direccion_id, contacto_id
        INTO i_id_emp, i_id_dir, i_id_cont
        FROM xxeks_empleados
        WHERE nombre = p_data(1) AND apellido_p = p_data(2) AND apellido_m = p_data(3);
        p_err_code := -2;
        DELETE FROM xxeks_empleados WHERE empleado_id = i_id_emp;
        p_err_code := -3;
        DELETE FROM xxeks_empleados WHERE empleado_id = i_id_cont;
        p_err_code := -4;
        DELETE FROM xxeks_direccion WHERE direccion_id = i_id_dir;
        COMMIT;
        p_err_code := 1;
        p_err_msg :='empleado eliminado sin problemas';
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK;
            IF p_err_code = -1 THEN
                p_err_msg:='error al buscar el empleado, deshaciendo cambios';
            ELSIF p_err_code = -2 THEN
                p_err_msg:='error al eliminar el empleado, deshaciendo cambios';
            ELSIF p_err_code = -3 THEN
                p_err_msg:='error al eliminar el contacto, deshaciendo cambios';
            ELSIF p_err_code = -4 THEN
                p_err_msg:='error al eliminar la direccion, deshaciendo cambios';
            END IF;
    END;
    
    PROCEDURE massive_upload_dirs AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('');
    END;
    
    PROCEDURE massive_upload_ctlg AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('');
    END;
END;