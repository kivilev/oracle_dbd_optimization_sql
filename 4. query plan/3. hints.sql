/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. План запроса

  Описание скрипта: демонстрация механики хинтов
 
*/

---- 1. Примеры использования хинтов

-- проход по индексу
select * 
  from hr.employees t 
 where t.department_id = 1;


-- Хинт через многострочный комментарий -> Заставляем использовать полное сканирование таблицы
select /*+ FULL(t)*/ * 
  from hr.employees t
 where t.department_id = 1;


-- Хинт через однострочный комментарий -> Заставляем использовать полное сканирование таблицы
select --+ FULL(t)
       * 
 from hr.employees t
where t.department_id = 1;



---- 2. Случаи невозможности применения хинтов

-- такого индекса нет
select /*+ index(no_exists_index)*/* from hr.employees t;

-- неправильны хинт
select /*+ index2(no_exists_index)*/* from hr.employees t;

-- нет в запросе таблицы t2
select /*+ use_nl(t t2)*/* from hr.employees t;


