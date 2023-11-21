-- HR. OLTP vs DWH

-- Все кредиты одного клиента

create table client(
 id number(30),
 fname varchar2(200 char),
 lname varchar2(200 char),
 bday  date,
 constraint client_pk primary key (id)
);
comment on table client is 'Table for example. You can delete it';

insert into client
select level, dbms_random.string('x', 10),  dbms_random.string('x', 10), add_months(sysdate - level, -18*12)
  from dual connect by level <= 10000;
commit;

create table client_credit(
 client_credit_id varchar2(50 char),
 client_id        number(30),
 create_dtime      date,
 constraint client_credit_pk primary key (client_credit_id)
);
comment on table client_credit is 'Table for example. You can delete it';

insert into client_credit
select sys_guid(),
       c.id,
       sysdate - rownum/24
  from client c, (select level from dual connect by level <= 3)
commit;

-- explain plan
explain plan for
select * 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;

select * from dbms_xplan.display(format => 'ALL');

select * 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;

select * from v$sqlarea t where t.sql_text like '%c.id = 1999%' and t.sql_text like '%monitor%';
select dbms_sql_monitor.report_sql_monitor(sql_id => '74mrq15c3qccf', type => 'HTML') from dual;


---- Фиксим проблему. Создаем индекс
create index client_credit_client_i on client_credit(client_id);

explain plan for
select * 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;
select * from dbms_xplan.display(format => 'ALL');

select /*+ monitor */* 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;

select * from v$sqlarea t where t.sql_text like '%c.id = 1999%' and t.sql_text like '%monitor%';
select * from v$sql t where t.sql_id = '74mrq15c3qccf';
select dbms_sql_monitor.report_sql_monitor(sql_id => '74mrq15c3qccf', type => 'HTML') from dual;


