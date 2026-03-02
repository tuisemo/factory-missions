---
description: 批准当前规划并开始执行 Mission
---

# ✅ 批准规划

批准当前 Mission 规划并开始执行。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 检查是否有有效的规划（milestones 非空）
3. 更新状态：
   - `status`: "in-progress"
   - `last_updated`: 当前时间戳
4. 将更新后的状态写回文件
5. 调度 Orchestrator 开始执行第一个 Milestone
6. 输出确认信息

**输出格式**：
```text
✅ 规划已批准，Mission 开始执行！

Mission: [mission_goal]
场景: [scene]
Milestones: N 个
总 Features: M 个

🚀 正在启动 Orchestrator 执行 Milestone 1...

[显示执行进度]
```

**错误处理**：
- 如果没有规划（milestones 为空），提示用户先使用 /plan-command 生成规划
- 如果已经在执行中，提示当前状态
