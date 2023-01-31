SELECT
    *
FROM
    V$EVENT_NAME
WHERE
    WAIT_CLASS = 'Idle';