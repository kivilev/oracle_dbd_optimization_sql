/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: статистика по колонкам таблиц
  
*/

---- 1) Статистика по колонке
select t.num_distinct, t.num_nulls, t.last_analyzed,
       t.sample_size, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';

---- 2) Эксперименты со статистикой
drop table demo$tab$stat;

-- вставка 1М - статистика собирается сразу (Oracle 12c и выше)
create table demo$tab$stat as
select level col1, 'sssss' col2, rpad('я',50,'ъ') col3, decode(mod(level,2), 0, 1) nullcol4
  from dual
connect by level <= 1000000;--1M

-- статистика по столбцам
select t.num_distinct, t.num_nulls, t.sample_size, t.last_analyzed,
       notes, t.histogram,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'DEMO$TAB$STAT'
   and t.owner = 'HR';
   
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


-- Вопрос. Как определить на основе статистики подходит ли колонка для использования в качестве лидирующего столбца для индекса?






---- Для секционированных таблиц
select * from all_part_col_statistics;
