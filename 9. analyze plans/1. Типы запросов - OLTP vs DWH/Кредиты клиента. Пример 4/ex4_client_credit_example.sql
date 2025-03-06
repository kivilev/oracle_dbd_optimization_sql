-- Схема: HR
-- Средний возраст клиентов выданных кредитов за последний год помесячно


---- Пример 1. Данные за 9 месяцев предыдущего года
select /*+ full(cc) use_hash(c cc) */round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(trunc(sysdate,'YYYY'), -12)  
   and cc.create_dtime < add_months(trunc(sysdate,'YYYY'), -3);

-- выводы: ничего не сделать. выбираем много данных - hash, fts.

---- Пример 2. данные за первый месяц предыдущего года
select /*+ index(cc client_credit_create_dtime_i) use_nl(c cc) */round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(trunc(sysdate,'YYYY'), -12)  
   and cc.create_dtime < add_months(trunc(sysdate,'YYYY'), -11);
   
-- план такой же. но количество в Actual rows = 9300. можно попробовать сделать индекс по дате и захинтоваться.
create index client_credit_create_dtime_i on client_credit(create_dtime);

select /*+ use_nl(c cc) leading(cc c) index(cc client_credit_create_dtime_i) */round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= add_months(trunc(sysdate,'YYYY'), -12)  
   and cc.create_dtime < add_months(trunc(sysdate,'YYYY'), -11);

-- выводы: для начала года индекс эффективен

