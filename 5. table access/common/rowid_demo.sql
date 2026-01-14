/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Хранение данных

  Описание скрипта: демо rowid
*/


select rowid from dual;

declare
  v_object_number number;
  v_relative_fno  number;
  v_block_number  number;
  v_row_number    number;
  v_rowid_type    number;
begin
  dbms_rowid.rowid_info(rowid_in      => 'AAAACPAABAAAAShAAA',
                        object_number => v_object_number,
                        block_number  => v_block_number,
                        row_number    => v_row_number,
                        relative_fno  => v_relative_fno,
                        rowid_type => v_rowid_type
                        );

  dbms_output.put_line('v_object_number: ' || v_object_number);
  dbms_output.put_line('v_relative_fno: ' || v_relative_fno);
  dbms_output.put_line('v_block_number: ' || v_block_number);
  dbms_output.put_line('v_row_number: ' || v_object_number);
end;
/

select t.relative_fno, t.* from dba_data_files t where t.relative_fno = 1;
select t.object_id, t.* from all_objects t where t.object_id = 143;
