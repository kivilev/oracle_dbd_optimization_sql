
SQL_ID  9jmt2zm6bbjqp, child number 0
-------------------------------------
select
                        s.serv_name,
                        round( ts.first_on$ * nvl( th.tax_rate, 1 ), 2 ) first_on$,
                        case
                          when     nvl( ch.policy_id, 0 ) > 0 
                               and nvl( ssh2.serv_id, 0 ) != 2881 then
                            round( ap.charge_value_wo_dis, 2 )
                          else
                            round( ts.next_month$ * nvl( th.tax_rate, 1 ), 2 )
                        end next_month$,
                        round( ts.next_month$ * nvl( th.tax_rate, 1 ), 2 ) ap_mono,
                        idi.int_dict_name,
                        decode( u.usi_id, null, 0, 1 ) is_mob_subs,
                        decode( sb.activation_date, null, 0, 1 ) is_subs_activated,
                        case
                          when     nvl( ch.policy_id, 0 ) > 0 
                               and nvl( ssh2.serv_id, 0 ) != 2881 then
                            idi2.int_type_id
                          else
                            idi.int_type_id
                        end int_type_id,
                        case
                          when     nvl( ch.policy_id, 0 ) > 0 
                               and nvl( ssh2.serv_id, 0 ) != 2881 then
                            1
                          else
                            idi.quantity
                        end quantity,
                        ts.achm_id
                   from subs_history sh
                  inner join subscriber sb on sh.subs_id = sb.subs_id
                   left join subs_usi_history suh on sh.subs_id = suh.subs_id
                                            and suh.stime <= sysdate
                                            and sysdate < suh.etime
                   left join usi u on suh.usi_id = u.usi_id
                  inner join subs_serv_history ssh on sh.subs_id = ssh.subs_id
                                                  and ssh.stime <= sysdate
                                                  and sysdate < ssh.etime
                   left join subs_serv_history ssh2 on sh.subs_id = ssh2.subs_id
                                                   and ssh2.stime <= sysdate
                                                   and sysdate < ssh2.etime
                                                   and ssh2.serv_id = 2881
                                                   and ssh2.sstat_id in ( 1, 4 )
                  inner join service s on ssh.serv_id = s.serv_id
                  inner join tariff_service ts on sh.trpl_id = ts.trpl_id
                                              and ssh.serv_id = ts.serv_id
                                              and ts.stime <= sysdate
                                              and sysdate < ts.etime
                   left join client_taxes ct on sh.clnt_id = ct.clnt_id
                                            and ct.stime <= sysdate
                                            and sysdate < ct.etime
                                            and ct.tax_id = 1
                   left join tax_history th on ct.tax_id = th.tax_id
                                            and th.stime <= sysdate
                                            and sysdate < th.etime
                   left join interval_dict idi on ts.int_dict_id = idi.int_dict_id
                  inner join client_history ch on ch.clnt_id = sh.clnt_id
                                              and ch.stime <= sysdate and sysdate < ch.etime
                   left join interval_dict idi2 on idi2.int_dict_id = 
                               inv_policy.get_mp_pack_param_value( i_policy_id   => ch.policy_id,
                                                                   i_tpd_code    => 'AP_INTERVAL',
                                                                   i_target_date => sysdate )
                   left join table( rif_invoice.get_clnt_serv_charge( i_clnt_id     => sh.clnt_id,
                                                                      i_target_date => sysdate )
                                  ) ap on ap.subs_id = sh.subs_id
                                      and ap.serv_id = ssh.serv_id
                                      and ap.trpl_id = sh.trpl_id
                  where sh.stime <= sysdate
                    and sysdate < sh.etime
                    and sh.subs_id = 968707
 
