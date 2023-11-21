SQL_ID  drywq9th6v9kp, child number 0
-------------------------------------
SELECT /*+ index(cm client_migrate_result_pk) */ CM.CNTR_PUBLIC_ID, 
CM.PST_ID, CM.MRT_ID, CM.CMR_DESCRIPTION, CM.LAST_PROCESSING_DATE FROM 
IDENT_TASKS_MIGRATE.CLIENT_MIGRATE_RESULT CM WHERE CM.CNTR_PUBLIC_ID = 
'D212661E3BC511DDBFFFFFCAFFFFFFDD' AND CM.PST_ID = 0 FOR UPDATE OF 
CM.CNTR_PUBLIC_ID SKIP LOCKED
 
Plan hash value: 1632637792
 
---------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name                     | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                          |      1 |        |       |     2 (100)|          |      1 |00:00:00.01 |       7 |
|   1 |  FOR UPDATE                  |                          |      1 |        |       |            |          |      1 |00:00:00.01 |       7 |
|*  2 |   TABLE ACCESS BY INDEX ROWID| CLIENT_MIGRATE_RESULT    |      1 |      1 |   839 |     2   (0)| 00:00:01 |      1 |00:00:00.01 |       5 |
|*  3 |    INDEX UNIQUE SCAN         | CLIENT_MIGRATE_RESULT_PK |      1 |      1 |       |     1   (0)| 00:00:01 |      1 |00:00:00.01 |       4 |
---------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$1
   2 - SEL$1 / CM@SEL$1
   3 - SEL$1 / CM@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('11.2.0.4')
      DB_VERSION('11.2.0.4')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$1")
      INDEX_RS_ASC(@"SEL$1" "CM"@"SEL$1" ("CLIENT_MIGRATE_RESULT"."CNTR_PUBLIC_ID"))
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter("CM"."PST_ID"=0)
   3 - access("CM"."CNTR_PUBLIC_ID"='D212661E3BC511DDBFFFFFCAFFFFFFDD')
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "CM"."CNTR_PUBLIC_ID"[VARCHAR2,800], "CM"."PST_ID"[NUMBER,22], "CM"."MRT_ID"[NUMBER,22], "CM"."CMR_DESCRIPTION"[VARCHAR2,800], 
       "CM"."LAST_PROCESSING_DATE"[DATE,7]
   2 - "CM".ROWID[ROWID,10], "CM"."CNTR_PUBLIC_ID"[VARCHAR2,800], "CM"."PST_ID"[NUMBER,22], "CM"."MRT_ID"[NUMBER,22], 
       "CM"."CMR_DESCRIPTION"[VARCHAR2,800], "CM"."LAST_PROCESSING_DATE"[DATE,7]
   3 - "CM".ROWID[ROWID,10], "CM"."CNTR_PUBLIC_ID"[VARCHAR2,800]
 
