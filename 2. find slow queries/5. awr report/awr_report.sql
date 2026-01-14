/*
  Курс: Оптимизация Oracle SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://backend-pro.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск медленных запросов

  Описание: построение AWR-отчета
 
*/

-- grant execute on dbms_workload_repository to hr, kivi;

-- получаем список отчетов
select sysdate, t.* from dba_hist_snapshot t order by snap_id desc;

-- строим по отрезку отчет, лучще воспользоваться скриптом awr_reader.sql
select *
  from dbms_workload_repository.awr_report_html(l_dbid     => 2939488823,
                                                l_inst_num => 1,                                                
                                                l_bid => 5228,
                                                l_eid => 5229);
