insert /*+ append */ into word_black_list
select level, dbms_random.string(opt => 'x', len => 20)
  from dual connect by level <= 10000;
commit;
