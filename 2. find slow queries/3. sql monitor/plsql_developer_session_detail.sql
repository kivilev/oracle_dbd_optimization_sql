/*
 Session detail
*/

select m.sql_text, status
          , to_char(elapsed_time / 1000000, '00.00') exec_min
          ,dbms_sqltune.report_sql_monitor(sql_id => m.sql_id, sql_exec_start => m.sql_exec_start, report_level => 'all', type => 'HTML')          
from  v$sql_monitor m
where m.sid = :sid and m.session_serial# = :serial#
order by m.first_refresh_time desc;
