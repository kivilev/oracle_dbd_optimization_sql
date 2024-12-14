/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: Адаптивная оптимизация - STATISTICS COLLECTOR
*/


explain plan for
select e.*, d.department_name
  from hr.employees   e
      ,hr.departments d
 where e.department_id = d.department_id
   and d.department_name in ('Marketing', 'Sales');

-- показывает финальный план
select * from dbms_xplan.display(format => 'ALL');

-- показывает отброшенные шаги
select * from dbms_xplan.display(format => 'ALL ADAPTIVE');