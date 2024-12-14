/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Другие операции оптимизатора
  
  Описание скрипта: statements
   
*/


---- Пример 1. Select
select * from dual;


---- Пример 2. Insert
insert into hr.departments
values (1, '111', 1, 2);


---- Пример 3. Update
update hr.departments t set t.department_name = 'sdf'
 where t.department_id = 1;


---- Пример 4. Delete
delete from hr.employees where 1 = 0;


---- Пример 5. Create
create table del$table as select * from dual;
