/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 6. Индексный доступ

  Описание скрипта: демо различных видов индексов
*/

create table employees2 as
select * from employees;

create index employees2_last_name_idx on employees2(last_name);

-- Range scan
select * from employees2 t where t.last_name = 'Austin';

-- делаем не видимым
alter index employees2_last_name_idx invisible;

select t.visibility, t.* from user_indexes t where t.index_name = 'EMPLOYEES2_LAST_NAME_IDX';


-- Full table scan
select * from employees2 t where t.last_name = 'Austin';


-- делаем видимым
alter index employees2_last_name_idx visible;


