INSERT INTO xxeks_direccion(calle, codigo_postal, n_interior, n_exterior, colonia,estado,pais) VALUES ('San Luis', 70610,10,1,'deportiva','oaxaca','mexico');
SELECT sq_xxeks_direccion.currval FROM DUAL;
select * from xxeks_direccion where calle = 'San Luis';
select * from xxeks_auditoria; 
select user from dual;
delete from xxeks_direccion where direccion_id = 2;