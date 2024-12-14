/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: операции над множествами
  
*/

---- Пример 1. UNION ALL
select *
  from hr.employees e   
 where e.employee_id >= 180
 union all
select *
  from hr.employees e   
 where e.employee_id >= 200;

---- Пример 2. UNION
select *
  from hr.employees e   
 where e.employee_id >= 180
 union
select *
  from hr.employees e   
 where e.employee_id >= 200;

---- Пример 3. INTERSECT
select *
  from hr.employees e   
 where e.employee_id >= 180
 intersect
select *
  from hr.employees e   
 where e.employee_id >= 200;

---- Пример 4. MINUS
select *
  from hr.employees e   
 where e.employee_id >= 180
 minus
select *
  from hr.employees e   
 where e.employee_id >= 200;
