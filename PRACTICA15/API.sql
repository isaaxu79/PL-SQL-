DECLARE
    req utl_http.req;
    res utl_http.resp;
    l_request CLOB;
    l_url VARCHAR2(300):='https://hbawlx2uyy4v5tx-db202009281546.adb.us-phoenix-1.oraclecloudapps.com/ords/pdbuser/xxisaac_api_v1/jobs';
    l_response CLOB;
    CURSOR jobs is
        SELECT * FROM JOBS;
BEGIN
    
    FOR job_x in jobs loop
        BEGIN
            
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object; ---{
            APEX_JSON.write('JOB_ID',job_x.JOB_ID);
            APEX_JSON.write('JOB_TITLE',job_x.JOB_TITLE);
            APEX_JSON.write('MIN_SALARY',job_x.MIN_SALARY);
            APEX_JSON.write('MAX_SALARY',job_x.MAX_SALARY);
            APEX_JSON.close_object; --}
            l_request := APEX_JSON.get_clob_output;
            DBMS_OUTPUT.PUT_LINE(l_request);
            utl_http.set_transfer_timeout(30);
            UTL_HTTP.SET_WALLET ('file:C:\oraclexe\cert','isaac');
            req := utl_http.begin_request('hbawlx2uyy4v5tx-db202009281546.adb.us-phoenix-1.oraclecloudapps.com/ords/pdbuser/xxisaac_api_v1/jobs', 'POST',' HTTP/1.1');
            utl_http.set_header(req, 'user-agent', 'mozilla/4.0'); 
            DBMS_OUTPUT.PUT_LINE('2');
            utl_http.set_header(req, 'content-type', 'application/json'); 
            DBMS_OUTPUT.PUT_LINE('3');
            utl_http.write_text(req, l_request);
            DBMS_OUTPUT.PUT_LINE('4');
            res := utl_http.get_response(req);
            DBMS_OUTPUT.PUT_LINE('5');
            BEGIN
                loop
                    utl_http.read_line(res, l_response);
                    dbms_output.put_line(l_response);
                end loop;
                utl_http.end_response(res);
            EXCEPTION
                WHEN utl_http.end_of_body THEN
                    utl_http.end_response(res);
            END;

        EXCEPTION
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('err: ' || DBMS_UTILITY.format_error_backtrace || chr(10)|| SQLERRM);
        END;
        DBMS_OUTPUT.put_line('REALIZADO');
    end loop;

END;

select UTL_HTTP.REQUEST('hbawlx2uyy4v5tx-db202009281546.adb.us-phoenix-1.oraclecloudapps.com/ords/pdbuser/xxisaac_api_v1/jobs',null,'file:C:\oraclexe\cert','isaac') Output from dual