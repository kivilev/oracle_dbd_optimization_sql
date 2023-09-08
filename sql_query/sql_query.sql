/* 
  Теория по SQL запросам 
  
  Схема: HR
*/  

---- Пример 1. Демонстрация информации по запросу

-- 1) Выполняем наш тестовый запрос
-- exmpl1 - это просто метка, чтоб проще было искать (это не хинт)
select /* exmpl1 */
       to_char(sysdate), t.*
  from hr.employees t
 where t.employee_id in (100, 101);

-- 2) parent-курсор
select t.* 
  from v$sqlarea t 
 where t.sql_text like '%/* exmpl1 */%';

-- 3) child-курсор (он один)
select t.child_number, t.plan_hash_value, t.*
  from v$sql t 
 where t.sql_id = 'gqfb6pj53vusn';
 
-- 4) query plan
select * 
  from v$sql_plan t
 where t.sql_id = 'gqfb6pj53vusn' and t.child_number = 0
 order by t.id;

-- или
select * 
  from v$sql_plan t
 where t.sql_id = 'gqfb6pj53vusn' and t.plan_hash_value = 1245571860
 order by t.id;
 
-- 5) Накопленная статистика по выполнению этого плана
select *
  from v$sqlarea_plan_hash t
 where t.sql_id = 'gqfb6pj53vusn'
   and t.plan_hash_value = 1977235694;


---- Пример 2. Порождение второго child-курсора

-- 1) Например, меняем NLS-окружение
alter session set nls_territory = 'AUSTRALIA';

-- 2) Выполняем наш запрос
select /* exmpl1 */
       to_char(sysdate), t.*
  from hr.employees t
 where t.employee_id in (100, 101);

-- 3) Parent-курсор как был так и остался, увеличился счетчик версий запроса
select t.version_count, t.plan_hash_value, t.*
  from v$sqlarea t 
 where t.sql_id = 'gqfb6pj53vusn';

-- 4) Появился новый child-курсор
select t.child_number, t.plan_hash_value, t.*
  from v$sql t 
 where t.sql_id = 'gqfb6pj53vusn'
 order by t.child_number;
 
-- 5) Причина появления (смотрим столбец с Y и столбец REASON)
select s.language_mismatch
      ,s.*
  from v$sql_shared_cursor s
 where s.sql_id = 'gqfb6pj53vusn'
 order by s.child_number;
 

