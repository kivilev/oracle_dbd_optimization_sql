/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: статистика коллекциям
  
*/

---- Пример 1. Использование коллекций

-- 1. Создание таблицы для демо
drop table credit;
create table credit
(
  id   number(38),
  col2 varchar2(200 char)
);
create unique index credit_ui on credit(id);

insert into credit select level, 'level' || level from dual connect by level <= 100000;  

call dbms_stats.gather_table_stats(ownname => user, tabname => 'credit');

-- 2. Создаем коллекцию
create or replace type t_ids is table of number(38);
/


-- 3. По умолчанию -   8168
explain plan for 
select count(1)
  from t_ids(1, 2222, 30000, 99999) t;
  
select * from dbms_xplan.display();


-- 4. Почему это плохо? 
-- до - hash join
explain plan for 
select d.*
  from t_ids(1, 2222, 30000, 99999) t
  join credit d on value(t) = d.id;

select * from dbms_xplan.display();

-- после - NL
explain plan for 
select /*+ cardinality(t 10)*/
       d.*
  from t_ids(1, 2, 3, 4) t
  join credit d on value(t) = d.id;

select * from dbms_xplan.display();



