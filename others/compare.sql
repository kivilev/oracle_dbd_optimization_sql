-- Изучить/Сравнить запросы

---- 1
-- 1
select e.first_name "Employee"
  from hr.Employees e
  join hr.Employees m on m.employee_id = e.manager_id and e.salary > m.salary

-- 2
select e.first_name "Employee"
  from hr.Employees e
 where e.salary > (select m.salary from hr.Employees m where m.employee_id = e.manager_id);


---- 2
-- 1
select d.department_name, e.first_name, e.salary
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id
 where e.salary = (select max(salary) 
                     from hr.employees t
                    where t.department_id = e.department_id);
-- 2
select d.department_name, e.first_name, e.salary
  from (select t.department_id, max(salary) max_salary
         from hr.employees t
        group by t.department_id) dm
  join hr.employees e on dm.department_id = e.department_id and dm.max_salary = e.salary
  join hr.departments d on d.department_id = e.department_id;


----- 3

select c.name customers
  from customers c
where not exists (select 1 from Orders o where o.customerId = c.id)


-- 
select email
  from person
 group by email
 having count(1) > 1
