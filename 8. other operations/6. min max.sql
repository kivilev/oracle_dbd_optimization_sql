/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: min max 
   
*/

---- 1. Ограничение результатов до 10
select *
  from hr.employees t
 where t.employee_id >= 170
   and rownum <= 10;

---- 2. Подзапрос обработает все записи, только потом count stop
select *
  from (select /*+ full(t)*/ *
          from hr.employees t
         where t.employee_id >= 160
         order by t.employee_id desc)
 where rownum <= 10
