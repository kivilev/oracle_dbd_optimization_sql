/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: демо table access full 
 
  alter system flush buffer_cache; -- сброс кэша данных (не выполнять в ПРОД!)
  alter system flush shared_pool; -- сброс shared пуля (не выполнять в ПРОД!)
*/

---- 1. Параметр "количество блоков за 1 операцию ввода/вывода" (настраивают DBA)
select *
  from v$parameter t 
 where t.name = 'db_file_multiblock_read_count';

---- 2. Как выглядит FTS в плане

-- a) нет никаких предикатов + выбираются все столбцы
select * from hr.employees t;

-- б) есть индекс по полю "manager_id", но все равно использован FTS, т.к. выбирается > 15% строк
select * from hr.employees t where t.manager_id = 1; -- индекс
select * from hr.employees t where t.manager_id > 1; -- FTS

select count(distinct t.manager_id) from hr.employees t;
107/18 = 0.06 = 6 строк

-- в) указан хинт FULL, не смотря на подходящий индекс будет использован FTS
select /*+ FULL(t)*/ * from hr.employees t where t.manager_id = 1;

