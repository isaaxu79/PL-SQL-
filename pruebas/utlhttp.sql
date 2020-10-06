DECLARE
  req     utl_http.req;
  res     utl_http.resp;
  pUrl  VARCHAR2(200):='http://jsonplaceholder.typicode.com/users';
  vResult VARCHAR2(500);
begin
    utl_http.set_transfer_timeout(30);
    dbms_output.put_line('Request>  URL:  '   ||pUrl);
    req := utl_http.begin_request(pUrl, 'GET', 'HTTP/1.1');

    res := utl_http.get_response(req);
    dbms_output.put_line('Response> status_code: "'   ||res.status_code  || '"');
    dbms_output.put_line('Response> reason_phrase: "' ||res.reason_phrase || '"');
    dbms_output.put_line('Response> http_version: "'  ||res.http_version  || '"');
    Begin
        Loop
            utl_http.read_line(res, vResult,TRUE);
            dbms_output.put_line(vResult);
        End Loop;
        utl_http.end_response(res);
    Exception
        When utl_http.end_of_body Then
                utl_http.end_response(res);
    End;
end;

