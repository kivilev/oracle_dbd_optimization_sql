
/*
   Планы с IOT-таблицами
*/


drop table oblast;

create table oblast
(id           number(10),
 code         varchar2(20 char),
 description  varchar2(50 char)  not null, 
 constraint oblast_pk primary key (id)
)
organization index;

create index oblast_code_i on oblast(code);

insert into oblast
select level, 'code'||level, 'desc'||level 
  from dual connect by level <= 10000; 
commit;

select * from oblast t where t.id = 333;

select * from oblast t where t.code = 'code'||333;
