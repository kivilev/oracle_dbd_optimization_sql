
ALTER SESSION SET CURRENT_SCHEMA=HR;
ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

rem =======================================================
rem create HR schema objects
rem =======================================================

@@hr_create.sql

rem =======================================================
rem populate tables with data
rem =======================================================

@@hr_populate.sql

rem =======================================================
rem create procedural objects
rem =======================================================

@@hr_code.sql

rem =======================================================
rem installation validation
rem =======================================================

SET HEADING ON
rem reactivated by sub-scripts, turn it off again.
SET FEEDBACK OFF

SELECT 'Verification:' AS "Installation verification" FROM dual;

SELECT 'regions' AS "Table", 5 AS "provided", count(1) AS "actual" FROM hr.regions
UNION ALL
SELECT 'countries' AS "Table", 25 AS "provided", count(1) AS "actual" FROM hr.countries
UNION ALL
SELECT 'departments' AS "Table", 27 AS "provided", count(1) AS "actual" FROM hr.departments
UNION ALL
SELECT 'locations' AS "Table", 23 AS "provided", count(1) AS "actual" FROM hr.locations
UNION ALL
SELECT 'employees' AS "Table", 107 AS "provided", count(1) AS "actual" FROM hr.employees
UNION ALL
SELECT 'jobs' AS "Table", 19 AS "provided", count(1) AS "actual" FROM hr.jobs
UNION ALL
SELECT 'job_history' AS "Table", 10 AS "provided", count(1) AS "actual" FROM hr.job_history;

rem
rem Installation finish text.
rem
rem the SELECT '' FROM DUAL statements serve to print new lines
rem and make the output more readable.
rem

SELECT 'The installation of the sample schema is now finished.'  AS "Thank you!"
   FROM dual
UNION ALL
SELECT 'Please check the installation verification output above.' AS "Thank you!"
   FROM dual
UNION ALL
SELECT '' AS "Thank you!"
   FROM dual
UNION ALL
SELECT 'You will now be disconnected from the database.' AS "Thank you!"
   FROM dual
UNION ALL
SELECT '' AS "Thank you!"
   FROM dual
UNION ALL
SELECT 'Thank you for using Oracle Database!' AS "Thank you!"
   FROM dual
UNION ALL
SELECT '' AS "Thank you!"
   FROM dual;

rem stop writing to the log file
spool off

rem
rem Exit from the session.
rem Use 'exit' and not 'disconnect' to keep behavior the same for when errors occur.
rem
exit
