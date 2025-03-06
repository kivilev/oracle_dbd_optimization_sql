SQL_ID  at2c9hbatmy12, child number 0
-------------------------------------
SELECT /*+ use_nl(c cc)*/TRUNC(C.BDAY, 'YYYY'), COUNT(*) FROM CLIENT C 
JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID GROUP BY TRUNC(C.BDAY, 
'YYYY')
 
Plan hash value: 2133407294
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name          | Starts |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |               |      1 |       |  6003K(100)|          |     20 |00:00:06.62 |    9021K|   1163 |       |       |          |
|   1 |  HASH GROUP BY                |               |      1 |   360 |  6003K  (1)| 00:03:55 |     20 |00:00:06.62 |    9021K|   1163 |  1369K|  1369K| 1296K (0)|
|   2 |   NESTED LOOPS                |               |      1 |    51M|  6003K  (1)| 00:03:55 |   3000K|00:00:06.23 |    9021K|   1163 |       |       |          |
|   3 |    NESTED LOOPS               |               |      1 |    51M|  6003K  (1)| 00:03:55 |   3000K|00:00:03.93 |    6021K|   1163 |       |       |          |
|   4 |     TABLE ACCESS FULL         | CLIENT_CREDIT |      1 |    14M|  8068   (1)| 00:00:01 |   3000K|00:00:00.21 |   21276 |      0 |       |       |          |
|   5 |     INDEX UNIQUE SCAN         | CLIENT_PK     |   3000K|       |     1   (0)| 00:00:01 |   3000K|00:00:03.25 |    6000K|   1163 |       |       |          |
|   6 |    TABLE ACCESS BY INDEX ROWID| CLIENT        |   3000K|    13 |     2   (0)| 00:00:01 |   3000K|00:00:01.85 |    3000K|      0 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / C@SEL$1
   6 - SEL$58A6D7F6 / C@SEL$1
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (rowset=256) TRUNC(INTERNAL_FUNCTION("C"."BDAY"),'fmyyyy')[8], COUNT(*)[22]
   2 - "C"."BDAY"[DATE,7]
   3 - "C".ROWID[ROWID,10]
   4 - "CC"."CLIENT_ID"[NUMBER,22]
   5 - "C".ROWID[ROWID,10]
   6 - "C"."BDAY"[DATE,7]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 2 (U - Unused (1))
---------------------------------------------------------------------------
 
   4 -  SEL$58A6D7F6 / CC@SEL$1
         U -  use_nl(c cc)
 
   5 -  SEL$58A6D7F6 / C@SEL$1
           -  use_nl(c cc)
 
