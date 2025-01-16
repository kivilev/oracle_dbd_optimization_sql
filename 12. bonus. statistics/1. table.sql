/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Статистика

  Описание скрипта: статистика по таблицам
  
*/

---- Пример 1. Статистика по таблице HR.EMPLOYEES
select t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';

-- в xxx_tables так же есть информация по статистике
select t.num_rows, t.blocks, t.avg_row_len,
       t.last_analyzed, t.*
  from all_tables t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';


---- Пример 2. CTAS + сборка статы
-- drop table demo$tab$stat;

-- вставка 1М - статистика собирается сразу (Oracle 12c и выше) -> посмотреть план (statistics gathering)
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
 


---- Пример 3. Устаревание статистики + сбор вручную
-- вставка 1K НЕ приведет к устареванию (STALE = NO)
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('я',50,'1') col3
  from dual
connect by level <=  1000;
commit;

-- стата
select sysdate, t.num_rows, t.stale_stats, t.last_analyzed
  from user_tab_statistics t
 where  t.table_name = 'DEMO$TAB$STAT';

-- вставка 100K приведет к устареванию (STALE = YES), но статистика ДО сбора не изменится
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('я',50,'1') col3
  from dual
connect by level <= 100000;
commit;

-- стата
select sysdate, t.num_rows, t.stale_stats, t.last_analyzed
  from user_tab_statistics t
 where  t.table_name = 'DEMO$TAB$STAT';

-- пример как неактуальная статистика влияет на план
-- посмотреть план после вставки -> столбец cardinality
select count(*) cnt from demo$tab$stat;

-- вызов сбора вручную -> посмотреть стат
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO$TAB$STAT');


---- Пример 4. Секционированные таблицы

drop table del$sale_hash;

create table del$sale_hash(
  sale_id      number(30) not null,
  customer_id  number(30) not null
) 
partition by hash(customer_id)
(partition p1, partition p2);

insert into del$sale_hash select level, level from dual connect by level <= 100; 
commit;

-- Для секционированных таблиц
select t.table_name, t.partition_name, t.num_rows, t.blocks, t.avg_row_len,
       t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_partitions t
 where table_owner = user
   and table_name = 'DEL$SALE_HASH';
   
select t.num_rows, t.* from all_tab_statistics t where t.table_name = 'DEL$SALE_HASH';-- and t.partition_name = 'P1';

-- собираем стату для 1й секции (смотрим)
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEL$SALE_HASH', partname => 'P1');

-- для другой
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEL$SALE_HASH', partname => 'P2');



