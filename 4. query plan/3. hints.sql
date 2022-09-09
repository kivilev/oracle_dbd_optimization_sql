/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: демонстрация механики хинтов
 
*/

-- проход по индексу
select * 
  from hr.employees t 
 where t.department_id = 1;


-- Хинт через многострочный комментарий
select /*+ FULL(t)*/ * 
  from hr.employees t
 where t.department_id = 1;


-- Хинт через многострочный комментарий
select --+ FULL(t)
       * 
 from hr.employees t
where t.department_id = 1;

