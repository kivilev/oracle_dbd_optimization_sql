BEGIN
  DBMS_STATS.DELETE_TABLE_STATS('OE','ORDERS');
END;
/
Lock the statistics for the oe table.

For example, execute the following procedure:

BEGIN
  DBMS_STATS.LOCK_TABLE_STATS('OE','ORDERS');
END;
/