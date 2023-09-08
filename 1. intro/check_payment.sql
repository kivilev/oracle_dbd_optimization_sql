/*
  Course: Oracle SQL Optimization. Basic
  Author: Denis Kivilev (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Description: Optimization demo for introduction lesson
  
  Schema: kivi  

*/

---- 1. Check payment
begin
  kivi.payment_check_pack.check_payment(p_payment_id => 2688631);
end;
/






---- 2. Tracing

alter session set timed_statistics = true;
alter session set tracefile_identifier = 'CHECK_PAYMENT_1';
call dbms_session.session_trace_enable();

-- Check payment
begin
  kivi.payment_check_pack.check_payment(p_payment_id => 2688631);
end;
/

call dbms_session.session_trace_disable();
rollback;

