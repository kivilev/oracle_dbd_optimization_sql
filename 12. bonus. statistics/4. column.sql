/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 11. Статистика

  Описание скрипта: статистика по колонкам таблиц
  
*/

call dbms_stats.gather_table_stats(ownname => user, tabname => 'EMPLOYEES');

---- Пример 1. Статистика по колонкам HR.EMPLOYEES
select t.num_distinct, t.num_nulls, t.last_analyzed,
       t.sample_size, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';

select count(distinct t.COMMISSION_PCT) from hr.employees t ;
select count(1) from hr.employees t where t.COMMISSION_PCT is not null;

---- Пример 2. Более разнообразный
drop table demo$tab$stat;

-- вставка 1М - статистика собирается сразу (Oracle 12c и выше)
create table demo$tab$stat as
select level col1, 'sssss' col2, rpad('я',50,'ъ') col3, decode(mod(level,2), 0, 1) nullcol4
  from dual
connect by level <= 1000000;--1M

-- статистика по столбцам
select t.num_distinct, t.num_nulls, t.sample_size, t.last_analyzed,
       notes, t.histogram,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'DEMO$TAB$STAT'
   and t.owner = user;
   
-- Вопрос. Как определить на основе статистики подходит ли колонка для использования в качестве лидирующего столбца для индекса?



---- Пример 3. Секционированных таблицы
select * from all_part_col_statistics t where t.table_name = 'DEL$SALE_HASH';



---- Пример 4. Как посмотреть Low_value и high_value
-- https://jonathanlewis.wordpress.com/2006/11/29/low_value-high_value/

-- запрос "на коленке"
select t.num_distinct
      ,t.num_nulls
      ,(case
         when tc.data_type = 'NUMBER' then
          to_char(dbms_stats.convert_raw_to_number(t.low_value))
         else
          dbms_stats.convert_raw_to_varchar2(t.low_value)
       end) lvalue
      
      ,(case
         when tc.data_type = 'NUMBER' then
          to_char(dbms_stats.convert_raw_to_number(t.high_value))
         else
           dbms_stats.convert_raw_to_varchar2(t.high_value)
       end) hvalue
      
      ,t.*
  from all_tab_col_statistics t
  join all_tab_cols tc on tc.owner = t.owner and t.table_name = tc.table_name and t.column_name = tc.column_name
 where t.table_name = 'DEMO$TAB$STAT'
   and t.owner = user;
   
