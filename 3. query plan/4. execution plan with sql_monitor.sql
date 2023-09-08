/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: получение реального (execution) plan из Sql monitoing'a
 
*/


---- 1) выполняем запрос > 5 секунд
select /*my query mon exec plan*/count(*)
  from hr.employees
  cross join hr.employees
  cross join hr.employees
  cross join hr.employees;


---- 2) Формируем отчет (взято из предыдущей лекции)

select t.sql_id, t.sql_text from v$sqlarea t where t.sql_text like '%/*my query mon exec plan*/%'; -- находим наш запрос

-- по самому последнему запуску конкретного запроса sql_id (не обязательно наш запуск)

select dbms_sqltune.report_sql_monitor(sql_id => '2t68nz1rk96p7', report_level => 'all', type => 'HTML') from dual;

-- способ 4. конкретный запрос с конкретным началом выполнения
select sysdate
       ,t.sql_exec_start
       ,sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'TEXT')
  from v$sql_monitor t
 where t.sql_id = '2t68nz1rk96p7'
   and t.sql_exec_start >= sysdate - 1/24;
 
