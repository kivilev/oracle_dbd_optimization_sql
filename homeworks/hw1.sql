/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Домашнее задание 1. Исследование child-курсоров

*/ 

create table del$tab
(
 id number not null,
 dtime date not null
);

insert into del$tab 
select level, sysdate + level
  from dual
connect by level <= 10000;
commit;

-- выполняем 1й запрос, проверяем количество child-курсоров
select to_char(dtime) from del$tab t where t.id = 5555;

-- что-то надо сделать здесь, чтоб породился новый child-курсор (структуры объектов, текст запроса менять нельзя)
...

-- выполняем 2й запрос, проверяем количество child-курсоров => Должно быть более одного!
select to_char(dtime) from del$tab t where t.id = 5555;


---- запросы для проверки
select t.version_count, t.* 
  from v$sqlarea t 
 where t.sql_text like '%del$tab%' 
   and t.parsing_schema_name = user;
 
select * from v$sql t where t.sql_id = '8vt3nsc0ntmbt'; -- подставить sql_id
select * from v$sql_shared_cursor t where t.sql_id = '8vt3nsc0ntmbt'; -- подставить sql_id

