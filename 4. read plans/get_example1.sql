--- Вывод актуального плана выполнения (ОБХОД БАГА IDE)
begin
  dbms_output.enable();
  execute immediate 'alter session set statistics_level = ALL';

  --execute immediate q'{alter session set optimizer_features_enable  = '10.1.0'}';
 
  for test in (
               -------------
               -- сюда вставляем запрос  
               -------------
				select /*+ leading(e d)*/ 
					   e.employee_id, d.* 
				  from hr.employees e 
				  join hr.departments d on e.department_id = d.department_id
				 where e.last_name = 'Smith'

               ) loop
    null;
  end loop;



  for x in (select p.plan_table_output
              from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS ADVANCED LAST')) p) loop
    dbms_output.put_line(x.plan_table_output);
  end loop;
  rollback;
end;
/
