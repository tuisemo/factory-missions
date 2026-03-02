---
description: 显示当前 Mission 规划
---

# 📄 显示规划

显示当前 Mission 的详细规划信息。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 格式化输出以下信息：
   - Mission 目标
   - 场景类型
   - 当前状态
   - 所有 Milestones（含进度）
   - 每个 Milestone 下的 Features
   - 并行执行配置
3. 如果有已完成或进行中的任务，显示进度统计

**输出格式**：
```text
╔════════════════════════════════════════╗
║         📄 Mission 规划详情           ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  场景: [scene]                         ║
║  状态: [status]                        ║
║  当前进度: [completed]/[total]         ║
║  并行执行: [enabled/disabled]          ║
╚════════════════════════════════════════╝

🎯 Milestones (共 N 个):

Milestone 1: [name] [✓/○/⟳]
  状态: [completed/in-progress/pending]
  成功标准: [success_criteria]
  并行模式: [parallel_mode]
  进度: [X]/[Y] Features 完成
  Features:
    ✓ [Feature 1] (已完成)
    ⟳ [Feature 2] (进行中)
    ○ [Feature 3] (待执行)

Milestone 2: [name] [○]
  ...

⏱️ 时间信息:
  创建时间: [created_at]
  最后更新: [last_updated]
  预计开始: [estimated_start]
```
