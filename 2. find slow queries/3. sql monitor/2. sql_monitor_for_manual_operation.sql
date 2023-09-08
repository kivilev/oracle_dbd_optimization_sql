---- Пример 1. Группа SQL-операций (схема HR)
-- forced_tracking = 'Y' - снимается принудительно.

declare
  v_exec_id number;
  v_cnt     number;
begin
  v_exec_id := dbms_sql_monitor.begin_operation(dbop_name => 'HR_TEST', forced_tracking => 'Y' );

  -- >>> begin. our functional

  select /*my_query1*/ count(*) 
    into v_cnt
    from hr.countries
    cross join hr.departments
    cross join hr.employees
    cross join hr.employees;

  select /*my_query2*/ count(*) 
    into v_cnt  
    from hr.employees
    cross join hr.employees
    cross join hr.employees;
  
  select /*my_query3*/ count(1)    
    into v_cnt
   from hr.employees;

  select /*my_query4*/ count(1)
    into v_cnt
   from hr.departments;

  dbms_session.sleep(2);

  -- >>> end

  dbms_sql_monitor.end_operation(dbop_name => 'HR_TEST', dbop_eid => v_exec_id);
  dbms_output.put_line('Exceution_id: '|| v_exec_id); 
end;
/

-- построение отчета в двух вариантах (по умолчанию последний запуск)
select dbms_sql_monitor.report_sql_monitor(dbop_name => 'HR_TEST', type => 'HTML', report_level => 'ALL') as html_rpt
      ,dbms_sql_monitor.report_sql_monitor(dbop_name => 'HR_TEST', type => 'text', report_level => 'ALL') as text_rpt
  from dual;



---- Пример 2. Выполнение в ручном режиме с использованием операций

-- ! выполнить несколько раз
declare
  v_exec_id number;
begin
  v_exec_id := dbms_sql_monitor.begin_operation(dbop_name => 'CHECK_USER', forced_tracking => 'Y' );

  -- Checking client
  begin
    kivi.payment_check_pack.check_payment(p_payment_id => 2688632);
  end;


  dbms_sql_monitor.end_operation(dbop_name => 'CHECK_USER', dbop_eid => v_exec_id);
  dbms_output.put_line('Exceution_id: '|| v_exec_id); 
end;
/

-- сколько выполнялась операция
select status, sql_id, dbop_name, dbop_exec_id,
       to_char(elapsed_time/1000000,'000.00') as elapsed_sec 
from   v$sql_monitor
where  dbop_name = 'CHECK_USER';

select t.key
      ,dbop_name
      ,dbop_exec_id as id
      ,status
      ,t.*
  from v$sql_monitor t
 where dbop_name is not null
 order by dbop_exec_id;

-- ничего не вернет, т.к. мониторится группа операций
select t.*
  from v$sql_plan_monitor t
 where t.key = 270582942888;

-- построение отчета в двух вариантах (по умолчанию последний запуск)
select dbms_sql_monitor.report_sql_monitor(dbop_name => 'CHECK_USER', type => 'HTML', report_level => 'ALL') as html_rpt
      ,dbms_sql_monitor.report_sql_monitor(dbop_name => 'CHECK_USER', type => 'text', report_level => 'ALL') as text_rpt
  from dual;


select dbms_sql_monitor.report_sql_monitor(dbop_name => 'CHECK_USER', type => 'HTML', report_level => 'ALL', dbop_exec_id => 1) as html_rpt
      ,dbms_sql_monitor.report_sql_monitor(dbop_name => 'CHECK_USER', type => 'text', report_level => 'ALL', dbop_exec_id => 1) as text_rpt
  from dual;
