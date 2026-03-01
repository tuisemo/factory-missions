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
        - `status`: "in-progress"
        - `scene`: "programming"
        - `created_at`: 当前 ISO 时间戳
        - `current_milestone`: 0
    - 如果模板中有 `milestones` 结构，请保留为空数组 `[]`，等待 Orchestrator 随后填充。

2.  **调度 Orchestrator**：
    - 使用 `Task` 工具将任务分发给名为 `orchestrator` 的 Subagent。
    - Subagent Prompt: "基于 mission-state.json 中的目标开始执行规划和任务拆解。"

3.  **反馈用户**：
    输出以下启动控制台：

```text
╔════════════════════════════════════════╗
║    🚀 Missions 工作模式已激活          ║
╠════════════════════════════════════════╣
║  Mission: $ARGUMENTS                   ║
║  状态: 进行中                          ║
║  Orchestrator: 正在初始化...           ║
╚════════════════════════════════════════╝
```
