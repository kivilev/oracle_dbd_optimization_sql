SQL_ID  0qqyvvbpsndwp, child number 0
-------------------------------------
SELECT ROUND(AVG(MONTHS_BETWEEN(SYSDATE, C.BDAY)/12), 2) YRS FROM 
CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID WHERE 
CC.CREATE_DTIME >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) AND 
CC.CREATE_DTIME < ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -11)
 
Plan hash value: 3030869904
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name                         | Starts |E-Bytes|E-Temp | Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                              |      1 |       |       |  4307 (100)|          |      1 |00:00:00.24 |    6452 |       |       |          |
|   1 |  SORT AGGREGATE                        |                              |      1 |    26 |       |            |          |      1 |00:00:00.24 |    6452 |       |       |          |
|   2 |   FILTER                               |                              |      1 |       |       |            |          |  93000 |00:00:00.22 |    6452 |       |       |          |
|   3 |    HASH JOIN                           |                              |      1 |  2386K|  2296K|  4307   (1)| 00:00:01 |  93000 |00:00:00.22 |    6452 |  6145K|  2894K| 6796K (0)|
|   4 |     TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |      1 |  1193K|       |   920   (1)| 00:00:01 |  93000 |00:00:00.02 |     909 |       |       |          |
|   5 |      INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |      1 |       |       |   253   (1)| 00:00:01 |  93000 |00:00:00.01 |     249 |       |       |          |
|   6 |     TABLE ACCESS FULL                  | CLIENT                       |      1 |    12M|       |  2085   (1)| 00:00:01 |   1000K|00:00:00.05 |    5543 |       |       |          |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / CC@SEL$1
   6 - SEL$58A6D7F6 / C@SEL$1
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   4 - "CC"."CLIENT_ID"[NUMBER,22]
   5 - "CC".ROWID[ROWID,10]
   6 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Note
-----
   - this is an adaptive plan
 
