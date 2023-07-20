insert /*+ append nologging */  into ip_list
select level
       , dbms_random.string(opt => 'u', len => 10), decode(mod(level, 2), 0, 'W', 'B')
  from dual connect by level <= 10000;
commit;
