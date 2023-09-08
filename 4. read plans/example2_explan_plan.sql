Plan hash value: 3892127698
 
-----------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |             |     1 |    36 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                         |             |     1 |    36 |     3   (0)| 00:00:01 |
|   2 |   NESTED LOOPS                        |             |     1 |    36 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| EMPLOYEES   |     1 |    15 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN                  | EMP_NAME_IX |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN                  | DEPT_ID_PK  |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID         | DEPARTMENTS |     1 |    21 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / E@SEL$1
   4 - SEL$58A6D7F6 / E@SEL$1
   5 - SEL$58A6D7F6 / D@SEL$1
   6 - SEL$58A6D7F6 / D@SEL$1
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("E"."LAST_NAME"='Smith')
   5 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) "E"."EMPLOYEE_ID"[NUMBER,22], "E"."DEPARTMENT_ID"[NUMBER,22], 
       "D"."DEPARTMENT_ID"[NUMBER,22], "D"."DEPARTMENT_NAME"[VARCHAR2,30], 
       "D"."MANAGER_ID"[NUMBER,22], "D"."LOCATION_ID"[NUMBER,22]
   2 - (#keys=0) "E"."EMPLOYEE_ID"[NUMBER,22], "E"."DEPARTMENT_ID"[NUMBER,22], 
       "D".ROWID[ROWID,10], "D"."DEPARTMENT_ID"[NUMBER,22]
   3 - "E"."EMPLOYEE_ID"[NUMBER,22], "E"."DEPARTMENT_ID"[NUMBER,22]
   4 - "E".ROWID[ROWID,10]
   5 - "D".ROWID[ROWID,10], "D"."DEPARTMENT_ID"[NUMBER,22]
   6 - "D"."DEPARTMENT_NAME"[VARCHAR2,30], "D"."MANAGER_ID"[NUMBER,22], 
       "D"."LOCATION_ID"[NUMBER,22]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 1
---------------------------------------------------------------------------
 
   1 -  SEL$58A6D7F6
           -  leading(e d)
 
Note
-----
   - this is an adaptive plan
