-- Создание интервально секционированной таблицы
CREATE TABLE payments (
    payment_id NUMBER,
    payment_date DATE,
    amount NUMBER(10,2),
    customer_id NUMBER
)
PARTITION BY RANGE (payment_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))
(
    PARTITION p_initial VALUES LESS THAN (TO_DATE('2024-02-01', 'YYYY-MM-DD'))
);

-- Вставка 10 строк данных
INSERT ALL
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (1, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 100.00, 1001)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (2, TO_DATE('2024-02-20', 'YYYY-MM-DD'), 150.50, 1002)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (3, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 200.75, 1003)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (4, TO_DATE('2024-04-05', 'YYYY-MM-DD'), 75.25, 1004)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (5, TO_DATE('2024-05-12', 'YYYY-MM-DD'), 300.00, 1005)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (6, TO_DATE('2024-06-18', 'YYYY-MM-DD'), 125.50, 1006)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (7, TO_DATE('2024-07-22', 'YYYY-MM-DD'), 180.00, 1007)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (8, TO_DATE('2024-08-30', 'YYYY-MM-DD'), 90.75, 1008)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (9, TO_DATE('2024-09-14', 'YYYY-MM-DD'), 250.25, 1009)
    INTO payments (payment_id, payment_date, amount, customer_id) VALUES (10, TO_DATE('2024-10-01', 'YYYY-MM-DD'), 175.00, 1010)
SELECT * FROM dual;

-- Запрос по ключу секционирования
SELECT * FROM payments
WHERE payment_date BETWEEN TO_DATE('2024-03-01', 'YYYY-MM-DD') AND TO_DATE('2024-05-31', 'YYYY-MM-DD');

-- Запрос без использования ключа секционирования
SELECT * FROM payments
WHERE amount > 200;

-- Запрос с использованием ключа секционирования через Bind переменную
VARIABLE v_date DATE;
EXEC :v_date := TO_DATE('2024-06-01', 'YYYY-MM-DD');

SELECT * FROM payments
WHERE payment_date = :v_date;

-- Запрос с использованием ключа секционирования через литерал и равенство
SELECT * FROM payments
WHERE payment_date = TO_DATE('2024-07-22', 'YYYY-MM-DD');

-- Запрос с использованием ключа секционирования через литерал и равенство (альтернативный формат даты)
SELECT * FROM payments
WHERE payment_date = DATE '2024-08-30';
