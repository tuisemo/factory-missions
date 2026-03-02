---
description: 编辑当前 Mission 规划
argument-hint: <编辑指令>
---

# ✏️ 编辑规划

编辑当前 Mission 的规划。提供编辑指令，由 Orchestrator 应用更改。

**编辑指令格式**：

1. **添加 Milestone**：
   ```
   在位置 2 添加 Milestone: "实现用户认证"
   成功标准: 用户可以登录和注册
   Features: 实现登录表单, 实现注册表单, JWT 认证
   ```

2. **修改 Milestone**：
   ```
   修改 Milestone 1: 重命名为 "项目初始化与配置"
   ```

3. **删除 Milestone**：
   ```
   删除 Milestone 3
   ```

4. **添加 Feature**：
   ```
   为 Milestone 1 添加 Feature: "配置 ESLint"
   依赖: []
   Worker: programmer
   ```

5. **修改 Feature**：
   ```
   修改 Milestone 1 的 Feature f1: 添加依赖 f3
   ```

6. **删除 Feature**：
   ```
   删除 Milestone 2 的 Feature f5
   ```

7. **调整并行模式**：
   ```
   将 Milestone 2 的并行模式改为 parallel
   ```

8. **批量编辑**：
   ```
   删除 Milestone 3
   修改 Milestone 1 的并行模式为 sequential
   为 Milestone 2 添加 Feature: "性能优化" 依赖: []
   ```

**执行步骤**：

1. 解析编辑指令（$ARGUMENTS）
2. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
3. 根据指令类型应用更改：
   - 重新编号 Milestone IDs（如果添加/删除）
   - 重新编号 Feature IDs（如果添加/删除）
   - 验证依赖关系的有效性
   - 更新 last_updated
4. 将更新后的状态写回文件
5. 显示更改摘要

**输出格式**：
```text
✏️ 规划已更新

应用的更改:
  ✓ 添加 Milestone 2: "实现用户认证"
  ✓ 删除 Milestone 3
  ✓ 修改 Milestone 1 的并行模式为 sequential
  ✓ 为 Milestone 1 添加 Feature: "配置 ESLint"

当前规划概览:
  Milestones: N 个
  Features: M 个
  状态: [status]

⚠️ 请使用 /show-plan-command 查看完整规划
   使用 /approve-command 批准并开始执行
```

**错误处理**：
- 如果指令格式错误，提示正确的格式并给出示例
- 如果编辑会导致无效状态（如循环依赖），提示用户并拒绝更改
