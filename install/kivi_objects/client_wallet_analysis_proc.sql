create or replace procedure client_wallet_analysis_proc is
  /*
    Purpose: Performs comprehensive analysis of client wallets and payment activity
  
    This procedure analyzes client financial data for business intelligence purposes:
    - Evaluates active client base
    - Analyzes wallet statuses and account distribution
    - Examines payment patterns and currency usage
    - Identifies high-value clients and blocked accounts
    - Generates data for financial reporting dashboards
  */
  v_active_client_count number;
  v_active_wallet_count number;
  v_total_account_count number;
  v_successful_payments number;
  v_client_id           client.client_id%type;
  v_wallet_id           wallet.wallet_id%type;
  v_usd_currency_id     currency.currency_id%type;

  -- Collections to store analysis results
  type currency_distribution_rec is record(
     currency_code char(3 char)
    ,account_count number);
  type currency_distribution_tab is table of currency_distribution_rec index by pls_integer;
  v_currency_distribution currency_distribution_tab;

  type risk_client_rec is record(
     client_id    number(30)
    ,block_reason varchar2(200 char));
  type risk_client_tab is table of risk_client_rec index by pls_integer;
  v_risk_clients risk_client_tab;

  type recent_transaction_rec is record(
     payment_id  number(38)
    ,amount      number(30, 2)
    ,currency    char(3 char)
    ,create_date timestamp(6));
  type recent_transaction_tab is table of recent_transaction_rec index by pls_integer;
  v_recent_transactions recent_transaction_tab;

  type client_profile_rec is record(
     field_name  varchar2(100 char)
    ,field_value varchar2(200 char));
  type client_profile_tab is table of client_profile_rec index by pls_integer;
  v_client_profile client_profile_tab;

  type payment_client_mapping_rec is record(
     payment_id  number(38)
    ,client_name varchar2(200 char));
  type payment_client_mapping_tab is table of payment_client_mapping_rec index by pls_integer;
  v_payment_client_mapping payment_client_mapping_tab;

begin
  -- Query 1: Count active clients for customer base analysis
  select count(*)
    into v_active_client_count
    from client
   where is_active = 1;

  -- Query 2: Count active wallets for transaction capacity analysis
  select count(*)
    into v_active_wallet_count
    from wallet w
   where status_id = 0;

  -- Query 3: Get USD currency ID for international payment analysis
  select currency_id
    into v_usd_currency_id
    from currency
   where alfa3 = 'USD';

  -- Query 4: Count successful payments for transaction volume analysis
  select count(*) into v_successful_payments from payment where status = 1;

  -- Query 5: Identify highest-value client for VIP customer analysis
  begin
    select c.client_id
      into v_client_id
      from client c
      join wallet w
        on w.client_id = c.client_id
      join account a
        on a.wallet_id = w.wallet_id
     where c.is_active = 1
       and a.currency_id = 840 -- USD
     order by a.balance desc
     fetch first 1 row only;
  exception
    when no_data_found then
      v_client_id := null;
  end;

  -- Query 6: Cross-reference payments with client data for transaction audit
  -- This query maps payment transactions to client information for compliance reporting
  select /*+ FULL(cd)*/p.payment_id
        ,cd.field_value
    bulk collect
    into v_payment_client_mapping
    from payment     p
        ,client_data cd
   where p.status = 1
     and cd.field_id = 1
     and p.from_client_id = cd.client_id;

  -- Query 7: Analyze currency distribution across accounts
  select c.alfa3
        ,count(a.account_id) as account_count
    bulk collect
    into v_currency_distribution
    from account a
    join currency c
      on a.currency_id = c.currency_id
   group by c.alfa3
   order by count(a.account_id) desc;

  -- Query 8: Identify clients with blocked wallets for risk assessment
  select c.client_id
        ,w.status_change_reason
    bulk collect
    into v_risk_clients
    from client c
    join wallet w
      on c.client_id = w.client_id
   where w.status_id = 1
     and rownum <= 5;

  -- Query 9: Analyze recent payment activity for trend analysis
  select p.payment_id
        ,p.summa
        ,c.alfa3
        ,p.create_dtime
    bulk collect
    into v_recent_transactions
    from payment p
    join currency c
      on p.currency_id = c.currency_id
   where p.create_dtime > trunc(sysdate) - 7
   order by p.create_dtime desc
   fetch first 5 rows only;

  -- Query 10: Retrieve client profile data for customer verification
  begin
    select client_id into v_client_id from client where rownum = 1;
  
    select cdf.name
          ,cd.field_value
      bulk collect
      into v_client_profile
      from client_data cd
      join client_data_field cdf
        on cd.field_id = cdf.field_id
     where cd.client_id = v_client_id;
  exception
    when no_data_found then
      null;
  end;

  -- Results would typically be processed here for reporting or further analysis

end client_wallet_analysis_proc;
/
