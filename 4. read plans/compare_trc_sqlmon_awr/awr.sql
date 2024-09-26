SQL_ID  3g2fz9g3dvhz3, child number 0
-------------------------------------
SELECT /*+ monitor use_nl(ser num) */ COUNT(*) FROM CLIENT_DATA SER 
JOIN CLIENT_DATA NUM ON NUM.CLIENT_ID = SER.CLIENT_ID AND 
NUM.FIELD_VALUE = :B2 AND NUM.FIELD_ID = :B1 WHERE SER.FIELD_VALUE = 
:B4 AND SER.FIELD_ID = :B3
 
Plan hash value: 4245905949
 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name                | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                     |      1 |        |       |  6146 (100)|          |      1 |00:00:04.14 |   14426 |   2281 |
|   1 |  SORT AGGREGATE                        |                     |      1 |      1 |    44 |            |          |      1 |00:00:04.14 |   14426 |   2281 |
|   2 |   NESTED LOOPS                         |                     |      1 |   1429 | 62876 |  6146   (1)| 00:00:01 |  10000 |00:00:04.14 |   14426 |   2281 |
|   3 |    NESTED LOOPS                        |                     |      1 |   1429 | 62876 |  6146   (1)| 00:00:01 |  10000 |00:00:04.11 |    4426 |   2233 |
|*  4 |     TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_DATA         |      1 |   1429 | 31438 |  3287   (1)| 00:00:01 |  10000 |00:00:04.00 |    2044 |   2040 |
|*  5 |      INDEX RANGE SCAN                  | CLIENT_DATA_FIELD_I |      1 |    350K|       |  1019   (1)| 00:00:01 |    350K|00:00:02.29 |    1085 |   1085 |
|*  6 |     INDEX UNIQUE SCAN                  | CLIENT_DATA_PK      |  10000 |      1 |       |     1   (0)| 00:00:01 |  10000 |00:00:00.10 |    2382 |    193 |
|*  7 |    TABLE ACCESS BY INDEX ROWID         | CLIENT_DATA         |  10000 |      1 |    22 |     2   (0)| 00:00:01 |  10000 |00:00:00.03 |   10000 |     48 |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / SER@SEL$1
   5 - SEL$58A6D7F6 / SER@SEL$1
   6 - SEL$58A6D7F6 / NUM@SEL$1
   7 - SEL$58A6D7F6 / NUM@SEL$1
 
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
      INDEX_RS_ASC(@"SEL$58A6D7F6" "SER"@"SEL$1" ("CLIENT_DATA"."FIELD_ID"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$58A6D7F6" "SER"@"SEL$1")
      INDEX(@"SEL$58A6D7F6" "NUM"@"SEL$1" ("CLIENT_DATA"."CLIENT_ID" "CLIENT_DATA"."FIELD_ID"))
      LEADING(@"SEL$58A6D7F6" "SER"@"SEL$1" "NUM"@"SEL$1")
      USE_NL(@"SEL$58A6D7F6" "NUM"@"SEL$1")
      NLJ_BATCHING(@"SEL$58A6D7F6" "NUM"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Peeked Binds (identified by position):
--------------------------------------
 
   1 - :1 (VARCHAR2(30), CSID=873): 'FENXEOVELUCNGESNMJSE'
   2 - :2 (NUMBER): 5
   3 - (VARCHAR2(30), CSID=873): 'PPBZ'
   4 - (NUMBER): 4
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - filter("SER"."FIELD_VALUE"=:B4)
   5 - access("SER"."FIELD_ID"=:B3)
   6 - access("NUM"."CLIENT_ID"="SER"."CLIENT_ID" AND "NUM"."FIELD_ID"=:B1)
   7 - filter("NUM"."FIELD_VALUE"=:B2)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(*)[22]
   3 - "NUM".ROWID[ROWID,10]
   4 - "SER"."CLIENT_ID"[NUMBER,22]
   5 - "SER".ROWID[ROWID,10]
   6 - "NUM".ROWID[ROWID,10]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 2 (U - Unused (1))
---------------------------------------------------------------------------
 
   4 -  SEL$58A6D7F6 / SER@SEL$1
         U -  use_nl(ser num)
 
   6 -  SEL$58A6D7F6 / NUM@SEL$1
           -  use_nl(ser num)
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[NUM]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[SER]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[NUM]]></t><
        s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[SER]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
