---- Демо примитивной диагностики по v$session (HR)

---- Пример 1. Одна сесссия

-- 1) открываем другую вкладку с сессиями

-- 2) в этой вкладке запускам

declare
  v_cnt number;
begin
  dbms_session.sleep(5); -- чтоб успел переключиться во вкладку с сессиями

  select
   count(*)
    into v_cnt
    from hr.employees q1
   cross join hr.employees
   cross join hr.employees
   cross join hr.employees;

  select
   count(*)
    into v_cnt
    from hr.employees q2
   cross join hr.employees
   cross join hr.employees;

  select 
   count(*)
    into v_cnt
    from hr.employees q3
   cross join hr.employees;

end;
/

