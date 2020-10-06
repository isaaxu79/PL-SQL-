--DROP TABLE testo2;
--create table testo2(id number, dsa CLOB)
--delete from testo where id = 1;
--13
--SELECT extractvalue(dsa,'/students/student/@ids') sas from testo;
--SELECT extractvalue(dsa,'/cfdi:Comprobante/@Version','xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd"') sas from testo;

SELECT h.fecha, 
        h.subtotal,
        h.moneda,
        h.total,
        h.EmisorNombre,
        h.ReceptorNombre,
        r.claveServ,
        r.clave, 
        r.unidad,
        r.descripcion,
        q.* 
FROM testo2
    LEFT JOIN XMLTABLE(
       'Comprobante'
       PASSING XMLTYPE(replace(dsa,'cfdi:'))
       COLUMNS  
       Fecha VARCHAR2(25) PATH '@Fecha',
       Version NUMBER PATH '@Version',
       Serie VARCHAR2(200) PATH '@Serie',
       Folio VARCHAR2(200) PATH '@Folio',
       NoCertificado VARCHAR2(200) PATH '@NoCertificado',
       Forma_pago VARCHAR2(200) PATH '@FormaPago',
       MetodoPago VARCHAR2(200) PATH '@MetodoPago',
       SubTotal VARCHAR2(200) PATH '@SubTotal',
       Moneda VARCHAR2(200) PATH '@Moneda',
       Total VARCHAR2(200) PATH '@Total',
       EmisorRFC VARCHAR2(200) PATH 'Emisor/@Rfc',
       EmisorNombre VARCHAR2(200) PATH 'Emisor/@Nombre',
       ReceptorRFC VARCHAR2(200) PATH 'Receptor/@Rfc',
       ReceptorNombre VARCHAR2(200) PATH 'Receptor/@Nombre',
       Conceptos XMLTYPE PATH 'Conceptos/Concepto'
    )h  ON ( 1 = 1 )
    LEFT JOIN XMLTABLE(
       'Concepto'
       PASSING h.Conceptos
       COLUMNS  
       claveServ NUMBER PATH '@ClaveProdServ',
       clave varchar2(20) PATH '@ClaveUnidad',
       Unidad varchar2(20) PATH '@Unidad',
       Descripcion varchar2(20) PATH '@Descripcion',
       Traslados XMLTYPE PATH 'Impuestos/Traslados/Traslado'
    )r  ON ( 1 = 1 )
    LEFT JOIN XMLTABLE(
       'Traslado'
       PASSING r.Traslados
       COLUMNS  
       Base NUMBER PATH '@Base',
       Impuesto VARCHAR2(100) PATH '@Impuesto',
       TipoFactor VARCHAR2(100) PATH '@TipoFactor',
       TasaOCuota VARCHAR2(100) PATH '@TasaOCuota',
       Importe VARCHAR2(200) PATH '@Importe'
    )q  ON ( 1 = 1 );
