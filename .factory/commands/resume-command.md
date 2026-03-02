---
description: 从暂停点恢复 Mission 执行
---

# ▶️ 恢复 Mission

从暂停点恢复 Mission 执行，继续之前的工作。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 检查当前状态：
   - 如果 `status` 不是 "paused"，提示用户
   - 读取 `checkpoint_data` 了解暂停位置
3. 恢复执行上下文：
   - 根据 `checkpoint_data` 确定从哪里继续
   - 如果有未完成的 Feature，从该 Feature 继续
   - 如果 Feature 已完成但 Milestone 未验证，执行验证
   - 如果 Milestone 已完成，进入下一个 Milestone
4. 更新状态：
   - `status`: "in-progress"
   - `last_updated`: 当前 ISO 时间戳
   - 清空 `paused_at`
5. 将更新后的状态写回文件
6. 调度 Orchestrator 继续执行
7. 输出恢复确认信息

**输出格式**：
```text
▶️ Mission 已恢复

Mission: [mission_goal]
暂停时长: [X 分钟/小时]
当前位置:
  - Milestone: [Milestone 名称] ([X]/[total])
  - Feature: [Feature 名称] ([status])

🚀 继续执行...

[显示当前执行进度]
```

**恢复逻辑**：
```
1. 读取 checkpoint_data
   ↓
2. 判断暂停位置：

   如果 checkpoint_data.feature_id 存在且未完成：
     → 从该 Feature 继续

   如果 checkpoint_data.feature_id 存在且已完成：
     → 检查 Milestone 验证
       - 未验证 → 执行 Validator
       - 已验证 → 进入下一个 Milestone

   如果只有 milestone_id：
     → 从该 Milestone 开始

   如果都没有：
     → 从 current_milestone 继续
   ↓
3. 恢复执行
```

**错误处理**：
- 如果 Mission 未暂停，提示用户
- 如果没有 checkpoint 数据，从头开始或从 current_milestone 继续
- 如果 Mission 已完成，提示用户 Mission 已完成

**使用示例**：
```
# 暂停
/missions-command 实现一个博客系统
... (执行中)
/pause-command

# 恢复
/resume-command
```
