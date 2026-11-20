# 00 · 数据库分类与从零搭建 MySQL 学习环境

> 状态：**教程已整理；本地环境尚未验收**。本页不代表用户已经执行命令。  
> 适用：Windows 11 + Docker Desktop + PowerShell + DBeaver Community。  
> 本仓库使用 `mysql:8.4` 和本机 `127.0.0.1:3307`，以仓库当前的 `compose.yaml`、`.env.example` 为准。

## 1. 先认清数据库系统

- 数据库（Database）：管理的一组相关数据及数据库对象的逻辑集合。
- 数据库管理系统（DBMS）：处理数据存储、读写、权限和并发等的软件。
- 关系型数据库：主要使用表、行、列与表间关系；常见 MySQL、PostgreSQL、SQL Server、SQLite。
- 非关系型数据库（NoSQL）：包括键值、文档、图等模型；常见 Redis、MongoDB、Neo4j。
- SQL：与关系型数据库交互的语言；**MySQL 是数据库软件，不是 SQL 语言本身**。
- SQLite 是嵌入式数据库，一般不需要独立数据库服务进程；MySQL 通常采用客户端/服务器模式。

学习方向：先 MySQL 的表与 SQL、索引、事务；后续再比较 PostgreSQL，并学习 Redis 的缓存与数据结构。

## 2. 数据库软件为什么部署在 Docker 而不是 Windows？

可以直接在 Windows 安装 MySQL Server，Docker **不是唯一方案**。

这里选择 Docker 的原因：现有 Docker Desktop/WSL 2 环境、版本统一、便于多数据库隔离、重建实验环境更方便。代价是还需要管理 Docker Desktop、容器、镜像、卷及额外资源占用；不意味着 MySQL 查询更快。

从运行路径看：

```text
Windows 11
  ├─ Docker Desktop
  │    └─ mysql:8.4 镜像创建的 MySQL 容器（运行 MySQL Server）
  │          └─ /var/lib/mysql ← Docker 命名数据卷 mysql_data（持久化）
  ├─ DBeaver Community（SQL 图形客户端，直接装在 Windows）
  └─ PowerShell（控制 docker compose）
DBeaver → 127.0.0.1:3307 → 容器内端口 3306 → MySQL Server
```

- **镜像（Image）**：创建容器的模板；仓库声明 `mysql:8.4`。
- **容器（Container）**：按镜像启动的运行实例，里面运行数据库服务进程。
- **数据卷（Volume）**：持久保存实际数据库数据。停止/移除容器后可继续保留数据。
- **端口映射**：`127.0.0.1:3307:3306` 表示只绑定本机回环地址的 3307，转发到容器内 MySQL 的 3306。
- **Compose**：用仓库根目录的 `compose.yaml` 管理服务、环境变量、端口、数据卷和挂载。

注意：数据卷不是 SQL 脚本文件夹。`./mysql:/lab/sql:ro` 是将学习 SQL 文件**只读**映射到容器；而 `mysql_data:/var/lib/mysql` 才是数据库持久化存储目录。Docker 中的数据并不因为没有 Windows MySQL 安装包就“消失”。

## 3. 为什么需要 DBeaver？

区分三类工具：

1. MySQL Server：实际运行数据库、保存和处理数据。
2. Docker Desktop：启动、停止、查看 MySQL 容器。
3. DBeaver Community：数据库**图形化客户端**，浏览数据库/表、查看数据、执行 SQL。

DBeaver 不是数据库服务；只安装 DBeaver 而未启动 MySQL Server，不能直接连接到本地 MySQL。推荐 DBeaver Community 因为也能用于 PostgreSQL。

- 官方下载：https://dbeaver.io/download/
- 官方安装：https://dbeaver.com/docs/dbeaver/Installation/
- 官方连接指南：https://dbeaver.com/docs/dbeaver/Create-Connection/

Windows 建议使用官方安装包，或在已有可信软件包管理习惯下安装 Community 版。首次创建 MySQL 连接可能提示下载 JDBC 驱动，按软件界面确认即可。

## 4. 从零启动仓库数据库（PowerShell）

### A. 打开项目

若**尚未克隆**仓库，在你希望存放代码的目录打开 PowerShell：

```powershell
git clone https://github.com/sorenjing/database-lab.git
Set-Location .\database-lab
```

**若已经克隆**，直接在已有 `database-lab` 仓库根目录打开 PowerShell，不要重复克隆。

确认当前位置为仓库根目录：

```powershell
Get-Location
Test-Path .\compose.yaml
```

第二条应返回 `True`。不要在其他仓库执行本项目的 Compose 命令。

### B. 确认 Docker 可用

打开 Docker Desktop，等待 Engine 处于运行状态：

```powershell
docker version
docker compose version
```

`docker version` 的 Client 和 Server 信息都能正常出现说明 Docker Engine 可连接；若只有 Client 或出现无法连接 Engine，应先检查 Docker Desktop 是否启动。

### C. 第一次配置环境变量

```powershell
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
notepad .env
```

仅首次创建本地 `.env`，不会覆盖原有文件。更改：

