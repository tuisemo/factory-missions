---
description: 暂停当前正在执行的 Mission
---

# ⏸️ 暂停 Mission

暂停当前正在执行的 Mission，保存当前状态以便后续恢复。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 检查当前状态：
   - 如果 `status` 不是 "in-progress"，提示用户
   - 记录当前正在执行的任务（如果有的话）
3. 更新状态：
   - `status`: "paused"
   - `paused_at`: 当前 ISO 时间戳
   - `last_updated`: 当前 ISO 时间戳
   - 记录当前 checkpoint 信息：
     ```json
     {
       "checkpoint_data": {
         "milestone_id": [当前 milestone],
         "feature_id": [当前执行或刚完成的 feature],
         "context": [简要描述当前执行上下文]
       }
     }
     ```
4. 将更新后的状态写回文件
5. 输出暂停确认信息

**输出格式**：
```text
⏸️ Mission 已暂停

Mission: [mission_goal]
暂停时间: [paused_at]
当前进度: [completed]/[total] Milestones
当前位置:
  - Milestone: [Milestone 名称]
  - Feature: [Feature 名称] (执行中/刚完成)

💡 使用 /resume 命令继续执行
   使用 /status 查看完整状态
```

**错误处理**：
- 如果 Mission 已经暂停或完成，提示用户
- 如果没有正在执行的 Mission，提示用户

