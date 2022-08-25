/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция N. Поиск проблем

  Описание скрипта: примеры поиска, диагностики проблем
  
*/


---- I. Однотипные запросы порождают Parent и child-курсоры, чаще всего имеют один и тот же план запроса.

-- 1. Запросы не используют bind vars
select t.plan_hash_value
      ,count(*)
  from v$sql t
 where t.parsing_schema_name = 'COMMON_IDENT' -- схема
 group by t.plan_hash_value;

-- 2. Проблема с неправильным использованием или не использованием коллекций
TODO: написать






