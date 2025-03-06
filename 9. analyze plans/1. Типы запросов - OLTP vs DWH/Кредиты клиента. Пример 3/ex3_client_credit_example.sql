/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск и анализ проблемных мест
  
  Описание скрипта: OLTP vs DWH. Средний возраст клиентов выданных кредитов за последний месяц
   
*/

---- BEFORE
select round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= trunc(sysdate, 'mm');


---- Трансформация 1. Создаем индекс и смотрим как изменился план?

-- определяем сколько в месяц бывает кредитов
select trunc(cc.create_dtime, 'MM') mon
      ,count(*) cnt
  from client_credit cc
 group by trunc(cc.create_dtime, 'MM');

-- создаем индекс
create index client_credit_create_dtime_i on client_credit(create_dtime);

-- проверяем план
select /*+ index(cc client_credit_create_dtime_i)*/
       round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= trunc(sysdate, 'mm');

-- Выводы: снизилась нагрузка по чтениям за счет индекса.
-- Hash join как был так и остался. Создает доп нагрузку. Попробуем избавиться от него.


---- Трансформация 2. Хинтуем и смотрим план

select /*+ use_nl(c cc) leading(cc c) index(cc client_credit_create_dtime_i)*/round(avg(months_between(sysdate, c.bday)/12), 2) yrs
  from client c
  join client_credit cc on c.id = cc.client_id
 where cc.create_dtime >= trunc(sysdate, 'mm');

