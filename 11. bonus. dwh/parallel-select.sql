
---- Пример запроса
select /*+ parallel(4)*/ count(*) 
  from account;

explain plan for
select /*+ parallel(4)*/ count(*) 
  from account;  
select * from dbms_xplan.display();

-- Попробует выбрать автоматически DOP (степень параллелизма)
explain plan for
select /*+ parallel*/ count(*) 
  from account;  
select * from dbms_xplan.display();
