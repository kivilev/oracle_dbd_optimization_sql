--- Получение плана через трассировку

alter session set timed_statistics = true; -- добавление статистики
alter session set tracefile_identifier = 'EXAMPLE_HR_Q1'; -- метка для трассировочного файла
call dbms_session.session_trace_enable();-- начало снятия трассировки

select /*+ leading(e d)*/ 
             e.employee_id, d.* 
          from hr.employees e 
          join hr.departments d on e.department_id = d.department_id
         where e.last_name = 'Smith';

call dbms_session.session_trace_disable(); -- завершение снятия трассировки

-- отчет 
select * from v$diag_trace_file t where t.trace_filename like '%EXAMPLE_HR_Q1%';
