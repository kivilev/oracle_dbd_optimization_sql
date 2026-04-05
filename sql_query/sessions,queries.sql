/*
Course: Oracle SQL Optimization. Basic
Author: Denis Kivilev (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

Description: Sessions

*/

---- Пример 1. Информация по сессиям

select * from v$session;

select * from v$process;

select s.sid, -- session identifier
       s.serial#, -- session serial number
       p.spid, -- operating system process identifier
       p.pid, -- oracle process identifier
       s.username, -- oracle db username
       s.osuser, -- operating system client user name
       s.terminal, -- operating system terminal name
       s.program, -- operating system program name
       s.status -- status of the session.active,inactive,killed,cached,sniped
from   v$session s, v$process p
where  p.addr = s.paddr
and    s.type != 'BACKGROUND';

