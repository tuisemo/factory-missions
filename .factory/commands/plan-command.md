---
description: 重新生成 Mission 规划
---

# 📋 重新生成规划

重新生成当前 Mission 的 Milestones 和 Features 计划。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 分析 `mission_goal` 和已有规划
3. 与用户确认是否需要调整规划策略：
   - 是否需要更多的/更少的 Milestones？
   - 每个 Milestone 的粒度如何？
   - 是否需要特定的 Skills？
4. 基于用户反馈重新生成规划
5. 显示新规划并等待用户确认（使用 /approve）

**输出格式**：
```text
📋 新规划已生成

Milestones (共 N 个):

Milestone 1: [名称]
  成功标准: [success_criteria]
  并行模式: [auto/parallel/sequential]
  Features:
    - [Feature 1] (依赖: [])
    - [Feature 2] (依赖: [f1])

Milestone 2: [名称]
  ...

⚠️ 请使用 /approve-command 批准此规划，或使用 /edit-plan-command 进行编辑
```
