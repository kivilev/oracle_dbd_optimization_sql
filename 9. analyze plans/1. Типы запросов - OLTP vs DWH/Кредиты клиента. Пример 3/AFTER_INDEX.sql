SQL_ID  aryf37f0bj8h7, child number 0
-------------------------------------
SELECT /*+ index(cc client_credit_create_dtime_i)*/ 
ROUND(AVG(MONTHS_BETWEEN(SYSDATE, C.BDAY)/12), 2) YRS FROM CLIENT C 
JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID WHERE CC.CREATE_DTIME >= 
TRUNC(SYSDATE, 'mm')
 
Plan hash value: 1625687885
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name                         | Starts |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |                              |      1 |       |  2171 (100)|          |      1 |00:00:00.17 |    5616 |     21 |       |       |          |
|   1 |  SORT AGGREGATE                       |                              |      1 |    26 |            |          |      1 |00:00:00.17 |    5616 |     21 |       |       |          |
|   2 |   HASH JOIN                           |                              |      1 |   205K|  2171   (1)| 00:00:01 |   7000 |00:00:00.17 |    5616 |     21 |  2171K|  2171K| 2132K (0)|
|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |      1 |   102K|    82   (0)| 00:00:01 |   7000 |00:00:00.01 |      73 |     21 |       |       |          |
|   4 |     INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |      1 |       |    24   (0)| 00:00:01 |   7000 |00:00:00.01 |      22 |     21 |       |       |          |
|   5 |    TABLE ACCESS FULL                  | CLIENT                       |      1 |    12M|  2085   (1)| 00:00:01 |   1000K|00:00:00.05 |    5543 |      0 |       |       |          |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / CC@SEL$1
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / C@SEL$1
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - "CC"."CLIENT_ID"[NUMBER,22]
   4 - "CC".ROWID[ROWID,10]
   5 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 1
---------------------------------------------------------------------------
 
   3 -  SEL$58A6D7F6 / CC@SEL$1
           -  index(cc client_credit_create_dtime_i)
 
Note
-----
   - this is an adaptive plan
 
