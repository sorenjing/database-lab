# 01 · SQL 基础：客户与订单

目标：理解 `CREATE TABLE`、主键、外键、联合索引、`SELECT`、`JOIN`、`GROUP BY` 和 `EXPLAIN`。

## 执行顺序

1. [01-schema.sql](01-schema.sql)：**会删除并重建** `shop_orders` 与 `shop_customers`，随后插入示例数据。仅在本地 `lab_db` 执行。
2. [02-queries.sql](02-queries.sql)：查询已付款订单、按客户聚合金额，并查看索引计划。

进入本项目 MySQL 容器后：

```sql
SOURCE /lab/sql/01-basics/01-schema.sql;
SOURCE /lab/sql/01-basics/02-queries.sql;
```

## 需要思考的问题

- 为什么外键字段通常需要支持查找的索引？
- `WHERE customer_id = ? ORDER BY created_at` 可能如何利用联合索引？
- `LEFT JOIN` 与 `INNER JOIN` 对没有订单的客户有什么不同？
- 很少的示例数据无法证明某个索引一定更快；`EXPLAIN` 应结合数据规模和真实执行指标理解。
