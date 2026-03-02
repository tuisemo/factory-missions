---
description: 启动一个新的 Mission
argument-hint: <任务描述>
---

# 🚀 启动 Mission

你现在需要为用户启动一个全新的 Mission 工作流。

**任务目标**: $ARGUMENTS

请立即执行以下步骤来初始化：

1.  **状态初始化**：
    - 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json.example` 作为参考模板。
    - 使用 `Write` 工具创建或覆盖 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`。
    - 在 JSON 中设置：
        - `mission_goal`: "$ARGUMENTS"
        - `status`: "planning"
        - `scene`: "programming"
        - `created_at`: 当前 ISO 时间戳
        - `current_milestone`: 0
        - `retry_count`: 0
        - `max_retries`: 3
        - `parallel_execution`: true
        - `max_parallel_workers`: 3
    - 如果模板中有 `milestones` 结构，请保留为空数组 `[]`，等待 Orchestrator 随后填充。

2.  **进入交互式规划模式**：
    - 使用 `Task` 工具将任务分发给名为 `orchestrator` 的 Subagent。
    - Subagent Prompt: "进入交互式规划模式。基于 mission-state.json 中的目标，与用户协作制定详细的 Milestones 和 Features 计划。规划完成后等待用户确认。"

3.  **反馈用户**：
    输出以下启动控制台：

```text
╔════════════════════════════════════════╗
║    🚀 Mission 交互式规划模式            ║
╠════════════════════════════════════════╣
║  Mission: $ARGUMENTS                   ║
║  状态: 规划中                          ║
║  Orchestrator: 正在分析需求...         ║
╚════════════════════════════════════════╝

💡 交互式规划命令：
  /plan-command           - 重新生成规划
  /edit-plan-command      - 编辑当前规划
  /approve-command        - 批准规划并开始执行
  /show-plan-command      - 显示当前规划
  /add-milestone-command  - 添加新的 Milestone
  /add-feature-command    - 为 Milestone 添加 Feature
```
