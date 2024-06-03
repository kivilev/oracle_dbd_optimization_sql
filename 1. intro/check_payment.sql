/*
  Course: Oracle SQL Optimization. Basic
  Author: Denis Kivilev (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Description: Optimization demo for introduction lesson
  
  Schema: kivi  

*/

-- call flush_all();

---- 0. Get one of payments 6013328
select * from payment;

---- 1. Check payment
begin
  kivi.payment_check_pack.check_payment(p_payment_id => &payment_id);
end;
/






---- 2. Tracing + awr
alter session set statistics_level = all;
alter session set timed_statistics = true;
alter session set tracefile_identifier = 'CHECK_PAYMENT_2';
call dbms_session.session_trace_enable();

-- Check payment
begin
  kivi.payment_check_pack.check_payment(p_payment_id => 6254217);
end;
/

call dbms_session.session_trace_disable();
rollback;

-- tkprof ORCLCDB_ora_859890_CHECK_PAYMENT_2.trc ORCLCDB_ora_859890_CHECK_PAYMENT_2.trc.txt sort=prsela,fchela,exeela sys=no
-- call clear_payments();
