/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. Адаптивная оптимизация запросов (Adaptive Query Optimization)

  Описание скрипта: примеры адаптивной статистики
  
  alter system set optimizer_adaptive_statistics = true scope=both;  
*/

call flush_all();

-- адаптивная статистика (12c)
select * from v$parameter t where t.name = 'optimizer_adaptive_statistics';

-- dynamic sampling (11g)
select * from v$parameter t where t.name = 'optimizer_dynamic_sampling';


---- Пример 1. Динамическая статистика
drop  table del$tab;
create table del$tab(
 id number(10),
 v2 varchar2(200 char),
 v3 varchar2(200 char),
 v4 varchar2(200 char),
 v5 varchar2(200 char)
);

create index del$tab_i1 on del$tab(id);
create index del$tab_i2 on del$tab(v2);
create index del$tab_i3 on del$tab(v3);


insert into del$tab 
select level, level, level, level, level
  from dual
connect by level <= 100000;
commit;

select * from user_tab_statistics t where t.table_name = 'DEL$TAB';
-- call dbms_stats.gather_table_stats(user, 'DEL$TAB');

-- Уровни 5-9 увеличивают объем данных, используемых для Dynamic Sampling
-- alter session set optimizer_dynamic_sampling = 5; 
-- или
-- сбора статы с уровнем 5 с хинтом
select /*+ gather_plan_statistics dynamic_sampling(5)*/
        *
  from del$tab t
 where t.v2 like '32%' or t.v4 like '4%';

select * from v$sqlarea t where t.sql_fulltext like '%del$tab t%';

select * from dbms_xplan.display_cursor(sql_id => '40kqf9rudsf5u', cursor_child_no =>  0, format => 'ALLSTATS ALL LAST');





---- Пример 2. Re-optimization
call flush_all();

create or replace type t_number_array is table of number(38);
/

create or replace function get_numbers(p_rows in number) return t_number_array
  pipelined as
begin
  for i in 1 .. p_rows loop
    pipe row(i);
  end loop;
  return;
end;
/

create or replace function get_numbers2(p_rows in number) return t_number_array
  pipelined as
begin
  for i in 1 .. p_rows loop
    pipe row(i);
  end loop;
  return;
end;
/

-- Тестовый запрос. gather_plan_statistics - только для нас, чтобы было наглядней.

select /*+ gather_plan_statistics */ *
  from table(get_numbers2(1000)) t2
  join table(get_numbers(20)) t1 on value(t2) = value(t1);


select t.is_reoptimizable
      ,t.sql_text
      ,t.sql_id
      ,t.child_number
  from v$sql t
 where sql_text like '%get_numbers%' and sql_text not like '%v$sql%';

select t.use_feedback_stats
      ,t.reason
      ,c.sql_text
      ,c.plan_hash_value
      ,t.*
  from v$sql_shared_cursor t
  join v$sql c
    on c.child_address = t.child_address
 where t.sql_id = 'c8s3vw02f0h48';

select * from dbms_xplan.display_cursor(sql_id => 'c8s3vw02f0h48', cursor_child_no => 0, format => 'ALLSTATS ADVANCED'); 
select * from dbms_xplan.display_cursor(sql_id => 'c8s3vw02f0h48', cursor_child_no => 1, format => 'ALLSTATS ADVANCED'); 






---- 3. Директивы
select *
  from dba_sql_plan_directives d
  join dba_sql_plan_dir_objects ob on d.directive_id = ob.directive_id
 where ob.owner = 'KIVI'
   and d.created >= sysdate - 1;
