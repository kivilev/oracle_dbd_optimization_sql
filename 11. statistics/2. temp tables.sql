/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: статистика по таблицам (временные и коллекции)
  
*/

---- Пример 1. Статистика по временным таблицам
-- 1) Создаем временную таблицу + данные
create global temporary table demo1_gtt
(
  id   number(38),
  col2 varchar2(200 char)
)
on commit delete rows;
--create unique index demo1_gtt_ui on demo1_gtt(id);

insert into demo1_gtt select level, 'level' || level from dual connect by level <= 100000;  
select * from demo1_gtt;

---- 2) Статистика по таблице

-- после вставки не будет никакой статистики (таблица)
select t.scope, t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where t.table_name = 'DEMO1_GTT'
   and t.owner = 'HR';

-- после вставки не будет никакой статистики (индекс)
select t.*
  from all_ind_statistics t
 where t.table_name = 'DEMO1_GTT'
   and t.owner = 'HR';
   
-- сбор статистики -> создаст строку с SCOPE = SESSION
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO1_GTT');


---- Пример 2. Демо хинта Cardinality
drop table demo1;
create table demo1
(
  id   number(38),
  col2 varchar2(200 char)
);
create unique index demo1_ui on demo1(id);

insert into demo1 select level, 'level' || level from dual connect by level <= 100000;  

call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO1');

select t.scope, t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where t.table_name = 'DEMO1'
   and t.owner = 'HR';

-- от изменения числа происходит выбор плана (по факту demo1_gtt - пустая)
explain plan for 
select /* + cardinality(g 800)*/g.col2, t.col2 
  from demo1_gtt g
  join demo1 t on t.id = g.id;
select * from dbms_xplan.display();



---- Пример 3. Коллекции
create or replace type t_ids is table of number(38);
/

select d.*
  from t_ids(1,2,3,4) t
  join demo1 d on value(t) = d.id;
  



