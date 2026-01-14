/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонус. Оптимизатор

  Описание скрипта: снятие трассировки с оптимизатора при построении плана для демонстрации этапов построения запроса
  Запросы должны выполняться впервые или alter system flush shared_pool под SYS для сброса разделяемого пула (НЕ ДЕЛАТЬ В ПРОД СРЕДЕ!)
*/

-- НЕ ДЕЛАТЬ В ПРОД СРЕДЕ!
-- call flush_all();

---- Пример 1. Устранение обращения к таблице departments в ходе трансформаций (показать план)
-- Файл с трассировкой - ORCLCDB_ora_559724_OPT_TRC_1.trc

alter session set events '10053 trace name context forever';
alter session set tracefile_identifier='OPT_TRC_1';

select t.first_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.first_name like 'Alex%';

alter session set events '10053 trace name context off';

-- в трейс файле: 810 стр - применение join elimination, 942 стр - запрос после трансформаций, 


---- Пример 2. Устранение невозможно, т.к. используется столбец department_name
alter session set events '10053 trace name context forever';
alter session set tracefile_identifier='OPT_TRC_2';

select t.first_name, d.department_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.first_name like 'Alex%';
 
alter session set events '10053 trace name context off';

---- Пример 3. Получение трейса оптимизатора для существующего запроса
select * from v$sqlarea t where t.sql_text like '%Alex%' order by t.last_load_time desc;
begin
  dbms_sqldiag.dump_trace(p_sql_id       => 'c92qr9wm7utjm',
                          p_child_number => 0,
                          p_component    => 'Optimizer', --Valid values are "Optimizer" and "Compiler"
                          p_file_id      => 'OPT_TRC_1_3');
end;
/

select * from dbms_xplan.display_cursor(sql_id => 'c92qr9wm7utjm', format => 'ALLSTATS ADVANCED LAST');
