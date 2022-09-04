SQL_ID  arapcvy9qnncb, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ e.first_name, d.department_name   
from hr.employees e   join hr.departments d on e.department_id = 
d.department_id
 
Plan hash value: 1473400139
 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name              | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                   |      1 |        |       |     5 (100)|          |    100 |00:00:00.01 |      10 |       |       |          |
|   1 |  MERGE JOIN                  |                   |      1 |    106 |  2756 |     5  (20)| 00:00:01 |    100 |00:00:00.01 |      10 |       |       |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |     27 |   432 |     2   (0)| 00:00:01 |     10 |00:00:00.01 |       2 |       |       |          |
|   3 |    INDEX FULL SCAN           | DEPT_ID_PK        |      1 |     27 |       |     1   (0)| 00:00:01 |     10 |00:00:00.01 |       1 |       |       |          |
|*  4 |   SORT JOIN                  |                   |     10 |    107 |  1070 |     3  (34)| 00:00:01 |    100 |00:00:00.01 |       8 | 73728 | 73728 |          |
|   5 |    VIEW                      | index$_join$_001  |      1 |    107 |  1070 |     2   (0)| 00:00:01 |    106 |00:00:00.01 |       8 |       |       |          |
|*  6 |     HASH JOIN                |                   |      1 |        |       |            |          |    106 |00:00:00.01 |       8 |  1610K|  1610K| 1623K (0)|
|   7 |      INDEX FAST FULL SCAN    | EMP_DEPARTMENT_IX |      1 |    107 |  1070 |     1   (0)| 00:00:01 |    106 |00:00:00.01 |       4 |       |       |          |
|   8 |      INDEX FAST FULL SCAN    | EMP_NAME_IX       |      1 |    107 |  1070 |     1   (0)| 00:00:01 |    107 |00:00:00.01 |       4 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   2 - SEL$58A6D7F6 / D@SEL$1
   3 - SEL$58A6D7F6 / D@SEL$1
   5 - SEL$5E75DC3A / E@SEL$1
   6 - SEL$5E75DC3A
   7 - SEL$5E75DC3A / indexjoin$_alias$_001@SEL$5E75DC3A
   8 - SEL$5E75DC3A / indexjoin$_alias$_002@SEL$5E75DC3A
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$5E75DC3A")
      OUTLINE_LEAF(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      INDEX(@"SEL$58A6D7F6" "D"@"SEL$1" ("DEPARTMENTS"."DEPARTMENT_ID"))
      INDEX_JOIN(@"SEL$58A6D7F6" "E"@"SEL$1" ("EMPLOYEES"."DEPARTMENT_ID") ("EMPLOYEES"."LAST_NAME" "EMPLOYEES"."FIRST_NAME"))
      LEADING(@"SEL$58A6D7F6" "D"@"SEL$1" "E"@"SEL$1")
      USE_MERGE(@"SEL$58A6D7F6" "E"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   6 - access(ROWID=ROWID)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "D"."DEPARTMENT_NAME"[VARCHAR2,30], "E"."FIRST_NAME"[VARCHAR2,20]
   2 - "D"."DEPARTMENT_ID"[NUMBER,22], "D"."DEPARTMENT_NAME"[VARCHAR2,30]
   3 - "D".ROWID[ROWID,10], "D"."DEPARTMENT_ID"[NUMBER,22]
   4 - (#keys=1) "E"."DEPARTMENT_ID"[NUMBER,22], "E"."FIRST_NAME"[VARCHAR2,20]
   5 - "E"."FIRST_NAME"[VARCHAR2,20], "E"."DEPARTMENT_ID"[NUMBER,22]
   6 - (#keys=1) "E"."DEPARTMENT_ID"[NUMBER,22], "E"."FIRST_NAME"[VARCHAR2,20]
   7 - ROWID[ROWID,10], "E"."DEPARTMENT_ID"[NUMBER,22]
   8 - ROWID[ROWID,10], "E"."FIRST_NAME"[VARCHAR2,20]
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[D]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[E]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[D]]></t><s><![CDA
        TA[SEL$1]]></s></h><h><t><![CDATA[E]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
