drop table del$demo1;

create table del$demo1(
  id number,
  v2 varchar2(100 char)
);

-- установка размера таблицы
call dbms_stats.set_table_stats(ownname => user, tabname => 'del$demo1', numrows => 1000000); 

-- свойства изменились
select t.num_rows, t.* from user_tables t where t.table_name = 'DEL$DEMO1';

-- explain plan -> cardinality
select count(*) cnt from del$demo1;

----- Экспорт\ипорт статистики
-- создаем таблицу для экпорта статы
call dbms_stats.create_stat_table(ownname => user, stattab => 'MY_STAT_TAB');
-- экспортируем
call dbms_stats.export_table_stats(ownname => user, tabname => 'del$demo1', stattab => 'MY_STAT_TAB', statid => 'st1');

-- поменяем количество в табличке
select t.*, rowid from my_stat_tab t;

-- импортируем
call dbms_stats.import_table_stats(ownname => user, tabname => 'DEL$DEMO1', stattab => 'MY_STAT_TAB', statid => 'st1');

-- свойства изменились
select t.num_rows, t.* from user_tables t where t.table_name = 'DEL$DEMO1';
