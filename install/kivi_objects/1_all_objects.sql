prompt PL/SQL Developer Export User Objects for user KIVI@CLO-ORA19EE-DB1
prompt Created by kivil on 18 Январь 2024 г.
set define off
spool all_objects.log

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
  references PAYMENT_DETAIL_FIELD (FIELD_ID);


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
start with 1
increment by 1
cache 100;

prompt
prompt Creating sequence CLIENT_SEQ
prompt ============================
prompt
create sequence CLIENT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;

prompt
prompt Creating sequence EVENT_QUEUE_SEQ
prompt =================================
prompt
create sequence EVENT_QUEUE_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;

prompt
prompt Creating sequence PAYMENT_SEQ
prompt =============================
prompt
create sequence PAYMENT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;

prompt
prompt Creating sequence PLSQL_PROFILER_RUNNUMBER
prompt ==========================================
prompt
create sequence PLSQL_PROFILER_RUNNUMBER
minvalue 1
maxvalue 9999999999999999999999999999
start with 3
increment by 1
nocache;

prompt
prompt Creating sequence WALLET_SEQ
prompt ============================
prompt
create sequence WALLET_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;

prompt
prompt Creating package ACCOUNT_API_PACK
prompt =================================
prompt
create or replace package account_api_pack is

  -- Author  : D.KIVILEV
  -- Purpose : API для работы с сущностью "Счет"

  -- Сообщения об ошибках
  c_error_msg_negative_value        constant varchar2(100 char) := 'Отрицательный баланс';
  c_error_code_balance_is_not_empty constant number(10) := -20111;
  c_error_msg_balance_is_not_empty  constant varchar2(100 char) := 'Баланс не нулевой';
  c_error_code_not_enough_balance   constant number(10) := -20112;
  c_error_msg_not_enough_balance    constant varchar2(100 char) := 'Не хватает баланса для списания';

  -- Коды валют
  c_currency_rub_id constant currency.currency_id%type := 643;
  c_currency_usd_id constant currency.currency_id%type := 840;
  c_currency_eur_id constant currency.currency_id%type := 978;

  -- Создание счета
  function create_account(p_client_id   account.client_id%type,
                          p_wallet_id   account.wallet_id%type,
                          p_currency_id account.currency_id%type,
                          p_balance     account.balance%type := 0)
    return account.account_id%type;

  -- перевод
  procedure transfer_money(p_wallet_from_id client.client_id%type,
                           p_wallet_to_id   client.client_id%type,
                           p_currency_id    account.currency_id%type,
                           p_summa          payment.summa%type);

end;
/

prompt
prompt Creating type T_CLIENT_DATA
prompt ===========================
prompt
create or replace type t_client_data is object
(
  field_id number(10),
  field_value varchar2(200 char)
);
/

prompt
prompt Creating type T_CLIENT_DATA_ARRAY
prompt =================================
prompt
create or replace type t_client_data_array is table of t_client_data
/

prompt
prompt Creating package CLIENT_API_PACK
prompt ================================
prompt
create or replace package client_api_pack is
  /*
  Автор: Кивилев Д.С.
  Описание: API для сущности "Клиент"
  */

  -- Статусы активности клиента
  c_active   constant client.is_active%type := 1;
  c_inactive constant client.is_active%type := 0;
  -- Статусы блокировки клиента
  c_not_blocked constant client.is_blocked%type := 0;
  c_blocked     constant client.is_blocked%type := 1;
  -- Поля клиента
  c_first_name_field_id constant client_data_field.field_id%type := 1;
  c_last_name_field_id constant client_data_field.field_id%type := 2;
  c_birthday_field_id    constant client_data_field.field_id%type := 3;
  c_passport_series_field_id constant client_data_field.field_id%type := 4;
  c_passport_number_field_id constant client_data_field.field_id%type := 5;
  c_email_field_id    constant client_data_field.field_id%type := 6;
  c_mobile_phone_field_id    constant client_data_field.field_id%type := 7;

  ---- API

  -- Создание клиента
  function create_client(p_client_data t_client_data_array) return client.client_id%type;

  -- Блокировка клиента
  procedure block_client(p_client_id client.client_id%type
                        ,p_reason    client.blocked_reason%type);


  -- Разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type);

  -- Клиент деактивирован
  procedure deactivate_client(p_client_id client.client_id%type);

  -- Блокировка клиента для изменений
  procedure try_lock_client(p_client_id client.client_id%type);


  ---- Триггеры

  -- Проверка, допустимость изменения клиента
  procedure is_changes_through_api;

  -- Проверка, на возможность удалять данные
  procedure check_client_delete_restriction;

end;
/

prompt
prompt Creating package CLIENT_CHECK_PACK
prompt ==================================
prompt
create or replace package client_check_pack is

  -- Author  : D.KIVILEV
  -- Created : 20.06.2023 10:48:48
  -- Purpose :

  function is_terrorist(p_client_id client.client_id%type) return boolean;

  function is_passport_limit_exceeded(p_client_id client.client_id%type
                                     ,p_limit     number) return boolean;

  function passport_in_blacklist(p_client_id client.client_id%type) return boolean;

end client_check_pack;
/

prompt
prompt Creating type T_NUMBER_ARRAY
prompt ============================
prompt
create or replace type t_number_array is table of number(38);
/

prompt
prompt Creating package CLIENT_DATA_API_PACK
prompt =====================================
prompt
create or replace package client_data_api_pack is

  /*
  Автор: Кивилев Д.С.
  Описание: API для сущностей "Клиентские данные"
  */

  -- Вставка/обновление клиентских данных
  procedure insert_or_update_client_data(p_client_id   client.client_id%type
                                        ,p_client_data t_client_data_array);

  -- Удаление клиентских данных
  procedure delete_client_data(p_client_id        client.client_id%type
                              ,p_delete_field_ids t_number_array);

  -- Выполняются ли изменения через API
  procedure is_changes_through_api;

end;
/

prompt
prompt Creating package CLIENT_MANAGE_PACK
prompt ===================================
prompt
create or replace package client_manage_pack is

  -- Author  : D.KIVILEV
  -- Created : 07.06.2023 21:53:53
  -- Purpose :

  c_default_currency_id currency.currency_id%type := account_api_pack.c_currency_rub_id;
  c_default_balance     account.balance%type := 0;

  function register_new_client(p_client_data t_client_data_array) return client.client_id%type;

end;
/

prompt
prompt Creating package COMMON_PACK
prompt ============================
prompt
create or replace package common_pack is

  -- Author  : D.KIVILEV
  -- Purpose : Common object, functionality

  -- Включение/отключение разрешения менять данные в ручную
  procedure enable_manual_changes;
  procedure disable_manual_changes;

  -- Разрешены ли ручные изменения на глобальном уровне сессии
  function is_manual_change_allowed return boolean;

end;
/

prompt
prompt Creating package COUNTRY_API_PACK
prompt =================================
prompt
create or replace package country_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 20.06.2023 9:27:12
  -- Purpose :

  function get_country(p_phone country_phone.phone_prefix%type) return country_phone.country_id%type;

  function get_currency(p_country_id country.id%type) return currency.currency_id%type;

end;
/

