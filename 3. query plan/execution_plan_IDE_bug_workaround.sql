--- Вывод актуального плана выполнения (ОБХОД БАГА IDE)
begin
  dbms_output.enable();

  execute immediate 'alter session set statistics_level = ALL';


  for test in (

               -- сюда вставляем запрос                 
               SELECT E.FIRST_NAME ,E.LAST_NAME ,E.SALARY ,D.DEPARTMENT_NAME FROM 
				HR.EMPLOYEES E ,HR.DEPARTMENTS D WHERE E.DEPARTMENT_ID = 
				D.DEPARTMENT_ID AND D.DEPARTMENT_NAME IN ('Marketing', 'Sales')
			   -------
               
               ) loop
    null;
  end loop;

  for x in (select p.plan_table_output from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS ADVANCED LAST ADAPTIVE')) p) loop
    dbms_output.put_line(x.plan_table_output);
  end loop;
  rollback;
end;
/
