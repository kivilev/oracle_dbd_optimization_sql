-- Пример из истории
select * 
  from dbms_xplan.display_workload_repository(sql_id => 'aruh7kzjq9htm'
                                             ,format => 'ADVANCED ALLSTATS LAST');
