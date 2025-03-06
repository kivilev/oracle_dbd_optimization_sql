
TKPROF: Release 12.2.0.1.0 - Development on Tue Apr 9 15:28:36 2024

Copyright (c) 1982, 2017, Oracle and/or its affiliates.  All rights reserved.

Trace file: TESTA1_ora_TRC_9.trc
Sort options: prsela  fchela  exeela  
********************************************************************************
count    = number of times OCI procedure was executed
cpu      = cpu time in seconds executing 
elapsed  = elapsed time in seconds executing
disk     = number of physical reads of buffers from disk
query    = number of buffers gotten for consistent read
current  = number of buffers gotten in current mode (usually for update)
rows     = number of rows processed by the fetch or execute call
********************************************************************************

SELECT --+choose
 1 AS N, OP.DEP_ID, OP.ID, OP.DVAL, D.CODE, OP.REFER FROM T_ORD O, G_ACCBLN A, T_BOP_STAT_STD S, T_PROCESS P, T_PROCMEM M, S_ORDDSC_STD D, S_ORDPAY OP WHERE OP.DEP_ID = M.DEP_ID AND OP.ID = M.ORD_ID AND M.MAINFL = '1' AND P.ID = M.ID AND S.ID = P.BOP_ID AND S.NORD = P.NSTAT AND OP.DEP_ID = O.DEP_ID AND OP.ID = O.ID AND D.ID = OP.KSO_ID AND OP.DEP_ID = A.DEP_ID AND OP.ACC_ID = A.ID AND S.CODE = 'CLIENTBANK' AND D.CODE = '221' AND OP.ALTERCODE = 'CBC' AND OP.DVAL >= P_OPERDAY - 5 UNION SELECT --+choose
 2 AS N, OP.DEP_ID, OP.ID, OP.DVAL, D.CODE, OP.REFER FROM T_ORD O, G_ACCBLN A, T_BOP_STAT_STD S, T_PROCESS P, T_PROCMEM M, S_ORDDSC_STD D, S_ORDPAY OP WHERE OP.DEP_ID = M.DEP_ID AND OP.ID = M.ORD_ID AND M.MAINFL = '1' AND P.ID = M.ID AND S.ID = P.BOP_ID AND S.NORD = P.NSTAT AND OP.DEP_ID = O.DEP_ID AND OP.ID = O.ID AND D.ID = OP.KSO_ID AND OP.DEP_ID = A.DEP_ID AND OP.ACC_ID = A.ID AND S.CODE = 'CLIENTBANK' AND D.CODE = '311' AND OP.ALTERCODE = 'CBC' AND SUBSTR(OP.CODE_OD,1,1) = '1' AND SUBSTR(OP.CODE_BE,1,1)='1' AND EXISTS (SELECT 1 FROM DUAL WHERE SUBSTR(C_PKGDEP.FIDDEP2CODEBNK(OP.DEP_ID), 1, 30) = 'QWERTY' AND OP.CODE_BCR = 'QWERTY') AND ((TO_NUMBER(TO_CHAR(SYSDATE, 'hh24')) < 22 AND OP.DVAL >= P_OPERDAY-5) OR (TO_NUMBER(TO_CHAR(SYSDATE, 'hh24')) > 22 AND OP.DVAL = P_OPERDAY)) UNION SELECT --+choose
 1 AS N, OP.DEP_ID, OP.ID, OP.DVAL, D.CODE, OP.REFER FROM T_ORD O, G_ACCBLN A, T_BOP_STAT_STD S, T_PROCESS P, T_PROCMEM M, T_ACC AA, S_ORDDSC_STD D, S_ORDPAY OP WHERE OP.DEP_ID = M.DEP_ID AND OP.ID = M.ORD_ID AND M.MAINFL = '1' AND P.ID = M.ID AND DECODE( G_PKGLOCK.FGETACCLOCKEXIST(A.DEP_ID, A.ID) + T_PKGLIM.FHOLDACC(A.DEP_ID, A.ID, P_OPERDAY, DECODE(AA.VALUTFL,1,AA.VAL_ID,P_NATVAL)), 0, 0, 1 ) = 0 AND A.ID=AA.ID AND A.DEP_ID=AA.DEP_ID AND S.ID = P.BOP_ID AND S.NORD = P.NSTAT AND OP.DEP_ID = O.DEP_ID AND OP.AMOUNT <= 500000 AND OP.VAL_ID = 1 AND OP.ID = O.ID AND D.ID = OP.KSO_ID AND OP.DEP_ID = A.DEP_ID AND OP.ACC_ID = A.ID AND S.CODE = 'CLIENTBANK' AND D.CODE = '311' AND OP.ALTERCODE = 'CBC' AND SUBSTR(OP.CODE_OD,1,1) = '1' AND EXISTS (SELECT 1 FROM DUAL WHERE SUBSTR(C_PKGDEP.FIDDEP2CODEBNK(OP.DEP_ID), 1, 30) = 'QWERTY' AND OP.CODE_BCR <> 'QWERTY') AND OP.DVAL >= P_OPERDAY - 5 UNION SELECT --+choose
 3 AS N, OP.DEP_ID, OP.ID, OP.DVAL, D.CODE, OP.REFER FROM T_ORD O, G_ACCBLN A, T_BOP_STAT_STD S, T_PROCESS P, T_PROCMEM M, S_ORDDSC_STD D, S_ORDPAY OP, C_USR U WHERE OP.DEP_ID = M.DEP_ID AND OP.ID = M.ORD_ID AND M.MAINFL = '1' AND P.ID = M.ID AND S.ID = P.BOP_ID AND S.NORD = P.NSTAT AND OP.DEP_ID = O.DEP_ID AND OP.ID = O.ID AND D.ID = OP.KSO_ID AND OP.DEP_ID = A.DEP_ID AND OP.ACC_ID = A.ID AND U.ID = O.ID_US AND S.CODE = 'CLIENTBANK' AND D.CODE = '221' AND OP.ALTERCODE = 'CBC' AND EXISTS (SELECT 1 FROM DUAL WHERE SUBSTR(C_PKGDEP.FIDDEP2CODEBNK(OP.DEP_ID), 1, 30) = 'QWERTY' AND OP.CODE_BCR = 'QWERTY') AND OP.RNN_CL=OP.RNN_CR AND OP.KNP='342' AND OP.CHA_ID=:B2 AND OP.DVAL >= :B1 - 5 

