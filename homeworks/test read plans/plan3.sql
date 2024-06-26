SQL_ID  7xkj27nxsaz4k, child number 0
-------------------------------------
SELECT T.CLIENT_ID ,AC.CURRENCY_ID ,AC.BALANCE ,(SELECT CD.FIELD_VALUE 
FROM CLIENT_DATA CD WHERE CD.CLIENT_ID = T.CLIENT_ID AND CD.FIELD_ID = 
1) LAST_NAME FROM CLIENT T JOIN ACCOUNT AC ON AC.CLIENT_ID = 
T.CLIENT_ID WHERE T.CLIENT_ID IN (216, 226)
 
Plan hash value: 3587303806
 
-------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name           | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  |
-------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                |      1 |        |       | 22241 (100)|          |      2 |00:00:01.94 |   59068 |  59059 |
|   1 |  TABLE ACCESS BY INDEX ROWID| CLIENT_DATA    |      2 |      1 |    22 |     3   (0)| 00:00:01 |      2 |00:00:00.01 |       8 |      4 |
|*  2 |   INDEX UNIQUE SCAN         | CLIENT_DATA_PK |      2 |      1 |       |     2   (0)| 00:00:01 |      2 |00:00:00.01 |       6 |      3 |
|   3 |  NESTED LOOPS               |                |      1 |      2 |    36 | 22238   (1)| 00:00:01 |      2 |00:00:01.94 |   59068 |  59059 |
|*  4 |   TABLE ACCESS FULL         | ACCOUNT        |      1 |      2 |    24 | 22236   (1)| 00:00:01 |      2 |00:00:01.94 |   59062 |  59057 |
|*  5 |   INDEX UNIQUE SCAN         | CLIENT_PK      |      2 |      1 |     6 |     1   (0)| 00:00:01 |      2 |00:00:00.01 |       6 |      2 |
-------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$3        / CD@SEL$3
   2 - SEL$3        / CD@SEL$3
   4 - SEL$58A6D7F6 / AC@SEL$1
   5 - SEL$58A6D7F6 / T@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$3")
      OUTLINE_LEAF(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      FULL(@"SEL$58A6D7F6" "AC"@"SEL$1")
      INDEX(@"SEL$58A6D7F6" "T"@"SEL$1" ("CLIENT"."CLIENT_ID"))
      LEADING(@"SEL$58A6D7F6" "AC"@"SEL$1" "T"@"SEL$1")
      USE_NL(@"SEL$58A6D7F6" "T"@"SEL$1")
      INDEX_RS_ASC(@"SEL$3" "CD"@"SEL$3" ("CLIENT_DATA"."CLIENT_ID" "CLIENT_DATA"."FIELD_ID"))
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CD"."CLIENT_ID"=:B1 AND "CD"."FIELD_ID"=1)
   4 - filter(("AC"."CLIENT_ID"=216 OR "AC"."CLIENT_ID"=226))
   5 - access("AC"."CLIENT_ID"="T"."CLIENT_ID")
       filter(("T"."CLIENT_ID"=216 OR "T"."CLIENT_ID"=226))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "CD"."FIELD_VALUE"[VARCHAR2,800]
   2 - "CD".ROWID[ROWID,10]
   3 - "AC"."CLIENT_ID"[NUMBER,22], "AC"."CURRENCY_ID"[NUMBER,22], "AC"."BALANCE"[NUMBER,22], "T"."CLIENT_ID"[NUMBER,22]
   4 - "AC"."CLIENT_ID"[NUMBER,22], "AC"."CURRENCY_ID"[NUMBER,22], "AC"."BALANCE"[NUMBER,22]
   5 - "T"."CLIENT_ID"[NUMBER,22]
 
Note
-----
   - this is an adaptive plan
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[AC]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[T]]></t><s><![CDATA[SEL$1]]></s></
        h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![C
        DATA[AC]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[T]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_004]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
  <q o="2" f="y"><n><![CDATA[SEL$3]]></n><f><h><t><![CDATA[CD]]></t><s><![CDATA[SEL$3]]></s></h></f></q>
 
 
