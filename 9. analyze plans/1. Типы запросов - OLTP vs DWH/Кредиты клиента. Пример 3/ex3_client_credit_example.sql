-- Схема: HR
-- Средний возраст клиентов выданных кредитов за последний месяц

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

insert /*+ append */ into client
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

---- BEFORE
select round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= trunc(sysdate, 'mm');


---- Трансформация 1. Создаем индекс и смотрим как изменился план?

-- определяем сколько в месяц бывает кредитов
select trunc(cc.create_dtime, 'MM') mon
      ,count(*) cnt
  from client_credit cc
 group by trunc(cc.create_dtime, 'MM');

-- создаем индекс
create index client_credit_create_dtime_i on client_credit(create_dtime);

-- проверяем план
select /*+ index(cc client_credit_create_dtime_i)*/
       round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= trunc(sysdate, 'mm');

-- Выводы: снизилась нагрузка по чтениям за счет индекса.
-- Hash join как был так и остался. Создает доп нагрузку. Попробуем избавиться от него.


---- Трансформация 2. Хинтуем и смотрим план

select /*+ use_nl(c cc) leading(cc c) index(cc client_credit_create_dtime_i)*/round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= trunc(sysdate, 'mm');

