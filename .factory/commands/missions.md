---
description: 启动一个新的完全闭环管理的 Mission
argument-hint: <任务描述>
---

# 🚀 启动闭环 Mission

你现在需要为用户启动一个全新的 Autonomous Mission（自主任务）工作流。

**任务目标**: $ARGUMENTS

请立即执行以下步骤来初始化：

1.  **准备环境与状态初始化**：
    - 读取 `$FACTORY_PROJECT_DIR/.factory/mission-state.json.example` 作为参考模板。
    - 使用 `Write` 工具创建或覆盖 `$FACTORY_PROJECT_DIR/.factory/mission-state.json`。
    - 在 JSON 中设置：
        - `mission_goal`: "$ARGUMENTS"
        - `status`: "planning"
        - `created_at`: 当前 ISO 时间戳
        - `current_milestone`: 0
        - `retry_count`: 0
        - `max_retries`: 3
        - `parallel_execution`: true
        - `max_parallel_workers`: 3
    - 模板中的 `milestones` 初始化为空数组 `[]`，等待 Backbone 主干自主规划和填充。

2.  **激活 Backbone 主干代理**：
    - 使用 `Task` 工具将任务直接委托给名为 `backbone` 的代理。
    - 传递 Prompt: "进入全自动任务规划模式。读取刚才设置的目标，自动拆解 Milestones 和 Features 写入 `mission-state.json`，然后**直接将状态更新为 `in-progress` 并自行调度**对应的 `branch` 执行任务以及对应的 `validator` 进行闭环验收。无需向用户索要确认。"

3.  **反馈用户**：
    输出以下启动控制台：

```text
╔════════════════════════════════════════╗
║    🚀 Mission 全自动闭环代理已启动        ║
╠════════════════════════════════════════╣
║  Mission 目标: $ARGUMENTS               ║
║  状态: 规划中...                         ║
║  Backbone: 正在分析需求并准备分发任务...     ║
╚════════════════════════════════════════╝

💡 后台主干会自动为你进行任务拆分、并行执行与质量评估。期间如有异常或失败会发起自我修复支线（Repair Branch）。
💡 如有需要可随时通过 /status 查看进度。
```

