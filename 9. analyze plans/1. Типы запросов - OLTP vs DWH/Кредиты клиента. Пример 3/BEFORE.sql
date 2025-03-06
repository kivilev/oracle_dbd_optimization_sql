SQL_ID  g8awrhasajsts, child number 0
-------------------------------------
SELECT ROUND(AVG(MONTHS_BETWEEN(SYSDATE, C.BDAY)/12), 2) YRS FROM 
CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID WHERE 
CC.CREATE_DTIME >= TRUNC(SYSDATE, 'mm')
 
Plan hash value: 3122511200
 
-------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name          | Starts |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |               |      1 |       | 10215 (100)|          |      1 |00:00:00.27 |   26819 |       |       |          |
|   1 |  SORT AGGREGATE     |               |      1 |    26 |            |          |      1 |00:00:00.27 |   26819 |       |       |          |
|   2 |   HASH JOIN         |               |      1 |   205K| 10215   (1)| 00:00:01 |   7000 |00:00:00.26 |   26819 |  2171K|  2171K| 2139K (0)|
|   3 |    TABLE ACCESS FULL| CLIENT_CREDIT |      1 |   102K|  8126   (1)| 00:00:01 |   7000 |00:00:00.11 |   21276 |       |       |          |
|   4 |    TABLE ACCESS FULL| CLIENT        |      1 |    12M|  2085   (1)| 00:00:01 |   1000K|00:00:00.05 |    5543 |       |       |          |
-------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / CC@SEL$1
   4 - SEL$58A6D7F6 / C@SEL$1
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], 
       SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - "CC"."CLIENT_ID"[NUMBER,22]
   4 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Note
-----
   - this is an adaptive plan
 