Plan hash value: 3606862299
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                               | Name                           | Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | Pstart| Pstop | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                                        |                                |      1 |        |       |   458 (100)|          |       |       |     22 |00:00:02.44 |     366K|       |       |          |
|   1 |  NESTED LOOPS OUTER                                     |                                |      1 |     16 |  4992 |   458   (1)| 00:00:01 |       |       |     22 |00:00:02.44 |     366K|       |       |          |
|*  2 |   HASH JOIN OUTER                                       |                                |      1 |     16 |  4928 |    21   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |     705 |   884K|   884K|  440K (0)|
|   3 |    NESTED LOOPS OUTER                                   |                                |      1 |      8 |  2280 |    20   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |     703 |       |       |          |
|   4 |     NESTED LOOPS                                        |                                |      1 |      8 |  2224 |    18   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |     107 |       |       |          |
|   5 |      NESTED LOOPS OUTER                                 |                                |      1 |      8 |  1920 |    16   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      78 |       |       |          |
|   6 |       NESTED LOOPS                                      |                                |      1 |      8 |  1704 |    15   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      74 |       |       |          |
|   7 |        MERGE JOIN CARTESIAN                             |                                |      1 |     13 |  2288 |    12   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      47 |       |       |          |
|   8 |         NESTED LOOPS OUTER                              |                                |      1 |      1 |   151 |     8   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |      33 |       |       |          |
|   9 |          NESTED LOOPS OUTER                             |                                |      1 |      1 |   146 |     7   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |      30 |       |       |          |
|  10 |           NESTED LOOPS                                  |                                |      1 |      1 |   122 |     6   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |      26 |       |       |          |
|  11 |            MERGE JOIN OUTER                             |                                |      1 |      1 |    99 |     5   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |      22 |       |       |          |
|  12 |             MERGE JOIN OUTER                            |                                |      1 |      1 |    73 |     4   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |      18 |       |       |          |
|  13 |              NESTED LOOPS                               |                                |      1 |      1 |    45 |     2   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       8 |       |       |          |
|  14 |               TABLE ACCESS BY INDEX ROWID               | SUBSCRIBER                     |      1 |      1 |    14 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       4 |       |       |          |
|* 15 |                INDEX UNIQUE SCAN                        | PK$SUBSCRIBER$SUBS_ID          |      1 |      1 |       |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       3 |       |       |          |
|* 16 |               TABLE ACCESS BY INDEX ROWID BATCHED       | SUBS_HISTORY                   |      1 |      1 |    31 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       4 |       |       |          |
|* 17 |                INDEX RANGE SCAN                         | SH_SUBS_ETIME_IDX              |      1 |      1 |       |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       3 |       |       |          |
|  18 |              BUFFER SORT                                |                                |      1 |      1 |    28 |     3   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |      10 |  1024 |  1024 |          |
|  19 |               PARTITION RANGE ITERATOR                  |                                |      1 |      1 |    28 |     2   (0)| 00:00:01 |   KEY |    20 |      0 |00:00:00.01 |      10 |       |       |          |
|* 20 |                TABLE ACCESS BY LOCAL INDEX ROWID BATCHED| SUBS_SERV_HISTORY              |      6 |      1 |    28 |     2   (0)| 00:00:01 |   KEY |    20 |      0 |00:00:00.01 |      10 |       |       |          |
|* 21 |                 INDEX RANGE SCAN                        | SUBS_SERV_HISTORY$SUBS#SERV#ET |      6 |      1 |       |     2   (0)| 00:00:01 |   KEY |    20 |      0 |00:00:00.01 |      10 |       |       |          |
|  22 |             BUFFER SORT                                 |                                |      1 |      1 |    26 |     3   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       4 |  2048 |  2048 | 2048  (0)|
|* 23 |              TABLE ACCESS BY INDEX ROWID BATCHED        | SUBS_USI_HISTORY               |      1 |      1 |    26 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       4 |       |       |          |
|* 24 |               INDEX RANGE SCAN                          | PK$SUBS_USI_HS$SUBS_ID$NUM_HS  |      1 |      1 |       |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       3 |       |       |          |
|* 25 |            TABLE ACCESS BY INDEX ROWID BATCHED          | CLIENT_HISTORY                 |      1 |      1 |    23 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       4 |       |       |          |
|* 26 |             INDEX RANGE SCAN                            | CLIENT_HIST$CLNT_ID#ETIME$IDX  |      1 |      1 |       |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       3 |       |       |          |
|* 27 |           TABLE ACCESS BY INDEX ROWID BATCHED           | CLIENT_TAXES                   |      1 |      1 |    24 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       4 |       |       |          |
|* 28 |            INDEX RANGE SCAN                             | PK$CLIENT_TAXES$CLNT_ID$TAX_ID |      1 |      1 |       |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       3 |       |       |          |
|* 29 |          INDEX UNIQUE SCAN                              | PK$USI$USI_ID                  |      1 |      1 |     5 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       3 |       |       |          |
|  30 |         BUFFER SORT                                     |                                |      1 |     11 |   275 |    11   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      14 |  2048 |  2048 | 2048  (0)|
|  31 |          PARTITION RANGE ITERATOR                       |                                |      1 |     11 |   275 |     4   (0)| 00:00:01 |   KEY |    20 |     16 |00:00:00.01 |      14 |       |       |          |
|* 32 |           TABLE ACCESS BY LOCAL INDEX ROWID BATCHED     | SUBS_SERV_HISTORY              |      6 |     11 |   275 |     4   (0)| 00:00:01 |   KEY |    20 |     16 |00:00:00.01 |      14 |       |       |          |
|* 33 |            INDEX RANGE SCAN                             | SUBS_SERV_HISTORY$SUBS#SERV#ET |      6 |     12 |       |     2   (0)| 00:00:01 |   KEY |    20 |     16 |00:00:00.01 |      10 |       |       |          |
|* 34 |        TABLE ACCESS BY INDEX ROWID BATCHED              | TARIFF_SERVICE                 |     16 |      1 |    37 |     1   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      27 |       |       |          |
|* 35 |         INDEX RANGE SCAN                                | PK$TRFF_SRVC$TRPL_D$SRV_D      |     16 |      1 |       |     1   (0)| 00:00:01 |       |       |     24 |00:00:00.01 |       8 |       |       |          |
|  36 |       TABLE ACCESS BY INDEX ROWID                       | INTERVAL_DICT                  |     16 |      1 |    27 |     1   (0)| 00:00:01 |       |       |      3 |00:00:00.01 |       4 |       |       |          |
|* 37 |        INDEX UNIQUE SCAN                                | PK$INTERVAL_DICT$INT_DICT_ID   |     16 |      1 |       |     1   (0)| 00:00:01 |       |       |      3 |00:00:00.01 |       1 |       |       |          |
|  38 |      TABLE ACCESS BY INDEX ROWID                        | SERVICE                        |     16 |      1 |    38 |     1   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      29 |       |       |          |
|* 39 |       INDEX UNIQUE SCAN                                 | PK$SERVICE$SERV_ID             |     16 |      1 |       |     1   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |      13 |       |       |          |
|  40 |     TABLE ACCESS BY INDEX ROWID                         | INTERVAL_DICT                  |     16 |      1 |     7 |     1   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |     596 |       |       |          |
|* 41 |      INDEX UNIQUE SCAN                                  | PK$INTERVAL_DICT$INT_DICT_ID   |     16 |      1 |       |     1   (0)| 00:00:01 |       |       |     16 |00:00:00.01 |     580 |       |       |          |
|* 42 |    TABLE ACCESS BY INDEX ROWID BATCHED                  | TAX_HISTORY                    |      1 |      2 |    46 |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       2 |       |       |          |
|* 43 |     INDEX RANGE SCAN                                    | TAX_HISTORY$ETIME              |      1 |      2 |       |     1   (0)| 00:00:01 |       |       |      1 |00:00:00.01 |       1 |       |       |          |
|* 44 |   COLLECTION ITERATOR PICKLER FETCH                     | GET_CLNT_SERV_CHARGE           |     16 |      1 |     4 |    27   (0)| 00:00:01 |       |       |      8 |00:00:02.43 |     366K|       |       |          |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$5532671F
  14 - SEL$5532671F / SB@SEL$1
  15 - SEL$5532671F / SB@SEL$1
  16 - SEL$5532671F / SH@SEL$1
  17 - SEL$5532671F / SH@SEL$1
  20 - SEL$5532671F / SSH2@SEL$5
  21 - SEL$5532671F / SSH2@SEL$5
  23 - SEL$5532671F / SUH@SEL$2
  24 - SEL$5532671F / SUH@SEL$2
  25 - SEL$5532671F / CH@SEL$11
  26 - SEL$5532671F / CH@SEL$11
  27 - SEL$5532671F / CT@SEL$8
  28 - SEL$5532671F / CT@SEL$8
  29 - SEL$5532671F / U@SEL$3
  32 - SEL$5532671F / SSH@SEL$4
  33 - SEL$5532671F / SSH@SEL$4
  34 - SEL$5532671F / TS@SEL$7
  35 - SEL$5532671F / TS@SEL$7
  36 - SEL$5532671F / IDI@SEL$10
  37 - SEL$5532671F / IDI@SEL$10
  38 - SEL$5532671F / S@SEL$6
  39 - SEL$5532671F / S@SEL$6
  40 - SEL$5532671F / IDI2@SEL$12
  41 - SEL$5532671F / IDI2@SEL$12
  42 - SEL$5532671F / TH@SEL$9
  43 - SEL$5532671F / TH@SEL$9
  44 - SEL$5532671F / KOKBF$0@SEL$14
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      IGNORE_OPTIM_EMBEDDED_HINTS
      OPTIMIZER_FEATURES_ENABLE('19.1.0')
      DB_VERSION('19.1.0')
      OPT_PARAM('optimizer_index_cost_adj' 25)
      OPT_PARAM('optimizer_index_caching' 100)
      ALL_ROWS
      OUTLINE_LEAF(@"SEL$5532671F")
      MERGE(@"SEL$1CF66C63" >"SEL$2079BD10")
      OUTLINE(@"SEL$2079BD10")
      MERGE(@"SEL$BF0BE69A" >"SEL$16")
      OUTLINE(@"SEL$1CF66C63")
      MERGE(@"SEL$14" >"SEL$13")
      OUTLINE(@"SEL$16")
      OUTLINE(@"SEL$BF0BE69A")
      MERGE(@"SEL$2FF2AA33" >"SEL$300E1A3C")
      OUTLINE(@"SEL$13")
      OUTLINE(@"SEL$14")
      OUTLINE(@"SEL$300E1A3C")
      ANSI_REARCH(@"SEL$15")
      OUTLINE(@"SEL$2FF2AA33")
      MERGE(@"SEL$5823572D" >"SEL$8BB7F254")
      OUTLINE(@"SEL$15")
      OUTLINE(@"SEL$8BB7F254")
      ANSI_REARCH(@"SEL$12")
      OUTLINE(@"SEL$5823572D")
      MERGE(@"SEL$F0771A65" >"SEL$AC502716")
      OUTLINE(@"SEL$12")
      OUTLINE(@"SEL$AC502716")
      ANSI_REARCH(@"SEL$11")
      OUTLINE(@"SEL$F0771A65")
      MERGE(@"SEL$E47DDC80" >"SEL$C3276022")
      OUTLINE(@"SEL$11")
      OUTLINE(@"SEL$C3276022")
      ANSI_REARCH(@"SEL$F96D694F")
      OUTLINE(@"SEL$E47DDC80")
      MERGE(@"SEL$EC1B6B75" >"SEL$4623585D")
      OUTLINE(@"SEL$F96D694F")
      ANSI_REARCH(@"SEL$10")
      OUTLINE(@"SEL$4623585D")
      ANSI_REARCH(@"SEL$C4CE708E")
      OUTLINE(@"SEL$EC1B6B75")
      MERGE(@"SEL$7FB6BAB7" >"SEL$82B3A4B9")
      OUTLINE(@"SEL$10")
      OUTLINE(@"SEL$C4CE708E")
      ANSI_REARCH(@"SEL$9")
      OUTLINE(@"SEL$82B3A4B9")
      ANSI_REARCH(@"SEL$8")
      OUTLINE(@"SEL$7FB6BAB7")
      MERGE(@"SEL$820683A9" >"SEL$7")
      OUTLINE(@"SEL$9")
      OUTLINE(@"SEL$8")
      OUTLINE(@"SEL$7")
      OUTLINE(@"SEL$820683A9")
      MERGE(@"SEL$F6E2B8B2" >"SEL$29421ABC")
      OUTLINE(@"SEL$29421ABC")
      ANSI_REARCH(@"SEL$6")
      OUTLINE(@"SEL$F6E2B8B2")
      MERGE(@"SEL$62D7CD7B" >"SEL$EB4BAB32")
      OUTLINE(@"SEL$6")
      OUTLINE(@"SEL$EB4BAB32")
      ANSI_REARCH(@"SEL$5")
      OUTLINE(@"SEL$62D7CD7B")
      MERGE(@"SEL$BF83D006" >"SEL$D2E4DCB5")
      OUTLINE(@"SEL$5")
      OUTLINE(@"SEL$D2E4DCB5")
      ANSI_REARCH(@"SEL$4")
      OUTLINE(@"SEL$BF83D006")
      MERGE(@"SEL$8B0CE372" >"SEL$791DB105")
      OUTLINE(@"SEL$4")
      OUTLINE(@"SEL$791DB105")
      ANSI_REARCH(@"SEL$F52A8B21")
      OUTLINE(@"SEL$8B0CE372")
      MERGE(@"SEL$1" >"SEL$1A566D0B")
      OUTLINE(@"SEL$F52A8B21")
      ANSI_REARCH(@"SEL$3")
      OUTLINE(@"SEL$1A566D0B")
      ANSI_REARCH(@"SEL$2")
      OUTLINE(@"SEL$1")
      OUTLINE(@"SEL$3")
      OUTLINE(@"SEL$2")
      INDEX_RS_ASC(@"SEL$5532671F" "SB"@"SEL$1" ("SUBSCRIBER"."SUBS_ID"))
      INDEX_RS_ASC(@"SEL$5532671F" "SH"@"SEL$1" ("SUBS_HISTORY"."SUBS_ID" "SUBS_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "SH"@"SEL$1")
      INDEX_RS_ASC(@"SEL$5532671F" "SSH2"@"SEL$5" ("SUBS_SERV_HISTORY"."SUBS_ID" "SUBS_SERV_HISTORY"."SERV_ID" "SUBS_SERV_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "SSH2"@"SEL$5")
      INDEX_RS_ASC(@"SEL$5532671F" "SUH"@"SEL$2" ("SUBS_USI_HISTORY"."SUBS_ID" "SUBS_USI_HISTORY"."NUM_HISTORY"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "SUH"@"SEL$2")
      INDEX_RS_ASC(@"SEL$5532671F" "CH"@"SEL$11" ("CLIENT_HISTORY"."CLNT_ID" "CLIENT_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "CH"@"SEL$11")
      INDEX_RS_ASC(@"SEL$5532671F" "CT"@"SEL$8" ("CLIENT_TAXES"."CLNT_ID" "CLIENT_TAXES"."TAX_ID" "CLIENT_TAXES"."NUM_HISTORY"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "CT"@"SEL$8")
      INDEX(@"SEL$5532671F" "U"@"SEL$3" ("USI"."USI_ID"))
      INDEX_RS_ASC(@"SEL$5532671F" "SSH"@"SEL$4" ("SUBS_SERV_HISTORY"."SUBS_ID" "SUBS_SERV_HISTORY"."SERV_ID" "SUBS_SERV_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "SSH"@"SEL$4")
      INDEX_RS_ASC(@"SEL$5532671F" "TS"@"SEL$7" ("TARIFF_SERVICE"."TRPL_ID" "TARIFF_SERVICE"."SERV_ID" "TARIFF_SERVICE"."NUM_HISTORY"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "TS"@"SEL$7")
      INDEX_RS_ASC(@"SEL$5532671F" "IDI"@"SEL$10" ("INTERVAL_DICT"."INT_DICT_ID"))
      INDEX_RS_ASC(@"SEL$5532671F" "S"@"SEL$6" ("SERVICE"."SERV_ID"))
      INDEX_RS_ASC(@"SEL$5532671F" "IDI2"@"SEL$12" ("INTERVAL_DICT"."INT_DICT_ID"))
      INDEX_RS_ASC(@"SEL$5532671F" "TH"@"SEL$9" ("TAX_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$5532671F" "TH"@"SEL$9")
      FULL(@"SEL$5532671F" "KOKBF$0"@"SEL$14")
      LEADING(@"SEL$5532671F" "SB"@"SEL$1" "SH"@"SEL$1" "SSH2"@"SEL$5" "SUH"@"SEL$2" "CH"@"SEL$11" "CT"@"SEL$8" "U"@"SEL$3" "SSH"@"SEL$4" "TS"@"SEL$7" "IDI"@"SEL$10" "S"@"SEL$6" "IDI2"@"SEL$12" "TH"@"SEL$9" 
              "KOKBF$0"@"SEL$14")
      USE_NL(@"SEL$5532671F" "SH"@"SEL$1")
      USE_MERGE_CARTESIAN(@"SEL$5532671F" "SSH2"@"SEL$5")
      USE_MERGE_CARTESIAN(@"SEL$5532671F" "SUH"@"SEL$2")
      USE_NL(@"SEL$5532671F" "CH"@"SEL$11")
      USE_NL(@"SEL$5532671F" "CT"@"SEL$8")
      USE_NL(@"SEL$5532671F" "U"@"SEL$3")
      USE_MERGE_CARTESIAN(@"SEL$5532671F" "SSH"@"SEL$4")
      USE_NL(@"SEL$5532671F" "TS"@"SEL$7")
      USE_NL(@"SEL$5532671F" "IDI"@"SEL$10")
      USE_NL(@"SEL$5532671F" "S"@"SEL$6")
      USE_NL(@"SEL$5532671F" "IDI2"@"SEL$12")
      USE_HASH(@"SEL$5532671F" "TH"@"SEL$9")
      USE_NL(@"SEL$5532671F" "KOKBF$0"@"SEL$14")
      END_OUTLINE_DATA
  */
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CT"."TAX_ID"="TH"."TAX_ID")
  15 - access("SB"."SUBS_ID"=968707)
  16 - filter("SH"."STIME"<=SYSDATE@!)
  17 - access("SH"."SUBS_ID"=968707 AND "SH"."ETIME">SYSDATE@!)
  20 - filter((INTERNAL_FUNCTION("SSH2"."SSTAT_ID") AND "SSH2"."STIME"<=SYSDATE@!))
  21 - access("SSH2"."SUBS_ID"=968707 AND "SSH2"."SERV_ID"=2881 AND "SSH2"."ETIME">SYSDATE@! AND "SSH2"."ETIME" IS NOT NULL)
  23 - filter(("SUH"."ETIME">SYSDATE@! AND "SUH"."STIME"<=SYSDATE@!))
  24 - access("SUH"."SUBS_ID"=968707)
  25 - filter("CH"."STIME"<=SYSDATE@!)
  26 - access("CH"."CLNT_ID"="SH"."CLNT_ID" AND "CH"."ETIME">SYSDATE@!)
  27 - filter(("CT"."STIME"<=SYSDATE@! AND "CT"."ETIME">SYSDATE@!))
  28 - access("SH"."CLNT_ID"="CT"."CLNT_ID" AND "CT"."TAX_ID"=1)
  29 - access("SUH"."USI_ID"="U"."USI_ID")
  32 - filter("SSH"."STIME"<=SYSDATE@!)
  33 - access("SSH"."SUBS_ID"=968707 AND "SSH"."ETIME">SYSDATE@!)
       filter("SSH"."ETIME">SYSDATE@!)
  34 - filter(("TS"."ETIME">SYSDATE@! AND "TS"."STIME"<=SYSDATE@!))
  35 - access("SH"."TRPL_ID"="TS"."TRPL_ID" AND "SSH"."SERV_ID"="TS"."SERV_ID")
  37 - access("TS"."INT_DICT_ID"="IDI"."INT_DICT_ID")
  39 - access("SSH"."SERV_ID"="S"."SERV_ID")
  41 - access("IDI2"."INT_DICT_ID"=TO_NUMBER("INV_POLICY"."GET_MP_PACK_PARAM_VALUE"("CH"."POLICY_ID",'AP_INTERVAL',SYSDATE@!)))
  42 - filter("TH"."STIME"<=SYSDATE@!)
  43 - access("TH"."ETIME">SYSDATE@!)
  44 - filter(("SH"."SUBS_ID"=VALUE(KOKBF$) AND "SSH"."SERV_ID"=VALUE(KOKBF$) AND "SH"."TRPL_ID"=VALUE(KOKBF$) AND VALUE(KOKBF$)=968707))
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "SB"."ACTIVATION_DATE"[DATE,7], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "IDI2"."INT_TYPE_ID"[NUMBER,22], "U"."USI_ID"[NUMBER,22], "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], 
       "TS"."NEXT_MONTH$"[NUMBER,22], "IDI"."INT_TYPE_ID"[NUMBER,22], "IDI"."INT_DICT_NAME"[VARCHAR2,50], "IDI"."QUANTITY"[NUMBER,22], "S"."SERV_NAME"[VARCHAR2,250], "TH"."TAX_RATE"[NUMBER,22], VALUE(A0)[22]
   2 - (#keys=1) "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], 
       "IDI2"."INT_TYPE_ID"[NUMBER,22], "U"."USI_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], "TS"."NEXT_MONTH$"[NUMBER,22], "IDI"."INT_TYPE_ID"[NUMBER,22], 
       "IDI"."INT_DICT_NAME"[VARCHAR2,50], "IDI"."QUANTITY"[NUMBER,22], "S"."SERV_NAME"[VARCHAR2,250], "TH"."TAX_RATE"[NUMBER,22]
   3 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CT"."TAX_ID"[NUMBER,22], 
       "U"."USI_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], "TS"."NEXT_MONTH$"[NUMBER,22], "IDI"."INT_TYPE_ID"[NUMBER,22], "IDI"."INT_DICT_NAME"[VARCHAR2,50], 
       "IDI"."QUANTITY"[NUMBER,22], "S"."SERV_NAME"[VARCHAR2,250], "IDI2"."INT_TYPE_ID"[NUMBER,22]
   4 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CT"."TAX_ID"[NUMBER,22], 
       "U"."USI_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], "TS"."NEXT_MONTH$"[NUMBER,22], "IDI"."INT_TYPE_ID"[NUMBER,22], "IDI"."INT_DICT_NAME"[VARCHAR2,50], 
       "IDI"."QUANTITY"[NUMBER,22], "S"."SERV_NAME"[VARCHAR2,250]
   5 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CT"."TAX_ID"[NUMBER,22], 
       "U"."USI_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], "TS"."NEXT_MONTH$"[NUMBER,22], "IDI"."INT_TYPE_ID"[NUMBER,22], "IDI"."INT_DICT_NAME"[VARCHAR2,50], 
       "IDI"."QUANTITY"[NUMBER,22]
   6 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CT"."TAX_ID"[NUMBER,22], 
       "U"."USI_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], "TS"."NEXT_MONTH$"[NUMBER,22], "TS"."INT_DICT_ID"[NUMBER,22]
   7 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CT"."TAX_ID"[NUMBER,22], 
       "U"."USI_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22]
   8 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CT"."TAX_ID"[NUMBER,22], 
       "U"."USI_ID"[NUMBER,22]
   9 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "SUH"."USI_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], 
       "CT"."TAX_ID"[NUMBER,22]
  10 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "SUH"."USI_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22]
  11 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22], "SUH"."USI_ID"[NUMBER,22]
  12 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22], "SSH2"."SERV_ID"[NUMBER,22]
  13 - "SB"."ACTIVATION_DATE"[DATE,7], "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22]
  14 - "SB"."ACTIVATION_DATE"[DATE,7]
  15 - "SB".ROWID[ROWID,10]
  16 - "SH"."SUBS_ID"[NUMBER,22], "SH"."CLNT_ID"[NUMBER,22], "SH"."TRPL_ID"[NUMBER,22]
  17 - "SH".ROWID[ROWID,10], "SH"."SUBS_ID"[NUMBER,22]
  18 - (#keys=0) "SSH2"."SERV_ID"[NUMBER,22]
  19 - "SSH2"."SERV_ID"[NUMBER,22]
  20 - "SSH2"."SERV_ID"[NUMBER,22]
  21 - "SSH2".ROWID[ROWID,10], "SSH2"."SERV_ID"[NUMBER,22]
  22 - (#keys=0) "SUH"."USI_ID"[NUMBER,22]
  23 - "SUH"."USI_ID"[NUMBER,22]
  24 - "SUH".ROWID[ROWID,10]
  25 - "CH"."POLICY_ID"[NUMBER,22]
  26 - "CH".ROWID[ROWID,10]
  27 - "CT"."TAX_ID"[NUMBER,22]
  28 - "CT".ROWID[ROWID,10], "CT"."TAX_ID"[NUMBER,22]
  29 - "U"."USI_ID"[NUMBER,22]
  30 - (#keys=0) "SSH"."SERV_ID"[NUMBER,22]
  31 - "SSH"."SERV_ID"[NUMBER,22]
  32 - "SSH"."SERV_ID"[NUMBER,22]
  33 - "SSH".ROWID[ROWID,10], "SSH"."SERV_ID"[NUMBER,22]
  34 - "TS"."ACHM_ID"[NUMBER,22], "TS"."FIRST_ON$"[NUMBER,22], "TS"."NEXT_MONTH$"[NUMBER,22], "TS"."INT_DICT_ID"[NUMBER,22]
  35 - "TS".ROWID[ROWID,10]
  36 - "IDI"."INT_TYPE_ID"[NUMBER,22], "IDI"."INT_DICT_NAME"[VARCHAR2,50], "IDI"."QUANTITY"[NUMBER,22]
  37 - "IDI".ROWID[ROWID,10]
  38 - "S"."SERV_NAME"[VARCHAR2,250]
  39 - "S".ROWID[ROWID,10]
  40 - "IDI2"."INT_TYPE_ID"[NUMBER,22]
  41 - "IDI2".ROWID[ROWID,10]
  42 - "TH"."TAX_ID"[NUMBER,22], "TH"."TAX_RATE"[NUMBER,22]
  43 - "TH".ROWID[ROWID,10]
  44 - VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[21], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22], VALUE(A0)[22]
