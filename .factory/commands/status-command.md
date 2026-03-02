---
description: 查看当前 Mission 的详细状态
---

# 📊 Mission 状态

显示当前 Mission 的详细执行状态和进度信息。

**执行步骤**：

1. 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`
2. 检查文件是否存在：
   - 如果不存在，提示用户使用 `/missions` 启动新任务
3. 格式化输出以下信息：
   - Mission 基本信息（目标、场景、状态）
   - 执行进度统计
   - 当前位置（Milestone、Feature）
   - 时间信息（创建、更新、暂停时间）
   - 已使用的技能
   - 最近日志（最后 5 条）
4. 根据 status 显示不同的提示信息

**输出格式**：

**状态：进行中**
```text
╔════════════════════════════════════════╗
║         📊 Mission 状态               ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  场景: [scene]                         ║
║  状态: 🟢 进行中                       ║
║  并行执行: [enabled/disabled]          ║
╚════════════════════════════════════════╝

📈 执行进度:
  Milestones: [completed]/[total] ([XX]%)
  Features: [completed]/[total] ([XX]%)

📍 当前位置:
  Milestone [X]/[total]: [Milestone 名称]
    进度: [Y]/[N] Features
    状态: [执行中/验证中/等待中]
    并行模式: [parallel_mode]
  当前 Feature:
    - [Feature 名称] ([worker_type])
    - 状态: [进行中/已完成/待执行]

⏱️ 时间信息:
  创建时间: [created_at]
  最后更新: [last_updated]
  已运行: [X 分钟/小时]

🛠️ 使用的技能:
  - [skill 1]
  - [skill 2]
  - ...

📋 最近日志:
  [2026-03-02T14:30:00Z] [INFO] Feature f3 已完成
  [2026-03-02T14:25:00Z] [INFO] 开始执行 Milestone 2
  ...

💡 可用命令:
  /pause-command    - 暂停执行
  /show-plan-command - 查看完整规划
  /logs-command     - 查看详细日志
```

**状态：已暂停**
```text
╔════════════════════════════════════════╗
║         📊 Mission 状态               ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  状态: ⏸️ 已暂停                      ║
╚════════════════════════════════════════╝

暂停时间: [paused_at]
暂停时长: [X 分钟/小时]

当前位置:
  Milestone: [Milestone 名称]
  Feature: [Feature 名称] (执行中时暂停)

💡 可用命令:
  /resume-command   - 继续执行
  /redirect-command - 重定向到新方向
```

**状态：已完成**
```text
╔════════════════════════════════════════╗
║         📊 Mission 状态               ║
╠════════════════════════════════════════╣
║  目标: [mission_goal]                  ║
║  状态: ✅ 已完成                      ║
╚════════════════════════════════════════╝

完成时间: [completed_at]
总耗时: [X 分钟/小时]
成功率: [100% / 实际百分比]

💡 可用命令:
  /missions-command [目标] - 开始新任务
  /logs-command            - 查看执行日志
  /show-plan-command       - 查看完成的规划
```

**错误处理**：
- 如果 mission-state.json 不存在，提示用户使用 `/missions-command` 启动
- 如果文件损坏，提示用户恢复或删除重新开始
- 如果读取失败，显示错误信息

**使用示例**：
```
# 查看状态
/status-command

# 暂停后查看状态
/pause-command
/status-command

# 恢复后查看状态
/resume-command
/status-command
```
