/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Как и когда использовать индексы

  Описание скрипта: демо создание индекса
*/

drop table push_queue;

create table push_queue(
 id number not null primary key,
 status varchar(20 char) not null,
 f1 varchar2(2000 char),
 f2 varchar2(2000 char)
);

insert /*+ append*/ into push_queue
    select level
           ,decode(mod(level, 100), 0, 'NEW', 1, 'DELAYED', 'PROCESSED') status
           ,rpad(level, 200,'_'), rpad(level, 200,'_')
      from dual connect by level <= 100000;
commit;

select status, count(*) cnt from push_queue group by status;
-- NEW	1000
-- DELAYED	1000
-- PROCESSED	98000

-- исходный запрос
select id
  from push_queue 
 where status = 'NEW'
   and rownum <= 10
   for update skip locked;



---- Простой вариант (запрос менять не надо)
create index push_queue_status_i on push_queue(status);

select id
  from push_queue 
 where status = 'NEW'
   and rownum <= 10
   for update skip locked;



---- Экономный вариант (надо менять запрос)

create index push_queue_status_i on push_queue(decode(status, 'PROCESSED', null, status));

select id
  from push_queue 
 where decode(status, 'PROCESSED', null, status) = 'NEW'
   and rownum <= 10
   for update skip locked;



---- Эффективный вариант (надо менять запрос)
create index push_queue_status_i on push_queue(decode(status, 'PROCESSED', null, status), status);

-- что изменилось в плане?
select rowid
  from push_queue 
 where decode(status, 'PROCESSED', null, status) = 'NEW'
   and rownum <= 10
   for update skip locked;

