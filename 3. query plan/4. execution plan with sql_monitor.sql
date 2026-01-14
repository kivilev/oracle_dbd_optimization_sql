/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: получение реального (execution) plan из Sql monitoing'a
 
*/

-- будем получать информацию для этого запроса - хинт monitor.
select /*my_query_mon1*/ /*+ monitor */count(*)
  from hr.employees
  cross join hr.employees
  cross join hr.employees
  cross join hr.employees;

select t.sql_id, t.sql_text from v$sqlarea t where t.sql_text like '%/*my_query_mon1*/%'; -- находим наш запрос



---- Пример 1. Данные в SGA (v$sql_monitor, dbms_sqltune или dbms_sql_monitor)

-- способ 1. по самому последнему запросу попавшему в мониторинг (не обязательно наш запрос)
select dbms_sqltune.report_sql_monitor(report_level => 'all', type => 'HTML') from dual;

-- способ 2. по самому последнему запросу в конкретной сессии (не обязательно наш запрос)
select dbms_sqltune.report_sql_monitor(session_id => 84, session_serial => 12735, report_level => 'all', type => 'HTML') from dual;

-- способ 3. по самому последнему запуску конкретного запроса sql_id (не обязательно наш запуск)
select dbms_sqltune.report_sql_monitor(sql_id => '81pwuwydjdpdn', report_level => 'all', type => 'HTML') from dual;

-- способ 4. конкретный запрос с конкретным началом выполнения (можно добавить в Detail в PL/SQL Developer)
select sysdate
       ,t.sql_exec_start
       ,sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'00000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_id => t.sql_exec_id, report_level => 'all', type => 'TEXT')
  from v$sql_monitor t
 where t.sid = 84 and t.session_serial# = 12735;

-- все три типа отчета 
select sysdate
       ,t.sql_exec_start
       ,sql_id 
       ,t.sql_text
       ,to_char(elapsed_time/1000000,'00000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'TEXT') text
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'HTML') html
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'ACTIVE') active
  from v$sql_monitor t
 where t.sql_id = '81pwuwydjdpdn'
   and t.sql_exec_start >= sysdate - 1/24/6;

---- Пример 2. Все запросы, которые выполнялись в сессии (SGA)
select m.sql_id
      ,m.sql_text
      ,m.username
      ,m.module
      ,m.action
      ,m.sid
      ,m.session_serial#
      ,(m.last_refresh_time - m.sql_exec_start)*24*60*60 sec
      ,dbms_sqltune.report_sql_monitor(sql_id => m.sql_id, sql_exec_id => m.sql_exec_id, type => 'HTML', report_level => 'ALL') AS report_html
      ,dbms_sqltune.report_sql_monitor(sql_id => m.sql_id, sql_exec_id => m.sql_exec_id, type => 'ACTIVE', report_level => 'ALL') as report_active
      ,dbms_sqltune.report_sql_monitor(sql_id => m.sql_id, sql_exec_id => m.sql_exec_id, type => 'TEXT', report_level => 'ALL') AS report_txt
 from  v$sql_monitor m
where m.sid = 84 
  and m.session_serial# = 12735
order by sql_exec_start desc;


---- Пример 3. Данные в AWR (dba_hist_reports, dbms_auto_report)
select t.session_id
      ,t.session_serial#
      ,(t.period_end_time - t.period_start_time)*60*60*24 sec
      ,t.key1 sql_id
      ,dbms_auto_report.report_repository_detail(rid => t.report_id, type => 'HTML') report_html
      ,dbms_auto_report.report_repository_detail(rid => t.report_id, type => 'ACTIVE') report_active
      ,dbms_auto_report.report_repository_detail(rid => t.report_id, type => 'TEXT') report_txt
  from dba_hist_reports t
 where t.session_id = 131
   and t.session_serial# = 30437
   and t.component_name = 'sqlmonitor';


---- Вкладка в PL/SQL Developer
select m.sql_text
      ,to_char(elapsed_time / 1000000, '00000.00') as elapsed_sec
      ,dbms_sqltune.report_sql_monitor(sql_id       => m.sql_id,
                                       sql_exec_id  => m.sql_exec_id,
                                       type         => 'HTML',
                                       report_level => 'ALL') as report_html
  from v$sql_monitor m
 where m.sid = :sid
   and m.session_serial# = :serial#
 order by sql_exec_start desc
