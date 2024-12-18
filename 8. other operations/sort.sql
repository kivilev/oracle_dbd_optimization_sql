/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: операции сортировки (sort)
   
*/

---- Пример 1. SORT ORDER BY - обычная сортировка
select * from hr.employees t order by department_id;



---- Пример 2. SORT AGGREGATE - возврат одного значения - результат групповой функции
select count(*) cnt, max(t.employee_id) 
  from hr.employees t;

select min(t.employee_id) from hr.employees t;



---- Пример 3. SORT JOIN - использование в Merge join
select /*+ FULL(d) use_merge(e d)*/
       e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.department_id;


---- Пример 4. SORT GROUP BY - выдача результатов по группам
select  /*+ no_use_hash_aggregation */ count(*) cnt
  from hr.employees t 
 group by t.department_id; 



---- Пример 5. SORT UNIQUE - использование сортировки для получения уникальных значений

-- hash
select distinct t.department_id 
  from hr.employees t;

-- sort
-- execute immediate q'{alter session set optimizer_features_enable  = '10.1.0'}';-- откл HASH
-- или NO_USE_HASH_AGGREGATION 

select /*+ no_use_hash_aggregation */ distinct t.department_id 
  from hr.employees t;

select distinct t.country_name from hr.countries t;
  


----- Пример 6. HASH UNIQUE и HASH GROUP BY 
select distinct t.department_id from hr.employees t;
select count(*) cnt from hr.employees t group by t.department_id;


---- Hash vs Sort
create table t2 (id varchar2(30), amount number);
insert into t2 values ('A', 10);
insert into t2 values ('C',  5);
insert into t2 values ('B',  1);
insert into t2 values ('B',  2);
insert into t2 values ('A',  3);
insert into t2 values ('C',  1);
insert into t2 values ('A',  7);

select id, sum(amount)
  from t2
 group by id;

select id, ora_hash(id, 4), amount from t2;

