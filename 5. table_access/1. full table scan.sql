/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: получение реального (execution) plan
 
*/

select * from hr.employees t;

---- параметр "количество блоков за 1 операцию ввода/вывода" (настраивают DBA)
select *
  from v$parameter t 
 where t.name = 'db_file_multiblock_read_count';

---- как FTS отображается в event'ах
drop table hr.employees$del;
create table hr.employees$del as
select t.* from hr.employees t, (select 1 from dual connect by level <= 100000);

-- count обязан дойти до hwm, зна
select count(*) from  hr.employees$del;
select * from v$sql t where t.sql_text like '%hr.employees$del%';

select t.event,  t.* from v$active_session_history t where t.sql_id = 'fwb6hwhdsz3u6';


