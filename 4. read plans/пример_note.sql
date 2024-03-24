SQL_ID  97rz59u07jpkd, child number 0
-------------------------------------
SELECT /*+ index(t TERRORIST_FLB_I)*/ COUNT(*) FROM TERRORIST T WHERE 
T.BIRTHDAY = TO_DATE(:B3 , 'YYYY-MM-DD') AND T.LAST_NAME = :B2 AND 
T.FIRST_NAME = :B1
 
Plan hash value: 3176462421
 
-------------------------------------------------------------------------------------
| Id  | Operation        | Name            | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | 
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |                 |        |       |   145K(100)|          |
|   1 |  SORT AGGREGATE  |                 |      1 |    26 |            |          |
|*  2 |   INDEX FULL SCAN| TERRORIST_FLB_I |      1 |    26 |   145K  (1)| 00:00:06 |
-------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$1
   2 - SEL$1 / T@SEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$1")
      INDEX(@"SEL$1" "T"@"SEL$1" ("TERRORIST"."REASON" "TERRORIST"."BIRTHDAY" 
              "TERRORIST"."LAST_NAME" "TERRORIST"."FIRST_NAME"))
      END_OUTLINE_DATA
  */
 
Peeked Binds (identified by position):
--------------------------------------
 
   1 - :1 (VARCHAR2(30), CSID=873): '1982-01-21'
   2 - :2 (VARCHAR2(30), CSID=873): 'Smith'
   3 - (VARCHAR2(30), CSID=873): 'John'
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("T"."BIRTHDAY"=TO_DATE(:B3,'YYYY-MM-DD') AND 
              "T"."LAST_NAME"=:B2 AND "T"."FIRST_NAME"=:B1)
       filter(("T"."LAST_NAME"=:B2 AND "T"."FIRST_NAME"=:B1 AND 
              "T"."BIRTHDAY"=TO_DATE(:B3,'YYYY-MM-DD')))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(*)[22]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 1
---------------------------------------------------------------------------
 
   2 -  SEL$1 / T@SEL$1
           -  index(t TERRORIST_FLB_I)
 
Note
-----
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 

