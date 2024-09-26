/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: демо table access full 
 
  alter system flush buffer_cache; -- сброс кэша данных (не выполнять в ПРОД!)
  alter system flush shared_pool; -- сброс shared пуля (не выполнять в ПРОД!)
*/
alter session set statistics_level = ALL;

---- 1. Параметр "количество блоков за 1 операцию ввода/вывода" (настраивают DBA)
select *
  from v$parameter t 
 where t.name = 'db_file_multiblock_read_count';

---- 2. Как выглядит FTS в плане
-- a) нет никаких предикатов
select * from hr.employees t;
-- б) есть индекс по полю "manager_id", но все равно использован FTS
select * from hr.employees t where t.manager_id = 1; -- индекс
select * from hr.employees t where t.manager_id > 1; -- FTS


select count(distinct t.manager_id) from hr.employees t;
107/18 = 0.06 = 6 строк


---- 3. Как FTS отображается в event'ах
-- создадим большую таблицу
drop table hr.employees$del;
create table hr.employees$del as
select t.* from hr.employees t, (select 1 from dual connect by level <= 100000);

-- count обязан дойти до hwm (~6 сек)
select count(*) from  hr.employees$del;

-- получаем sql_id запроса
select * from v$sql t where t.sql_text like '%hr.employees$del%';

-- информация по непосредственному выполнению запроса (квант 1с)
select t.sql_exec_id, t.event, t.sql_plan_operation, t.sql_plan_options, t.* 
  from v$active_session_history t
 where t.sql_id = 'fwb6hwhdsz3u6'
 order by t.sample_id;

-- execution-план (забавное отличие E-time и A-time)
select * from dbms_xplan.display_cursor(sql_id   => 'fwb6hwhdsz3u6',
                                        cursor_child_no => 1,
                                        format   => 'ADVANCED ALLSTATS LAST');

