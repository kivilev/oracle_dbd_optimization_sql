

---- Пример 
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

-- 4) добавим 10К строк на одну дату
insert into sale$del
select sale$del_pk.nextval, date'1999-12-31', 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- 
declare
  v date := date'1999-12-31';
  v_res number;
begin

   select count(t.sale_id) cnt_sale
  into v_res
    from sale$del t
   where t.order_date = v;

end;
/

declare
  v date := date'2020-01-03';
  v_res number;
begin

   select count(t.sale_id) cnt_sale
  into v_res
    from sale$del t
   where t.order_date = v;

end;
/   
 

select a.is_bind_sensitive, a.is_bind_aware, a.* from v$sqlarea a where a.sql_text like '%CNT_SALE%';

74k88msa38dz0

select * from dbms_xplan.display_cursor(sql_id => '74k88msa38dz0',cursor_child_no => 0, format => 'ADVANCED' );

select t.child_number, t.* from v$sql t where t.sql_id = '74k88msa38dz0';
select * from v$sql_shared_cursor t where t.sql_id = '74k88msa38dz0';


select * from v$sql_cs_histogram
where sql_id = '74k88msa38dz0';
 
select * from v$sql_cs_selectivity
where sql_id = '74k88msa38dz0';

select  child_number, 
bind_set_hash_value, 
peeked, 
executions, 
rows_processed, 
buffer_gets, 
cpu_time
from v$sql_cs_statistics
where sql_id = '74k88msa38dz0';
