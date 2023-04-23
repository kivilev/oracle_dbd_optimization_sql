/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: гистограммы
  
*/

drop table sale$del;
drop sequence sale$del_pk;

create sequence sale$del_pk;
create table sale$del(
  sale_id      number(38), -- primary key,
  order_date   date not null,
  some_info    varchar2(200 char)
);
create index sale$del_i on sale$del(order_date);

---- Пример 1. Запросы с и без гистограмм

-- 1) Забиваем данными
insert into sale$del
select sale$del_pk.nextval, date'2000-01-01' + level, 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- 2) посмотрим статистику по колонкам --> пусто, стата еще не собиралась
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- 3) соберем статистику по таблице -> стата по колонкам появится. histogram -> NONE
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 

select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- 4) добавим 10К строк на одну дату
insert into sale$del
select sale$del_pk.nextval, date'1999-12-31', 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- 5) собираем стату и смотрим -> histogram -> NONE, т.к. еще ни разу не выполнялся запрос по столбу
call dbms_stats.gather_table_stats (user, 'sale$del');
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

---- Какой будет план у 2х запросов ДО и ПОСЛЕ построения гистограмм?

-- 1 строка
select *
  from sale$del t
 where t.order_date = date'2000-01-02';

-- 10К строк
select *
  from sale$del t
 where t.order_date = date'1999-12-31';
  
/*
-- посмотреть обращения можно здесь
select x.*, c.column_name
  from dba_objects t
  join sys.col_usage$ x on x.obj# = t.object_id
  join dba_tab_cols c on c.owner = t.owner and c.table_name = t.object_name and c.column_id = x.intcol#
where t.owner = 'HR' and t.object_name = 'SALE$DEL';
*/

---- Пример 2. Сбор статистики с указанием опций

-- все колонки, с авто выбором количества корзин
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 
-- все колонки, с ручным указанием количества корзин
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE 8');
-- конкретная колонка, с авто выбором количества корзин
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 2'); 

select *
  from sale$del t
 where t.sale_id = 1;

select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';
   
---- Пример 3. Проверим, что при соблюдении условия NDV < N buckets будет FREQUENCY-гистограмма
-- 1) пересоздадим таблицу

-- 2) добавим 100 строк
insert into sale$del(sale_id,
                     order_date,
                     some_info)
select sale$del_pk.nextval, date'2000-01-01' + level, 'some_info'||level 
  from dual connect by level <= 100; 
commit;

-- 3) выполним запрос к полю
select *
  from sale$del t
 where t.sale_id = 1;

-- 4) соберем стату с количеством корзин (254) > чем количество уникальных (100)
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 254'); 
   
-- 5) посмотрим тип гистограммы на столбце
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

---- Пример 4. Подробности про построенные гистограммы
-- 1) пересоздадим таблицу

-- 2) заполним данными 
insert into sale$del
select sale$del_pk.nextval, date'2000-01-01', 'some_info'||level 
  from dual connect by level <= 100; 
commit;

-- 3) выполним запрос к sale_id и соберем стату
select *
  from sale$del t
 where t.sale_id = 1;
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 5'); 

-- 4) посмотрим распределение по гистограмме
select * 
  from all_tab_histograms t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- 5) опять вставим 1000 c одинаковым ключем   
insert into sale$del
select 150, date'2000-01-01', 'some_info'||level 
  from dual connect by level <= 1000; 
commit;   

-- 6) соберем и проверим -> гистограмма перестроилась
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 5'); 
select * 
  from all_tab_histograms t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';
