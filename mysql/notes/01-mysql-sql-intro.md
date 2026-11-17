# 01 · MySQL、数据库、表与 SQL 基础

> 学习时间：2026-11-17  
> 状态：**已讲解，待本地实操验证**。本笔记不是实验成功记录。  
> 环境基线：仓库 `compose.yaml` 使用 `mysql:8.4`，本机端口 `127.0.0.1:3307`，默认数据库 `lab_db`。

## 1. 核心概念

- **MySQL**：关系型数据库管理系统（RDBMS），负责数据库访问、数据存取、SQL 执行及事务等。
- **Database / Schema**：逻辑容器，用于组织表等数据库对象。MySQL 中 `CREATE SCHEMA` 与 `CREATE DATABASE` 基本同义。
- **Table**：二维结构；列（column）有名称和类型，行（row）是一条记录。
- **SQL**：结构化查询语言，用于定义、查询和修改关系型数据。

本仓库的例子：一个 `lab_db` 数据库，包含 `shop_customers` 和 `shop_orders` 两张表。订单表的 `customer_id` 通过外键关联客户表的 `id`。

## 2. SQL 常见分类

| 分类 | 含义 | 代表语句 |
| --- | --- | --- |
| DDL | 数据定义 | `CREATE`、`ALTER`、`DROP` |
| DML | 数据修改 | `INSERT`、`UPDATE`、`DELETE` |
| DQL | 数据查询（常见教学分类） | `SELECT` |
| DCL | 权限管理 | `GRANT`、`REVOKE` |
| TCL | 事务控制 | `COMMIT`、`ROLLBACK` |

注：分类并非唯一约定；有些资料将 `SELECT` 也归入广义 DML。

## 3. 进入本地 MySQL

仓库根目录中，确认 Docker Desktop 已启动并执行：

```powershell
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
notepad .env                  # 设置本机专用密码，不提交 .env
docker compose up -d
docker compose ps
docker compose exec mysql mysql -u lab_user -p lab_db
```

在 `mysql>` 提示符中输入：

```sql
SELECT VERSION();               -- 查看版本
SELECT DATABASE();              -- 当前数据库，应为 lab_db
SHOW TABLES;                    -- 查看当前数据库的非临时表和视图
```

新建环境若尚无练习表，可执行以下**会重置两张示例表数据**的脚本：

```sql
SOURCE /lab/sql/01-basics/01-schema.sql;
```

仅在本项目 **`lab_db`** 内操作，绝对不要在业务库中运行重置脚本。

## 4. 认识表及 SELECT

```sql
DESCRIBE shop_customers;             -- 查看列结构
SHOW CREATE TABLE shop_customers;    -- 查看建表语句

SELECT * FROM shop_customers;        -- 全部列
SELECT id, name FROM shop_customers; -- 指定列
SELECT id, name
FROM shop_customers
WHERE city = 'Chengdu'
ORDER BY id ASC;
```

拆解查询：`SELECT` 选择列，`FROM` 指定表，`WHERE` 过滤行，`ORDER BY` 排序。`ASC` 升序、`DESC` 降序。SQL 的书写顺序不是数据库内部物理执行步骤。

按 `01-schema.sql` 的**初始模拟数据**，成都客户预期是 `Alice` 和 `Dana`；这是静态预期而非已验证结果。

## 5. 建表和 CRUD

配套实验脚本：[03-crud-practice.sql](../01-basics/03-crud-practice.sql)。在 `mysql>` 中运行：

```sql
SOURCE /lab/sql/01-basics/03-crud-practice.sql;
```

实验对象是专用的 `lesson01_students` 表，脚本会先删除并重建**这张练习表**，不会修改 `shop_customers` 或 `shop_orders`。

理解以下结构，而非机械背诵：

```sql
CREATE TABLE lesson01_students (
    id INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    age INT NOT NULL
) ENGINE=InnoDB;

INSERT INTO lesson01_students (id, name, age)
VALUES (1, 'Alice', 20);

SELECT id, name, age
FROM lesson01_students
WHERE age >= 20
ORDER BY age DESC, id ASC;

UPDATE lesson01_students
SET age = 22
WHERE id = 1;

DELETE FROM lesson01_students
WHERE id = 2;
```

- `PRIMARY KEY`：主键，要求唯一且非 NULL；后续专门讲解主键索引。
- `NOT NULL`：不允许 NULL。
- `WHERE`：限制 `UPDATE` / `DELETE` 的作用范围。**没有 WHERE 可能修改或删除整张表所有行**。
- `INSERT`：插入一行或多行；`SELECT`：读取；`UPDATE`：更新；`DELETE`：删除行。
- `DROP TABLE`：删除表的定义和数据，与 `DELETE` 仅删除记录不同。

## 6. 常见易错点

1. 把 `mysql>` 内的 SQL 当作 PowerShell 命令：两者运行环境不同。
2. 创建表后误以为自动产生数据：`CREATE TABLE` 只定义表结构。
3. 省略 `UPDATE` / `DELETE` 的 `WHERE`：可能批量误操作。
4. 混淆 `NULL` 和空字符串：它们不是同一个值；判断空值使用 `IS NULL`。
5. 将脚本中写好的预期结果当作自己实测结果。
6. 修改 `.env` 里的初始化密码不等于自动修改**已初始化数据卷**里的数据库账号密码。

## 7. 自测与验证（待填写）

按以下顺序操作并记录实际输出：

1. `docker compose ps`：MySQL 容器是否运行？
2. `SELECT VERSION();`：实际数据库版本是什么？
3. `SELECT DATABASE();`：是否连接到 `lab_db`？
4. `SHOW TABLES;`：执行建表脚本前后有哪些表？
5. `SELECT id, name FROM shop_customers WHERE city = 'Chengdu' ORDER BY id;`：实际返回哪两行？
6. `SOURCE /lab/sql/01-basics/03-crud-practice.sql;`：检查建表、插入、更新、删除后结果。
7. 思考：`DELETE FROM lesson01_students WHERE id = 2` 和 `DROP TABLE lesson01_students` 有何不同？

**目前未接收到本地命令输出，以上验证全部未完成。** 不将示例或预期伪装为已通过。

## 参考与实验

- [MySQL 8.4 官方手册：Getting Information About Databases and Tables](https://dev.mysql.com/doc/refman/8.4/en/getting-information.html)
- [MySQL 8.4 官方手册：CREATE TABLE](https://dev.mysql.com/doc/refman/8.4/en/create-table.html)
- [已有初始数据脚本](../01-basics/01-schema.sql)
- [已有查询脚本](../01-basics/02-queries.sql)
