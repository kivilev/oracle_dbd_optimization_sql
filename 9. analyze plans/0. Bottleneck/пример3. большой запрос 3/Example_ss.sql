SQL_ID  2258rmhahzvux, child number 0
-------------------------------------
with cr as (
     select /*+ materialize*/ 
             mph.policy_id,
            (select to_number(max(valhst.value))
               from mp_action ma
               join mp_statement_history stat on ( ma.action_id = stat.action_id )
               join mp_statement statg on ( stat.ps_id = statg.ps_id and statg.del_date is null )
               join mp_variable_history varhst on ( stat.variable_id = varhst.variable_id )
               join mp_value_history valhst on ( stat.value_id = valhst.val_id )
              where ma.policy_id = mph.policy_id
                and ma.del_date is null
                and varhst.var_type_id = 12
                and varhst.tpd_code = 'AP_INTERVAL'
                and stat.stime <= sysdate and sysdate < stat.etime
                and varhst.stime <= sysdate and sysdate < varhst.etime
                and valhst.stime <= sysdate and sysdate < valhst.etime) as int_id,
            (select to_number(max(valhst.value))
               from mp_action ma
               join mp_statement_history stat on ( ma.action_id = stat.action_id )
               join mp_statement statg on ( stat.ps_id = statg.ps_id and statg.del_date is null )
               join mp_variable_history varhst on ( stat.variable_id = varhst.variable_id )
               join mp_value_history valhst on ( stat.value_id = valhst.val_id )
              where ma.policy_id = mph.policy_id
                and ma.del_date is null
                and varhst.var_type_id = 12
                and varhst.tpd_code = 'SERV_MARKER_ID'
                and stat.stime <= sysdate and sysdate < stat.etime
                and varhst.stime <= sysdate and sysdate < varhst.etime
                and valhst.stime <= sysdate and sysdate < valhst.etime) as serv_marker_id       
       from mp_policy_history mph
      where mph.smst_id = 1
        and mph.stime <= sysdate
        and mph.etime >  sysdate
        and mph.policy_level = 1
      group by mph.policy_id 
    )
    select /*+ ordered leading(cr)*/
           sbh.subs_id
      from cr
      join client_history ch on ch.policy_id = cr.policy_id
      join client clnt on clnt.clnt_id = ch.clnt_id      
      join subs_history sbh on sbh.clnt_id = ch.clnt_id
                           and sbh.stime <= sysdate
                           and sbh.etime >  sysdate
      join subscriber sub on sub.subs_id = sbh.subs_id
      join mp_policy_history mph on mph.policy_id = cr.policy_id
                                and mph.stime <= sysdate
                                and mph.etime >  sysdate
      join tariff_service ts on ts.trpl_id = sbh.trpl_id 
                            and ts.tsst_id = 1
                            and ts.stime  <= sysdate
                            and ts.etime  >  sysdate
      join subs_serv_history ssh on ssh.subs_id = sbh.subs_id
                                and ssh.serv_id = ts.serv_id
                                and ssh.etime >  sysdate
                                and ssh.stime <= sysdate
      join interval_dict id on id.int_dict_id = cr.int_id
     where ch.stime  <= sysdate
       and ch.etime  >  sysdate
       -- Типы клиентов, абоненты которых не учитываются
       and ( ( not exists ( select 1
                              from table( t_integers_tab (:B1) ) sub_st
                             where sub_st.column_value = clnt.ct_id ) and :i_not_clnt_type is not null ) or ( :i_not_clnt_type is null ) )
       -- У клиента подключен пакет услуг (политика)
       and nvl( ch.policy_id, 0) > 0
       -- Идет первый период с момента сборки клиентского пакета (дата подключения пакета + интервал расчета АП по пакету > текущий момент времени)
       and gp.get_end_date( i_time           => ( select max(clh.etime)
                                                    from client_history clh
                                                   where clh.clnt_id = ch.clnt_id
                                                     and nvl( clh.policy_id, 0) != ch.policy_id ),
                            i_int_type_id    => id.int_type_id,
                            i_quantity       => id.quantity,
                            i_renew_quantity => 1,
                            i_trpl_id        => sbh.trpl_id,
                            i_precision      => id.precision) > sysdate
       -- Абонент активирован
       and sub.activation_date is not null
       and sub.activation_date <= sysdate
       -- На тарифном плане есть услуги с charge_group = 2
       and ts.charge_group = 2
       -- Исключаем абонентов с услугой-маркером
       and ( cr.serv_marker_id is null ) or
           ( not exists ( select 1
                            from subs_serv_history ssh
                           where ssh.subs_id = sub.subs_id
                             and ssh.serv_id = cr.serv_marker_id
                             and ssh.stime  <= sysdate
                             and ssh.etime  >  sysdate
                             and ssh.sstat_id in (1, 4) ) ) --активна или разблокирована
       and (
           -- Перечень тарифных планов задан
           ( exists ( select 1
                        from table( t_integers_tab (:B2) ) sub_st
                       where sub_st.column_value = sbh.trpl_id ) and :i_trpl is not null ) or
           -- Перечень тарифных планов не задан, и тип тарифного плана любой
           ( :i_trpl is null and :i_trpl_type = 0 ) or
           -- Перечень тарифных планов не задан, и тип тарифного плана календарный
           ( :i_trpl is null and :i_trpl_type = 1 and nvl( id.int_type_id, :Var2 ) in ( :Var4, :Var3 ) ) or
           -- Перечень тарифных планов не задан, и тип тарифного плана не календарный
           ( :i_trpl is null and :i_trpl_type = 2 and nvl( id.int_type_id, :Var5 ) not in ( :Var7, :Var6 ) )
           )
       and mod(sbh.subs_id, :i_streams) = :i_num_stream - 1
     group by sbh.subs_id
 
