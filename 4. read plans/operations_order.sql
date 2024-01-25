---- Порядок операций в таблице операций

---- Виды операций

-- одиночные операции, только с 1 потомком  (например, sort order by)
select * 
  from hr.departments d
 order by d.department_name;

-- с более чем 1 потомком (например, union all)
select * from hr.departments d1
union 
select * from hr.departments d2
union
select * from hr.departments d3;

-- joins, всегда два потомка (например, nested loops)
select /*+ use_nl(e d) FULL(e) FULL(d) */
       e.employee_id, d.*
  from hr.employees e 
  join hr.departments d on e.department_id = d.department_id;


---- Примеры запросов
-- 1
select *
  from hr.employees;

-- 2
select *
  from hr.employees t
 where t.employee_id = 100;

-- 3
select e.first_name, m.first_name
  from hr.employees e
  join hr.employees m on e.manager_id = m.employee_id

-- 4
select e.*, m.*, d1.department_name
  from hr.employees e
  join hr.employees m on e.manager_id = m.employee_id
  join hr.departments d1 on d1.department_id = e.department_id
 order by d1.department_name;  

-- 5. Исключение из правил - подзапрос в select
select (select d.department_name 
          from departments d 
         where d.department_id = e.department_id) dep_name
   from employees e;

-- 6.  Исключение из правил - CTE
with dep as
 (select /*+ materialize*/ d.department_id
    from departments d
   where d.department_name like 'A%')
select e.first_name
  from employees e
  join dep d on e.department_id = d.department_id;

  
