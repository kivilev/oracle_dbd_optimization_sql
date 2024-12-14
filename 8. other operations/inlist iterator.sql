/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: inlist/iterator
   
*/

---- Пример 1. Использование итератора

-- Inlist Iterator с IN
select * 
  from hr.employees t 
 where t.employee_id in (100, 101, 102);

select * from hr.employees t 
 where t.department_id in (10, 20, 30);

-- Inlist Iterator с OR
select * from hr.employees t 
 where t.department_id = 10 or t.department_id = 20 or t.department_id = 30;


---- Пример 2. Iteratir не подключился, т.к. дешевле FTS
select * 
  from hr.employees t 
 where t.employee_id in (100,101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168,
 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187,
 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206
); 

select * from hr.employees t 
 where t.department_id in (10, 20, 30, 40, 50, 60);


---- Пример 3. Итератор в сеционированных таблицах

-- drop table del$requests;

create table del$requests
(
  request_id   number(30) not null,
  request_date date not null,
  region_id    char(2 char) not null,
  customer_id  number(30) not null,
  external_id  varchar2(200) not null
)
partition by range (request_date) interval (numtodsinterval(1,'DAY'))
(
  partition pmin values less than (to_date(' 2024-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
);

-- Inlist с IN
select * from del$requests t where t.request_date in (:dsd, :sds);

-- Inlist с OR
select *
  from del$requests t
 where t.request_date = :dsd
    or t.request_date = :dsd2;

-- Iterator
select *
  from del$requests t
 where t.request_date between :v and :v2;
