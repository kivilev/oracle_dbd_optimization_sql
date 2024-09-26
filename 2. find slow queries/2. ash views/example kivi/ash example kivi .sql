---- Пример. Использование ASH

/*
-- наш код, который мы исследуем
begin
  kivi.payment_check_pack.check_payment(p_payment_id => 5254221);
end;
/
*/

select * from payment;
call flush_all();

--! Не будем выполнять код. Используем предыдущий запуск, когда снимали трассировку

-- найдем по параметру из кода p_payment_id => 2688631 PL/SQL-код в кэше запросов SQL_ID нашего Pl/SQL_блока.
select * from v$sqlarea t where t.sql_text like '%5254221%';

-- его используем как входную точку top_level_sql_id = '9ccsww2absp5k'
select sysdate
      ,t.*
      ,obj.owner
      ,obj.object_name
  from v$active_session_history t
  join dba_objects obj on t.current_obj# = obj.object_id
 where t.top_level_sql_id = '0s361p0sckss1'
 order by t.sample_id;

-- в более удобном виде для анализа
select t.sql_id
      ,work_time
      ,s.sql_text
  from (select sql_id
              ,max(t.sample_time) - min(t.sample_time) work_time
          from v$active_session_history t
         where t.top_level_sql_id = '0s361p0sckss1'
         group by sql_id) t
  join v$sqlarea s
    on s.sql_id = t.sql_id
 order by work_time desc;
 
