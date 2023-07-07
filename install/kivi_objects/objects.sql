prompt PL/SQL Developer Export User Objects for user KIVI@ORACLE19EE
prompt Created by d.kivilev on 7 Июль 2023 г.
set define off
spool objects.log

prompt
prompt Creating table CLIENT
prompt =====================
prompt
create table CLIENT
(
  client_id         NUMBER(30) not null,
  is_active         NUMBER(1) default 1 not null,
  is_blocked        NUMBER(1) default 0 not null,
  blocked_reason    VARCHAR2(1000 CHAR),
  create_dtime_tech TIMESTAMP(6) default systimestamp not null,
  update_dtime_tech TIMESTAMP(6) default systimestamp not null
)
;
comment on table CLIENT
  is 'Клиент';
comment on column CLIENT.client_id
  is 'Уникальный ID клиента';
comment on column CLIENT.is_active
  is 'Активен ли клиент. 1 - да, 0 - нет.';
comment on column CLIENT.is_blocked
  is 'Заблокирован ли клиент. 1 - да, 0 - нет.';
comment on column CLIENT.blocked_reason
  is 'Причина блокировки';
comment on column CLIENT.create_dtime_tech
  is 'Техническое поле. Дата создания записи';
comment on column CLIENT.update_dtime_tech
  is 'Техническое поле. Дата обновления записи';
alter table CLIENT
  add constraint CLIENT_PK primary key (CLIENT_ID);
alter table CLIENT
  add constraint CLIENT_ACTIVE_CHK
  check (is_active in (0, 1));
alter table CLIENT
  add constraint CLIENT_BLOCKED_CHK
  check (is_blocked in (0, 1));
alter table CLIENT
  add constraint CLIENT_BLOCK_REASON_CHK
  check ((is_blocked = 1 and blocked_reason is not null) or (is_blocked = 0));
alter table CLIENT
  add constraint CLIENT_TECH_DATES_CHK
  check (create_dtime_tech <= update_dtime_tech);

prompt
prompt Creating table CURRENCY
prompt =======================
prompt
create table CURRENCY
(
  currency_id NUMBER(3) not null,
  alfa3       CHAR(3 CHAR) not null,
  description VARCHAR2(100 CHAR) not null
)
;
comment on table CURRENCY
  is 'Справочник валют (ISO-4217)';
comment on column CURRENCY.currency_id
  is 'Трёхзначный цифровой (number-3) код валюты';
comment on column CURRENCY.alfa3
  is 'Трёхбуквенный алфавитный (alfa-3) код валюты';
comment on column CURRENCY.description
  is 'Описание валюты';
alter table CURRENCY
  add constraint CURRENCY_PK primary key (CURRENCY_ID);
alter table CURRENCY
  add constraint CURRENCY_ALFA3_CHK
  check (alfa3 = upper(alfa3));

prompt
prompt Creating table WALLET
prompt =====================
prompt
create table WALLET
(
  wallet_id            NUMBER(30) not null,
  client_id            NUMBER(30) not null,
  status_id            NUMBER(2) default 0 not null,
  status_change_reason VARCHAR2(200 CHAR),
  create_dtime_tech    TIMESTAMP(6) default systimestamp not null,
  update_dtime_tech    TIMESTAMP(6) default systimestamp not null
)
;
comment on table WALLET
  is 'Кошелек';
comment on column WALLET.wallet_id
  is 'Уникальный ID кошелька';
comment on column WALLET.client_id
  is 'Уникальный ID клиента';
comment on column WALLET.status_id
  is 'Статус кошелька. 0 - транзакции разрешены, 1 - транзакции заблокированы';
comment on column WALLET.status_change_reason
  is 'Последняя причина изменения статуса';
comment on column WALLET.create_dtime_tech
  is 'Техническое поле. Дата создания записи';
comment on column WALLET.update_dtime_tech
  is 'Техническое поле. Дата обновления записи';
