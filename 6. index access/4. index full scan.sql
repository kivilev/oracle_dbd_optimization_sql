/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Индексный доступ

  Описание скрипта: демо index full scan
*/

---- Пример 1. Устраняется дополнительный шаг с сортировкой
select t.employee_id 
  from hr.employees t 
 order by t.employee_id; -- order by

select t.employee_id, count(1) 
  from hr.employees t 
 group by t.employee_id; -- group by


---- Пример 2. Использование столбцов, которых нет в индексе

-- использует IFS, даже если в индексе нет столбца для результатов
select t.employee_id, t.salary 
  from hr.employees t 
 order by t.employee_id; -- order by

-- не использует индекс, т.к. manager_id нет в индексе EMP_EMP_ID_PK: нужен доступ к таблице, и FTS + SORT дешевле
select t.employee_id
  from hr.employees t 
 where t.manager_id > 170
 order by t.employee_id; -- order by

