-- Запрос 
select  cm.cntr_public_id
		,cm.pst_id
		,cm.mrt_id
		,cm.cmr_description
		,cm.last_processing_date
  from ident_tasks_migrate.client_migrate_result cm
 where cm.cntr_public_id = 'D212661E3BC511DDBFFFFFCAFFFFFFDD'
   and cm.pst_id = 0;


-- Определение таблицы
create table client_migrate_result
(
  cntr_public_id       varchar2(200 char) not null,
  pst_id               number(20) not null,
  mrt_id               number(20),
  cmr_description      varchar2(200 char),
  last_processing_date date not null,
  cntr_creation_date   date not null
);

create index client_migrate_result_ccd_i on client_migrate_result (cntr_creation_date);
create index client_migrate_result_lpd_i on client_migrate_result (last_processing_date);
create index client_migrate_result_mrt_id_i on client_migrate_result (mrt_id);
create index client_migrate_result_pst_id_i on client_migrate_result (pst_id);


alter table client_migrate_result
  add constraint client_migrate_result_pk primary key (cntr_public_id);
alter table client_migrate_result
  add constraint migrate_result_mst_id_fk foreign key (mrt_id)
  references migrate_result (mrt_id);
alter table client_migrate_result
  add constraint processing_status_pst_id_fk foreign key (pst_id)
  references processing_status (pst_id);

