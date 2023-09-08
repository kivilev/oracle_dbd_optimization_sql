SQL_ID aruh7kzjq9htm
--------------------
DELETE FROM wri$_adv_actions a      WHERE a.task_id = :task_id_num AND  
         (:execution_name IS NULL OR :execution_name1 = a.exec_name)
 
Plan hash value: 926350108
 
-----------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name                | E-Rows |E-Bytes| Cost (%CPU)| E-Time   |
-----------------------------------------------------------------------------------------------------
|   0 | DELETE STATEMENT             |                     |        |       |     3 (100)|          |
|   1 |  DELETE                      | WRI$_ADV_ACTIONS    |        |       |            |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| WRI$_ADV_ACTIONS    |      1 |    18 |     3   (0)| 00:00:01 |
|   3 |    INDEX RANGE SCAN          | WRI$_ADV_ACTIONS_PK |     10 |       |     2   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - DEL$1
   2 - DEL$1 / A@DEL$1
   3 - DEL$1 / A@DEL$1
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('11.2.0.4')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"DEL$1")
      INDEX_RS_ASC(@"DEL$1" "A"@"DEL$1" ("WRI$_ADV_ACTIONS"."TASK_ID" "WRI$_ADV_ACTIONS"."ID"))
      END_OUTLINE_DATA
  */
 
Peeked Binds (identified by position):
--------------------------------------
 
   1 - :TASK_ID_NUM (NUMBER): 6
   3 - :EXECUTION_NAME1 (VARCHAR2(30), CSID=873): 'EXEC_18397'
 
Note
-----
   - Warning: basic plan statistics not available. These are only collected when:
       * hint 'gather_plan_statistics' is used for the statement or
       * parameter 'statistics_level' is set to 'ALL', at session or system level
 
Query Block Registry:
---------------------
 
  <q o="2" f="y"><n><![CDATA[DEL$1]]></n><f><h><t><![CDATA[A]]></t><s><![CDATA[DEL$1]]></s></h>
        </f></q>
 
 
