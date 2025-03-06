select * from payment t;

alter session set statistics_level = all;
alter session set timed_statistics = true;
alter session set tracefile_identifier = 'CHECK_PAYMENT_1';
call dbms_session.session_trace_enable();

-- Check payment
begin
  kivi.payment_check_pack.check_payment(p_payment_id => 22165010);
end;
/

call dbms_session.session_trace_disable();
rollback;

-- tkprof ORCLCDB_ora_859890_CHECK_PAYMENT_2.trc ORCLCDB_ora_859890_CHECK_PAYMENT_2.trc.txt sort=prsela,fchela,exeela sys=no
-- call clear_payments();
