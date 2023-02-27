/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: result cache
   
*/

-- функция с 1сек засыпанием
create or replace function sleep1sec return number
is
begin
  dbms_session.sleep(1);
  return 1; 
end;
/

-- сохранение и получение из кэша (дергаем несколько раз)
select /*+ result_cache */
       sleep1sec(),
       t.first_name
  from hr.employees t 
 where t.employee_id = 110;
 
-- будет выполняться долго, т.к. с такими результатами кэша еще нет 
select /*+ result_cache */
       sleep1sec(),
       t.job_id
  from hr.employees t 
 where t.employee_id = 110;


-- статус RC
select dbms_result_cache.status() from dual;

begin dbms_result_cache.Memory_Report(detailed => true); end;