alter table WALLET
  add constraint WALLET_PK primary key (WALLET_ID);
alter table WALLET
  add constraint WALLET_CLIENT_FK foreign key (CLIENT_ID)
  references CLIENT (CLIENT_ID);
alter table WALLET
  add constraint WALLET_STATUS_ID_CHK
  check (status_id in (0, 1));
alter table WALLET
  add constraint WALLET_STATUS_REASON_CHK
  check (status_id = 1 and status_change_reason is not null or status_id = 0);

prompt
prompt Creating table ACCOUNT
prompt ======================
prompt
create table ACCOUNT
(
  account_id        NUMBER(38) not null,
  client_id         NUMBER(30) not null,
  wallet_id         NUMBER(30) not null,
  currency_id       NUMBER(4) not null,
  balance           NUMBER(30,2) not null,
  create_dtime_tech TIMESTAMP(6) default systimestamp not null,
  update_dtime_tech TIMESTAMP(6) default systimestamp not null
)
;
comment on table ACCOUNT
  is 'Счет кошелька';
comment on column ACCOUNT.account_id
  is 'Уникальный ID счета';
comment on column ACCOUNT.client_id
  is 'Уникальный ID клиента';
comment on column ACCOUNT.wallet_id
  is 'Уникальный ID кошелька';
comment on column ACCOUNT.currency_id
  is 'Валюта счета. 840 - USD, 643 - RUB, 978 - EUR';
comment on column ACCOUNT.balance
  is 'Текущий баланс счета';
comment on column ACCOUNT.create_dtime_tech
  is 'Техническое поле. Дата создания записи';
comment on column ACCOUNT.update_dtime_tech
  is 'Техническое поле. Дата обновления записи';
create unique index ACCOUNT_WALLET_CURRENCY_UNQ on ACCOUNT (WALLET_ID, CURRENCY_ID);
alter table ACCOUNT
  add constraint ACCOUNT_PK primary key (ACCOUNT_ID);
alter table ACCOUNT
  add constraint ACCOUNT_CLIENT_FK foreign key (CLIENT_ID)
  references CLIENT (CLIENT_ID);
alter table ACCOUNT
  add constraint ACCOUNT_CURRENCY_ID_FK foreign key (CURRENCY_ID)
  references CURRENCY (CURRENCY_ID);
alter table ACCOUNT
  add constraint ACCOUNT_WALLET_FK foreign key (WALLET_ID)
  references WALLET (WALLET_ID);

prompt
prompt Creating table CLIENT_DATA_FIELD
prompt ================================
prompt
create table CLIENT_DATA_FIELD
(
  field_id    NUMBER(10) not null,
  name        VARCHAR2(100 CHAR) not null,
  description VARCHAR2(200 CHAR) not null
)
;
comment on table CLIENT_DATA_FIELD
  is 'Справочник полей данных клиента';
comment on column CLIENT_DATA_FIELD.field_id
  is 'Уникальный ID поля';
comment on column CLIENT_DATA_FIELD.name
  is 'Название - код';
comment on column CLIENT_DATA_FIELD.description
  is 'Описание';
alter table CLIENT_DATA_FIELD
  add constraint CLIENT_DATA_FIELD_PK primary key (FIELD_ID);
alter table CLIENT_DATA_FIELD
  add constraint CLIENT_DATA_FIELD_NAME_CHK
  check (name = upper(name));

prompt
prompt Creating table CLIENT_DATA
prompt ==========================
prompt
create table CLIENT_DATA
(
  client_id   NUMBER(30) not null,
  field_id    NUMBER(10) not null,
  field_value VARCHAR2(200 CHAR) not null
)
;
comment on table CLIENT_DATA
  is 'Данные клиента';
comment on column CLIENT_DATA.client_id
  is 'ID клиента';
comment on column CLIENT_DATA.field_id
  is 'ID поля';
