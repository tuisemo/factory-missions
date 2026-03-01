---
name: validate-output
description: 通用输出格式校验，确保符合规范
user-invocable: true
disable-model-invocation: false
---

# Validate Output Skill

**功能**：验证输出是否符合场景特定的格式和规范

**输入**：
- 输出内容
- 场景类型（writing/programming/research）

**输出**：
- PASS / FAIL
- 不符合规范的具体问题
- 修正建议

**校验规则**：

**Writing 场景**：
- ✓ 包含大纲
- ✓ 包含字数统计
- ✓ 包含字数预估
- ✓ SEO关键词检查
- ✓ 结构清晰完整

**Programming 场景**：
- ✓ 代码符合最佳实践
- ✓ 测试覆盖率 ≥ 85%
- ✓ 通过 lint 检查
- ✓ 通过所有测试

**Research 场景**：
- ✓ 包含 Findings
- ✓ 包含 Sources（带访问时间）
- ✓ 包含 Recommendations
- ✓ 数据来源可靠（2025-2026年）

**使用场景**：
- 每个 Feature 完成后
- 每个 Milestone 完成后
- 用户要求验证时
