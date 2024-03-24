/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание: секционирование
*/
drop table demo_payment_range;
drop table demo_country_list;
drop table demo_client_hash;

-- RANGE + interval
create table demo_payment_range(
  id number(20),
  payment_date date
)
partition by range (payment_date)
interval (interval '1' day)
(partition part_min values less than (to_date('01.01.2023','dd.mm.yyyy')));

insert into demo_payment_range 
 select level, trunc(sysdate) + level from dual connect by level <= 100;

select * from user_tab_partitions t where t.table_name = 'DEMO_PAYMENT_RANGE';

-- LIST
create table demo_country_list(
  id number(20),
  country_id varchar2(20 char)
)
partition by list(country_id)(
  partition country_uz values ('UZ'),
  partition country_gb values ('GB'),
  partition country_kz values ('KZ')
);

-- HASH
create table demo_client_hash(
  id number(20)
)
partition by hash (id) partitions 4;


---- Примеры планов

--- Случай 1. Попали только в одну секцию
-- Range single
select * from demo_payment_range t where t.payment_date = date'2023-01-15';

-- List single
select * from demo_country_list t where t.country_id = 'GB';

-- Hash single
select * from demo_client_hash t where t.id = 1000;


--- Случай 2. Выбрали несколько секций
-- Partition range iterator
select * from demo_payment_range t where t.payment_date between date'2023-01-15' and date'2023-01-20';

-- Partition list inlist
select * from demo_country_list t where t.country_id in('GB', 'UZ');

-- Partition hash inlist
select * from demo_client_hash t where t.id = 1000 or t.id = 2000


--- Случай 3. выбрали все секции
-- Partition range ALL
select * from demo_payment_range t;

-- Partition list ALL
select * from demo_country_list t;
select * from demo_country_list t where t.country_id in('GB', 'UZ', 'KZ');-- забавный случай, когда inlist, но по факту ALL

-- Partition hash ALL
select * from demo_client_hash t where t.id between 1000 and 1010;

