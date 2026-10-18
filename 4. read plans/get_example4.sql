-- Пример из истории
select * 
  from dbms_xplan.display_workload_repository(sql_id => 'aruh7kzjq9htm'
                                             ,format => 'ADVANCED'); -- в AWR нет A-Rows/A-Time, ALLSTATS LAST не нужен
