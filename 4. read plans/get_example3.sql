--- выполняем запрос
select /*+ monitor leading(e d)*/ 
	   e.employee_id, d.* 
  from hr.employees e 
  join hr.departments d on e.department_id = d.department_id
 where e.last_name = 'Smith';


--- 
select t.sql_id, t.sql_text from v$sqlarea t where t.sql_text like '%/*+ monitor leading(e d)*/%'; -- находим наш запрос

-- по самому последнему запуску конкретного запроса sql_id (не обязательно наш запуск)

select dbms_sqltune.report_sql_monitor(sql_id => '2t68nz1rk96p7', report_level => 'all', type => 'HTML') from dual;