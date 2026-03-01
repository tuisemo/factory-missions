---
name: test-coverage
description: 确保代码测试覆盖率 ≥ 85%，生成测试报告
user-invocable: true
disable-model-invocation: false
---

# Test Coverage Skill

**功能**：确保代码测试覆盖率达到 85% 以上，生成详细报告

**输入**：
- 代码文件/目录
- 测试框架
- 覆盖率目标（默认 85%）

**输出**：
1. 测试覆盖率报告
2. 未覆盖代码列表
3. 覆盖率提升建议
4. 测试代码（如需补充）

**覆盖率计算**：
- 行覆盖率（Line Coverage）
- 分支覆盖率（Branch Coverage）
- 函数覆盖率（Function Coverage）
- 语句覆盖率（Statement Coverage）

**目标要求**：
- 总覆盖率 ≥ 85%
- 核心业务逻辑 ≥ 95%
- 边界情况 ≥ 80%

**工作流程**：
1. 运行测试并生成覆盖率报告
2. 分析未覆盖的代码
3. 识别关键未覆盖路径
4. 补充测试用例
5. 重新验证覆盖率
6. 生成最终报告

**覆盖率工具推荐**：
- JavaScript/TypeScript: Istanbul (nyc), c8
- Python: coverage.py, pytest-cov
- Java: JaCoCo
- Go: go test -cover
- Ruby: SimpleCov

**报告格式**：
```markdown
# 测试覆盖率报告

## 总体覆盖率
- 行覆盖率：92.5%
- 分支覆盖率：88.3%
- 函数覆盖率：100%
- 目标：85% ✓

## 按文件覆盖率
| 文件 | 行覆盖 | 分支覆盖 | 状态 |
|------|--------|----------|------|
| src/api.ts | 95% | 90% | ✓ |
| src/utils.ts | 100% | 100% | ✓ |
| src/legacy.ts | 70% | 65% | ✗ |

## 未覆盖代码
- src/legacy.ts:45-52（错误处理逻辑）
- ...

## 建议
1. 为 src/legacy.ts 补充错误处理测试
2. 增加边界情况测试
```

**使用场景**：
- PR 前检查
- 代码质量门禁
- 重构验证
- CI/CD 流程
