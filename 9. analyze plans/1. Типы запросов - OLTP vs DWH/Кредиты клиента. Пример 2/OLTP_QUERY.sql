SQL_ID  at2c9hbatmy12, child number 0
-------------------------------------
SELECT /*+ use_nl(c cc)*/TRUNC(C.BDAY, 'YYYY'), COUNT(*) FROM CLIENT C 
JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID GROUP BY TRUNC(C.BDAY, 
'YYYY')
 
Plan hash value: 2133407294
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name          | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |               |      1 |        |       |   311K(100)|          |    275 |00:00:00.70 |     320K|       |       |          |
|   1 |  HASH GROUP BY                |               |      1 |    311K|    10M|   311K  (1)| 00:00:13 |    275 |00:00:00.70 |     320K|  1369K|  1369K| 1428K (0)|
|   2 |   NESTED LOOPS                |               |      1 |    311K|    10M|   311K  (1)| 00:00:13 |    300K|00:00:00.62 |     320K|       |       |          |
|   3 |    NESTED LOOPS               |               |      1 |    347K|    10M|   311K  (1)| 00:00:13 |    300K|00:00:00.30 |   20146 |       |       |          |
|   4 |     TABLE ACCESS FULL         | CLIENT_CREDIT |      1 |    347K|  4409K|   805   (1)| 00:00:01 |    300K|00:00:00.04 |    2140 |       |       |          |
|*  5 |     INDEX UNIQUE SCAN         | CLIENT_PK     |    300K|      1 |       |     0   (0)|          |    300K|00:00:00.16 |   18006 |       |       |          |
|   6 |    TABLE ACCESS BY INDEX ROWID| CLIENT        |    300K|      1 |    22 |     1   (0)| 00:00:01 |    300K|00:00:00.21 |     300K|       |       |          |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / C@SEL$1
   6 - SEL$58A6D7F6 / C@SEL$1
 
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
      FULL(@"SEL$58A6D7F6" "CC"@"SEL$1")
      INDEX(@"SEL$58A6D7F6" "C"@"SEL$1" ("CLIENT"."ID"))
      LEADING(@"SEL$58A6D7F6" "CC"@"SEL$1" "C"@"SEL$1")
      USE_NL(@"SEL$58A6D7F6" "C"@"SEL$1")
      NLJ_BATCHING(@"SEL$58A6D7F6" "C"@"SEL$1")
      USE_HASH_AGGREGATION(@"SEL$58A6D7F6")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("C"."ID"="CC"."CLIENT_ID")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (rowset=256) TRUNC(INTERNAL_FUNCTION("C"."BDAY"),'fmyyyy')[8], COUNT(*)[22]
   2 - "C"."BDAY"[DATE,7]
   3 - "C".ROWID[ROWID,10]
   4 - "CC"."CLIENT_ID"[NUMBER,22]
   5 - "C".ROWID[ROWID,10]
   6 - "C"."BDAY"[DATE,7]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 2 (U - Unused (1))
---------------------------------------------------------------------------
 
   4 -  SEL$58A6D7F6 / CC@SEL$1
         U -  use_nl(c cc)
 
   5 -  SEL$58A6D7F6 / C@SEL$1
           -  use_nl(c cc)
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[C]]></t><s><![
        CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
