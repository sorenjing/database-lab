# Database Lab

Hands-on database learning with MySQL, PostgreSQL, and Redis, covering SQL, indexing, transactions, and optimization.

> 本仓库是**本地学习与可重复实验**的集合，不是生产数据库部署模板。当前已提供 MySQL 实验配置及第一组 SQL；PostgreSQL 和 Redis 仅保留后续学习入口。

## 当前内容

| 目录 | 主题 | 状态 |
| --- | --- | --- |
| [mysql/](mysql/) | SQL、表结构、索引、事务、锁和查询优化 | 已提供入门 SQL 与 Docker 配置 |
| [postgresql/](postgresql/) | PostgreSQL 数据类型、索引、查询计划与事务 | 计划中 |
| [redis/](redis/) | 数据结构、过期、缓存和并发控制 | 计划中 |

## 新手先读

如果完全没有数据库基础，请先阅读 [第 00 课：数据库分类与从零搭建 MySQL 学习环境](mysql/notes/00-database-setup.md)，认识 MySQL Server、Docker、数据卷与 DBeaver 图形客户端。下面的命令是给已了解这些概念的人使用的快速入口。

## 快速开始 · MySQL

**前置条件：** Docker Desktop 和 `docker compose` 可用。默认使用官方 `mysql:8.4` 镜像，映射到本机 **127.0.0.1:3307**，避免占用本地 3306。

在仓库根目录执行（PowerShell）：

```powershell
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
notepad .env            # 先把两个示例密码替换为本地专用密码
docker compose up -d
docker compose ps
docker compose exec mysql mysql -u lab_user -p lab_db
```

MySQL 交互提示密码时，输入 `.env` 中的 `MYSQL_PASSWORD`。进入 `mysql>` 后执行：

```sql
SOURCE /lab/sql/01-basics/01-schema.sql;
SOURCE /lab/sql/01-basics/02-queries.sql;
```

这里将 `./mysql/` 以只读方式映射到容器的 `/lab/sql/`，不需要 Windows 本机额外安装 MySQL Server。也可以用支持 MySQL 的 GUI 客户端连接 `127.0.0.1:3307`，数据库为 `lab_db`，用户为 `lab_user`，密码来自你本地的 `.env`。

**注意：** `01-schema.sql` 会删除并重新创建本实验的两张示例表，**不可用于真实业务数据库**。MySQL 环境变量只在全新数据卷初始化时创建用户，修改旧 `.env` 不会自动改已有用户密码。

结束实验：

```powershell
docker compose down        # 停止容器，保留学习数据
```

只有确定不再需要本仓库 MySQL 数据时，才能执行 `docker compose down -v`，此操作将删除本 Compose 项目的命名数据卷。

## 学习路线

1. [SQL 基础实验](mysql/01-basics/README.md)：建表、查询、JOIN、分组、索引初探。
2. 索引与 `EXPLAIN`：理解查询计划和联合索引。
3. 事务与隔离：用两个会话验证并发读写。
4. 锁与并发：定位死锁和争用。
5. PostgreSQL：对比数据库能力与索引机制。
6. Redis：理解缓存数据结构、过期和一致性策略。

## 仓库边界与安全

- 通用 SQL、数据库行为实验、可复现的本地环境放这里；Spring Boot 代码放 [java-backend-lab](https://github.com/sorenjing/java-backend-lab)。
- 真实项目的数据结构、迁移脚本与业务数据必须留在原项目仓库。
- 不提交 `.env`、数据库文件、真实数据、密钥或连接字符串；公开仓库只包含假数据。
- **未在你的本地 Docker 环境执行验收**；请按上述步骤运行后记录实际结果。

## License

[MIT](LICENSE)，第三方数据库软件按其各自许可证使用。