prompt
prompt Creating package EVENT_API_PACK
prompt ===============================
prompt
create or replace package event_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 20.06.2023 13:37:37
  -- Purpose :

  -- Event types
  c_client_registration constant event_queue.type%type := 0;

  -- Send registration message to queue
  procedure enqueue_message(p_object_id  event_queue.object_id%type
                           ,p_event_type event_queue.type%type);

end event_api_pack;
/

prompt
prompt Creating package EXCEPTION_PACK
prompt ===============================
prompt
create or replace package exception_pack is

  -- Author  : D.KIVILEV
  -- Created : 20.06.2023 9:36:35
  -- Purpose :

  -- Codes
  c_error_code_invalid_input_parameter   constant number(10) := -20101;
  c_error_code_delete_forbidden          constant number(10) := -20102;
  c_error_code_manual_changes            constant number(10) := -20103;
  c_error_code_inactive_object           constant number(10) := -20104;
  c_error_code_object_notfound           constant number(10) := -20105;
  c_error_code_object_already_locked     constant number(10) := -20106;
  c_error_code_object_already_exists     constant number(10) := -20107;
  c_error_code_country_not_supported     constant number(10) := -20108;
  c_error_code_object_check_failed       constant number(10) := -20109;
  c_error_code_payment_cant_be_processed constant number(10) := -20110;
  c_error_code_unexpected_error          constant number(10) := -20999;

  -- Messages
  c_error_msg_empty_field_id            constant varchar2(100 char) := 'Fild id can not be empty';
  c_error_msg_empty_field_value         constant varchar2(100 char) := 'Fild value can not be empty';
  c_error_msg_empty_collection          constant varchar2(100 char) := 'Collection is empty';
  c_error_msg_empty_object_id           constant varchar2(100 char) := 'Object id can not be empty';
  c_error_msg_empty_reason              constant varchar2(100 char) := 'Reason can not be empty';
  c_error_msg_delete_forbidden          constant varchar2(100 char) := 'Deleting object is forbidden';
  c_error_msg_manual_changes            constant varchar2(100 char) := 'Changes should be through API';
  c_error_msg_inactive_object           constant varchar2(100 char) := 'Object is in final state';
  c_error_msg_object_notfound           constant varchar2(100 char) := 'Object not found';
  c_error_msg_object_already_locked     constant varchar2(100 char) := 'Object already locked';
  c_error_msg_object_already_exists     constant varchar2(100 char) := 'Object already exists';
  c_error_msg_country_not_supported     constant varchar2(100 char) := 'Country is not supported yet';
  c_error_msg_object_check_failed       constant varchar2(100 char) := 'Object didn''t pass check(s)';
  c_error_msg_payment_cant_be_processed constant varchar2(100 char) := 'Payment can not be processed';
  c_error_msg_unexpected_error          constant varchar2(100 char) := 'Unexpected error';

  -- Exceptions
  e_invalid_input_parameter exception;
  pragma exception_init(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  e_delete_forbidden exception;
  pragma exception_init(e_delete_forbidden, c_error_code_delete_forbidden);
  e_manual_changes exception;
  pragma exception_init(e_manual_changes, c_error_code_manual_changes);
  e_object_notfound exception;
  pragma exception_init(e_object_notfound, c_error_code_object_notfound);
  e_row_locked exception;
  pragma exception_init(e_row_locked, -00054);
  e_object_already_locked exception;
  pragma exception_init(e_object_already_locked, c_error_code_object_already_locked);
  e_object_already_exists exception;
  e_country_not_found     exception;
  e_object_check_failed   exception;
  pragma exception_init(e_object_check_failed, c_error_code_object_check_failed);

end exception_pack;
/

prompt
prompt Creating type T_PAYMENT_DETAIL
prompt ==============================
prompt
create or replace type t_payment_detail is object(
  field_id number(10),
  field_value varchar2(200 char)
);
/

prompt
prompt Creating type T_PAYMENT_DETAIL_ARRAY
prompt ====================================
prompt
create or replace type t_payment_detail_array is table of t_payment_detail;
/

prompt
prompt Creating package PAYMENT_API_PACK
prompt =================================
prompt
create or replace package payment_api_pack is

  -- Statuses
  c_created             constant payment.status%type := 0;
  c_successful_finished constant payment.status%type := 1;
  c_failed              constant payment.status%type := 2;
  c_canceled            constant payment.status%type := 3;

  -- Fields
  с_client_software_field_id  constant payment_detail_field.field_id%type := 1;
  с_ip_field_id               constant payment_detail_field.field_id%type := 2;
  с_note_field_id             constant payment_detail_field.field_id%type := 3;
  с_is_checked_fraud_field_id constant payment_detail_field.field_id%type := 4;


  ---- API

  -- Создание платежа
  function create_payment(p_from_client_id payment.from_client_id%type
                         ,p_to_client_id   payment.to_client_id%type
                         ,p_currency_id    payment.currency_id%type
                         ,p_create_dtime   payment.create_dtime%type
                         ,p_summa          payment.summa%type
                         ,p_payment_detail t_payment_detail_array) return payment.payment_id%type;

  -- Сброс платежа в ошибку
  procedure fail_payment(p_payment_id payment.payment_id%type
                        ,p_reason     payment.status_change_reason%type);

  -- Отмена платежа
  procedure cancel_payment(p_payment_id payment.payment_id%type
                          ,p_reason     payment.status_change_reason%type);

  -- Завершение платежа
  procedure successful_finish_payment(p_payment_id payment.payment_id%type);

  ----
  -- Проверка выполняется ли через API
  procedure api_restriction;

  -- Проверка, на возможность удалять данные
  procedure check_payment_delete_restriction;

  -- Блокировка данных перед изменеием
  procedure try_lock_payment(p_payment_id payment.payment_id%type);

end;
/

prompt
prompt Creating package PAYMENT_CHECK_PACK
prompt ===================================
prompt
create or replace package payment_check_pack is

  -- Author  : D.KIVILEV
  -- Created : 05.07.2023 20:45:00
  -- Purpose : Payment check

  procedure check_payment(p_payment_id payment.payment_id%type);

end payment_check_pack;
/

prompt
prompt Creating package PAYMENT_DETAIL_API_PACK
prompt ========================================
prompt
create or replace package payment_detail_api_pack is

  -- Вставка или обновление данных платежа
  procedure insert_or_update_payment_detail(p_payment_id     payment.payment_id%type
                                           ,p_payment_dtime  payment.create_dtime%type
                                           ,p_payment_detail t_payment_detail_array);

  -- Удаление данных платежа
  procedure delete_payment_detail(p_payment_id       payment.payment_id%type
                                 ,p_payment_dtime    payment.create_dtime%type
                                 ,p_delete_field_ids t_number_array);

  -- Проверка выполняется ли через API
  procedure api_restriction;

end;
/

prompt
prompt Creating package PAYMENT_PROCESSING_PACK
prompt ========================================
prompt
create or replace package payment_processing_pack is

  -- Author  : D.KIVILEV
  -- Created : 04.07.2023 10:53:33
  -- Purpose :

  procedure processing(p_bulk_size number);

end payment_processing_pack;
/

prompt
prompt Creating package WALLET_API_PACK
prompt ================================
prompt
create or replace package wallet_api_pack is

  -- Author  : D.KIVILEV
  -- Purpose : API для работы с сущностью "Кошелек"

  -- Статусы кшелька
  c_wallet_status_active  constant wallet.status_id%type := 0;
  c_wallet_status_blocked constant wallet.status_id%type := 1;

  -- Создание кошелька
  function create_wallet(p_client_id wallet.client_id%type)
    return wallet.wallet_id%type;

  -- блокировка кошелька
  procedure block_wallet(p_wallet_id    wallet.wallet_id%type,
                         p_block_reason wallet.status_change_reason%type);

  -- разблокировка кошелька
  procedure unblock_wallet(p_wallet_id wallet.wallet_id%type);

end;
/

prompt
prompt Creating type T_NUMBER_PAIR
prompt ===========================
prompt
create or replace type t_number_pair as object
(
  first number(38),
  second number(38)
)
/

prompt
prompt Creating type T_NUMBER_PAIR_ARRAY
prompt =================================
prompt
create or replace type t_number_pair_array is table of t_number_pair;
/

prompt
prompt Creating type T_STRING_ARRAY
prompt ============================
prompt
create or replace type t_string_array is table of varchar2(4000 char);
/

prompt
prompt Creating function GET_CLIENT_NAME
prompt =================================
prompt
create or replace function get_client_name(p_client_id client.client_id%type)
  return varchar2 is
  pragma udf;
  v_name varchar2(4000 char);
begin
  select nvl(tn.field_value, ln.field_value || ' ' || fn.field_value) client_name
    into v_name
    from client c
    left join client_data ln
      on ln.client_id = c.client_id
     and ln.field_id = 5
    left join client_data fn
      on fn.client_id = c.client_id
     and fn.field_id = 6
    left join client_data tn
      on tn.client_id = c.client_id
     and tn.field_id = 9
   where c.client_id = p_client_id;

  return v_name;
end;
/

prompt
prompt Creating procedure CLEAR_PAYMENTS
prompt =================================
prompt
create or replace procedure clear_payments is
  c_days_left constant number(3) := 45;
  v_current_payment_count number(38);
begin
  select count(*)
    into v_current_payment_count
    from payment t
   where t.create_dtime < trunc(sysdate - c_days_left)
     and rownum < 2;

  if v_current_payment_count >= 1 then
    for p in (select to_char(trunc(create_dtime), 'yyyymmdd') pdate
                from payment t
               where t.create_dtime < trunc(sysdate - c_days_left)
               group by trunc(create_dtime)) loop
      execute immediate 'alter table payment drop partition for(to_date(' ||
                        p.pdate || ',''yyyymmdd'')) update global indexes';
    end loop;
  end if;
end;
/

prompt
prompt Creating procedure FILL_PAYMENTS
prompt ================================
prompt
create or replace procedure fill_payments is
  c_one_time_limit    constant number(10) := 5000;
  c_max_payment_count constant number(10) := 100000;
  v_current_payment_count number(38);
  c_days_left constant number(3) := 45;

  v_payment_ids   t_number_array;
  v_data_value    payment_detail.field_value%type;
  v_field_ids     t_number_array := t_number_array(1, 2, 3, 4);
  v_payment_dtime payment.create_dtime%type;

  v_client_id_min client.client_id%type;
  v_client_id_max client.client_id%type;
begin

  <<days_loop>>
  for dd in (with dth as
                (select trunc(sysdate - level + 1) dt
                  from dual
                connect by level <= c_days_left),
               cur_dates as
                (select trunc(create_dtime) dt
                      ,count(1) payment_count
                  from payment t
                 where t.create_dtime >= trunc(sysdate - c_days_left)
                 group by trunc(create_dtime))
               select dth.dt payment_day
                     ,nvl(t.payment_count, 0) payment_count
                 from dth
                 left join cur_dates t
                   on t.dt = dth.dt) loop
  
    v_current_payment_count := dd.payment_count;
  
    if v_current_payment_count < c_max_payment_count then
      begin
        select min(client_id)
              ,max(client_id)
          into v_client_id_min
              ,v_client_id_max
          from (select client_id
                  from client sample(1)
                 order by dbms_random.value())
         where rownum <= 2;
      
        select payment_seq.nextval
          bulk collect
          into v_payment_ids
          from dual
        connect by level <=
                   least((c_max_payment_count - v_current_payment_count),
                         c_one_time_limit);
      
        v_payment_dtime := dd.payment_day + dbms_random.value(1, 24) / 24;
      
        common_pack.enable_manual_changes;
      
        -- payment
        insert /*+ append */
        into payment
          (payment_id
          ,create_dtime
          ,summa
          ,currency_id
          ,from_client_id
          ,to_client_id
          ,status_change_reason
          ,status)
          select value(t)
                ,v_payment_dtime create_dtime
                ,round(dbms_random.value(0, 1000), 2) summa
                ,840
                ,trunc(dbms_random.value(v_client_id_min, v_client_id_max)) from_client_id
                ,trunc(dbms_random.value(v_client_id_min, v_client_id_max)) to_client_id
                ,decode(mod(rownum, 10), 1, 'reason', 2, 'reason', null) status_change_reason
                ,decode(mod(rownum, 10), 0, 0, 1, 2, 2, 3, 1) status
            from table(v_payment_ids) t;
      
        -- payment_detail
        v_data_value := dbms_random.string(opt => 'A', len => 10);
        insert /*+ append */
        into payment_detail
          (payment_id
          ,payment_create_dtime
          ,field_id
          ,field_value)
          select value(p)
                ,v_payment_dtime
                ,value(pd)
                ,v_data_value
            from table(v_payment_ids) p
           cross join table(v_field_ids) pd;
      
        commit;
      
      exception
        when others then
          dbms_output.put_line('Error: ' || sqlerrm);
      end;
    end if;
  
  end loop days_loop;

end;
/

prompt
prompt Creating package body ACCOUNT_API_PACK
prompt ======================================
prompt
create or replace package body account_api_pack is

  function create_account(p_client_id   account.client_id%type,
                          p_wallet_id   account.wallet_id%type,
                          p_currency_id account.currency_id%type,
                          p_balance     account.balance%type := 0)
    return account.account_id%type is
    v_account_id account.account_id%type;
  begin

    if p_balance < 0 then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              c_error_msg_negative_value);
    end if;

    begin
      insert into account
        (account_id, client_id, wallet_id, currency_id, balance)
      values
        (account_seq.nextval,
         p_client_id,
         p_wallet_id,
         p_currency_id,
         p_balance)
      returning account_id into v_account_id;
    exception
      when dup_val_on_index then
        -- такой счет уже есть в данном кошельке
        raise_application_error(exception_pack.c_error_code_object_already_exists,
                                exception_pack.c_error_msg_object_already_exists);
    end;

    return v_account_id;
  end;

  -- Блокировка счета для изменений
  procedure try_lock_account(p_wallet_id   client.client_id%type,
                             p_currency_id account.currency_id%type) is
  begin
    null;
  end;

  procedure update_balance(p_account_id account.account_id%type,
                           p_value      account.balance%type) is
  begin

    -- обновляем баланс на переданную величину
    update account a
       set a.balance = a.balance + p_value
     where a.account_id = p_account_id;

    -- используем атрибут курсора, чтобы понять был ли вообще update.
    if sql%rowcount = 0 then
      raise_application_error(exception_pack.c_error_code_object_notfound,
                              exception_pack.c_error_msg_object_notfound);
    end if;

  end;

  procedure transfer_money(p_wallet_from_id client.client_id%type,
                           p_wallet_to_id   client.client_id%type,
                           p_currency_id    account.currency_id%type,
                           p_summa          payment.summa%type) is
    v_balance_from    account.balance%type;
    v_balance_to      account.balance%type;
    v_account_id_from account.account_id%type;
    v_account_id_to   account.account_id%type;
  begin
    -- Блочим 1 баланс, с которого снимаем
    select ac.balance, ac.account_id
      into v_balance_from, v_account_id_from
      from account ac
     where ac.wallet_id = p_wallet_from_id
       and ac.currency_id = p_currency_id
       for update wait 2;

    -- проверяем хватил ли баланса для списания
    if (v_balance_from - p_summa < 0) then
      raise_application_error(c_error_code_not_enough_balance,
                              c_error_msg_not_enough_balance);
    end if;

    -- блочим 2 баланс, на который мы зачисляем
    select ac.balance, ac.account_id
      into v_balance_to, v_account_id_to
      from account ac
     where ac.wallet_id = p_wallet_to_id
       and ac.currency_id = p_currency_id
       for update wait 2;

    -- обновление балансоввв
    update_balance(p_account_id => v_account_id_from, p_value => -p_summa);
    update_balance(p_account_id => v_account_id_to, p_value => p_summa);

  end;

