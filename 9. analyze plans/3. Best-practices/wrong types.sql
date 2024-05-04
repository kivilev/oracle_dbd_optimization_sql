-- drop table del$1;
create table del$1(
  id varchar2(30 char),
  col1 varchar2(300 char),
  constraint del$1_pk primary key (id)
);

insert /*+ append */ into del$1
select level, lpad(level, 200, '_') from dual connect by level <= 10000;
commit;

---- не используется индекс по PK
select * from del$1 t where t.id = 11;

---- используется индекс по PK
select * from del$1 t where t.id = '11'

