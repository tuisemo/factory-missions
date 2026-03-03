---
description: 查看当前 Mission 的详细执行状态与里程碑
---

# 📊 Mission 状态监控

显示当前 Mission 的执行进度、并行执行状态和闭环修复状态。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 检查文件是否存在：
   - 如果不存在，提示用户使用 `/auto-missions` 启动新任务
3. 提取和格式化以下信息：
   - 基本信息（目标、状态）
   - Milestones 进度结构
   - 验证和自修复信息
   - 并行节点占用

**输出格式要求**：

**状态：进行中 （或 规划中/修复中）**
```text
╔════════════════════════════════════════╗
║         📊 Mission 状态面板             ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  状态: 🟢 [status]                      ║
║  并行执行: 开启，支持 [max_parallel_workers] 个并发 ║
╚════════════════════════════════════════╝

📍 当前 Milestone进度 [X]/[total]: 
   名称: [Milestone 名称]
   状态: [pending/in-progress/verifying/repairing/completed]

🚀 在运行的 Branch (并行子分支):
   - [Feature 名称 A]
   - [Feature 名称 B]
   - [如果有 Repair 修复分支也会列在这里]

⚙️ 验证闭环追踪:
   最近的 Validator 反馈: [None/PASS/FAIL]
   自修复重试次数 (Retry): [retry_count] / [max_retries]

⏱️ 运行统计:
   创建时间: [created_at]
   最后更新: [last_updated]

💡 可用命令:
   /mission-pause    - 暂停自动执行
   /mission-show-plan - 查看所有已规划出的 Milestone 清单
   /mission-logs     - 查看主干记录的追踪日志
```

**状态：已暂停 或 卡住（达到最大重试上限）**
```text
╔════════════════════════════════════════╗
║         📊 Mission 异常挂起 / 暂停        ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  状态: ⏸️ 已暂停 / FAIL_HALT            ║
╚════════════════════════════════════════╝

暂停原因: [如人工暂停或达到了 max_retries]
请检查 `mission-state.json` 或日志以确认具体错误点。

💡 可用命令:
   /mission-resume   - 重置 retry_count 并尝试继续
   /mission-redirect - 调整目标的重定向指令
```

**状态：已完成**
```text
╔════════════════════════════════════════╗
║         📊 Mission 圆满完成             ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  状态: ✅ 已完成                      ║
╚════════════════════════════════════════╝

所有拆解的 Milestones 及其下属功能均经过 Validator 验证放行。
```

