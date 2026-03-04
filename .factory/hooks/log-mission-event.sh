#!/bin/bash
# Log Mission Event Hook (Enhanced Version)
# 在关键事件发生时自动记录日志到 mission-state.json
# 增强容错能力，不依赖 jq 也能记录日志到独立文件

set -e

# Use FACTORY_PROJECT_DIR if available
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="${FACTORY_PROJECT_DIR//\\//}"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"
LOG_DIR="$PROJECT_DIR/logs/mission-logs"

# 创建日志目录
mkdir -p "$LOG_DIR" 2>/dev/null || true

# 从 stdin 读取日志数据（JSON 格式）
INPUT=$(cat)

# 获取时间戳
get_timestamp() {
    if command -v date >/dev/null 2>&1; then
        date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S"
    else
        echo "2026-03-04T00:00:00Z"
    fi
}

# 提取日志字段（不依赖 jq 的方式）
extract_field() {
    local field="$1"
    local input="$2"
    
    if command -v jq >/dev/null 2>&1; then
        echo "$input" | jq -r ".$field // \"\"" 2>/dev/null
    else
        # 简单的 sed 提取（适用于简单 JSON）
        echo "$input" | sed -n "s/.*\"$field\": *\"\([^\"]*\)\".*/\1/p" | head -1
    fi
}

TIMESTAMP=$(get_timestamp)
LOG_LEVEL=$(extract_field "level" "$INPUT")
SOURCE=$(extract_field "source" "$INPUT")
MESSAGE=$(extract_field "message" "$INPUT")
EXTRA_INFO=$(extract_field "extra_info" "$INPUT")

# 默认值
LOG_LEVEL=${LOG_LEVEL:-INFO}
SOURCE=${SOURCE:-unknown}

# 如果没有消息，退出
if [ -z "$MESSAGE" ]; then
    exit 0
fi

# 记录到独立日志文件（总是有效）
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"
{
    echo "[$TIMESTAMP] [$LOG_LEVEL] [$SOURCE] $MESSAGE"
    if [ -n "$EXTRA_INFO" ]; then
        echo "  - Extra: $EXTRA_INFO"
    fi
} >> "$LOG_FILE"

# 尝试更新 mission-state.json 中的 logs 数组
if [ -f "$STATE" ] && command -v jq >/dev/null 2>&1; then
    # 构建日志条目
    if [ -n "$EXTRA_INFO" ]; then
        LOG_ENTRY="{\"timestamp\":\"$TIMESTAMP\",\"level\":\"$LOG_LEVEL\",\"source\":\"$SOURCE\",\"message\":\"$MESSAGE\",\"extra_info\":\"$EXTRA_INFO\"}"
    else
        LOG_ENTRY="{\"timestamp\":\"$TIMESTAMP\",\"level\":\"$LOG_LEVEL\",\"source\":\"$SOURCE\",\"message\":\"$MESSAGE\"}"
    fi
    
    # 添加日志到 mission-state.json
    NEW_STATE=$(jq --argjson log "$LOG_ENTRY" '
        if .logs == null then .logs = [] end |
        .logs += [$log] |
        .logs |= .[-100:]  # 保留最近 100 条日志
    ' "$STATE" 2>/dev/null)
    
    if [ -n "$NEW_STATE" ]; then
        echo "$NEW_STATE" > "$STATE"
        echo "✓ Log added to mission-state.json"
    else
        echo "⚠️ Warning: Failed to update mission-state.json, log saved to file only" >&2
    fi
else
    echo "✓ Log saved to $LOG_FILE"
fi

echo "✓ Log hook completed"
