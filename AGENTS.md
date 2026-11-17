# Repository working rules

- 本仓库只维护数据库通用知识、实验用 SQL 和本地可重现实验。
- 当前真正提供的运行环境仅 MySQL；PostgreSQL 和 Redis 为后续计划，不应被描述为已部署。
- 所有公开示例只使用合成数据；不得提交账号、密钥、真实业务数据、`.env` 或数据卷。
- 新增 SQL 实验要写明数据库版本、执行顺序、预期结果和是否具有破坏性。
- `DROP`、`TRUNCATE`、`DELETE` 和 `docker compose down -v` 需显著标注风险。
- 不把 Euboulos、毕设等项目的实际业务 schema 和私有配置复制进来。
- 不应将尚未运行的实验声称为已验证。
