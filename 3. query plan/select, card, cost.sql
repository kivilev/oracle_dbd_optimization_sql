/*
  Курс: Оптимизация Oracle SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://backend-pro.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. План запроса: селективность, кардинальность, стоимость

  Описание скрипта: три случая со слайда p115 (orders, 1M строк, индекс по status).
  Запрос везде select * - с select t.status индекс покрывающий,
  и план всегда INDEX FAST FULL SCAN без обращения к таблице.
  Статистику собираем ДО запроса, с гистограммой по status:
  без неё оптимизатор считает селективность как 1/NDV (для 2 статусов - 50%).
*/

drop table orders;

create table orders (
  order_id         number(19,0)      not null,
  status            varchar2(30)      not null,
  v2 varchar2(200),
  v3 varchar2(200),
 -- constraint orders_pk primary key (order_id),
  constraint orders_status_ck check (status IN ('NEW','PAID', 'PAID2', 'PAID3', 'CANCELLED', 'CANCELLED3', 'CANCELLED2'))
);
create index orders_status_i on orders(status);

---- Случай 1. CANCELLED - 10K из 1M (1%)
insert into orders
select level, 'NEW', lpad('1',200),lpad('2',200)  from dual connect by level <= 990000;
insert into orders
select level, 'CANCELLED', lpad('1',200),lpad('2',200)  from dual connect by level <= 10000;
commit;

call dbms_stats.gather_table_stats(ownname => user, tabname => 'orders', method_opt => 'for columns status size 254');

select * from orders t where t.status = 'CANCELLED';

---- Случай 2. CANCELLED - 400K из 1M (40%)
truncate table orders;

insert into orders
select level, 'NEW', lpad('1',200),lpad('2',200)  from dual connect by level <= 600000;
insert into orders
select 800000+level, 'CANCELLED', lpad('1',200),lpad('2',200)  from dual connect by level <= 400000;
commit;

call dbms_stats.gather_table_stats(ownname => user, tabname => 'orders', method_opt => 'for columns status size 254');

select * from orders t where t.status = 'CANCELLED';

---- Случай 3. 7 статусов поровну, по ~142K (14%)
-- статусы вставляются блоками один за другим, поэтому данные отсортированы по status
-- и фактор кластеризации индекса хороший (~ числу блоков таблицы): это влияет на выбор индекса
truncate table orders;

declare
  type t_list is table of varchar2(200);
  v_list t_list := t_list('NEW','PAID', 'PAID2', 'PAID3', 'CANCELLED', 'CANCELLED3', 'CANCELLED2');
begin
  for i in v_list.first..v_list.last loop
    insert into orders
    select level, v_list(i), lpad('1',200),lpad('2',200)  from dual connect by level <= 142857;
  end loop;
  commit;
end;
/

call dbms_stats.gather_table_stats(ownname => user, tabname => 'orders', method_opt => 'for columns status size 254');

select t.clustering_factor, t.num_rows from user_indexes t where t.index_name = 'ORDERS_STATUS_I';

select * from orders t where t.status = 'CANCELLED';
