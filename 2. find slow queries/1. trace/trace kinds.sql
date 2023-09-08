---- 1. Способы трассировки

---- Способ 1. Только в текущей сессии, параметры задать нельзя
alter session set sql_trace = true; -- самый урезанный вариант

alter session set sql_trace = false;


---- Способ 2. Только в текущей сессии, параметры задать можно
alter session set events '10046 trace name context forever, level 8'; -- waits
alter session set events '10046 trace name context forever, level 12'; -- waits + bind vars

alter session set events '10046 trace name context off';


---- Способ 3. Мощный пакет для трассировки любых сессий. Нужны доп гранты
-- grant execute on dbms_monitor to kivi, hr;
call dbms_monitor.session_trace_enable(client_id => 
call dbms_monitor.session_trace_enable( waits=>true, binds=>false);

call dbms_monitor.client_id_trace_disable(client_id=>'tim_hall');
-- call dbms_monitor.database_trace_enable(..);-- для всей БД. Так делать лучше не надо :)


---- Способ 4. 
-- grant execute on dbms_monitor to kivi, hr;
call dbms_system.set_sql_trace_in_session(sid => 123, serial# => 1234, sql_trace => true);
call dbms_system.set_sql_trace_in_session(sid => 123, serial# => 1234, sql_trace=> false);


---- Способ 5. 
-- grant execute on dbms_monitor to kivi, hr;
call dbms_system.set_ev(si=>123, se=>1234, ev=>10046, le=>8, nm=>'');

call dbms_system.set_ev(si=>123, se=>1234, ev=>10046, le=>0, nm=>'');


---- Способ 6. 
-- нужно установить пакет: @$ORACLE_HOME/rdbms/admin/dbmssupp.sql
-- дать гранты: grant execute on dbms_support to kivi, hr;
call dbms_support.start_trace_in_session(sid    => 123,
                                         serial => 12312,
                                         waits  => true,
                                         binds  => false);

call dbms_support.stop_trace_in_session(sid    => 123,
                                         serial => 12312);


---- Способ 7. Трассировка конкретного запрос
alter system set events 'sql_trace [sql:52zxnrrzr892y] bind=true, wait=true';

---- есть и другие.


--! открыть TOAD показать какая ф-я там используется.