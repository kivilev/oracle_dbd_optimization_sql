/*
 drop table del$account_summary;
*/


create table del$account_summary(
  currency_id number(4),
  sum number(38,2),
  calc_date date
);

-- alter session enable parallel dml;

-- 4 потока на получение данных, 4 на запись
insert /*+ append parallel(4) enable_parallel_dml */ into del$account_summary 
select currency_id, sum(acc.balance) sum, sysdate calc_date 
  from account acc
  group by acc.currency_id;


