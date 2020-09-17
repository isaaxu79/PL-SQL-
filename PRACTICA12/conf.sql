DROP TABLE xxeks_direccion CASCADE CONSTRAINTS;
DROP TABLE xxeks_empleados CASCADE CONSTRAINTS;
DROP TABLE xxeks_asignaciones CASCADE CONSTRAINTS;
DROP TABLE xxeks_catalogos;
DROP TABLE xxeks_auditoria;

CREATE TABLE xxeks_direccion(
                            direccion_id NUMBER PRIMARY KEY,
                            calle VARCHAR2(100) NOT NULL,
                            codigo_postal NUMBER(10) NOT NULL,
                            n_interior NUMBER(5) NOT NULL,
                            n_exterior NUMBER(5) NOT NULL,
                            colonia VARCHAR2(100) NOT NULL,
                            estado VARCHAR2(100) NOT NULL,
                            pais VARCHAR2(100) NOT NULL
                            );

CREATE TABLE xxeks_empleados(  --contacto:8,12,
                        empleado_id NUMBER PRIMARY KEY,
                        nombre VARCHAR2(40) NOT NULL, --
                        apellido_m VARCHAR2(40) NOT NULL,--
                        apellido_p VARCHAR2(40) NOT NULL,--
                        edad NUMBER(2) NOT NULL,--
                        sexo CHAR(1) NOT NULL,---
                        telefono VARCHAR2(20) NOT NULL,--
                        salario NUMBER(10,2), 
                        fecha_ingreso DATE,
                        fecha_baja DATE,
                        tipo VARCHAR2(40) NOT NULL, --
                        contacto_id NUMBER,
                        manager_id NUMBER,
                        direccion_id NUMBER,
                        CONSTRAINT fk_direccion
                            FOREIGN KEY (direccion_id)
                            REFERENCES xxeks_direccion(direccion_id)
                            ON DELETE SET NULL,
                        CONSTRAINT fk_contacto
                            FOREIGN KEY (contacto_id)
                            REFERENCES xxeks_empleados(empleado_id)
                            ON DELETE SET NULL,
                        CONSTRAINT fk_manager
                            FOREIGN KEY (manager_id)
                            REFERENCES xxeks_empleados(empleado_id)
                            ON DELETE SET NULL
                        );

CREATE TABLE xxeks_asignaciones(
                                    asignacion_id NUMBER PRIMARY KEY,
                                    fecha_inicio DATE NOT NULL,
                                    fecha_fin DATE NOT NULL,
                                    descripcion VARCHAR(200) NOT NULL,
                                    status NUMBER(1) NOT NULL,
                                    empleado_id NUMBER NOT NULL,
                                    CONSTRAINT fk_empleado
                                        FOREIGN KEY (empleado_id)
                                        REFERENCES xxeks_empleados(empleado_id)
                                        ON DELETE CASCADE
                                );
                                
CREATE TABLE xxeks_catalogos(
                                catalogo_id NUMBER PRIMARY KEY,
                                nombre VARCHAR2(100) NOT NULL,
                                codigo NUMBER(7) NOT NULL,
                                valor VARCHAR2(100) NOT NULL,
                                descripcion VARCHAR2(100) NOT NULL,
                                activo NUMBER NOT NULL
                            );

CREATE TABLE xxeks_auditoria(
                                auditoria_id NUMBER PRIMARY KEY,
                                nombre_tabla VARCHAR2(100) NOT NULL,
                                descripcion VARCHAR2(500) NOT NULL,
                                fecha_modificacion TIMESTAMP NOT NULL,
                                accion VARCHAR(10) NOT NULL,
                                usuario VARCHAR2(100) NOT NULL
                            );

DROP SEQUENCE sq_xxeks_empleados;
DROP SEQUENCE sq_xxeks_direccion;
DROP SEQUENCE sq_xxeks_asignaciones;
DROP SEQUENCE sq_xxeks_catalogos;
DROP SEQUENCE sq_xxeks_auditoria;

CREATE SEQUENCE sq_xxeks_empleados
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE sq_xxeks_direccion
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE sq_xxeks_asignaciones
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE sq_xxeks_catalogos
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE sq_xxeks_auditoria
START WITH 1
INCREMENT BY 1;

/*
** Trigger de autoincremento
*/
CREATE OR REPLACE TRIGGER tri_sq_xxeks_empleados
BEFORE INSERT ON xxeks_empleados
FOR EACH ROW
BEGIN
SELECT sq_xxeks_empleados.NEXTVAL INTO :NEW.empleado_id from DUAL;
END;

CREATE OR REPLACE TRIGGER tri_sq_xxeks_direccion
BEFORE INSERT ON xxeks_direccion
FOR EACH ROW
BEGIN
SELECT sq_xxeks_direccion.NEXTVAL INTO :NEW.direccion_id from DUAL;
END; 

CREATE OR REPLACE TRIGGER tri_sq_xxeks_asignaciones
BEFORE INSERT ON xxeks_asignaciones
FOR EACH ROW
BEGIN
SELECT sq_xxeks_asignaciones.NEXTVAL INTO :NEW.asignacion_id from DUAL;
END;

CREATE OR REPLACE TRIGGER tri_sq_xxeks_catalogos
BEFORE INSERT ON xxeks_catalogos
FOR EACH ROW
BEGIN
SELECT sq_xxeks_catalogos.NEXTVAL INTO :NEW.catalogo_id from DUAL;
END;

