/*
  Курс: Оптимизация Oracle SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://backend-pro.ru, https://www.youtube.com/c/OracleDBD)

  Лекция. Поиск медленных запросов

  Описание: пример снятия трассировки
 
*/

select * from payment;

-- Этап 1. Снятие 

alter session set timed_statistics = true; -- Включение сбора статистики (включена по умолчанию)
alter session set tracefile_identifier = 'EXAMPLE_TRC_1'; -- Метка для файла
alter session set max_dump_file_size = '20M'; -- Максимальный размер файла (по умолчанию безлимит)

call dbms_session.session_trace_enable();

begin
  kivi.payment_check_pack.check_payment(p_payment_id => 5254216);
end;
/

call dbms_session.session_trace_disable();


-- Этап 2. Получение содержимого

select * from v$diag_trace_file t where t.trace_filename like '%EXAMPLE_TRC_1%';
 
select payload
  from v$diag_trace_file_contents t
 where t.trace_filename like '%ORCLCDB_ora_87107_EXAMPLE_TRC_1.trc%'
 order by t.line_number;


-- Этап 3. Разбор

tkprof ORCLCDB_ora_87107_EXAMPLE_TRC_1.trc ORCLCDB_ora_87107_EXAMPLE_TRC_1.trc.txt sort=prsela,fchela,exeela sys=no
orasrp --sort=prsela,fchela,exeela --sys=no EXAMPLE_TRC_1.trc EXAMPLE_TRC_1.trc.html

orasrp --sort=prsela,fchela,exeela --sys=no ORCLCDB_ora_183083_CHECK_PAYMENT111.trc ORCLCDB_ora_183083_CHECK_PAYMENT111.trc.html 
