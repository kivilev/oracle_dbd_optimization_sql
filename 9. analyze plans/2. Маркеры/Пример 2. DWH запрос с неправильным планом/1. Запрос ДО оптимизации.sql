SQL_ID  f55t7s6f328qx, child number 0
-------------------------------------
SELECT COUNT(*) FROM COMMON_IDENT.CLIENT CL JOIN 
COMMON_IDENT.CLIENT_IDENT_LEVEL LVL ON CL.CLNT_ID = LVL.CLNT_ID AND 
LVL.CORE_IL_ID = 2 WHERE CL.CLS_ID = 0
 
Plan hash value: 1229357961
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name                         | Starts | E-Rows |E-Bytes|E-Temp | Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  | Writes |  OMem |  1Mem | Used-Mem | Used-Tmp|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |                              |      1 |        |       |       |   251K(100)|          |      1 |00:01:14.95 |    1116K|    955K|   5487 |       |       |          |         |
|   1 |  SORT AGGREGATE                       |                              |      1 |      1 |    21 |       |            |          |      1 |00:01:14.95 |    1116K|    955K|   5487 |       |       |          |         |
|*  2 |   HASH JOIN                           |                              |      1 |   3821K|    76M|    87M|   251K  (1)| 00:00:10 |   1754K|00:01:14.86 |    1116K|    955K|   5487 |   187M|    11M|  194M (0)|   53248 |
|*  3 |    TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_IDENT_LEVEL           |      1 |   3821K|    43M|       | 57165   (1)| 00:00:03 |   3916K|00:00:47.70 |     339K|    284K|      0 |       |       |          |         |
|*  4 |     INDEX RANGE SCAN                  | CLIENT_IDENT_LEVEL_CORE_ID_I |      1 |   3821K|       |       | 11154   (1)| 00:00:01 |   3916K|00:00:05.70 |   32370 |  10266 |      0 |       |       |          |         |
|*  5 |    TABLE ACCESS FULL                  | CLIENT                       |      1 |     24M|   209M|       |   165K  (1)| 00:00:07 |     25M|00:00:15.96 |     776K|    664K|      0 |       |       |          |         |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / LVL@SEL$1
   4 - SEL$58A6D7F6 / LVL@SEL$1
   5 - SEL$58A6D7F6 / CL@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('18.1.0')
      DB_VERSION('18.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      INDEX_RS_ASC(@"SEL$58A6D7F6" "LVL"@"SEL$1" ("CLIENT_IDENT_LEVEL"."CORE_IL_ID"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$58A6D7F6" "LVL"@"SEL$1")
      FULL(@"SEL$58A6D7F6" "CL"@"SEL$1")
      LEADING(@"SEL$58A6D7F6" "LVL"@"SEL$1" "CL"@"SEL$1")
      USE_HASH(@"SEL$58A6D7F6" "CL"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CL"."CLNT_ID"="LVL"."CLNT_ID")
   3 - filter("PRD_IL_ID"<=2)
   4 - access("LVL"."CORE_IL_ID"=2)
   5 - filter("CL"."CLS_ID"=0)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(*)[22]
   2 - (#keys=1) 
   3 - "LVL"."CLNT_ID"[NUMBER,22]
   4 - "LVL".ROWID[ROWID,10]
   5 - "CL"."CLNT_ID"[NUMBER,22]
 
Note
-----
   - this is an adaptive plan
 
