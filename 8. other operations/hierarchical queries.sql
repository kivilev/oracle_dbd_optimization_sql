/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: иерархические запросы
  
*/


 select * 
   from dual e 
connect by level <= 10;


select * 
   from hr.employees e 
connect by prior e.employee_id = e.manager_id -- prior обязателен: связь "родитель -> потомок"
 start with e.manager_id is null; -- корень дерева; план: CONNECT BY NO FILTERING WITH START-WITH + TABLE ACCESS FULL



 