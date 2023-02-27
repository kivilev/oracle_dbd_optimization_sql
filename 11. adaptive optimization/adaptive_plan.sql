/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. Адаптивная оптимизация запросов (Adaptive Query Optimization)

  Описание скрипта: примеры адаптивного плана
  
*/

select /* ao example */
 e.first_name
,e.last_name
,e.salary
,d.department_name
  from employees   e
      ,departments d
 where e.department_id = d.department_id
   and d.department_name in ('Marketing', 'Sales');


-- посмотреть адаптивный план
select * 
  from table(dbms_xplan.display_cursor(sql_id => 'cy47zfs7ubh0s', cursor_child_no => 0, format => 'ADAPTIVE LAST'));

select * 
  from table(dbms_xplan.display_cursor(sql_id => 'cy47zfs7ubh0s', cursor_child_no => 0, format => 'LAST'));


-- найти курсоры с адаптивными планами
select t.is_resolved_adaptive_plan, t.* 
  from v$sql t
 where t.is_resolved_adaptive_plan = 'Y'
   and t.parsing_schema_name = 'HR';-- какая-нибудь бизнесова схема
