/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Типы соединений

  Описание скрипта: типы операций соединения
  
*/

---- 1. Примеры Equijoins, Non Equijoins

-- Equijoins
select /*+ FULL(e) FULL(d)*/
       e.last_name
      ,d.department_name
  from hr.employees e
  join hr.departments d
    on d.department_id = e.department_id;

-- Non Equijoins
select /*+ FULL(e) FULL(d)*/
       e.last_name
      ,d.department_name
  from hr.employees e
  join hr.departments d
    on d.department_id > e.department_id;
    
---- 2. Примеры Outer join (Full, Left, and Right)

-- Left, and Right
select /*+ FULL(e) FULL(d)*/
       e.last_name
      ,d.department_name
  from hr.departments d
  right outer join hr.employees e
    on d.department_id = e.department_id;

select /*+ FULL(e) FULL(d)*/
       e.last_name
      ,d.department_name
  from hr.departments d
  left outer join hr.employees e
    on d.department_id = e.department_id;
        
-- Full outer join
select /*+ FULL(e) FULL(d)*/
       e.last_name
      ,d.department_name
  from hr.departments d
  full join hr.employees e
    on d.department_id = e.department_id;
    

---- 3. Semi Join

-- Exists
select d.department_name
  from hr.departments d
 where exists (select 1 from hr.employees e where e.department_id = d.department_id);
    
-- IN
select d.department_name
  from hr.departments d
 where d.department_id in (select e.department_id 
                             from hr.employees e);

-- Exists with OR делает невозможным использование SemiJoin
select d.department_name
  from hr.departments d
 where exists (select 1 from hr.employees e 
                where e.department_id = d.department_id or e.email is not null);
    
    
---- 4. Anti Join

-- Not Exists
select /*+ FULL(d) */
       d.department_name
  from hr.departments d
 where not exists (select 1 from hr.employees e 
                    where e.department_id = d.department_id);
    
-- Not IN
select /*+ FULL(d) */
       d.department_name
  from hr.departments d
 where d.department_id not in (select e.department_id 
                                 from hr.employees e);

