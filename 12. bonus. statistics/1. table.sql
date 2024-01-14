/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: статистика по таблицам
  
*/

---- 1) Статистика по таблице
select t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';



-- так же есть информация по статистике
select t.num_rows, t.blocks, t.avg_row_len,
       t.last_analyzed, t.*
  from all_tables t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';

---- 2) Эксперименты со статистикой
drop table demo$tab$stat;

-- вставка 1М - статистика собирается сразу (Oracle 12c и выше)
create table demo$tab$stat as
select level col1, 'sssss' col2, rpad('я',50,'ъ') col3
  from dual
connect by level <= 1000000;

-- статистика по таблице
select sysdate, t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from user_tab_statistics t
 where  t.table_name = 'DEMO$TAB$STAT';
 
-- truncate table DEMO$TAB$STAT;

-- вставка 1М -> статистика не собирается.
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('я',50,'1') col3
  from dual
connect by level <= 1000000;

-- вызов сбора вручную
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO$TAB$STAT');

-- вставка 1K НЕ приведет к устареванию (STALE = NO)
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('я',50,'1') col3
  from dual
connect by level <= 1000;

-- вставка 100K приведет к устареванию (STALE = YES)
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('я',50,'1') col3
  from dual
connect by level <= 100000;

-- пример как неактуальная статистика влияет на план
-- посмотреть план после вставки -> столбец cardinality
select count(*) cnt from demo$tab$stat;


-- Для секционированных таблиц
select  t.num_rows, t.blocks, t.avg_row_len,
        t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_partitions t
-- where table_owner = 'my_schema'
--   and table_name = 'my_table'
;

select t.* from all_tab_partitions t where t.;

select t.* from all_tab_statistics t where t.partition_name = 'SYS_P1262';

call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO_CLIENT_HASH', partname => 'SYS_P1262');


