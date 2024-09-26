/* 
   Course: Oracle SQL Optimization. Basic
   Author: Kivilev Denis
   
   Description: getting content of trace file
   using: 
   sqlplus connection_string @treader.sql file_name.trc
   
*/
set head off verify off echo off timi off termout off feedback off trimspool on
spool &1
COLUMN trace_line FORMAT OFF WRAPPED
select replace(replace(trim(payload),chr(13),''), chr(10),'') trace_line
from v$diag_trace_file_contents t
where t.trace_filename = '&1'
order by line_number;

spool off