/*  procedure close_all_accounts(p_wallet_id account.wallet_id%type) is
    type t_account_balances is table of account.balance%type;
    v_account_balances t_account_balances;
  begin
    -- получаем текущие балансы и заодно блокируем, чтобы никто не смог изменить баланс
    select a.balance
      bulk collect
      into v_account_balances
      from account a
     where a.wallet_id = p_wallet_id
       for update;

    -- если коллекция пустая, то значит вообще нет никаких счетов, можно выходить -> закрывать нечего
    if v_account_balances is empty then
      return;
    end if;

    -- проверяем есть ли не нулевые балансы. если есть => выбрасываем исключение
    for i in v_account_balances.first .. v_account_balances.last loop
      if v_account_balances(i) <> 0 then
        raise_application_error(c_error_code_balance_is_not_empty,
                                c_error_msg_balance_is_not_empty);
      end if;
    end loop;

    delete from account a where a.wallet_id = p_wallet_id;

  end;*/

end;
/

prompt
prompt Creating package body CLIENT_API_PACK
prompt =====================================
prompt
create or replace package body client_api_pack is

  g_is_api boolean := false; -- признак, выполняется ли изменение через API

  -- разрешение менять данные
  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  -- запрет менять данные
  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  -- Создание клиента
  function create_client(p_client_data t_client_data_array) return client.client_id%type is
    v_client_id client.client_id%type;
  begin
    allow_changes();

    -- создание клиента
    insert into client
      (client_id
      ,is_active
      ,is_blocked
      ,blocked_reason)
    values
      (client_seq.nextval
      ,c_active
      ,c_not_blocked
      ,null)
    returning client_id into v_client_id;

    -- добавление клиентских данных
    client_data_api_pack.insert_or_update_client_data(p_client_id => v_client_id, p_client_data => p_client_data);

    disallow_changes();

    return v_client_id;

  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Блокировка клиента
  procedure block_client(p_client_id client.client_id%type
                        ,p_reason    client.blocked_reason%type) is
  begin
    if p_client_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_reason is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_reason);
    end if;

    try_lock_client(p_client_id); -- блокируем клиента

    allow_changes();

    -- обновление клиента
    update client cl
       set cl.is_blocked     = c_blocked
          ,cl.blocked_reason = p_reason
     where cl.client_id = p_client_id
       and cl.is_active = c_active;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Разблокировка клиента
  procedure unblock_client(p_client_id client.client_id%type) is
  begin
    if p_client_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    try_lock_client(p_client_id); -- блокируем клиента

    allow_changes();

    -- обновление клиента
    update client cl
       set cl.is_blocked     = c_not_blocked
          ,cl.blocked_reason = null
     where cl.client_id = p_client_id
       and cl.is_active = c_active;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Клиент деактивирован
  procedure deactivate_client(p_client_id client.client_id%type) is
  begin
    if p_client_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    try_lock_client(p_client_id); -- блокируем клиента

    allow_changes();

    -- обновление клиента
    update client cl
       set cl.is_active = c_inactive
     where cl.client_id = p_client_id
       and cl.is_active = c_active;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure is_changes_through_api is
  begin
    if not g_is_api
       and not common_pack.is_manual_change_allowed() then
      raise_application_error(exception_pack.c_error_code_manual_changes, exception_pack.c_error_msg_manual_changes);
    end if;
  end;

  procedure check_client_delete_restriction is
  begin
    if not common_pack.is_manual_change_allowed() then
      raise_application_error(exception_pack.c_error_code_delete_forbidden,
                              exception_pack.c_error_msg_delete_forbidden);
    end if;
  end;

  procedure try_lock_client(p_client_id client.client_id%type) is
    v_is_active client.client_id%type;
  begin
    -- пытаемся заблокировать клиента
    select cl.is_active into v_is_active from client cl where cl.client_id = p_client_id for update nowait;

    -- объект уже неактивен. с ним нельзя работать
    if v_is_active = c_inactive then
      raise_application_error(exception_pack.c_error_code_inactive_object, exception_pack.c_error_msg_inactive_object);
    end if;

  exception
    when no_data_found then
      -- такой клиент вообще не найден
      raise_application_error(exception_pack.c_error_code_object_notfound, exception_pack.c_error_msg_object_notfound);
    when exception_pack.e_row_locked then
      -- объект не удалось заблокировать
      raise_application_error(exception_pack.c_error_code_object_already_locked,
                              exception_pack.c_error_msg_object_already_locked);
  end;

