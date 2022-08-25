/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 2. SQL-запросы

  Описание скрипта: примеры parent\child-курсоров, планы, причины изменения.

  Представления:
  https://docs.oracle.com/en/database/oracle/oracle-database/21/refrn/V-SQLAREA.html
  https://docs.oracle.com/en/database/oracle/oracle-database/21/refrn/V-SQL.html
*/

select t.*
  from v$sqlarea t
 where t.VERSION_COUNT > 1
   and t.parsing_schema_name = 'COMMON_IDENT';

-- sql с 1м child
select t.version_count, t.* from v$sqlarea t where t.sql_id = '4ywurr2rtn12r';
select t.child_number, t.plan_hash_value, t.* from v$sql t where t.sql_id = '4ywurr2rtn12r';

-- pl/sql
select t.version_count, t.* from v$sqlarea t where t.sql_id = 'gn7ug3w6dw39c';
select t.child_number, t.plan_hash_value, t.* from v$sql t where t.sql_id = 'gn7ug3w6dw39c';

select t.version_count, t.* from v$sqlarea t where t.sql_id = '49brvbdyc8132';
select t.child_number, t.plan_hash_value, t.* from v$sql t where t.sql_id = '49brvbdyc8132';
select * from v$sql_shared_cursor t where t.sql_id =  '4ywurr2rtn12r'




-- получаем план выполения с подробной статой.
select * 
  from table(dbms_xplan.display_cursor(sql_id => '49brvbdyc8132', cursor_child_no => 1,  format => 'ALLSTATS ADVANCED'));

select * from v$sql_plan t where t.sql_id = '4ywurr2rtn12r' and t.plan_hash_value = '455381491';

