-- Файл 2: test_query.sql - Установка client_id и выполнение тестового запроса на схеме HR
-- Подключиться как HR или пользователь с доступом к схеме HR

-- Установка client_identifier для активации трассировки
call dbms_session.set_identifier('HR_TEST');

-- 
-- alter session set tracefile_identifier = 'HR_PERF_TEST';


-- тестовый запрос: сотрудники из отделов it и sales с зарплатой > 5000
select /*+ MYQ2 */ e.employee_id, e.first_name, e.last_name, e.department_id, d.department_name, e.salary
from hr.employees e
join hr.departments d on e.department_id = d.department_id
where d.department_name in ('IT', 'Sales')
  and e.salary > 5000
order by e.salary desc;

-- проверка пути к файлу трассировки (опционально)
select value as trace_file from v$diag_info where name = 'Default Trace File';


-- call dbms_session.clear_identifier();
