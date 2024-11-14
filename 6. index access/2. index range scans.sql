/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Индексный доступ

  Описание скрипта: демо index range scan
*/

---- Пример 1. IRS на не уникальном индексе
-- emp_manager_ix -> create index emp_manager_ix on employees (manager_id);

-- равенство
select * from hr.employees t where t.manager_id = 108;

-- диапазон
select * from hr.employees t where t.manager_id between 1 and 40;

-- in -> inlist iterator
select * from hr.employees t where t.manager_id in (108, 103, 102);



---- Пример 2. IRS на уникальном индексе
select * from hr.employees t where t.employee_id between 100 and 110;




---- Пример 3. Пороговые значения при использовании индекса

-- предикат отбирает меньше 15% строк -> range scan
select * from hr.employees t where t.manager_id > 149;

-- предикат отбирает больше 15% строк -> table access full
select * from hr.employees t where t.manager_id > 19;



---- Пример 4. Нет шага с сортировкой (sort order by)

-- нет
select * 
  from employees t
 where t.manager_id between 1 and 40
 order by t.manager_id;

-- есть
select * 
  from employees t
 where t.manager_id between 1 and 40
 order by t.salary;
