DROP TABLE testo;
create table testo(id number, dsa XMLTYPE)
delete from testo where id = 1;

SELECT extractvalue(dsa,'/students/student/@ids') sas from testo;
SELECT extractvalue(dsa,'/cfdi:Comprobante/@Version','xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd"') sas from testo;

SELECT h.* FROM testo, XMLTABLE(
    xmlnamespaces (
   'http://www.w3.org/2001/XMLSchema-instance' as "xsi",
   'http://www.sat.gob.mx/cfd/3' as "cfdi"
   , 'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd' as "schemaLocation"
   ,default 'http://www.w3.org/2001/XMLSchema-instance'
   ),
   'cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado'
   PASSING dsa
   COLUMNS  
   "Cantidad" NUMBER PATH './../../@Cantidad',
   "Base" VARCHAR2(200) PATH '@Base',
   "Impuesto" VARCHAR2(200) PATH '@Impuesto',
   "Factor" VARCHAR2(200) PATH '@TipoFactor',
   "Cuota" VARCHAR2(200) PATH '@TasaOCuota',
   "Importe" VARCHAR2(200) PATH '@Importe'
)h;
