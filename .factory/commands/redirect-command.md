---
description: 重定向 Mission 到新的方向或目标
argument-hint: <重定向指令>
---

# 🔄 重定向 Mission

重定向 Mission 到新的方向或目标，调整剩余的工作计划。

**参数**：
- 重定向指令：描述新的方向或目标（$ARGUMENTS）

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 分析重定向指令，确定重定向类型：
   - **功能调整**：添加/删除/修改某个功能
   - **方向改变**：完全改变项目方向
   - **优先级调整**：调整 Features 的优先级
   - **Milestone 调整**：添加/删除/合并 Milestones
3. 根据类型执行相应操作：

   **类型 1：功能调整**
   ```
   指令示例：
   - "删除邮件通知功能，改为 Slack 集成"
   - "添加用户个人资料页面"

   操作：
   - 删除/添加对应的 Features
   - 更新受影响的 Milestones
   - 保持已完成的 Features 不变
   ```

   **类型 2：方向改变**
   ```
   指令示例：
   - "将项目从单体架构改为微服务架构"
   - "从 Web 应用改为移动应用"

   操作：
   - 标记已完成的 Milestones
   - 重新规划剩余的 Milestones
   - 可能需要重新定义成功标准
   ```

   **类型 3：优先级调整**
   ```
   指令示例：
   - "将支付功能提前到 Milestone 2"
   - "性能优化延后到最后"

   操作：
   - 重新排序 Milestones
   - 调整 Features 的顺序
   - 更新依赖关系
   ```

   **类型 4：Milestone 调整**
   ```
   指令示例：
   - "合并 Milestone 3 和 4"
   - "在 Milestone 2 之后添加新的 Milestone"

   操作：
   - 添加/删除/合并 Milestones
   - 重新分配 Features
   - 更新 ID 和顺序
   ```

4. 更新状态：
   - `status`: "in-progress" (如果之前是 paused)
   - `redirect_target`: 记录重定向指令
   - `last_updated`: 当前 ISO 时间戳
   - 在 `logs` 中添加重定向记录
5. 将更新后的状态写回文件
6. 显示重定向摘要和新计划

**输出格式**：
```text
🔄 Mission 已重定向

重定向指令: [指令内容]

执行的更改:
  ✓ 删除 Feature: "邮件通知"
  ✓ 添加 Feature: "Slack 集成"
  ✓ 调整 Milestone 2 的 Features 顺序
  ✓ 更新依赖关系

新计划概览:
  Milestones: N 个 (从 Milestone X 开始)
  Features: M 个
  预计影响: +/- X 个 Features

当前进度:
  ✓ 已完成: [X] Milestones, [Y] Features
  ⟳ 进行中: [Z] Milestone
  ○ 待执行: [剩余 Milestones]

🚀 从 Milestone [X] 继续执行...

[显示更新后的计划]
```

**重定向日志格式**：
```json
{
  "timestamp": "2026-03-02T14:30:00Z",
  "type": "redirect",
  "instruction": "删除邮件通知，改为 Slack 集成",
  "changes": {
    "deleted_features": ["邮件通知"],
    "added_features": ["Slack 集成"],
    "modified_milestones": [2]
  },
  "before": {
    "milestones_count": 5,
    "features_count": 15
  },
  "after": {
    "milestones_count": 5,
    "features_count": 15
  }
}
```

**错误处理**：
- 如果重定向会导致依赖关系破坏，提示用户并要求确认
- 如果重定向需要回滚已完成的工作，明确告知用户
- 如果指令不明确，请求用户澄清

**使用示例**：
```
# 场景 1：功能调整
/redirect 删除邮件通知功能，改为 Slack 集成

# 场景 2：优先级调整
/redirect 将支付功能提前到 Milestone 2，性能优化延后

# 场景 3：方向改变
/redirect 将项目从 Web 应用改为移动应用

# 场景 4：Milestone 调整
/redirect 合并 Milestone 3 和 4，因为它们都关于测试
```

**注意事项**：
- 重定向可能会影响之前的工作，要谨慎处理
- 尽量保留已完成的工作
- 如果需要重新开始，明确告知用户
- 重定向后建议使用 /show-plan-command 确认新计划
