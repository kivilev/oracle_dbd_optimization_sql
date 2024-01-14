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



----- Для PL/SQL Developer

select trim(ltrim(tmi_delta,'+000000000')) tm_delta
      ,t.sql_id
      ,q1.sql_text slow_sql
      ,t.sql_child_number child_no
      ,q1.version_count childs
      ,t.top_level_sql_id parent_sql_id
      ,topq.sql_text parent_sql
  from (select t.top_level_sql_id
               ,t.sql_child_number
               ,t.sql_id
               ,max(t.sample_time) - min(t.sample_time) tmi_delta
          from v$active_session_history t
         where t.session_id = :sid
           and t.session_serial# = :serial#
         group by t.sql_id
                  ,t.sql_child_number
                  ,t.top_level_sql_id) t
  left join v$sqlarea q1
    on q1.sql_id = t.sql_id
  left join v$sqlarea topq
    on topq.sql_id = t.top_level_sql_id
 order by tmi_delta desc
         ,top_level_sql_id
         ,t.sql_id