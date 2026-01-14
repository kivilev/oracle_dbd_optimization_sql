create or replace procedure clear_payments is
  c_days_left constant number(3) := 45;
  v_high_value_date date;
begin

  for p in (select partition_name
                  ,high_value
                  ,table_name
              from user_tab_partitions
             where upper(table_name) in ('PAYMENT', 'PAYMENT_DETAIL')
               and upper(partition_name) <> 'PMIN') loop
  
    execute immediate 'select ' || p.high_value || ' from dual'
      into v_high_value_date;
  
    if v_high_value_date is not null
       and v_high_value_date < trunc(sysdate - c_days_left) then
    
      dbms_output.put_line(lower(p.table_name) || '.' || p.partition_name ||
                           ' will be deleted');
    
      execute immediate ' ALTER TABLE ' || lower(p.table_name) ||
                        ' DROP PARTITION ' || p.partition_name ||
                        ' UPDATE GLOBAL INDEXES';
    end if;
  end loop;

end;
/
