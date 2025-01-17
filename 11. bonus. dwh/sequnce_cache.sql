/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Секреты работы с DWH

  Описание скрипта: Пример использования последовательностей с кэшем и без
*/

/*
 drop table del$tab1;
 drop sequence del$tab1_seq;
 drop sequence del$tab1_1K_seq;
*/

create table del$tab1
(
  id number(38),
  col2 varchar2(200 char)
);

create sequence del$tab1_seq nocache;

insert /*seq query1*/ into del$tab1
select del$tab1_seq.nextval,
       lpad('X', 100, 'x')
  from dual connect by level <= 100000; 
commit;

-- f1h95dqcjdbdp
select * from v$sqlarea t where t.sql_text like '%seq query1%';
select * from v$active_session_history t where t.sample_time >= systimestamp - 1/24 and t.sql_id = 'f1h95dqcjdbdp' order by t.sample_id;


---- Используем сиквенс с кэшом
create sequence del$tab1_1K_seq cache 1000;

insert /*seq query2*/ into del$tab1
select del$tab1_1K_seq.nextval,
       lpad('X', 100, 'x')
  from dual connect by level <= 100000; 
commit;

select * from v$sqlarea t where t.sql_text like '%seq query2%';
select * from v$active_session_history t where t.sample_time >= systimestamp - 1/24 and t.sql_id = '5jtva96uw1mm1' order by t.sample_id;


---- Снимем трассировку (показать трассу)

alter session set timed_statistics = true;
alter session set events '10046 trace name context forever, level 8'; -- waits
alter session set tracefile_identifier = 'EXAMPLE_SEQ_2';

insert /*seq query1*/ into del$tab1
select del$tab1_seq.nextval,
       lpad('X', 100, 'x')
  from dual connect by level <= 100000; 
commit;

alter session set events '10046 trace name context off';


-- /mnt/vdb1/oracle19ee/diag/rdbms/orclcdb/ORCLCDB/trace
-- tkprof ORCLCDB_ora_249489_EXAMPLE_SEQ_2.trc ORCLCDB_ora_249489_EXAMPLE_SEQ_2.trc.txt sort=prsela,fchela,exeela sys=no

