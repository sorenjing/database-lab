-- 1) Simple filtering and ordering
SELECT id, customer_id, total_amount
FROM shop_orders
WHERE status = 'PAID'
ORDER BY total_amount DESC;

-- 2) INNER JOIN: customers with paid orders
SELECT c.name, o.id AS order_id, o.total_amount
FROM shop_customers AS c
JOIN shop_orders AS o ON o.customer_id = c.id
WHERE o.status = 'PAID'
ORDER BY o.id;

-- 3) LEFT JOIN: include customers without orders
SELECT c.id, c.name, COUNT(o.id) AS order_count
FROM shop_customers AS c
LEFT JOIN shop_orders AS o ON o.customer_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;

-- 4) Aggregate paid amounts by customer
SELECT c.name, SUM(o.total_amount) AS paid_total
FROM shop_customers AS c
JOIN shop_orders AS o ON o.customer_id = c.id
WHERE o.status = 'PAID'
GROUP BY c.id, c.name
ORDER BY paid_total DESC;

-- 5) Inspect the candidate composite index (small data may use a table scan)
EXPLAIN
SELECT id, created_at, total_amount
FROM shop_orders
WHERE customer_id = 1
ORDER BY created_at DESC
LIMIT 5;
