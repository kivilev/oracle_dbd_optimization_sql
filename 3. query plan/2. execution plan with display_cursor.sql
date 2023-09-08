/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: получение реального (execution) plan
 
*/

---- 1) Подготовка
-- выполняем запрос
select /* my_plan_example */e.*, d.department_name
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id;

-- ищем его sql_id
select t.sql_id, t.child_number, t.*
  from v$sql t where t.sql_text like '%my_plan_example%';


---- 2) Примеры форматирования

select * from dbms_xplan.display_cursor(sql_id          => '7s4ujcxm6dq0r',
                                        format          => 'TYPICAL');
                                        
select * from dbms_xplan.display_cursor(sql_id          => '7s4ujcxm6dq0r',
                                        cursor_child_no => 0,                                                           
                                        format          => 'ALL');

select * from dbms_xplan.display_cursor(sql_id          => '7s4ujcxm6dq0r',
                                        cursor_child_no => 0,                                                           
                                        format          => 'ADVANCED');

-- можно убирать некоторые блоки через "-НАЗВАНИЕ" (PREDICATE, COST, BYTES, ROWS, NOTE, PARTITION, PARALLEL, QBREGISTRY...)
select * from dbms_xplan.display_cursor(sql_id          => '7s4ujcxm6dq0r',
                                        cursor_child_no => 0,                                                           
                                        format          => 'ALL -PREDICATE -COST');
                                        

---- 3) Вывод плана со статистикой выполнения
-- alter session set statistics_level = all;

-- запускаем несколько раз
select /*+ gather_plan_statistics */ e.first_name, d.department_name
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id;

-- ищем его sql_id
select t.sql_id, t.child_number, t.*
  from v$sql t
 where t.sql_text like '%gather_plan_statistics%' and t.sql_text like '%hr.employees e%';

-- план без статы 
select * from dbms_xplan.display_cursor(sql_id          => 'arapcvy9qnncb',
                                        cursor_child_no => 0,                                                           
                                        format          => 'ADVANCED');

-- стата для всех запусков (ALLSTATS + ALL)
select * from dbms_xplan.display_cursor(sql_id          => 'arapcvy9qnncb',
                                        cursor_child_no => 0,                                                           
                                        format          => 'ADVANCED ALLSTATS ALL');

-- стата для последнего (ALLSTATS + LAST)                               
select * from dbms_xplan.display_cursor(sql_id          => 'arapcvy9qnncb',
                                        cursor_child_no => 0,                                                           
                                        format          => 'ADVANCED ALLSTATS LAST');


---- 4) IDE вносит много мусора, поэтому нижний подход не будет работать (обход проблем с IDE)
-- sqlplus vs ide

select 123 from dual, dual;
select * from dbms_xplan.display_cursor();
                                        

