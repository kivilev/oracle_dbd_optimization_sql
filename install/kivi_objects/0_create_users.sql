/*
  Creating role, kivi, hr schemas
  
-- role
drop role student_role;

create role student_role;
grant connect to student_role;
grant resource to student_role;
grant debug connect session to student_role;
grant create view to student_role;
grant create materialized view to student_role;

*/

declare
  type t_users is table of all_users.username%type;
  v_users t_users := t_users('kivi', 'hr');

  v_ts_name dba_tablespaces.tablespace_name%type := 'users';
  v_role_name varchar2(20 char) := 'student_role';

  procedure exec_sql(sql_cmd varchar2)is
  begin
   execute immediate sql_cmd;
  exception when others then
    dbms_output.put_line(sqlerrm || chr(13) || chr(10) || sql_cmd);
  end;
                              
begin
  
  if v_users is not empty then
    for i in v_users.first .. v_users.last loop
      exec_sql(' create user '||v_users(i)||' identified by booble12
      default tablespace '|| v_ts_name ||
      ' temporary tablespace temp');
      
      exec_sql('grant '||v_role_name||' to '|| v_users(i));

      exec_sql('grant select_catalog_role to '|| v_users(i));
      exec_sql('grant select any dictionary to '|| v_users(i));
      exec_sql('grant alter session to '|| v_users(i));
        
      dbms_output.put_line('User "'||v_users(i)||'" was created');          
    
    end loop;
  end if;

end;
/

alter user kivi quota 17g on users;
alter user hr quota 500m on users;
