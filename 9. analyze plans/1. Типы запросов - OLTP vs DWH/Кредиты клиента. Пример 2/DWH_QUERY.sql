SQL_ID  7u62fpn1jubmq, child number 0
-------------------------------------
SELECT TRUNC(C.BDAY, 'YYYY'), COUNT(*) FROM CLIENT C JOIN CLIENT_CREDIT 
CC ON C.ID = CC.CLIENT_ID GROUP BY TRUNC(C.BDAY, 'YYYY')
 
Plan hash value: 3424012996
 
---------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name          | Starts |E-Bytes|E-Temp | Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |               |      1 |       |       | 13871 (100)|          |     20 |00:00:00.49 |   26819 |       |       |          |
|   1 |  HASH GROUP BY      |               |      1 |   360 |       | 13871   (2)| 00:00:01 |     20 |00:00:00.49 |   26819 |  1369K|  1369K| 1317K (0)|
|   2 |   HASH JOIN         |               |      1 |    51M|    23M| 13772   (1)| 00:00:01 |   3000K|00:00:00.34 |   26819 |    58M|  9033K|   60M (0)|
|   3 |    TABLE ACCESS FULL| CLIENT        |      1 |    12M|       |  2085   (1)| 00:00:01 |   1000K|00:00:00.03 |    5543 |       |       |          |
|   4 |    TABLE ACCESS FULL| CLIENT_CREDIT |      1 |    14M|       |  8068   (1)| 00:00:01 |   3000K|00:00:00.07 |   21276 |       |       |          |
---------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / C@SEL$1
   4 - SEL$58A6D7F6 / CC@SEL$1
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (rowset=256) TRUNC(INTERNAL_FUNCTION("C"."BDAY"),'fmyyyy')[8], COUNT(*)[22]
   2 - (#keys=1; rowset=256) "C"."BDAY"[DATE,7]
   3 - (rowset=256) "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
   4 - (rowset=256) "CC"."CLIENT_ID"[NUMBER,22]
 
