-- truncate table passport_black_list;

-- black list
declare 
 v_total number := 4000000;
 v_step number := 10000;
begin
  
  for i in 1..v_total/v_step loop
    insert /*+ append */ 
      into passport_black_list(passport_series,
                               passport_number,
                               add_dtime)
       select trunc(dbms_random.value(1000,9999))
            ,trunc(dbms_random.value(100000,999999))
            ,date '2023-01-21' + mod(level, 100)
        from dual
      connect by level <= v_step;
    commit;
  end loop;
end;
/  

-- select count(*) cnt from passport_black_list;
