/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция N. Поиск проблем

  Описание скрипта: статистика
*/

---- Создадим 2 таблички с данными 
-- drop table del$1;
create table del$1(
  id number(30),
  col1 varchar2(300 char),
  constraint del$1_pk primary key (id)  
);

insert /*+ append */ into del$1
select level, lpad(level, 200, '_') from dual connect by level <= 100000;
commit;

-- drop table del$2;
create table del$2(
  id number(30),
  col1 varchar2(300 char),
  constraint del$2_pk primary key (id)
);

insert /*+ append */ into del$2
select level, lpad(level, 200, '_') from dual connect by level <= 10;
commit;

---- соберем статистику
call dbms_stats.gather_table_stats(ownname => user, tabname => 'del$1');
call dbms_stats.gather_table_stats(ownname => user, tabname => 'del$2');

select t.num_rows, t.blocks, t.* from user_tab_statistics t where t.table_name in ('DEL$1', 'DEL$2') order by table_name;

---- получим план запроса из dbms_xplan.display_cursor (IDE)
select s.id, b.col1 from del$2 s join del$1 b on s.id = b.id;


---- вставим 100к строк
delete from del$2;
insert /*+ append */ into del$2
select level, lpad(level, 200, '_') from dual connect by level <= 100000;
commit;

---- смотрим повторно статистику -> ничего не изменилось
select t.num_rows, t.blocks, t.* from user_tab_statistics t where t.table_name in ('DEL$1', 'DEL$2') order by table_name;

-- соовтетственно, план аналогично остался тем же, изменилась A-стата (E = 10, A = 100K)
select s.id, b.col1 from del$2 s join del$1 b on s.id = b.id;

-- собираем и смотрим план
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEL$1', method_opt => 'FOR ALL COLUMNS SIZE AUTO');
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEL$2', method_opt => 'FOR ALL COLUMNS SIZE AUTO');

select s.id, b.col1 from del$2 s join del$1 b on s.id = b.id;


