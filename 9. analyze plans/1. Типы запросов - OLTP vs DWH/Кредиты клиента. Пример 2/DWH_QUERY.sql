SQL_ID  7u62fpn1jubmq, child number 1
-------------------------------------
SELECT TRUNC(C.BDAY, 'YYYY'), COUNT(*) FROM CLIENT C JOIN CLIENT_CREDIT 
CC ON C.ID = CC.CLIENT_ID GROUP BY TRUNC(C.BDAY, 'YYYY')
 
Plan hash value: 3424012996
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name          | Starts | E-Rows |E-Bytes|E-Temp | Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |               |      1 |        |       |       |  1611 (100)|          |    275 |00:00:00.14 |    2722 |       |       |          |
|   1 |  HASH GROUP BY      |               |      1 |    311K|    10M|       |  1611   (1)| 00:00:01 |    275 |00:00:00.14 |    2722 |  1369K|  1369K|   10M (0)|
|*  2 |   HASH JOIN         |               |      1 |    311K|    10M|  3040K|  1601   (1)| 00:00:01 |    300K|00:00:00.09 |    2722 |  6912K|  2259K| 7990K (0)|
|   3 |    TABLE ACCESS FULL| CLIENT        |      1 |  91533 |  1966K|       |   236   (1)| 00:00:01 |    100K|00:00:00.01 |     582 |       |       |          |
|   4 |    TABLE ACCESS FULL| CLIENT_CREDIT |      1 |    347K|  4409K|       |   805   (1)| 00:00:01 |    300K|00:00:00.02 |    2140 |       |       |          |
------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / C@SEL$1
   4 - SEL$58A6D7F6 / CC@SEL$1
 
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
      FULL(@"SEL$58A6D7F6" "C"@"SEL$1")
      FULL(@"SEL$58A6D7F6" "CC"@"SEL$1")
      LEADING(@"SEL$58A6D7F6" "C"@"SEL$1" "CC"@"SEL$1")
      USE_HASH(@"SEL$58A6D7F6" "CC"@"SEL$1")
      USE_HASH_AGGREGATION(@"SEL$58A6D7F6")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("C"."ID"="CC"."CLIENT_ID")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (rowset=256) TRUNC(INTERNAL_FUNCTION("C"."BDAY"),'fmyyyy')[8], COUNT(*)[22]
   2 - (#keys=1; rowset=256) "C"."BDAY"[DATE,7]
   3 - (rowset=256) "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
   4 - (rowset=256) "CC"."CLIENT_ID"[NUMBER,22]
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[C]]></t><s><
        ![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
