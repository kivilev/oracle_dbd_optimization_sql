declare
  v_client_ids    t_number_array;
  v_payment_ids   t_number_array;
  v_data_value    payment_detail.field_value%type;
  v_field_ids     t_number_array := t_number_array(1, 2, 3, 4);
  v_payment_dtime payment.create_dtime%type;
  c_days_count constant number(3) := 45;
  v_payment_per_day   number := 100000;
  v_diff_date_per_day number := 25;
  v_bulk_size         number := v_payment_per_day / v_diff_date_per_day;
  v_client_id_min     client.client_id%type;
  v_client_id_max     client.client_id%type;

begin

  common_pack.enable_manual_changes;

  <<days_loop>>
  for i in (select trunc(sysdate) - level + 1 dt
              from dual
            connect by level <= c_days_count) loop
  
    <<bulk_loop>>
    for dd in (select level lvl from dual connect by level <= v_diff_date_per_day) loop
    
      select payment_seq.nextval
        bulk collect
        into v_payment_ids
        from dual
      connect by level <= v_bulk_size;
    
      v_payment_dtime := i.dt + dbms_random.value(1, 24) / 24;
    
      select payment_seq.nextval
        bulk collect
        into v_payment_ids
        from dual
      connect by level <= v_bulk_size;
    
      select min(client_id)
            ,max(client_id)
        into v_client_id_min
            ,v_client_id_max
        from (select client_id
                from client sample(1)
               order by dbms_random.value())
       where rownum <= 2;
    
      -- payment
      insert /*+ append */
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
              ,round(dbms_random.value(0, 100), 2) summa
              ,840
              ,trunc(dbms_random.value(v_client_id_min, v_client_id_max)) from_client_id
              ,trunc(dbms_random.value(v_client_id_min, v_client_id_max)) to_client_id
              ,decode(mod(rownum, 10), 1, 'reason', 2, 'reason', null) status_change_reason
              ,decode(mod(rownum, 10), 0, 0, 1, 2, 2, 3, 1) status
          from table(v_payment_ids) t;
    
      -- payment_detail
      v_data_value := dbms_random.string(opt => 'A', len => 10);
      insert /*+ append */
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
  end loop;
end;
/

--truncate table payment;
--truncate table payment_detail;
