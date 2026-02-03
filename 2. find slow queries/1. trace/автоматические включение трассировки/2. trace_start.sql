-- Включение трассировки на уровне БД для client_id 'HR_TEST'

begin
  dbms_monitor.client_id_trace_enable(
    client_id => 'HR_TEST',
    waits     => true,
    binds     => true
  );
  
  dbms_output.put_line('Трассировка включена для client_id ''HR_TEST'' (waits=TRUE, binds=TRUE).');
end;
/


-- отключение 
begin
   dbms_monitor.client_id_trace_disable(client_id => 'HR_TEST');
end;
/

