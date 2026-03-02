#!/bin/bash
# Log Mission Event Hook
# 在关键事件发生时自动记录日志到 mission-state.json
# 兼容 Windows (Git Bash)、Linux 和 macOS

set -e

# Use FACTORY_PROJECT_DIR if available
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="${FACTORY_PROJECT_DIR//\\//}"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"

# 从 stdin 读取日志数据（JSON 格式）
INPUT=$(cat)

# 提取日志字段
LOG_LEVEL=$(echo "$INPUT" | jq -r '.level // "INFO"' 2>/dev/null || echo "INFO")
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"' 2>/dev/null || echo "unknown")
MESSAGE=$(echo "$INPUT" | jq -r '.message // ""' 2>/dev/null || echo "")
EXTRA_INFO=$(echo "$INPUT" | jq -r '.extra_info // ""' 2>/dev/null || echo "")

# 如果没有消息，退出
if [ -z "$MESSAGE" ]; then
    exit 0
fi

# 获取 ISO 时间戳
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S")

# 构建日志条目
LOG_ENTRY="{
  \"timestamp\": \"$TIMESTAMP\",
  \"level\": \"$LOG_LEVEL\",
  \"source\": \"$SOURCE\",
  \"message\": \"$MESSAGE\"$([ -n "$EXTRA_INFO" ] && echo ", \"extra_info\": \"$EXTRA_INFO\"")
}"

# 如果 jq 不可用，跳过
if ! command -v jq >/dev/null 2>&1; then
    exit 0
fi

# 添加日志到 mission-state.json
if [ -f "$STATE" ]; then
    # 添加新的日志条目
    NEW_STATE=$(jq --argjson log "$LOG_ENTRY" '
        if .logs == null then .logs = [] end |
        .logs += [$log] |
        .logs |= .[-100:]  # 保留最近 100 条日志
    ' "$STATE" 2>/dev/null)

    if [ -n "$NEW_STATE" ]; then
        echo "$NEW_STATE" > "$STATE"
    fi
fi
