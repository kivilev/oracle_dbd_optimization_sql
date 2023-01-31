-- SemiJoin не получился, т.к. есть OR, но вместо него FILTER
select d.department_name
  from hr.departments d
 where exists (select 1 from hr.employees e where e.department_id = d.department_id or e.email is not null)