/*
 Oracle wait events

*/

---- Пример 1. Всего ~2K ожиданий
select * from v$event_name order by name;


---- Пример 2. Ожидания "PL/SQL lock timer" и "library cache pin"
-- создадим процедуру
create or replace procedure del$demo
is
begin
  dbms_session.sleep(60); -- 1 минуту спит
end;
/

-- запускаем в sqplus hr/booble@clo-ora19ee-db1
call del$demo();

-- в текущей сессии пробуем перекомпилировать
alter procedure del$demo compile;

-- смотрим список сессий и колонки с ожиданием (скрин session_waits.png)




---- Пример 3.  Ожидания из трассировки (event_waits_example_ORCLCDB_ora_249489_EXAMPLE_SEQ_2.trc.txt)

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



---- показать на примере
declare
  v_client_id   client.client_id%type;
  v_client_data t_client_data_array := t_client_data_array(t_client_data(client_api_pack.c_first_name_field_id, 'John'),
                                                           t_client_data(client_api_pack.c_last_name_field_id, 'Smith'),
                                                           t_client_data(client_api_pack.c_birthday_field_id,
                                                                         '1982-01-21'),
                                                           t_client_data(client_api_pack.c_passport_series_field_id,
                                                                          dbms_random.string(opt => 'U', len => 4)),
                                                           t_client_data(client_api_pack.c_passport_number_field_id,
                                                                         dbms_random.string(opt => 'X', len => 6)),
                                                           t_client_data(client_api_pack.c_email_field_id,
                                                                         'email@email.com'),
                                                           t_client_data(client_api_pack.c_mobile_phone_field_id,
                                                                         '+' || trunc(dbms_random.value(19000000000, 19999999999))));
begin
  v_client_id := client_manage_pack.register_new_client(v_client_data);
  dbms_output.put_line(v_client_id);
end;
/

