/*
** INSERT FULL DATA EMPLEADO
** ¿Como insertar? nombre,apellido_materno,apellido_paterno,edadd,sexo,telefono,salario,fecha_ingreso,fecha_baja,tipo,...10---1:10
** ...nombre,apellido_materno,apellido_paterno,edadd,sexo,telefono,tipo,...7 11:17
** ...calle,codigo_postal,n_interior,n_exterior,colonia,estado,pais 7----18:24
*/
DECLARE
    asd xxeks_nomina_pkg.lista_type;
    i_data VARCHAR(500):= :p_params;
    i_err_code NUMBER:=1;
    i_err_msg VARCHAR2(100):='';
BEGIN
    DBMS_OUTPUT.PUT_LINE(user);
    asd := xxeks_nomina_pkg.separate_words(i_data,',',i_err_msg,i_err_code);
    IF i_err_code > 0 AND asd.LAST = 24 THEN
        xxeks_nomina_pkg.crear_empleado(asd,i_err_code,i_err_msg);
    ELSIF asd.LAST <> 24 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR AL INGRESAR LOS DATOS, VERICA QUE LA INFORMACION ESTE COMPLETA');
    ELSE
        DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UN EXCEPCION, DETALLES: ' || i_err_msg);
    END IF;
    DBMS_OUTPUT.PUT_LINE(i_err_msg);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA ERROR INTERNO POR FAVOR CONTACTA AL ADMIN');
END;


/*
** Asignacion de Manager
** Como insertar? Nombre_manager,apellido_paterno_manager, apellido_materno_manager,nombre empleado,apellidopaterno_empleado, apellido materno empleado
*/

DECLARE
    asd xxeks_nomina_pkg.lista_type;
    i_data VARCHAR(500):= :p_params;
    i_err_code NUMBER:=1;
    i_err_msg VARCHAR2(100):='';
BEGIN
    asd := xxeks_nomina_pkg.separate_words(i_data,',',i_err_msg,i_err_code);
    IF i_err_code > 0 AND asd.LAST = 6 THEN
        xxeks_nomina_pkg.asignar_manager(asd,i_err_code,i_err_msg);
        IF i_err_code > 0 THEN
            DBMS_OUTPUT.PUT_LINE(i_err_msg); 
        ELSE
            DBMS_OUTPUT.PUT_LINE(i_err_msg);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(i_err_msg);
    END IF;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA ERROR INTERNO POR FAVOR CONTACTA AL ADMIN');
END;

/*
**  Crear asignaciones
** fecha inicio, fecha fin, descripcion, 
*/

DECLARE
    asd xxeks_nomina_pkg.lista_type;
    i_data VARCHAR(500):= :p_params;
    i_err_code NUMBER:=1;
    i_err_msg VARCHAR2(100):='';
BEGIN
    asd := xxeks_nomina_pkg.separate_words(i_data,',',i_err_msg,i_err_code);
    IF i_err_code > 0 THEN 
        xxeks_nomina_pkg.crear_asignacion(asd,i_err_code,i_err_msg);
        IF i_err_code > 0 THEN
            DBMS_OUTPUT.PUT_LINE(i_err_msg);
        ELSE
            DBMS_OUTPUT.PUT_LINE(i_err_msg);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(i_err_msg);
    END IF;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA ERROR INTERNO POR FAVOR CONTACTA AL ADMIN');
END;