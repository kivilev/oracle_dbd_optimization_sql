/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Соединения

  Описание скрипта: демо для hash join
  
*/

---- Пример 1. Hash join
select /*+ use_hash(e d) no_index(e) */
       e.employee_id
      ,d.department_name
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id;


---- Пример 2. Соединение по неравенству невозможно
select /*+ use_hash(e d) no_index(e) */
       e.employee_id
      ,d.department_name
  from hr.employees e
  join hr.departments d on d.department_id > e.department_id;

