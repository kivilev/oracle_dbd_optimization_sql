select * from v$session;

---- Пример 1. Активная история сеансов (v$active_session_history)

-- самая ранняя запись
select min(t.sample_time) from v$active_session_history t;

-- посмотреть вообще что есть в представлении
select * from v$active_session_history t order by  t.sample_id;

-- пример 
select *
  from v$active_session_history t
 where t.session_id = 38
   and t.session_serial# = 37774
 order by t.sample_id;

---- Пример 2. Архивная история сеансов (dba_hist_active_sess_history)

-- границы диапазона
select min(t.sample_time), max(t.sample_time) from dba_hist_active_sess_history t;

-- посмотреть вообще что есть в представлении
select * from dba_hist_active_sess_history t;

-- на примере 1 сессии, что происходило с запросами. в т.ч. посмотреть текст запроса
select *
  from dba_hist_active_sess_history t
 where t.session_id = 38
   and t.session_serial# = 37774
 order by t.sample_id;

select * from v$sqlarea t where t.sql_id = '5jvf84zg4c49n';


