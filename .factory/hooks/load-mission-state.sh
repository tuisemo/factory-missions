#!/bin/bash
# Load Mission State Hook
# 在会话开始时加载并显示当前Mission状态

set -e

# Use FACTORY_PROJECT_DIR if available, otherwise calculate relative to script
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"

if [ -f "$STATE" ]; then
    echo ""
    echo "========================================"
    echo "  当前 Mission 进度"
    echo "========================================"
    echo ""

    if command -v jq >/dev/null 2>&1; then
        # 如果安装了jq，格式化输出
        jq -r '
            "场景: \(.scene // "未定义")" +
            "\n目标: \(.mission_goal // "未定义")" +
            "\n当前 Milestone: \(.current_milestone + 1)/\(.milestones | length)" +
            "\n状态: \(.status // "进行中")" +
            "\n最后更新: \(.last_updated // "未知")"
        ' "$STATE"

        echo ""
        echo "----------------------------------------"
        echo "Milestones 列表："
        echo ""
        jq -r '.milestones[] | "\(.status == "completed" ? "✓" : "○") Milestone \(.id + 1): \(.name)"' "$STATE"
    else
        # 如果没有jq，简单输出
        cat "$STATE"
    fi

    echo ""
    echo "========================================"
    echo ""
else
    echo "📝 新 Mission 已启动，mission-state.json 将在首次执行时创建"
    echo ""
fi
