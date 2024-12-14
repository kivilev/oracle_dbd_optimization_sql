/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: filter
  
*/


---- Пример 1. Фильтрация по предикату
select *
  from (select department_id
              ,count(*) as emp_count
          from employees
         group by department_id) dept_summary
 where emp_count > 10;


---- Пример 2. Можно встретить в старых версиях оптимизатора

-- 19.1.0
alter session set optimizer_features_enable  = '19.1.0';

explain plan for 
select e.department_id
      ,sum(salary)
  from hr.employees e
 group by e.department_id
having sum(salary) > 100;

select * from dbms_xplan.display(); 
rollback;

-- изменение на старую версию 
alter session set optimizer_features_enable  = '11.2.0.2';

explain plan for 
select e.department_id
      ,sum(salary)
  from hr.employees e
 group by e.department_id
having sum(salary) > 100;

select * from dbms_xplan.display();
