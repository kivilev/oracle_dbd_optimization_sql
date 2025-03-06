SQL_ID  2dwc5uqawbkxk, child number 0
-------------------------------------
SELECT * FROM CLIENT C JOIN CLIENT_CREDIT CC ON C.ID = CC.CLIENT_ID 
WHERE C.ID = 1999
 
Plan hash value: 3052884723
 
----------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name          | Starts | E-Rows | E-Time   | A-Rows |   A-Time   | Buffers | Reads  |
----------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |               |      1 |        |          |      3 |00:00:01.44 |   21281 |  21264 |
|   1 |  NESTED LOOPS                |               |      1 |      3 | 00:00:01 |      3 |00:00:01.44 |   21281 |  21264 |
|   2 |   TABLE ACCESS BY INDEX ROWID| CLIENT        |      1 |      1 | 00:00:01 |      1 |00:00:00.01 |       4 |      0 |
|*  3 |    INDEX UNIQUE SCAN         | CLIENT_PK     |      1 |      1 | 00:00:01 |      1 |00:00:00.01 |       3 |      0 |
|*  4 |   TABLE ACCESS FULL          | CLIENT_CREDIT |      1 |      3 | 00:00:01 |      3 |00:00:01.44 |   21277 |  21264 |
----------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   2 - SEL$58A6D7F6 / C@SEL$1
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
      INDEX_RS_ASC(@"SEL$58A6D7F6" "C"@"SEL$1" ("CLIENT"."ID"))
      FULL(@"SEL$58A6D7F6" "CC"@"SEL$1")
      LEADING(@"SEL$58A6D7F6" "C"@"SEL$1" "CC"@"SEL$1")
      USE_NL(@"SEL$58A6D7F6" "CC"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("C"."ID"=1999)
   4 - filter("CC"."CLIENT_ID"=1999)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "C"."ID"[NUMBER,22], "C"."FNAME"[VARCHAR2,800], "C"."LNAME"[VARCHAR2,800], "C"."BDAY"[DATE,7], 
       "CC"."CLIENT_CREDIT_ID"[VARCHAR2,200], "CC"."CLIENT_ID"[NUMBER,22], "CC"."CREATE_DTIME"[DATE,7]
   2 - "C"."ID"[NUMBER,22], "C"."FNAME"[VARCHAR2,800], "C"."LNAME"[VARCHAR2,800], "C"."BDAY"[DATE,7]
   3 - "C".ROWID[ROWID,10], "C"."ID"[NUMBER,22]
   4 - "CC"."CLIENT_CREDIT_ID"[VARCHAR2,200], "CC"."CLIENT_ID"[NUMBER,22], "CC"."CREATE_DTIME"[DATE,7]
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><!
        [CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v>
        </o></i><f><h><t><![CDATA[C]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[CC]]></t><s><![CDATA[SEL$1]]></s></h></
        f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
