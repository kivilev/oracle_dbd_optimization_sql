/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Секреты работы с DWH

  Описание скрипта: INSERT + APPEND
*/

drop table del$account;
create table del$account(
  id number(38),
  sum number(38,2),
  calc_date date
);

--- показать оба запроса с использованием autotrace (sqlplus): смотрим redo size
set autotrace traceonly statistics;

-- обычная вставка
 insert into del$account 
 select level, 10, sysdate
   from dual 
connect by level <= 1000000;
commit;

-- вставка с append 
 insert /*+ append*/ into del$account 
 select level, 10, sysdate
   from dual 
connect by level <= 1000000;
commit; -- после append до commit любое чтение таблицы в этой сессии дает ORA-12838

-- в ARCHIVELOG для LOGGING-таблицы redo при append почти не уменьшается (уменьшается undo)

