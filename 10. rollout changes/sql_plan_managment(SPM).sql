/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поставка изменений

  Описание скрипта: Закрепление плана SQL-запроса (SQL plan baseline, SPM)
   - выполнение под SYS   
*/


-- drop table del$1;
create table del$1(
  id number(30),
  col1 varchar2(300 char),
  col2 varchar2(300 char),
  constraint del$1_pk primary key (id)
);

insert /*+ append */ into del$1
select level, lpad(level, 200, '_'), lpad(level, 200, '_') from dual connect by level <= 1000;
commit;

create index del$1_col1_i on del$1(col1);
create index del$1_col1_col2_i on del$1(col1, col2);

---- 1. Сгенерируем курсоры/план для 1го запроса
select * from del$1 t where col1 = 'some_value3';


-- ищем sql_id -> g6r6jkyfvxpbb, 1849873826
select t.plan_hash_value, t.sql_id, t.* from v$sql t where t.sql_text like '%del$1%some_value3%';


---- 2. Хинтуем и генерируем курсоры/план для 2го запроса
select /*+ index(t del$1_col1_col2_i)*/ * from del$1 t where col1 = 'some_value3';

-- ищем sql_id -> 3qc5btf7zt68t, 3594690962
select t.plan_hash_value, t.sql_id, t.* from v$sql t where t.sql_text like '%index%del$1%some_value3%';


-- Загружаем в "хранилище планов"
begin
   dbms_output.put_line(dbms_spm.load_plans_from_cursor_cache(sql_id => 'g6r6jkyfvxpbb', plan_hash_value => 1849873826)); 
end;
/

-- получаем информацию по нему -> SQL_89e066867bcec871
select sql_handle, to_char(sql_text), plan_name from dba_sql_plan_baselines;

-- отключаем план по sql_handle
begin
  dbms_output.put_line(dbms_spm.alter_sql_plan_baseline(sql_handle      => 'SQL_440d7f4cfb3a80a9',
                                                        attribute_name  => 'enabled',
                                                        attribute_value => 'NO'));
end;
/

-- фиксируем первому запросу план от второго запроса
begin
  dbms_output.put_line(dbms_spm.load_plans_from_cursor_cache(sql_id          => '3qc5btf7zt68t', -- sql_id второго запроса
                                                             plan_hash_value => 3594690962, -- plan_hash второго запроса
                                                             fixed           => 'YES',
                                                             sql_handle      => 'SQL_440d7f4cfb3a80a9'));
end;
/

---- смотрим получилось или нет
select * from del$1 t where col1 = 'some_value3';