CREATE OR REPLACE TRIGGER tri_sq_xxeks_auditoria
BEFORE INSERT ON xxeks_auditoria
FOR EACH ROW
BEGIN
SELECT sq_xxeks_auditoria.NEXTVAL INTO :NEW.auditoria_id from DUAL;
END;

/*
** Triggers para auditoria en la tabla empleados
*/

CREATE OR REPLACE TRIGGER xxeks_audi_emp_tri
BEFORE DELETE OR UPDATE OR INSERT
ON xxeks_empleados
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion, accion,usuario)
            VALUES (
                    'xxeks_empleados',
                    'Se ha insertado un nuevo empleado: ' || :new.nombre || ' ' || :new.apellido_p || ', ' || :new.apellido_m || '.',
                    CURRENT_TIMESTAMP,
                    'insert', TO_CHAR(user));
    ELSIF DELETING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion, accion,usuario)
            VALUES (
                    'xxeks_empleados',
                    'Se ha elimidado al empleado: ' || :old.nombre || ' ' || :old.apellido_p || ', ' || :old.apellido_m || '.',
                    CURRENT_TIMESTAMP,
                    'delete',TO_CHAR(user));
    ELSIF UPDATING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion,accion,usuario)
            VALUES (
                    'xxeks_empleados',
                    'Se ha actualizado el' || :old.tipo || ' con el ID' || :old.empleado_id,
                    CURRENT_TIMESTAMP,
                    'update',TO_CHAR(user));
    END IF;
END;

/*
** Triggers para auditoria en la tabla direccion
*/
----
CREATE OR REPLACE TRIGGER xxeks_auit_dir_tri
BEFORE DELETE OR UPDATE OR INSERT
ON xxeks_direccion
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion,accion,usuario)
            VALUES (
                    'xxeks_direccion',
                    'Se ha insertado una nueva direccion: ' || :new.calle || ', ' || :new.colonia || ', ' || :new.estado || ', ' || :new.pais,
                    CURRENT_TIMESTAMP,
                    'insert',TO_CHAR(user));
    ELSIF DELETING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion, accion,usuario)
            VALUES (
                    'xxeks_direccion',
                    'Se ha elimidado la direccion: ' || :old.calle || ', No.'|| :old.n_exterior || ' exterior, ' || :old.colonia || ', ' || :old.codigo_postal || ', ' || :old.estado || ', ' || :old.pais,
                    CURRENT_TIMESTAMP,
                    'delete',TO_CHAR(user));
    ELSIF UPDATING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion, accion,usuario)
            VALUES (
                    'xxeks_direccion',
                    'Se ha actualizado la direccion con id: ' || :old.direccion_id,
                    CURRENT_TIMESTAMP,
                    'update',TO_CHAR(user));
    END IF;
END;

/*
** Triggers para auditoria en la tabla asignaciones
*/

CREATE OR REPLACE TRIGGER xxeks_audit_asig_tri
BEFORE DELETE OR UPDATE OR INSERT
ON xxeks_asignaciones
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion, accion,usuario)
            VALUES (
                    'xxeks_asignaciones',
                    'Se ha insertado un nueva asignacion: ' || :new.descripcion || ' con fecha de ' || :new.fecha_inicio || ' al ' || :new.fecha_fin || '.',
                    CURRENT_TIMESTAMP,
                    'insert',TO_CHAR(user));
    ELSIF DELETING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion,accion,usuario)
            VALUES (
                    'xxeks_asignaciones',
                    'Se ha elimidado la asignacion: '  || :old.descripcion || ' con fecha de ' || :old.fecha_inicio || ' al ' || :old.fecha_fin || '.',
                    CURRENT_TIMESTAMP,
                    'delete',TO_CHAR(user));
    ELSIF UPDATING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion,accion,usuario)
            VALUES (
                    'xxeks_asignaciones',
                    'Se ha actualizado la asignacion con el ID' || :old.asignacion_id,
                    CURRENT_TIMESTAMP,
                    'update',TO_CHAR(user));
    END IF;
END;

/*
** Triggers para auditoria en la tabla empleados
*/

CREATE OR REPLACE TRIGGER xxeks_audit_catlg_tri
BEFORE DELETE OR UPDATE OR INSERT
ON xxeks_catalogos
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion, accion,usuario)
            VALUES (
                    'xxeks_catalogos',
                    'Se ha insertado un nuevo catalogo: ' || :new.nombre || ', ' || :new.codigo || ', ' || :new.valor || ', ' || :new.descripcion,
                    CURRENT_TIMESTAMP,
                    'insert',TO_CHAR(user));
    ELSIF DELETING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion,accion,usuario)
            VALUES (
                    'xxeks_catalogos',
                    'Se ha elimidado un catalogo: ' || :old.nombre || ', ' || :old.codigo || ', ' || :old.valor || ', ' || :old.descripcion,
                    CURRENT_TIMESTAMP,
                    'delete',TO_CHAR(user));
    ELSIF UPDATING THEN
        INSERT INTO xxeks_auditoria(nombre_tabla,descripcion,fecha_modificacion,accion,usuario)
            VALUES (
                    'xxeks_catalogos',
                    'Se ha actualizado el catalogo con id: ' || :old.catalogo_id,
                    CURRENT_TIMESTAMP,
                    'update',TO_CHAR(user));
    END IF;
END;