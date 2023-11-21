/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция N. Поиск проблем

  Описание скрипта: не указывать размер коллекций/временных таблиц
*/

create or replace type t_number_array is table of number(38);
/


---- Размер коллекции в E-rows = 8168
select * 
  from t_number_array(1,2,3) t;

-- выбирается не правильное соединение и порядок
select * 
  from t_number_array(1,2,3) t
  join hr.employees e on e.employee_id = value(t)



---- Указываем примерный размер коллекции               
select /*+ cardinality(t 10) */ * 
  from t_number_array(1,2,3) t
  
select /*+ cardinality(t 3) */ * 
  from t_number_array(1,2,3) t
  join hr.employees e on e.employee_id = value(t)
  
