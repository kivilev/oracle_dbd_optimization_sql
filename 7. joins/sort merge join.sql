/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Соединения

  Описание скрипта: демо для sort merge join
  
*/

---- Пример 1. Соединение merge join
-- не используем индекс для departments -> появляется SORT JOIN шаг для первого источника
-- FULL(d) - full table scan
-- use_merge - насильно заставляем использовать MJ, иначе будет hash join ибо он выгодней в данном случае
select /*+ FULL(d) use_merge(e d)*/
       e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id;



---- Пример 2. Исключение сортировки первого множества
-- 1 источник данных - full index scan (не требует сортировки)
-- 2 источник данных - требует sort join.
-- доп шаг для итоговой сортировки отсутствует, т.к. результат MJ отсортированный.
select e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.department_id;


 
---- Пример 3. Merge join отлично работает с неравенствами
select /*+ FULL(d) use_merge(e d)*/
       e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id > d.department_id
 order by e.department_id; 
  
 

---- Пример 4. Экономим на сортировке 
 
-- сортировка не по предикату соединения -> появляется доп шаг с сортировкой
select e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.first_name;

-- сортировка по предикату соединения -> нет доп шага с сортировкой
select e.*
      ,d.*
  from hr.employees   e
  join hr.departments d on e.department_id = d.department_id
 order by e.department_id; 
