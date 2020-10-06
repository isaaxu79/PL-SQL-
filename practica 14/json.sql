declare
   l_json     CLOB := '
        {
            "SupplierSite": "Site_31031992",
            "ProcurementBU": "HDI",
            "SitePurposePurchasingFlag": true,
            "SitePurposePrimaryPayFlag": true,
            "SupplierAddressName": "addres test",
            "SitePurposePayFlag": true,
            "DFF": [
                {
                    "numeroDeProveedorLider": "11542",
                    "folioDelPerfil": "hola.jpg",
                    "oficina": "KANSAS",
                    "sucursal": "SDASD",
                    "descripcion": "ESPERA",
                    "tipoDePerfil": "N/A",
                    "estatus": "ABIERTO",
                    "esPrincipal": "Acisa",
                    "canalDeDistribucion": "PAASC",
                    "ubicacionGeografica": "-122,-2332",
                    "modeloDeNegocio": "Tradicional",
                    "actividadOGiro": null
                },
                {
                    "numeroDeProveedorLider": "09876",
                    "folioDelPerfil": "foto.jpg",
                    "oficina": "OREGON",
                    "sucursal": null,
                    "descripcion": null,
                    "tipoDePerfil": null,
                    "estatus": null,
                    "esPrincipal": null,
                    "canalDeDistribucion": null,
                    "ubicacionGeografica": null,
                    "modeloDeNegocio": null,
                    "actividadOGiro": null
                },
                {
                    "numeroDeProveedorLider": "12345",
                    "folioDelPerfil": "perfil_img.png",
                    "oficina": "Mexico",
                    "sucursal": null,
                    "descripcion": null,
                    "tipoDePerfil": null,
                    "estatus": null,
                    "esPrincipal": null,
                    "canalDeDistribucion": null,
                    "ubicacionGeografica": null,
                    "modeloDeNegocio": null,
                    "actividadOGiro": null
                }
            ],
            "assignments": [
                {
                    "ClientBU": "HDI",
                    "BillToBU": "HDI",
                    "LiabilityDistribution": "",
                    "InactiveDate": ""
                },
                {
                    "ClientBU": "EKS",
                    "BillToBU": "EKS",
                    "LiabilityDistribution": "",
                    "InactiveDate": ""
                }
            ]
        }
   ';
   l_number   number;
begin
    apex_json.parse (l_json);
   
    dbms_output.put_line (
                            '-SupplierSite: ' || apex_json.get_varchar2 ('SupplierSite') || chr(10) ||
                            '-ProcurementBU: ' || apex_json.get_varchar2 ('ProcurementBU') || chr(10) ||
                            '-DFF'
                        );

   
    for i in 1 .. apex_json.get_count ('DFF') loop
        dbms_output.put_line (chr (9) || '---------------------');
        dbms_output.put_line (chr (9) || chr (9) || ' * numero De Proveedor Lider: ' || apex_json.get_varchar2 ('DFF[%d].ClientBU', i));
        dbms_output.put_line (chr (9) || chr (9) || ' * folioDelPerfil: ' || apex_json.get_varchar2 ('DFF[%d].folioDelPerfil', i));
        dbms_output.put_line (chr (9) || chr (9) || ' * oficina: ' || apex_json.get_varchar2 ('DFF[%d].oficina', i));
    end loop;
   
    dbms_output.put_line(
                            '-assignments'
                        );
   
    for i in 1 .. apex_json.get_count ('assignments') loop
        dbms_output.put_line (chr (9) || '---------------------');
        dbms_output.put_line (chr (9) || chr (9) || ' * numero De Proveedor Lider: ' || apex_json.get_varchar2 ('assignments[%d].numeroDeProveedorLider', i));
        dbms_output.put_line (chr (9) || chr (9) || ' * folioDelPerfil: ' || apex_json.get_varchar2 ('assignments[%d].BillToBU', i));
    end loop;
end;