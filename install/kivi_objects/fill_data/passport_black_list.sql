-- black list
declare 
 v_total number := 20000000;
 v_step number := 10000;
begin
  
  for i in 1..v_total/v_step loop
    insert /*+ append nologging */ 
      into passport_black_list(passport_series,
                               passport_number,
                               add_dtime)
       select dbms_random.string(opt => 'U', len => 4)
            ,dbms_random.string(opt => 'X', len => 6)
            ,date '2023-01-21' + mod(level, 100)
        from dual
      connect by level <= v_step;
    commit;
  end loop;
end;
/  
-- 341 сек

