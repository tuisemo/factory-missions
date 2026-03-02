---
name: dynamic-skill-generator
description: 动态生成新的技能（Skill）以应对特定任务需求
user-invocable: true
disable-model-invocation: false
---

# Dynamic Skill Generator

**功能**：在 Mission 执行过程中，动态创建新的技能定义以满足特定需求

**触发场景**：
- 当前已有的 Skills 无法满足任务需求
- 任务需要高度专业化的知识或流程
- 多次尝试使用通用 Worker 失败
- 用户或 Orchestrator 明确需要新技能

**生成流程**：

1. **需求分析**
   - 识别当前任务的具体需求
   - 分析为什么现有 Skills 不足
   - 确定新技能的核心职责

2. **技能设计**
   - 定义技能名称（简洁、描述性）
   - 编写详细描述（50-100 字）
   - 确定所需的工具（tools）
   - 制定工作流程
   - 设定输出格式和质量标准

3. **技能创建**
   - 在 `.factory/skills/custom/` 目录下创建新的 SKILL.md 文件
   - 文件名使用 kebab-case 格式，如 `custom-skill-name.md`
   - 使用标准格式编写技能定义

4. **注册更新**
   - 在 mission-state.json 的 `skills_used` 数组中添加新技能名称
   - 更新 last_updated

5. **验证测试**
   - 使用新技能执行一个简单的测试任务
   - 验证技能是否正常工作
   - 如有问题，调整技能定义

**技能定义模板**：

```markdown
---
name: [skill-name]
description: [简短描述，50-100 字]
user-invocable: true
disable-model-invocation: false
---

# [Skill Display Name]

## 功能描述
[详细描述这个技能的功能和用途]

## 使用场景
- [场景 1]
- [场景 2]
- [场景 3]

## 输入要求
- [必需输入 1]
- [必需输入 2]
- [可选输入 1]

## 输出格式
```
[示例输出格式]
```

## 工作流程
1. [步骤 1]
2. [步骤 2]
3. [步骤 3]

## 质量标准
- ✓ [质量标准 1]
- ✓ [质量标准 2]

## 注意事项
- [注意事项 1]
- [注意事项 2]
```

**示例场景**：

**场景 1：生成 "GraphQL API 设计" 技能**

```
任务：设计和实现 GraphQL API
现有技能：code-implement（通用编码）
问题：缺少 GraphQL 特定的最佳实践和模式

生成过程：
1. 识别需要 GraphQL Schema 设计、Resolver 实现、查询优化等知识
2. 创建技能定义，包含：
   - GraphQL Schema 设计原则
   - 常见查询模式和反模式
   - 性能优化技巧
   - 测试策略
3. 保存为 .factory/skills/custom/graphql-api-design.md
4. 更新 mission-state.json
```

**场景 2：生成 "数据库迁移脚本" 技能**

```
任务：编写数据库迁移脚本
现有技能：无
问题：需要数据库特定的知识（SQL、迁移工具、回滚策略）

生成过程：
1. 识别需要迁移脚本编写、版本控制、测试等能力
2. 创建技能定义，包含：
   - 迁移脚本编写规范
   - 常用迁移工具（Flyway、Liquibase、Alembic）
   - 向前和向后兼容性
   - 回滚策略
3. 保存为 .factory/skills/custom/database-migration.md
4. 更新 mission-state.json
```

**输出格式**：

```text
✓ 新技能已创建

技能名称: [skill-name]
文件路径: .factory/skills/custom/[file-name].md
描述: [技能描述]

应用场景:
- [应用场景 1]
- [应用场景 2]

📝 已更新 mission-state.json
   skills_used: [..., "[skill-name]"]

💡 技能已注册，可以立即使用
   使用方式：在 Worker 或 Subagent 中引用此技能
```

**错误处理**：
- 如果技能目录不存在，自动创建
- 如果技能名称已存在，添加版本号或后缀
- 如果生成的技能定义有问题，提示并重新生成

**最佳实践**：
- 技能名称要简洁且具有描述性
- 描述要清晰，让其他开发者能快速理解技能用途
- 工作流程要具体，避免模糊的步骤
- 质量标准要可量化，便于验证
- 添加使用示例，降低学习成本
