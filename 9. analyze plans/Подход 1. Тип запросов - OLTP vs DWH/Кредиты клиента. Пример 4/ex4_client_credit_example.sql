-- Схема: HR
-- Средний возраст клиентов выданных кредитов за последний год помесячно

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

create table client(
 id number(30),
 fname varchar2(200 char),
 lname varchar2(200 char),
 bday  date,
 constraint client_pk primary key (id)
);
comment on table client is 'Table for example. You can delete it';

create table client_credit(
 client_credit_id varchar2(50 char),
 client_id        number(30),
 create_dtime      date,
 constraint client_credit_pk primary key (client_credit_id)
);
comment on table client_credit is 'Table for example. You can delete it';
create index client_credit_client_i on client_credit(client_id);

insert into client_credit
select sys_guid(),
       c.id,
       sysdate - rownum/24
  from client c, (select level from dual connect by level <= 3)
commit;

-- explain plan
explain plan for
select round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(sysdate, -12);

select * from dbms_xplan.display(format => 'ALL');

-- ресурсы
select /*+ monitor */round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(sysdate, -12);
 
select * from v$sqlarea t where t.sql_text like '%cc.create_dtime >= add_months(sysdate, -12)%' and t.sql_text like '%monitor%';
select dbms_sql_monitor.report_sql_monitor(sql_id => 'g96c8tg5t1xwm', type => 'HTML', report_level => 'ALL') from dual;


---- Трансформация 1. Создаем индекс и смотрим как изменился план?

-- кардинальность/селективность
select trunc(cc.create_dtime, 'MM') mon
      ,count(*) cnt
  from client_credit cc  
 group by trunc(cc.create_dtime, 'MM');

create index client_credit_create_dtime_i on client_credit(create_dtime);

-- explain plan
explain plan for
select round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(sysdate, -12);

select * from dbms_xplan.display(format => 'ALL');

-- ресурсы
select /*+ monitor */round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(sysdate, -12);

select dbms_sql_monitor.report_sql_monitor(sql_id => 'd1df3k7d34d97', type => 'HTML', report_level => 'ALL') from dual;

-- Выводы: снизилась нагрузка по чтениям за счет индекса. Hash join как был так и остался. Попробуем избавиться от него.

---- Трансформация 2. Хинтуем.

-- explain plan
explain plan for
select /*+ use_nl(c cc) leading(cc c)*/round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
where cc.create_dtime >= add_months(sysdate, -12);

select * from dbms_xplan.display(format => 'ALL');

-- ресурсы
select /*+ use_nl(c cc) leading(cc c) monitor*/round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(sysdate, -12);

select * from v$sqlarea t 
 where t.sql_text like '%round(avg(months_between(sysdate, c.bday)/12), 2)%' 
   and t.sql_text like '%use_nl(c cc) leading(cc c) monitor%';

select dbms_sql_monitor.report_sql_monitor(sql_id => '9km1dxntjyvvv', type => 'HTML', report_level => 'ALL') from dual;
