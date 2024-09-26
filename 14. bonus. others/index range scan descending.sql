create index emp_manager_ix on employees (manager_id);

select *
  from employees t
 where t.manager_id between 1 and 40
 order by t.manager_id desc;
