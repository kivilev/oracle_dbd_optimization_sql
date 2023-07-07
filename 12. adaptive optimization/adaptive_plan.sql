/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. Адаптивная оптимизация запросов (Adaptive Query Optimization)

  Описание скрипта: примеры адаптивного плана
  
*/

explain plan for 
select /* ao example */
 e.first_name
,e.last_name
,e.salary
,d.department_name
  from employees   e
      ,departments d
 where e.department_id = d.department_id
   and d.department_name in ('Marketing', 'Sales');
select * from dbms_xplan.

select * from v$sqlarea t where t.sql_fulltext like '%ao example%';

-- посмотреть адаптивный план
select * 
  from table(dbms_xplan.display_cursor(sql_id => 'awvww67f1qkdz', cursor_child_no => 0, format => 'ADAPTIVE LAST'));

select * 
  from table(dbms_xplan.display_cursor(sql_id => 'awvww67f1qkdz', cursor_child_no => 0, format => 'LAST'));


-- найти курсоры с адаптивными планами
select t.is_resolved_adaptive_plan, t.* 
  from v$sql t
 where t.is_resolved_adaptive_plan = 'Y'
   and t.parsing_schema_name = 'HR';-- какая-нибудь бизнесова схема
