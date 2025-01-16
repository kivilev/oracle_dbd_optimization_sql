/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Статистика

  Описание скрипта: статистика по индексам
  
*/

---- Пример 1. Статистика по крохотным индексам 

select t.blevel, t.leaf_blocks, t.distinct_keys
      ,t.avg_leaf_blocks_per_key leafblk_per_key
      ,t.avg_data_blocks_per_key datablk_per_key
      ,t.clustering_factor, t.num_rows, t.*
  from all_ind_statistics t
 where t.owner = 'HR'
   and t.table_name = 'EMPLOYEES';

-- почему num_rows разный? 107 и 106?
select count(*) cnt from hr.employees;
select count(*) cnt from hr.employees t where t.manager_id ... ;


---- Пример 2. Большая таблица

drop table sale_demo;
drop sequence sale_demo_pk;

create sequence sale_demo_pk;
create table sale_demo(
  sale_id      number(38),
  order_date   date not null,
  status       number(1)  
);

insert /*+ append */ into sale_demo
select sale_demo_pk.nextval
      ,date'2000-01-01' + mod(level, 10) order_date -- 10 уникальных дат
      ,mod(level, 2) status -- 2 уникальных статуса
  from dual connect by level <= 1000000;
commit;

create unique index sale_demo_uq on sale_demo(sale_id);
create index sale_demo_order_date_i on sale_demo(order_date);
create index sale_demo_status_i on sale_demo(status);

select * from sale_demo;

-- статистика по индекам таблицы 
select t.blevel, t.leaf_blocks, t.distinct_keys
      ,t.avg_leaf_blocks_per_key leafblk_per_key
      ,t.avg_data_blocks_per_key datablk_per_key
      ,t.clustering_factor, t.num_rows, t.*
  from all_ind_statistics t
 where t.owner = user
   and t.table_name = 'SALE_DEMO'
 order by index_name;

/*
Выводы:
1) SALE_DEMO_UQ: 
  - высота индекса - 2 (ок)
  - листьев - 2088 (ок)
  - всего значений (num_rows) - 1М
  - уникальных значений - 1М (distinct_keys = num_rows - очень хорошо)
  - 1 листовой блок нужен для получения данных (отлично)
  - 1 блок данных соответствует ключу индекса (отлично)
  - null значений нет

2) SALE_DEMO_ORDER_DATE_I
  - высота индекса - 2
  - листьев - 2653
  - всего значений (num_rows) - 1М
  - уникальных значений - 10 (1 distinct_keys = 10% от 1M = 100К строк на ключ, плохой индекс*)
  - 265 листовых блока нужно для получения данных по 1 ключу
  - 2832 блока данных соответствует ключу индекса
  - null значений нет
  
3) SALE_DEMO_STATUS_I
  - высота индекса - 2
  - листьев - 1883
  - всего значений (num_rows) - 1М
  - уникальных значений - 2 (1 distinct_keys = 50% от 1M = 500К строк на ключ, отвратительный индекс*)
  - 941 листовых блока нужно для получения данных по 1 ключу
  - 2832 блока данных соответствует ключу индекса
  - null значений нет  

 * - не учитывается IFFS, IFS  
*/

---- Пример 3. Важность уникальности(разнообразности) значений лидирующего столбца
-- доработать пример!
create index sale_demo_sale_id_status_i on sale_demo(sale_id, status);
create index sale_demo_status_sale_id_i on sale_demo(status, sale_id);


---- Пример 4. Фактор кластеризации

drop table sale_demo;

create table sale_demo(
  sale_id      number(38),
  order_date   date not null,
  status       number(1)  
);

-- 1 случай. Сортировка по id
insert /*+ append */ into sale_demo
select * from (
select level id
      ,date'2000-01-01' + mod(level, 10) order_date -- 10 уникальных дат
      ,mod(level, 2) status -- 2 уникальных статуса
  from dual connect by level <= 1000000)
  order by id;
commit;

create unique index sale_demo_uq on sale_demo(sale_id);
create index sale_demo_order_date_i on sale_demo(order_date);
create index sale_demo_status_i on sale_demo(status);

select * from sale_demo;

call dbms_stats.gather_table_stats(ownname => user, tabname => 'sale_demo');

-- статистика по индекам таблицы 
select t.blevel, t.leaf_blocks, t.distinct_keys
      ,t.avg_leaf_blocks_per_key leafblk_per_key
      ,t.avg_data_blocks_per_key datablk_per_key
      ,t.clustering_factor, t.num_rows, t.*
  from all_ind_statistics t
 where t.owner = user
   and t.table_name = 'SALE_DEMO'
 order by index_name;

select t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from user_tab_statistics t
 where  t.table_name = 'SALE_DEMO';


-- 2 случай. Сортировка по order_date
truncate table sale_demo;

insert /*+ append */ into sale_demo
select * from (
select level id
      ,date'2000-01-01' + mod(level, 10) order_date -- 10 уникальных дат
      ,mod(level, 2) status -- 2 уникальных статуса
  from dual connect by level <= 1000000)
  order by order_date;
commit;

call dbms_stats.gather_table_stats(ownname => user, tabname => 'sale_demo');

-- статистика по индекам таблицы 
select t.blevel, t.leaf_blocks
       ,t.clustering_factor, t.num_rows
      ,t.distinct_keys
      ,t.avg_leaf_blocks_per_key leafblk_per_key
      ,t.avg_data_blocks_per_key datablk_per_key
      , t.*
  from all_ind_statistics t
 where t.owner = user
   and t.table_name = 'SALE_DEMO'
 order by index_name;

select t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where  t.table_name = 'SALE_DEMO';


-- 3 случай. Неупорядоченное хранение в индексе (реверсивный индекс)
drop table sale_demo;
create table sale_demo(
  sale_id      number(38),
  order_date   date not null,
  status       number(1)  
);

insert /*+ append */ into sale_demo
select * from (
select level sale_id
      ,date'2000-01-01' + mod(level, 10) order_date -- 10 уникальных дат
      ,mod(level, 2) status -- 2 уникальных статуса
  from dual connect by level <= 1000000)
  order by sale_id;
commit;

call dbms_stats.gather_table_stats(ownname => user, tabname => 'sale_demo');

-- create index sale_demo_uq on sale_demo(sale_id);
create index sale_demo_reverse_i on sale_demo(sale_id) reverse;

-- статистика по индекам таблицы 
select t.blevel, t.leaf_blocks
       ,t.clustering_factor, t.num_rows
      ,t.distinct_keys
      ,t.avg_leaf_blocks_per_key leafblk_per_key
      ,t.avg_data_blocks_per_key datablk_per_key
      , t.*
  from all_ind_statistics t
 where t.owner = user
   and t.table_name = 'SALE_DEMO'
 order by index_name;

select t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where  t.table_name = 'SALE_DEMO';


-- Задание ДЗ (тест): дать на анализ индексы и в тесте нужно выбрать почему
