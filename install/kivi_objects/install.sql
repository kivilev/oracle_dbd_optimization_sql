set define off
spool install.log

prompt
prompt Creating tables
prompt =================================
prompt
@@objects.sql

prompt
prompt Fill dictionaries 
prompt =================================
prompt
@@data_dicts.sql

prompt
prompt Creating plsql objects
prompt =================================
prompt
@@plsql_objects.sql





prompt Done
spool off
set define on