end;
/

prompt
prompt Creating package body CLIENT_CHECK_PACK
prompt =======================================
prompt
create or replace package body client_check_pack is

  procedure get_passport_series_and_number(p_client_id        client.client_id%type
                                          ,po_passport_series out client_data.field_value%type
                                          ,po_passport_number out client_data.field_value%type) is
  begin
    select max(ser.field_value)
          ,max(num.field_value)
      into po_passport_series
          ,po_passport_number
      from client_data ser
      join client_data num
        on ser.client_id = num.client_id
       and num.field_id = client_api_pack.c_passport_number_field_id
     where ser.field_id = client_api_pack.c_passport_series_field_id
       and ser.client_id = p_client_id;
  end;

  function is_terrorist(p_client_id client.client_id%type) return boolean is
    v_cnt        number;
    v_birthday   client_data.field_value%type;
    v_last_name  client_data.field_value%type;
    v_first_name client_data.field_value%type;
  begin
    select max(fn.field_value)
          ,max(ln.field_value)
          ,max(bd.field_value)
      into v_first_name
          ,v_last_name
          ,v_birthday
      from client_data fn
      join client_data ln
        on ln.client_id = fn.client_id
       and ln.field_id = client_api_pack.c_last_name_field_id
      join client_data bd
        on bd.client_id = fn.client_id
       and bd.field_id = client_api_pack.c_birthday_field_id
     where fn.client_id = p_client_id
       and fn.field_id = client_api_pack.c_first_name_field_id;

    select /*+ index_ffs(t TERRORIST_FLB_I)*/
           count(*)
      into v_cnt
      from terrorist t
     where t.birthday = to_date(v_birthday, 'YYYY-MM-DD')
       and t.last_name = v_last_name
       and t.first_name = v_first_name;

    return v_cnt > 0;
  end;

  function is_passport_limit_exceeded(p_client_id client.client_id%type
                                     ,p_limit     number) return boolean is
    v_passport_series client_data.field_value%type;
    v_passport_number client_data.field_value%type;
    v_cnt             number;
  begin
    get_passport_series_and_number(p_client_id, v_passport_series, v_passport_number);

    select /*+ leading(num ser) use_hash(ser num)*/ count(1)
      into v_cnt
      from client_data ser
      join client_data num
        on num.client_id = ser.client_id
       and num.field_value = v_passport_number
       and num.field_id = client_api_pack.c_passport_number_field_id
     where ser.field_value = v_passport_series
       and ser.field_id = client_api_pack.c_passport_series_field_id
     group by ser.field_value
             ,num.field_value;

    return v_cnt > p_limit;
  end;

  function passport_in_blacklist(p_client_id client.client_id%type) return boolean is
    v_passport_series client_data.field_value%type;
    v_passport_number client_data.field_value%type;
    v_cnt             number;
  begin
    get_passport_series_and_number(p_client_id, v_passport_series, v_passport_number);

    select count(*) cnt
      into v_cnt
      from passport_black_list t
     where t.passport_series = v_passport_series
       and t.passport_number = v_passport_number;

    return v_cnt > 0;
  end;

