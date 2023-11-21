SQL_ID  dbnqya757q85y, child number 0
-------------------------------------
SELECT /*+ FULL(lvl) parallel(cl 4) parallel(lvl 4)*/COUNT(*) FROM 
COMMON_IDENT.CLIENT CL JOIN COMMON_IDENT.CLIENT_IDENT_LEVEL LVL ON 
CL.CLNT_ID = LVL.CLNT_ID AND LVL.CORE_IL_ID = 2 WHERE CL.CLS_ID = 0
 
Plan hash value: 2976262980
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                  | Name               | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   |    TQ  |IN-OUT| PQ Distrib | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT           |                    |      1 |        |       | 65502 (100)|          |        |      |            |      1 |00:00:06.75 |     123 |       |       |          |
|   1 |  SORT AGGREGATE            |                    |      1 |      1 |    21 |            |          |        |      |            |      1 |00:00:06.75 |     123 |       |       |          |
|   2 |   PX COORDINATOR           |                    |      1 |        |       |            |          |        |      |            |      4 |00:00:06.75 |     123 | 73728 | 73728 |          |
|   3 |    PX SEND QC (RANDOM)     | :TQ10001           |      0 |      1 |    21 |            |          |  Q1,01 | P->S | QC (RAND)  |      0 |00:00:00.01 |       0 |       |       |          |
|   4 |     SORT AGGREGATE         |                    |      0 |      1 |    21 |            |          |  Q1,01 | PCWP |            |      0 |00:00:00.01 |       0 |       |       |          |
|*  5 |      HASH JOIN             |                    |      0 |   3463K|    69M| 65502   (1)| 00:00:03 |  Q1,01 | PCWP |            |      0 |00:00:00.01 |       0 |   736M|    23M|  186M (0)|
|   6 |       JOIN FILTER CREATE   | :BF0000            |      0 |   3463K|    39M| 19624   (1)| 00:00:01 |  Q1,01 | PCWP |            |      0 |00:00:00.01 |       0 |       |       |          |
|   7 |        PX RECEIVE          |                    |      0 |   3463K|    39M| 19624   (1)| 00:00:01 |  Q1,01 | PCWP |            |      0 |00:00:00.01 |       0 |       |       |          |
|   8 |         PX SEND BROADCAST  | :TQ10000           |      0 |   3463K|    39M| 19624   (1)| 00:00:01 |  Q1,00 | P->P | BROADCAST  |      0 |00:00:00.01 |       0 |       |       |          |
|   9 |          PX BLOCK ITERATOR |                    |      0 |   3463K|    39M| 19624   (1)| 00:00:01 |  Q1,00 | PCWC |            |      0 |00:00:00.01 |       0 |       |       |          |
|* 10 |           TABLE ACCESS FULL| CLIENT_IDENT_LEVEL |      0 |   3463K|    39M| 19624   (1)| 00:00:01 |  Q1,00 | PCWP |            |      0 |00:00:00.01 |       0 |       |       |          |
|  11 |       JOIN FILTER USE      | :BF0000            |      0 |     24M|   209M| 45856   (1)| 00:00:02 |  Q1,01 | PCWP |            |      0 |00:00:00.01 |       0 |       |       |          |
|  12 |        PX BLOCK ITERATOR   |                    |      0 |     24M|   209M| 45856   (1)| 00:00:02 |  Q1,01 | PCWC |            |      0 |00:00:00.01 |       0 |       |       |          |
|* 13 |         TABLE ACCESS FULL  | CLIENT             |      0 |     24M|   209M| 45856   (1)| 00:00:02 |  Q1,01 | PCWP |            |      0 |00:00:00.01 |       0 |       |       |          |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
  10 - SEL$58A6D7F6 / LVL@SEL$1
  13 - SEL$58A6D7F6 / CL@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('18.1.0')
      DB_VERSION('18.1.0')
      OPT_PARAM('optimizer_dynamic_sampling' 5)
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      FULL(@"SEL$58A6D7F6" "LVL"@"SEL$1")
      FULL(@"SEL$58A6D7F6" "CL"@"SEL$1")
      LEADING(@"SEL$58A6D7F6" "LVL"@"SEL$1" "CL"@"SEL$1")
      USE_HASH(@"SEL$58A6D7F6" "CL"@"SEL$1")
      PQ_DISTRIBUTE(@"SEL$58A6D7F6" "CL"@"SEL$1" BROADCAST NONE)
      PX_JOIN_FILTER(@"SEL$58A6D7F6" "CL"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("CL"."CLNT_ID"="LVL"."CLNT_ID")
  10 - access(:Z>=:Z AND :Z<=:Z)
       filter(("LVL"."CORE_IL_ID"=2 AND "PRD_IL_ID"<=2))
  13 - access(:Z>=:Z AND :Z<=:Z)
       filter(("CL"."CLS_ID"=0 AND SYS_OP_BLOOM_FILTER(:BF0000,"CL"."CLNT_ID")))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT()[22]
   2 - SYS_OP_MSR()[10]
   3 - (#keys=0) SYS_OP_MSR()[10]
   4 - (#keys=0) SYS_OP_MSR()[10]
   5 - (#keys=1; rowset=1019) 
   6 - (rowset=256) "LVL"."CLNT_ID"[NUMBER,22]
   7 - (rowset=256) "LVL"."CLNT_ID"[NUMBER,22]
   8 - (#keys=0) "LVL"."CLNT_ID"[NUMBER,22]
   9 - (rowset=256) "LVL"."CLNT_ID"[NUMBER,22]
  10 - (rowset=256) "LVL"."CLNT_ID"[NUMBER,22]
  11 - (rowset=256) "CL"."CLNT_ID"[NUMBER,22]
  12 - (rowset=256) "CL"."CLNT_ID"[NUMBER,22]
  13 - (rowset=256) "CL"."CLNT_ID"[NUMBER,22]
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=5)
   - Degree of Parallelism is 4 because of table property
 
