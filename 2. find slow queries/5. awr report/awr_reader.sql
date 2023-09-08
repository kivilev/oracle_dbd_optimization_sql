/* 
   Course: Oracle SQL Optimization. Basic
   Author: Kivilev Denis
   
   Description: getting content of AWR-report
   
   using: 
   sqlplus connection_string @treader.sql dbid start_snp_id end_snp_id
   example: sqlplsu hr@oracle19ee @awr_reader.sql 2913690710 229 230
   
*/
set head off verify off echo off timi off termout off feedback off trimspool on
spool report.html
select trim(output)
  from dbms_workload_repository.awr_report_html(l_dbid     => &1,
                                                l_inst_num => 1,                                                
                                                l_bid => &2,
                                                l_eid => &3);

spool off
