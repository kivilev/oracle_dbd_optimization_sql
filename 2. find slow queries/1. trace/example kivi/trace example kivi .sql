---- Пример. Снятие трассировки (KIVI)
-- Этап 1. Снятие 

alter session set timed_statistics = true;
alter session set tracefile_identifier = 'EXAMPLE_TRC_2';
call dbms_session.session_trace_enable();

begin
  kivi.payment_check_pack.check_payment(p_payment_id => 2688631);
end;
/

call dbms_session.session_trace_disable();


-- Этап 2. Получение содержимого

select * from v$diag_trace_file t where t.trace_filename like '%EXAMPLE_TRC%';
 
select payload
  from v$diag_trace_file_contents t
 where t.trace_filename like '%EXAMPLE_TRC%'
 order by t.line_number;


-- Этап 3. Разбор

tkprof EXAMPLE_TRC_1.trc EXAMPLE_TRC_1.trc.txt sort=prsela,fchela,exeela sys=no
orasrp --sort prsela,fchela,exeela EXAMPLE_TRC_1.trc EXAMPLE_TRC_1.trc.html sys=no

orasrp --sort prsela,fchela,exeela ORCLCDB_ora_183083_CHECK_PAYMENT111.trc ORCLCDB_ora_183083_CHECK_PAYMENT111.trc.html sys=no
