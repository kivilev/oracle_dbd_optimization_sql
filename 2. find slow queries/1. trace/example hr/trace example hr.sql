---- Пример 1. Снятие трассировки (HR)

-- Этап 1. Снятие 
alter session set timed_statistics = true; -- добавление статистики
alter session set tracefile_identifier = 'EXAMPLE_TRC_1'; -- метка для трассировочного файла
call dbms_session.session_trace_enable();-- начало снятия трассировки

-- >>> begin. our functional

select /*my_query1*/ count(*) 
  from hr.countries
  cross join hr.departments
  cross join hr.employees
  cross join hr.employees;

select /*my_query2*/ count(*) 
  from hr.employees
  cross join hr.employees
  cross join hr.employees;
  
select /*my_query3*/ count(1) from hr.employees;

select /*my_query4*/ count(1) from hr.departments;

-- >>> end


call dbms_session.session_trace_disable(); -- завершение снятия трассировки

-- Этап 2. Получение содержимого


select * from v$diag_trace_file t where t.trace_filename like '%EXAMPLE_TRC%'
 
select payload
  from v$diag_trace_file_contents t
 where t.trace_filename like '%EXAMPLE_TRC%'
 order by t.line_number;



-- Этап 3. Разбор
-- cd /opt/oracle/diag/rdbms/orclcdb/ORCLCDB/trace
tkprof EXAMPLE_TRC_1.trc EXAMPLE_TRC_1.trc.txt sort=prsela,fchela,exeela sys=no
orasrp --sort prsela,fchela,exeela EXAMPLE_TRC_1.trc EXAMPLE_TRC_1.trc.html sys=no

--! открыть в SQL Developer и TOAD

