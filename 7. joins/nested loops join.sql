/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Соединения

  Описание скрипта: демо для nested loops join
  
*/


---- Пример 1. Более классический пример: 1 - unique index scan; 2 - index range scan
select t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where d.department_id = 60;



---- Пример 2. Отличный пример применения: 1 и 2 - unique index scan
select t.*, d.department_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.employee_id = 100;



---- Пример 3. Ничего страшного. 1 - unique index scan; 2 - full table scan (всего 107 строк)
select /*+ FULL(t)*/t.*, d.department_name
  from hr.departments d
  join hr.employees t on d.department_id = t.department_id
 where d.department_id = 50;


