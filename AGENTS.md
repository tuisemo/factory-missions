# AGENTS.md - Factory Droid 全场景规范

## 快速开始

### 启动 Mission

使用快捷命令激活 Missions 工作模式：

```
/missions [你的任务]
```

例如：
```
/missions 写一篇 5000 字关于 Agentic AI 的技术报告
```

这会自动：
1. 激活 Missions 工作模式
2. 识别场景（写作/编程/调研）
3. 启动 Orchestrator
4. 拆解 Milestones 和 Features
5. 开始执行 Mission

---

## 通用规则

所有 Subagents 必须遵守以下通用规则：

1. **输出结构化**：所有输出必须包含清晰的结构（大纲 + 内容 + 验证）
2. **保持一致性**：使用相同的格式和术语，便于 Orchestrator 解析
3. **明确进度**：使用 TodoWrite 工具实时显示进度
4. **质量第一**：完成任务后必须进行自我验证
5. **文档完整**：所有修改必须包含清晰的说明

---

## 写作场景规范

### Writer Subagent 规则

**输出格式**：
```markdown
# [标题]

## 大纲
1. 章节1
   - 子要点
2. 章节2
   - ...

## 内容
[完整内容...]

## 统计信息
- 字数：XXXX 字
- 预估字数：XXXX 字
- 完成度：XX%
```

**质量标准**：
- ✓ 必须先输出大纲
- ✓ 字数统计准确
- ✓ 包含字数预估
- ✓ 进行 SEO 检查
- ✓ 结构清晰，层次分明
- ✓ 语言流畅，适合发布

**SEO 检查清单**：
- 标题包含主关键词
- 合理使用 H1-H3 标题
- 段落长度适中（100-150词）
- 关键词密度 1-2%
- 包含内部/外部链接
- 图像有 alt 文本

---

## 编程场景规范

### Programmer Subagent 规则

**输出格式**：
```markdown
✓ 功能实现完成

**修改文件**：
- `src/feature.ts` (新增 XXX 行)
- `tests/feature.test.ts` (新增 XX 行)

**测试结果**：
- 测试通过：X/X
- 覆盖率：XX%

**代码质量**：
- Lint 检查：通过
- 类型检查：通过
```

**质量标准**：
- ✓ 测试覆盖率 ≥ 85%
- ✓ 核心业务逻辑覆盖率 ≥ 95%
- ✓ 通过所有单元测试
- ✓ 通过 Lint 检查
- ✓ 代码符合项目规范
- ✓ 包含必要的注释和文档

**测试要求**：
- 测试正常路径
- 测试边界条件
- 测试异常情况
- 测试可重复执行
- 测试运行快速（< 5秒）

**代码风格**：
- 遵循项目现有代码风格
- 使用一致的命名规范
- 保持函数简洁（< 50 行）
- 避免代码重复
- 适当使用设计模式

---

## 调研场景规范

### Researcher Subagent 规则

**输出格式**：
```markdown
# [调研主题] 调研报告

## Findings（研究发现）
[总结关键发现...]

## Sources（数据来源）
- [来源标题](URL) - 访问时间：2026-MM-DD
- ...

## Recommendations（建议）
1. 建议1
2. 建议2
...

## 对比表格
| 维度 | 方案A | 方案B | 方案C |
|------|-------|-------|-------|
| ... | ... | ... | ... |
```

**质量标准**：
- ✓ 所有结论必须标注来源
- ✓ 每条来源包含访问时间（2026年）
- ✓ 使用 WebSearch 验证最新信息
- ✓ 数据准确，来源可靠
- ✓ 观点客观，避免偏见
- ✓ 包含明确的推荐和理由

**信息时效性**：
- 优先使用 2025-2026 年数据
- 明确标注数据发布时间
- 对于过时信息，说明原因
- 定期更新调研结果

---

## Validator 规范

### Validator Subagent 规则

**输出格式（PASS）**：
```markdown
### PASS：所有成功标准已满足
- 成功标准 1：✓ 通过 [具体证据]
- 成功标准 2：✓ 通过 [具体证据]
- ...

**校验结论**：Milestone 成功完成，可以进入下一个 Milestone
```

**输出格式（FAIL）**：
```markdown
### FAIL：存在未满足的标准
- 成功标准 1：✗ 未通过 [具体问题]
- 成功标准 2：✓ 通过
- ...

**修复建议**：
1. [具体修复步骤]
2. [具体修复步骤]
...

**新增 Feature**：
- [需要添加的额外工作]
```

**校验方法**：
- 运行所有相关测试
- 执行 Lint 检查
- 代码 review
- 手动验证功能
- 检查文档完整性

**校验标准**：
- 严格按成功标准逐项验证
- 提供具体的证据或错误信息
- 给出可操作的修复建议
- 避免模糊的描述

---

## Worker 规范

### Worker Subagent 规则

**输出格式**：
```markdown
DONE: [feature-name]

**完成内容**：
[简要描述完成的工作]

**修改文件**：
- `path/to/file1.ts`
- `path/to/file2.ts`

**验证结果**：
[如何验证完成的工作]
```

**执行原则**：
- 快速高效完成任务
- 遵循项目代码风格
- 必要时添加注释
- 不超出任务范围
- 完成后立即报告

---

## Orchestrator 规范

### Orchestrator Subagent 规则

**输出格式**：
```markdown
【当前场景】：xxx
【Mission 状态】：进行中 / 第 N 个 Milestone

Milestones：
- [ ] Milestone 1（成功标准：...）
  Features: ...
  当前进度：xx%

当前进度：XX%
```

