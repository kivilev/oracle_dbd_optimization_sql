/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Индексный доступ

  Описание скрипта: демо index skip scan
*/

---- Пример 1. Не задан лидирующий столбец
select * 
  from hr.employees t
where t.first_name = 'Alexander';

-- 102 поддерева
select count(distinct t.last_name)
  from hr.employees t;



---- Пример 2. Лидирующий столбец задан, но он низко кардинальный
-- создадим табличку аналог employees + пол

create table hr.employees_gender as
select rownum employee_id,
       t.first_name,
       t.last_name,
       t.email,
       t.phone_number,
       t.hire_date,
       t.job_id,
       t.salary,
       t.commission_pct,
       t.manager_id,
       t.department_id,
       decode(mod(rownum,2),0,'F','M') gender
  from hr.employees t, (select level from dual connect by level <= 100);

create index employees_gender_i on employees_gender(gender, employee_id);

call dbms_stats.gather_table_stats(ownname => user, tabname => 'employees_gender');

select /*+ index_ss(t employees_gender_i)*/ t.*
  from employees_gender t 
 where t.gender = 'M' and t.employee_id = 23;

  
