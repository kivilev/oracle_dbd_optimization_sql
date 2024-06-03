/*
 Oracle wait events

 Author: Kivilev D.S.
*/

---- Пример 1. Всего ~2K ожиданий
select * from v$event_name order by name;
select t.wait_class, count(*) from v$event_name t group by t.wait_class order by 2 desc;



---- Пример 2. Ожидания "PL/SQL lock timer" и "library cache pin"
-- создадим процедуру
create or replace procedure del$demo
is
begin
  dbms_session.sleep(60); -- 1 минуту спит
end;
/

-- запускаем в sqlplus
call del$demo();

-- в текущей сессии пробуем перекомпилировать
alter procedure hr.del$demo compile;

-- смотрим список сессий и колонки с ожиданием (скрин session_waits.png)


---- Пример 3. Снятие трассировки, ожидания в отчете
alter session set timed_statistics = true;
alter session set tracefile_identifier = 'WAIT_TRC';
alter session set events '10046 trace name context forever, level 8';

-- полезная нагрузка
call dbms_session.sleep(5);

select * from dual;

call dbms_session.sleep(5);
--

alter session set events '10046 trace name context off';

-- tkprof name1.trc name1.trc.txt sort=prsela,fchela,exeela sys=no




---- Пример 4. Трассировочные файлы

-- Трассировочный файл ORCLCDB_ora_2830885_REGISTER_NEW_CLIENT_d4.trc.txt
-- Трассировочный файл event_waits_example_ORCLCDB_ora_249489_EXAMPLE_SEQ_2.trc.txt


Elapsed times include waiting on following events:
  Event waited on                             Times   Max. Wait  Total Waited
  ----------------------------------------   Waited  ----------  ------------
  PGA memory operation                           78        0.00          0.00
  Disk file operations I/O                        5        0.00          0.00
  control file sequential read                   21        0.00          0.00
  datafile move cleanup during resize             1        0.00          0.00
  Data file init write                           66        0.00          0.05
  direct path sync                                1        0.26          0.26
  db file single write                            1        0.00          0.00
  control file parallel write                     3        0.00          0.00
  DLM cross inst call completion                  1        0.00          0.00
  buffer busy waits                               1        0.11          0.11
  log file switch completion                      2        0.02          0.03
  log file sync                                   1        0.01          0.01
  SQL*Net message to client                       1        0.00          0.00
  SQL*Net message from client                     1        0.20          0.20
********************************************************************************

select *
  from V$EVENT_NAME t
 where t.name = 'db file single write';
 
-- Описание ожидания
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/descriptions-of-wait-events.html#GUID-99DA16ED-FB60-4589-BCBB-29E6AD13E084

