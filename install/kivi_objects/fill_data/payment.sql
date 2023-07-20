declare
  v_client_ids    t_number_array;
  v_payment_ids   t_number_array;
  v_data_value    payment_detail.field_value%type;
  v_field_ids     t_number_array := t_number_array(1, 2, 3, 4);
  v_payment_dtime payment.create_dtime%type;
begin

  common_pack.enable_manual_changes;

  for i in (select trunc(sysdate + 1) - level dt from dual connect by level <= 30) loop
  
    select client_id
      bulk collect
      into v_client_ids
      from (select client_id from client t order by dbms_random.value)
     where rownum <= 1000;
  
    select payment_seq.nextval bulk collect into v_payment_ids from dual connect by level <= 100000;
  
    v_payment_dtime := i.dt + dbms_random.value(1, 60) / 24 / 60;
  
    -- payment
    insert /*+ append nologging */
    into payment
      (payment_id
      ,create_dtime
      ,summa
      ,currency_id
      ,from_client_id
      ,to_client_id
      ,status_change_reason
      ,status)
      select value(t)
            ,v_payment_dtime create_dtime
            ,round(dbms_random.value(0, 10000), 2) summa
            ,840
            ,v_client_ids(trunc(dbms_random.value(1, v_client_ids.count))) from_client_id
            ,v_client_ids(trunc(dbms_random.value(1, v_client_ids.count))) to_client_id
            ,decode(mod(rownum, 10), 1, 'reason', 2, 'reason', null) status_change_reason
            ,decode(mod(rownum, 10), 0, 0, 1, 2, 2, 3, 1) status
        from table(v_payment_ids) t;
  
    -- payment_detail
    v_data_value := dbms_random.string(opt => 'A', len => 10);
    insert /*+ append nologging */
    into payment_detail
      (payment_id
      ,payment_create_dtime
      ,field_id
      ,field_value)
      select value(p)
            ,v_payment_dtime
            ,value(pd)
            ,v_data_value
        from table(v_payment_ids) p
       cross join table(v_field_ids) pd;
  
    commit;
  end loop;
end;
/

--truncate table payment;
--truncate table payment_detail;
