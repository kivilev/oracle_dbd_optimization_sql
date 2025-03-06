/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск и анализ проблемных мест
  
  Описание скрипта: OLTP vs DWH. Пример OLTP-Запроса
   
*/


-- смотрим execution plan для запроса ДО
select * 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;


-- Фиксим проблему. Создаем индекс
create index client_credit_client_i on client_credit(client_id);

-- смотрим execution plan для запроса ПОСЛЕ
select /*+ index(cc client_credit_client_i) */* 
  from client c
  join client_credit cc on c.id = cc.client_id
where c.id = 1999;