end client_check_pack;
/

prompt
prompt Creating package body CLIENT_DATA_API_PACK
prompt ==========================================
prompt
create or replace package body client_data_api_pack is

  g_is_api boolean := false; -- признак выполняется ли изменения через API

  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  procedure insert_or_update_client_data(p_client_id   client.client_id%type
                                        ,p_client_data t_client_data_array) is
  begin
    if p_client_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_client_data is not empty then

      for i in p_client_data.first .. p_client_data.last loop

        if (p_client_data(i).field_id is null) then
          raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                                  exception_pack.c_error_msg_empty_field_id);
        end if;

        if (p_client_data(i).field_value is null) then
          raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                                  exception_pack.c_error_msg_empty_field_value);
        end if;
      end loop;
    else
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_collection);
    end if;

    -- попытка заблокировать клиента (защита от параллельных изменений)
    client_api_pack.try_lock_client(p_client_id);

    allow_changes();

    -- вставка/обновление данных
    merge into client_data o
    using (select p_client_id client_id
                 ,value      (t).field_id       field_id
                 ,value      (t).field_value       field_value
             from table(p_client_data) t) n
    on (o.client_id = n.client_id and o.field_id = n.field_id)
    when matched then
      update set o.field_value = n.field_value
    when not matched then
      insert
        (client_id
        ,field_id
        ,field_value)
      values
        (n.client_id
        ,n.field_id
        ,n.field_value);

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;
  end;

  -- Удаление клиентских данных
  procedure delete_client_data(p_client_id        client.client_id%type
                              ,p_delete_field_ids t_number_array) is
  begin
    if p_client_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_delete_field_ids is null
       or p_delete_field_ids is empty then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_collection);
    end if;

    -- попытка заблокировать клиента (защита от параллельных изменений)
    client_api_pack.try_lock_client(p_client_id);

    delete client_data cd
     where cd.client_id = p_client_id
       and cd.field_id in (select value(t) from table(p_delete_field_ids) t);

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure is_changes_through_api is
  begin
    if not g_is_api
       and not common_pack.is_manual_change_allowed() then
      raise_application_error(exception_pack.c_error_code_manual_changes, exception_pack.c_error_msg_manual_changes);
    end if;
  end;

end;
/

prompt
prompt Creating package body CLIENT_MANAGE_PACK
prompt ========================================
prompt
create or replace package body client_manage_pack is

  c_initial_balance                constant account.balance%type := 0;
  c_passport_limit_per_one_account constant account.balance%type := 3;

  function register_new_client(p_client_data t_client_data_array) return client.client_id%type is
    v_client_id                  client.client_id%type;
    v_wallet_id                  wallet.wallet_id%type;
    v_account_id                 account.account_id%type;
    v_client_is_active           client.is_active%type;
    v_mobile_phone               client_data.field_value%type;
    v_country_id                 country.id%type;
    v_currency_id                currency.currency_id%type;
    v_is_terrorist               boolean;
    v_is_passport_limit_exceeded boolean;
    v_is_passport_in_blacklist   boolean;

  begin
    if not p_client_data.exists(client_api_pack.c_mobile_phone_field_id)
       or not p_client_data.exists(client_api_pack.c_passport_series_field_id)
       or not p_client_data.exists(client_api_pack.c_passport_number_field_id)
       or not p_client_data.exists(client_api_pack.c_birthday_field_id) then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_field_value);
    end if;

    -- Get country and default currency by phone
    v_mobile_phone := '+' || ltrim(p_client_data(client_api_pack.c_mobile_phone_field_id).field_value, '+');
    v_country_id   := country_api_pack.get_country(v_mobile_phone);
    v_currency_id  := country_api_pack.get_currency(v_country_id);

    begin
      -- Search client with the same phone
      select cl.client_id
            ,cl.is_active
        into v_client_id
            ,v_client_is_active
        from client_data cd
        join client cl
          on cl.client_id = cd.client_id
       where cd.field_id = client_api_pack.c_mobile_phone_field_id
         and cd.field_value = v_mobile_phone
         and cl.is_active = client_api_pack.c_active;

      raise exception_pack.e_object_already_exists;

    exception
      when too_many_rows then
        raise_application_error(exception_pack.c_error_code_unexpected_error,
                                exception_pack.c_error_msg_unexpected_error);
      when no_data_found then
        -- Create client
        v_client_id := client_api_pack.create_client(p_client_data);
        client_api_pack.try_lock_client(v_client_id);
    end;

    -- Check client
    v_is_terrorist               := client_check_pack.is_terrorist(v_client_id);
    v_is_passport_limit_exceeded := client_check_pack.is_passport_limit_exceeded(v_client_id,
                                                                                 c_passport_limit_per_one_account);
    v_is_passport_in_blacklist   := client_check_pack.passport_in_blacklist(v_client_id);

    if (v_is_terrorist or v_is_passport_limit_exceeded or v_is_passport_in_blacklist) then
      client_api_pack.block_client(p_client_id => v_client_id,
                                   p_reason    => exception_pack.c_error_msg_object_check_failed);
      raise exception_pack.e_object_check_failed;
    end if;

    -- Create waller and account
    v_wallet_id  := wallet_api_pack.create_wallet(p_client_id => v_client_id);
    v_account_id := account_api_pack.create_account(p_client_id   => v_client_id,
                                                    p_wallet_id   => v_wallet_id,
                                                    p_currency_id => v_currency_id,
                                                    p_balance     => c_initial_balance);

    -- Send registration message to queue
    event_api_pack.enqueue_message(p_object_id  => to_char(v_client_id),
                                   p_event_type => event_api_pack.c_client_registration);

    return v_client_id;
  exception
    when exception_pack.e_object_already_exists then
      raise_application_error(exception_pack.c_error_code_object_already_exists,
                              exception_pack.c_error_msg_object_already_exists);
    when exception_pack.e_country_not_found then
      raise_application_error(exception_pack.c_error_code_country_not_supported,
                              exception_pack.c_error_msg_country_not_supported);
    when exception_pack.e_object_check_failed then
      raise_application_error(exception_pack.c_error_code_object_check_failed,
                              exception_pack.c_error_msg_object_check_failed);
  end;

