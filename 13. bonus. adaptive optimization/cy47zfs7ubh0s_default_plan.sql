SQL_ID  cy47zfs7ubh0s, child number 0
-------------------------------------
SELECT E.FIRST_NAME ,E.LAST_NAME ,E.SALARY ,D.DEPARTMENT_NAME FROM 
HR.EMPLOYEES E ,HR.DEPARTMENTS D WHERE E.DEPARTMENT_ID = 
D.DEPARTMENT_ID AND D.DEPARTMENT_NAME IN ('Marketing', 'Sales')
 
Plan hash value: 1021246405
 
-----------------------------------------------------------------------------------------------------
|   Id  | Operation                     | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
|     0 | SELECT STATEMENT              |                   |       |       |     5 (100)|          |
|- *  1 |  HASH JOIN                    |                   |    19 |   722 |     5   (0)| 00:00:01 |
|     2 |   NESTED LOOPS                |                   |    19 |   722 |     5   (0)| 00:00:01 |
|     3 |    NESTED LOOPS               |                   |    20 |   722 |     5   (0)| 00:00:01 |
|-    4 |     STATISTICS COLLECTOR      |                   |       |       |            |          |
|  *  5 |      TABLE ACCESS FULL        | DEPARTMENTS       |     2 |    32 |     4   (0)| 00:00:01 |
|  *  6 |     INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |    10 |       |     0   (0)|          |
|     7 |    TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |    10 |   220 |     1   (0)| 00:00:01 |
|-    8 |   TABLE ACCESS FULL           | EMPLOYEES         |    10 |   220 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   5 - filter(("D"."DEPARTMENT_NAME"='Marketing' OR "D"."DEPARTMENT_NAME"='Sales'))
   6 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
 
Note
-----
   - this is an adaptive plan (rows marked '-' are inactive)
 
