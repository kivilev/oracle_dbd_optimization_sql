-- Создание list секционированной таблицы
CREATE TABLE payments (
    payment_id NUMBER,
    payment_date DATE,
    amount NUMBER(10,2),
    customer_id NUMBER,
    state VARCHAR2(2)
)
PARTITION BY LIST (state)
AUTOMATIC
(
    PARTITION p_ca VALUES ('CA'),
    PARTITION p_ny VALUES ('NY'),
    PARTITION p_tx VALUES ('TX')
);

-- Вставка 10 строк данных
INSERT ALL
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (1, DATE '2024-01-15', 100.00, 1001, 'CA')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (2, DATE '2024-02-20', 150.50, 1002, 'NY')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (3, DATE '2024-03-10', 200.75, 1003, 'TX')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (4, DATE '2024-04-05', 75.25, 1004, 'CA')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (5, DATE '2024-05-12', 300.00, 1005, 'NY')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (6, DATE '2024-06-18', 125.50, 1006, 'FL')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (7, DATE '2024-07-22', 180.00, 1007, 'TX')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (8, DATE '2024-08-30', 90.75, 1008, 'WA')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (9, DATE '2024-09-14', 250.25, 1009, 'CA')
    INTO payments (payment_id, payment_date, amount, customer_id, state) VALUES (10, DATE '2024-10-01', 175.00, 1010, 'OR')
SELECT * FROM dual;

-- Запрос с использованием ключа секционирования (эффективный)
SELECT * FROM payments
WHERE state = 'CA';

-- Запрос без использования ключа секционирования (менее эффективный)
SELECT * FROM payments
WHERE amount > 200;

-- Запрос с использованием ключа секционирования через Bind переменную
VARIABLE v_state VARCHAR2(2);
EXEC :v_state := 'NY';

SELECT * FROM payments
WHERE state = :v_state;

-- Запрос системных представлений для получения информации о секциях
SELECT table_name, partition_name, high_value
FROM user_tab_partitions
WHERE table_name = 'PAYMENTS'
ORDER BY partition_position;
