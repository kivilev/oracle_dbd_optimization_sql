/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 7. Соединения

  Описание скрипта: демо для nested loops join
  Про optimizer_features_enable https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/optimizer_features_enable.html
*/

---- 1. 1 - unique index scan; 2 - full table scan (всего 107 строк)
select t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where d.department_id = 50;

---- 2. Более классический пример: 1 - unique index scan; 2 - index range scan
select /*+ index(t emp_department_ix)*/t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where d.department_id = 50;

---- 3. Отличный пример применения: 1 и 2 - unique index scan
select t.*, d.department_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.employee_id = 100;

-- то же, но по-другому
select /*+ use_nl(t d) leading(t d)*/
       t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where t.employee_id = 100;


---- 4. Анти пример
select /*+ use_nl(t d) */t.*, d.department_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id;

---- 5. Несколько JOIN в одом запросе

select e.*, d.department_name, j.job_title, jh.start_date
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id
  join hr.jobs j on j.job_id = e.job_id
  join hr.job_history jh on jh.job_id = j.job_id
 where e.employee_id = 100;

---- 6. Оптимизации nested loops для разных версий

alter session set optimizer_features_enable  = '9.0.0';
--alter session set optimizer_features_enable  = '19.1.0.1';


explain plan set statement_id = 'my_query' for
select d.department_name, e.last_name, d.department_id, e.department_id
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id
 where e.last_name like 'A%';


select * from dbms_xplan.display(statement_id => 'my_query', format => 'ALL');

rollback;




