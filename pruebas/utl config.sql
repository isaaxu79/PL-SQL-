SELECT USERNAME FROM DBA_USERS;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => 'apex_oracle_jobxS.xml', 
    description  => 'ACL for testing purposes',
    principal    => 'HR',
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);
  COMMIT;
END;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => 'apex_oracle_jobxS.xml',
    host        => 'hbawlx2uyy4v5tx-db202009281546.adb.us-phoenix-1.oraclecloudapps.com', 
    lower_port  => NULL,
    upper_port  => NULL);
  COMMIT;
END;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => 'oracle_apex_api_jobs.xml',
    host        => 'www.jhbawlx2uyy4v5tx-db202009281546.adb.us-phoenix-1.oraclecloudapps.com', 
    lower_port  => NULL,
    upper_port  => NULL);
  COMMIT;
END;