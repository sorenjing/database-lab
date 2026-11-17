-- WARNING: training data only. This script DROPS and recreates two lab tables.
-- Run only in the local lab_db database, never in a production database.

DROP TABLE IF EXISTS shop_orders;
DROP TABLE IF EXISTS shop_customers;

CREATE TABLE shop_customers (
    id BIGINT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    city VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE shop_orders (
    id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL,
    CONSTRAINT fk_shop_orders_customer
        FOREIGN KEY (customer_id) REFERENCES shop_customers(id),
    INDEX idx_shop_orders_customer_created (customer_id, created_at)
) ENGINE=InnoDB;

INSERT INTO shop_customers (id, name, city) VALUES
    (1, 'Alice', 'Chengdu'),
    (2, 'Bob', 'Taiyuan'),
    (3, 'Chen', 'Suzhou'),
    (4, 'Dana', 'Chengdu');

INSERT INTO shop_orders (id, customer_id, total_amount, status, created_at) VALUES
    (101, 1, 99.00, 'PAID', '2026-01-01 10:00:00'),
    (102, 1, 10.00, 'CANCELLED', '2026-01-02 11:00:00'),
    (103, 2, 30.50, 'PAID', '2026-01-03 12:00:00'),
    (104, 3, 48.00, 'PENDING', '2026-01-04 13:00:00');
