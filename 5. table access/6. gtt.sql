/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: работа с временными таблицами 
*/

---- Пример 1. GTT
create global temporary table gtt_example (
    id number,
    description varchar2(100)
) on commit preserve rows;


insert into gtt_example (id, description)
select level
      ,'desc' || level
  from dual
connect by level <= 100;


explain plan for
  select * from gtt_example;

select * from table(dbms_xplan.display);


---- Пример 2. PTT

create private temporary table ora$ptt_example (
    id number,
    description varchar2(100)
) on commit drop definition;

insert into ora$ptt_example (id, description)
select level
      ,'desc' || level
  from dual
connect by level <= 100;


explain plan for
  select * from ora$ptt_example;

select * from table(dbms_xplan.display);