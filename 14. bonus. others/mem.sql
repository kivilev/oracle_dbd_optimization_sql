/*
 Пример запроса со всеми столбцами
*/ 

---- Пример 1. Простой 
-- в скрипт для IDE

select /* + use_hash(e d) no_index(e) */
     e.employee_id
    ,d.department_name
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id;
    
   
---- Пример 2. Сложный запрос с использованием всех столбцов

with guid_cby as (
  select id, level rn, list_col,instr ('|' || d.list_col, '|', 1, level) pos
    from delimited_lists d
  connect by prior id = id and prior sys_guid() is not null and
    level <= length (d.list_col) - nvl (length (replace (d.list_col, '|')), 0) + 1
)
select id  id, 
       substr (list_col, pos, lead (pos, 1, 4000) over (partition by id order by pos) - pos - 1) token
  from guid_cby

Plan hash value: 240527573

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  | Writes |  OMem |  1Mem | Used-Mem | Used-Tmp|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                 |      1 |        |   5400K|00:14:12.07 |   77412 |   2404K|   2404K|       |       |          |         |
|   1 |  WINDOW SORT                   |                 |      1 |   3000 |   5400K|00:14:12.07 |   77412 |   2404K|   2404K|    20G|    45M|  163M (0)|      18M|
|   2 |   VIEW                         |                 |      1 |   3000 |   5400K|00:04:07.47 |    1509 |      0 |      0 |       |       |          |         |
|*  3 |    CONNECT BY WITHOUT FILTERING|                 |      1 |        |   5400K|00:03:55.99 |    1509 |      0 |      0 |    12M|  1343K|   10M (0)|         |
|   4 |     TABLE ACCESS FULL          | DELIMITED_LISTS |      1 |   3000 |   3000 |00:00:00.01 |    1509 |      0 |      0 |       |       |          |         |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("ID"=PRIOR NULL)
   
