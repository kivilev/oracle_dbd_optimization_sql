/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 7. Соединения

  Описание скрипта: демо для cartesian join
  
*/

select e.employee_id
      ,d.department_name
  from hr.employees e, hr.departments  d
