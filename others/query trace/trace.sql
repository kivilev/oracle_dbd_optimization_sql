/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция . Утилиты

  Описание скрипта: трассировка запроса  
*/

select * from v$parameter t where t.name like '%trace%';
-- /opt/oracle/diag/rdbms/xe/XE/trace

execute immediate 'alter session set timed_statistics=true';
execute immediate 'alter session set tracefile_identifier=''' || v_trace_file_name || '''';
execute immediate 'alter session set events ''10046 trace name context forever, level ' ||
                  g_diag_option.trace_level || '''';
execute immediate 'ALTER SESSION SET max_dump_file_size = ''' || g_trace_max_size || '''';
execute IMMEDIATE 'alter session set events ''10046 trace name context off''';


tkprof XE_ora_1686_ROWIDSCAN.trc XE_ora_1686_ROWIDSCAN.out sort=prsela,fchela,exeela


alter session set timed_statistics=true;
alter session set tracefile_identifier='FULL2';
--alter session set events '10046 trace name context forever, level 8';

begin
  dbms_monitor.session_trace_enable(waits => true); 
end;
/
select count(*) from  hr.employees$del;


--alter session set events '10046 trace name context off';
begin
  dbms_monitor.session_trace_disable();
end;
/

-- grant execute on dbms_monitor to hr;