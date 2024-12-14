/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: Материализация результата
   
*/

---- Пример 1. Материализация результата
with t as (
select /*+ materialize */ * 
  from employees
)
select * from t;


---- Пример 2. Более одной материализации
with emps as (
select /*+ materialize */ *
  from employees
),
emps2 as (
select /*+ materialize */ *
  from emps
)
select * from emps2;
