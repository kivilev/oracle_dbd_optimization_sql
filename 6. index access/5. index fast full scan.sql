/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Индексный доступ

  Описание скрипта: демо index fast full scan
*/


---- Пример 1. Используем индекс для получения данных
select /*+ index_ffs(t emp_name_ix)*/
 t.first_name
,t.last_name
  from employees t;


---- Пример 2. Используем индекс для count(*)
-- важно! столбец в индексе должен быть not null
select  /*+ index_ffs(t emp_name_ix)*/ count(*)
  from employees t;
