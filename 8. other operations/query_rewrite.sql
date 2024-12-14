/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: переписывание запроса

  grant create materialized view to hr;   
*/

-- создаем матвью с опцией переписывания запросов
create materialized view mv_employees_agg
build immediate
enable query rewrite --!
as
select t.department_id, count(*)
  from hr.employees t 
 group by t.department_id;

-- в плане подмена
select t.department_id, count(*)
  from hr.employees t 
 group by t.department_id; 

-- в плане подмена
select t.department_id, count(*)
  from hr.employees t   
 group by t.department_id
 having count(*) > 2;
 
-- нет подмены
select t.department_id, count(*)
  from hr.employees t 
 where t.department_id = 40
 group by t.department_id; 
