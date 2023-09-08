SQL_ID  aa3a4fnd00df5, child number 0
-------------------------------------
SELECT /*+ leading(e d)*/ E.EMPLOYEE_ID, D.* FROM HR.EMPLOYEES E JOIN 
HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID WHERE E.LAST_NAME 
= 'Smith'
 
Plan hash value: 3892127698
 
-----------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name        | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |             |      1 |        |       |     3 (100)|          |      2 |00:00:00.01 |       6 |
|   1 |  NESTED LOOPS                         |             |      1 |      1 |    36 |     3   (0)| 00:00:01 |      2 |00:00:00.01 |       6 |
|   2 |   NESTED LOOPS                        |             |      1 |      1 |    36 |     3   (0)| 00:00:01 |      2 |00:00:00.01 |       4 |
|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| EMPLOYEES   |      1 |      1 |    15 |     2   (0)| 00:00:01 |      2 |00:00:00.01 |       2 |
|*  4 |     INDEX RANGE SCAN                  | EMP_NAME_IX |      1 |      1 |       |     1   (0)| 00:00:01 |      2 |00:00:00.01 |       1 |
|*  5 |    INDEX UNIQUE SCAN                  | DEPT_ID_PK  |      2 |      1 |       |     0   (0)|          |      2 |00:00:00.01 |       2 |
|   6 |   TABLE ACCESS BY INDEX ROWID         | DEPARTMENTS |      2 |      1 |    21 |     1   (0)| 00:00:01 |      2 |00:00:00.01 |       2 |
-----------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   3 - SEL$58A6D7F6 / E@SEL$1
   4 - SEL$58A6D7F6 / E@SEL$1
   5 - SEL$58A6D7F6 / D@SEL$1
   6 - SEL$58A6D7F6 / D@SEL$1
 
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
      INDEX_RS_ASC(@"SEL$58A6D7F6" "E"@"SEL$1" ("EMPLOYEES"."LAST_NAME" "EMPLOYEES"."FIRST_NAME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$58A6D7F6" "E"@"SEL$1")
      INDEX(@"SEL$58A6D7F6" "D"@"SEL$1" ("DEPARTMENTS"."DEPARTMENT_ID"))
      LEADING(@"SEL$58A6D7F6" "E"@"SEL$1" "D"@"SEL$1")
      USE_NL(@"SEL$58A6D7F6" "D"@"SEL$1")
      NLJ_BATCHING(@"SEL$58A6D7F6" "D"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("E"."LAST_NAME"='Smith')
   5 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "E"."EMPLOYEE_ID"[NUMBER,22], "E"."DEPARTMENT_ID"[NUMBER,22], "D"."DEPARTMENT_ID"[NUMBER,22], 
       "D"."DEPARTMENT_NAME"[VARCHAR2,30], "D"."MANAGER_ID"[NUMBER,22], "D"."LOCATION_ID"[NUMBER,22]
   2 - "E"."EMPLOYEE_ID"[NUMBER,22], "E"."DEPARTMENT_ID"[NUMBER,22], "D".ROWID[ROWID,10], "D"."DEPARTMENT_ID"[NUMBER,22]
   3 - "E"."EMPLOYEE_ID"[NUMBER,22], "E"."DEPARTMENT_ID"[NUMBER,22]
   4 - "E".ROWID[ROWID,10]
   5 - "D".ROWID[ROWID,10], "D"."DEPARTMENT_ID"[NUMBER,22]
   6 - "D"."DEPARTMENT_NAME"[VARCHAR2,30], "D"."MANAGER_ID"[NUMBER,22], "D"."LOCATION_ID"[NUMBER,22]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 1
---------------------------------------------------------------------------
 
   1 -  SEL$58A6D7F6
           -  leading(e d)
 
Note
-----
   - this is an adaptive plan
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[D]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[E]]></t><s><![CDATA[SEL$1]]></s><
        /h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><!
        [CDATA[D]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[E]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
 
 
