---
description: 查看 Mission 执行日志
---

查看 Mission 的详细执行日志。

**参数**：
- 可选：日志数量（默认 20 条）
- 可选：日志级别（默认 all，可选：INFO、WARN、ERROR）

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 检查 `logs` 数组是否存在
3. 根据参数过滤日志：
   - 如果指定了级别，只显示该级别的日志
   - 如果指定了数量，只显示最近 N 条
4. 格式化输出日志
5. 显示日志统计信息

**输出格式**：
```text
📋 Mission 执行日志

日志统计:
  总日志: [总数]
  INFO: [X] 条
  WARN: [Y] 条
  ERROR: [Z] 条

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[2026-03-02T14:30:00Z] [INFO] [orchestrator] Feature f3 "编写测试" 已完成
  - Worker: programmer
  - 耗时: 15 分钟
  - Token 使用: 12,345

[2026-03-02T14:25:00Z] [INFO] [programmer] 开始实现功能 B
  - 依赖: f4
  - Worker 类型: programmer

[2026-03-02T14:20:00Z] [WARN] [validator] 测试覆盖率 82%，低于目标 85%
  - 建议: 添加边界情况测试

[2026-03-02T14:15:00Z] [INFO] [orchestrator] 开始执行 Milestone 2
  - 并行模式: parallel
  - Features: 3 个

[2026-03-02T14:10:00Z] [INFO] [validator] Milestone 1 验证通过
  - 成功标准: 全部满足

[2026-03-02T14:05:00Z] [INFO] [programmer] Feature f1 "搭建项目结构" 已完成
  - 耗时: 8 分钟

[2026-03-02T14:00:00Z] [INFO] [orchestrator] 开始执行 Milestone 1
  - 并行模式: auto

[2026-03-02T13:55:00Z] [INFO] [orchestrator] 规划已批准，开始执行
  - 总 Milestones: 3 个
  - 总 Features: 9 个

[2026-03-02T13:50:00Z] [INFO] [user] 用户批准规划

[2026-03-02T13:45:00Z] [INFO] [orchestrator] 生成初始规划
  - 场景: programming

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 可用命令:
  /logs [数量] - 显示指定数量的日志
  /logs [级别] - 显示指定级别的日志（INFO/WARN/ERROR）
  /status       - 查看当前状态
```

**日志格式**：
```
[时间戳] [级别] [来源] 消息
  - 额外信息（可选）
```

**日志级别说明**：
- **INFO**: 正常执行信息，任务完成、状态变更等
- **WARN**: 警告信息，质量问题、潜在问题等
- **ERROR**: 错误信息，执行失败、验证失败等

**使用示例**：
```bash
# 查看最近 20 条日志（默认）
/logs

# 查看最近 50 条日志
/logs 50

# 查看所有 WARN 级别日志
/logs WARN

# 查看所有 ERROR 级别日志
/logs ERROR

# 查看最近 10 条 INFO 日志
/logs 10 INFO
```

**错误处理**：
- 如果没有日志记录，提示用户 Mission 可能刚开始
- 如果日志格式错误，提示用户
