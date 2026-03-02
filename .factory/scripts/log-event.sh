#!/bin/bash
# Log Event Helper Script
# 便捷的日志记录脚本，可被其他脚本调用
# 用法: ./log-event.sh [LEVEL] [SOURCE] [MESSAGE] [EXTRA_INFO]

set -e

LEVEL="${1:-INFO}"
SOURCE="${2:-system}"
MESSAGE="${3:-}"
EXTRA_INFO="${4:-}"

# Use FACTORY_PROJECT_DIR if available
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="${FACTORY_PROJECT_DIR//\\//}"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

HOOKS_DIR="$PROJECT_DIR/.factory/hooks"
LOG_HOOK="$HOOKS_DIR/log-mission-event.sh"

# 构建日志 JSON
LOG_JSON=$(jq -n \
    --arg level "$LEVEL" \
    --arg source "$SOURCE" \
    --arg message "$MESSAGE" \
    --arg extra_info "$EXTRA_INFO" \
    '{
        level: $level,
        source: $source,
        message: $message,
        extra_info: $extra_info
    }')

# 调用日志 hook
if [ -f "$LOG_HOOK" ]; then
    echo "$LOG_JSON" | bash "$LOG_HOOK"
fi
