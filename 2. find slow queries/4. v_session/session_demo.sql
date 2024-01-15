---- ƒемо примитивной диагностики по v$session (HR)

---- ѕример 1. ќдна сессси€

-- 1) открываем другую вкладку с сесси€ми

-- 2) в этой вкладке запускам

declare
  v_cnt number;
begin
  dbms_session.sleep(5); -- чтоб успел переключитьс€ во вкладку с сесси€ми

  select
   count(*)
    into v_cnt
    from hr.employees q1
   cross join hr.employees
   cross join hr.employees
   cross join hr.employees;

  select
   count(*)
    into v_cnt
    from hr.employees q2
   cross join hr.employees
   cross join hr.employees
   cross join hr.employees;

  select 
   count(*)
    into v_cnt
    from hr.employees q3
   cross join hr.employees
   cross join hr.employees
   cross join hr.employees;

end;
/


---- ѕример 2. »митаци€ нескольких сессий

-- создаем процедурку с тормозами
create or replace procedure del$client_activity
is
  v_cnt number;
begin
  select count(*) into v_cnt from dual;
  
  dbms_application_info.set_action(action_name => 'Q1 running...');
  
  select
   count(*)
    into v_cnt
    from hr.employees q1
   cross join hr.employees
   cross join hr.employees
   cross join hr.employees;


  dbms_application_info.set_action(action_name => 'Q2 running...');

  select
   count(*)
    into v_cnt
    from hr.employees q2
   cross join hr.employees
   cross join hr.employees
   cross join hr.employees;

  dbms_application_info.set_action(action_name => 'Q3 running...');

  select 
   count(*)
    into v_cnt
    from hr.employees q3
   cross join hr.employees;

  dbms_application_info.set_action(action_name => 'Q4 running...');

  select 
   count(*)
    into v_cnt
    from hr.employees q4
   cross join hr.employees
   cross join hr.employees;

end;
/

-- создаем 10 сессий
declare
  v_session_count number := 10;
begin
  for i in 1..v_session_count loop
  dbms_scheduler.create_job(job_name        => 'demo_v_session_job_'||i,
                              job_type        => 'STORED_PROCEDURE',
                              job_action      => 'del$client_activity',
                              start_date      => systimestamp,
                              repeat_interval => 'freq=SECONDLY;',
                              end_date        => null,
                              enabled         => true,
                              auto_drop       => false,
                              comments        => 'Some client activity');
  end loop;                            
end;
/

select sysdate, t.next_run_date, t.* from user_scheduler_jobs t where lower(t.job_name) like 'demo_v_session_job_%';

-- чистим
declare
  v_session_count number := 10;
begin
  for i in 1..v_session_count loop
    dbms_scheduler.drop_job(job_name => 'demo_v_session_job_'||i, force => true); 
  end loop;                            
end;
/

