/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 3. Оптимизатор

  Описание скрипта: снятие трассировки с оптимизатора при построении плана для демонстрации этапов построения запроса
  Запросы должны выполняться впервые или alter system flush shared_pool под SYS для сброса разделяемого пула (НЕ ДЕЛАТЬ В ПРОД СРЕДЕ!)
*/

-- НЕ ДЕЛАТЬ В ПРОД СРЕДЕ!
-- alter system flush shared_pool;

-- Пример 1. Устранение обращения к таблице departments в ходе трансформаций (показать план)
alter session set events '10053 trace name context forever';
alter session set tracefile_identifier='TRC2';

select t.first_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.first_name like 'Alex%';

alter session set events '10053 trace name context off';


-- Пример 2. Устранение невозможно, т.к. используется столбец department_name
alter session set events '10053 trace name context forever';
alter session set tracefile_identifier='PLAN_TRC_EXAMPLE2';

select t.first_name, d.department_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.first_name like 'Alex%';
 
alter session set events '10053 trace name context off';

----- c92qr9wm7utjm
select * from v$sqlarea t where t.sql_text like '%Alex%' order by t.last_load_time desc;
begin
  dbms_sqldiag.dump_trace(p_sql_id       => 'du0bk2up3htpq',
                          p_child_number => 0,
                          p_component    => 'Optimizer', --Valid values are "Optimizer" and "Compiler"
                          p_file_id      => 'PLAN_TRC_EXAMPLE1');
end;
/

--select * from dbms_xplan.display_cursor(sql_id => 'du0bk2up3htpq', format => 'ALLSTATS ADVANCED LAST');
