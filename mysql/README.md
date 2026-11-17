# MySQL

当前使用 `mysql:8.4` 的本地学习容器，Compose 配置在仓库根目录。

## 专题

- [01-basics](01-basics/)：基础表设计、查询、JOIN 与聚合（已有可运行的 SQL 脚本）。
- 索引与执行计划：后续增加覆盖索引、联合索引和回表实验。
- 事务与隔离：后续增加双会话、脏读/不可重复读/幻读和锁实验。
- 性能分析：后续增加慢查询、分页与索引选择实验。

## 运行

按 [仓库根目录 README](../README.md) 启动 Docker 和 MySQL，然后在交互客户端运行：

```sql
SOURCE /lab/sql/01-basics/01-schema.sql;
SOURCE /lab/sql/01-basics/02-queries.sql;
```

不要连接真实数据库运行实验脚本。第一份 SQL 会重建练习表。
