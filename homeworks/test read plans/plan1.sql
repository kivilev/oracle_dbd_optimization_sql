SQL_ID  288trj3m50utt, child number 0
-------------------------------------
SELECT COUNT(*) FROM WALLET W

Plan hash value: 3439131513

--------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name              | Starts | E-Rows | Cost (%CPU)| E-Time   | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |                   |      1 |        |  3988 (100)|          |      1 |00:00:06.78 |   14972 |  14946 |
|   1 |  SORT AGGREGATE       |                   |      1 |      1 |            |          |      1 |00:00:06.78 |   14972 |  14946 |
|   2 |   INDEX FAST FULL SCAN| WALLET_CLIENT_UNQ |      1 |   7280K|  3988   (1)| 00:00:01 |   7280K|00:00:06.38 |   14972 |  14946 |
--------------------------------------------------------------------------------------------------------------------------------------

Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------

   1 - SEL$1
   2 - SEL$1 / W@SEL$1

Outline Data
-------------

  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$1")
      INDEX_FFS(@"SEL$1" "W"@"SEL$1" ("WALLET"."CLIENT_ID"))
      END_OUTLINE_DATA
  */

Column Projection Information (identified by operation id):
-----------------------------------------------------------

   1 - (#keys=0) COUNT(*)[22]

Query Block Registry:
---------------------

  <q o="2" f="y"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[W]]></t><s><![CDATA[SEL$1]]></s></h></f></q>


