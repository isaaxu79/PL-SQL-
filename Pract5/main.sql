DECLARE
    i_mensaje VARCHAR2(100) ;
BEGIN
<    --xxeks_reportes_pkg.p_report_department(i_mensaje, i_mensaje2);

    PRINT(i_mensaje, i_mensaje2);
    --xxeks_reportes_pkg.p_report_employees();
    --xxeks_reportes_pkg.p_report_emplo_manager();
    --xxeks_reportes_pkg.p_report_emplo_depto('EUR','03-01');
    --xxeks_reportes_pkg.p_report_region_depto();
    --xxeks_reportes_pkg.p_report_employees_detailed('Isaac', 'AXISCODE', null, '13-2010');
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('HA OCURRIDO UNA EXCEPCION:' || SQLCODE|| ' - ' || SQLERRM || CHR(10) ||
                                                'EN: ' || DBMS_UTILITY.format_error_backtrace);
END;