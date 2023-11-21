Plan hash value: 1625687885
 
----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name                         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |                              |     1 |    44 |    97   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE                       |                              |     1 |    44 |            |          |
|*  2 |   HASH JOIN                           |                              |  6747 |   289K|    97   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |  6747 |   144K|    73   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |  6747 |       |    23   (0)| 00:00:01 |
|   5 |    TABLE ACCESS FULL                  | CLIENT                       | 10000 |   214K|    24   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / CC@SEL$1
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / C@SEL$1
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("C"."ID"="CC"."CLIENT_ID")
   4 - access("CC"."CREATE_DTIME">=ADD_MONTHS(SYSDATE@!,(-12)))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], 
       SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - "CC"."CLIENT_ID"[NUMBER,22]
   4 - "CC".ROWID[ROWID,10]
   5 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
   - this is an adaptive plan
