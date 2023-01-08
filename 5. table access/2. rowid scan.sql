/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: демо rowid scan
 
  alter system flush buffer_cache; -- сброс кэша данных (не выполнять в ПРОД!)
  alter system flush shared_pool; -- сброс shared пуля (не выполнять в ПРОД!)
*/
alter session set statistics_level = ALL;

---- 1. Как выглядит Rowid scan в плане

-- 1) непосредственное обращение по rowid
select t.*, rowid from hr.employees t where t.rowid = chartorowid('AAAHgsAAEAAAADLAAD');

-- 2) индекс (unq) -> rowid
select /*rowid_idx*/ t.* from hr.employees t where t.employee_id = 1;

-- 3) индекс (не unq) -> rowid batched
select /*rowid_idx_batched*/ t.* from hr.employees t where t.department_id = 1;


-- получаем sql_id запроса
select * from v$sql t where t.sql_text like '%AAAHgsAAEAAAADLAAD%';
select * from v$sql t where t.sql_text like '%rowid_idx%';
select * from v$sql t where t.sql_text like '%rowid_idx_batched%';

select * from dbms_xplan.display_cursor(sql_id   => '82vxk74c1guas',
                                        cursor_child_no => 0,
                                        format   => 'ADVANCED ALLSTATS LAST');