end;
/

prompt
prompt Creating package body COMMON_PACK
prompt =================================
prompt
create or replace package body common_pack is

  g_enable_manual_changes boolean := false; -- включен ли флажок возможности "ручных" изменений

  procedure enable_manual_changes is
  begin
    -- здесь должна логироваться в спец таблицу информация по тому кто изменил этот флажок
    g_enable_manual_changes := true;
  end;

  procedure disable_manual_changes is
  begin
    -- здесь должна логироваться в спец таблицу информация по тому кто изменил этот флажок
    g_enable_manual_changes := false;
  end;

  function is_manual_change_allowed return boolean is
  begin
    return g_enable_manual_changes;
  end;

end common_pack;
/

prompt
prompt Creating package body COUNTRY_API_PACK
prompt ======================================
prompt
create or replace package body country_api_pack is

  function get_country(p_phone country_phone.phone_prefix%type) return country_phone.country_id%type is
    v_country_id country_phone.country_id%type;
    v_phone country_phone.phone_prefix%type := ltrim(p_phone, '+');
  begin
    select max(p.country_id)
      into v_country_id
      from country_phone p
     where p.phone_prefix = '+'||substr(v_phone, 1, length(v_phone) - 10);

    if v_country_id is null then
      raise exception_pack.e_country_not_found;
    end if;

    return v_country_id;
  end;

  function get_currency(p_country_id country.id%type) return currency.currency_id%type is
    v_currency_id currency.currency_id%type;
  begin
    select max(p.country_id)
      into v_currency_id
      from country_currency p
     where p.country_id = p_country_id;
    return v_currency_id;
  end;

end;
/

prompt
prompt Creating package body EVENT_API_PACK
prompt ====================================
prompt
create or replace package body event_api_pack is

  procedure enqueue_message(p_object_id  event_queue.object_id%type
                           ,p_event_type event_queue.type%type) is
  begin
    insert into event_queue
      (id
      ,type
      ,object_id
      ,create_dtime
      ,next_processing_date)
    values
      (event_queue_seq.nextval
      ,p_event_type
      ,p_object_id
      ,sysdate
      ,sysdate);
  end;

end event_api_pack;
/

prompt
prompt Creating package body PAYMENT_API_PACK
prompt ======================================
prompt
create or replace package body payment_api_pack is

  g_is_api boolean := false; -- признак, выполняется ли изменение через API

  -- Разрешение менять данные
  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  -- Запрет на изменение данных
  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  function create_payment(p_from_client_id payment.from_client_id%type
                         ,p_to_client_id   payment.to_client_id%type
                         ,p_currency_id    payment.currency_id%type
                         ,p_create_dtime   payment.create_dtime%type
                         ,p_summa          payment.summa%type
                         ,p_payment_detail t_payment_detail_array) return payment.payment_id%type is
    v_payment_id   payment.payment_id%type;
  begin

    -- Создание платежа
    allow_changes();

    insert into payment
      (payment_id
      ,create_dtime
      ,summa
      ,currency_id
      ,from_client_id
      ,to_client_id
      ,status)
    values
      (payment_seq.nextval
      ,p_create_dtime
      ,p_summa
      ,p_currency_id
      ,p_from_client_id
      ,p_to_client_id
      ,c_created)
    returning payment_id into v_payment_id;

    disallow_changes();

    -- Вставка данных платежа
    payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id     => v_payment_id,
                                                            p_payment_dtime  => p_create_dtime,
                                                            p_payment_detail => p_payment_detail);

    return v_payment_id;

  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure fail_payment(p_payment_id payment.payment_id%type
                        ,p_reason     payment.status_change_reason%type) is
  begin
    if p_payment_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_reason is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_reason);
    end if;

    try_lock_payment(p_payment_id); --блокировка

    allow_changes();

    update payment
       set status               = c_failed
          ,status_change_reason = p_reason
     where payment_id = p_payment_id
       and status = c_created;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;

  end;

  procedure cancel_payment(p_payment_id payment.payment_id%type
                          ,p_reason     payment.status_change_reason%type) is
  begin
    if p_payment_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_reason is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_reason);
    end if;

    try_lock_payment(p_payment_id); --блокировка

    allow_changes();

    update payment
       set status               = c_canceled
          ,status_change_reason = p_reason
     where payment_id = p_payment_id
       and status = c_created;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;

  end;

  procedure successful_finish_payment(p_payment_id payment.payment_id%type) is
  begin
    if p_payment_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    allow_changes();

    try_lock_payment(p_payment_id); --блокировка

    update payment p
       set status                 = c_successful_finished
          ,p.status_change_reason = null
     where payment_id = p_payment_id
       and status = c_created;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;

  end;

  procedure api_restriction is
  begin
    if not g_is_api
       and not common_pack.is_manual_change_allowed() then
      raise_application_error(exception_pack.c_error_code_manual_changes, exception_pack.c_error_msg_manual_changes);
    end if;
  end;

  procedure check_payment_delete_restriction is
  begin
    if not common_pack.is_manual_change_allowed() then
      raise_application_error(exception_pack.c_error_code_delete_forbidden,
                              exception_pack.c_error_msg_delete_forbidden);
    end if;
  end;

  procedure try_lock_payment(p_payment_id payment.payment_id%type) is
    v_is_active payment.payment_id%type;
  begin

    select status into v_is_active from payment t where t.payment_id = p_payment_id for update nowait;

    if v_is_active != c_created then
      raise_application_error(exception_pack.c_error_code_inactive_object, exception_pack.c_error_msg_inactive_object);
    end if;

  exception
    when no_data_found then
      raise_application_error(exception_pack.c_error_code_object_notfound, exception_pack.c_error_msg_object_notfound);
    when exception_pack.e_row_locked then
      raise_application_error(exception_pack.c_error_code_object_already_locked,
                              exception_pack.c_error_msg_object_already_locked);
  end;

end;
/

