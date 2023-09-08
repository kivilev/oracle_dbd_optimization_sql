/*
   Построение AWR-отчета
*/

-- grant execute on dbms_workload_repository to hr, kivi;

-- получаем список отчетов
select * from dba_hist_snapshot t order by snap_id desc;

-- строим по отрезку отчет, лучще воспользоваться скриптом awr_reader.sql
select *
  from dbms_workload_repository.awr_report_html(l_dbid     => 2913690710,
                                                l_inst_num => 1,                                                
                                                l_bid => 229,
                                                l_eid => 230);
