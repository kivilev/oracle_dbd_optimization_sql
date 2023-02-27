/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: filter
  
*/


execute immediate q'{alter session set optimizer_features_enable  = '10.1.0'}';
-- 18.1.0

select e.department_id, sum(salary)
  from hr.employees e   
 group by e.department_id   
 having  sum(salary) > 100
