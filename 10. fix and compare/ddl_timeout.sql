-- drop table del$1;
create table del$1(
  id number(30),
  col1 varchar2(300 char),
  constraint del$1_pk primary key (id)
);

-- вставка без commit
insert into del$1 values (100001, 'some_value');



