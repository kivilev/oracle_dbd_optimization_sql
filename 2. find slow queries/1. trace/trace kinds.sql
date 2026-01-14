/*
  Курс: Оптимизация Oracle SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://backend-pro.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск медленных запросов

  Описание: запуск/остановка снятия трассировки
 
*/

------ Пример 1. Снятие в текущей сессии

---- Способ 1. Можно задать параметры
alter session set events '10046 trace name context forever, level 8'; -- waits
--alter session set events '10046 trace name context forever, level 12'; -- waits + bind vars

-- здесь функционал

alter session set events '10046 trace name context off';


---- Способ 2. Пакет dbms_session 
call dbms_session.session_trace_enable(waits => true, binds => false);

-- здесь функционал

call dbms_session.session_trace_disable();


---- Способ 3. Пакет dbms_monitor (нужны гранты на пакет)
-- grant execute on dbms_monitor to kivi, hr;
call dbms_monitor.session_trace_enable(waits => true, binds => false);

-- здесь функционал

call dbms_monitor.session_trace_disable();



---- Способ 4. Только в текущей сессии, параметры задать нельзя
-- устарел, не рекомендуется использовать -> dbms_monitor, dbms_session.
alter session set sql_trace = true;

-- здесь функционал

alter session set sql_trace = false;


------ Пример 2. Снятие в другой сессии

---- Способ 1. Пакет dbms_monitor (нужны гранты на пакет)
-- grant execute on dbms_monitor to kivi, hr;
call dbms_monitor.session_trace_enable(session_id => 22, serial_num => 212222, waits => true, binds => false);

call dbms_monitor.session_trace_disable(session_id => 22, serial_num => 212222);


---- Способ 2. Пакет dbms_support
-- нужно установить пакет: @$ORACLE_HOME/rdbms/admin/dbmssupp.sql
-- дать гранты: grant execute on dbms_support to kivi, hr;
call dbms_support.start_trace_in_session(sid => 22, serial => 212222, waits  => true, binds  => false);

call dbms_support.stop_trace_in_session(sid => 22, serial => 212222);


---- Способ 3. Автоматическое снятие трассировки при установке client_id в сессии
call dbms_monitor.client_id_trace_enable(client_id => 'some_spec_client', waits => true, binds => false);


call dbms_monitor.client_id_trace_disable(client_id=>'some_spec_client');

-- call dbms_session.set_identifier ('some_spec_client'); -- в клиенте дб установка идентификатора


---- Способ 4. Автоматическое снятие трассировки при появлении сервиса/модуля/определенного действия
call dbms_monitor.serv_mod_act_trace_enable(service_name => 'db1', module_name => 'my_module', 
                                            action_name => 'my_action', waits => true, binds => false);

call dbms_monitor.serv_mod_act_trace_disable(...);

/* в клиенте дб установка 
dbms_application_info.set_module
dbms_application_info.set_action
*/


---- Способ 5. В старых версиях Oracle
-- grant execute on dbms_system to kivi, hr;
call dbms_system.set_sql_trace_in_session(sid => 123, serial# => 1234, sql_trace => true);
call dbms_system.set_sql_trace_in_session(sid => 123, serial# => 1234, sql_trace=> false);


---- Способ 6. В старых версиях Oracle 
-- grant execute on dbms_system to kivi, hr;
call dbms_system.set_ev(si=>123, se=>1234, ev=>10046, le=>8, nm=>'');

call dbms_system.set_ev(si=>123, se=>1234, ev=>10046, le=>0, nm=>'');

---- есть и другие.


--! открыть TOAD показать какая ф-я там используется.

select t.sql_trace, t.sql_trace_waits, t.sql_trace_binds, t.* from v$session t where t.sid = 130;

