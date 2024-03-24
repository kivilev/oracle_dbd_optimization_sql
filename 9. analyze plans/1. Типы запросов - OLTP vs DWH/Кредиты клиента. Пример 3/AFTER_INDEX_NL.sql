SQL_ID  9275zc7thmhdu, child number 0
-------------------------------------
SELECT /*+ use_nl(c cc) leading(cc c) index(cc 
client_credit_create_dtime_i)*/ROUND(AVG(MONTHS_BETWEEN(SYSDATE, 
C.BDAY)/12), 2) YRS FROM CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = 
CC.CLIENT_ID WHERE CC.CREATE_DTIME >= TRUNC(SYSDATE, 'mm')
 
Plan hash value: 1660074313
 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name                         | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                              |      1 |        |       | 14177 (100)|          |      1 |00:00:00.04 |   21023 |
|   1 |  SORT AGGREGATE                        |                              |      1 |      1 |    26 |            |          |      1 |00:00:00.04 |   21023 |
|   2 |   NESTED LOOPS                         |                              |      1 |   7105 |   180K| 14177   (1)| 00:00:01 |   7000 |00:00:00.04 |   21023 |
|   3 |    NESTED LOOPS                        |                              |      1 |   7105 |   180K| 14177   (1)| 00:00:01 |   7000 |00:00:00.03 |   14023 |
|   4 |     TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT                |      1 |   7105 | 92365 |  7128   (1)| 00:00:01 |   7000 |00:00:00.02 |    7021 |
|*  5 |      INDEX RANGE SCAN                  | CLIENT_CREDIT_CREATE_DTIME_I |      1 |   7105 |       |    21   (0)| 00:00:01 |   7000 |00:00:00.01 |      21 |
|*  6 |     INDEX UNIQUE SCAN                  | CLIENT_PK                    |   7000 |      1 |       |     0   (0)|          |   7000 |00:00:00.01 |    7002 |
|   7 |    TABLE ACCESS BY INDEX ROWID         | CLIENT                       |   7000 |      1 |    13 |     1   (0)| 00:00:01 |   7000 |00:00:00.01 |    7000 |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / CC@SEL$1
   6 - SEL$58A6D7F6 / C@SEL$1
   7 - SEL$58A6D7F6 / C@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      INDEX_RS_ASC(@"SEL$58A6D7F6" "CC"@"SEL$1" ("CLIENT_CREDIT"."CREATE_DTIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$58A6D7F6" "CC"@"SEL$1")
      INDEX(@"SEL$58A6D7F6" "C"@"SEL$1" ("CLIENT"."ID"))
      LEADING(@"SEL$58A6D7F6" "CC"@"SEL$1" "C"@"SEL$1")
      USE_NL(@"SEL$58A6D7F6" "C"@"SEL$1")
      NLJ_BATCHING(@"SEL$58A6D7F6" "C"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("CC"."CREATE_DTIME">=TRUNC(SYSDATE@!,'fmmm'))
   6 - access("C"."ID"="CC"."CLIENT_ID")
 
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
           -  index(cc client_credit_create_dtime_i)
 
   6 -  SEL$58A6D7F6 / C@SEL$1
           -  use_nl(c cc)
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[C]]></t><s>
        <![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
