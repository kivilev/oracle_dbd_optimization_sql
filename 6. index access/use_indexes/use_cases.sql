/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Как и когда использовать индексы

  Описание скрипта: демо кейсов использования индексов
*/

-- drop table hr.employees_extended;

create table hr.employees_extended as
select rownum employee_id,
       t.first_name,
       t.last_name,
       t.email || rownum email,
       t.phone_number,
       t.hire_date,
       t.job_id,
       t.salary,
       t.commission_pct,
       t.manager_id,
       t.department_id,
       decode(mod(rownum,2), 0, 'F', 'M') gender,
       to_char(rownum) tabel_number
  from hr.employees t, (select level from dual connect by level <= 10000);


call dbms_stats.gather_table_stats(ownname => user, tabname => 'employees_extended');

select * from employees_extended

---- Пример 1. Поиск по низкокардинальному значению
create index employees_extended_gen_i on employees_extended(gender);

select * from employees_extended t where t.gender = 'M'; -- плохо, будет FTS

-- что делать? 
-- а) строить bitmap-индекс, если низкая конкуренция за DML 
-- б) считывать данные FTS + parallel, если данных много



---- Пример 2. Использование index fast full scan при подсчете count вместо full table scan
-- предикаты не заданы, но получаем эффект от использования индекса

alter table employees_extended add constraint employees_extended_pk primary key (employee_id);

select count(*) from hr.employees_extended;
select /*+ full(t)*/ count(*) from hr.employees_extended t;



---- Пример 3. Sort Merge Join двух таблиц, использование full scan

-- за счет индекса в employees устраняется шаг с сортировкой - хорошо
select /*+ use_merge(g1 e)*/ * 
  from hr.employees_extended g1
  join hr.employees e on g1.manager_id = e.employee_id;

-- без индекса появляется шаг с сортировкой - медленней
select /*+ use_merge(g1 e) full(e)*/ * 
  from hr.employees_extended g1
  join hr.employees e on g1.manager_id = e.employee_id;



---- Пример 4.1 Неявное преобразование данных
create index employees_extended_tab_num_i on employees_extended(tabel_number); 

-- упс индекс не подтягивается -> неявное преобразование
select * from employees_extended t where t.tabel_number = 23;

-- все ок, индекс ок
select * from employees_extended t where t.tabel_number = '23';


---- Пример 4.2 Неявное преобразование данных
drop table del$tab1;

create table del$tab1(
 id number not null,
 f1 varchar2(2000 char),
 f2 varchar2(2000 char),
 dtime timestamp not null
);

create index del$tab1_i on del$tab1(dtime); -- индекс по timestamp

begin
  for i in 1..10000 loop
    insert /*+ append*/ into del$tab1
    select level, rpad(level, 200,'_'), rpad(level, 200,'_'), systimestamp from dual connect by level <= 10;
    commit;
  end loop;
end;
/

-- упс, индекс не подхватывается
select * 
  from del$tab1 t 
 where t.dtime between systimestamp - interval '1' hour and systimestamp;

-- все ок
select * from del$tab1 t 
  where t.dtime between cast (systimestamp as timestamp(6)) - interval '1' hour and cast (systimestamp as timestamp(6));




---- Пример 5. Функциональный индекс
drop index employees_extended_tab_num_i;
create index employees_extended_tab_num_i on employees_extended(upper(tabel_number)); 

-- упс, индекс не используется
select * from employees_extended t where tabel_number = :v;

-- индекс используется
select * from employees_extended t where upper(tabel_number) = :v;



---- Пример 6 Предикат null
select * from employees_extended t where t.employee_id is null;


---- Пример 7. Устраняем операцию по чтению лишних столбцов

-- нет Iffs
select t.first_name, t.last_name, t.hire_date from employees t;

-- есть
select  /*  + index_ffs(t)*/ t.first_name, t.last_name from employees t;
