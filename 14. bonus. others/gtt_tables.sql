insert into MY_GTT
select level, rpad('_',199,'_'), rpad('_',199,'_') from dual connect by level <= 100000; 

explain plan for 
select * from MY_GTT;

select * from dbms_xplan.display(format => 'ALL');

create private temporary table ora$ptt_my_tab_sess ( 
id number(30)
)  
on commit preserve definition;

insert into ora$ptt_my_tab_sess select level from dual connect by level <= 10000; 

select * from ora$ptt_my_tab_sess;

explain plan for 
select * from ora$ptt_my_tab_sess;

select * from dbms_xplan.display(format => 'ALL');

select * from user_tab_statistics t where t.table_name = 'MY_GTT'
