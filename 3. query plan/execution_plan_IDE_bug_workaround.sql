--- Вывод актуального плана выполнения (ОБХОД БАГА IDE)
begin
  dbms_output.enable();

  execute immediate 'alter session set statistics_level = ALL';
  --execute immediate q'{alter session set optimizer_features_enable  = '10.1.0'}';

  for test in (

               -- сюда вставляем запрос                 
               SELECT E.FIRST_NAME ,E.LAST_NAME ,E.SALARY ,D.DEPARTMENT_NAME FROM 
				HR.EMPLOYEES E ,HR.DEPARTMENTS D WHERE E.DEPARTMENT_ID = 
				D.DEPARTMENT_ID AND D.DEPARTMENT_NAME IN ('Marketing', 'Sales')
			   -------
               
               ) loop
    null;
  end loop;

  for x in (select p.plan_table_output from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS ADVANCED LAST -cost -bytes')) p) loop
    dbms_output.put_line(x.plan_table_output);
  end loop;
  rollback;
end;
/


/*
-- possible versions
19.1.0.1, 19.1.0, 18.1.0, 12.2.0.1, 12.1.0.2, 12.1.0.1, 11.2.0.4, 11.2.0.3, 11.2.0.2, 11.2.0.1, 11.1.0.7,
11.1.0.6, 10.2.0.5, 10.2.0.4, 10.2.0.3, 10.2.0.2, 10.2.0.1, 10.1.0.5, 10.1.0.4, 10.1.0.3, 10.1.0,
9.2.0.8, 9.2.0, 9.0.1, 9.0.0, 8.1.7, 8.1.6, 8.1.5, 8.1.4, 8.1.3, 8.1.0, 8.0.7, 8.0.6, 8.0.5, 8.0.4, 8.0.3, 8.0.0
*/