prompt PL/SQL Developer Export User Objects for user KIVI@ORACLE19EE
prompt Created by d.kivilev on 7 Июль 2023 г.
set define off
spool plsql_objects.log

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

    select /*+ index(t TERRORIST_FLB_I)*/
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

    select count(1)
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
         and cl.is_active = client_api_pack.c_active
         for update of cl.client_id nowait;

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
  c_outcome_limit number(38) := 1000; -- 1K USD
  c_income_limit  number(38) := 2000; -- 2K USD

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
     where p.create_dtime >= trunc(sysdate, 'mm')
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
     where p.create_dtime >= trunc(sysdate, 'mm')
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


prompt Done
spool off
set define on