**工作流程**：
1. 读取或创建 mission-state.json
2. 自动判断场景（写作/编程/调研）
3. 拆解 Milestones（3-8个）
4. 每个 Milestone 拆解 Features（1-4个）
5. 调度对应的 Specialist Subagent
6. 每个 Milestone 完成后调用 Validator
7. 更新状态，显示进度

**状态管理**：
- 保持 mission-state.json 一致性
- 实时更新进度
- 及时记录问题
- 支持中断恢复

---

## 技术栈推荐

### 写作工具
- Markdown 格式
- SEO 优化工具
- 文字统计工具

### 编程工具
- 测试框架：Jest, pytest, JUnit
- Lint 工具：ESLint, Pylint
- 覆盖率工具：Istanbul, coverage.py

### 调研工具
- WebSearch 工具
- FetchUrl 工具
- 数据验证工具

---

## 错误处理

### 常见错误类型
1. **Milestone 卡住**：建议用户干预或重新评估
2. **测试失败**：修复失败用例
3. **信息不足**：请求用户补充信息
4. **技术限制**：建议替代方案

### 错误报告格式
```markdown
⚠️ 错误：[错误类型]

**问题描述**：
[详细描述]

**影响范围**：
[受影响的部分]

**建议解决方案**：
1. [方案1]
2. [方案2]
```

---

## 最佳实践

1. **始终使用 TodoWrite**：实时显示进度
2. **保持沟通**：遇到问题及时报告
3. **自我验证**：完成任务后自行检查
4. **文档完整**：所有修改都有清晰说明
5. **质量优先**：不牺牲质量追求速度
6. **状态一致**：保持 mission-state.json 准确

---

## 日志规范

### 日志级别
- **INFO**: 正常执行信息，任务开始/完成、状态变更、重大决策
- **WARN**: 警告信息，质量问题（测试覆盖率低）、潜在问题、非致命错误
- **ERROR**: 错误信息，执行失败、验证失败、致命错误
- **DEBUG**: 调试信息，详细操作、文件编辑、内部状态

### 日志记录方式
在 Orchestrator 和 Workers 中使用日志脚本：

```python
# INFO 级别
Execute(
    command='bash "$FACTORY_PROJECT_DIR/.factory/scripts/log-event.sh" "INFO" "orchestrator" "开始执行 Milestone 1"',
    riskLevel="low"
)

# WARN 级别
Execute(
    command='bash "$FACTORY_PROJECT_DIR/.factory/scripts/log-event.sh" "WARN" "validator" "测试覆盖率不足" "当前: 82%, 目标: 85%"',
    riskLevel="low"
)

# ERROR 级别
Execute(
    command='bash "$FACTORY_PROJECT_DIR/.factory/scripts/log-event.sh" "ERROR" "programmer" "测试失败" "3 个测试用例失败"',
    riskLevel="low"
)
```

### 日志最佳实践
- 只记录关键事件，避免过度记录
- 消息要简洁明确，使用 extra_info 提供额外上下文
- 包含足够的信息用于调试
- 日志记录要快速，避免阻塞执行

详细文档：`.factory/docs/LOGGING.md`

---

## 交互式规划

### 规划阶段命令
- `/plan` - 重新生成规划
- `/show-plan` - 显示当前规划
- `/edit-plan [指令]` - 编辑规划
- `/add-milestone [名称]` - 添加 Milestone
- `/add-feature [名称]` - 添加 Feature
- `/approve` - 批准规划并开始执行

### 规划流程
1. Orchestrator 分析任务目标
2. 提出澄清问题（3-5个）
3. 生成初步规划
4. 展示规划并等待用户确认
5. 用户可使用 /edit-plan 修改
6. 使用 /approve 批准后开始执行

---

## 中断恢复

### 恢复命令
- `/pause` - 暂停当前执行
- `/resume` - 从暂停点恢复
- `/redirect [指令]` - 重定向到新方向
- `/status` - 查看当前状态
- `/logs` - 查看执行日志

### 暂停机制
- 自动保存当前 checkpoint
- 记录正在执行的任务
- 支持精确恢复到中断点

### 重定向支持
- 功能调整（添加/删除/修改功能）
- 方向改变（架构调整）
- 优先级调整（重新排序）
- Milestone 调整（合并/拆分）

---

## 动态技能生成

### 触发条件
- 现有 Skills 无法满足任务需求
- 任务需要高度专业化知识
- 多次尝试使用通用 Worker 失败
- 用户明确要求创建新技能

### 生成流程
1. 识别技能缺口
2. 使用 `dynamic-skill-generator` 生成技能定义
3. 创建 `.factory/skills/custom/[skill-name].md`
4. 更新 mission-state.json.skills_used
5. 重新执行任务，使用新技能

### 技能注册
- 自动添加到 mission-state.json
- 可立即使用
- 支持跨 Mission 复用

---

## 并行执行

### 并行模式
- `auto` - 自动分析依赖关系，最大化并行
- `parallel` - 尽可能并行执行
- `sequential` - 串行执行

### 依赖管理
- 每个 Feature 可声明 dependencies
- 使用拓扑排序确定执行顺序
- 等待所有依赖完成后才执行

### 资源限制
- `max_parallel_workers` 控制并发数
- 默认 3 个并发 Worker
- 可根据系统资源调整

详细文档：`.factory/docs/PARALLEL_EXECUTION.md`
