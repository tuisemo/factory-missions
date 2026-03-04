# Mission 守卫协议 - 防止提前结束会话

## 问题描述

在长程任务执行过程中，Factory Droid 容易在某个 Milestone 完成后错误地认为整个 Mission 完成，导致：
- 提前输出总结报告
- 结束会话
- 剩余 Milestones 未执行

## 根本原因分析

### 1. 缺少全局完成检查
- Subagent 只关注当前任务，不了解整体进度
- 完成局部任务后容易触发"完成任务"的心理模型
- 缺少强制的全局状态验证

### 2. 结束条件模糊
- 没有明确的"Mission 完成"定义
- 局部完成和全局完成容易混淆
- 缺少量化的完成指标

### 3. 缺少守卫机制
- 没有在关键节点设置检查点
- 结束会话前没有强制验证
- 依赖 Subagent 自觉遵守规则

## 解决方案

### 方案 1：强制完成检查清单（已实现）

**实现文件**：`.factory/hooks/enforce-mission-completion.sh`

**触发时机**：每次 SubagentStop 时自动执行

**检查内容**：
```bash
# 1. 计算完成度
总 Milestones: N
已完成：M
完成度：M/N

总 Features: X
已完成：Y
待执行：Z

# 2. 判断是否可以结束
可以结束的条件：
- status == "completed" AND
- 已完成 Milestones == 总 Milestones AND
- 进行中 Features == 0 AND
- Pending Features == 0

# 3. 输出检查面板
显示进度、警告、建议行动
```

**输出示例**：
```
╔════════════════════════════════════════════════════════╗
║         🛡️ Mission 完成度检查（守卫机制）              ║
╠════════════════════════════════════════════════════════╣
║  Mission: 实现一个完整的博客系统                         ║
║  状态：in-progress                                      ║
║  进度：3/7 Milestones, 15/34 Features                  ║
║  进行中：5 Features                                     ║
║  待执行：14 Features                                    ║
║  已停滞：0 Features                                     ║
╚════════════════════════════════════════════════════════╝

🛡️  守卫拦截：Mission 未完成，禁止结束会话

建议行动:
  1. 继续执行剩余的 Features
  2. 处理停滞的 Features（如有）
  3. 确保所有 Milestones 验收通过

🚀 继续执行下一个任务...
   下一个任务：2.1: 设计用户表 schema
```

---

### 方案 2：更新 Backbone 文档（已实现）

**关键修改**：在 backbone.md 中添加"禁止提前结束"条款

**新增内容**：

```markdown
## 防止提前结束会话（强制条款）

### 绝对禁止的行为

❌ **禁止在以下情况结束会话**：
1. 还有 pending 或 in-progress 的 Features
2. 还有未验收的 Milestones
3. 当前 Milestone 完成但后续 Milestones 未完成
4. 有任何停滞的 Features 未处理

### 结束会话的唯一条件

✅ **只有同时满足以下条件才能结束会话**：
1. 所有 Milestones 状态为 "completed"
2. 所有 Features 状态为 "completed"
3. 最后一个 Milestone 的 Validator 验收通过
4. mission-state.json 的 status 字段为 "completed"

### 完成检查清单

在考虑结束会话前，**必须**执行以下检查：

```bash
# 运行完成度检查
bash .factory/hooks/enforce-mission-completion.sh
```

检查输出必须显示：
- ✅ 所有 Milestones 已完成
- ✅ 所有 Features 已完成
- ✅ 无进行中的任务
- ✅ 无停滞的任务
- ✅ 守卫检查通过

### 常见错误场景

**场景 1：Milestone 完成后错误结束**
```
错误：完成 Milestone 3 后，认为任务完成
正确：检查是否还有 Milestone 4, 5, 6... 待执行
```

**场景 2：Feature 完成后错误总结**
```
错误：完成一个重要 Feature 后输出总结报告
正确：继续执行下一个 Feature，直到所有完成
```

**场景 3：遇到挫折后提前放弃**
```
错误：遇到测试失败就认为任务无法完成
正确：创建修复任务，继续执行，直到达到 max_retries
```

### 强制续行机制

如果检测到会话即将结束但 Mission 未完成：

1. **自动触发守卫检查**
   ```bash
   bash .factory/hooks/enforce-mission-completion.sh
   ```

2. **显示剩余任务清单**
   - 列出所有 pending 和 in-progress 的 Features
   - 显示下一个待执行的任务
   - 提示预计剩余时间

3. **强制继续执行**
   - 派发下一个 Feature 给 Branch
   - 更新状态为 in-progress
   - 记录日志说明自动续行

4. **用户通知**
   - 输出提示信息："Mission 未完成，自动继续执行"
   - 显示剩余工作量
   - 提供暂停选项
```

---

### 方案 3：最终验收流程（新增）

**实现文件**：`.factory/droids/final-validator.md`（待创建）

**职责**：在 Mission 结束前进行最终验收

