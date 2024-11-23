/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Соединения

  Описание скрипта: несколько JOIN в одном запросе
  
*/

---- Пример 1. Несколько таблиц
select e.*, d.department_name, j.job_title, jh.start_date
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id
  join hr.jobs j on j.job_id = e.job_id
  join hr.job_history jh on jh.job_id = j.job_id
 where e.employee_id = 100;



---- Пример 2. Указание порядка через leading
select /*+ use_nl(t d) leading(t d)*/
       t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where t.employee_id = 100;
 
select /*+ use_hash(t d) leading(t d)*/
       t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where t.employee_id = 100; 
 
 
---- Пример 3. В запросе могут быть разные методы соединения
-- почитаем шаги и посмотрим методы соединения
select department_name
      ,first_name
  from departments d
 cross join lateral (select e.first_name
                       from employees e
                      where e.department_id = d.department_id)
 order by 1, 2;
