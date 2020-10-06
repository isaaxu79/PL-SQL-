select * from all_scheduler_jobs;
select * from ALL_SCHEDULER_JOB_RUN_DETAILS;
SELECT * FROM V$TIMEZONE_NAMES;
CREATE TABLE jobs_deamons(
            id NUMBER PRIMARY KEY,
            descrp varchar2(20),
            fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
create sequence unit
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tri_sq_test
BEFORE INSERT ON jobs_deamons
FOR EACH ROW
BEGIN
SELECT unit.NEXTVAL INTO :NEW.id from DUAL;
END;

CREATE PROCEDURE hola_mundo AS
BEGIN
    INSERT INTO jobs_deamons(descrp) values('hola mundo');
END;

begin
dbms_scheduler.create_job (
   job_name           =>  'Save_Hello',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'hola_mundo',
   start_date         =>  '21-SEP-20 12:03:00 CST',
   repeat_interval    =>  'FREQ=DAILY',
   enabled            =>  TRUE);
end;