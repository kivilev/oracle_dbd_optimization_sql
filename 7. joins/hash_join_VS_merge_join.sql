/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 7. Соединения

  Описание скрипта: сравнение hash join и merge join
  
  Источник: https://stackoverflow.com/questions/8188093/oracle-always-uses-hash-join-even-when-both-tables-are-huge
*/


--Drop objects if they already exist
drop table test_10k_rows purge;
drop table test1 purge;
drop table test2 purge;

--Create a small table to hold rows to be added.
--("connect by" would run out of memory later when _area_sizes are small.)
--VARIABLE: More or less distinct values can change results.  Changing
--"level" to something like "mod(level,100)" will result in more joins, which
--seems to favor hash joins even more.
create table test_10k_rows(a number, b number, c number, d number, e number);
insert /*+ append */ into test_10k_rows
    select level a, 12345 b, 12345 c, 12345 d, 12345 e
    from dual connect by level <= 10000;
commit;

--Restrict memory size to simulate running out of memory.
alter session set workarea_size_policy=manual;

--1 MB for hashing and sorting
--VARIABLE: Changing this may change the results.  Setting it very low,
--such as 32K, will make merge sort joins faster.
alter session set hash_area_size = 1048576;
alter session set sort_area_size = 1048576;

--Tables to be joined
create table test1(a number, b number, c number, d number, e number);
create table test2(a number, b number, c number, d number, e number);

--Type to hold results
create or replace type number_table is table of number;
/

-- set serveroutput on;

--
--Compare hash and merge joins for different data sizes.
--
declare
  v_hash_seconds          number_table := number_table();
  v_average_hash_seconds  number;
  v_merge_seconds         number_table := number_table();
  v_average_merge_seconds number;

  v_size_in_mb number;
  v_rows       number;
  v_begin_time number;
  v_throwaway  number;

  --Increase the size of the table this many times
  c_number_of_steps number := 40;
  --Join the tables this many times
  c_number_of_tests number := 5;

begin
  --Clear existing data
  execute immediate 'truncate table test1';
  execute immediate 'truncate table test2';

  --Print headings.  Use tabs for easy import into spreadsheet.
  dbms_output.put_line('Rows' || chr(9) || ' | ' || 'Size, MB' || chr(9) || ' | ' || 'Hash' || chr(9) || ' | ' ||
                       'Merge');

  --Run the test for many different steps
  for i in 1 .. c_number_of_steps loop
    v_hash_seconds.delete;
    v_merge_seconds.delete;
    --Add about 0.375 MB of data (roughly - depends on lots of factors)
    --The order by will store the data randomly.
    insert /*+ append */
    into test1
      select * from test_10k_rows order by dbms_random.value;
  
    insert /*+ append */
    into test2
      select * from test_10k_rows order by dbms_random.value;
  
    commit;
  
    --Get the new size
    --(Sizes may not increment uniformly)
    select bytes / 1024 / 1024 into v_size_in_mb from user_segments where segment_name = 'TEST1';
  
    --Get the rows.  (select from both tables so they are equally cached)
    select count(*) into v_rows from test1;
    select count(*) into v_rows from test2;
  
    --Perform the joins several times
    for i in 1 .. c_number_of_tests loop
      --Hash join
      v_begin_time := dbms_utility.get_time;
      select /*+ use_hash(test1 test2) */
       count(*)
        into v_throwaway
        from test1
        join test2
          on test1.a = test2.a;
      v_hash_seconds.extend;
      v_hash_seconds(i) := (dbms_utility.get_time - v_begin_time) / 100;
    
      --Merge join
      v_begin_time := dbms_utility.get_time;
      select /*+ use_merge(test1 test2) */
       count(*)
        into v_throwaway
        from test1
        join test2
          on test1.a = test2.a;
      v_merge_seconds.extend;
      v_merge_seconds(i) := (dbms_utility.get_time - v_begin_time) / 100;
    end loop;
  
    --Get average times.  Throw out first and last result.
    select (sum(column_value) - max(column_value) - min(column_value)) / (count(*) - 2)
      into v_average_hash_seconds
      from table(v_hash_seconds);
  
    select (sum(column_value) - max(column_value) - min(column_value)) / (count(*) - 2)
      into v_average_merge_seconds
      from table(v_merge_seconds);
  
    --Display size and times
    dbms_output.put_line(v_rows || chr(9) || ' | ' || round(v_size_in_mb, 2) || chr(9) || ' | ' ||
                         round(v_average_hash_seconds, 2) || chr(9) || ' | ' || round(v_average_merge_seconds, 2));
  
  end loop;
end;
/
