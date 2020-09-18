INSERT INTO xxeks_direccion(calle, codigo_postal, n_interior, n_exterior, colonia,estado,pais) VALUES ('San Luis', 70610,10,1,'deportiva','oaxaca','mexico');
SELECT sq_xxeks_direccion.currval FROM DUAL;
select * from xxeks_direccion where calle = 'San Luis';
select * from xxeks_auditoria; 
select user from dual;
delete from xxeks_empleados where empleado_id = 2;
ROLLBACK;
select * from xxeks_empleados;
select * from xxeks_asignaciones;emmp 6,emp 5, dir 3
UPDATE xxeks_empleados
set nombre = 'leo'
where empleado_id = 4;
INSERT INTO xxeks_empleados(nombre,apellido_m,apellido_p,edad,sexo,telefono,salario,fecha_ingreso,fecha_baja,tipo,contacto_id,manager_id,direccion_id) 
VALUES('leo','vasquez','marin',12,'H','213123',21212,'12-12-12','12-12-12','empleado',5,null,3);