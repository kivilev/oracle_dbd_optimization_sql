create or replace procedure fill_payments is
  c_one_time_limit    constant number(10) := 5000;
  c_max_payment_count constant number(10) := 100000;
  v_current_payment_count number(38);
  c_days_left constant number(3) := 45;

  v_payment_ids   t_number_array;
  v_data_value    payment_detail.field_value%type;
  v_field_ids     t_number_array := t_number_array(1, 2, 3, 4);
  v_payment_dtime payment.create_dtime%type;

  v_client_id_min client.client_id%type;
  v_client_id_max client.client_id%type;
begin

  <<days_loop>>
  for dd in (with dth as
                (select trunc(sysdate - level + 1) dt
                  from dual
                connect by level <= c_days_left),
               cur_dates as
                (select trunc(create_dtime) dt
                      ,count(1) payment_count
                  from payment t
                 where t.create_dtime >= trunc(sysdate - c_days_left)
                 group by trunc(create_dtime))
               select dth.dt payment_day
                     ,nvl(t.payment_count, 0) payment_count
                 from dth
                 left join cur_dates t
                   on t.dt = dth.dt) loop

    v_current_payment_count := dd.payment_count;

    if v_current_payment_count < c_max_payment_count then
      begin
        select min(client_id)
              ,max(client_id)
          into v_client_id_min
              ,v_client_id_max
          from (select client_id
                  from client sample(1)
                 order by dbms_random.value())
         where rownum <= 2;

        select payment_seq.nextval
          bulk collect
          into v_payment_ids
          from dual
        connect by level <=
                   least((c_max_payment_count - v_current_payment_count),
                         c_one_time_limit);

        v_payment_dtime := dd.payment_day + dbms_random.value(1, 24) / 24;

        common_pack.enable_manual_changes;

        dbms_output.put_line(v_payment_dtime ||' - '||v_payment_ids.count());

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
                ,round(dbms_random.value(0, 1000), 2) summa
                ,840
                ,trunc(dbms_random.value(v_client_id_min, v_client_id_max)) from_client_id
                ,trunc(dbms_random.value(v_client_id_min, v_client_id_max)) to_client_id
                ,decode(mod(rownum, 10), 1, 'reason', 2, 'reason', null) status_change_reason
                ,decode(mod(rownum, 10), 0, 0, 1, 2, 2, 3, 1) status
            from table(v_payment_ids) t;
            
        dbms_output.put_line('payment inserted: '||sql%rowcount);

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
           
        dbms_output.put_line('payment_detail inserted: '||sql%rowcount);

        commit;

      exception
        when others then
          dbms_output.put_line('Error: ' || sqlerrm);
      end;
    end if;

  end loop days_loop;

end;
/
