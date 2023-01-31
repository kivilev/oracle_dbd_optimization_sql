/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 6. Индексный доступ

  Описание скрипта: демо различных видов индексов
*/

---- 1. Unique index scan

-- Уникальный индекс: EMP_EMP_ID_PK -> create unique index emp_emp_id_pk on employees(employee_id);
select * from hr.employees t where t.employee_id = 100;
select t.employee_id from hr.employees t where t.employee_id = 100;-- в чем разница

-- IN -> inlist iterator
select * from hr.employees t where t.employee_id in (100, 110);


---- 2. Range index scan

-- Не уникальный индекс: EMP_MANAGER_IX -> create index emp_manager_ix on employees (manager_id);

-- равенство
select * from hr.employees t where t.manager_id = 108;

-- диапазон
select * from hr.employees t where t.manager_id between 1 and 40;

-- in -> inlist iterator
select * from hr.employees t where t.manager_id in (108, 103, 102);

-- уникальный индекс, но range scan
select * from hr.employees t where t.employee_id between 100 and 110;

-- условия больше/меньше (меньше 5%) -> range scan
select * from hr.employees t where t.manager_id > 149;

-- условия больше/меньше (больше 5%) -> table access full
select * from hr.employees t where t.manager_id > 19;


-- index range scan descending
select * 
  from employees t
 where t.manager_id between 1 and 40
 order by t.manager_id desc;

-- нет шага с сортировкой (sort order by)
select * 
  from employees t
 where t.manager_id between 1 and 40
 order by t.manager_id;


---- 3. Index Skip Scan

-- Не уникальный индекс: EMP_NAME_IX -> create index emp_name_ix on employees (last_name, first_name);

select * 
  from hr.employees t
where t.first_name = 'Alexander';

-- 102 поддерева
select count(distinct t.last_name)
  from hr.employees t;


---- 4. Index Full Scan

-- нет доп шага с сортировкой
select t.employee_id from employees t order by t.employee_id; -- order by
select t.employee_id, count(1) from employees t group by t.employee_id; -- group by

-- оптимизатор решил ifs
select t.employee_id from employees t;


---- 5. Index Fast Full Scan

select /*+ index_ffs(t emp_name_ix)*/
 t.first_name
,t.last_name
  from employees t

create index emp_name_ix on employees (last_name, first_name)

---- 6. Index Join
select t.employee_id, t.first_name from employees t;


select min(t.employee_id) from employees t;
