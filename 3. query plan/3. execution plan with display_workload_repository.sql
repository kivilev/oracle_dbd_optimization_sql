/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: получение реального (execution) plan из AWR
 
*/

---- 1) Найдем какой-нибудь архивный запрос
select * 
  from DBA_HIST_SQLTEXT t 
 where (lower(t.sql_text) like '%hr%' or  lower(t.sql_text) like '%kivi%')
   and lower(t.sql_text) not like '%sys%';
 

---- 2) Получим его план запроса
select * 
  from dbms_xplan.display_workload_repository(sql_id => '3d236h8knyw1w' -- подставьте свой sql_id из шага 1
                                           --,plan_hash_value => <plan_hash_value> -- если у запроса несколько планов
                                             ,format => 'ADVANCED'); -- в AWR нет runtime-статистики по шагам (A-Rows, A-Time), поэтому ALLSTATS LAST не нужен
