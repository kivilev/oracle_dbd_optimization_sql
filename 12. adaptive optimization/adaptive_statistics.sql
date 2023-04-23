/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. Адаптивная оптимизация запросов (Adaptive Query Optimization)

  Описание скрипта: примеры адаптивной статистики
  
*/

---- 1. Пример 
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

-- некий запрос со сложными предикатами -> трудно точно предуагадать -> E-rows будет отличаться от A-rows (показывать с выводом плана)
select /*+ GATHER_PLAN_STATISTICS */
        *
  from del$tab t
  join del$tab t2 on t.id = t2.id and t2.v5 like '%999%'                 
 where t.id between 1000 and 3000 or t.v2 like '32%'
    or t.v4 like '46%';

-- после первого выполнения будет child-курсор с Y в use_feedback_stats
select t.use_feedback_stats, t.reason, c.sql_text, c.plan_hash_value
  from v$sql_shared_cursor t
  join v$sql c on c.child_address = t.child_address
 where t.sql_id = '6nux4b64radqu';

-- после повторного выполнения будет E-rows = A-rows + в Note: statistics feedback used for this statement


---- 2. Поиск запросов с уточненной статистикой

-- поиск запросов с ReOptimize
select t.is_reoptimizable, t.*
  from v$sql t
 where t.is_reoptimizable = 'Y' and t.parsing_schema_name = 'SOME_USER';

-- все child-курсоры кокретного запроса
select t.is_reoptimizable, t.child_number, t.*
  from v$sql t 
 where t.sql_id = '9aky80d5as5yp' order by t.child_number;

-- причины изменения
select * 
  from v$sql_shared_cursor t
 where t.sql_id = '9aky80d5as5yp';


---- 3. Директивы
select *
  from dba_sql_plan_directives d
  join dba_sql_plan_dir_objects ob on d.directive_id = ob.directive_id
 where ob.owner = 'HR'
   and d.created >= sysdate - 10