prompt
prompt Creating package body PAYMENT_CHECK_PACK
prompt ========================================
prompt
create or replace package body payment_check_pack is

  c_black_type_id ip_list.type%type := 'B';
  c_outcome_limit number(38) := 10000; -- 1K USD
  c_income_limit  number(38) := 10000; -- 2K USD

  procedure check_payment(p_payment_id payment.payment_id%type) is
    v_payment_details t_payment_detail_array;
    v_cnt             number;
    v_outcome_sum     payment.summa%type;
    v_income_sum      payment.summa%type;
    v_payment         payment%rowtype;
  begin
    select /*+ FULL(p)*/
     p.*
      into v_payment
      from payment p
     where p.payment_id = p_payment_id;

    select t_payment_detail(pd.field_id, pd.field_value)
      bulk collect
      into v_payment_details
      from payment_detail pd
     where pd.payment_id = p_payment_id;

    -- checking ip in black list
    if (v_payment_details.exists(payment_api_pack.с_ip_field_id)) then
      select count(*)
        into v_cnt
        from ip_list ip
       where ip.type = c_black_type_id
         and trim(ip.ip) = trim(v_payment_details(payment_api_pack.с_ip_field_id).field_value);

      if v_cnt <> 0 then
        raise_application_error(exception_pack.c_error_code_object_check_failed,
                                exception_pack.c_error_msg_object_check_failed);
      end if;
    end if;

    -- checking note
    if (v_payment_details.exists(payment_api_pack.с_note_field_id)) then
      select count(*)
        into v_cnt
        from word_black_list w
       where lower(v_payment_details(payment_api_pack.с_note_field_id).field_value) like lower('%' || w.word || '%');

      if v_cnt <> 0 then
        raise_application_error(exception_pack.c_error_code_object_check_failed,
                                exception_pack.c_error_msg_object_check_failed);
      end if;
    end if;

    -- month limit outcome (w/o convertation)
    select /*+ index(p PAYMENT_TO_CLIENT_I) */sum(p.summa)
      into v_outcome_sum
      from payment p
     where p.create_dtime >= trunc(sysdate) - 30
       and p.create_dtime < sysdate
       and p.status = payment_api_pack.c_successful_finished
       and p.from_client_id = v_payment.from_client_id;

    if v_outcome_sum >= c_outcome_limit then
      raise_application_error(exception_pack.c_error_code_object_check_failed,
                              exception_pack.c_error_msg_object_check_failed);
    end if;

    -- month limit income (w/o convertation)
    select /*+ index(p PAYMENT_FROM_CLIENT_I) */sum(p.summa)
      into v_income_sum
      from payment p
     where p.create_dtime >= trunc(sysdate) - 30
       and p.create_dtime < sysdate
       and p.status = payment_api_pack.c_successful_finished
       and p.to_client_id = v_payment.to_client_id;

    if v_income_sum >= c_income_limit then
      raise_application_error(exception_pack.c_error_code_object_check_failed,
                              exception_pack.c_error_msg_object_check_failed);
    end if;

  end;

end payment_check_pack;
/

prompt
prompt Creating package body PAYMENT_DETAIL_API_PACK
prompt =============================================
prompt
create or replace package body payment_detail_api_pack is

  g_is_api boolean := false; -- признак, выполняется ли изменение через API

  -- Разрешение менять данные
  procedure allow_changes is
  begin
    g_is_api := true;
  end;

  -- Запрет на изменение данных
  procedure disallow_changes is
  begin
    g_is_api := false;
  end;

  procedure insert_or_update_payment_detail(p_payment_id     payment.payment_id%type
                                           ,p_payment_dtime  payment.create_dtime%type
                                           ,p_payment_detail t_payment_detail_array) is
  begin
    if p_payment_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_payment_detail is not empty then
      for i in p_payment_detail.first .. p_payment_detail.last loop
        if p_payment_detail(i).field_id is null then
          raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                                  exception_pack.c_error_msg_empty_field_id);
        end if;

        if p_payment_detail(i).field_value is null then
          raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                                  exception_pack.c_error_msg_empty_field_value);
        end if;
      end loop;
    else
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_collection);
    end if;

    payment_api_pack.try_lock_payment(p_payment_id); -- блокировка платежа

    allow_changes();

    merge into payment_detail pd
    using (select p_payment_id    as payment_id
                 ,p_payment_dtime as payment_create_dtime
                 ,value          (t1).field_id           as field_id
                 ,value          (t1).field_value           as field_value
             from table(p_payment_detail) t1) t2
    on (pd.payment_id = t2.payment_id and pd.payment_create_dtime = t2.payment_create_dtime and pd.field_id = t2.field_id)
    when matched then
      update set pd.field_value = t2.field_value
    when not matched then
      insert
        (payment_id
        ,payment_create_dtime
        ,field_id
        ,field_value)
      values
        (t2.payment_id
        ,t2.payment_create_dtime
        ,t2.field_id
        ,t2.field_value);

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;

  end;

  procedure delete_payment_detail(p_payment_id       payment.payment_id%type
                                 ,p_payment_dtime    payment.create_dtime%type
                                 ,p_delete_field_ids t_number_array) is
  begin
    if p_payment_id is null then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_object_id);
    end if;

    if p_delete_field_ids is null
       or p_delete_field_ids is empty then
      raise_application_error(exception_pack.c_error_code_invalid_input_parameter,
                              exception_pack.c_error_msg_empty_collection);
    end if;

    payment_api_pack.try_lock_payment(p_payment_id); -- блокировка платежа

    allow_changes();

    delete payment_detail pd
     where pd.payment_id = p_payment_id
       and pd.field_id in (select value(t) from table(p_delete_field_ids) t)
       and pd.payment_create_dtime = p_payment_dtime;

    disallow_changes();

  exception
    when others then
      disallow_changes();
      raise;
  end;

  procedure api_restriction is
  begin
    if not g_is_api
       and not common_pack.is_manual_change_allowed() then
      raise_application_error(exception_pack.c_error_code_manual_changes, exception_pack.c_error_msg_manual_changes);
    end if;
  end;

end;
/

