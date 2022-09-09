/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: сравнение планов между собой
 
*/

---- 1. Выполяем запросы
select e.first_name, d.department_name
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id
 where e.employee_id >= 120;

select e.first_name, d.department_name
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id
 where e.employee_id = 120;

---- 2. Ищем их sql_id
select sql_id
      ,sql_text
  from v$sql
 where sql_text like '%hr.employees%'
   and sql_text not like '%SQL_TEXT%'
 order by sql_id;

---- 3. Сраниванием через dbms_xplan.compare_plans
begin
  dbms_output.put_line(dbms_xplan.compare_plans(reference_plan    => cursor_cache_object('98b51385gyxv7', null),
                                                compare_plan_list => plan_object_list(cursor_cache_object('bdrjyah0y6kc5', null)),
                                                type              => 'TEXT',
                                                level             => 'TYPICAL',
                                                section           => 'ALL'));
end;
/
