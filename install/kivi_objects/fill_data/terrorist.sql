-- terrorist
declare 
 v_total number := 15000000;--5 000 000;
 v_step number := 100000;
 v_first_name varchar2(200);
 v_last_name varchar2(200); 
 v_first_names t_string_array := t_string_array('Oliver','Jake','Noah','James',
'Jack','Connor','Liam','John',
'Harry','Callum','Mason','Robert',
'Jacob','Jacob','Jacob','Michael',
'Charlie','Kyle','William','William',
'Thomas','Joe','Ethan','David',
'George','Reece','Michael','Richard',
'Oscar','Rhys','Alexander','Joseph',
'James','Charlie','James','Charles',
'William','Damian','Daniel','Thomas',
'Amelia','Margaret','Emma','Mary',
'Olivia','Samantha','Olivia','Patricia',
'Isla','Bethany','Sophia','Jennifer',
'Emily','Elizabeth','Isabella','Elizabeth',
'Poppy','Joanne','Ava','Linda',
'Ava','Megan','Mia','Barbara',
'Isabella','Victoria','Emily','Susan',
'Jessica','Lauren','Abigail','Margaret',
'Lily','Michelle','Madison','Jessica',
'Sophie','Tracy','Charlotte','Sarah');
v_nums t_number_array;
begin
  
   select level
     bulk collect into v_nums
    from dual
   connect by level <= v_step;


  for i in 1..v_total/v_step loop
    v_first_name := v_first_names(trunc(dbms_random.value(1, v_first_names.count)));
    v_last_name := dbms_random.string(opt => 'U', len => 10);
    
    insert /*+ append */
    into terrorist
      (first_name
      ,last_name
      ,birthday
      ,reason
      ,created_dtime
      )
      select /*+ cardinality(t 100000)*/v_first_name
            ,v_last_name
            ,date '1984-01-21' + mod(rownum, 10000)
            ,dbms_random.string(opt => 'p', len => 20)
            ,sysdate - 1/24/60*rownum
        from table(v_nums) t;
    commit;
  end loop;
end;
/  
