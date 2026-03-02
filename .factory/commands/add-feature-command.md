---
description: 为指定的 Milestone 添加 Feature
argument-hint: <Feature 名称>
---

# ➕ 添加 Feature

为指定的 Milestone 添加新的 Feature。

**参数**：
- Feature 名称：新 Feature 的名称（$ARGUMENTS）

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 询问用户以下信息（如果未提供）：
   - Milestone ID（必需）
   - 依赖的 Features（可选，默认：[]）
   - Worker 类型（可选，默认：worker）
3. 创建新的 Feature 对象：
   ```json
   {
     "id": "f[自动编号]",
     "name": "[名称]",
     "status": "pending",
     "dependencies": ["f1", "f2"],
     "worker_type": "[worker/programmer/writer/researcher]",
     "assigned_at": null,
     "completed_at": null
   }
   ```
4. 添加到指定 Milestone 的 features 数组
5. 更新 last_updated
6. 将更新后的状态写回文件
7. 显示确认信息

**输出格式**：
```text
➕ Feature 已添加

✓ Feature [ID]: [名称]
  所属 Milestone: [Milestone ID] - [Milestone 名称]
  依赖: [dependencies]
  Worker: [worker_type]

当前 Milestone [ID] 的 Features:
  ○ [Feature 1]
  ○ [Feature 2] (新增)
  ...

💡 使用 /show-plan-command 查看完整规划
   使用 /approve-command 批准并开始执行
```

**错误处理**：
- 如果 Milestone ID 不存在，提示用户使用 /show-plan-command 查看
- 如果指定的依赖 Features 不存在，提示并让用户重新输入
