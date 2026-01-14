/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Разные темы

  Описание скрипта: ASH-отчет
*/

---- Способ 1. Выполнение скрипта на сервере СУБД
-- @$ORACLE_HOME/rdbms/admin/ashrpt.sql


---- Способ 2. DBMS_WORKLOAD_REPOSITORY
select dbid from v$database;
select instance_number from v$instance;

-- получение отчета за период
select *
  from dbms_workload_repository.ash_report_html(l_dbid     => 2939488823,
                                                l_inst_num => 1,
                                                l_btime    => sysdate - 1 / 24,
                                                l_etime    => sysdate);

-- Фильтр по названию PL/SQL-объекта входной точки за период
select *
  from dbms_workload_repository.ash_report_html(l_dbid     => 2939488823,
                                                l_inst_num => 1,
                                                l_btime    => sysdate - 1,
                                                l_etime    => sysdate,
                                                l_plsql_entry => '%CLIENT_WALLET_ANALYSIS_PROC%');

-- фильтр по SID-сессии за период 368,65293
select *
  from dbms_workload_repository.ash_report_html(l_dbid     => 2939488823,
                                                l_inst_num => 1,
                                                l_btime    => sysdate - 1/24,
                                                l_etime    => sysdate,
                                                l_sid => 368);
