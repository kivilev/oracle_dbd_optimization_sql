--
-- Copyright (c) 1995, 2020, Oracle and/or its affiliates. 
-- NAME
--   plustrce.sql
--
-- DESCRIPTION
--   Creates a role with access to Dynamic Performance Tables
--   for the SQL*Plus SET AUTOTRACE ... STATISTICS command.
--   After this script has been run, each user requiring access to
--   the AUTOTRACE feature should be granted the PLUSTRACE role by
--   the DBA.
--
-- USAGE
--   sqlplus "sys/<password> as sysdba" @plustrce
--
--   Catalog.sql must have been run before this file is run.
--   This file must be run while connected to a DBA schema.

set echo on

drop role plustrace;
create role plustrace;

grant select on v_$sesstat to plustrace;
grant select on v_$statname to plustrace;
grant select on v_$mystat to plustrace;
grant plustrace to dba with admin option;

set echo off
