/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Секреты работы с DWH

  Описание скрипта: Пример использования параллельных DDL операций
*/

/*
 drop table del$account_summary;
 drop index terrorist_birhday_last_name_i;
*/


---- Пример 1. CTAS
create table del$account_summary(
  currency_id,
  sum,
  calc_date
) parallel 4 -- 4 потока на чтение и 4 на запись
as
select currency_id, sum(acc.balance) sum, sysdate calc_date 
  from account acc
  group by acc.currency_id;
  
-- смотрим степень параллелизма
select t.degree, t.* from user_tables t where t.table_name = 'DEL$ACCOUNT_SUMMARY';

-- автоматически подтягивается параллели в запрос
select * from del$account_summary t;


-- убирем параллелизм
alter table del$account_summary noparallel;

-- проверям
select t.degree, t.* from user_tables t where t.table_name = 'DEL$ACCOUNT_SUMMARY';




---- Пример 2. Создание индекса
-- drop index terrorist_birhday_last_name_i;

-- создаем индекс в параллелях
create index terrorist_birhday_last_name_i on terrorist(birthday, last_name) parallel 4; -- 4 потока на чтение и 4 на запись

-- смотрим степень параллелизма
select t.degree, t.* from user_indexes t where t.index_name = 'TERRORIST_BIRHDAY_LAST_NAME_I';

-- убираем параллелизм
alter index terrorist_birhday_last_name_i noparallel;
-- проверяем
select t.degree, t.* from user_indexes t where t.index_name = 'TERRORIST_BIRHDAY_LAST_NAME_I';


---- Пример 3. Параметры отвечающие за настройку параллелизма
select * from v$parameter t where t.name like '%parallel%' or t.name like '%cpu%';
