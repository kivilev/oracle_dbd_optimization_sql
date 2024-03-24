/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция N. Поиск проблем

  Описание скрипта: не указывать размер коллекций/временных таблиц
*/

create or replace type t_numbers is table of number(38);
/


---- Размер коллекции в E-rows = 8168
select * 
  from t_numbers(1,2,3) t;

-- выбирается не правильное соединение и порядок
select * 
  from t_numbers(1,2,3) t
  join hr.employees e on e.employee_id = value(t);



---- Решение 1. Cardinality. Указываем примерный размер коллекции               
select /*+ cardinality(t 10) */ * 
  from t_numbers(1,2,3) t;
  
select /*+ cardinality(t 3) */ * 
  from t_numbers(1,2,3) t
  join hr.employees e on e.employee_id = value(t);

---- Решение 2. Dynamic_sampling. Указываем уровень сбора % от выборки (см. доку)
select /*+ dynamic_sampling(t 5)*/ *
  from t_numbers(1,2,3) t;
  
select /*+ dynamic_sampling(t 5)*/ *
  from t_numbers(1,2,3) t
  join hr.employees e on e.employee_id = value(t);

