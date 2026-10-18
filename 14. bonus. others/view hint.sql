/*
  Демо проталкивания хинтов во view
*/

---- Пример 1. Хинты во view через алиасы 
-- подходит, когда нет указания других объектов
create or replace view del$view1 as
select e.last_name, e.department_id, d.location_id
  from hr.employees e
  join hr.departments d on e.department_id = d.department_id;

-- без хинтов
explain plan for
select t.* 
  from del$view1 t;

select * from dbms_xplan.display(format => 'ADVANCED');

-- с хинтами
explain plan for
select /*+ use_hash(t.e t.d) leading(t.d t.e) FULL(t.e) */ t.* 
  from del$view1 t;
select * from dbms_xplan.display(format => 'ADVANCED');


---- Пример 2. Хинты во view (через QB_NAME)

-- через алиасы хинтование не работает: из-за ANSI-join с другой таблицей запрос переписывается
-- в новые query block'и, и хинты по алиасу view (t.e, t.d) становятся Unresolved - смотрите Hint Report:
-- select * from dbms_xplan.display(format => 'BASIC +HINT_REPORT +ALIAS');
-- (если соединить через запятую - from del$view1 t, hr.locations loc where ... - хинты t.e/t.d снова работают)
explain plan for
select /*+ use_hash(t.e t.d) leading(t.d t.e) FULL(t.e) */ * 
  from del$view1 t
  join hr.locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');


-- получаем на предыдущем этапе object_alias (лучше через ide наглядней), хинтуем
explain plan for
select /*+ USE_HASH(E@SEL$2 D@SEL$2) LEADING(E@SEL$2 D@SEL$2) FULL(E@SEL$2) FULL(D@SEL$2)*/ * 
  from del$view1 t
  join hr.locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');


-- ИЛИ используем qb_name: даем имя блоку запроса во view и ссылаемся на него через @.
-- Внутри view соединяем через запятую: ANSI-join во view порождает еще один query block,
-- таблицы e/d уходят в него, и хинты E@V1/D@V1 станут Unresolved
create or replace view del$view1 as
select /*+ qb_name(v1) */ e.last_name, e.department_id, d.location_id
  from hr.employees e, hr.departments d
 where e.department_id = d.department_id;

explain plan for
select /*+ USE_HASH(E@V1 D@V1) LEADING(D@V1 E@V1) FULL(E@V1)*/ * 
  from del$view1 t
  join hr.locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');

