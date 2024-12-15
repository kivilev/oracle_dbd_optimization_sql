/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поставка изменений

  Описание скрипта: SQL-карантин
   - выполнение под SYS
   - только для Exadata
*/

-- Тестовый запрос
select /*q-t1*/ count(*) 
  from hr.employees 
 where dbms_random.value(1, 1000) > 500;
 
-- 1. Поиск SQL_ID проблемного запроса
select sql_id
      ,sql_text
      ,t.child_number
      ,t.plan_hash_value
      ,t.*
  from v$sql t
 where sql_text like '%q-t1%' and sql_text not like '%explain plan set%' and sql_text not like '%v$sql%';

-- нашли sql_id: c8mhw7tq0q9t4, plan_hash_value = 1537892406

-- 2. Создание SQL-карантина для блокировки запроса
declare
  v_quarantine_name varchar2(1000 char);
begin
  v_quarantine_name := dbms_sqlq.create_quarantine_by_sql_id(sql_id          => 'a297dxxrp024j',
                                                             plan_hash_value => '1537892406'); -- можно не передавать, будут внесены все планы
  dbms_output.put_line(v_quarantine_name);
end;
/


-- 3. Проверка созданного SQL-карантина
select t.*
  from dba_sql_quarantine t;


-- 4. Удаление SQL-карантина (при необходимости)
begin
  dbms_sqlq.drop_quarantine(quarantine_name => 'SQL_QUARANTINE_5nrgmk5vbh9gg5baa6036');
end;
/