call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        1      0.02       0.02          0          0          0           0
Execute      1      0.54       0.54          0          0          0           0
Fetch        2   1198.39    2555.20    2817072   33422951          0           2
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total        4   1198.96    2555.77    2817072   33422951          0           2

Misses in library cache during parse: 1
Optimizer mode: CHOOSE
Parsing user id: 83     (recursive depth: 1)
Number of plan statistics captured: 1

Rows (1st) Rows (avg) Rows (max)  Row Source Operation
---------- ---------- ----------  ---------------------------------------------------
         2          2          2  SORT UNIQUE (cr=39123371 pr=2817369 pw=0 time=1328337739 us starts=1 cost=104371 size=400 card=5)
       129        129        129   UNION-ALL  (cr=39123371 pr=2817369 pw=0 time=123868144 us starts=1)
         1          1          1    NESTED LOOPS  (cr=33820 pr=0 pw=0 time=1021454 us starts=1 cost=19795 size=118 card=1)
         1          1          1     HASH JOIN  (cr=33817 pr=0 pw=0 time=1021407 us starts=1 cost=19794 size=108 card=1)
         1          1          1      TABLE ACCESS BY INDEX ROWID BATCHED T_BOP_STAT_STD (cr=3 pr=0 pw=0 time=77 us starts=1 cost=2 size=30 card=2)
         1          1          1       INDEX RANGE SCAN AK_T_BOP_STAT_STD_CODE (cr=2 pr=0 pw=0 time=55 us starts=1 cost=1 size=0 card=2)(object id 105281)
       153        153        153      NESTED LOOPS  (cr=33814 pr=0 pw=0 time=275318 us starts=1 cost=19792 size=274164 card=2948)
       153        153        153       NESTED LOOPS  (cr=33661 pr=0 pw=0 time=1585620 us starts=1 cost=19792 size=274164 card=2948)
       153        153        153        NESTED LOOPS  (cr=33215 pr=0 pw=0 time=1581166 us starts=1 cost=18318 size=232892 card=2948)
       153        153        153         HASH JOIN  (cr=32668 pr=0 pw=0 time=1567592 us starts=1 cost=16883 size=169271 card=2869)
         1          1          1          TABLE ACCESS BY INDEX ROWID S_ORDDSC_STD (cr=2 pr=0 pw=0 time=40 us starts=1 cost=1 size=9 card=1)
         1          1          1           INDEX UNIQUE SCAN AK_S_ORDDSC_STD_CODE (cr=1 pr=0 pw=0 time=20 us starts=1 cost=1 size=0 card=1)(object id 104953)
      9285       9285       9285          TABLE ACCESS BY INDEX ROWID BATCHED S_ORDPAY (cr=32666 pr=0 pw=0 time=817072 us starts=1 cost=16881 size=7315600 card=146312)
    354490     354490     354490           INDEX RANGE SCAN IE_S_ORDPAY_DVAL (cr=1441 pr=0 pw=0 time=162048 us starts=1 cost=636 size=0 card=320847)(object id 104973)
       153        153        153         TABLE ACCESS BY INDEX ROWID BATCHED T_PROCMEM (cr=547 pr=0 pw=0 time=6981 us starts=153 cost=1 size=20 card=1)
       153        153        153          INDEX RANGE SCAN FK_PROCMEM_ORDERS (cr=444 pr=0 pw=0 time=5053 us starts=153 cost=1 size=0 card=1)(object id 101222)
       153        153        153        INDEX UNIQUE SCAN PK_T_PROCESS (cr=446 pr=0 pw=0 time=2850 us starts=153 cost=1 size=0 card=1)(object id 105704)
       153        153        153       TABLE ACCESS BY INDEX ROWID T_PROCESS (cr=153 pr=0 pw=0 time=1373 us starts=153 cost=1 size=14 card=1)
         1          1          1     INDEX UNIQUE SCAN PK_G_ACCBLN (cr=3 pr=0 pw=0 time=36 us starts=1 cost=1 size=10 card=1)(object id 101187)
         5          5          5    NESTED LOOPS  (cr=43297 pr=0 pw=0 time=1130414 us starts=1 cost=17296 size=138 card=2)
         1          1          1     FAST DUAL  (cr=0 pr=0 pw=0 time=4 us starts=1 cost=2 size=0 card=1)
         5          5          5     VIEW  VW_JF_SET$4C271D7D (cr=43297 pr=0 pw=0 time=1130405 us starts=1 cost=17294 size=138 card=2)
         5          5          5      UNION-ALL  (cr=43297 pr=0 pw=0 time=1130402 us starts=1)
         0          0          0       FILTER  (cr=0 pr=0 pw=0 time=36 us starts=1)
         0          0          0        HASH JOIN  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=408 size=134 card=1)
         0          0          0         NESTED LOOPS  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=408 size=134 card=1)
         0          0          0          NESTED LOOPS  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=408 size=134 card=1)
         0          0          0           STATISTICS COLLECTOR  (cr=0 pr=0 pw=0 time=0 us starts=0)
         0          0          0            NESTED LOOPS  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=407 size=119 card=1)
         0          0          0             NESTED LOOPS  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=406 size=105 card=1)
         0          0          0              NESTED LOOPS  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=405 size=85 card=1)
         0          0          0               NESTED LOOPS  (cr=0 pr=0 pw=0 time=0 us starts=0 cost=404 size=75 card=1)
         0          0          0                TABLE ACCESS BY INDEX ROWID S_ORDDSC_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=9 card=1)
         0          0          0                 INDEX UNIQUE SCAN AK_S_ORDDSC_STD_CODE (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 104953)
         0          0          0                TABLE ACCESS BY INDEX ROWID BATCHED S_ORDPAY (cr=0 pr=0 pw=0 time=0 us starts=0 cost=403 size=66 card=1)
         0          0          0                 INDEX RANGE SCAN IE_S_ORDPAY_DVAL (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=7961)(object id 104973)
         0          0          0               INDEX UNIQUE SCAN PK_G_ACCBLN (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=10 card=1)(object id 101187)
         0          0          0              TABLE ACCESS BY INDEX ROWID BATCHED T_PROCMEM (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=20 card=1)
         0          0          0               INDEX RANGE SCAN FK_PROCMEM_ORDERS (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 101222)
         0          0          0             TABLE ACCESS BY INDEX ROWID T_PROCESS (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=14 card=1)
         0          0          0              INDEX UNIQUE SCAN PK_T_PROCESS (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 105704)
         0          0          0           INDEX UNIQUE SCAN PK_T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 105282)
         0          0          0          TABLE ACCESS BY INDEX ROWID T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=15 card=1)
         0          0          0         TABLE ACCESS BY INDEX ROWID BATCHED T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=15 card=1)
         0          0          0          INDEX RANGE SCAN AK_T_BOP_STAT_STD_CODE (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 105281)
         5          5          5       FILTER  (cr=43297 pr=0 pw=0 time=1130352 us starts=1)
         5          5          5        HASH JOIN  (cr=43297 pr=0 pw=0 time=1130340 us starts=1 cost=16886 size=134 card=1)
      1068       1068       1068         NESTED LOOPS  (cr=43294 pr=0 pw=0 time=1188185 us starts=1 cost=16886 size=134 card=1)
      1068       1068       1068          NESTED LOOPS  (cr=43294 pr=0 pw=0 time=1187941 us starts=1 cost=16886 size=134 card=1)
      1068       1068       1068           STATISTICS COLLECTOR  (cr=43294 pr=0 pw=0 time=1187457 us starts=1)
      1068       1068       1068            NESTED LOOPS  (cr=43294 pr=0 pw=0 time=1271575 us starts=1 cost=16885 size=119 card=1)
      1068       1068       1068             NESTED LOOPS  (cr=39033 pr=0 pw=0 time=1245311 us starts=1 cost=16884 size=105 card=1)
      1068       1068       1068              NESTED LOOPS  (cr=35060 pr=0 pw=0 time=1211448 us starts=1 cost=16883 size=85 card=1)
      1068       1068       1068               HASH JOIN  (cr=32968 pr=0 pw=0 time=1192895 us starts=1 cost=16882 size=75 card=1)
         1          1          1                TABLE ACCESS BY INDEX ROWID S_ORDDSC_STD (cr=2 pr=0 pw=0 time=38 us starts=1 cost=1 size=9 card=1)
         1          1          1                 INDEX UNIQUE SCAN AK_S_ORDDSC_STD_CODE (cr=1 pr=0 pw=0 time=22 us starts=1 cost=1 size=0 card=1)(object id 104953)
      1338       1338       1338                TABLE ACCESS BY INDEX ROWID BATCHED S_ORDPAY (cr=32966 pr=0 pw=0 time=824914 us starts=1 cost=16881 size=66 card=1)
    354490     354490     354490                 INDEX RANGE SCAN IE_S_ORDPAY_DVAL (cr=1441 pr=0 pw=0 time=162319 us starts=1 cost=636 size=0 card=320847)(object id 104973)
      1068       1068       1068               INDEX UNIQUE SCAN PK_G_ACCBLN (cr=2092 pr=0 pw=0 time=17627 us starts=1068 cost=1 size=10 card=1)(object id 101187)
      1068       1068       1068              TABLE ACCESS BY INDEX ROWID BATCHED T_PROCMEM (cr=3973 pr=0 pw=0 time=37692 us starts=1068 cost=1 size=20 card=1)
      1090       1090       1090               INDEX RANGE SCAN FK_PROCMEM_ORDERS (cr=3200 pr=0 pw=0 time=27793 us starts=1068 cost=1 size=0 card=1)(object id 101222)
      1068       1068       1068             TABLE ACCESS BY INDEX ROWID T_PROCESS (cr=4261 pr=0 pw=0 time=28432 us starts=1068 cost=1 size=14 card=1)
      1068       1068       1068              INDEX UNIQUE SCAN PK_T_PROCESS (cr=3193 pr=0 pw=0 time=17201 us starts=1068 cost=1 size=0 card=1)(object id 105704)
         0          0          0           INDEX UNIQUE SCAN PK_T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 105282)
         0          0          0          TABLE ACCESS BY INDEX ROWID T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=15 card=1)
         1          1          1         TABLE ACCESS BY INDEX ROWID BATCHED T_BOP_STAT_STD (cr=3 pr=0 pw=0 time=61 us starts=1 cost=1 size=15 card=1)
         1          1          1          INDEX RANGE SCAN AK_T_BOP_STAT_STD_CODE (cr=2 pr=0 pw=0 time=42 us starts=1 cost=1 size=0 card=1)(object id 105281)
       123        123        123    NESTED LOOPS  (cr=39046254 pr=2817369 pw=0 time=1328337472 us starts=1 cost=67278 size=144 card=2)
         1          1          1     FAST DUAL  (cr=0 pr=0 pw=0 time=3 us starts=1 cost=2 size=0 card=1)
       123        123        123     VIEW  VW_JF_SET$6FD39390 (cr=39046254 pr=2817369 pw=0 time=1328337570 us starts=1 cost=67276 size=144 card=2)
       123        123        123      SORT UNIQUE (cr=39046254 pr=2817369 pw=0 time=1328337566 us starts=1 cost=67276 size=339 card=2)
       123        123        123       UNION-ALL  (cr=39046254 pr=2817369 pw=0 time=1327602475 us starts=1)
       123        123        123        NESTED LOOPS  (cr=39044606 pr=2815865 pw=0 time=1327601610 us starts=1 cost=67262 size=156 card=1)
       123        123        123         NESTED LOOPS  (cr=39043398 pr=2815524 pw=0 time=1326405096 us starts=1 cost=67262 size=156 card=1)
       123        123        123          HASH JOIN  (cr=39043027 pr=2815487 pw=0 time=1326308881 us starts=1 cost=67261 size=140 card=1)
      4816       4816       4816           NESTED LOOPS  (cr=39043024 pr=2815487 pw=0 time=1316344458 us starts=1 cost=67261 size=140 card=1)
      4816       4816       4816            STATISTICS COLLECTOR  (cr=39043024 pr=2815487 pw=0 time=1316342166 us starts=1)
      4816       4816       4816             NESTED LOOPS  (cr=39043024 pr=2815487 pw=0 time=1799687777 us starts=1 cost=67260 size=125 card=1)
      4816       4816       4816              NESTED LOOPS  (cr=39023755 pr=2811268 pw=0 time=1795138670 us starts=1 cost=67259 size=111 card=1)
      4816       4816       4816               NESTED LOOPS  (cr=39001132 pr=2806868 pw=0 time=1792147016 us starts=1 cost=67258 size=91 card=1)
      4816       4816       4816                NESTED LOOPS  (cr=38991633 pr=2806536 pw=0 time=1791851802 us starts=1 cost=67257 size=81 card=1)
         1          1          1                 TABLE ACCESS BY INDEX ROWID S_ORDDSC_STD (cr=2 pr=0 pw=0 time=43 us starts=1 cost=1 size=9 card=1)
         1          1          1                  INDEX UNIQUE SCAN AK_S_ORDDSC_STD_CODE (cr=1 pr=0 pw=0 time=25 us starts=1 cost=1 size=0 card=1)(object id 104953)
      4816       4816       4816                 TABLE ACCESS BY INDEX ROWID BATCHED S_ORDPAY (cr=38991631 pr=2806536 pw=0 time=1791847470 us starts=1 cost=67256 size=72 card=1)
  34384530   34384530   34384530                  INDEX SKIP SCAN IE_S_ORDPAY_DOP (cr=5896682 pr=172503 pw=0 time=615983330 us starts=1 cost=2246 size=0 card=135144)(object id 104971)
      4816       4816       4816                INDEX UNIQUE SCAN PK_G_ACCBLN (cr=9499 pr=332 pw=0 time=360221 us starts=4816 cost=1 size=10 card=1)(object id 101187)
      4816       4816       4816               TABLE ACCESS BY INDEX ROWID BATCHED T_PROCMEM (cr=22623 pr=4400 pw=0 time=3229932 us starts=4816 cost=1 size=20 card=1)
      8649       8649       8649                INDEX RANGE SCAN FK_PROCMEM_ORDERS (cr=14307 pr=1809 pw=0 time=1625902 us starts=4816 cost=1 size=0 card=1)(object id 101222)
      4816       4816       4816              TABLE ACCESS BY INDEX ROWID T_PROCESS (cr=19269 pr=4219 pw=0 time=3655874 us starts=4816 cost=1 size=14 card=1)
      4816       4816       4816               INDEX UNIQUE SCAN PK_T_PROCESS (cr=14450 pr=2313 pw=0 time=1984769 us starts=4816 cost=1 size=0 card=1)(object id 105704)
         0          0          0            TABLE ACCESS BY INDEX ROWID T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=15 card=1)
         0          0          0             INDEX UNIQUE SCAN PK_T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 105282)
         1          1          1           TABLE ACCESS BY INDEX ROWID BATCHED T_BOP_STAT_STD (cr=3 pr=0 pw=0 time=38 us starts=1 cost=1 size=15 card=1)
         1          1          1            INDEX RANGE SCAN AK_T_BOP_STAT_STD_CODE (cr=2 pr=0 pw=0 time=30 us starts=1 cost=1 size=0 card=1)(object id 105281)
       123        123        123          INDEX UNIQUE SCAN PK_T_ACC (cr=371 pr=37 pw=0 time=28423 us starts=123 cost=1 size=0 card=1)(object id 105140)
       123        123        123         TABLE ACCESS BY INDEX ROWID T_ACC (cr=1208 pr=341 pw=0 time=381628 us starts=123 cost=1 size=16 card=1)
         0          0          0        NESTED LOOPS  (cr=1648 pr=1504 pw=0 time=1616860 us starts=1 cost=14 size=183 card=1)
         0          0          0         HASH JOIN  (cr=1648 pr=1504 pw=0 time=1616855 us starts=1 cost=13 size=178 card=1)
         7          7          7          NESTED LOOPS  (cr=1645 pr=1504 pw=0 time=1606886 us starts=1 cost=13 size=178 card=1)
         7          7          7           STATISTICS COLLECTOR  (cr=1645 pr=1504 pw=0 time=1606868 us starts=1)
         7          7          7            NESTED LOOPS  (cr=1645 pr=1504 pw=0 time=1609392 us starts=1 cost=12 size=163 card=1)
         7          7          7             NESTED LOOPS  (cr=1615 pr=1496 pw=0 time=1599807 us starts=1 cost=11 size=149 card=1)
         7          7          7              NESTED LOOPS  (cr=1599 pr=1495 pw=0 time=1599396 us starts=1 cost=10 size=139 card=1)
         7          7          7               NESTED LOOPS  (cr=1569 pr=1475 pw=0 time=1588825 us starts=1 cost=9 size=124 card=1)
         7          7          7                NESTED LOOPS  (cr=1539 pr=1466 pw=0 time=1579396 us starts=1 cost=8 size=104 card=1)
         1          1          1                 TABLE ACCESS BY INDEX ROWID S_ORDDSC_STD (cr=2 pr=0 pw=0 time=64 us starts=1 cost=1 size=9 card=1)
         1          1          1                  INDEX UNIQUE SCAN AK_S_ORDDSC_STD_CODE (cr=1 pr=0 pw=0 time=15 us starts=1 cost=1 size=0 card=1)(object id 104953)
         7          7          7                 TABLE ACCESS BY INDEX ROWID BATCHED S_ORDPAY (cr=1537 pr=1466 pw=0 time=1579324 us starts=1 cost=8 size=95 card=1)
        95         95         95                  BITMAP CONVERSION TO ROWIDS (cr=1466 pr=1466 pw=0 time=1576617 us starts=1)
         1          1          1                   BITMAP AND  (cr=1466 pr=1466 pw=0 time=1576600 us starts=1)
         1          1          1                    BITMAP CONVERSION FROM ROWIDS (cr=25 pr=25 pw=0 time=26073 us starts=1)
      9658       9658       9658                     INDEX RANGE SCAN FK_S_ORDPAY_T_OPRCHR (cr=25 pr=25 pw=0 time=5813 us starts=1 cost=1 size=0 card=7961)(object id 104969)
         4          4          4                    BITMAP CONVERSION FROM ROWIDS (cr=1441 pr=1441 pw=0 time=1641258 us starts=1)
    354490     354490     354490                     SORT ORDER BY (cr=1441 pr=1441 pw=0 time=1572525 us starts=1)
    354490     354490     354490                      INDEX RANGE SCAN IE_S_ORDPAY_DVAL (cr=1441 pr=1441 pw=0 time=1448677 us starts=1 cost=2 size=0 card=7961)(object id 104973)
         7          7          7                TABLE ACCESS BY INDEX ROWID BATCHED T_PROCMEM (cr=30 pr=9 pw=0 time=7254 us starts=7 cost=1 size=20 card=1)
         7          7          7                 INDEX RANGE SCAN FK_PROCMEM_ORDERS (cr=23 pr=7 pw=0 time=5503 us starts=7 cost=1 size=0 card=1)(object id 101222)
         7          7          7               TABLE ACCESS BY INDEX ROWID BATCHED T_ORD (cr=30 pr=20 pw=0 time=17866 us starts=7 cost=1 size=15 card=1)
         7          7          7                INDEX RANGE SCAN PK_T_ORD (cr=23 pr=13 pw=0 time=10502 us starts=7 cost=1 size=0 card=1)(object id 101220)
         7          7          7              INDEX UNIQUE SCAN PK_G_ACCBLN (cr=16 pr=1 pw=0 time=1621 us starts=7 cost=1 size=10 card=1)(object id 101187)
         7          7          7             TABLE ACCESS BY INDEX ROWID T_PROCESS (cr=30 pr=8 pw=0 time=7133 us starts=7 cost=1 size=14 card=1)
         7          7          7              INDEX UNIQUE SCAN PK_T_PROCESS (cr=23 pr=5 pw=0 time=4840 us starts=7 cost=1 size=0 card=1)(object id 105704)
         0          0          0           TABLE ACCESS BY INDEX ROWID T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=15 card=1)
         0          0          0            INDEX UNIQUE SCAN PK_T_BOP_STAT_STD (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=0 card=1)(object id 105282)
         1          1          1          TABLE ACCESS BY INDEX ROWID BATCHED T_BOP_STAT_STD (cr=3 pr=0 pw=0 time=50 us starts=1 cost=1 size=15 card=1)
         1          1          1           INDEX RANGE SCAN AK_T_BOP_STAT_STD_CODE (cr=2 pr=0 pw=0 time=35 us starts=1 cost=1 size=0 card=1)(object id 105281)
         0          0          0         INDEX UNIQUE SCAN PK_C_USR (cr=0 pr=0 pw=0 time=0 us starts=0 cost=1 size=5 card=1)(object id 102431)


Elapsed times include waiting on following events:
  Event waited on                             Times   Max. Wait  Total Waited
  ----------------------------------------   Waited  ----------  ------------
  PGA memory operation                          178        0.00          0.00
  Disk file operations I/O                      350        0.00          0.05
  db file sequential read                   2782944        0.04       1457.95
  latch: cache buffers chains                     4        0.00          0.00
  db file parallel read                        2166        0.00          3.10
********************************************************************************
