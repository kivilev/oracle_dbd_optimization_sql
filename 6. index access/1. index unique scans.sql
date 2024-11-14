/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Индексный доступ

  Описание скрипта: демо index unique scan
*/

-- Уникальный индекс: EMP_EMP_ID_PK -> create unique index emp_emp_id_pk on employees(employee_id);


---- Пример 1. Уникальное индексное сканирование
select * from hr.employees t where t.employee_id = 100;

-- в чем разница ?
select t.employee_id from hr.employees t where t.employee_id = 100;



---- Пример 2. Unique index scan + inlist iterator (IN)
select * from hr.employees t where t.employee_id in (100, 110);

