/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск и анализ проблемных мест
  
  Описание скрипта: OLTP vs DWH. Пример DWH-Запроса
   
*/

---- Нормальная ситуация для DWH - hash + fts
select trunc(c.bday, 'YYYY'), count(*)
  from client c
  join client_credit cc on c.id = cc.client_id
 group by trunc(c.bday, 'YYYY');

---- ОШИБКА. Используем неправильный тип соединения - NL 
select /*+ use_nl(c cc)*/trunc(c.bday, 'YYYY'), count(*)
  from client c
  join client_credit cc on c.id = cc.client_id
 group by trunc(c.bday, 'YYYY');

