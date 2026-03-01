#!/bin/bash
# Save Mission State Hook
# 在子代理停止后自动保存状态并提交到Git
# 兼容 Windows (Git Bash)、Linux 和 macOS

set -e

# 检测操作系统
OS_TYPE="$(uname -s)"

# Use FACTORY_PROJECT_DIR if available
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"
STATE_TMP="${STATE}.tmp"

# 确保状态文件存在并标准化路径
if [ ! -f "$STATE" ]; then
    echo '{}' > "$STATE"
fi

# 转换 Windows 路径为本地路径格式以供显示
DISPLAY_PATH="${STATE//\\//}"

# 更新状态：添加时间戳
if command -v jq >/dev/null 2>&1; then
    # 使用不同方式获取 ISO 8601 时间戳
    if command -v date >/dev/null 2>&1; then
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S")
    else
        TIMESTAMP="2026-03-01T23:02:00Z"
    fi

    # 鲁棒性更新
    NEW_STATE=$(jq --arg ts "$TIMESTAMP" '.last_updated = $ts' "$STATE" 2>/dev/null)
    if [ -z "$NEW_STATE" ]; then
        echo "⚠️ Warning: jq failed to parse state. Preservation mode engaged." >&2
    else
        echo "$NEW_STATE" > "$STATE"
    fi
else
    # 简单回退：仅更新文件修改时间
    touch "$STATE"
fi

# Git 提交（如果在Git仓库中）
cd "$PROJECT_DIR"
if [ -d ".git" ] && command -v git >/dev/null 2>&1; then
    git add "$STATE" 2>/dev/null || true
    git commit -m "chore(mission): update mission state" 2>/dev/null || echo "✓ Mission state 已更新"
else
    echo "✓ Mission state 已更新"
fi
