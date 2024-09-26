
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
