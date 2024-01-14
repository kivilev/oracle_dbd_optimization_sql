---- Создание PLUSTRACE роли
-- 1) из папки на сервере/клиенте
@%oracle_home%\sqlplus\admin\plustrce.sql;
-- 2) в репе взять plustrce.sql


---- Даем гранты все пользователям (на PROD тому кому нужно)
 grant plustrace to public;


set autotrace traceonly statistics; -- только статистика
 
set autotrace traceonly; -- статистика + план



/*

	recursive calls: Количество рекурсивных вызовов (например, для поддержки контекста сессии).

	db block gets: Количество логических I/O-операций (чтение блоков данных).

	consistent gets: Количество логических I/O-операций для получения стабильного изображения данных.

	physical reads: Количество физических I/O-операций (чтение физических блоков данных с диска).

	redo size: Объем информации в журнале изменений, который необходим для воссоздания изменений в случае сбоя.

	bytes sent via SQL*Net to client: Объем данных, отправленных клиенту через SQL*Net.

	bytes received via SQL*Net from client: Объем данных, полученных от клиента через SQL*Net.

	SQL*Net roundtrips to/from client: Количество обменов между сервером и клиентом через SQL*Net.

*/