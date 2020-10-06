DECLARE

   X CLOB := '<cfdi:Comprobante xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd" Version="3.3" Serie="EKI1" Folio="4E6B4" Fecha="2019-12-26T20:22:37" Sello="EkJW4j33SuyO7jV4aaiKfonvXZuLwsZDSu9XyX/xSOLyOEqq647oz9BHXfyf8wR6ZVunIG8fCMTQ7O7Msrtnp/flHRxmkEt7X2mmT6V8HjKX1LPVbBzDlAhFZ1+0wqLvlMNM8SrYLQm7XxzmmQMLpDNk02/ZuhQdVrPNsClNptE6Rae/OdqqA5Grtps+gpQVsp/qB5Chdok6+kOPlhXTJtn/K+xZtBfnFnpCQ07yA90x/QTZD9JpB/vQjmm+SVpiF+xxvsWINh0y3Wknw4z4HR/pNcCKTMR2yFuU2k+8T7+cloc7k+KZNvhmw5WjzCfVCt10ZoddTq0nig9q8g8mlg==" FormaPago="04" NoCertificado="00001000000500712135" Certificado="MIIF3zCCA8egAwIBAgIUMDAwMDEwMDAwMDA1MDA3MTIxMzUwDQYJKoZIhvcNAQELBQAwggGEMSAwHgYDVQQDDBdBVVRPUklEQUQgQ0VSVElGSUNBRE9SQTEuMCwGA1UECgwlU0VSVklDSU8gREUgQURNSU5JU1RSQUNJT04gVFJJQlVUQVJJQTEaMBgGA1UECwwRU0FULUlFUyBBdXRob3JpdHkxKjAoBgkqhkiG9w0BCQEWG2NvbnRhY3RvLnRlY25pY29Ac2F0LmdvYi5teDEmMCQGA1UECQwdQVYuIEhJREFMR08gNzcsIENPTC4gR1VFUlJFUk8xDjAMBgNVBBEMBTA2MzAwMQswCQYDVQQGEwJNWDEZMBcGA1UECAwQQ0lVREFEIERFIE1FWElDTzETMBEGA1UEBwwKQ1VBVUhURU1PQzEVMBMGA1UELRMMU0FUOTcwNzAxTk4zMVwwWgYJKoZIhvcNAQkCE01yZXNwb25zYWJsZTogQURNSU5JU1RSQUNJT04gQ0VOVFJBTCBERSBTRVJWSUNJT1MgVFJJQlVUQVJJT1MgQUwgQ09OVFJJQlVZRU5URTAeFw0xOTA3MTkyMzA3MzhaFw0yMzA3MTkyMzA3MzhaMIGtMRwwGgYDVQQDExNJVkFOIFNPVE8gSEVSTkFOREVaMRwwGgYDVQQpExNJVkFOIFNPVE8gSEVSTkFOREVaMRwwGgYDVQQKExNJVkFOIFNPVE8gSEVSTkFOREVaMRYwFAYDVQQtEw1TT0hJOTAwMTIwSDY2MRswGQYDVQQFExJTT0hJOTAwMTIwSEpDVFJWMDUxHDAaBgNVBAsTE0lWQU4gU09UTyBIRVJOQU5ERVowggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCJ2aA6UOVBANOG3W5VDAfRQtTJYBqw79mqbELpXQQtLJXXymRp4WIM7fkvIrEMkhev3OUAq7rbPpu3V3pOOTq9DB2jp5RisY/d2NAr6diW50QEEkiJSw3GmStI2CudNhkrK0g1b8d+SfGfTIx7vLcFIyO2EDgg4TqMv+vFEtitk4uMz/9MHjrx2dJiWlfFGpNivck3LFNXeEeFqVlHV5mdNExLLHmA4BnMyGTcXif5R7et2rYZcPuwnjiDVzWS+v2JNZoqDHNZGD4WS6//2gvPCOBnnG00pjkFKXp9Nf9Nff5PoF3JTvoPYBydRhJPndP/2fKJ/NZbIoedgMuoWcy5AgMBAAGjHTAbMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQDAgbAMA0GCSqGSIb3DQEBCwUAA4ICAQALhodIqKkEsnYd0BgEVFTxg2j5jy4u1FO2sv6jvHJyGivmxgY9UaCSWjOQYXFBCD1Yj3m7/a8HdTGT+dPpeVi/qwN5cR+7Fhlv9KdrLly/N0Waa0yQeIvksaWF88zI68OQ9aDTTWeDawuiV+HaMlB4RUe/hNZAKWO1ABwDRYFOXGG2MPPfxBjxNhFj/96jQ38gvC6LM5uOpEaog1f1A+MLhoCGRSIdtyYOsdYmaGQBc/9o9hoSv0RMn024DgYKP6rB7j3yuPkazR3qWToYhTg6uWqEcianys9slJXNoWQ0Xh/4uAwzHOBlg+UybdeeCTVBlL4t2v7mUni9djguJNyfOEDQ1TL0m7J9CWE0HIvL6yZzIApIe1K+HylOzbIkf3PgxHaGawrIfp/Kh8FOiOb4NPN/xcm33pLa6HxcGUsZRNQIiajR4l8sfDKGS8HI1ouMb3iv4HSAlG2dm120g5IuRnfFcIsO3V1Ti7Hp7ZhDrXnOB97wFTkYfHFHPGTkWbJN3DhI3thh2SOV5DRfCLI4suabtr09jRKupHz54xVrXRaeisew2rbldjZ/rIiVT8OZrNyvtkvdYgGVx0lmHqOol37RkuonTJQblYqLUAGNZu3wJWQ66gtNZg7QT4asX/f1tDhC5FwEbezPAW55f3WcDWYiRWd1+S3ZSSnEl/+oRw==" SubTotal="47.68" Moneda="MXN" Total="55.31" TipoDeComprobante="I" MetodoPago="PUE" LugarExpedicion="37237">
	<cfdi:Emisor Rfc="BYYYYYYYY" Nombre="IVAN SOTO HERNANDEZ" RegimenFiscal="621" />
	<cfdi:Receptor Rfc="AXXXXXXX" Nombre="EKS SOLUTIONS SA DE CV" UsoCFDI="G03" />

	<cfdi:Conceptos>
		<cfdi:Concepto ClaveProdServ="78111808" Cantidad="1" ClaveUnidad="E48" Unidad="Unidad de servicio" Descripcion="Tarifa" ValorUnitario="43.34" Importe="43.34">
			<cfdi:Impuestos>
				<cfdi:Traslados>
					<cfdi:Traslado Base="10.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
					<cfdi:Traslado Base="20.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
					<cfdi:Traslado Base="43.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
				</cfdi:Traslados>
			</cfdi:Impuestos>
		</cfdi:Concepto>

		<cfdi:Concepto ClaveProdServ="78111808" Cantidad="1" ClaveUnidad="XNA" Unidad="No Aplica" Descripcion="Cuota de solicitud" ValorUnitario="4.34" Importe="4.34">
			<cfdi:Impuestos>
				<cfdi:Traslados>
					<cfdi:Traslado Base="4.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="0.69" />
					<cfdi:Traslado Base="43.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
				</cfdi:Traslados>
			</cfdi:Impuestos>
		</cfdi:Concepto>

		<cfdi:Concepto ClaveProdServ="78111809" Cantidad="1" ClaveUnidad="E48" Unidad="Unidad de servicio" Descripcion="Tarifa" ValorUnitario="43.34" Importe="43.34">
			<cfdi:Impuestos>
				<cfdi:Traslados>
					<cfdi:Traslado Base="43.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
					<cfdi:Traslado Base="43.3" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
					<cfdi:Traslado Base="4.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
					<cfdi:Traslado Base="43.344" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
					<cfdi:Traslado Base="43.3664" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
				</cfdi:Traslados>
			</cfdi:Impuestos>
		</cfdi:Concepto>

		<cfdi:Concepto ClaveProdServ="78111801" Cantidad="1" ClaveUnidad="E48" Unidad="Unidad de servicio" Descripcion="Tarifa" ValorUnitario="43.34" Importe="43.34">
			<cfdi:Impuestos>
				<cfdi:Traslados>
					<cfdi:Traslado Base="43.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
				</cfdi:Traslados>
			</cfdi:Impuestos>
		</cfdi:Concepto>

		<cfdi:Concepto ClaveProdServ="78111802" Cantidad="1" ClaveUnidad="E48" Unidad="Unidad de servicio" Descripcion="Tarifa" ValorUnitario="43.34" Importe="43.34">
			<cfdi:Impuestos>
				<cfdi:Traslados>
					<cfdi:Traslado Base="43.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
				</cfdi:Traslados>
			</cfdi:Impuestos>
		</cfdi:Concepto>

		<cfdi:Concepto ClaveProdServ="78111803" Cantidad="1" ClaveUnidad="E48" Unidad="Unidad de servicio" Descripcion="Tarifa" ValorUnitario="43.34" Importe="43.34">
			<cfdi:Impuestos>
				<cfdi:Traslados>
					<cfdi:Traslado Base="43.34" Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="6.94" />
				</cfdi:Traslados>
			</cfdi:Impuestos>
		</cfdi:Concepto>

	</cfdi:Conceptos>
	<cfdi:Impuestos TotalImpuestosTrasladados="7.63">
		<cfdi:Traslados>
			<cfdi:Traslado Impuesto="002" TipoFactor="Tasa" TasaOCuota="0.160000" Importe="7.63" />
		</cfdi:Traslados>
	</cfdi:Impuestos>
	<cfdi:Complemento>
		<tfd:TimbreFiscalDigital xmlns:tfd="http://www.sat.gob.mx/TimbreFiscalDigital"  xsi:schemaLocation="http://www.sat.gob.mx/TimbreFiscalDigital http://www.sat.gob.mx/sitio_internet/cfd/TimbreFiscalDigital/TimbreFiscalDigitalv11.xsd" Version="1.1" UUID="XXXXXX-XXXXXX-XXXX-XXXXX" FechaTimbrado="2019-12-26T20:22:38" RfcProvCertif="DET080304395" SelloCFD="EkJW4j33SuyO7jV4aaiKfonvXZuLwsZDSu9XyX/xSOLyOEqq647oz9BHXfyf8wR6ZVunIG8fCMTQ7O7Msrtnp/flHRxmkEt7X2mmT6V8HjKX1LPVbBzDlAhFZ1+0wqLvlMNM8SrYLQm7XxzmmQMLpDNk02/ZuhQdVrPNsClNptE6Rae/OdqqA5Grtps+gpQVsp/qB5Chdok6+kOPlhXTJtn/K+xZtBfnFnpCQ07yA90x/QTZD9JpB/vQjmm+SVpiF+xxvsWINh0y3Wknw4z4HR/pNcCKTMR2yFuU2k+8T7+cloc7k+KZNvhmw5WjzCfVCt10ZoddTq0nig9q8g8mlg==" NoCertificadoSAT="00001000000407371267" SelloSAT="nhJ4A9BwxZcHekMXEktJNCIGuZawfkgCsXfShhGb7+TUgmCOSDMm2X2olmzjRcS/SLnBttSSTiipbOsaQywitgscV/z4/kr/qMc6PqUjRnp3t4Q==" />
	</cfdi:Complemento>
</cfdi:Comprobante>>';

BEGIN
    --DBMS_OUTPUT.PUT_LINE(replace(x,'cfdi:'));
   FOR R IN (SELECT EXTRACT(VALUE(P), '@ClaveProdServ').getStringVal() AS NM
                FROM TABLE(XMLSEQUENCE(EXTRACT(xmltype(replace(x,'cfdi:')), '/Comprobante/Conceptos'))) P)

   LOOP

      DBMS_OUTPUT.PUT_LINE(R.NM );


   END LOOP;

END;