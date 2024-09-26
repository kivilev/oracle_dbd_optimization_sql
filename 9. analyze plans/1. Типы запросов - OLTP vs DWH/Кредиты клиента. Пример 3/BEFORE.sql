SQL_ID  g8awrhasajsts, child number 1
-------------------------------------
SELECT ROUND(AVG(MONTHS_BETWEEN(SYSDATE, C.BDAY)/12), 2) YRS FROM 
CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID WHERE 
CC.CREATE_DTIME >= TRUNC(SYSDATE, 'mm')
 
Plan hash value: 3122511200
 
----------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name          | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |               |      1 |        |       |  1040 (100)|          |      1 |00:00:00.07 |    2687 |       |       |          |
|   1 |  SORT AGGREGATE     |               |      1 |      1 |    26 |            |          |      1 |00:00:00.07 |    2687 |       |       |          |
|*  2 |   HASH JOIN         |               |      1 |   6877 |   174K|  1040   (1)| 00:00:01 |   6800 |00:00:00.07 |    2687 |  2171K|  2171K| 2110K (0)|
|*  3 |    TABLE ACCESS FULL| CLIENT_CREDIT |      1 |   6877 | 89401 |   822   (1)| 00:00:01 |   6800 |00:00:00.03 |    2129 |       |       |          |
|   4 |    TABLE ACCESS FULL| CLIENT        |      1 |    100K|  1269K|   218   (1)| 00:00:01 |    100K|00:00:00.01 |     558 |       |       |          |
----------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / CC@SEL$1
   4 - SEL$58A6D7F6 / C@SEL$1
 
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
      FULL(@"SEL$58A6D7F6" "C"@"SEL$1")
      LEADING(@"SEL$58A6D7F6" "CC"@"SEL$1" "C"@"SEL$1")
      USE_HASH(@"SEL$58A6D7F6" "C"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("C"."ID"="CC"."CLIENT_ID")
   3 - filter("CC"."CREATE_DTIME">=TRUNC(SYSDATE@!,'fmmm'))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], 
       SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - "CC"."CLIENT_ID"[NUMBER,22]
   4 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Note
-----
   - this is an adaptive plan
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q
        >
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[C]]>
        </t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
