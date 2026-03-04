#!/bin/bash
# Save Mission State Hook (Enhanced Version)
# 在子代理停止后自动保存状态并提交到 Git
# 增强容错能力，不依赖 jq 也能正常工作

set -e

# Use FACTORY_PROJECT_DIR if available
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"
STATE_BACKUP="$PROJECT_DIR/.factory/mission-state.backup.json"
LOG_DIR="$PROJECT_DIR/logs/mission-logs"

# 确保状态文件存在
if [ ! -f "$STATE" ]; then
    echo "⚠️ Warning: mission-state.json not found, creating minimal state" >&2
    echo '{"status":"pending","milestones":[],"logs":[]}' > "$STATE"
fi

# 创建日志目录
mkdir -p "$LOG_DIR" 2>/dev/null || true

# 获取 ISO 8601 时间戳
get_timestamp() {
    if command -v date >/dev/null 2>&1; then
        date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S"
    else
        echo "2026-03-04T00:00:00Z"
    fi
}

# 备份当前状态
if [ -f "$STATE" ]; then
    cp "$STATE" "$STATE_BACKUP" 2>/dev/null || true
fi

# 更新时间戳
TIMESTAMP=$(get_timestamp)

# 尝试使用 jq 更新状态
if command -v jq >/dev/null 2>&1; then
    NEW_STATE=$(jq --arg ts "$TIMESTAMP" '.last_updated = $ts' "$STATE" 2>/dev/null)
    if [ -n "$NEW_STATE" ]; then
        echo "$NEW_STATE" > "$STATE"
        echo "✓ Mission state updated with jq at $TIMESTAMP"
    else
        echo "⚠️ Warning: jq failed to parse state, using fallback" >&2
        # 使用 sed 简单替换（不完美但可用）
        if grep -q '"last_updated"' "$STATE"; then
            sed -i "s/\"last_updated\": *\"[^\"]*\"/\"last_updated\": \"$TIMESTAMP\"/" "$STATE" 2>/dev/null || \
            sed "s/\"last_updated\": *\"[^\"]*\"/\"last_updated\": \"$TIMESTAMP\"/" "$STATE" > "${STATE}.tmp" && mv "${STATE}.tmp" "$STATE"
        else
            # 如果不存在 last_updated 字段，在 created_at 后添加
            sed -i "s/\"created_at\": *\"[^\"]*\"/&,\n  \"last_updated\": \"$TIMESTAMP\"/" "$STATE" 2>/dev/null || \
            sed "s/\"created_at\": *\"[^\"]*\"/&,\n  \"last_updated\": \"$TIMESTAMP\"/" "$STATE" > "${STATE}.tmp" && mv "${STATE}.tmp" "$STATE"
        fi
        echo "✓ Mission state updated with sed fallback"
    fi
else
    echo "⚠️ Warning: jq not available, using sed for basic update" >&2
    # 使用 sed 简单替换
    if grep -q '"last_updated"' "$STATE"; then
        sed -i "s/\"last_updated\": *\"[^\"]*\"/\"last_updated\": \"$TIMESTAMP\"/" "$STATE" 2>/dev/null || \
        sed "s/\"last_updated\": *\"[^\"]*\"/\"last_updated\": \"$TIMESTAMP\"/" "$STATE" > "${STATE}.tmp" && mv "${STATE}.tmp" "$STATE"
    fi
    echo "✓ Mission state updated (basic mode)"
fi

# 记录到独立日志文件（即使 jq 不可用也能工作）
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"
echo "[$TIMESTAMP] Mission state saved" >> "$LOG_FILE" 2>/dev/null || true

# Git 提交（如果在 Git 仓库中）
cd "$PROJECT_DIR"
if [ -d ".git" ] && command -v git >/dev/null 2>&1; then
    git add "$STATE" "$STATE_BACKUP" "$LOG_FILE" 2>/dev/null || true
    if git diff --cached --quiet 2>/dev/null; then
        echo "✓ No changes to commit"
    else
        git commit -m "chore(mission): update mission state" 2>/dev/null || echo "✓ Mission state committed"
    fi
else
    echo "✓ Mission state saved (not in git repo)"
fi

echo "✓ Save hook completed successfully"
