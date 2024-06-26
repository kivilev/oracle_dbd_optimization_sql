-- HR. OLTP vs DWH

-- Все кредиты одного клиента
drop table client;
drop table client_credit;

create table client(
 id number(30),
 fname varchar2(200 char),
 lname varchar2(200 char),
 bday  date,
 constraint client_pk primary key (id)
);
comment on table client is 'Table for example. You can delete it';

insert into client
select level, dbms_random.string('x', 10),  dbms_random.string('x', 10), add_months(trunc(sysdate), -12*18-mod(level,20)*12)
  from dual connect by level <= 100000;
commit;

create table client_credit(
 client_credit_id varchar2(50 char),
 client_id        number(30),
 create_dtime      date,
 constraint client_credit_pk primary key (client_credit_id)
);
comment on table client_credit is 'Table for example. You can delete it';

insert  /*+ append */  into client_credit
select sys_guid(),
       c.id,
       sysdate - mod(rownum, 1000) - mod(rownum, 24)/24
  from client c, (select level from dual connect by level <= 3);
commit;

call dbms_stats.gather_table_stats(ownname => user ,tabname => 'client_credit');
call dbms_stats.gather_table_stats(ownname => user ,tabname => 'client');

---- смотрим execution plan для запроса ДО
select * 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;


---- Фиксим проблему. Создаем индекс
create index client_credit_client_i on client_credit(client_id);

---- смотрим execution plan для запроса ПОСЛЕ
select /*+ index(cc client_credit_client_i) */* 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;

