/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 5. Доступ к данным таблиц

  Описание: коллекции
*/
-- drop type t_numbers;


---- Создадим демо коллекцию + функцию
create type t_numbers is table of number(38);
/

create or replace function get_numbers return t_numbers
is
begin
  return t_numbers(1, 2, 3);
end;
/


---- Пример 1. COLLECTION ITERATOR CONSTRUCTOR FETCH
select * 
  from t_numbers(1, 2, 3);


---- Пример 2. COLLECTION ITERATOR PICKLER FETCH
select * 
  from get_numbers();



---- Пример 3. Борьба с неверной кардинальностью

-- 10 - количество строк. важен порядок
select /*+ cardinality(t 10)*/ *
  from t_numbers(1, 2, 3) t;


-- 5 - уровень сбора от всей выборки
select /*+ dynamic_sampling(t 2)*/ *
  from t_numbers(1, 2, 3) t;
