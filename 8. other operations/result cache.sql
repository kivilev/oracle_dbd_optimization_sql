/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: result cache

  grant execute on dbms_result_cache to hr;
*/

-- функция с 1сек засыпанием - для имитации тормозов
create or replace function sleep1sec return number
is
begin
  dbms_session.sleep(1);
  return 1; 
end;
/

-- сохранение и получение из кэша (дергаем несколько раз)
select /*+ result_cache */
 sleep1sec()
,t.first_name
  from hr.employees t
 where t.employee_id = 110;

-- будет выполняться долго, т.к. с такими результатами кэша еще нет 
select /*+ result_cache */
 sleep1sec()
,t.job_id
  from hr.employees t
 where t.employee_id = 101;


---- Информация по Result Cache
select dbms_result_cache.status() from dual;

begin
  dbms_result_cache.memory_report(detailed => true);
end;
/

-- можно взять объект из плана
select *
  from v$result_cache_objects t
 where t.cache_id = '74x2p8p7dqqx81b38c63hxk30f';


call dbms_result_cache.flush();

