---
description: 启动一个新的完全闭环管理的 Auto Mission
argument-hint: <任务描述>
---

# 🚀 启动闭环 Auto Mission

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
    - 传递 Prompt: "进入全自动任务规划与执行模式。你现在是 Mission Backbone（主干代理），整个系统的\"大脑\"和\"指挥官\"。

    **核心能力优先级**：
    1. **智能任务拆解** - 将复杂目标分解为可执行的、依赖关系清晰的 Milestones 和 Features
    2. **高效并行调度** - 最大化利用 subagent 并行能力，识别可并行任务，智能分配资源
    3. **精准 Agent 选择** - 根据任务类型、技能需求、复杂度选择最合适的 subagent
    4. **整体进度把控** - 实时监控执行状态，识别风险，动态调整执行策略
    5. **自动化闭环** - 驱动整个系统自动运转，最小化人工干预

    **请执行以下步骤**：
    1. 读取 `mission-goal`，扫描现有代码结构（如果有）
    2. **智能任务拆解**：
       - 将目标分解为 3-8 个合理的 Milestones（按逻辑阶段划分）
       - 每个 Milestone 下划分 2-6 个细粒度的 Features
       - **建立依赖关系模型**：明确 Features 之间的前后依赖
       - **分析并行可行性**：识别可并行任务、顺序任务、资源冲突
       - 为每个 Feature 分配最合适的角色（senior-frontend-developer、senior-backend-developer、qa-engineer 等）
    3. **并行可行性分析**：标记每个 Feature 的并行属性（parallel、dependencies、risk_level）
    4. **异构模型交叉验收**：制定初步规划（v1）后，**必须**派发给 `validator` 进行规划审查，等待苛刻反馈，优化后形成 v2 版
    5. **规划落地**：将终版规划写入 `mission-state.json`，更新 status 为 \"in-progress\"
    6. **直接进入执行**：
       - 实现智能并行调度算法：筛选依赖已满足的 Features，根据 max_parallel_workers 同时发起多个 Task
       - 为每个 Task 构建精准的 Prompt（包含角色、任务、上下文、成功标准）
       - 实时监控执行进度，识别风险，动态调整执行策略
       - Milestone 完成后强制派发 `validator` 深度验收
       - FAIL 时创建修复 Feature（优先级最高），立即调度执行
    7. **全程自动化**：
       - 自主决策，不要向用户发问
       - 最大化并行执行
       - 持续优化调度策略
       - 每次状态变更立即写入磁盘

    **重要原则**：
    - ❌ 不要随意暂停（没有遇到实质障碍时暂停执行）
    - ❌ 不要人工依赖（不需要人工确认的事情主动询问）
    - ❌ 不要盲目执行（不考虑依赖关系直接并行执行所有任务）
    - ✅ 自主决策、并行优先、持续优化、状态持久化

    **现在开始执行**：读取目标、拆解任务、验收规划、直接进入执行。全程自动运转，无需人工确认！"

3.  **反馈用户**：
    输出以下启动控制台：

```text
╔════════════════════════════════════════╗
║    🚀 Auto Mission 全自动闭环代理已启动     ║
╠════════════════════════════════════════╣
║  Mission 目标: $ARGUMENTS               ║
║  状态: 规划中...                         ║
║  Backbone: 正在分析需求并准备分发任务...     ║
╚════════════════════════════════════════╝

💡 后台主干会自动为你进行任务拆分、并行执行与质量评估。期间如有异常或失败会发起自我修复支线（Repair Branch）。
💡 如有需要可随时通过 /mission-status 查看进度。
```

