SQL_ID  c92qr9wm7utjm, child number 0
-------------------------------------
select t.first_name   from hr.employees t   join hr.departments d on 
d.department_id = t.department_id  where t.first_name like 'Alex%'
 
Plan hash value: 612698390
 
----------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name        | E-Rows |E-Bytes| Cost (%CPU)| E-Time   |
----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |             |        |       |     2 (100)|          |
|*  1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMPLOYEES   |      1 |    10 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN                   | EMP_NAME_IX |      1 |       |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$FD66E0A3 / T@SEL$1
   2 - SEL$FD66E0A3 / T@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$FD66E0A3")
      MERGE(@"SEL$F7859CDE" >"SEL$2")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$F7859CDE")
      ELIMINATE_JOIN(@"SEL$1" "D"@"SEL$1")
      OUTLINE(@"SEL$1")
      INDEX_SS(@"SEL$FD66E0A3" "T"@"SEL$1" ("EMPLOYEES"."LAST_NAME" "EMPLOYEES"."FIRST_NAME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$FD66E0A3" "T"@"SEL$1")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("T"."DEPARTMENT_ID" IS NOT NULL)
   2 - access("T"."FIRST_NAME" LIKE 'Alex%')
       filter("T"."FIRST_NAME" LIKE 'Alex%')
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "T"."FIRST_NAME"[VARCHAR2,20]
   2 - "T".ROWID[ROWID,10], "T"."FIRST_NAME"[VARCHAR2,20]
 
Note
-----
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 
Query Block Registry:
---------------------
 
  <q o="34" h="y"><n><![CDATA[SEL$F7859CDE]]></n><p><![CDATA[SEL$1]]></p><i><o><t>TA</t><v><![
        CDATA[D@SEL$1]]></v></o></i><f><h><t><![CDATA[T]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[D]]></t><s><![CDATA[SEL$1]]></s></h><h><t
        ><![CDATA[T]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$FD66E0A3]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t>
        <v><![CDATA[SEL$F7859CDE]]></v></o></i><f><h><t><![CDATA[T]]></t><s><![CDATA[SEL$1]]></s></h
        ></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL
        $2]]></s></h></f></q>
 
 
