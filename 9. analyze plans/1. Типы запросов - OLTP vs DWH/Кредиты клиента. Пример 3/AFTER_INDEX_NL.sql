SQL_ID  9g8338md26gv4, child number 0
-------------------------------------
SELECT /*+ use_nl(c cc) leading(cc c) index(cc 
client_credit_create_dtime_i)*/ROUND(AVG(MONTHS_BETWEEN(SYSDATE, 
C.BDAY)/12), 2) YRS FROM CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = 
CC.CLIENT_ID WHERE CC.CREATE_DTIME >= TRUNC(SYSDATE, 'mm')
 
Plan hash value: 1660074313
 
--------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name                         | Starts |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                              |      1 |       | 16255 (100)|          |      1 |00:00:00.02 |   21075 |
|   1 |  SORT AGGREGATE                        |                              |      1 |    26 |            |          |      1 |00:00:00.02 |   21075 |
|   2 |   NESTED LOOPS                         |                              |      1 |   205K| 16255   (1)| 00:00:01 |   7000 |00:00:00.02 |   21075 |
|   3 |    NESTED LOOPS                        |                              |      1 |   205K| 16255   (1)| 00:00:01 |   7000 |00:00:00.01 |   14075 |
|   4 |     TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |      1 |   102K|    82   (0)| 00:00:01 |   7000 |00:00:00.01 |      73 |
|   5 |      INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |      1 |       |    24   (0)| 00:00:01 |   7000 |00:00:00.01 |      22 |
|   6 |     INDEX UNIQUE SCAN                  | CLIENT_PK                    |   7000 |       |     1   (0)| 00:00:01 |   7000 |00:00:00.01 |   14002 |
|   7 |    TABLE ACCESS BY INDEX ROWID         | CLIENT                       |   7000 |    13 |     2   (0)| 00:00:01 |   7000 |00:00:00.01 |    7000 |
--------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / CC@SEL$1
   6 - SEL$58A6D7F6 / C@SEL$1
   7 - SEL$58A6D7F6 / C@SEL$1
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], 
       SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - "C"."BDAY"[DATE,7]
   3 - "C".ROWID[ROWID,10]
   4 - "CC"."CLIENT_ID"[NUMBER,22]
   5 - "CC".ROWID[ROWID,10]
   6 - "C".ROWID[ROWID,10]
   7 - "C"."BDAY"[DATE,7]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 4 (U - Unused (1))
---------------------------------------------------------------------------
 
   1 -  SEL$58A6D7F6
           -  leading(cc c)
 
   4 -  SEL$58A6D7F6 / CC@SEL$1
         U -  use_nl(c cc)
           -  index(cc
client_credit_create_dtime_i)
 
   6 -  SEL$58A6D7F6 / C@SEL$1
           -  use_nl(c cc)
 
