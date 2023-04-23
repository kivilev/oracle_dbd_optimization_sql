/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: min max 
   
*/

---- Пример 1. Уникальный индекс с диапазоном -> Range index scan (min/max)
select min(t.employee_id)
  from hr.employees t
 where t.employee_id >= 170
 
---- Пример 2. Обычный индекс предикат равенство -> Range index scan (min/max)  
select min(t.department_id)
  from hr.employees t
 where t.department_id = 10;
 
