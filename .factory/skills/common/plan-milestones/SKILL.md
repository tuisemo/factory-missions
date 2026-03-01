---
name: plan-milestones
description: 把任意目标拆成 Milestones + Features + 成功标准
user-invocable: true
disable-model-invocation: false
---

# Plan Milestones Skill

**功能**：将任意目标自动拆解为 Milestones 和 Features

**输入**：
- Mission 目标
- 当前代码/文档状态（可选）

**输出**：
- Milestones 列表（3-8个）
- 每个 Milestone 包含：
  - 名称
  - 成功标准（可验证的具体要求）
  - Features 列表（1-4个具体任务）
  - 预估时间（可选）

**使用场景**：
- 用户提出新 Mission 时
- Mission 需要重新规划时
- 复杂任务需要拆解时

**示例**：
输入：实现一个博客系统
输出：
- Milestone 1: 项目初始化
  - 成功标准：项目结构搭建完成，可运行
  - Features: 创建项目目录、配置依赖、初始化数据库
- Milestone 2: 核心功能实现
  - ...
