/*
  Course: Oracle SQL Optimization. Basic
  Author: Denis Kivilev (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Description: First homework. Client registration example
  
  Schema: kivi  

*/

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
end;
/
