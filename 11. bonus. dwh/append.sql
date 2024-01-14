drop table del$account;
create table del$account(
  id number(38),
  sum number(38,2),
  calc_date date
);


-- обычная вставка
 insert into del$account 
 select level, 10, sysdate
   from dual 
connect by level <= 1000000;

-- вставка с append 
 insert /*+ append*/ into del$account 
 select level, 10, sysdate
   from dual 
connect by level <= 1000000;

--- показать обы запроса с использованием autotrace
set autotrace traceonly statistics;
-- redo size

