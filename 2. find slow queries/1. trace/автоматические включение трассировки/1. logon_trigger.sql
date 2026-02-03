  --- DEMO. Logon-Триггера
  -- Создать от SYS или пользователя с правами CREATE TRIGGER на DATABASE

create or replace noneditionable trigger hr_logon_trace_trigger
after logon on database
when (user = 'HR')
declare
  v_label varchar2(100);
begin
  v_label := 'HR_' || to_char(sysdate, 'YYYYMMDDHH24MISS');

  -- Установка метки в имя трассировочного файла
  execute immediate 'alter session set tracefile_identifier = ''' || v_label || '''';

  dbms_session.session_trace_enable();

end;
/
