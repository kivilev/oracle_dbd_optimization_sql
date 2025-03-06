/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск проблем

  Описание скрипта: cвязные переменные не используются  
*/


---- Плохой случай. Забивка библиотечного кэша
begin  
  for v_client_id in 1..100 loop
    execute immediate '
    select count(*)
      from client_data cd
     where cd.client_id = '||v_client_id;
  end loop;
end;
/

select * from v$sqlarea t where t.sql_fulltext like '%where cd.client_id =%';
select * from v$sql t where t.sql_fulltext like '%where cd.client_id =%';


---- Хороший случай. Используются bind vars.
begin  
  for v_client_id in 1..100 loop
    execute immediate '
    select count(*)
      from client_data cd
     where cd.client_id = :v_client_id' using v_client_id;
  end loop;
end;
/

select * from v$sqlarea t where t.sql_fulltext like '%cd.client_id = :v_client_id%';
select * from v$sql t where t.sql_fulltext like '%cd.client_id = :v_client_id%';

-- или еще проще
declare
  v_cnt number(30);
begin  
  for v_client_id in 1..100 loop
    select count(*)
      into v_cnt
      from client_data cd2
     where cd2.client_id = v_client_id;
  end loop;
end;
/

-- 
select * 
  from v$sqlarea t 
 where lower(t.sql_fulltext) like '%where cd2.client_id%';

-- учесть, что SQL-запрос из PL/SQL будет в верхнем регистре
-- SELECT COUNT(*) FROM CLIENT_DATA CD2 WHERE CD2.CLIENT_ID = :B1 


---- Диагностика таких запросов
select t.plan_hash_value
      ,count(*)
  from v$sql t
 where t.parsing_schema_name = 'KIVI' -- название схемы
 group by t.plan_hash_value;

select * from v$sql t where t.plan_hash_value = 2205388139;
