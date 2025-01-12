/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поставка изменений

  Описание скрипта: Закрепление пouлана SQL-запроса (SQL plan baseline, SPM)
   - выполнение под SYS   
*/


-- drop table del$tab;
create table del$tab(
  id number(30),
  col1 varchar2(300 char),
  col2 varchar2(300 char),
  constraint del$tab_pk primary key (id)
);

insert /*+ append */ into del$tab
select level, lpad(level, 200, '_'), lpad(level, 200, '_') from dual connect by level <= 1000;
commit;

create index del$tab_col1_i on del$tab(col1);
create index del$tab_col1_col2_i on del$tab(col1, col2);

call dbms_stats.gather_table_stats(ownname => user, tabname => 'del$tab');   

---- 1. Сгенерируем курсоры/план для 1го запроса
select * from del$tab t where col1 = 'some_value3';


-- ищем sql_id -> 8vwknv8k11bwh, 2751056628
select t.plan_hash_value, t.sql_id, t.* from v$sql t where t.sql_text like '%del$tab%some_value3%';


---- 2. Хинтуем и генерируем курсоры/план для 2го запроса
select /*+ index(t del$tab_col1_col2_i)*/ * from del$tab t where col1 = 'some_value3';

-- ищем sql_id -> dcp468rx06x21, 1059698090
select t.plan_hash_value, t.sql_id, t.* from v$sql t where t.sql_text like '%index%del$tab%some_value3%';


-- Загружаем в "хранилище планов"
begin
   dbms_output.put_line(dbms_spm.load_plans_from_cursor_cache(sql_id => '8vwknv8k11bwh', plan_hash_value => 2751056628)); 
end;
/

-- получаем информацию по нему -> SQL_89e066867bcec871
select sql_handle, to_char(sql_text), plan_name, t.* from dba_sql_plan_baselines t;

-- отключаем план по sql_handle
begin
  dbms_output.put_line(dbms_spm.alter_sql_plan_baseline(sql_handle      => 'SQL_e755192e9f4e0454',
                                                        attribute_name  => 'enabled',
                                                        attribute_value => 'NO'));
end;
/

-- фиксируем первому запросу план от второго запроса
begin
  dbms_output.put_line(dbms_spm.load_plans_from_cursor_cache(sql_id          => 'dcp468rx06x21', -- sql_id второго запроса
                                                             plan_hash_value => 1059698090, -- plan_hash второго запроса
                                                             fixed           => 'YES',
                                                             sql_handle      => 'SQL_e755192e9f4e0454'));
end;
/

---- смотрим получилось или нет
select * from del$tab t where col1 = 'some_value3';


