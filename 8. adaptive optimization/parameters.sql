/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 4. Адаптивная оптимизация запросов (Adaptive Query Optimization)

  Описание скрипта: параметры
  
*/

---- Параметры вкл/выкл адаптивная оптимизация
select * 
  from v$parameter t 
 where t.name in ('optimizer_adaptive_plans', 'optimizer_adaptive_statistics');

-- вкл/выкл на уровне сессии
alter session set optimizer_adaptive_plans = true;
alter session set optimizer_adaptive_statistics = true;

alter session set optimizer_adaptive_plans = false;
alter session set optimizer_adaptive_statistics = false;

-- вкл/выкл на уровне бд
alter system set optimizer_adaptive_plans = true scope=both;
alter system set optimizer_adaptive_statistics = true scope=both;

alter system set optimizer_adaptive_plans = false scope=both;
alter system set optimizer_adaptive_statistics = false scope=both;

