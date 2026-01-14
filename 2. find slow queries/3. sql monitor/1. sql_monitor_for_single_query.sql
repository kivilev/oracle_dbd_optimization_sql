/*
  Курс: Оптимизация Oracle SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://backend-pro.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск медленных запросов

  Описание: SQL-мониторинг
 
*/

---- Пример 1. Запросы в мониторинге - SGA
select key
       ,status, sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,t.*
  from v$sql_monitor t 
 where t.sid = 84 and t.session_serial# = 21495
 order by t.report_id desc;
 
select * from v$sql_plan_monitor t where t.key =  987842487379;



---- Пример 2. Исторические запросы в мониторинге - AWR
select * from dba_hist_sqltext t where t.sql_text like '%kivi.payment_check_pack.check_payment%';

select t.sql_id, t.sample_time - t.sql_exec_start time_delta, t.*
  from dba_hist_active_sess_history t
 where t.top_level_sql_id = 'agz15yj3kb4c9'
 order by t.sample_id;

select m.session_id
      ,m.session_serial#
      ,(m.period_end_time - m.period_start_time)*60*60*24 exec_sec
      ,m.key1 sql_id
      ,'---'
      ,m.*
  from dba_hist_reports m
 where m.session_id = 84
   and m.session_serial# = 21495
--   m.key1 = '52zxnrrzr892y'
   and m.component_name = 'sqlmonitor';


---- Пример 2. Хинт monitoring

-- выполняем запрос
select /*my query mon 2*/ /*+ monitor */count(*)
  from hr.employees;

-- запросы в мониторинге (может появиться не сразу)
select key
       ,status, sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,t.*
  from v$sql_monitor t where t.sid = 51 and t.session_serial# = 50626
 order by t.report_id desc;  



