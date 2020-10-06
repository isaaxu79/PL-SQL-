declare
  l_clob clob;
  l_buffer         varchar2(32767);
  l_amount         number;
  l_offset         number;
begin
    l_clob := apex_web_service.make_rest_request(
                p_url => 'https://hbawlx2uyy4v5tx-db202009281546.adb.us-phoenix-1.oraclecloudapps.com/ords/pdbuser/xxisaac_api_v1/jobs',
                p_http_method => 'GET',
                p_wallet_path => 'file:C:\oraclexe\cert',
                p_wallet_pwd => 'isaac');
 
    dbms_output.put_line(l_clob);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERR' || SQLERRM);
end;

DECLARE


-- SOAP REQUESTS/RESPONSE
   soap_req_msg    VARCHAR2 (2000);
   soap_resp_msg   VARCHAR2 (2000);

   -- HTTP REQUEST/RESPONSE
   http_req        UTL_HTTP.req;
   http_resp       UTL_HTTP.resp;

BEGIN
   --
   -- Create SOAP request via HTTP
   --
   soap_req_msg := 
      '<soapenv:Envelope xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope"><soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:MessageID>urn:uuid:1d66c9a8-b5e2-4c7a-9649-0bd63a590372</wsa:MessageID><wsa:Action>http://tempuri.org/IDataInterfaceService/Connect</wsa:Action><wsa:To>http://localhost:3038/</wsa:To></soapenv:Header><soapenv:Body><ns1:Connect xmlns:ns1="http://tempuri.org/"/></soapenv:Body></soapenv:Envelope>';

   http_req :=UTL_HTTP.begin_request('http://localhost:3038/', 'POST', 'HTTP/1.1');
   UTL_HTTP.set_header (http_req, 'Accept-Encoding', 'gzip,deflate');
   UTL_HTTP.set_header (http_req, 'Content-Type', 'application/soap+xml;charset=UTF-8;action="http://tempuri.org/IDataInterfaceService/Connect"');
   UTL_HTTP.set_header (http_req, 'Content-Length', length(soap_req_msg));
   UTL_HTTP.set_header (http_req, 'Host', 'localhost:3038');
   UTL_HTTP.set_header (http_req, 'Connection', 'Keep-Alive');
   UTL_HTTP.set_header (http_req, 'User-Agent', 'Apache-HttpClient/4.1.1 (java 1.5)');
   UTL_HTTP.write_text (http_req, soap_req_msg);

  dbms_output.put_line(' ');
  --
   -- Invoke Request and get Response.
   --
   http_resp := UTL_HTTP.get_response(http_req);
   UTL_HTTP.read_text (http_resp, soap_resp_msg);
   UTL_HTTP.end_response (http_resp);
   DBMS_OUTPUT.put_line ('Output: ' || soap_resp_msg);
END; 
parse xml
parse json
