declare
  v_exec_id number;
begin
  v_exec_id := dbms_sql_monitor.begin_operation(dbop_name => 'CREATE_USER');

  -- Creating client
  declare
    v_client_id   client.client_id%type;
    v_client_data t_client_data_array := t_client_data_array(t_client_data(client_api_pack.c_first_name_field_id, 'John'),
                                                             t_client_data(client_api_pack.c_last_name_field_id, 'Smith'),
                                                             t_client_data(client_api_pack.c_birthday_field_id,
                                                                           '1982-01-21'),
                                                             t_client_data(client_api_pack.c_passport_series_field_id,
                                                                            dbms_random.string(opt => 'U', len => 4)),
                                                             t_client_data(client_api_pack.c_passport_number_field_id,
                                                                           dbms_random.string(opt => 'X', len => 6)),
                                                             t_client_data(client_api_pack.c_email_field_id,
                                                                           'email@email.com'),
                                                             t_client_data(client_api_pack.c_mobile_phone_field_id,
                                                                           '+' || trunc(dbms_random.value(19000000000, 19999999999))));
  begin
    v_client_id := client_manage_pack.register_new_client(v_client_data);
    dbms_output.put_line(v_client_id);
    rollback;
  end;

  dbms_sql_monitor.end_operation(dbop_name => 'CREATE_USER', dbop_eid => v_exec_id);
end;
/


SELECT STATUS, SQL_ID, DBOP_NAME, DBOP_EXEC_ID,
       TO_CHAR(ELAPSED_TIME/1000000,'000.00') AS ELA_SEC 
FROM   V$SQL_MONITOR
WHERE  DBOP_NAME = 'CREATE_USER';


select dbop_name
      ,dbop_exec_id as id
      ,status
      ,cpu_time
      ,buffer_gets
  from v$sql_monitor
 where dbop_name is not null
 order by dbop_exec_id;


select dbms_sql_monitor.report_sql_monitor(dbop_name => 'CREATE_USER', type => 'HTML', report_level => 'ALL') as html_rpt
       ,dbms_sql_monitor.report_sql_monitor(dbop_name => 'CREATE_USER', type => 'text', report_level => 'ALL') as html_rpt
  from dual;


SELECT DBMS_SQL_MONITOR.REPORT_SQL_MONITOR(dbop_name=>'CREATE_USER',report_level=>'ALL',TYPE=>'active') from dual;
