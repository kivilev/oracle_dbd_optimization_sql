/*
 Автоматическое снятие мониторинга (HR)
*/ 

---- Пример 1. > 5 секунд

-- выполняем запрос
select /*my query mon 1*/count(*)
  from hr.employees
  cross join hr.employees
  cross join hr.employees
  cross join hr.employees;

-- получаем SID, SERIAL текущей сессии
select sid, serial#
  from v$session
 where sid in (select sid from v$mystat where rownum <=1);

-- запросы в мониторинге
select key
       ,status, sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,t.*
  from v$sql_monitor t where t.sid = 50 and t.session_serial# = 15381
 order by t.report_id desc;

select * from v$sql_plan_monitor t where t.key =  25769807090;

---- существует 4е способа сформировать отчет:

-- способ 1. по самому последнему запросу попавшему в мониторинг (не обязательно наш запрос)
select dbms_sqltune.report_sql_monitor(report_level => 'all', type => 'HTML') from dual;

-- способ 2. по самому последнему запросу в конкретной сессии (не обязательно наш запроса_
select dbms_sqltune.report_sql_monitor(session_id => 50, session_serial => 15381, report_level => 'all', type => 'HTML') from dual;

-- способ 3. по самому последнему запуску конкретного запроса sql_id (не обязательно наш запуск)
select t.sql_id, t.sql_text from v$sqlarea t where t.sql_text like '%/*my query mon 1*/%'; -- находим наш запрос

select dbms_sqltune.report_sql_monitor(sql_id => '9q6jxpvnvk01b', report_level => 'all', type => 'HTML') from dual;

-- способ 4. конкретный запрос с конкретным началом выполнения (можно добавить в Detail в PL/SQL Developer)
select sysdate
       ,t.sql_exec_start
       ,sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'00000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'TEXT')
  from v$sql_monitor t
 where t.sid = 50 and t.session_serial# = 15381;
 
 
---- Пример 2. Хинт monitoring

-- выполняем запрос
select /*my query mon 2*/ /*+ monitor */count(*)
  from hr.employees;

-- запросы в мониторинге (может появиться не сразу)
select key
       ,status, sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,t.*
  from v$sql_monitor t where t.sid = 50 and t.session_serial# = 15381
 order by t.report_id desc;  



---- Пример 3. Parallel запросы

-- на примере системных запросов, выполняющихся параллельно
select sysdate
       ,t.sql_exec_start
       ,sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'HTML')
  from v$sql_monitor t
 where t.sid = 50 and t.session_serial# = 15381;
