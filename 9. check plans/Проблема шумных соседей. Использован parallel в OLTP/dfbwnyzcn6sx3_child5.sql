SQL_ID  dfbwnyzcn6sx3, child number 5
-------------------------------------
select /*+ leading(dt4 dt3 dt1 dt2 cl cil) use_nl(dt1 dt2 dt3 dt4 cl 
cil)*/ cl.clnt_external_id   from common_ident.client_data dt4   join 
common_ident.client_data dt3 on dt3.clnt_id = dt4.clnt_id and 
dt3.fld_id = 7 and upper(dt3.cld_value) = :1    join 
common_ident.client_data dt1 on dt1.clnt_id = dt4.clnt_id and 
dt1.fld_id = 9    join common_ident.client cl on cl.clnt_id = 
dt4.clnt_id and cl.prd_id = :2  and cl.bnk_id = :3  and cl.cls_id = 0   
left join common_ident.client_data dt2 on dt2.clnt_id = dt1.clnt_id and 
dt2.fld_id = 8   join common_ident.client_ident_level cil on 
cil.clnt_id = cl.clnt_id and cil.prd_il_id <> 0  where dt4.fld_id = 5   
 and upper(dt4.cld_value) = :4     and 
regexp_replace(upper(dt2.cld_value || dt1.cld_value) collate binary_ci, 
'[^A-ZА-ЯЁ0-9№]+', '')      = regexp_replace(upper(:5 ) collate 
binary_ci, '[^A-ZА-ЯЁ0-9№]+', '')
 
Plan hash value: 3270897714
 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                     | Name                    | E-Rows |E-Bytes| Cost (%CPU)| E-Time   |    TQ  |IN-OUT| PQ Distrib |  OMem |  1Mem |  O/1/M   |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                              |                         |        |       |   192K(100)|          |        |      |            |       |       |          |
