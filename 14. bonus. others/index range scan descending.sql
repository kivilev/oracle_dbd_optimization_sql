-- в стандартной схеме HR индекс уже есть (иначе ORA-00955):
-- create index emp_manager_ix on hr.employees (manager_id);

select *
  from hr.employees t
 where t.manager_id between 1 and 40
 order by t.manager_id desc;
