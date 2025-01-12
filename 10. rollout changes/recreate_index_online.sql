/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поставка изменений

  Описание скрипта: пересоздание индекса
*/

-- drop table del$1;
create table del$1(
  id number(30),
  col1 varchar2(100 char),
  col2 varchar2(200 char),
  constraint del$1_pk primary key (id)
);

create index del$1_old_i on del$1(col2);

insert /*+ append */ into del$1
select level, lpad(level, 100, '_'), lpad(level, 100, '_') from dual connect by level <= 1000;
commit;


-- создаем новый индекс
create index del$1_new_i on del$1(col2, col1) online;

-- смотрим план -> пока подхватывается старый индекс
select * from del$1 t where t.col2 = 'values';

-- делаем невидимым для оптимизатора
alter index del$1_old_i invisible;

-- смотрим план -> уже подхватывается новый индекс
select * from del$1 t where t.col2 = 'values';

-- вставка без commit
insert into del$1 values (1222, 'some_value', 'some_value2');

-- удаляем индекс
drop index del$1_old_i online;

