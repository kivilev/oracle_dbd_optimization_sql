/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: сбор статистики
  
*/


---- Пример 1. Eжедневная таска по сбору статисики AUTO_TASK (DBA)
-- пакет по управлению настройками
dbms_auto_task_admin

-- вкл/выкл сбор ежедневной статистики
select client_name
      ,status      
  from dba_autotask_client t
 where client_name = 'auto optimizer stats collection';

-- AUTO_TASK - ежедневная, HIGH_FREQ_AUTO_TASK - инкрементальная раз в N минут.
select * from dba_auto_stat_executions;



---- Пример 2. Частотная таска по сбору статисики HIGH_FREQ_AUTO_TASK (DBA)
select * from dba_auto_stat_executions;

-- текущие настройки
select dbms_stats.get_prefs('AUTO_TASK_STATUS') 
      ,dbms_stats.get_prefs('AUTO_TASK_INTERVAL') 
  from dual;

-- Управление настройками частотной сборки статистики
call dbms_stats.set_global_prefs('AUTO_TASK_STATUS','ON'); -- включение автоматической сборки раз в N минут.
call dbms_stats.set_global_prefs('AUTO_TASK_MAX_RUN_TIME','180'); -- максимальное время работы
call dbms_stats.set_global_prefs('AUTO_TASK_INTERVAL','240');-- интервал HIGH_FREQ_AUTO_TASK


---- Пример 3. Автоматическая сборка при выполнении SQL

-- 1) Вставка 1М - статистика собирается сразу (Oracle 12c и выше)
drop table demo$tab$stat;
create table demo$tab$stat as
select level col1, 'sssss' col2, rpad('я',50,'ъ') col3
  from dual
connect by level <= 1000000;

-- статистика по таблице
select t.last_analyzed, t.*
  from user_tab_statistics t
 where  t.table_name = 'DEMO$TAB$STAT';
 
-- 2) без сбора статистики 
drop table demo$tab$stat; 
create table demo$tab$stat as
select  /*+ no_gather_optimizer_statistics*/ 
	   level col1, 'sssss' col2, rpad('я',50,'ъ') col3
  from dual
connect by level <= 1000000;

-- 3) insert + append, но только для пустой таблы

drop table demo$tab$stat;
create table demo$tab$stat
(
  col1 number,
  col2 varchar2(100 char)
  col3 varchar2(100 char)
);

insert /*+ append */into demo$tab$stat
select level col1, 'sssss' col2, rpad('я',50,'ъ') col3
  from dual
connect by level <= 100000;
commit;


---- Пример 4. Ручной сбор статистики

-- 1 поточный режим
call dbms_stats.gather_table_stats(ownname => user, tabname => 'demo$tab$stat');
-- 4 потока на сбор
call dbms_stats.gather_table_stats(ownname => user, tabname => 'demo$tab$stat', degree  => 4);
-- с дополнительными опциям
call dbms_stats.gather_table_stats (user, 'demo$tab$stat', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 

call dbms_stats.gather_schema_stats(ownname => user);
