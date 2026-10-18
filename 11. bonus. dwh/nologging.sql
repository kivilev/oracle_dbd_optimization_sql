set autotrace traceonly statistics; 

create table tab1 (col1 int, col2 varchar2(32));

create table tab2 (col1 int, col2 varchar2(32)) nologging;

-- nologging работает только для direct-path операций: сравниваем redo size
insert /*+ append */ into tab1 select level, 'x' from dual connect by level <= 100000;
commit;

insert /*+ append */ into tab2 select level, 'x' from dual connect by level <= 100000;
commit;

