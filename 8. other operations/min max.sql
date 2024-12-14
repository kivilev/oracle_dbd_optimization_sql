/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: min max 
   
*/

---- Пример 1. Уникальный индекс с диапазоном -> Range index scan (min/max)
select min(t.employee_id)
  from hr.employees t
 where t.employee_id >= 170;
 

---- Пример 2. Обычный индекс предикат равенство -> Range index scan (min/max)  
select min(t.department_id)
  from hr.employees t
 where t.department_id = 10;
 

---- Пример 3. Уникальный индекс без предиката -> Index full scan (min/max)
select min(t.department_id)
  from hr.employees t;


---- Пример 4. Две функции агрегации выключают min/max
select min(t.department_id), max(t.department_id)
  from hr.employees t;
  

select min(t.department_id)
  from hr.employees t
union all  
select max(t.department_id)
  from hr.employees t    