Plan hash value: 1275825371
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                      | Name                           | Starts | E-Rows |E-Bytes|E-Temp | Cost (%CPU)| E-Time   | Pstart| Pstop | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                               |                                |      1 |        |       |       |   335K(100)|          |       |       |      0 |00:00:00.44 |   14537 |       |       |          |
|   1 |  TEMP TABLE TRANSFORMATION                     |                                |      1 |        |       |       |            |          |       |       |      0 |00:00:00.44 |   14537 |       |       |          |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)      | SYS_TEMP_0FD9D6614_779F94E1    |      1 |        |       |       |            |          |       |       |      0 |00:00:00.03 |    5501 |  1024 |  1024 |          |
|   3 |    SORT AGGREGATE                              |                                |    149 |      1 |   102 |       |            |          |       |       |    149 |00:00:00.01 |    2767 |       |       |          |
|   4 |     NESTED LOOPS                               |                                |    149 |      1 |   102 |       |     5   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2767 |       |       |          |
|   5 |      NESTED LOOPS                              |                                |    149 |      1 |   102 |       |     5   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2618 |       |       |          |
|   6 |       NESTED LOOPS                             |                                |    149 |      1 |    96 |       |     4   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2601 |       |       |          |
|*  7 |        HASH JOIN                               |                                |    149 |      1 |    66 |       |     3   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2564 |   951K|   951K| 1156K (0)|
|   8 |         NESTED LOOPS                           |                                |    149 |      6 |   246 |       |     2   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |    1968 |       |       |          |
|   9 |          NESTED LOOPS                          |                                |    149 |      8 |   246 |       |     2   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |    1456 |       |       |          |
|* 10 |           TABLE ACCESS BY INDEX ROWID BATCHED  | MP_ACTION                      |    149 |      4 |    36 |       |     1   (0)| 00:00:01 |       |       |    626 |00:00:00.01 |     675 |       |       |          |
|* 11 |            INDEX RANGE SCAN                    | MP_ACTION$POLICY_ID$I          |    149 |      4 |       |       |     1   (0)| 00:00:01 |       |       |    626 |00:00:00.01 |     235 |       |       |          |
|* 12 |           INDEX RANGE SCAN                     | MP_STAT_HIST$COND_ID#ETIME$I   |    626 |      2 |       |       |     1   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |     781 |       |       |          |
|* 13 |          TABLE ACCESS BY INDEX ROWID           | MP_STATEMENT_HISTORY           |    836 |      2 |    64 |       |     1   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |     512 |       |       |          |
|* 14 |         TABLE ACCESS BY INDEX ROWID BATCHED    | MP_VARIABLE_HISTORY            |    149 |      1 |    25 |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |     596 |       |       |          |
|* 15 |          INDEX RANGE SCAN                      | MP_VARHIST$VART_ID#ETIME$I     |    149 |     10 |       |       |     1   (0)| 00:00:01 |       |       |   1490 |00:00:00.01 |     149 |       |       |          |
|* 16 |        TABLE ACCESS BY INDEX ROWID BATCHED     | MP_VALUE_HISTORY               |    149 |      1 |    30 |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |      37 |       |       |          |
|* 17 |         INDEX RANGE SCAN                       | MP_VAL_HIST$VAL_ID#NUM_HIST$P  |    149 |      1 |       |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |       3 |       |       |          |
|* 18 |       INDEX UNIQUE SCAN                        | MP_STATEMENT$PS_ID$P           |    149 |      1 |       |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |      17 |       |       |          |
|* 19 |      TABLE ACCESS BY INDEX ROWID               | MP_STATEMENT                   |    149 |      1 |     6 |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |     149 |       |       |          |
|  20 |    SORT AGGREGATE                              |                                |    149 |      1 |   102 |       |            |          |       |       |    149 |00:00:00.01 |    2726 |       |       |          |
|  21 |     NESTED LOOPS                               |                                |    149 |      1 |   102 |       |     5   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2726 |       |       |          |
|  22 |      NESTED LOOPS                              |                                |    149 |      1 |   102 |       |     5   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2577 |       |       |          |
|  23 |       NESTED LOOPS                             |                                |    149 |      1 |    96 |       |     4   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2568 |       |       |          |
|* 24 |        HASH JOIN                               |                                |    149 |      1 |    66 |       |     3   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |    2564 |   951K|   951K| 1156K (0)|
|  25 |         NESTED LOOPS                           |                                |    149 |      6 |   246 |       |     2   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |    1968 |       |       |          |
|  26 |          NESTED LOOPS                          |                                |    149 |      8 |   246 |       |     2   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |    1456 |       |       |          |
|* 27 |           TABLE ACCESS BY INDEX ROWID BATCHED  | MP_ACTION                      |    149 |      4 |    36 |       |     1   (0)| 00:00:01 |       |       |    626 |00:00:00.01 |     675 |       |       |          |
|* 28 |            INDEX RANGE SCAN                    | MP_ACTION$POLICY_ID$I          |    149 |      4 |       |       |     1   (0)| 00:00:01 |       |       |    626 |00:00:00.01 |     235 |       |       |          |
|* 29 |           INDEX RANGE SCAN                     | MP_STAT_HIST$COND_ID#ETIME$I   |    626 |      2 |       |       |     1   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |     781 |       |       |          |
|* 30 |          TABLE ACCESS BY INDEX ROWID           | MP_STATEMENT_HISTORY           |    836 |      2 |    64 |       |     1   (0)| 00:00:01 |       |       |    836 |00:00:00.01 |     512 |       |       |          |
|* 31 |         TABLE ACCESS BY INDEX ROWID BATCHED    | MP_VARIABLE_HISTORY            |    149 |      1 |    25 |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |     596 |       |       |          |
|* 32 |          INDEX RANGE SCAN                      | MP_VARHIST$VART_ID#ETIME$I     |    149 |     10 |       |       |     1   (0)| 00:00:01 |       |       |   1490 |00:00:00.01 |     149 |       |       |          |
|* 33 |        TABLE ACCESS BY INDEX ROWID BATCHED     | MP_VALUE_HISTORY               |    149 |      1 |    30 |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |       4 |       |       |          |
|* 34 |         INDEX RANGE SCAN                       | MP_VAL_HIST$VAL_ID#NUM_HIST$P  |    149 |      1 |       |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |       3 |       |       |          |
|* 35 |       INDEX UNIQUE SCAN                        | MP_STATEMENT$PS_ID$P           |    149 |      1 |       |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |       9 |       |       |          |
|* 36 |      TABLE ACCESS BY INDEX ROWID               | MP_STATEMENT                   |    149 |      1 |     6 |       |     1   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |     149 |       |       |          |
|  37 |    HASH GROUP BY                               |                                |      1 |    133 |  3458 |       |   698   (1)| 00:00:01 |       |       |    149 |00:00:00.01 |       7 |  2170K|  2170K| 1431K (0)|
|* 38 |     TABLE ACCESS BY INDEX ROWID BATCHED        | MP_POLICY_HISTORY              |      1 |    138 |  3588 |       |     3   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |       7 |       |       |          |
|* 39 |      INDEX SKIP SCAN                           | MP_POLHIST$BCT#BRANCH#ETIME$I  |      1 |    210 |       |       |     1   (0)| 00:00:01 |       |       |    214 |00:00:00.01 |       1 |       |       |          |
|  40 |   HASH GROUP BY                                |                                |      1 |      2 |   394 |       |            |          |       |       |      0 |00:00:00.41 |    9035 |   765K|   765K|          |
|  41 |    CONCATENATION                               |                                |      1 |        |       |       |            |          |       |       |      0 |00:00:00.41 |    9035 |       |       |          |
|* 42 |     FILTER                                     |                                |      1 |        |       |       |            |          |       |       |      0 |00:00:00.41 |    8647 |       |       |          |
|* 43 |      HASH JOIN                                 |                                |      1 |    148K|    27M|       |   170K  (1)| 00:00:07 |       |       |      0 |00:00:00.41 |    8647 |  1572K|  1572K| 1567K (0)|
|  44 |       TABLE ACCESS FULL                        | INTERVAL_DICT                  |      1 |     35 |   490 |       |     4   (0)| 00:00:01 |       |       |     36 |00:00:00.01 |       7 |       |       |          |
|* 45 |       HASH JOIN                                |                                |      1 |    148K|    25M|   283M|   170K  (1)| 00:00:07 |       |       |      0 |00:00:00.41 |    8640 |   774K|   774K|   16M (0)|
|* 46 |        HASH JOIN                               |                                |      1 |   1750K|   263M|       | 16415   (1)| 00:00:01 |       |       |      0 |00:00:00.40 |    8640 |  2192K|  1595K| 1680K (0)|
|* 47 |         TABLE ACCESS FULL                      | TARIFF_SERVICE                 |      1 |  16347 |   462K|       |   103   (1)| 00:00:01 |       |       |  16309 |00:00:00.01 |     374 |       |       |          |
|* 48 |         HASH JOIN                              |                                |      1 |  24527 |  3089K|       | 16307   (1)| 00:00:01 |       |       |      0 |00:00:00.38 |    8266 |  1196K|  1196K| 1631K (0)|
|* 49 |          TABLE ACCESS BY INDEX ROWID BATCHED   | MP_POLICY_HISTORY              |      1 |    210 |  4200 |       |     3   (0)| 00:00:01 |       |       |    214 |00:00:00.01 |       7 |       |       |          |
|* 50 |           INDEX SKIP SCAN                      | MP_POLHIST$BCT#BRANCH#ETIME$I  |      1 |    210 |       |       |     1   (0)| 00:00:01 |       |       |    214 |00:00:00.01 |       1 |       |       |          |
|* 51 |          HASH JOIN                             |                                |      1 |  22892 |  2436K|  2400K| 16304   (1)| 00:00:01 |       |       |      0 |00:00:00.38 |    8259 |   838K|   838K|  528K (0)|
|* 52 |           HASH JOIN                            |                                |      1 |  22892 |  2123K|       | 12388   (1)| 00:00:01 |       |       |      0 |00:00:00.38 |    8259 |  1075K|  1075K|  522K (0)|
|* 53 |            TABLE ACCESS BY INDEX ROWID BATCHED | SUBS_HISTORY                   |      1 |  14438 |   451K|       |  3252   (0)| 00:00:01 |       |       |      0 |00:00:00.38 |    8259 |       |       |          |
|* 54 |             INDEX SKIP SCAN                    | SH_SUBS_ETIME_IDX              |      1 |   5775 |       |       |  1947   (0)| 00:00:01 |       |       |      0 |00:00:00.38 |    8259 |       |       |          |
|* 55 |            HASH JOIN                           |                                |      0 |    200K|    12M|    12M|  9134   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |    24M|  5090K|          |
|* 56 |             HASH JOIN                          |                                |      0 |    200K|    10M|       |  5253   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |  1142K|  1142K|          |
|  57 |              VIEW                              |                                |      0 |    133 |  3990 |       |     2   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  58 |               TABLE ACCESS FULL                | SYS_TEMP_0FD9D6614_779F94E1    |      0 |    133 |  3458 |       |     2   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 59 |              TABLE ACCESS FULL                 | CLIENT_HISTORY                 |      0 |    200K|  4696K|       |  5250   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  60 |             TABLE ACCESS FULL                  | CLIENT                         |      0 |   1305K|    11M|       |  1952   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  61 |           TABLE ACCESS FULL                    | SUBSCRIBER                     |      0 |   1439K|    19M|       |  2023   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  62 |        PARTITION RANGE ITERATOR                |                                |      0 |     13M|   327M|       |   116K  (1)| 00:00:05 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 63 |         TABLE ACCESS FULL                      | SUBS_SERV_HISTORY              |      0 |     13M|   327M|       |   116K  (1)| 00:00:05 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|  64 |      PARTITION RANGE ITERATOR                  |                                |      0 |      1 |    28 |       |     3   (0)| 00:00:01 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 65 |       TABLE ACCESS BY LOCAL INDEX ROWID BATCHED| SUBS_SERV_HISTORY              |      0 |      1 |    28 |       |     3   (0)| 00:00:01 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 66 |        INDEX SKIP SCAN                         | SUBS_SERV_HISTORY$SUBS#SERV#ET |      0 |      1 |       |       |     3   (0)| 00:00:01 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 67 |      COLLECTION ITERATOR CONSTRUCTOR FETCH     |                                |      0 |     82 |   164 |       |    29   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 68 |     FILTER                                     |                                |      1 |        |       |       |            |          |       |       |      0 |00:00:00.01 |     388 |       |       |          |
|* 69 |      HASH JOIN                                 |                                |      1 |   7371 |  1418K|       |   163K  (1)| 00:00:07 |       |       |      0 |00:00:00.01 |     388 |  1572K|  1572K| 1598K (0)|
|  70 |       TABLE ACCESS FULL                        | INTERVAL_DICT                  |      1 |     35 |   490 |       |     4   (0)| 00:00:01 |       |       |     36 |00:00:00.01 |       7 |       |       |          |
|* 71 |       HASH JOIN                                |                                |      1 |   7371 |  1317K|    15M|   163K  (1)| 00:00:07 |       |       |      0 |00:00:00.01 |     381 |   774K|   774K| 1092K (0)|
|* 72 |        HASH JOIN                               |                                |      1 |  96902 |    14M|       | 22292   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |     381 |  1185K|  1185K| 1298K (0)|
|* 73 |         TABLE ACCESS FULL                      | TARIFF_SERVICE                 |      1 |    100 |  2900 |       |   103   (1)| 00:00:01 |       |       |     96 |00:00:00.01 |     374 |       |       |          |
|* 74 |         HASH JOIN                              |                                |      1 |    221K|    27M|       | 22189   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       7 |  1196K|  1196K| 1632K (0)|
|* 75 |          TABLE ACCESS BY INDEX ROWID BATCHED   | MP_POLICY_HISTORY              |      1 |    210 |  4200 |       |     3   (0)| 00:00:01 |       |       |    214 |00:00:00.01 |       7 |       |       |          |
|* 76 |           INDEX SKIP SCAN                      | MP_POLHIST$BCT#BRANCH#ETIME$I  |      1 |    210 |       |       |     1   (0)| 00:00:01 |       |       |    214 |00:00:00.01 |       1 |       |       |          |
|* 77 |          HASH JOIN                             |                                |      1 |    206K|    21M|    21M| 22185   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |   838K|   838K| 1038K (0)|
|* 78 |           HASH JOIN                            |                                |      1 |    206K|    18M|    11M| 17350   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |   916K|   916K| 1088K (0)|
|* 79 |            HASH JOIN                           |                                |      1 |    166K|    10M|    10M|  9035   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |   955K|   955K| 1088K (0)|
|* 80 |             HASH JOIN                          |                                |      1 |    166K|  8798K|       |  5256   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |  1142K|  1142K|  191K (0)|
|* 81 |              VIEW                              |                                |      1 |    133 |  3990 |       |     2   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  82 |               TABLE ACCESS FULL                | SYS_TEMP_0FD9D6614_779F94E1    |      1 |    133 |  3458 |       |     2   (0)| 00:00:01 |       |       |    149 |00:00:00.01 |       0 |       |       |          |
|* 83 |              TABLE ACCESS FULL                 | CLIENT_HISTORY                 |      0 |    166K|  3910K|       |  5253   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  84 |             TABLE ACCESS FULL                  | CLIENT                         |      0 |   1305K|    11M|       |  1954   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 85 |            TABLE ACCESS FULL                   | SUBS_HISTORY                   |      0 |   1443K|    44M|       |  4712   (1)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 86 |           TABLE ACCESS FULL                    | SUBSCRIBER                     |      0 |   1421K|    18M|       |  2035   (2)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  87 |        PARTITION RANGE ITERATOR                |                                |      0 |     13M|   327M|       |   116K  (1)| 00:00:05 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 88 |         TABLE ACCESS FULL                      | SUBS_SERV_HISTORY              |      0 |     13M|   327M|       |   116K  (1)| 00:00:05 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|  89 |      PARTITION RANGE ITERATOR                  |                                |      0 |      1 |    28 |       |     3   (0)| 00:00:01 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 90 |       TABLE ACCESS BY LOCAL INDEX ROWID BATCHED| SUBS_SERV_HISTORY              |      0 |      1 |    28 |       |     3   (0)| 00:00:01 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 91 |        INDEX SKIP SCAN                         | SUBS_SERV_HISTORY$SUBS#SERV#ET |      0 |      1 |       |       |     3   (0)| 00:00:01 |   KEY |    19 |      0 |00:00:00.01 |       0 |       |       |          |
|* 92 |      COLLECTION ITERATOR CONSTRUCTOR FETCH     |                                |      0 |     82 |   164 |       |    29   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 93 |      COLLECTION ITERATOR CONSTRUCTOR FETCH     |                                |      0 |     82 |   164 |       |    29   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|  94 |      SORT AGGREGATE                            |                                |      0 |      1 |    16 |       |            |          |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 95 |       TABLE ACCESS BY INDEX ROWID BATCHED      | CLIENT_HISTORY                 |      0 |      1 |    16 |       |     1   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
|* 96 |        INDEX RANGE SCAN                        | CLIENT_HIST$CLNT_ID#ETIME$IDX  |      0 |      1 |       |       |     1   (0)| 00:00:01 |       |       |      0 |00:00:00.01 |       0 |       |       |          |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$61E1728E  
   2 - SEL$17        
   3 - SEL$C3262EAB  
  10 - SEL$C3262EAB   / MA@SEL$1
  11 - SEL$C3262EAB   / MA@SEL$1
  12 - SEL$C3262EAB   / STAT@SEL$1
  13 - SEL$C3262EAB   / STAT@SEL$1
  14 - SEL$C3262EAB   / VARHST@SEL$3
  15 - SEL$C3262EAB   / VARHST@SEL$3
  16 - SEL$C3262EAB   / VALHST@SEL$4
  17 - SEL$C3262EAB   / VALHST@SEL$4
  18 - SEL$C3262EAB   / STATG@SEL$2
  19 - SEL$C3262EAB   / STATG@SEL$2
  20 - SEL$B5A111CF  
  27 - SEL$B5A111CF   / MA@SEL$5
  28 - SEL$B5A111CF   / MA@SEL$5
  29 - SEL$B5A111CF   / STAT@SEL$5
  30 - SEL$B5A111CF   / STAT@SEL$5
  31 - SEL$B5A111CF   / VARHST@SEL$7
  32 - SEL$B5A111CF   / VARHST@SEL$7
  33 - SEL$B5A111CF   / VALHST@SEL$8
  34 - SEL$B5A111CF   / VALHST@SEL$8
  35 - SEL$B5A111CF   / STATG@SEL$6
  36 - SEL$B5A111CF   / STATG@SEL$6
  38 - SEL$17         / MPH@SEL$17
  39 - SEL$17         / MPH@SEL$17
  44 - SEL$61E1728E_1 / ID@SEL$16
  47 - SEL$61E1728E_1 / TS@SEL$14
  49 - SEL$61E1728E_1 / MPH@SEL$13
  50 - SEL$61E1728E_1 / MPH@SEL$13
  53 - SEL$61E1728E_1 / SBH@SEL$11
  54 - SEL$61E1728E_1 / SBH@SEL$11
  57 - SEL$13983ABD   / CR@SEL$9
  58 - SEL$13983ABD   / T1@SEL$13983ABD
  59 - SEL$61E1728E_1 / CH@SEL$9
  60 - SEL$61E1728E_1 / CLNT@SEL$10
  61 - SEL$61E1728E_1 / SUB@SEL$12
  63 - SEL$61E1728E_1 / SSH@SEL$15
  64 - SEL$24        
  65 - SEL$24         / SSH@SEL$24
  66 - SEL$24         / SSH@SEL$24
  67 - SEL$95423B40   / KOKBF$1@SEL$26
  70 - SEL$61E1728E_2 / ID@SEL$61E1728E_2
  73 - SEL$61E1728E_2 / TS@SEL$61E1728E_2
  75 - SEL$61E1728E_2 / MPH@SEL$61E1728E_2
  76 - SEL$61E1728E_2 / MPH@SEL$61E1728E_2
  81 - SEL$13983ABD   / CR@SEL$61E1728E_2
  82 - SEL$13983ABD   / T1@SEL$13983ABD
  83 - SEL$61E1728E_2 / CH@SEL$61E1728E_2
  84 - SEL$61E1728E_2 / CLNT@SEL$61E1728E_2
  85 - SEL$61E1728E_2 / SBH@SEL$61E1728E_2
  86 - SEL$61E1728E_2 / SUB@SEL$61E1728E_2
  88 - SEL$61E1728E_2 / SSH@SEL$61E1728E_2
  89 - SEL$24        
  90 - SEL$24         / SSH@SEL$24
  91 - SEL$24         / SSH@SEL$24
  92 - SEL$95423B40   / KOKBF$1@SEL$26
  93 - SEL$109DB78D   / KOKBF$0@SEL$22
  94 - SEL$23        
  95 - SEL$23         / CLH@SEL$23
  96 - SEL$23         / CLH@SEL$23
 
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
      OUTLINE_LEAF(@"SEL$C3262EAB")
      MERGE(@"SEL$EE94F965" >"SEL$18")
      OUTLINE_LEAF(@"SEL$B5A111CF")
      MERGE(@"SEL$B3FD8164" >"SEL$19")
      OUTLINE_LEAF(@"SEL$17")
      OUTLINE_LEAF(@"SEL$109DB78D")
      MERGE(@"SEL$22" >"SEL$21")
      OUTLINE_LEAF(@"SEL$23")
      OUTLINE_LEAF(@"SEL$24")
      OUTLINE_LEAF(@"SEL$95423B40")
      MERGE(@"SEL$26" >"SEL$25")
      OUTLINE_LEAF(@"SEL$13983ABD")
      MATERIALIZE(@"SEL$17")
      OUTLINE_LEAF(@"SEL$61E1728E")
      MERGE(@"SEL$DF9A0365" >"SEL$20")
      OUTLINE_LEAF(@"SEL$61E1728E_1")
      USE_CONCAT(@"SEL$61E1728E" 8 OR_PREDICATES(1) PREDICATE_REORDERS((13 3) (14 4) (3 5) (4 6) (5 7) (6 8) (7 9) (8 10) (9 11) (10 12) (11 13) (12 14) (35 17) (17 18) (18 19) (19 20) (20 21) (21 22) (22 23) (23 24) 
              (24 25) (25 26) (26 27) (27 28) (28 29) (29 30) (30 31) (31 32) (32 33) (33 34) (34 35) (41 39) (42 40) (45 41) (48 42) (49 43) (52 44) (53 45) (39 46) (40 47) (43 48) (44 49) (46 50) (47 51) (50 52) (51 53) (125 
              122) (122 123) (123 125)))
      OUTLINE_LEAF(@"SEL$61E1728E_2")
      OUTLINE(@"SEL$18")
      OUTLINE(@"SEL$EE94F965")
      MERGE(@"SEL$9E43CB6E" >"SEL$4")
      OUTLINE(@"SEL$19")
      OUTLINE(@"SEL$B3FD8164")
      MERGE(@"SEL$BF82FE11" >"SEL$8")
      OUTLINE(@"SEL$21")
      OUTLINE(@"SEL$22")
      OUTLINE(@"SEL$25")
      OUTLINE(@"SEL$26")
      OUTLINE(@"SEL$20")
      OUTLINE(@"SEL$DF9A0365")
      MERGE(@"SEL$1CC80154" >"SEL$16")
      OUTLINE(@"SEL$4")
      OUTLINE(@"SEL$9E43CB6E")
      MERGE(@"SEL$58A6D7F6" >"SEL$3")
      OUTLINE(@"SEL$8")
      OUTLINE(@"SEL$BF82FE11")
      MERGE(@"SEL$6BD737F4" >"SEL$7")
      OUTLINE(@"SEL$16")
      OUTLINE(@"SEL$1CC80154")
      MERGE(@"SEL$1FF13C10" >"SEL$15")
      OUTLINE(@"SEL$3")
      OUTLINE(@"SEL$58A6D7F6")
      MERGE(@"SEL$1" >"SEL$2")
      OUTLINE(@"SEL$7")
      OUTLINE(@"SEL$6BD737F4")
      MERGE(@"SEL$5" >"SEL$6")
      OUTLINE(@"SEL$15")
      OUTLINE(@"SEL$1FF13C10")
      MERGE(@"SEL$31CE6305" >"SEL$14")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$1")
      OUTLINE(@"SEL$6")
      OUTLINE(@"SEL$5")
      OUTLINE(@"SEL$14")
      OUTLINE(@"SEL$31CE6305")
      MERGE(@"SEL$AF0AFD29" >"SEL$13")
      OUTLINE(@"SEL$13")
      OUTLINE(@"SEL$AF0AFD29")
      MERGE(@"SEL$425429CA" >"SEL$12")
      OUTLINE(@"SEL$12")
      OUTLINE(@"SEL$425429CA")
      MERGE(@"SEL$EA19AA3F" >"SEL$11")
      OUTLINE(@"SEL$11")
      OUTLINE(@"SEL$EA19AA3F")
      MERGE(@"SEL$9" >"SEL$10")
      OUTLINE(@"SEL$10")
      OUTLINE(@"SEL$9")
      NO_ACCESS(@"SEL$61E1728E_1" "CR"@"SEL$9")
      FULL(@"SEL$61E1728E_1" "CH"@"SEL$9")
      FULL(@"SEL$61E1728E_1" "CLNT"@"SEL$10")
      INDEX_SS(@"SEL$61E1728E_1" "SBH"@"SEL$11" ("SUBS_HISTORY"."SUBS_ID" "SUBS_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$61E1728E_1" "SBH"@"SEL$11")
      FULL(@"SEL$61E1728E_1" "SUB"@"SEL$12")
      INDEX_SS(@"SEL$61E1728E_1" "MPH"@"SEL$13" ("MP_POLICY_HISTORY"."BRANCH_CHK_TYPE" "MP_POLICY_HISTORY"."BRANCH_ID" "MP_POLICY_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$61E1728E_1" "MPH"@"SEL$13")
      FULL(@"SEL$61E1728E_1" "TS"@"SEL$14")
      FULL(@"SEL$61E1728E_1" "SSH"@"SEL$15")
      FULL(@"SEL$61E1728E_1" "ID"@"SEL$16")
      NO_ACCESS(@"SEL$61E1728E_2" "CR"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "CH"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "CLNT"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "SBH"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "SUB"@"SEL$61E1728E_2")
      INDEX_SS(@"SEL$61E1728E_2" "MPH"@"SEL$61E1728E_2" ("MP_POLICY_HISTORY"."BRANCH_CHK_TYPE" "MP_POLICY_HISTORY"."BRANCH_ID" "MP_POLICY_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$61E1728E_2" "MPH"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "TS"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "SSH"@"SEL$61E1728E_2")
      FULL(@"SEL$61E1728E_2" "ID"@"SEL$61E1728E_2")
      LEADING(@"SEL$61E1728E_1" "CR"@"SEL$9" "CH"@"SEL$9" "CLNT"@"SEL$10" "SBH"@"SEL$11" "SUB"@"SEL$12" "MPH"@"SEL$13" "TS"@"SEL$14" "SSH"@"SEL$15" "ID"@"SEL$16")
      LEADING(@"SEL$61E1728E_2" "CR"@"SEL$61E1728E_2" "CH"@"SEL$61E1728E_2" "CLNT"@"SEL$61E1728E_2" "SBH"@"SEL$61E1728E_2" "SUB"@"SEL$61E1728E_2" "MPH"@"SEL$61E1728E_2" "TS"@"SEL$61E1728E_2" "SSH"@"SEL$61E1728E_2" 
              "ID"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_1" "CH"@"SEL$9")
      USE_HASH(@"SEL$61E1728E_1" "CLNT"@"SEL$10")
      USE_HASH(@"SEL$61E1728E_1" "SBH"@"SEL$11")
      USE_HASH(@"SEL$61E1728E_1" "SUB"@"SEL$12")
      USE_HASH(@"SEL$61E1728E_1" "MPH"@"SEL$13")
      USE_HASH(@"SEL$61E1728E_1" "TS"@"SEL$14")
      USE_HASH(@"SEL$61E1728E_1" "SSH"@"SEL$15")
      USE_HASH(@"SEL$61E1728E_1" "ID"@"SEL$16")
      USE_HASH(@"SEL$61E1728E_2" "CH"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "CLNT"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "SBH"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "SUB"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "MPH"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "TS"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "SSH"@"SEL$61E1728E_2")
      USE_HASH(@"SEL$61E1728E_2" "ID"@"SEL$61E1728E_2")
      PX_JOIN_FILTER(@"SEL$61E1728E_1" "CLNT"@"SEL$10")
      PX_JOIN_FILTER(@"SEL$61E1728E_1" "SBH"@"SEL$11")
      PX_JOIN_FILTER(@"SEL$61E1728E_1" "SUB"@"SEL$12")
      PX_JOIN_FILTER(@"SEL$61E1728E_1" "MPH"@"SEL$13")
      PX_JOIN_FILTER(@"SEL$61E1728E_1" "SSH"@"SEL$15")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_1" "SBH"@"SEL$11")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_1" "MPH"@"SEL$13")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_1" "TS"@"SEL$14")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_1" "ID"@"SEL$16")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_2" "MPH"@"SEL$61E1728E_2")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_2" "TS"@"SEL$61E1728E_2")
      SWAP_JOIN_INPUTS(@"SEL$61E1728E_2" "ID"@"SEL$61E1728E_2")
      USE_HASH_AGGREGATION(@"SEL$61E1728E")
      ORDER_SUBQ(@"SEL$61E1728E" "SEL$24" "SEL$95423B40" "SEL$109DB78D" "SEL$23")
      PQ_FILTER(@"SEL$61E1728E" SERIAL)
      FULL(@"SEL$13983ABD" "T1"@"SEL$13983ABD")
      FULL(@"SEL$95423B40" "KOKBF$1"@"SEL$26")
      INDEX_SS(@"SEL$24" "SSH"@"SEL$24" ("SUBS_SERV_HISTORY"."SUBS_ID" "SUBS_SERV_HISTORY"."SERV_ID" "SUBS_SERV_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$24" "SSH"@"SEL$24")
      INDEX_RS_ASC(@"SEL$23" "CLH"@"SEL$23" ("CLIENT_HISTORY"."CLNT_ID" "CLIENT_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$23" "CLH"@"SEL$23")
      FULL(@"SEL$109DB78D" "KOKBF$0"@"SEL$22")
      INDEX_SS(@"SEL$17" "MPH"@"SEL$17" ("MP_POLICY_HISTORY"."BRANCH_CHK_TYPE" "MP_POLICY_HISTORY"."BRANCH_ID" "MP_POLICY_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$17" "MPH"@"SEL$17")
      USE_HASH_AGGREGATION(@"SEL$17")
      INDEX_RS_ASC(@"SEL$B5A111CF" "MA"@"SEL$5" ("MP_ACTION"."POLICY_ID"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$B5A111CF" "MA"@"SEL$5")
      INDEX(@"SEL$B5A111CF" "STAT"@"SEL$5" ("MP_STATEMENT_HISTORY"."ACTION_ID" "MP_STATEMENT_HISTORY"."ETIME"))
      INDEX_RS_ASC(@"SEL$B5A111CF" "VARHST"@"SEL$7" ("MP_VARIABLE_HISTORY"."VAR_TYPE_ID" "MP_VARIABLE_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$B5A111CF" "VARHST"@"SEL$7")
      INDEX_RS_ASC(@"SEL$B5A111CF" "VALHST"@"SEL$8" ("MP_VALUE_HISTORY"."VAL_ID" "MP_VALUE_HISTORY"."NUM_HISTORY"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$B5A111CF" "VALHST"@"SEL$8")
      INDEX(@"SEL$B5A111CF" "STATG"@"SEL$6" ("MP_STATEMENT"."PS_ID"))
      LEADING(@"SEL$B5A111CF" "MA"@"SEL$5" "STAT"@"SEL$5" "VARHST"@"SEL$7" "VALHST"@"SEL$8" "STATG"@"SEL$6")
      USE_NL(@"SEL$B5A111CF" "STAT"@"SEL$5")
      NLJ_BATCHING(@"SEL$B5A111CF" "STAT"@"SEL$5")
      USE_HASH(@"SEL$B5A111CF" "VARHST"@"SEL$7")
      USE_NL(@"SEL$B5A111CF" "VALHST"@"SEL$8")
      USE_NL(@"SEL$B5A111CF" "STATG"@"SEL$6")
      NLJ_BATCHING(@"SEL$B5A111CF" "STATG"@"SEL$6")
      INDEX_RS_ASC(@"SEL$C3262EAB" "MA"@"SEL$1" ("MP_ACTION"."POLICY_ID"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$C3262EAB" "MA"@"SEL$1")
      INDEX(@"SEL$C3262EAB" "STAT"@"SEL$1" ("MP_STATEMENT_HISTORY"."ACTION_ID" "MP_STATEMENT_HISTORY"."ETIME"))
      INDEX_RS_ASC(@"SEL$C3262EAB" "VARHST"@"SEL$3" ("MP_VARIABLE_HISTORY"."VAR_TYPE_ID" "MP_VARIABLE_HISTORY"."ETIME"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$C3262EAB" "VARHST"@"SEL$3")
      INDEX_RS_ASC(@"SEL$C3262EAB" "VALHST"@"SEL$4" ("MP_VALUE_HISTORY"."VAL_ID" "MP_VALUE_HISTORY"."NUM_HISTORY"))
      BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$C3262EAB" "VALHST"@"SEL$4")
      INDEX(@"SEL$C3262EAB" "STATG"@"SEL$2" ("MP_STATEMENT"."PS_ID"))
      LEADING(@"SEL$C3262EAB" "MA"@"SEL$1" "STAT"@"SEL$1" "VARHST"@"SEL$3" "VALHST"@"SEL$4" "STATG"@"SEL$2")
      USE_NL(@"SEL$C3262EAB" "STAT"@"SEL$1")
      NLJ_BATCHING(@"SEL$C3262EAB" "STAT"@"SEL$1")
      USE_HASH(@"SEL$C3262EAB" "VARHST"@"SEL$3")
      USE_NL(@"SEL$C3262EAB" "VALHST"@"SEL$4")
      USE_NL(@"SEL$C3262EAB" "STATG"@"SEL$2")
      NLJ_BATCHING(@"SEL$C3262EAB" "STATG"@"SEL$2")
      END_OUTLINE_DATA
  */
 
Peeked Binds (identified by position):
--------------------------------------
 
  11 - (VARCHAR2(30), CSID=171): (null)
  12 - (VARCHAR2(30), CSID=171): (null)
  16 - (VARCHAR2(30), CSID=171): (null)
  17 - (VARCHAR2(30), CSID=171): (null)
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   7 - access("STAT"."VARIABLE_ID"="VARHST"."VARIABLE_ID")
  10 - filter("MA"."DEL_DATE" IS NULL)
  11 - access("MA"."POLICY_ID"=:B1)
  12 - access("MA"."ACTION_ID"="STAT"."ACTION_ID" AND "STAT"."ETIME">SYSDATE@!)
       filter("STAT"."ACTION_ID" IS NOT NULL)
  13 - filter("STAT"."STIME"<=SYSDATE@!)
  14 - filter(("VARHST"."TPD_CODE"='AP_INTERVAL' AND "VARHST"."STIME"<=SYSDATE@!))
  15 - access("VARHST"."VAR_TYPE_ID"=12 AND "VARHST"."ETIME">SYSDATE@!)
  16 - filter(("VALHST"."ETIME">SYSDATE@! AND "VALHST"."STIME"<=SYSDATE@!))
  17 - access("STAT"."VALUE_ID"="VALHST"."VAL_ID")
  18 - access("STAT"."PS_ID"="STATG"."PS_ID")
  19 - filter("STATG"."DEL_DATE" IS NULL)
  24 - access("STAT"."VARIABLE_ID"="VARHST"."VARIABLE_ID")
  27 - filter("MA"."DEL_DATE" IS NULL)
  28 - access("MA"."POLICY_ID"=:B1)
  29 - access("MA"."ACTION_ID"="STAT"."ACTION_ID" AND "STAT"."ETIME">SYSDATE@!)
       filter("STAT"."ACTION_ID" IS NOT NULL)
  30 - filter("STAT"."STIME"<=SYSDATE@!)
  31 - filter(("VARHST"."TPD_CODE"='SERV_MARKER_ID' AND "VARHST"."STIME"<=SYSDATE@!))
  32 - access("VARHST"."VAR_TYPE_ID"=12 AND "VARHST"."ETIME">SYSDATE@!)
  33 - filter(("VALHST"."ETIME">SYSDATE@! AND "VALHST"."STIME"<=SYSDATE@!))
  34 - access("STAT"."VALUE_ID"="VALHST"."VAL_ID")
  35 - access("STAT"."PS_ID"="STATG"."PS_ID")
  36 - filter("STATG"."DEL_DATE" IS NULL)
  38 - filter(("MPH"."POLICY_LEVEL"=1 AND "MPH"."SMST_ID"=1 AND "MPH"."STIME"<=SYSDATE@!))
  39 - access("MPH"."ETIME">SYSDATE@!)
       filter("MPH"."ETIME">SYSDATE@!)
  42 - filter(( IS NULL AND ((:B4 IS NULL AND TO_NUMBER(:B5)=0) OR (:B4 IS NULL AND TO_NUMBER(:B5)=1 AND INTERNAL_FUNCTION("ID"."INT_TYPE_ID")) OR (:B4 IS NULL AND "ID"."INT_TYPE_ID"<>TO_NUMBER(:B11) AND 
              "ID"."INT_TYPE_ID"<>TO_NUMBER(:B10) AND TO_NUMBER(:B5)=2) OR (:B4 IS NOT NULL AND  IS NOT NULL))))
  43 - access("ID"."INT_DICT_ID"="CR"."INT_ID")
  45 - access("SSH"."SUBS_ID"="SBH"."SUBS_ID" AND "SSH"."SERV_ID"="TS"."SERV_ID")
  46 - access("TS"."TRPL_ID"="SBH"."TRPL_ID")
  47 - filter(("TS"."ETIME">SYSDATE@! AND "TS"."TSST_ID"=1 AND "TS"."STIME"<=SYSDATE@!))
  48 - access("MPH"."POLICY_ID"="CR"."POLICY_ID")
  49 - filter("MPH"."STIME"<=SYSDATE@!)
  50 - access("MPH"."ETIME">SYSDATE@!)
       filter("MPH"."ETIME">SYSDATE@!)
  51 - access("SUB"."SUBS_ID"="SBH"."SUBS_ID")
  52 - access("SBH"."CLNT_ID"="CH"."CLNT_ID")
  53 - filter("SBH"."STIME"<=SYSDATE@!)
  54 - access("SBH"."ETIME">SYSDATE@!)
       filter((MOD("SBH"."SUBS_ID",TO_NUMBER(:B2))=TO_NUMBER(:B3)-1 AND "SBH"."ETIME">SYSDATE@!))
  55 - access("CLNT"."CLNT_ID"="CH"."CLNT_ID")
  56 - access("CH"."POLICY_ID"="CR"."POLICY_ID")
  59 - filter("CH"."POLICY_ID" IS NOT NULL)
  63 - filter(("SSH"."ETIME">SYSDATE@! AND "SSH"."STIME"<=SYSDATE@!))
  65 - filter((INTERNAL_FUNCTION("SSH"."SSTAT_ID") AND "SSH"."STIME"<=SYSDATE@!))
  66 - access("SSH"."SUBS_ID"=:B1 AND "SSH"."SERV_ID"=:B2 AND "SSH"."ETIME">SYSDATE@! AND "SSH"."ETIME" IS NOT NULL)
  67 - filter(VALUE(KOKBF$)=:B1)
  68 - filter(((LNNVL( IS NULL) OR LNNVL(MOD("SBH"."SUBS_ID",TO_NUMBER(:B2))=TO_NUMBER(:B3)-1) OR ((LNNVL( IS NOT NULL) OR LNNVL(:B4 IS NOT NULL)) AND (LNNVL(:B4 IS NULL) OR LNNVL(TO_NUMBER(:B5)=0)) AND (LNNVL(:B4 
              IS NULL) OR LNNVL(TO_NUMBER(:B5)=1) OR (LNNVL("ID"."INT_TYPE_ID"=TO_NUMBER(:B8)) AND LNNVL("ID"."INT_TYPE_ID"=TO_NUMBER(:B7)))) AND (LNNVL(:B4 IS NULL) OR LNNVL(TO_NUMBER(:B5)=2) OR 
              LNNVL("ID"."INT_TYPE_ID"<>TO_NUMBER(:B11)) OR LNNVL("ID"."INT_TYPE_ID"<>TO_NUMBER(:B10))))) AND (:B1 IS NULL OR (:B1 IS NOT NULL AND  IS NULL)) AND 
              "GP"."GET_END_DATE"(,"ID"."INT_TYPE_ID","ID"."QUANTITY",1,"SBH"."TRPL_ID","ID"."PRECISION")>SYSDATE@!))
  69 - access("ID"."INT_DICT_ID"="CR"."INT_ID")
  71 - access("SSH"."SUBS_ID"="SBH"."SUBS_ID" AND "SSH"."SERV_ID"="TS"."SERV_ID")
  72 - access("TS"."TRPL_ID"="SBH"."TRPL_ID")
  73 - filter(("TS"."CHARGE_GROUP"=2 AND "TS"."ETIME">SYSDATE@! AND "TS"."TSST_ID"=1 AND "TS"."STIME"<=SYSDATE@!))
  74 - access("MPH"."POLICY_ID"="CR"."POLICY_ID")
  75 - filter("MPH"."STIME"<=SYSDATE@!)
  76 - access("MPH"."ETIME">SYSDATE@!)
       filter("MPH"."ETIME">SYSDATE@!)
  77 - access("SUB"."SUBS_ID"="SBH"."SUBS_ID")
  78 - access("SBH"."CLNT_ID"="CH"."CLNT_ID")
  79 - access("CLNT"."CLNT_ID"="CH"."CLNT_ID")
  80 - access("CH"."POLICY_ID"="CR"."POLICY_ID")
  81 - filter("CR"."SERV_MARKER_ID" IS NULL)
  83 - filter(("CH"."POLICY_ID" IS NOT NULL AND "CH"."ETIME">SYSDATE@! AND "CH"."POLICY_ID">0 AND "CH"."STIME"<=SYSDATE@!))
  85 - filter(("SBH"."ETIME">SYSDATE@! AND "SBH"."STIME"<=SYSDATE@!))
  86 - filter("SUB"."ACTIVATION_DATE"<=SYSDATE@!)
  88 - filter(("SSH"."ETIME">SYSDATE@! AND "SSH"."STIME"<=SYSDATE@!))
  90 - filter((INTERNAL_FUNCTION("SSH"."SSTAT_ID") AND "SSH"."STIME"<=SYSDATE@!))
  91 - access("SSH"."SUBS_ID"=:B1 AND "SSH"."SERV_ID"=:B2 AND "SSH"."ETIME">SYSDATE@! AND "SSH"."ETIME" IS NOT NULL)
  92 - filter(VALUE(KOKBF$)=:B1)
  93 - filter(VALUE(KOKBF$)=:B1)
  95 - filter(NVL("CLH"."POLICY_ID",0)<>:B1)
  96 - access("CLH"."CLNT_ID"=:B1)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "SBH"."SUBS_ID"[NUMBER,22]
   2 - SYSDEF[4], SYSDEF[0], SYSDEF[1], SYSDEF[120], SYSDEF[0]
   3 - (#keys=0) MAX("VALHST"."VALUE")[255]
   4 - "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], 
       "VALHST"."ETIME"[DATE,7], "STATG".ROWID[ROWID,10], "STATG"."PS_ID"[NUMBER,22], "STATG"."DEL_DATE"[DATE,7]
   5 - "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], 
       "VALHST"."ETIME"[DATE,7], "STATG".ROWID[ROWID,10], "STATG"."PS_ID"[NUMBER,22]
   6 - "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], 
       "VALHST"."ETIME"[DATE,7]
   7 - (#keys=1) "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7]
   8 - "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], 
       "STAT"."VARIABLE_ID"[NUMBER,22], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "STAT"."ETIME"[DATE,7]
   9 - "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7]
  10 - "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7]
  11 - "MA".ROWID[ROWID,10], "MA"."POLICY_ID"[NUMBER,22]
  12 - "STAT".ROWID[ROWID,10], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7]
  13 - "STAT".ROWID[ROWID,10], "STAT"."PS_ID"[NUMBER,22], "STAT"."VARIABLE_ID"[NUMBER,22], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7]
  14 - "VARHST".ROWID[ROWID,10], "VARHST"."VARIABLE_ID"[NUMBER,22], "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VARHST"."TPD_CODE"[VARCHAR2,30]
  15 - "VARHST".ROWID[ROWID,10], "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."ETIME"[DATE,7]
  16 - "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], "VALHST"."ETIME"[DATE,7]
  17 - "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22]
  18 - "STATG".ROWID[ROWID,10], "STATG"."PS_ID"[NUMBER,22]
  19 - "STATG".ROWID[ROWID,10], "STATG"."DEL_DATE"[DATE,7]
  20 - (#keys=0) MAX("VALHST"."VALUE")[255]
  21 - "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], 
       "VALHST"."ETIME"[DATE,7], "STATG".ROWID[ROWID,10], "STATG"."PS_ID"[NUMBER,22], "STATG"."DEL_DATE"[DATE,7]
  22 - "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], 
       "VALHST"."ETIME"[DATE,7], "STATG".ROWID[ROWID,10], "STATG"."PS_ID"[NUMBER,22]
  23 - "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], 
       "VALHST"."ETIME"[DATE,7]
  24 - (#keys=1) "STAT"."VARIABLE_ID"[NUMBER,22], "VARHST"."VARIABLE_ID"[NUMBER,22], "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], 
       "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "VARHST".ROWID[ROWID,10], "VARHST"."TPD_CODE"[VARCHAR2,30], 
       "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7]
  25 - "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], "STAT"."PS_ID"[NUMBER,22], "STAT"."ACTION_ID"[NUMBER,22], 
       "STAT"."VARIABLE_ID"[NUMBER,22], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7], "STAT"."ETIME"[DATE,7]
  26 - "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7], "STAT".ROWID[ROWID,10], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7]
  27 - "MA".ROWID[ROWID,10], "MA"."ACTION_ID"[NUMBER,22], "MA"."POLICY_ID"[NUMBER,22], "MA"."DEL_DATE"[DATE,7]
  28 - "MA".ROWID[ROWID,10], "MA"."POLICY_ID"[NUMBER,22]
  29 - "STAT".ROWID[ROWID,10], "STAT"."ACTION_ID"[NUMBER,22], "STAT"."ETIME"[DATE,7]
  30 - "STAT".ROWID[ROWID,10], "STAT"."PS_ID"[NUMBER,22], "STAT"."VARIABLE_ID"[NUMBER,22], "STAT"."VALUE_ID"[NUMBER,22], "STAT"."STIME"[DATE,7]
  31 - "VARHST".ROWID[ROWID,10], "VARHST"."VARIABLE_ID"[NUMBER,22], "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."STIME"[DATE,7], "VARHST"."ETIME"[DATE,7], "VARHST"."TPD_CODE"[VARCHAR2,30]
  32 - "VARHST".ROWID[ROWID,10], "VARHST"."VAR_TYPE_ID"[NUMBER,22], "VARHST"."ETIME"[DATE,7]
  33 - "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22], "VALHST"."VALUE"[VARCHAR2,255], "VALHST"."STIME"[DATE,7], "VALHST"."ETIME"[DATE,7]
  34 - "VALHST".ROWID[ROWID,10], "VALHST"."VAL_ID"[NUMBER,22]
  35 - "STATG".ROWID[ROWID,10], "STATG"."PS_ID"[NUMBER,22]
  36 - "STATG".ROWID[ROWID,10], "STATG"."DEL_DATE"[DATE,7]
  37 - "MPH"."POLICY_ID"[NUMBER,22]
  38 - "MPH".ROWID[ROWID,10], "MPH"."POLICY_ID"[NUMBER,22], "MPH"."SMST_ID"[NUMBER,22], "MPH"."STIME"[DATE,7], "MPH"."ETIME"[DATE,7], "MPH"."POLICY_LEVEL"[NUMBER,22]
  39 - "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7]
  40 - "SBH"."SUBS_ID"[NUMBER,22]
  41 - "ID"."INT_DICT_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "ID"."PRECISION"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "SBH"."SUBS_ID"[NUMBER,22], "SSH"."SUBS_ID"[NUMBER,22], 
       "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "TS"."STIME"[DATE,7], 
       "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SSH"."STIME"[DATE,7], 
       "SUB"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "CH"."ETIME"[DATE,7], "SBH"."STIME"[DATE,7], 
       "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "SSH"."ETIME"[DATE,7]
  42 - "ID"."INT_DICT_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "ID"."PRECISION"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "SBH"."SUBS_ID"[NUMBER,22], "SSH"."SUBS_ID"[NUMBER,22], 
       "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "TS"."STIME"[DATE,7], 
       "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SSH"."STIME"[DATE,7], 
       "SUB"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "CH"."ETIME"[DATE,7], "SBH"."STIME"[DATE,7], 
       "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "SSH"."ETIME"[DATE,7]
  43 - (#keys=1) "ID"."INT_DICT_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "ID"."PRECISION"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "SBH"."SUBS_ID"[NUMBER,22], 
       "SSH"."SUBS_ID"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], 
       "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], 
       "SSH"."STIME"[DATE,7], "SUB"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "CH"."ETIME"[DATE,7], 
       "SBH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "SSH"."ETIME"[DATE,7]
  44 - "ID"."INT_DICT_ID"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "ID"."PRECISION"[NUMBER,22]
  45 - (#keys=2) "SBH"."SUBS_ID"[NUMBER,22], "SSH"."SUBS_ID"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], 
       "TS"."CHARGE_GROUP"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], 
       "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "CR"."INT_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], 
       "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "CH"."ETIME"[DATE,7], "SBH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], 
       "SSH"."ETIME"[DATE,7], "SSH"."STIME"[DATE,7]
  46 - (#keys=1) "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], 
       "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SBH"."SUBS_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], 
       "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "CH"."ETIME"[DATE,7], "SBH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], 
       "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22]
  47 - "TS"."TRPL_ID"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22]
  48 - (#keys=1) "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SBH"."SUBS_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], 
       "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "SBH"."TRPL_ID"[NUMBER,22], "SBH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22], 
       "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7]
  49 - "MPH".ROWID[ROWID,10], "MPH"."POLICY_ID"[NUMBER,22], "MPH"."STIME"[DATE,7], "MPH"."ETIME"[DATE,7]
  50 - "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7]
  51 - (#keys=1) "SBH"."SUBS_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "CH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], 
       "SBH"."TRPL_ID"[NUMBER,22], "SBH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], 
       "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], "SUB"."ACTIVATION_DATE"[DATE,7]
  52 - (#keys=1) "SBH"."CLNT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH".ROWID[ROWID,10], "SBH"."SUBS_ID"[NUMBER,22], "SBH"."ETIME"[DATE,7], "SBH"."TRPL_ID"[NUMBER,22], "SBH"."STIME"[DATE,7], 
       "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], 
       "CH"."STIME"[DATE,7]
  53 - "SBH".ROWID[ROWID,10], "SBH"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "SBH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7]
  54 - "SBH".ROWID[ROWID,10], "SBH"."SUBS_ID"[NUMBER,22], "SBH"."ETIME"[DATE,7]
  55 - (#keys=1) "CH"."CLNT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], 
       "CH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22]
  56 - (#keys=1) "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "CH"."STIME"[DATE,7], "CH"."ETIME"[DATE,7]
  57 - (rowset=256) "CR"."POLICY_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22]
  58 - (rowset=256) "C0"[NUMBER,22], "C1"[NUMBER,22], "C2"[NUMBER,22]
  59 - "CH"."CLNT_ID"[NUMBER,22], "CH"."STIME"[DATE,7], "CH"."ETIME"[DATE,7], "CH"."POLICY_ID"[NUMBER,22]
  60 - "CLNT"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22]
  61 - "SUB"."SUBS_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7]
  62 - "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  63 - "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  64 - "SSH".ROWID[ROWID,10], "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."SSTAT_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  65 - "SSH".ROWID[ROWID,10], "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."SSTAT_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  66 - "SSH".ROWID[ROWID,10], "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."ETIME"[DATE,7]
  67 - VALUE(A0)[22]
  68 - "ID"."INT_DICT_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "ID"."PRECISION"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "SBH"."SUBS_ID"[NUMBER,22], "SSH"."SUBS_ID"[NUMBER,22], 
       "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "SBH"."STIME"[DATE,7], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], 
       "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "SUB"."SUBS_ID"[NUMBER,22], 
       "CH"."CLNT_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], 
       "SSH"."STIME"[DATE,7], "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SSH"."ETIME"[DATE,7]
  69 - (#keys=1) "ID"."INT_DICT_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "ID"."PRECISION"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "SBH"."SUBS_ID"[NUMBER,22], 
       "SSH"."SUBS_ID"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "SBH"."STIME"[DATE,7], 
       "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], 
       "SBH"."ETIME"[DATE,7], "SUB"."SUBS_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], 
       "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SSH"."ETIME"[DATE,7]
  70 - "ID"."INT_DICT_ID"[NUMBER,22], "ID"."INT_TYPE_ID"[NUMBER,22], "ID"."QUANTITY"[NUMBER,22], "ID"."PRECISION"[NUMBER,22]
  71 - (#keys=2) "SBH"."SUBS_ID"[NUMBER,22], "SSH"."SUBS_ID"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], 
       "TS"."CHARGE_GROUP"[NUMBER,22], "SBH"."STIME"[DATE,7], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], 
       "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "SUB"."SUBS_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], 
       "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SSH"."ETIME"[DATE,7], 
       "SSH"."STIME"[DATE,7]
  72 - (#keys=1) "TS"."TRPL_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], 
       "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SBH"."SUBS_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], 
       "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], 
       "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SBH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7]
  73 - "TS"."TRPL_ID"[NUMBER,22], "TS"."SERV_ID"[NUMBER,22], "TS"."STIME"[DATE,7], "TS"."ETIME"[DATE,7], "TS"."TSST_ID"[NUMBER,22], "TS"."CHARGE_GROUP"[NUMBER,22]
  74 - (#keys=1) "MPH"."POLICY_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7], "MPH"."STIME"[DATE,7], "SBH"."SUBS_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], 
       "CH"."CLNT_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], 
       "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SBH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], "SBH"."TRPL_ID"[NUMBER,22]
  75 - "MPH".ROWID[ROWID,10], "MPH"."POLICY_ID"[NUMBER,22], "MPH"."STIME"[DATE,7], "MPH"."ETIME"[DATE,7]
  76 - "MPH".ROWID[ROWID,10], "MPH"."ETIME"[DATE,7]
  77 - (#keys=1) "SBH"."SUBS_ID"[NUMBER,22], "SUB"."SUBS_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], 
       "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SBH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7], 
       "SBH"."TRPL_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7]
  78 - (#keys=1) "CH"."CLNT_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], 
       "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], "CH"."STIME"[DATE,7], "SBH".ROWID[ROWID,10], "SBH"."SUBS_ID"[NUMBER,22], "SBH"."ETIME"[DATE,7], "SBH"."TRPL_ID"[NUMBER,22], 
       "SBH"."STIME"[DATE,7]
  79 - (#keys=1) "CH"."CLNT_ID"[NUMBER,22], "CLNT"."CLNT_ID"[NUMBER,22], "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."ETIME"[DATE,7], 
       "CH"."STIME"[DATE,7], "CLNT"."CT_ID"[NUMBER,22]
  80 - (#keys=1) "CR"."POLICY_ID"[NUMBER,22], "CH"."POLICY_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CH"."CLNT_ID"[NUMBER,22], "CH"."STIME"[DATE,7], "CH"."ETIME"[DATE,7]
  81 - (rowset=256) "CR"."POLICY_ID"[NUMBER,22], "CR"."INT_ID"[NUMBER,22], "CR"."SERV_MARKER_ID"[NUMBER,22]
  82 - (rowset=256) "C0"[NUMBER,22], "C1"[NUMBER,22], "C2"[NUMBER,22]
  83 - "CH"."CLNT_ID"[NUMBER,22], "CH"."STIME"[DATE,7], "CH"."ETIME"[DATE,7], "CH"."POLICY_ID"[NUMBER,22]
  84 - "CLNT"."CLNT_ID"[NUMBER,22], "CLNT"."CT_ID"[NUMBER,22]
  85 - "SBH".ROWID[ROWID,10], "SBH"."SUBS_ID"[NUMBER,22], "SBH"."CLNT_ID"[NUMBER,22], "SBH"."TRPL_ID"[NUMBER,22], "SBH"."STIME"[DATE,7], "SBH"."ETIME"[DATE,7]
  86 - "SUB"."SUBS_ID"[NUMBER,22], "SUB"."ACTIVATION_DATE"[DATE,7]
  87 - "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  88 - "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  89 - "SSH".ROWID[ROWID,10], "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."SSTAT_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  90 - "SSH".ROWID[ROWID,10], "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."SSTAT_ID"[NUMBER,22], "SSH"."STIME"[DATE,7], "SSH"."ETIME"[DATE,7]
  91 - "SSH".ROWID[ROWID,10], "SSH"."SUBS_ID"[NUMBER,22], "SSH"."SERV_ID"[NUMBER,22], "SSH"."ETIME"[DATE,7]
  92 - VALUE(A0)[22]
  93 - VALUE(A0)[22]
  94 - (#keys=0) MAX("CLH"."ETIME")[7]
  95 - "CLH".ROWID[ROWID,10], "CLH"."CLNT_ID"[NUMBER,22], "CLH"."ETIME"[DATE,7], "CLH"."POLICY_ID"[NUMBER,22]
  96 - "CLH".ROWID[ROWID,10], "CLH"."CLNT_ID"[NUMBER,22], "CLH"."ETIME"[DATE,7]
 
Hint Report (identified by operation id / Query Block Name / Object Alias):
Total hints for statement: 3 (U - Unused (1))
---------------------------------------------------------------------------
 
   1 -  SEL$61E1728E
         U -  leading(cr) / hint overridden by another in parent query block
           -  ordered
 
   2 -  SEL$17
           -  materialize
 
Query Block Registry:
---------------------
 
  <q o="2"><n><![CDATA[SEL$7]]></n><f><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$7]]></s></h><h><t><![CDATA[from$_subquery$_014]]></t><s><![CDATA[SEL$7]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$1CC80154]]></n><p><![CDATA[SEL$15]]></p><i><o><t>VW</t><v><![CDATA[SEL$1FF13C10]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s><!
        [CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[TS]]></t><s><![CDATA[SEL$14]]></s></h><h><t><![CDATA[SSH]]></t><s><
        ![CDATA[SEL$15]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$61E1728E]]></n><p><![CDATA[SEL$20]]></p><i><o><t>VW</t><v><![CDATA[SEL$DF9A0365]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t
        ><s><![CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[TS]]></t><s><![CDATA[SEL$14]]></s></h><h><t><![CDATA[SSH]]></
        t><s><![CDATA[SEL$15]]></s></h><h><t><![CDATA[ID]]></t><s><![CDATA[SEL$16]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$12]]></n><f><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[from$_subquery$_026]]></t><s><![CDATA[SEL$12]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$DF9A0365]]></n><p><![CDATA[SEL$16]]></p><i><o><t>VW</t><v><![CDATA[SEL$1CC80154]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s><!
        [CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[TS]]></t><s><![CDATA[SEL$14]]></s></h><h><t><![CDATA[SSH]]></t><s><
        ![CDATA[SEL$15]]></s></h><h><t><![CDATA[ID]]></t><s><![CDATA[SEL$16]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="11" f="y"><n><![CDATA[SEL$61E1728E_2]]></n><p><![CDATA[SEL$61E1728E]]></p><i><o><t>BN</t><v><![CDATA[2]]></v></o></i><f><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[CLNT]]></t><
        s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[ID]]></t><s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$61E1728E_2]]></
        s></h><h><t><![CDATA[SBH]]></t><s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[SSH]]></t><s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$61E1728E_2]]></s></h><h><t><![CDATA[TS]]></
        t><s><![CDATA[SEL$61E1728E_2]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$11]]></n><f><h><t><![CDATA[SBH]]></t><s><![CDATA[SEL$11]]></s></h><h><t><![CDATA[from$_subquery$_024]]></t><s><![CDATA[SEL$11]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$16]]></n><f><h><t><![CDATA[ID]]></t><s><![CDATA[SEL$16]]></s></h><h><t><![CDATA[from$_subquery$_034]]></t><s><![CDATA[SEL$16]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$26]]></n><f><h><t><![CDATA[KOKBF$1]]></t><s><![CDATA[SEL$26]]></s></h></f></q>
  <q o="76" f="y" h="y"><n><![CDATA[SEL$13983ABD]]></n><p><![CDATA[SEL$17]]></p><f><h><t><![CDATA[T1]]></t><s><![CDATA[SEL$13983ABD]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$C3262EAB]]></n><p><![CDATA[SEL$18]]></p><i><o><t>VW</t><v><![CDATA[SEL$EE94F965]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[STAT]]></t><
        s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$2]]></s></h><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$3]]></s></h><h><t><![CDATA[VALHST]]></t><s><![CDATA[SEL$4]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$6]]></n><f><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$6]]></s></h><h><t><![CDATA[from$_subquery$_012]]></t><s><![CDATA[SEL$6]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$19]]></n><f><h><t><![CDATA[from$_subquery$_018]]></t><s><![CDATA[SEL$19]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$4]]></n><f><h><t><![CDATA[VALHST]]></t><s><![CDATA[SEL$4]]></s></h><h><t><![CDATA[from$_subquery$_007]]></t><s><![CDATA[SEL$4]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$31CE6305]]></n><p><![CDATA[SEL$13]]></p><i><o><t>VW</t><v><![CDATA[SEL$AF0AFD29]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s><!
        [CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![
        CDATA[SEL$9]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$95423B40]]></n><p><![CDATA[SEL$25]]></p><i><o><t>VW</t><v><![CDATA[SEL$26]]></v></o></i><f><h><t><![CDATA[KOKBF$1]]></t><s><![CDATA[SEL$26]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$425429CA]]></n><p><![CDATA[SEL$11]]></p><i><o><t>VW</t><v><![CDATA[SEL$EA19AA3F]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s><!
        [CDATA[SEL$11]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$109DB78D]]></n><p><![CDATA[SEL$21]]></p><i><o><t>VW</t><v><![CDATA[SEL$22]]></v></o></i><f><h><t><![CDATA[KOKBF$0]]></t><s><![CDATA[SEL$22]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$BF82FE11]]></n><p><![CDATA[SEL$7]]></p><i><o><t>VW</t><v><![CDATA[SEL$6BD737F4]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$5]]></s></h><h><t><![CDATA[STAT]]></t><s><![CD
        ATA[SEL$5]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$6]]></s></h><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$7]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$9E43CB6E]]></n><p><![CDATA[SEL$3]]></p><i><o><t>VW</t><v><![CDATA[SEL$58A6D7F6]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[STAT]]></t><s><![CD
        ATA[SEL$1]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$2]]></s></h><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$3]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$8]]></n><f><h><t><![CDATA[VALHST]]></t><s><![CDATA[SEL$8]]></s></h><h><t><![CDATA[from$_subquery$_016]]></t><s><![CDATA[SEL$8]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$6BD737F4]]></n><p><![CDATA[SEL$6]]></p><i><o><t>VW</t><v><![CDATA[SEL$5]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$5]]></s></h><h><t><![CDATA[STAT]]></t><s><![CDATA[SEL
        $5]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$6]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$25]]></n><f><h><t><![CDATA[SUB_ST]]></t><s><![CDATA[SEL$25]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$1]]></n><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[STAT]]></t><s><![CDATA[SEL$1]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$13]]></n><f><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[from$_subquery$_028]]></t><s><![CDATA[SEL$13]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$21]]></n><f><h><t><![CDATA[SUB_ST]]></t><s><![CDATA[SEL$21]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$B3FD8164]]></n><p><![CDATA[SEL$8]]></p><i><o><t>VW</t><v><![CDATA[SEL$BF82FE11]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$5]]></s></h><h><t><![CDATA[STAT]]></t><s><![CD
        ATA[SEL$5]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$6]]></s></h><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$7]]></s></h><h><t><![CDATA[VALHST]]></t><s><![CDATA[SEL$8]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$15]]></n><f><h><t><![CDATA[SSH]]></t><s><![CDATA[SEL$15]]></s></h><h><t><![CDATA[from$_subquery$_032]]></t><s><![CDATA[SEL$15]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$EA19AA3F]]></n><p><![CDATA[SEL$10]]></p><i><o><t>VW</t><v><![CDATA[SEL$9]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[S
        EL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$10]]></n><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[from$_subquery$_022]]></t><s><![CDATA[SEL$10]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$58A6D7F6]]></n><p><![CDATA[SEL$2]]></p><i><o><t>VW</t><v><![CDATA[SEL$1]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[STAT]]></t><s><![CDATA[SEL
        $1]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$2]]></n><f><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$2]]></s></h><h><t><![CDATA[from$_subquery$_003]]></t><s><![CDATA[SEL$2]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$1FF13C10]]></n><p><![CDATA[SEL$14]]></p><i><o><t>VW</t><v><![CDATA[SEL$31CE6305]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s><!
        [CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[TS]]></t><s><![CDATA[SEL$14]]></s></h><h><t><![CDATA[CH]]></t><s><!
        [CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="2" f="y"><n><![CDATA[SEL$23]]></n><f><h><t><![CDATA[CLH]]></t><s><![CDATA[SEL$23]]></s></h></f></q>
  <q o="11" f="y" h="y"><n><![CDATA[SEL$61E1728E_1]]></n><p><![CDATA[SEL$61E1728E]]></p><i><o><t>BN</t><v><![CDATA[1]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s
        ><![CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$13]]></s></h><h><t><![CDATA[TS]]></t><s><![CDATA[SEL$14]]></s></h><h><t><![CDATA[SSH]]></t><
        s><![CDATA[SEL$15]]></s></h><h><t><![CDATA[ID]]></t><s><![CDATA[SEL$16]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$5]]></n><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$5]]></s></h><h><t><![CDATA[STAT]]></t><s><![CDATA[SEL$5]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$3]]></n><f><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$3]]></s></h><h><t><![CDATA[from$_subquery$_005]]></t><s><![CDATA[SEL$3]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$AF0AFD29]]></n><p><![CDATA[SEL$12]]></p><i><o><t>VW</t><v><![CDATA[SEL$425429CA]]></v></o></i><f><h><t><![CDATA[CLNT]]></t><s><![CDATA[SEL$10]]></s></h><h><t><![CDATA[SBH]]></t><s><!
        [CDATA[SEL$11]]></s></h><h><t><![CDATA[SUB]]></t><s><![CDATA[SEL$12]]></s></h><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
  <q o="18" h="y"><n><![CDATA[SEL$EE94F965]]></n><p><![CDATA[SEL$4]]></p><i><o><t>VW</t><v><![CDATA[SEL$9E43CB6E]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$1]]></s></h><h><t><![CDATA[STAT]]></t><s><![CD
        ATA[SEL$1]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$2]]></s></h><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$3]]></s></h><h><t><![CDATA[VALHST]]></t><s><![CDATA[SEL$4]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$20]]></n><f><h><t><![CDATA[from$_subquery$_036]]></t><s><![CDATA[SEL$20]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$18]]></n><f><h><t><![CDATA[from$_subquery$_009]]></t><s><![CDATA[SEL$18]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$14]]></n><f><h><t><![CDATA[TS]]></t><s><![CDATA[SEL$14]]></s></h><h><t><![CDATA[from$_subquery$_030]]></t><s><![CDATA[SEL$14]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$22]]></n><f><h><t><![CDATA[KOKBF$0]]></t><s><![CDATA[SEL$22]]></s></h></f></q>
  <q o="18" f="y" h="y"><n><![CDATA[SEL$B5A111CF]]></n><p><![CDATA[SEL$19]]></p><i><o><t>VW</t><v><![CDATA[SEL$B3FD8164]]></v></o></i><f><h><t><![CDATA[MA]]></t><s><![CDATA[SEL$5]]></s></h><h><t><![CDATA[STAT]]></t><
        s><![CDATA[SEL$5]]></s></h><h><t><![CDATA[STATG]]></t><s><![CDATA[SEL$6]]></s></h><h><t><![CDATA[VARHST]]></t><s><![CDATA[SEL$7]]></s></h><h><t><![CDATA[VALHST]]></t><s><![CDATA[SEL$8]]></s></h></f></q>
  <q o="2" f="y"><n><![CDATA[SEL$24]]></n><f><h><t><![CDATA[SSH]]></t><s><![CDATA[SEL$24]]></s></h></f></q>
  <q o="2" f="y"><n><![CDATA[SEL$17]]></n><f><h><t><![CDATA[MPH]]></t><s><![CDATA[SEL$17]]></s></h></f></q>
  <q o="2"><n><![CDATA[SEL$9]]></n><f><h><t><![CDATA[CH]]></t><s><![CDATA[SEL$9]]></s></h><h><t><![CDATA[CR]]></t><s><![CDATA[SEL$9]]></s></h></f></q>
 
 
