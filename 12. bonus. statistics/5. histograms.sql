/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Статистика

  Описание скрипта: гистограммы
  
*/

drop table sale$del;

create table sale$del(
  sale_id      number(38),
  order_date   date not null,
  some_info    varchar2(200 char)
);
create index sale$del_i on sale$del(order_date);


---- Пример 1. Использование гистограм

-- Забиваем данными. Order_date равномерно заполняется.
insert into sale$del
select level, date'2000-01-01' + level, 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- соберем статистику по таблице -> стата по колонкам появится. histogram -> NONE
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 

-- посмотрим статистику по колонкам
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- добавим 10К строк на '1999-12-31' -> будет перекос данных  (data skew)
insert into sale$del
select level+10000, date'1999-12-31', 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- собираем стату и смотрим -> histogram -> NONE, т.к. еще ни разу не выполнялся запрос по столбу
call dbms_stats.gather_table_stats (user, 'sale$del');
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';


---- Планы запросов без построения гистограмм (не выполнять запросы!)
-- 1 строка -> Index RS (смотрим план)
select count(*)
  from sale$del t
 where t.order_date = date'2000-01-02';
 
-- 10К строк -> Index RS - ошибка! выбирается же > 15% строк таблицы (смотрим план)
select count(*)
  from sale$del t
 where t.order_date = date'1999-12-31'; 

-- выполним запрос 1й, собирем статистику заново, смотрим
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 

-- посмотрим статистику по колонкам -> histogram HYBRID
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';


-- 1 строка -> Index RS (смотрим план) - OK 
select count(*)
  from sale$del t
 where t.order_date = date'2000-01-02';

-- 10К строк -> Index FFS - OK
select count(*)
  from sale$del t
 where t.order_date = date'1999-12-31';
 


---- Пример 2. Поведение с Bind-переменными (peeked binds + адаптивные курсоры)
-- call flush_all();

declare
 v_date2 date := date'2000-01-02';
 v_date1 date := date'1999-12-31'; 
 v_cnt  number;
begin
  select /*+ gather_plan_statistics*/ count(*)
    into v_cnt
    from sale$del t
   where t.order_date = v_date1;
   
   select /*+ gather_plan_statistics*/ count(*)
    into v_cnt
    from sale$del t
   where t.order_date = v_date2;   
end;
/

select * from v$sqlarea t where t.sql_fulltext like '%SALE$DEL%';

select t.child_number, is_bind_sensitive, is_bind_aware, t.* 
  from v$sql t where t.sql_id = 'gmghjfw5xfsqq';

select * from v$sql_shared_cursor t where t.sql_id = 'gmghjfw5xfsqq';


-- доп инфа по курсорам чувствительным к Bind-переменным
select * from v$sql_cs_histogram
where sql_id = 'gmghjfw5xfsqq';

select * from v$sql_cs_selectivity
where sql_id = 'gmghjfw5xfsqq';

select * from dbms_xplan.display_cursor(sql_id => 'gmghjfw5xfsqq', cursor_child_no => 2, format => 'ADVANCED ALLSTATS' );




  
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
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE AUTO'); 

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
