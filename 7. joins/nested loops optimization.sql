/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Соединения

  Описание скрипта: оптимизации nested loops для разных версий
  
  Про optimizer_features_enable https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/optimizer_features_enable.html  
*/


alter session set optimizer_features_enable  = '9.0.0';
--alter session set optimizer_features_enable  = '19.1.0.1';


explain plan set statement_id = 'my_query' for
select /*+ use_nl(e d) */d.department_name, e.last_name, d.department_id, e.department_id
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id
 where e.last_name like 'A%';


select * from dbms_xplan.display(statement_id => 'my_query', format => 'ALL');

rollback;
