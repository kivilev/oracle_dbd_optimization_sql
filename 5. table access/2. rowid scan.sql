/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание скрипта: демо rowid scan
 
*/

---- Пример 1. непосредственное обращение по rowid
select t.*, rowid
  from hr.employees t where t.rowid = chartorowid('AAAR3NAAMAAAADrAAH');


---- Пример 2. индекс (unq) -> rowid
select /*+ batch_table_access_by_rowid(t)*/t.*
  from hr.employees t where t.employee_id = 1;


---- Пример 3. Индекс (не unq) -> rowid batched
select t.* 
  from hr.employees t where t.department_id = 1;

-- можно отключить
select /*+ no_batch_table_access_by_rowid(t)*/ t.*
  from hr.employees t where t.department_id = 1;

---- Пример 4. 

decalre

begin
  
  for v in (select p.*, rowid from payment p where p.status = 0) loop
  
    ....
    
    
     update payment p 
        set status = 1
     -- where p.payment_id = v.payment_id;
      where p.rowid = v.rowid;

  end loop;


end;
/





