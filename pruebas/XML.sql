DECLARE

   X XMLTYPE := XMLTYPE('<?xml version = "1.0" encoding = "utf-8"?>
    <DATA_DS><P_MONTO_INICIAL>50000</P_MONTO_INICIAL><P_MONEDA>USD</P_MONEDA><P_MONTO_FINAL>100000</P_MONTO_FINAL>
    <G_1>
    <INVOICE_NUM>7525899</INVOICE_NUM><INVOICE_CURRENCY_CODE>USD</INVOICE_CURRENCY_CODE><INVOICE_AMOUNT>93922.39</INVOICE_AMOUNT><INVOICE_DATE>2020-05-18T00:00:00.000+00:00</INVOICE_DATE><INVOICE_TYPE_LOOKUP_CODE>STANDARD</INVOICE_TYPE_LOOKUP_CODE><DESCRIPTION>Sin. 20200000065118 Cob. RESPONSABILIDAD CIVIL VIAJERO Por PAGO SERVICIOS - HOSPITALES C/IVA Doc: FACTURA - SLP94926662</DESCRIPTION><INVOICE_ID>300000010496818</INVOICE_ID>
    </G_1>
    <G_1>
    <INVOICE_NUM>7535371</INVOICE_NUM><INVOICE_CURRENCY_CODE>USD</INVOICE_CURRENCY_CODE><INVOICE_AMOUNT>93922.39</INVOICE_AMOUNT><INVOICE_DATE>2020-05-19T00:00:00.000+00:00</INVOICE_DATE><INVOICE_TYPE_LOOKUP_CODE>STANDARD</INVOICE_TYPE_LOOKUP_CODE><DESCRIPTION>Sin. 20200000065118 Cob. RESPONSABILIDAD CIVIL VIAJERO Por PAGO SERVICIOS - HOSPITALES C/IVA Doc: FACTURA - SLP94926662</DESCRIPTION><INVOICE_ID>300000010503235</INVOICE_ID>
    </G_1>
    <G_1>
    <INVOICE_NUM>USDMRC34</INVOICE_NUM><INVOICE_CURRENCY_CODE>USD</INVOICE_CURRENCY_CODE><INVOICE_AMOUNT>65432.77</INVOICE_AMOUNT><INVOICE_DATE>2020-05-01T00:00:00.000+00:00</INVOICE_DATE><INVOICE_TYPE_LOOKUP_CODE>STANDARD</INVOICE_TYPE_LOOKUP_CODE><INVOICE_ID>300000010443449</INVOICE_ID>
    </G_1>
    <G_1>
    <INVOICE_NUM>USDMRC20</INVOICE_NUM><INVOICE_CURRENCY_CODE>USD</INVOICE_CURRENCY_CODE><INVOICE_AMOUNT>78371.76</INVOICE_AMOUNT><INVOICE_DATE>2020-05-01T00:00:00.000+00:00</INVOICE_DATE><INVOICE_TYPE_LOOKUP_CODE>STANDARD</INVOICE_TYPE_LOOKUP_CODE><INVOICE_ID>300000010443104</INVOICE_ID>
    </G_1>
    </DATA_DS>');

BEGIN
   FOR R IN (SELECT EXTRACTVALUE(VALUE(P), '/G_1/INVOICE_NUM/text()') AS NM,
                    EXTRACTVALUE(VALUE(P), '/G_1/INVOICE_CURRENCY_CODE/text()') AS CODE,
                    EXTRACTVALUE(VALUE(P), '/G_1/INVOICE_AMOUNT/text()') AS AMOUNT,
                    EXTRACTVALUE(VALUE(P), '/G_1/INVOICE_DATE/text()') AS FECHA,
                    EXTRACTVALUE(VALUE(P), '/G_1/INVOICE_TYPE_LOOKUP_CODE/text()') AS TIPO,
                    EXTRACTVALUE(VALUE(P), '/G_1/DESCRIPTION/text()') AS DESCP,
                    EXTRACTVALUE(VALUE(P), '/G_1/INVOICE_ID/text()') AS ID
                FROM TABLE(XMLSEQUENCE(EXTRACT(X, '//DATA_DS/G_1'))) P)

   LOOP

      DBMS_OUTPUT.PUT_LINE(R.NM || ' ' ||R.CODE || ' ' ||R.AMOUNT || ' ' ||R.FECHA || ' ' ||R.TIPO || ' ' ||R.DESCP || ' ' ||R.ID);


   END LOOP;

END;