/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Домашнее задание N. Чтение планов запросов в части доступа к данным, выбора индексов

*/ 

select e.employee_id
      ,d.department_name
  from hr.employees e
  join hr.departments d on d.department_id = e.department_id;
  
----------------------------------------------------------
| Id  | Operation                    | Name              |
----------------------------------------------------------
|   0 | SELECT STATEMENT             |                   |
|   1 |  MERGE JOIN                  |                   |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |
|   3 |    INDEX FULL SCAN           | DEPT_ID_PK        |
|*  4 |   SORT JOIN                  |                   |
|   5 |    VIEW                      | index$_join$_001  |
|*  6 |     HASH JOIN                |                   |
|   7 |      INDEX FAST FULL SCAN    | EMP_DEPARTMENT_IX |
|   8 |      INDEX FAST FULL SCAN    | EMP_EMP_ID_PK     |
----------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
       filter("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
   6 - access(ROWID=ROWID)


