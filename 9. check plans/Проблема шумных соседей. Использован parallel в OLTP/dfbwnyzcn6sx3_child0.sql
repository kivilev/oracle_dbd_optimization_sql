SQL_ID  dfbwnyzcn6sx3, child number 0
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
 
Plan hash value: 1565037707
 
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name                          | E-Rows |E-Bytes| Cost (%CPU)| E-Time   |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                               |        |       |    16 (100)|          |
|   1 |  NESTED LOOPS                      |                               |      1 |   144 |    16   (0)| 00:00:01 |
|   2 |   NESTED LOOPS                     |                               |      1 |   144 |    16   (0)| 00:00:01 |
|   3 |    NESTED LOOPS                    |                               |      1 |   135 |    14   (0)| 00:00:01 |
|*  4 |     FILTER                         |                               |        |       |            |          |
|   5 |      NESTED LOOPS OUTER            |                               |      1 |    92 |    12   (0)| 00:00:01 |
|   6 |       NESTED LOOPS                 |                               |      1 |    69 |     9   (0)| 00:00:01 |
|   7 |        NESTED LOOPS                |                               |      1 |    46 |     6   (0)| 00:00:01 |
|*  8 |         INDEX RANGE SCAN           | CLIENT_DATA_FLD_VALUE_I       |      1 |    23 |     4   (0)| 00:00:01 |
|*  9 |         TABLE ACCESS BY INDEX ROWID| CLIENT_DATA                   |      1 |    23 |     3   (0)| 00:00:01 |
|* 10 |          INDEX UNIQUE SCAN         | CLIENT_DATA_PK                |      1 |       |     2   (0)| 00:00:01 |
|  11 |        TABLE ACCESS BY INDEX ROWID | CLIENT_DATA                   |      1 |    23 |     3   (0)| 00:00:01 |
|* 12 |         INDEX UNIQUE SCAN          | CLIENT_DATA_PK                |      1 |       |     2   (0)| 00:00:01 |
|  13 |       TABLE ACCESS BY INDEX ROWID  | CLIENT_DATA                   |      2 |    46 |     3   (0)| 00:00:01 |
|* 14 |        INDEX UNIQUE SCAN           | CLIENT_DATA_PK                |      1 |       |     2   (0)| 00:00:01 |
|* 15 |     TABLE ACCESS BY INDEX ROWID    | CLIENT                        |      1 |    43 |     2   (0)| 00:00:01 |
|* 16 |      INDEX UNIQUE SCAN             | CLIENT_PK                     |      1 |       |     1   (0)| 00:00:01 |
|* 17 |    INDEX UNIQUE SCAN               | CLIENT_IDENT_LEVEL_CLNT_ID_UQ |      1 |       |     1   (0)| 00:00:01 |
|* 18 |   TABLE ACCESS BY INDEX ROWID      | CLIENT_IDENT_LEVEL            |      1 |     9 |     2   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------------------
 
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
 
Peeked Binds (identified by position):
--------------------------------------
 
   1 - :1 (VARCHAR2(30), CSID=873): 'FOREIGN_COUNTRY_IDENTIFYING_DOCUMENT'
   2 - :2 (NUMBER): 9
   3 - (NUMBER): 1
   4 - (VARCHAR2(30), CSID=873): 'BY'
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - filter(NLSSORT( REGEXP_REPLACE (UPPER("DT2"."CLD_VALUE"||"DT1"."CLD_VALUE") COLLATE 
              "BINARY_CI",'[^A-ZА-ЯЁ0-9№]+','',<not feasible>)
   8 - access("DT4"."FLD_ID"=5 AND "DT4"."SYS_NC00006$"=:4)
   9 - filter(UPPER("CLD_VALUE")=:1)
  10 - access("DT3"."CLNT_ID"="DT4"."CLNT_ID" AND "DT3"."FLD_ID"=7)
  12 - access("DT1"."CLNT_ID"="DT4"."CLNT_ID" AND "DT1"."FLD_ID"=9)
  14 - access("DT2"."CLNT_ID"="DT1"."CLNT_ID" AND "DT2"."FLD_ID"=8)
  15 - filter(("CL"."CLS_ID"=0 AND "CL"."PRD_ID"=:2 AND "CL"."BNK_ID"=:3))
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
 
Note
-----
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 
