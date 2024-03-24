SQL_ID  cqdxucmxc6y65, child number 0
-------------------------------------
SELECT ROUND(AVG(MONTHS_BETWEEN(SYSDATE, C.BDAY)/12), 2) YRS FROM 
CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID WHERE 
CC.CREATE_DTIME >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) AND 
CC.CREATE_DTIME < ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -3)
 
Plan hash value: 3373943682
 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name          | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |               |      1 |        |       |  1048 (100)|          |      1 |00:00:00.21 |    2687 |       |       |          |
|   1 |  SORT AGGREGATE      |               |      1 |      1 |    26 |            |          |      1 |00:00:00.21 |    2687 |       |       |          |
|*  2 |   FILTER             |               |      1 |        |       |            |          |  82000 |00:00:00.19 |    2687 |       |       |          |
|*  3 |    HASH JOIN         |               |      1 |  82003 |  2082K|  1048   (2)| 00:00:01 |  82000 |00:00:00.18 |    2687 |  5603K|  2894K| 6799K (0)|
|*  4 |     TABLE ACCESS FULL| CLIENT_CREDIT |      1 |  82003 |  1041K|   829   (2)| 00:00:01 |  82000 |00:00:00.04 |    2129 |       |       |          |
|   5 |     TABLE ACCESS FULL| CLIENT        |      1 |    100K|  1269K|   218   (1)| 00:00:01 |    100K|00:00:00.01 |     558 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / C@SEL$1
 
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
 
   2 - filter(ADD_MONTHS(TRUNC(SYSDATE@!,'fmyyyy'),(-3))>ADD_MONTHS(TRUNC(SYSDATE@!,'fmyyyy'),(-12)))
   3 - access("C"."ID"="CC"."CLIENT_ID")
   4 - filter(("CC"."CREATE_DTIME">=ADD_MONTHS(TRUNC(SYSDATE@!,'fmyyyy'),(-12)) AND 
              "CC"."CREATE_DTIME"<ADD_MONTHS(TRUNC(SYSDATE@!,'fmyyyy'),(-3))))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22], 
       SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22]
   2 - "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   4 - "CC"."CLIENT_ID"[NUMBER,22]
   5 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Note
-----
   - this is an adaptive plan
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[C]]><
        /t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