- `MYSQL_ROOT_PASSWORD`：管理员 `root` 的密码（仅本地练习，不要公开）。
- `MYSQL_PASSWORD`：普通用户 `lab_user` 的密码（与管理员区分）。
- `MYSQL_USER=lab_user`：示例应用用户名称。
- `MYSQL_DATABASE=lab_db`：容器首次初始化时自动创建的练习数据库。
- `MYSQL_PORT=3307`：宿主机的连接端口。

无需将 `.env` 上传 GitHub，仓库 `.gitignore` 已忽略它。**如果容器的数据卷早已初始化，后来修改 `.env` 密码不会自动修改数据库里的已有密码。**

### D. 启动并检查

```powershell
docker compose up -d
docker compose ps
```

`up -d` 表示在后台启动，不是进入 MySQL 控制台。首次可能拉取镜像，数据库初始化可能比容器进程启动略晚。

排错时查看：

```powershell
docker compose logs --tail=50 mysql
```

不要凭 `docker compose ps` 中容器已启动就认为数据库完全准备就绪，还应测试连接。

## 5. 用 DBeaver 连接

在 Windows 安装并打开 **DBeaver Community** → 新建数据库连接 → 选择 **MySQL** → 填入：

| 字段 | 值 |
| --- | --- |
| Host / Server | `127.0.0.1` |
| Port | `3307` |
| Database | `lab_db` |
| Username | `lab_user` |
| Password | 本机 `.env` 中的 `MYSQL_PASSWORD` |

不要用 `3306` 连接 Windows 侧这个 Compose 项目：3306 是容器内端口，3307 才是映射到 Windows 的端口。

点击 **Test Connection**。首次可能需要下载 MySQL JDBC 驱动，成功后完成连接。在 DBeaver 的 SQL 编辑器执行：

```sql
SELECT VERSION();
SELECT DATABASE();
SHOW TABLES;
```

解释：查看服务版本、当前数据库、当前数据库已有表。若目前没有表，`SHOW TABLES` 返回空表也正常。

### 可选：命令行直接登录

DBeaver 若尚未安装，可以先在仓库根目录的 PowerShell 运行：

```powershell
docker compose exec mysql mysql -u lab_user -p lab_db
```

按提示输入普通用户密码，出现 `mysql>` 后执行上面的 SQL。结束时用 `exit;` 离开 MySQL 交互模式。**PowerShell 命令与 `mysql>` 里的 SQL 是两种不同环境**。

## 6. 第一张表（成功连接以后再操作）

练习库 `lab_db` 是首次初始化时**自动创建**的，不用再执行一次 `CREATE DATABASE lab_db`。接下来在 DBeaver SQL 编辑器中按顺序运行：

```sql
CREATE TABLE first_people (
    id INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL
);

INSERT INTO first_people (id, name)
VALUES (1, 'Alice');

SELECT id, name FROM first_people;
```

预期得到 `1, Alice`（**尚未实际验证**）。上面的建表和插入代码只供首次运行；反复运行可能出现表已存在或主键重复错误，这是正常的数据库约束反馈。

注意：此阶段不使用 `DROP TABLE`、`docker compose down -v` 等有删除风险的命令。

### 什么时候学习手动创建数据库？

到下一小节再学习 `CREATE DATABASE`、`USE`、用户权限。原因是此 Compose 预置的 `lab_user` 对 `lab_db` 有权限，但**不应假定它能创建新的数据库**；新建数据库通常需要管理员授权。先把连接跑通，避免把权限问题误判成 SQL 语法问题。

## 7. 停止与数据安全

```powershell
docker compose stop      # 停止容器，保留容器和数据卷
docker compose start     # 重新启动已经存在的 Compose 容器
docker compose down      # 移除本项目容器与网络，默认保留命名数据卷
```

**不要随意使用 `docker compose down -v`**：它会移除本 Compose 项目的命名数据卷，导致练习数据丢失。

保留数据卷不等同于正式备份；将来学习备份与恢复再实际验证。

## 8. 这节课的验收清单

- [ ] 能解释 MySQL 与 SQL 的区别
- [ ] 能说明关系型 / 非关系型数据库的常见区别
- [ ] 能解释镜像、容器、数据卷和端口映射
- [ ] Docker Engine 可用（运行 `docker version`）
- [ ] 在仓库根目录运行 `docker compose up -d`
- [ ] DBeaver 测试连接成功，或命令行登录成功
- [ ] 运行 `SELECT VERSION();`、`SELECT DATABASE();`
- [ ] 用图形界面创建并查看 `first_people` 表

**未收到实际本机执行输出，本清单目前全部待验证。**

## 9. 官方参考

- Docker：容器化数据库 https://docs.docker.com/guides/databases/
- Docker：持久化数据卷 https://docs.docker.com/get-started/docker-concepts/running-containers/persisting-container-data/
- MySQL 8.4：Docker 部署 https://dev.mysql.com/doc/refman/8.4/en/linux-installation-docker.html
- DBeaver：连接 MySQL https://dbeaver.com/docs/dbeaver/Database-driver-MySQL/