comment on column CLIENT_DATA.field_value
  is 'Значение поля (сами данные)';
create index CLIENT_DATA_FIELD_I on CLIENT_DATA (FIELD_ID);
alter table CLIENT_DATA
  add constraint CLIENT_DATA_PK primary key (CLIENT_ID, FIELD_ID);
alter table CLIENT_DATA
  add constraint CLIENT_DATA_CLIENT_FK foreign key (CLIENT_ID)
  references CLIENT (CLIENT_ID);
alter table CLIENT_DATA
  add constraint CLIENT_DATA_FIELD_FK foreign key (FIELD_ID)
  references CLIENT_DATA_FIELD (FIELD_ID);

prompt
prompt Creating table COUNTRY
prompt ======================
prompt
create table COUNTRY
(
  id          NUMBER(3) not null,
  name        VARCHAR2(100 CHAR) not null,
  iso_alpha_2 VARCHAR2(2 CHAR),
  iso_alpha_3 VARCHAR2(3 CHAR)
)
;
comment on table COUNTRY
  is 'Countries';
comment on column COUNTRY.id
  is 'ISO code';
comment on column COUNTRY.name
  is 'Name';
comment on column COUNTRY.iso_alpha_2
  is 'ISO 2';
comment on column COUNTRY.iso_alpha_3
  is 'ISO 3';
alter table COUNTRY
  add constraint COUNTRY_PK primary key (ID);
alter table COUNTRY
  add constraint COUNTRY_ISO_ALPHA_2_UQ unique (ISO_ALPHA_2);
alter table COUNTRY
  add constraint COUNTRY_ISO_ALPHA_3_UQ unique (ISO_ALPHA_3);
alter table COUNTRY
  add constraint COUNTRY_NAME_UQ unique (NAME);

prompt
prompt Creating table COUNTRY_CURRENCY
prompt ===============================
prompt
create table COUNTRY_CURRENCY
(
  country_id  NUMBER(3) not null,
  currency_id NUMBER(3) not null
)
;
comment on table COUNTRY_CURRENCY
  is 'Currencies in countries';
comment on column COUNTRY_CURRENCY.country_id
  is 'Country ID';
comment on column COUNTRY_CURRENCY.currency_id
  is 'Currency ID';
alter table COUNTRY_CURRENCY
  add constraint COUNTRY_CURRENCY_PK primary key (CURRENCY_ID, COUNTRY_ID);
alter table COUNTRY_CURRENCY
  add constraint COUNTRY_CURRENCY_CURRENCY_ID_FK foreign key (CURRENCY_ID)
  references CURRENCY (CURRENCY_ID)
  disable
  novalidate;

prompt
prompt Creating table COUNTRY_PHONE
prompt ============================
prompt
create table COUNTRY_PHONE
(
  country_id   NUMBER(3) not null,
  phone_prefix VARCHAR2(20) not null
)
;
comment on table COUNTRY_PHONE
  is 'Country to phone prefix';
create index COUNTRY_PHONE_PHONE_PREFIX_I on COUNTRY_PHONE (PHONE_PREFIX);
alter table COUNTRY_PHONE
  add constraint COUNTRY_PHONE_PK unique (COUNTRY_ID, PHONE_PREFIX)
  disable
  novalidate;

