-- “Œ“ ∆≈ «¿œ–Œ— “ŒÀ‹ Œ — BIND VARS

SQL_ID  201b04a26f2kn, child number 0
-------------------------------------
SELECT /*+ leading(dt4 dt3 dt1 dt2 cl cil) use_nl(dt1 dt2 dt3 dt4 cl
cil)*/ CL.CLNT_EXTERNAL_ID FROM COMMON_IDENT.CLIENT_DATA DT4 JOIN
COMMON_IDENT.CLIENT_DATA DT3 ON DT3.CLNT_ID = DT4.CLNT_ID AND
DT3.FLD_ID = 7 AND UPPER(DT3.CLD_VALUE) =
'FOREIGN_COUNTRY_IDENTIFYING_DOCUMENT' JOIN COMMON_IDENT.CLIENT_DATA
DT1 ON DT1.CLNT_ID = DT4.CLNT_ID AND DT1.FLD_ID = 9 JOIN
COMMON_IDENT.CLIENT CL ON CL.CLNT_ID = DT4.CLNT_ID AND CL.PRD_ID = 9
AND CL.BNK_ID = 1 AND CL.CLS_ID = 0 LEFT JOIN COMMON_IDENT.CLIENT_DATA
DT2 ON DT2.CLNT_ID = DT1.CLNT_ID AND DT2.FLD_ID = 8 JOIN
COMMON_IDENT.CLIENT_IDENT_LEVEL CIL ON CIL.CLNT_ID = CL.CLNT_ID AND
CIL.PRD_IL_ID <> 0 WHERE DT4.FLD_ID = 5 AND UPPER(DT4.CLD_VALUE) = 'BY'
AND REGEXP_REPLACE(UPPER(DT2.CLD_VALUE || DT1.CLD_VALUE) COLLATE
BINARY_CI, '[^A-Z¿-ﬂ®0-9π]+', '') = REGEXP_REPLACE(UPPER('MC3081625')
COLLATE BINARY_CI, '[^A-Z¿-ﬂ®0-9π]+', '')

Plan hash value: 1565037707

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name                          | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                               |      1 |        |       |    16 (100)|          |      1 |00:01:06.19 |     864K|    143K|
|   1 |  NESTED LOOPS                      |                               |      1 |      1 |   144 |    16   (0)| 00:00:01 |      1 |00:01:06.19 |     864K|    143K|
|   2 |   NESTED LOOPS                     |                               |      1 |      1 |   144 |    16   (0)| 00:00:01 |      1 |00:01:06.19 |     864K|    143K|
|   3 |    NESTED LOOPS                    |                               |      1 |      1 |   135 |    14   (0)| 00:00:01 |      1 |00:01:06.19 |     864K|    143K|
|*  4 |     FILTER                         |                               |      1 |        |       |            |          |      1 |00:01:06.19 |     864K|    143K|
|   5 |      NESTED LOOPS OUTER            |                               |      1 |      1 |    92 |    12   (0)| 00:00:01 |  77537 |00:01:05.21 |     864K|    143K|
|   6 |       NESTED LOOPS                 |                               |      1 |      1 |    69 |     9   (0)| 00:00:01 |  77537 |00:01:04.98 |     621K|    143K|
|   7 |        NESTED LOOPS                |                               |      1 |      1 |    46 |     6   (0)| 00:00:01 |  77540 |00:01:04.13 |     311K|    142K|
|*  8 |         INDEX RANGE SCAN           | CLIENT_DATA_FLD_VALUE_I       |      1 |      1 |    23 |     4   (0)| 00:00:01 |  77706 |00:00:00.28 |     448 |    446 |
|*  9 |         TABLE ACCESS BY INDEX ROWID| CLIENT_DATA                   |  77706 |      1 |    23 |     3   (0)| 00:00:01 |  77540 |00:01:03.80 |     310K|    142K|
|* 10 |          INDEX UNIQUE SCAN         | CLIENT_DATA_PK                |  77706 |      1 |       |     2   (0)| 00:00:01 |  77693 |00:00:31.71 |     233K|  69714 |
|  11 |        TABLE ACCESS BY INDEX ROWID | CLIENT_DATA                   |  77540 |      1 |    23 |     3   (0)| 00:00:01 |  77537 |00:00:00.79 |     310K|    995 |
|* 12 |         INDEX UNIQUE SCAN          | CLIENT_DATA_PK                |  77540 |      1 |       |     2   (0)| 00:00:01 |  77537 |00:00:00.42 |     232K|    224 |
|  13 |       TABLE ACCESS BY INDEX ROWID  | CLIENT_DATA                   |  77537 |      2 |    46 |     3   (0)| 00:00:01 |  10158 |00:00:00.17 |     242K|      7 |
|* 14 |        INDEX UNIQUE SCAN           | CLIENT_DATA_PK                |  77537 |      1 |       |     2   (0)| 00:00:01 |  10158 |00:00:00.13 |     232K|      0 |
|* 15 |     TABLE ACCESS BY INDEX ROWID    | CLIENT                        |      1 |      1 |    43 |     2   (0)| 00:00:01 |      1 |00:00:00.01 |       9 |      0 |
|* 16 |      INDEX UNIQUE SCAN             | CLIENT_PK                     |      1 |      1 |       |     1   (0)| 00:00:01 |      1 |00:00:00.01 |       3 |      0 |
|* 17 |    INDEX UNIQUE SCAN               | CLIENT_IDENT_LEVEL_CLNT_ID_UQ |      1 |      1 |       |     1   (0)| 00:00:01 |      1 |00:00:00.01 |       3 |      0 |
|* 18 |   TABLE ACCESS BY INDEX ROWID      | CLIENT_IDENT_LEVEL            |      1 |      1 |     9 |     2   (0)| 00:00:01 |      1 |00:00:00.01 |       1 |      0 |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------

   1 - SEL$6106A5A6
   8 - SEL$6106A5A6 / DT4@SEL$1
   9 - SEL$6106A5A6 / DT3@SEL$1
  10 - SEL$6106A5A6 / DT3@SEL$1
  11 - SEL$6106A5A6 / DT1@SEL$2
  12 - SEL$6106A5A6 / DT1@SEL$2
  13 - SEL$6106A5A6 / DT2@SEL$4
  14 - SEL$6106A5A6 / DT2@SEL$4
  15 - SEL$6106A5A6 / CL@SEL$3
  16 - SEL$6106A5A6 / CL@SEL$3
  17 - SEL$6106A5A6 / CIL@SEL$5
  18 - SEL$6106A5A6 / CIL@SEL$5

