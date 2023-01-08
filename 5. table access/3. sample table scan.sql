/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: получение реального (execution) plan
 
  alter system flush buffer_cache; -- сброс кэша данных (не выполнять в ПРОД!)
  alter system flush shared_pool; -- сброс shared пуля (не выполнять в ПРОД!)
*/
alter session set statistics_level = ALL;

---- 1. Как выглядит sample scan
select t.*, rowid from hr.employees sample (10) t;

---- 2. Cоздадим большую таблицу
drop table hr.employees$del;
create table hr.employees$del as
select t.* from hr.employees t, (select 1 from dual connect by level <= 100000);

select /* sample_big */ count(*) from hr.employees$del sample (10) t;

-- получаем sql_id запроса
select * from v$sql t where t.sql_text like '%sample_big%';

-- информация по непосредственному выполнению запроса (квант 1с - нет)
select t.sql_exec_id, t.event, t.sql_plan_operation, t.sql_plan_options, t.* 
  from v$active_session_history t
 where t.sql_id = '61qjvdmnb7n57'
 order by t.sample_id;

select * from dbms_xplan.display_cursor(sql_id   => '61qjvdmnb7n57',
                                        cursor_child_no => 0,
                                        format   => 'ADVANCED ALLSTATS LAST');

