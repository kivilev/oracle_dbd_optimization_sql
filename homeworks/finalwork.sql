/*
  Course: Oracle SQL Optimization. Basic
  Author: Denis Kivilev (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Description: First homework. Payment processing
  
  Schema: kivi  

*/

declare
  c_processing_payment_count constant number := 10;
begin
  kivi.payment_processing_pack.processing(p_bulk_size => c_processing_payment_count);
end;
/