Outline Data
-------------

  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('18.1.0')
      DB_VERSION('18.1.0')
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
      INDEX_RS_ASC(@"SEL$6106A5A6" "DT3"@"SEL$1" ("CLIENT_DATA"."CLNT_ID" "CLIENT_DATA"."FLD_ID"))
      INDEX_RS_ASC(@"SEL$6106A5A6" "DT1"@"SEL$2" ("CLIENT_DATA"."CLNT_ID" "CLIENT_DATA"."FLD_ID"))
      INDEX_RS_ASC(@"SEL$6106A5A6" "DT2"@"SEL$4" ("CLIENT_DATA"."CLNT_ID" "CLIENT_DATA"."FLD_ID"))
      INDEX_RS_ASC(@"SEL$6106A5A6" "CL"@"SEL$3" ("CLIENT"."CLNT_ID"))
      INDEX(@"SEL$6106A5A6" "CIL"@"SEL$5" ("CLIENT_IDENT_LEVEL"."CLNT_ID"))
      LEADING(@"SEL$6106A5A6" "DT4"@"SEL$1" "DT3"@"SEL$1" "DT1"@"SEL$2" "DT2"@"SEL$4" "CL"@"SEL$3" "CIL"@"SEL$5")
      USE_NL(@"SEL$6106A5A6" "DT3"@"SEL$1")
      USE_NL(@"SEL$6106A5A6" "DT1"@"SEL$2")
      USE_NL(@"SEL$6106A5A6" "DT2"@"SEL$4")
      USE_NL(@"SEL$6106A5A6" "CL"@"SEL$3")
      USE_NL(@"SEL$6106A5A6" "CIL"@"SEL$5")
      NLJ_BATCHING(@"SEL$6106A5A6" "CIL"@"SEL$5")
      END_OUTLINE_DATA
  */

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - filter(NLSSORT( REGEXP_REPLACE (UPPER("DT2"."CLD_VALUE"||"DT1"."CLD_VALUE") COLLATE "BINARY_CI",'[^A-Z¿-ﬂ®0-9π]+','',<not feasible>)
   8 - access("DT4"."FLD_ID"=5 AND "DT4"."SYS_NC00006$"='BY')
   9 - filter(UPPER("CLD_VALUE")='FOREIGN_COUNTRY_IDENTIFYING_DOCUMENT')
  10 - access("DT3"."CLNT_ID"="DT4"."CLNT_ID" AND "DT3"."FLD_ID"=7)
  12 - access("DT1"."CLNT_ID"="DT4"."CLNT_ID" AND "DT1"."FLD_ID"=9)
  14 - access("DT2"."CLNT_ID"="DT1"."CLNT_ID" AND "DT2"."FLD_ID"=8)
  15 - filter(("CL"."CLS_ID"=0 AND "CL"."PRD_ID"=9 AND "CL"."BNK_ID"=1))
  16 - access("CL"."CLNT_ID"="DT4"."CLNT_ID")
  17 - access("CIL"."CLNT_ID"="CL"."CLNT_ID")
  18 - filter("CIL"."PRD_IL_ID"<>0)

Column Projection Information (identified by operation id):
-----------------------------------------------------------

   1 - "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
   2 - "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400], "CIL".ROWID[ROWID,10]
   3 - "CL"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
   4 - "DT4"."CLNT_ID"[NUMBER,22]
   5 - "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200], "DT2"."CLD_VALUE"[VARCHAR2,1200]
   6 - "DT4"."CLNT_ID"[NUMBER,22], "DT1"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200]
   7 - "DT4"."CLNT_ID"[NUMBER,22]
   8 - "DT4"."CLNT_ID"[NUMBER,22]
  10 - "DT3".ROWID[ROWID,10]
  11 - "DT1"."CLNT_ID"[NUMBER,22], "DT1"."CLD_VALUE"[VARCHAR2,1200]
  12 - "DT1".ROWID[ROWID,10], "DT1"."CLNT_ID"[NUMBER,22]
  13 - "DT2"."CLD_VALUE"[VARCHAR2,1200]
  14 - "DT2".ROWID[ROWID,10]
  15 - "CL"."CLNT_ID"[NUMBER,22], "CL"."CLNT_EXTERNAL_ID"[VARCHAR2,400]
  16 - "CL".ROWID[ROWID,10], "CL"."CLNT_ID"[NUMBER,22]
  17 - "CIL".ROWID[ROWID,10]

