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

-- 1 
insert into orders
select level, 'NEW', lpad('1',200),lpad('2',200)  from dual connect by level <= 990000; 
insert into orders
select level, 'CANCELLED', lpad('1',200),lpad('2',200)  from dual connect by level <= 10000; 
commit;

-- 2
truncate table orders;

insert into orders
select level, 'NEW', lpad('1',200),lpad('2',200)  from dual connect by level <= 600000; 
insert into orders
select 800000+level, 'CANCELLED', lpad('1',200),lpad('2',200)  from dual connect by level <= 400000; 
commit;

call dbms_stats.gather_table_stats(ownname => user, tabname => 'orders');

select t.status from orders t where t.status = 'CANCELLED';

-- 3
truncate table orders;

declare
  type t_list is table of varchar2(200);
  v_list t_list := t_list('NEW','PAID', 'PAID2', 'PAID3', 'CANCELLED', 'CANCELLED3', 'CANCELLED2');  
begin
  for i in v_list.first..v_list.last loop
    insert into orders
    select level, v_list(i), lpad('1',200),lpad('2',200)  from dual connect by level <= 142857;   
  end loop;  
end;
/
select t.status from orders t where t.status = 'CANCELLED';

call dbms_stats.gather_table_stats(ownname => user, tabname => 'orders');