prompt
prompt Creating table EVENT_QUEUE
prompt ==========================
prompt
create table EVENT_QUEUE
(
  id                   NUMBER(38),
  type                 NUMBER(10),
  object_id            VARCHAR2(1000 CHAR),
  create_dtime         DATE,
  next_processing_date DATE
)
partition by range (NEXT_PROCESSING_DATE) interval (NUMTODSINTERVAL(1,'DAY'))
(
  partition PMIN values less than (TO_DATE(' 2023-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace users
);

prompt
prompt Creating table IP_LIST
prompt ======================
prompt
create table IP_LIST
(
  id   NUMBER(38),
  ip   VARCHAR2(30 CHAR),
  type CHAR(1) default 'B' not null
)
;
create index IP_LIST_TYPE_IP_I on IP_LIST (TYPE, IP);

prompt
prompt Creating table PASSPORT_BLACK_LIST
prompt ==================================
prompt
create table PASSPORT_BLACK_LIST
(
  passport_series VARCHAR2(20 CHAR) not null,
  passport_number VARCHAR2(20 CHAR) not null,
  add_dtime       DATE not null
)
;

prompt
prompt Creating table PAYMENT
prompt ======================
prompt
create table PAYMENT
(
  payment_id           NUMBER(38) not null,
  create_dtime         TIMESTAMP(6) not null,
  summa                NUMBER(30,2) not null,
  currency_id          NUMBER(3) not null,
  from_client_id       NUMBER(30) not null,
  to_client_id         NUMBER(30) not null,
  status               NUMBER(10) default 0 not null,
  status_change_reason VARCHAR2(200 CHAR),
  create_dtime_tech    TIMESTAMP(6) default systimestamp not null,
  update_dtime_tech    TIMESTAMP(6) default systimestamp not null
)
partition by range (CREATE_DTIME) interval (NUMTODSINTERVAL(1,'DAY'))
(
  partition PMIN values less than (TIMESTAMP' 2023-01-01 00:00:00')
    tablespace users
);
comment on table PAYMENT
  is 'Платеж';
comment on column PAYMENT.payment_id
  is 'Уникальный ID платежа';
comment on column PAYMENT.create_dtime
  is 'Дата создания платежа';
comment on column PAYMENT.summa
  is 'Сумма платежа';
comment on column PAYMENT.currency_id
  is 'В какой валюте производился платеж';
comment on column PAYMENT.from_client_id
  is 'Клиент-отправитель';
comment on column PAYMENT.to_client_id
  is 'Клиент-получатель';
comment on column PAYMENT.status
  is 'Статус платежа. 0 - готов к обработке, 1 - проведен, 2 - ошибка проведения, 3 - отмена платежа';
comment on column PAYMENT.status_change_reason
  is 'Причина изменения стуса платежа. Заполняется для статусов "2" и "3"';
comment on column PAYMENT.create_dtime_tech
  is 'Техническое поле. Дата создания записи';
comment on column PAYMENT.update_dtime_tech
  is 'Техническое поле. Дата обновления записи';
create index PAYMENT_FROM_CLIENT_I on PAYMENT (FROM_CLIENT_ID)
  nologging  local;
create index PAYMENT_TO_CLIENT_I on PAYMENT (TO_CLIENT_ID)
  nologging  local;
alter table PAYMENT
  add constraint PAYMENT_PK primary key (PAYMENT_ID);
alter table PAYMENT
  add constraint PAYMENT_CURRENCY_ID_FK foreign key (CURRENCY_ID)
  references CURRENCY (CURRENCY_ID);
alter table PAYMENT
  add constraint PAYMENT_FROM_CLIENT_ID_FK foreign key (FROM_CLIENT_ID)
  references CLIENT (CLIENT_ID);
alter table PAYMENT
  add constraint PAYMENT_TO_CLIENT_ID_FK foreign key (TO_CLIENT_ID)
  references CLIENT (CLIENT_ID);
alter table PAYMENT
  add constraint PAYMENT_REASON_CHK
  check ((status in (2,3) and status_change_reason is not null) or (status not in (2, 3)));
alter table PAYMENT
  add constraint PAYMENT_STATUS_CHK
  check (status in (0, 1, 2, 3, 4));
alter table PAYMENT
  add constraint PAYMENT_TECH_DATES_CHK
  check (create_dtime_tech <= update_dtime_tech);

prompt
prompt Creating table PAYMENT_DETAIL_FIELD
prompt ===================================
prompt
create table PAYMENT_DETAIL_FIELD
(
  field_id    NUMBER(10) not null,
  name        VARCHAR2(100 CHAR) not null,
  description VARCHAR2(200 CHAR) not null
)
;
comment on table PAYMENT_DETAIL_FIELD
  is 'Справочник полей данных платежа';
comment on column PAYMENT_DETAIL_FIELD.field_id
  is 'Уникальный ID поля';
comment on column PAYMENT_DETAIL_FIELD.name
  is 'Название - код';
comment on column PAYMENT_DETAIL_FIELD.description
  is 'Описание';
alter table PAYMENT_DETAIL_FIELD
  add constraint PAYMENT_DETAIL_FIELD_PK primary key (FIELD_ID);
alter table PAYMENT_DETAIL_FIELD
  add constraint PAYMENT_DETAIL_FIELD_NAME_CHK
  check (name = upper(name));

prompt
prompt Creating table PAYMENT_DETAIL
prompt =============================
prompt
create table PAYMENT_DETAIL
(
  payment_id           NUMBER(38) not null,
  payment_create_dtime TIMESTAMP(6) not null,
  field_id             NUMBER(10) not null,
  field_value          VARCHAR2(200 CHAR) not null
)
partition by range (PAYMENT_CREATE_DTIME) interval (NUMTODSINTERVAL(1,'DAY'))
(
  partition PMIN values less than (TIMESTAMP' 2023-01-01 00:00:00')
    tablespace users
);
comment on table PAYMENT_DETAIL
  is 'Детали платежа';
comment on column PAYMENT_DETAIL.payment_id
  is 'ID платежа';
comment on column PAYMENT_DETAIL.payment_create_dtime
  is 'Дата платежа';
comment on column PAYMENT_DETAIL.field_id
  is 'ID поля';
comment on column PAYMENT_DETAIL.field_value
  is 'Значение поля (сами данные)';
create unique index PAYMENT_DETAIL_DTIME_PAYMENT_ID_FIELD_ID_UQ on PAYMENT_DETAIL (PAYMENT_CREATE_DTIME, PAYMENT_ID, FIELD_ID)
  nologging  local;
alter table PAYMENT_DETAIL
  add constraint PAYMENT_DETAIL_FIELD_FK foreign key (FIELD_ID)
  references PAYMENT_DETAIL_FIELD (FIELD_ID)
  disable
  novalidate;

prompt
prompt Creating table TERRORIST
prompt ========================
prompt
create table TERRORIST
(
  first_name    VARCHAR2(100 CHAR) not null,
  last_name     VARCHAR2(100 CHAR) not null,
  birthday      DATE not null,
  reason        VARCHAR2(200 CHAR) not null,
  created_dtime DATE not null
)
;
create index TERRORIST_FLB_I on TERRORIST (REASON, BIRTHDAY, LAST_NAME, FIRST_NAME);

prompt
prompt Creating table WORD_BLACK_LIST
prompt ==============================
prompt
create table WORD_BLACK_LIST
(
  word_id NUMBER(38),
  word    VARCHAR2(1000 CHAR)
)
;

prompt
prompt Creating sequence ACCOUNT_SEQ
prompt =============================
prompt
create sequence ACCOUNT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 30957108
increment by 1
cache 100;

prompt
prompt Creating sequence CLIENT_SEQ
prompt ============================
prompt
create sequence CLIENT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 31057008
increment by 1
cache 100;

prompt
prompt Creating sequence EVENT_QUEUE_SEQ
prompt =================================
prompt
create sequence EVENT_QUEUE_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 2707
increment by 1
cache 100;

prompt
prompt Creating sequence PAYMENT_SEQ
prompt =============================
prompt
create sequence PAYMENT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 3200001
increment by 1
cache 100;

prompt
prompt Creating sequence WALLET_SEQ
prompt ============================
prompt
create sequence WALLET_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 30996908
increment by 1
cache 100;


prompt Done
spool off
set define on
