/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поставка изменений

  Описание скрипта: Сборк статистики
*/

-- Тестовая таблица
drop table del$tab1;
create table del$tab1
(
  id   number,
  val1 number,
  val2 varchar2(1000),
  val3 varchar2(2000)
);

insert into del$tab1
select level id, level+level val1, rpad('1',1000,'_') val2, rpad('1',2000,'_') val3
  from dual connect by level <= 10000;

commit;

-- view для получения информации 
select * from all_tab_statistics t where t.table_name = 'DEL$TAB1';

-- сбор статистики по конкретной таблице
call dbms_stats.gather_table_stats(ownname => user, tabname =>  'DEL$TAB1');

-- view для получения информации
select * from all_tab_statistics t where t.table_name = 'DEL$TAB1';

