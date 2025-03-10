/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поставка изменений

  Описание скрипта: DDL timeout
*/


-- drop table del$1;
create table del$1(
  id number(30),
  col1 varchar2(300 char),
  constraint del$1_pk primary key (id)
);

-- вставка без commit
insert into del$1 values (100001, 'some_value');

---- выполняем в другой сессии
alter session set ddl_lock_timeout = 60;

alter table DEL$1 rename column col1 to COL11;


