/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 3. План запроса

  Описание скрипта: получение гипотетического(explain) plan
  
  В системе дб установлена таблица PLAN_TABLE:
  @$ORACLE_HOME/rdbms/admin/utlxplan.sql
  
*/

---- 1. Таблица PLAN_TABLE для сохранения результатов
select * from dba_objects t where t.object_name = 'PLAN_TABLE';
select * from dba_synonyms t where t.synonym_name = 'PLAN_TABLE';
select t.temporary, t.* from dba_tables t where t.table_name = 'PLAN_TABLE$';


---- 2. Команда explain plan + display
explain plan for 
select e.*, d.department_name
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id;

-- вывод плана
select * from dbms_xplan.display(format => 'ALL');


---- 3. Команда explain plan + select 
explain plan set statement_id = 'my_query' for 
select e.*
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id;

-- вывод плана
select id
      ,lpad(' ', 2 * (level - 1)) || operation operation
      ,options
      ,object_name
      ,object_alias
      ,position
  from plan_table
 start with id = 0
        and statement_id = 'my_query'
connect by prior id = parent_id
       and statement_id = 'my_query'
 order by id;

-- или 
select * from dbms_xplan.display(statement_id => 'my_query', format => 'ALL');


---- 4. IDE в своем интерфейсе используют те же запросы
В toad или в pl/sql developer (C:\Program Files\Dell\Toad for Oracle 12.6\SQLTracker)
