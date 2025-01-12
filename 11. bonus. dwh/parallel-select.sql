/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Секреты работы с DWH

  Описание скрипта: Пример использования параллельных запросов
*/

---- ѕример запроса
select /*+ parallel(4)*/ count(*) 
  from account;

explain plan for
select /*+ parallel(4)*/ count(*) 
  from account;  
select * from dbms_xplan.display();

-- ѕопробует выбрать автоматически DOP (степень параллелизма)
explain plan for
select /*+ parallel*/ count(*) 
  from account;  
select * from dbms_xplan.display();
