---
description: 添加新的 Milestone 到规划
argument-hint: <Milestone 名称>
---

# ➕ 添加 Milestone

在当前 Mission 规划中添加新的 Milestone。

**参数**：
- 名称：新 Milestone 的名称（$ARGUMENTS）

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 询问用户以下信息（如果未提供）：
   - 成功标准（必需）
   - 并行模式（可选，默认：auto）
   - 位置（可选，默认：添加到末尾）
3. 创建新的 Milestone 对象：
   ```json
   {
     "id": [自动分配],
     "name": "[名称]",
     "status": "pending",
     "success_criteria": "[成功标准]",
     "parallel_mode": "[auto/parallel/sequential]",
     "features": []
   }
   ```
4. 插入到指定位置
5. 更新 last_updated
6. 将更新后的状态写回文件
7. 显示确认信息

**输出格式**：
```text
➕ Milestone 已添加

✓ Milestone [ID]: [名称]
  成功标准: [success_criteria]
  并行模式: [parallel_mode]
  位置: [位置]

当前规划:
  Milestones: N 个
  总进度: [completed]/[total] Milestones

💡 使用 /add-feature-command 为此 Milestone 添加 Features
   使用 /show-plan-command 查看完整规划
```
