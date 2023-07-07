/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Описание скрипта: необходимые гранты для пользователя для курса по оптимизации
  
*/

create role optimization_role;

grant select on v_$session to optimization_role;
grant select on v_$sql_plan to optimization_role;
grant select on v_$sql_plan_statistics to optimization_role;
grant select on v_$sql to optimization_role;
grant select on v_$sql_plan_statistics_all to optimization_role;

grant optimization_role to hr;

grant alter session to hr;
