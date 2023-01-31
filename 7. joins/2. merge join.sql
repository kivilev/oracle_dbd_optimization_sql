/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 7. Соединения

  Описание скрипта: демо для sort merge join
  
*/

-- 1. Классический MJ.
-- 1 источник данных - full index scan (не требует сортировки)
-- 2 источник данных - требует sort join.
-- доп шаг для итоговой сортировки отсутствует, т.к. результат MJ отсортированный.
select e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.department_id;

-- не используем индекс для departments -> появляется SORT JOIN шаг для первого источника
-- FULL(d) - full table scan
-- use_merge - насильно заставляем использовать MJ, иначе будет hash join ибо он выгодней в данном случае
select /*+ FULL(d) use_merge(e d)*/
       e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.department_id;
 
-- неравенство, hash join не может примениться -> merge join. 
select /*+ FULL(d) use_merge(e d)*/
       e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id > d.department_id
 order by e.department_id; 
  
-- сортировка по-другому полю -> появляется доп шаг с сортировкой
select e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.first_name;
 
