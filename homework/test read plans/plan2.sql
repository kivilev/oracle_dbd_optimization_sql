SQL_ID  8k46pjkc1st3v, child number 0
-------------------------------------
SELECT W.* ,AC.CURRENCY_ID ,AC.BALANCE FROM WALLET W LEFT JOIN ACCOUNT
AC ON W.WALLET_ID = AC.WALLET_ID WHERE ROWNUM <= 10

Plan hash value: 3053406827

---------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name                        | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |                             |      1 |        |       |    32 (100)|          |     10 |00:00:00.01 |      17 |
|*  1 |  NNNNNNNNNNNNN                        |                             |      1 |        |       |            |          |     10 |00:00:00.01 |      17 |
|   2 |   ОПЕРАЦИИИИИИИЯИИИИ                  |                             |      1 |     10 |   480 |    32   (0)| 00:00:01 |     10 |00:00:00.01 |      17 |
|   3 |    ОПЕРАЦИЯЯЯЯЯ                       | WALLET                      |      1 |     10 |   360 |     2   (0)| 00:00:01 |     10 |00:00:00.01 |       3 |
|   4 |    ОПЕРАЦИЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯ    | ACCOUNT                     |     10 |      1 |    12 |     3   (0)| 00:00:01 |     10 |00:00:00.01 |      14 |
|*  5 |     ОПЕРАЦИИИИИИИИИЯ                  | ACCOUNT_WALLET_CURRENCY_UNQ |     10 |      1 |       |     2   (0)| 00:00:01 |     10 |00:00:00.01 |      13 |
---------------------------------------------------------------------------------------------------------------------------------------------------------------

Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------

   1 - SEL$2BFA4EE4
   3 - SEL$2BFA4EE4 / W@SEL$1
   4 - SEL$2BFA4EE4 / AC@SEL$1
   5 - SEL$2BFA4EE4 / AC@SEL$1

Outline Data
-------------

  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$2BFA4EE4")
      MERGE(@"SEL$8812AA4E" >"SEL$948754D7")
      OUTLINE(@"SEL$948754D7")
      ANSI_REARCH(@"SEL$2")
      OUTLINE(@"SEL$8812AA4E")
      ANSI_REARCH(@"SEL$1")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      FULL(@"SEL$2BFA4EE4" "W"@"SEL$1")
      INDEX_RS_ASC(@"SEL$2BFA4EE4" "AC"@"SEL$1" ("ACCOUNT"."WALLET_ID" "ACCOUNT"."CURRENCY_ID"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$2BFA4EE4" "AC"@"SEL$1")
      LEADING(@"SEL$2BFA4EE4" "W"@"SEL$1" "AC"@"SEL$1")
      USE_NL(@"SEL$2BFA4EE4" "AC"@"SEL$1")
      END_OUTLINE_DATA
  */

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(ROWNUM<=10)
   5 - access("W"."WALLET_ID"="AC"."WALLET_ID")

Column Projection Information (identified by operation id):
-----------------------------------------------------------

   1 - "W"."WALLET_ID"[NUMBER,22], "W"."CLIENT_ID"[NUMBER,22], "W"."STATUS_ID"[NUMBER,22], "W"."STATUS_CHANGE_REASON"[VARCHAR2,800],
       "W"."CREATE_DTIME_TECH"[TIMESTAMP,11], "W"."UPDATE_DTIME_TECH"[TIMESTAMP,11], "AC"."CURRENCY_ID"[NUMBER,22], "AC"."BALANCE"[NUMBER,22]
   2 - "W"."WALLET_ID"[NUMBER,22], "W"."CLIENT_ID"[NUMBER,22], "W"."STATUS_ID"[NUMBER,22], "W"."STATUS_CHANGE_REASON"[VARCHAR2,800],
       "W"."CREATE_DTIME_TECH"[TIMESTAMP,11], "W"."UPDATE_DTIME_TECH"[TIMESTAMP,11], "AC"."CURRENCY_ID"[NUMBER,22], "AC"."BALANCE"[NUMBER,22]
   3 - "W"."WALLET_ID"[NUMBER,22], "W"."CLIENT_ID"[NUMBER,22], "W"."STATUS_ID"[NUMBER,22], "W"."STATUS_CHANGE_REASON"[VARCHAR2,800],
       "W"."CREATE_DTIME_TECH"[TIMESTAMP,11], "W"."UPDATE_DTIME_TECH"[TIMESTAMP,11]
   4 - "AC"."CURRENCY_ID"[NUMBER,22], "AC"."BALANCE"[NUMBER,22]
   5 - "AC".ROWID[ROWID,10], "AC"."CURRENCY_ID"[NUMBER,22]

Query Block Registry:
---------------------

  <q o="68" h="y"><n><![CDATA[SEL$8812AA4E]]></n><p><![CDATA[SEL$1]]></p><f><h><t><![CDATA[AC]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[W]]></t><s
        ><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[AC]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[W]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$2BFA4EE4]]></n><p><![CDATA[SEL$948754D7]]></p><i><o><t>VW</t><v><![CDATA[SEL$8812AA4E]]></v></o></i><f><h><t><![C
        DATA[AC]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[W]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="67" h="y"><n><![CDATA[SEL$948754D7]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$8812AA4E]]></v></o></i><f><h><t><![CDATA[from$_su
        bquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>


