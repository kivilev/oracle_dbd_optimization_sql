/*
  Демо проталкивания хинтов во view
*/

---- Пример 1. Хинты во view через алиасы 
-- подходит, когда нет указания других объектов
create or replace view del$view1 as
select e.last_name, e.department_id, d.location_id
  from hr.employees e
  join departments d on e.department_id = d.department_id;

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

-- через алиасы хинтование не работает, т.к. есть другие объекты
explain plan for
select /*+ use_hash(t.e t.d) leading(t.d t.e) FULL(t.e) */ * 
  from del$view1 t
  join locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');


-- получаем на предыдущем этапе object_alias (лучше через ide наглядней), хинтуем
explain plan for
select /*+ USE_HASH(E@SEL$2 D@SEL$2) LEADING(E@SEL$2 D@SEL$2) FULL(E@SEL$2) FULL(D@SEL$2)*/ * 
  from del$view1 t
  join locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');


-- ИЛИ используем qb_name

