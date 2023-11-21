Plan hash value: 1660074313
 
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name                         | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                              |     1 |    44 |   557   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE                        |                              |     1 |    44 |            |          |
|   2 |   NESTED LOOPS                         |                              |   664 | 29216 |   557   (0)| 00:00:01 |
|   3 |    NESTED LOOPS                        |                              |   664 | 29216 |   557   (0)| 00:00:01 |
|   4 |     TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |   664 | 14608 |     9   (0)| 00:00:01 |
|*  5 |      INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |   664 |       |     4   (0)| 00:00:01 |
|*  6 |     INDEX UNIQUE SCAN                  | CLIENT_PK                    |     1 |       |     0   (0)| 00:00:01 |
|   7 |    TABLE ACCESS BY INDEX ROWID         | CLIENT                       |     1 |    22 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / CC@SEL$1
   6 - SEL$58A6D7F6 / C@SEL$1
   7 - SEL$58A6D7F6 / C@SEL$1
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("CC"."CREATE_DTIME">=TRUNC(SYSDATE@!,'fmmm'))
   6 - access("C"."ID"="CC"."CLIENT_ID")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], 
       SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - (#keys=0) "C"."BDAY"[DATE,7]
   3 - (#keys=0) "C".ROWID[ROWID,10]
   4 - "CC"."CLIENT_ID"[NUMBER,22]
   5 - "CC".ROWID[ROWID,10]
   6 - "C".ROWID[ROWID,10]
   7 - "C"."BDAY"[DATE,7]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 3 (U - Unused (1))
---------------------------------------------------------------------------
 
   1 -  SEL$58A6D7F6
           -  leading(cc c)
 
   4 -  SEL$58A6D7F6 / CC@SEL$1
         U -  use_nl(c cc)
 
   6 -  SEL$58A6D7F6 / C@SEL$1
           -  use_nl(c cc)
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
