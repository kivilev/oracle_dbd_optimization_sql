--- Схема: KIVI

---- малая таблица первая - ок
select /*+ full(cl) full(cd) leading(cl cd)*/
 count(cl.is_active + cd.field_id)
  from client cl
  join client_data cd
    on cd.client_id = cl.client_id;

---- большая таблица первая - не ок
select /*+ full(cl) full(cd) leading(cd cl)*/
 count(cl.is_active + cd.field_id)
  from client cl
  join client_data cd
    on cd.client_id = cl.client_id;
