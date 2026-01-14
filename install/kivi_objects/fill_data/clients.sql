declare
  c_client_count constant number := 4000000;
  c_step_count number := 10000;
  c_initial_balance constant account.balance%type := 0;
  v_cnt         number := 0;
  v_client_ids  t_number_array;
  v_client_ids2 t_number_array;
  v_wallet_ids  t_number_array;
  v_currency_id currency.currency_id%type := 643;
  v_client_data t_client_data_array;
  v_wallets     t_number_pair_array;

  function get_random_client_email return client_data.field_value%type is
  begin
    return dbms_random.string('l', 10) || '@' || dbms_random.string('l', 10) || '.com';
  end;

  function get_random_client_mobile_phone return client_data.field_value%type is
  begin
    return '+' || trunc(dbms_random.value(79000000000, 79999999999));
  end;

begin
  common_pack.enable_manual_changes;
  
  for i in 1 .. c_client_count / c_step_count loop
  
    v_client_data := t_client_data_array(t_client_data(client_api_pack.c_first_name_field_id,
                                                       dbms_random.string(opt => 'A', len => 6)),
                                         t_client_data(client_api_pack.c_last_name_field_id,
                                                       dbms_random.string(opt => 'A', len => 8)),
                                         t_client_data(client_api_pack.c_birthday_field_id,
                                                       to_char(sysdate - trunc(dbms_random.value(7000, 15000)), 'YYYY-MM-DD')),
                                         t_client_data(client_api_pack.c_passport_series_field_id,
                                                       dbms_random.string(opt => 'U', len => 4)),
                                         t_client_data(client_api_pack.c_passport_number_field_id,
                                                       dbms_random.string(opt => 'U', len => 20)),
                                         t_client_data(client_api_pack.c_email_field_id, get_random_client_email()),
                                         t_client_data(client_api_pack.c_mobile_phone_field_id,
                                                       get_random_client_mobile_phone()));
  
    select client_seq.nextval bulk collect into v_client_ids from dual connect by level <= c_step_count;
  
    insert /*+ append  */
    into client
      (client_id
      ,is_active
      ,is_blocked)
      select value(t)
            ,client_api_pack.c_active
            ,client_api_pack.c_not_blocked
        from table(v_client_ids) t;
  
    insert /*+ append  */
    into client_data
      select value(c) client_id
            ,value(t).field_id field_id
            ,value(t).field_value field_value
        from table(v_client_ids) c
            ,table(v_client_data) t;
  
    select t_number_pair(value(c), wallet_seq.nextval) bulk collect into v_wallets from table(v_client_ids) c;
  
    insert /*+ append  */
    into wallet
      (wallet_id
      ,client_id
      ,status_id)
      select value                                 (c).second
            ,value                                 (c).first
            ,wallet_api_pack.c_wallet_status_active
        from table(v_wallets) c;
  
    insert /*+ append  */
    into account
      (account_id
      ,client_id
      ,wallet_id
      ,currency_id
      ,balance)
      select account_seq.nextval
            ,value              (c).first
            ,value              (c).second
            ,v_currency_id
            ,c_initial_balance
        from table(v_wallets) c;
  
    commit;
  end loop;
end;
/
