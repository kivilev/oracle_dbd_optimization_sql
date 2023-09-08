explain plan for 
select /*+ leading(e d)*/ 
					   e.employee_id, d.* 
				  from hr.employees e 
				  join hr.departments d on e.department_id = d.department_id
				 where e.last_name = 'Smith';

-- вывод плана
select * from dbms_xplan.display(format => 'ALL');
