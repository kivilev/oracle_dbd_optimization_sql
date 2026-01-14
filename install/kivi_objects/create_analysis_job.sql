BEGIN
  -- First, check if the job already exists and drop it if it does
  BEGIN
    DBMS_SCHEDULER.DROP_JOB(job_name => 'CLIENT_WALLET_ANALYSIS_JOB');
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- Job doesn't exist, continue
  END;

  -- Create the job to run client_wallet_analysis_proc every hour
  DBMS_SCHEDULER.CREATE_JOB(
    job_name            => 'CLIENT_WALLET_ANALYSIS_JOB',
    job_type            => 'STORED_PROCEDURE',
    job_action          => 'client_wallet_analysis_proc',
    start_date          => SYSTIMESTAMP,
    repeat_interval     => 'FREQ=HOURLY; INTERVAL=1',
    end_date            => NULL,
    enabled             => TRUE,
    auto_drop           => FALSE,
    comments            => 'Job to analyze client wallet data hourly for business intelligence'
  );
  
  DBMS_OUTPUT.PUT_LINE('Job CLIENT_WALLET_ANALYSIS_JOB created successfully');
END;
/ 