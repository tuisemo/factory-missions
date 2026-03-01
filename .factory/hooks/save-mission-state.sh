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

# 确保状态文件存在
if [ ! -f "$STATE" ]; then
    echo '{}' > "$STATE"
fi

# 更新状态：添加时间戳
if command -v jq >/dev/null 2>&1; then
    # 使用不同方式获取 ISO 8601 时间戳
    if command -v date >/dev/null 2>&1; then
        # Linux/macOS/Windows Git Bash
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%S%:z" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S")
    elif command -v powershell >/dev/null 2>&1; then
        # Windows PowerShell fallback
        TIMESTAMP=$(powershell -Command "Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ'" 2>/dev/null || echo "2026-03-01T14:35:00Z")
    else
        TIMESTAMP="2026-03-01T14:35:00Z"
    fi

    # 只有在 jq 成功时才覆盖原文件，防止清空状态文件
    if jq --arg ts "$TIMESTAMP" '.last_updated = $ts' "$STATE" > "$STATE_TMP" 2>/dev/null; then
        mv "$STATE_TMP" "$STATE"
    else
        echo "⚠️ Warning: jq failed to update mission state. Preservation mode engaged." >&2
        rm -f "$STATE_TMP"
    fi
fi

# Git 提交（如果在Git仓库中）
cd "$PROJECT_DIR"
if [ -d ".git" ] && command -v git >/dev/null 2>&1; then
    git add "$STATE" 2>/dev/null || true
    git commit -m "chore(mission): update mission state" 2>/dev/null || echo "✓ Mission state 已更新"
else
    echo "✓ Mission state 已更新"
fi
