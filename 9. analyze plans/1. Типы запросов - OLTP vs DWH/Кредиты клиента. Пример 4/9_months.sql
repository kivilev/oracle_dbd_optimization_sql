SQL_ID  cqdxucmxc6y65, child number 0
-------------------------------------
SELECT ROUND(AVG(MONTHS_BETWEEN(SYSDATE, C.BDAY)/12), 2) YRS FROM 
CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID WHERE 
CC.CREATE_DTIME >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) AND 
CC.CREATE_DTIME < ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -3)
 
Plan hash value: 3030869904
 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name                         | Starts |E-Bytes|E-Temp | Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  | Writes |  OMem |  1Mem | Used-Mem | Used-Tmp|
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                              |      1 |       |       | 12284 (100)|          |      1 |00:00:01.95 |   13553 |   4597 |   2400 |       |       |          |         |
|   1 |  SORT AGGREGATE                        |                              |      1 |    26 |       |            |          |      1 |00:00:01.95 |   13553 |   4597 |   2400 |       |       |          |         |
|   2 |   FILTER                               |                              |      1 |       |       |            |          |    822K|00:00:01.85 |   13553 |   4597 |   2400 |       |       |          |         |
|   3 |    HASH JOIN                           |                              |      1 |    20M|    19M| 12284   (1)| 00:00:01 |    822K|00:00:01.80 |   13553 |   4597 |   2400 |    41M|  5786K|   47M (1)|      20M|
|   4 |     TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |      1 |    10M|       |  8033   (1)| 00:00:01 |    822K|00:00:00.67 |    8010 |   2182 |      0 |       |       |          |         |
|   5 |      INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |      1 |       |       |  2192   (1)| 00:00:01 |    822K|00:00:00.56 |    2183 |   2182 |      0 |       |       |          |         |
|   6 |     TABLE ACCESS FULL                  | CLIENT                       |      1 |    12M|       |  2085   (1)| 00:00:01 |   1000K|00:00:00.05 |    5543 |      0 |      0 |       |       |          |         |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
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
 