|   1 |  PX COORDINATOR                               |                         |        |       |            |          |        |      |            | 73728 | 73728 |          |
|   2 |   PX SEND QC (RANDOM)                         | :TQ10006                |    191K|    26M|   192K  (1)| 00:00:08 |  Q1,06 | P->S | QC (RAND)  |       |       |          |
|*  3 |    HASH JOIN BUFFERED                         |                         |    191K|    26M|   192K  (1)| 00:00:08 |  Q1,06 | PCWP |            |    25M|  6509K|  1273/0/0|
|   4 |     BUFFER SORT                               |                         |        |       |            |          |  Q1,06 | PCWC |            |  1753K|   641K|  1263/0/0|
|   5 |      PX RECEIVE                               |                         |    430K|  9662K|  3035   (1)| 00:00:01 |  Q1,06 | PCWP |            |       |       |          |
|   6 |       PX SEND HYBRID HASH                     | :TQ10000                |    430K|  9662K|  3035   (1)| 00:00:01 |        | S->P | HYBRID HASH|       |       |          |
|   7 |        STATISTICS COLLECTOR                   |                         |        |       |            |          |        |      |            |       |       |          |
|*  8 |         INDEX RANGE SCAN                      | CLIENT_DATA_FLD_VALUE_I |    430K|  9662K|  3035   (1)| 00:00:01 |        |      |            |       |       |          |
|   9 |     PX RECEIVE                                |                         |    190K|    22M|   189K  (1)| 00:00:08 |  Q1,06 | PCWP |            |       |       |          |
|  10 |      PX SEND HYBRID HASH                      | :TQ10005                |    190K|    22M|   189K  (1)| 00:00:08 |  Q1,05 | P->P | HYBRID HASH|       |       |          |
|  11 |       BUFFER SORT                             |                         |    191K|    26M|            |          |  Q1,05 | PCWP |            |  9216 |  9216 |  1279/0/0|
|* 12 |        FILTER                                 |                         |        |       |            |          |  Q1,05 | PCWC |            |       |       |          |
|  13 |         NESTED LOOPS OUTER                    |                         |    190K|    22M|   189K  (1)| 00:00:08 |  Q1,05 | PCWP |            |       |       |          |
|* 14 |          HASH JOIN                            |                         |    123K|    11M|   160K  (1)| 00:00:07 |  Q1,05 | PCWP |            |    10M|  2606K|  1280/0/0|
|  15 |           JOIN FILTER CREATE                  | :BF0000                 |    123K|    11M|   160K  (1)| 00:00:07 |  Q1,05 | PCWP |            |       |       |          |
|  16 |            PX RECEIVE                         |                         |        |       |            |          |  Q1,05 | PCWP |            |       |       |          |
|  17 |             PX SEND HASH                      | :TQ10003                |        |       |            |          |  Q1,03 | P->P | HASH       |       |       |          |
|* 18 |              HASH JOIN                        |                         |    139K|    11M|   154K  (1)| 00:00:07 |  Q1,03 | PCWP |            |    70M|  7220K|  1278/0/0|
|  19 |               JOIN FILTER CREATE              | :BF0001                 |    139K|  6280K|   141K  (1)| 00:00:06 |  Q1,03 | PCWP |            |       |       |          |
|  20 |                PX RECEIVE                     |                         |    139K|  6280K|   141K  (1)| 00:00:06 |  Q1,03 | PCWP |            |       |       |          |
|  21 |                 PX SEND BROADCAST             | :TQ10002                |    139K|  6280K|   141K  (1)| 00:00:06 |  Q1,02 | P->P | BROADCAST  |       |       |          |
|  22 |                  BUFFER SORT                  |                         |    191K|    26M|            |          |  Q1,02 | PCWP |            |  1045K|   546K|  1279/0/0|
|  23 |                   NESTED LOOPS                |                         |    139K|  6280K|   141K  (1)| 00:00:06 |  Q1,02 | PCWP |            |       |       |          |
|  24 |                    NESTED LOOPS               |                         |    139K|  6280K|   141K  (1)| 00:00:06 |  Q1,02 | PCWP |            |       |       |          |
|  25 |                     PX RECEIVE                |                         |        |       |            |          |  Q1,02 | PCWP |            |       |       |          |
|  26 |                      PX SEND ROUND-ROBIN      | :TQ10001                |        |       |            |          |  Q1,01 | S->P | RND-ROBIN  |       |       |          |
|  27 |                       PX SELECTOR             |                         |        |       |            |          |  Q1,01 | SCWC |            |       |       |          |
|* 28 |                        INDEX RANGE SCAN       | CLIENT_DATA_FLD_VALUE_I |    139K|  3140K|  1010   (1)| 00:00:01 |  Q1,01 | SCWP |            |       |       |          |
|* 29 |                     INDEX UNIQUE SCAN         | CLIENT_DATA_PK          |      1 |       |     0   (0)|          |  Q1,02 | PCWP |            |       |       |          |
|  30 |                    TABLE ACCESS BY INDEX ROWID| CLIENT_DATA             |      1 |    23 |     0   (0)|          |  Q1,02 | PCWP |            |       |       |          |
|  31 |               JOIN FILTER USE                 | :BF0001                 |     17M|   722M| 13107   (1)| 00:00:01 |  Q1,03 | PCWP |            |       |       |          |
|  32 |                PX BLOCK ITERATOR              |                         |     17M|   722M| 13107   (1)| 00:00:01 |  Q1,03 | PCWC |            |       |       |          |
|* 33 |                 TABLE ACCESS FULL             | CLIENT                  |     17M|   722M| 13107   (1)| 00:00:01 |  Q1,03 | PCWP |            |       |       |          |
|  34 |           PX RECEIVE                          |                         |     42M|   363M|  5603   (1)| 00:00:01 |  Q1,05 | PCWP |            |       |       |          |
|  35 |            PX SEND HASH                       | :TQ10004                |     42M|   363M|  5603   (1)| 00:00:01 |  Q1,04 | P->P | HASH       |       |       |          |
|  36 |             JOIN FILTER USE                   | :BF0000                 |     42M|   363M|  5603   (1)| 00:00:01 |  Q1,04 | PCWP |            |       |       |          |
|  37 |              PX BLOCK ITERATOR                |                         |     42M|   363M|  5603   (1)| 00:00:01 |  Q1,04 | PCWC |            |       |       |          |
|* 38 |               TABLE ACCESS FULL               | CLIENT_IDENT_LEVEL      |     42M|   363M|  5603   (1)| 00:00:01 |  Q1,04 | PCWP |            |       |       |          |
|  39 |          TABLE ACCESS BY INDEX ROWID          | CLIENT_DATA             |      2 |    46 |     0   (0)|          |  Q1,05 | PCWP |            |       |       |          |
|* 40 |           INDEX UNIQUE SCAN                   | CLIENT_DATA_PK          |      1 |       |     0   (0)|          |  Q1,05 | PCWP |            |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$6106A5A6
   8 - SEL$6106A5A6 / DT3@SEL$1
  28 - SEL$6106A5A6 / DT4@SEL$1
  29 - SEL$6106A5A6 / DT1@SEL$2
  30 - SEL$6106A5A6 / DT1@SEL$2
  33 - SEL$6106A5A6 / CL@SEL$3
  38 - SEL$6106A5A6 / CIL@SEL$5
  39 - SEL$6106A5A6 / DT2@SEL$4
  40 - SEL$6106A5A6 / DT2@SEL$4
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('18.1.0')
      DB_VERSION('18.1.0')
      OPT_PARAM('optimizer_dynamic_sampling' 6)
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$6106A5A6")
      MERGE(@"SEL$34470967" >"SEL$6")
      OUTLINE(@"SEL$6")
      OUTLINE(@"SEL$34470967")
      MERGE(@"SEL$2EDB1937" >"SEL$3B59BFE8")
      OUTLINE(@"SEL$3B59BFE8")
      ANSI_REARCH(@"SEL$5")
      OUTLINE(@"SEL$2EDB1937")
      MERGE(@"SEL$9E43CB6E" >"SEL$34F970FD")
      OUTLINE(@"SEL$5")
      OUTLINE(@"SEL$34F970FD")
      ANSI_REARCH(@"SEL$4")
      OUTLINE(@"SEL$9E43CB6E")
      MERGE(@"SEL$58A6D7F6" >"SEL$3")
      OUTLINE(@"SEL$4")
      OUTLINE(@"SEL$3")
      OUTLINE(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      INDEX(@"SEL$6106A5A6" "DT4"@"SEL$1" "CLIENT_DATA_FLD_VALUE_I")
      INDEX(@"SEL$6106A5A6" "DT1"@"SEL$2" ("CLIENT_DATA"."CLNT_ID" "CLIENT_DATA"."FLD_ID"))
      FULL(@"SEL$6106A5A6" "CL"@"SEL$3")
      FULL(@"SEL$6106A5A6" "CIL"@"SEL$5")
      INDEX_RS_ASC(@"SEL$6106A5A6" "DT2"@"SEL$4" ("CLIENT_DATA"."CLNT_ID" "CLIENT_DATA"."FLD_ID"))
      INDEX(@"SEL$6106A5A6" "DT3"@"SEL$1" "CLIENT_DATA_FLD_VALUE_I")
      LEADING(@"SEL$6106A5A6" "DT4"@"SEL$1" "DT1"@"SEL$2" "CL"@"SEL$3" "CIL"@"SEL$5" "DT2"@"SEL$4" "DT3"@"SEL$1")
      USE_NL(@"SEL$6106A5A6" "DT1"@"SEL$2")
      NLJ_BATCHING(@"SEL$6106A5A6" "DT1"@"SEL$2")
      USE_HASH(@"SEL$6106A5A6" "CL"@"SEL$3")
      USE_HASH(@"SEL$6106A5A6" "CIL"@"SEL$5")
      USE_NL(@"SEL$6106A5A6" "DT2"@"SEL$4")
      USE_HASH(@"SEL$6106A5A6" "DT3"@"SEL$1")
      PQ_DISTRIBUTE(@"SEL$6106A5A6" "DT1"@"SEL$2" RANDOM NONE)
      PQ_DISTRIBUTE(@"SEL$6106A5A6" "CL"@"SEL$3" BROADCAST NONE)
      PX_JOIN_FILTER(@"SEL$6106A5A6" "CL"@"SEL$3")
      PQ_DISTRIBUTE(@"SEL$6106A5A6" "CIL"@"SEL$5" HASH HASH)
      PQ_DISTRIBUTE(@"SEL$6106A5A6" "CIL"@"SEL$5" HASH HASH)
      PX_JOIN_FILTER(@"SEL$6106A5A6" "CIL"@"SEL$5")
      PQ_DISTRIBUTE(@"SEL$6106A5A6" "DT2"@"SEL$4" NONE BROADCAST)
      PQ_DISTRIBUTE(@"SEL$6106A5A6" "DT3"@"SEL$1" HASH HASH)
      SWAP_JOIN_INPUTS(@"SEL$6106A5A6" "DT3"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Peeked Binds (identified by position):
--------------------------------------
 
   1 - :1 (VARCHAR2(30), CSID=873): 'FOREIGN_COUNTRY_IDENTIFYING_DOCUMENT'
   2 - :2 (NUMBER): 9
   3 - (NUMBER): 1
   4 - (VARCHAR2(30), CSID=873): 'KZ'
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DT3"."CLNT_ID"="DT4"."CLNT_ID")
   8 - access("DT3"."FLD_ID"=7 AND "DT3"."SYS_NC00006$"=:1)
  12 - filter(NLSSORT( REGEXP_REPLACE (UPPER("DT2"."CLD_VALUE"||"DT1"."CLD_VALUE") COLLATE "BINARY_CI",'[^A-ZА-ЯЁ0-9№]+','',<not feasible>)
  14 - access("CIL"."CLNT_ID"="CL"."CLNT_ID")
  18 - access("CL"."CLNT_ID"="DT4"."CLNT_ID")
  28 - access("DT4"."FLD_ID"=5 AND "DT4"."SYS_NC00006$"=:4)
  29 - access("DT1"."CLNT_ID"="DT4"."CLNT_ID" AND "DT1"."FLD_ID"=9)
  33 - access(:Z>=:Z AND :Z<=:Z)
       filter(("CL"."CLS_ID"=0 AND "CL"."PRD_ID"=:2 AND "CL"."BNK_ID"=:3 AND SYS_OP_BLOOM_FILTER(:BF0001,"CL"."CLNT_ID")))
  38 - access(:Z>=:Z AND :Z<=:Z)
       filter(("CIL"."PRD_IL_ID"<>0 AND SYS_OP_BLOOM_FILTER(:BF0000,"CIL"."CLNT_ID")))
  40 - access("DT2"."CLNT_ID"="DT1"."CLNT_ID" AND "DT2"."FLD_ID"=8)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
   2 - (#keys=0) "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
   3 - (#keys=1; rowset=150) "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
   4 - (#keys=0; rowset=256) "DT3"."CLNT_ID"[NUMBER,22]
   5 - (rowset=256) "DT3"."CLNT_ID"[NUMBER,22]
   6 - (#keys=1) "DT3"."CLNT_ID"[NUMBER,22]
   7 - "DT3"."CLNT_ID"[NUMBER,22]
   8 - "DT3"."CLNT_ID"[NUMBER,22]
   9 - (rowset=150) "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  10 - (#keys=1) "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  11 - (#keys=0; rowset=150) "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  12 - "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  13 - "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400], "DT2"."CLD_VALUE"[VARCHAR2,1200]
  14 - (#keys=1) "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  15 - "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  16 - "CL"."CLNT_ID"[NUMBER,22], "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22]
  17 - (#keys=1) "CL"."CLNT_ID"[NUMBER,22], "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400], "DT1"."CLD_VALUE"[VARCHAR2,1200], 
       "DT1"."CLNT_ID"[NUMBER,22]
  18 - (#keys=1) "DT4"."CLNT_ID"[NUMBER,22], "CL"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22], 
       "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  19 - (rowset=52) "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22]
  20 - (rowset=52) "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22]
  21 - (#keys=0) "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22]
  22 - (#keys=0; rowset=52) "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT1"."CLNT_ID"[NUMBER,22]
  23 - "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200]
  24 - "DT4"."CLNT_ID"[NUMBER,22], "DT1".ROWID[ROWID,10], "DT1"."CLNT_ID"[NUMBER,22]
  25 - "DT4"."CLNT_ID"[NUMBER,22]
  26 - (#keys=0) "DT4"."CLNT_ID"[NUMBER,22]
  27 - "DT4".ROWID[ROWID,10], "DT4"."CLNT_ID"[NUMBER,22], "DT4"."FLD_ID"[NUMBER,22], "DT4"."SYS_NC00006$"[VARCHAR2,1200]
  28 - "DT4".ROWID[ROWID,10], "DT4"."CLNT_ID"[NUMBER,22], "DT4"."FLD_ID"[NUMBER,22], "DT4"."SYS_NC00006$"[VARCHAR2,1200]
  29 - "DT1".ROWID[ROWID,10], "DT1"."CLNT_ID"[NUMBER,22]
  30 - "DT1"."CLD_VALUE"[VARCHAR2,1200]
  31 - (rowset=150) "CL"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  32 - (rowset=150) "CL"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  33 - (rowset=150) "CL"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  34 - "CIL"."CLNT_ID"[NUMBER,22]
  35 - (#keys=1) "CIL"."CLNT_ID"[NUMBER,22]
  36 - (rowset=256) "CIL"."CLNT_ID"[NUMBER,22]
  37 - (rowset=256) "CIL"."CLNT_ID"[NUMBER,22]
  38 - (rowset=256) "CIL"."CLNT_ID"[NUMBER,22]
  39 - "DT2"."CLD_VALUE"[VARCHAR2,1200]
  40 - "DT2".ROWID[ROWID,10]
 
Note
-----
   - SQL profile SYS_SQLPROF_0188c39312410001 used for this statement
   - this is an adaptive plan
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
   - parallel query server generated this plan using optimizer hints from coordinator
 
