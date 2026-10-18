/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Соединения

  Описание скрипта: почему важно использовать правильный тип соединения
  
*/

drop table del$credits;
create table del$credits as select level credit_id, level client_id,  level value from dual connect by level <= 1000000; --1M

alter table del$credits modify credit_id not null;
alter table del$credits add constraint del$credits_pk primary key (credit_id);
create index del$credits_client_id on del$credits(client_id);

call dbms_stats.gather_table_stats(ownname => user, tabname => 'del$credits');


---- Пример 1. Классика. Коллекция + JOIN c другой таблицей
-- нужен тип t_numbers (см. 5. table access/4. collections.sql)
-- card + hash join :(
select * 
  from t_numbers(1, 1000, 2000) cl -- ID клиентов
  join del$credits cr on value(cl) = cr.client_id;  -- кредиты

-- исправление: подсказываем реальную кардинальность коллекции -> nested loops по индексу del$credits_client_id
select /*+ cardinality(cl 3) use_nl(cl cr) */ * 
  from t_numbers(1, 1000, 2000) cl -- ID клиентов
  join del$credits cr on value(cl) = cr.client_id;  -- кредиты
 
 
