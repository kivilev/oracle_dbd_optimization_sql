﻿/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: inlist iterator
   
*/

-- INLIST
select * 
  from hr.employees t 
 where t.employee_id in (100, 101, 102);

select * from hr.employees t 
 where t.department_id in (10, 20, 30);

-- FTS 
select * 
  from hr.employees t 
 where t.employee_id in (100,101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168,
 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187,
 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206
); 

select * from hr.employees t 
 where t.department_id in (10, 20, 30, 40, 50, 60);