**验收清单**：
```markdown
### 最终验收检查清单

**文件完整性**：
- [ ] 所有计划的文件已创建
- [ ] 所有配置文件正确
- [ ] 所有文档完整

**功能完整性**：
- [ ] 所有 Features 已实现
- [ ] 所有 API 可正常工作
- [ ] 所有测试通过

**质量标准**：
- [ ] 测试覆盖率 ≥ 85%
- [ ] Lint 检查通过
- [ ] 无严重 Bug

**文档完整性**：
- [ ] README.md 完整
- [ ] API 文档完整
- [ ] 部署文档完整

**验收结论**：
- PASS: Mission 可以结束
- FAIL: 列出未完成项，创建修复任务
```

---

### 方案 4：会话心跳（新增）

**实现方式**：在 mission-state.json 中添加会话级心跳

**新增字段**：
```json
{
  "session_heartbeat": "2026-03-04T14:00:00Z",
  "session_status": "active",
  "last_subagent": "branch",
  "next_action": "execute_feature_2.1"
}
```

**检测机制**：
- 每 5 分钟更新会话心跳
- 如果心跳停止但 Mission 未完成，触发警告
- 防止会话"静默死亡"

---

## 实施步骤

### 步骤 1：安装守卫 Hook（已完成）

```bash
# 已将 hooks 添加到 settings.json
# 在 SubagentStop 时自动触发
```

### 步骤 2：更新 Droids 文档（进行中）

需要更新：
- backbone.md - 添加防止提前结束条款
- branch.md - 添加完成报告规范
- validator.md - 添加最终验收流程

### 步骤 3：测试守卫机制

**测试场景**：
1. 模拟完成单个 Milestone → 验证不会提前结束
2. 模拟完成 80% Features → 验证继续执行
3. 模拟完成 100% → 验证正常结束

### 步骤 4：监控和优化

**监控指标**：
- 提前结束次数：目标 0
- 守卫拦截次数：记录并分析
- 用户满意度：调查反馈

---

## 使用指南

### 对于 Backbone

**每次完成 Milestone 后**：
```markdown
1. 检查是否还有未完成的 Milestones
2. 如果有，立即开始下一个 Milestone
3. 不要输出总结报告
4. 继续派发 Features
```

**完成最后一个 Milestone 后**：
```markdown
1. 运行守卫检查：bash .factory/hooks/enforce-mission-completion.sh
2. 确认所有检查通过
3. 更新 status 为 "completed"
4. 输出最终总结报告
5. 结束会话
```

### 对于 Branch

**完成任务后**：
```markdown
1. 报告完成，不要输出 Mission 总结
2. 等待 Backbone 派发新任务
3. 不要主动结束会话
```

### 对于 Validator

**验收通过后**：
```markdown
1. 如果还有未完成的 Milestones → 提示继续
2. 如果是最后一个 Milestone → 启动最终验收
3. 最终验收通过 → 允许结束
```

---

## 错误处理

### 错误 1：守卫 Hook 未执行

**症状**：会话提前结束，守卫未触发

**原因**：settings.json 未配置或 Hook 路径错误

**解决**：
```bash
# 检查 settings.json
cat .factory/settings.json | jq '.hooks.SubagentStop'

# 检查 Hook 文件是否存在
ls -la .factory/hooks/enforce-mission-completion.sh

# 测试 Hook
bash .factory/hooks/enforce-mission-completion.sh
```

### 错误 2：状态不一致

**症状**：显示 completed 但实际未完成

**原因**：状态更新错误或手动修改

**解决**：
```bash
# 强制重新计算状态
bash .factory/hooks/enforce-mission-completion.sh

# 手动修正（如需要）
jq '.status = "in-progress"' mission-state.json > tmp.json && mv tmp.json mission-state.json
```

### 错误 3：无限循环

**症状**：守卫一直触发，无法正常结束

**原因**：完成条件判断错误

**解决**：
```bash
# 检查完成度
jq '{
  total_milestones: (.milestones | length),
  completed_milestones: ([.milestones[] | select(.status == "completed")] | length),
  total_features: ([.milestones[].features | length] | add),
  completed_features: ([.milestones[].features[] | select(.status == "completed")] | length)
}' mission-state.json
```

---

## 最佳实践

1. **始终运行守卫检查**
   - 完成任何任务后都运行
   - 不要依赖主观判断

2. **量化的完成标准**
   - 使用数字而不是感觉
   - 100% = 真正完成

3. **渐进式完成**
   - 完成一个 Milestone 就标记一个
   - 不要等到最后一起标记

4. **定期同步状态**
   - 每完成 10% 进度同步一次
   - 确保状态和实际一致

---

## 总结

通过 4 层防护机制确保 Mission 不会提前结束：

1. **Hook 守卫**：自动检查完成度（已实现）
2. **文档规范**：明确禁止提前结束（已实现）
3. **最终验收**：结束前强制验收（待实现）
4. **会话心跳**：监控会话活跃度（待实现）

**预期效果**：
- 提前结束次数：→ 0
- Mission 完成率：→ 100%
- 用户满意度：显著提升
