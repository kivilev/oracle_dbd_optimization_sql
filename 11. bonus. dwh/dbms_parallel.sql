/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Бонусная лекция. Секреты работы с DWH

  Описание скрипта: Демо dbms_parallel
*/

-- Создаем тестовую таблицу EMPLOYEES_TEST
drop table employees_test;
create table employees_test (
   emp_id    number primary key,
   name      varchar2(50 char),
   salary    number(10)
);

insert into employees_test
select level, 'name_'||level, level salary from dual connect by level <= 100000; 
commit;

-- создаем задачу
begin
  dbms_parallel_execute.create_task('update_salaries_task');
end;
/

-- создаем чанки по rowid
begin
  dbms_parallel_execute.create_chunks_by_rowid(
    task_name   => 'update_salaries_task',
    table_owner => user,
    table_name  => 'EMPLOYEES_TEST',
    by_row      => true,
    chunk_size  => 10000
  );
end;
/

-- определяем sql-запрос для выполнения в параллельном режиме
begin
  dbms_parallel_execute.run_task(
    task_name      => 'update_salaries_task',
    sql_stmt       => 'UPDATE employees_test SET salary = salary + 1000 WHERE ROWID BETWEEN :start_id AND :end_id',
    language_flag  => dbms_sql.native,
    parallel_level => 5
  );
end;
/

-- удаляем задачу после завершения
begin
  dbms_parallel_execute.drop_task('update_salaries_task');
end;
/

-- проверяем работу
select sysdate, t.* from user_scheduler_job_log t where t.job_name like 'TASK$%' and t.log_date >= sysdate - 1/24/5 order by log_date desc;
select sysdate, t.* from user_scheduler_job_run_details t where t.job_name like 'TASK$%'  and t.log_date >= sysdate - 1/24/5 order by log_date desc;
select sysdate, t.* from user_scheduler_jobs t where t.job_name like 'TASK$%'; -- нет записей

select * from employees_test;
