create or replace noneditionable procedure sys.flush_all
is
begin
  execute immediate 'alter system flush buffer_cache';
  execute immediate 'alter system flush shared_pool';
end;
/

create or replace noneditionable procedure kill_session(sid number, serial number)
is
  v_sql varchar2(1000);
begin
  v_sql := 'ALTER SYSTEM KILL SESSION '''||sid||','||serial ||''' IMMEDIATE';
  execute immediate v_sql;
end;
/


create public synonym flush_all for sys.flush_all;
create public synonym kill_session for sys.kill_session;

grant execute on kill_session to kivi, hr;
grant execute on flush_all to kivi, hr;

