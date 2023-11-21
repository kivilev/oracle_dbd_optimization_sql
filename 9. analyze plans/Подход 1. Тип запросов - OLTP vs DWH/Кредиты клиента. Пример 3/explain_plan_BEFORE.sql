Plan hash value: 3122511200
 
-------------------------------------------------------------------------------------
| Id  | Operation           | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |               |     1 |    44 |   118   (1)| 00:00:01 |
|   1 |  SORT AGGREGATE     |               |     1 |    44 |            |          |
|*  2 |   HASH JOIN         |               |   887 | 39028 |   118   (1)| 00:00:01 |
|*  3 |    TABLE ACCESS FULL| CLIENT_CREDIT |   887 | 19514 |    94   (2)| 00:00:01 |
|   4 |    TABLE ACCESS FULL| CLIENT        | 10000 |   214K|    24   (0)| 00:00:01 |
-------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   3 - SEL$58A6D7F6 / CC@SEL$1
   4 - SEL$58A6D7F6 / C@SEL$1
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("C"."ID"="CC"."CLIENT_ID")
   3 - filter("CC"."CREATE_DTIME">=TRUNC(SYSDATE@!,'fmmm'))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) COUNT(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY")
       )/12)[22], SUM(MONTHS_BETWEEN(SYSDATE@!,INTERNAL_FUNCTION("C"."BDAY"))/12)[22
       ]
   2 - (#keys=1) "C"."BDAY"[DATE,7], "C"."BDAY"[DATE,7]
   3 - "CC"."CLIENT_ID"[NUMBER,22]
   4 - "C"."ID"[NUMBER,22], "C"."BDAY"[DATE,7]
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
   - this is an adaptive plan
