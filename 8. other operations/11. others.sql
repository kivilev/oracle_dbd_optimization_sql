/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: разные
  
*/

---- Пример 1. Load as select (создание таблицы)
create table ddd as
select * from dual;


---- Пример 2. Иерархические запросы
 select * 
   from dual e 
connect by level <= 10;

select * 
   from hr.employees e 
connect by e.employee_id = e.manager_id
 start with e.employee_id = 100;
 

---- Пример 3. Переписывание запроса
grant create materialized view to hr;

create materialized view mv_employees_agg
build immediate
enable query rewrite
as
select t.department_id, count(*)
  from hr.employees t 
 group by t.department_id;

select t.department_id, count(*)
  from hr.employees t 
 group by t.department_id 


---- Пример 4. INSERT/UPDATE/SELECT STATEMENT
insert into hr.departments
values (1, '111', 1, 2);

update hr.departments t set t.department_name = 'sdf'
 where t.department_id = 1;

select * from dual;

delete from hr.employees where 1 = 0;


---- Пример 5. Материализация результата
with t as (
select /*+ materialize */* 
  from employees
)
select * from t;


---- Пример 6. Аналитические функции
select sum(e.salary) over(order by e.employee_id)
      ,sum(e.job_id) over(partition by e.department_id order by e.employee_id)
      ,dense_rank() over(partition by e.first_name order by e.phone_number desc) as dense_rnk
      ,min(e.email) over(partition by e.first_name order by e.salary desc) as dense_rnk
  from hr.employees e


---- Пример 7. Секционирование
-- range
drop table sales_interval_1d;

create table sales_interval_1d(
  sale_id      number(30) not null,
  sale_date    date not null,
  region_id    char(2 char) not null,
  customer_id  number(30) not null
)
partition by range(sale_date) -- секционируем по дате
interval(numtodsinterval(1,'DAY')) -- интервал 1 день
(
partition pmin values less than (date '2005-01-01') -- одна секция за любой период
);

insert into sales_interval_1d(sale_id, sale_date, region_id, customer_id)
select level, sysdate + level- 20, level, level  from dual connect by level <= 10;
commit;

select * from sales_interval_1d t where t.sale_date >= sysdate -10;
select * from sales_interval_1d t where t.sale_date = sysdate -10;
select * from sales_interval_1d t;

-- list
create table sale_hash(
  sale_id      number(30) not null,
  sale_date    date not null,
  region_id    char(2 char),
  customer_id  number(30) not null
) 
partition by hash(customer_id)
partitions 4;

-- Вставка 10К записей
insert into sale_hash 
select level, sysdate+level, 'NY', level 
 from dual connect by level <= 16000;
commit; 

select * from sale_hash t where t.customer_id = 100;
select * from sale_hash t where t.customer_id in (100, 120);


---- Пример 8. STATISTICS COLLECTOR

select e.*, d.department_name
  from hr.employees   e
      ,hr.departments d
 where e.department_id = d.department_id
   and d.department_name in ('Marketing', 'Sales');