prompt
prompt Creating package body PAYMENT_PROCESSING_PACK
prompt =============================================
prompt
create or replace package body payment_processing_pack is

  function check_client_and_get_wallet(p_client_id client.client_id%type) return wallet.wallet_id%type is
    v_client_is_active client.is_active%type;
    v_client_blocked   client.is_blocked%type;
    v_wallet_id        wallet.wallet_id%type;
    v_wallet_status_id wallet.status_id%type;
  begin
    select /*+ index(w1 WALLET_CLIENT_FK) index(w2 WALLET_CLIENT_FK)*/
           cl.is_active
          ,cl.is_blocked
          ,w.wallet_id
          ,w.status_id
      into v_client_is_active
          ,v_client_blocked
          ,v_wallet_id
          ,v_wallet_status_id
      from client cl
      left join wallet w
        on w.client_id = cl.client_id
     where cl.client_id = p_client_id;

    if (v_client_is_active = client_api_pack.c_inactive or v_client_blocked = client_api_pack.c_not_blocked or
       v_wallet_status_id = wallet_api_pack.c_wallet_status_blocked) then
      raise_application_error(exception_pack.c_error_code_payment_cant_be_processed,
                              exception_pack.c_error_msg_payment_cant_be_processed);
    end if;

    return v_wallet_id;

  end;


  procedure processing(p_bulk_size number) is
    v_payment_ids    t_number_array;
    v_wallet_from_id wallet.wallet_id%type;
    v_wallet_to_id   wallet.wallet_id%type;
  begin
    select p.payment_id
      bulk collect
      into v_payment_ids
      from payment p
     where p.status = payment_api_pack.c_created
       and rownum <= p_bulk_size
       for update skip locked;

    if v_payment_ids is empty then
      return;
    end if;

    for p in (select /*+ cardinality(pi 1000) leading(p pi)*/
               p.payment_id
              ,p.currency_id
              ,p.summa
              ,p.from_client_id
              ,p.to_client_id
                from table(v_payment_ids) pi
                join payment p
                  on p.payment_id = value(pi)) loop
      begin
        dbms_application_info.set_action(action_name => 'process payment_id: ' || p.payment_id);

        v_wallet_from_id := check_client_and_get_wallet(p.from_client_id);
        v_wallet_to_id   := check_client_and_get_wallet(p.to_client_id);

        account_api_pack.transfer_money(p_wallet_from_id => v_wallet_from_id,
                                        p_wallet_to_id   => v_wallet_to_id,
                                        p_currency_id    => p.currency_id,
                                        p_summa          => p.summa);

        payment_api_pack.successful_finish_payment(p_payment_id => p.payment_id);
      exception
        when others then
          payment_api_pack.fail_payment(p_payment_id => p.payment_id,
                                        p_reason     => substr(sqlerrm || utl_tcp.crlf ||
                                                               dbms_utility.format_error_stack,
                                                               1,
                                                               200));
      end;
      dbms_application_info.set_action(action_name => null);

    end loop;

    commit;

  end;

end payment_processing_pack;
/

prompt
prompt Creating package body WALLET_API_PACK
prompt =====================================
prompt
create or replace package body wallet_api_pack is

  function create_wallet(p_client_id wallet.client_id%type)
    return wallet.wallet_id%type is
    v_new_wallet_id wallet.wallet_id%type;
  begin
    -- пытаемся сделать вставку в таблицу wallet
    begin
      insert into wallet
        (wallet_id, client_id, status_id, status_change_reason)
      values
        (wallet_seq.nextval, p_client_id, c_wallet_status_active, null)
      returning wallet_id into v_new_wallet_id;
    exception
      when dup_val_on_index then
        -- попытка создать повторно кошелек привязанный к этому клиенту
        raise_application_error(exception_pack.c_error_code_object_already_exists,
                                exception_pack.c_error_msg_object_already_exists);
    end;

    return v_new_wallet_id;
  end;

  -- приватная процедура по блокировке/разблокировке
  procedure block_unblock_wallet(p_wallet_id wallet.client_id%type,
                                 p_block     wallet.status_id%type,
                                 p_reason    wallet.status_change_reason%type) is
  begin
    update wallet w
       set w.status_id = p_block, w.status_change_reason = p_reason
     where w.wallet_id = p_wallet_id;

    if sql%rowcount = 0 then
      raise_application_error(exception_pack.c_error_code_object_notfound,
                              exception_pack.c_error_msg_object_notfound);
    end if;
  end;

  procedure block_wallet(p_wallet_id    wallet.wallet_id%type,
                         p_block_reason wallet.status_change_reason%type) is
  begin
    -- вызываем приватную процедуру
    block_unblock_wallet(p_wallet_id,
                         c_wallet_status_blocked,
                         p_block_reason);
  end;

  procedure unblock_wallet(p_wallet_id wallet.wallet_id%type) is
  begin
    -- вызываем приватную процедуру
    block_unblock_wallet(p_wallet_id, c_wallet_status_active, null);
  end;

end wallet_api_pack;
/

prompt
prompt Creating trigger CLIENT_B_D_RESTRICT
prompt ====================================
prompt
create or replace trigger client_b_d_restrict
  before delete on client
begin
  client_api_pack.check_client_delete_restriction();
end;
/

prompt
prompt Creating trigger CLIENT_B_IU_API
prompt ================================
prompt
create or replace trigger client_b_iu_api
  before insert or update on client
begin
  client_api_pack.is_changes_through_api(); -- проверяем выполняется ли изменение через API
end;
/

prompt
prompt Creating trigger CLIENT_B_IU_TECH_FIELDS
prompt ========================================
prompt
create or replace trigger client_b_iu_tech_fields
  before insert or update on client
  for each row
declare
  v_current_timestamp client.create_dtime_tech%type := systimestamp;
begin
  if inserting then
    :new.create_dtime_tech := v_current_timestamp;
  end if;
  :new.update_dtime_tech := v_current_timestamp;
end;
/

prompt
prompt Creating trigger CLIENT_DATA_B_IU_API
prompt =====================================
prompt
create or replace trigger client_data_b_iu_api
  before insert or update on client_data
begin
  client_data_api_pack.is_changes_through_api(); -- проверяем выполняется ли изменение через API
end;
/

prompt
prompt Creating trigger PAYMENT_B_D_RESTRICT
prompt =====================================
prompt
create or replace trigger payment_b_d_restrict
before
delete
on payment
begin
  payment_api_pack.check_payment_delete_restriction();
end;
/

prompt
prompt Creating trigger PAYMENT_B_IU_API
prompt =================================
prompt
create or replace trigger payment_b_iu_api
before
insert or update
on payment
begin
  payment_api_pack.api_restriction();
end;
/

prompt
prompt Creating trigger PAYMENT_B_IU_TECH_FIELDS
prompt =========================================
prompt
create or replace trigger payment_b_iu_tech_fields
before
insert or update
on payment
for each row
declare
  v_current_dtime payment.update_dtime_tech%type := systimestamp;
begin
  if inserting then
    :new.create_dtime_tech := v_current_dtime;
  end if;

  :new.update_dtime_tech := v_current_dtime;
end;
/

prompt
prompt Creating trigger WALLET_B_IU_TECH_FIELDS
prompt ========================================
prompt
create or replace trigger wallet_b_iu_tech_fields
  before insert or update on wallet
  for each row
declare
  v_dt wallet.create_dtime_tech%type := systimestamp;
begin
  if inserting
  then
    :new.create_dtime_tech := v_dt;
  end if;
  :new.update_dtime_tech := v_dt;
end;
/

prompt
prompt JOBS
prompt ========================================
prompt
begin
  sys.dbms_scheduler.create_job(job_name            => 'KIVI.CLEAR_PAYMENTS_JOB',
                                job_type            => 'STORED_PROCEDURE',
                                job_action          => 'clear_payments',
                                start_date          => systimestamp + interval '1' minute ,
                                repeat_interval     => 'freq=hourly; byminute=0',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => 'Clear payments every hour');
end;
/
begin
  sys.dbms_scheduler.create_job(job_name            => 'KIVI.FILL_PAYMENT_JOB',
                                job_type            => 'STORED_PROCEDURE',
                                job_action          => 'fill_payments',
                                start_date          => systimestamp + interval '1' minute ,
                                repeat_interval     => 'freq=hourly; byminute=0',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => 'Fill payments every hour');
end;
/


prompt Done
spool off
set define on
