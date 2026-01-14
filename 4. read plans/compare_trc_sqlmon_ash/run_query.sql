
-- call flush_all();

-- найдем клиента
select * from client_data t where t.field_id = 5 and t.client_id = 146; 
select * from client_data t where t.field_id = 4 and t.client_id = 146; 

-- включим трассировку и сбор статистики
alter session set statistics_level = all; -- статистика для запроса
alter session set timed_statistics = true; -- добавление статистики для трассировки
alter session set tracefile_identifier = 'MON_TRC_01'; -- метка для трассировочного файла
alter session set events '10046 trace name context forever, level 12'; -- waits + bind vars

select /*+ monitor use_nl(ser num) leading(ser num)*/ count(*)
  from client_data ser
  join client_data num
    on num.client_id = ser.client_id
   and num.field_value = 'FENXEOVELUCNGESNMJSE'
   and num.field_id = 5
 where ser.field_value = 'PPBZ'
   and ser.field_id = 4;

alter session set events '10046 trace name context off';

-- отчет SQL-монитора
select dbms_sqltune.report_sql_monitor(sql_id => '3g2fz9g3dvhz3', report_level => 'all', type => 'HTML') from dual;
select dbms_sql_monitor.report_sql_monitor(sql_id => '3g2fz9g3dvhz3', report_level => 'all', type => 'ACTIVE') from dual;
select dbms_sql_monitor.report_sql_monitor(sql_id => '3g2fz9g3dvhz3', report_level => 'all', type => 'TEXT') from dual;



-- tkprof ORCLCDB_ora_2655_MON_TRC_01.trc ORCLCDB_ora_2655_MON_TRC_01.trc.txt sort=prsela,fchela,exeela sys=no
