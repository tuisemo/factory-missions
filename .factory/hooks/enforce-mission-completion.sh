#!/bin/bash
# Enforce Mission Completion Hook
# 强制检查 Mission 完成状态，防止提前结束会话
# 基于 jq 实现，提供精确的 JSON 解析和完整的完成度检查

set -e

# Use FACTORY_PROJECT_DIR if available
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="${FACTORY_PROJECT_DIR//\\//}"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"

# 检查状态文件是否存在
if [ ! -f "$STATE" ]; then
    echo "⚠️  Warning: mission-state.json not found" >&2
    exit 0
fi

# 读取 Mission 基本信息
MISSION_GOAL=$(jq -r '.mission_goal // "Unknown"' "$STATE")
STATUS=$(jq -r '.status // "unknown"' "$STATE")
CREATED_AT=$(jq -r '.created_at // "Unknown"' "$STATE")

# 计算 Milestones 统计
TOTAL_MILESTONES=$(jq -r '.milestones | length' "$STATE")
COMPLETED_MILESTONES=$(jq -r '[.milestones[] | select(.status == "completed")] | length' "$STATE")
IN_PROGRESS_MILESTONES=$(jq -r '[.milestones[] | select(.status == "in-progress")] | length' "$STATE")
PENDING_MILESTONES=$(jq -r '[.milestones[] | select(.status == "pending")] | length' "$STATE")

# 计算 Features 统计
TOTAL_FEATURES=$(jq -r '[.milestones[].features | length] | add // 0' "$STATE")
COMPLETED_FEATURES=$(jq -r '[.milestones[].features[] | select(.status == "completed")] | length' "$STATE")
IN_PROGRESS_FEATURES=$(jq -r '[.milestones[].features[] | select(.status == "in-progress")] | length' "$STATE")
PENDING_FEATURES=$(jq -r '[.milestones[].features[] | select(.status == "pending")] | length' "$STATE")
STAGNATED_FEATURES=$(jq -r '[.milestones[].features[] | select(.status == "stagnated")] | length' "$STATE")

# 计算完成百分比
if [ "$TOTAL_FEATURES" -gt 0 ]; then
    COMPLETION_PERCENT=$((COMPLETED_FEATURES * 100 / TOTAL_FEATURES))
else
    COMPLETION_PERCENT=0
fi

# 显示完成度面板
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║         🛡️ Mission 完成度检查（守卫机制）              ║"
echo "╠════════════════════════════════════════════════════════╣"
printf "║  Mission: %-50s ║\n" "${MISSION_GOAL:0:50}"
echo "║  状态：$STATUS"
echo "║  创建时间：$CREATED_AT"
echo "╠════════════════════════════════════════════════════════╣"
echo "║  Milestones 进度："
printf "║    总计：%d | 已完成：%d | 进行中：%d | 待执行：%d\n" "$TOTAL_MILESTONES" "$COMPLETED_MILESTONES" "$IN_PROGRESS_MILESTONES" "$PENDING_MILESTONES"
echo "╠════════════════════════════════════════════════════════╣"
echo "║  Features 进度："
printf "║    总计：%d | 已完成：%d | 进行中：%d | 待执行：%d\n" "$TOTAL_FEATURES" "$COMPLETED_FEATURES" "$IN_PROGRESS_FEATURES" "$PENDING_FEATURES"
echo "╠════════════════════════════════════════════════════════╣"
printf "║  总体完成度：%3d%% (%d/%d)                             ║\n" "$COMPLETION_PERCENT" "$COMPLETED_FEATURES" "$TOTAL_FEATURES"
echo "╠════════════════════════════════════════════════════════╣"
if [ "$STAGNATED_FEATURES" -gt 0 ]; then
    printf "║  ⚠️  停滞警告：%d 个 Features 已停滞                      ║\n" "$STAGNATED_FEATURES"
else
    echo "║  ✅ 无停滞任务                                          ║"
fi
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# 判断是否可以结束 Mission
CAN_COMPLETE=false
EXIT_CODE=0

if [ "$STATUS" = "completed" ]; then
    # 状态已经是 completed，检查是否真实完成
    if [ "$COMPLETED_MILESTONES" -eq "$TOTAL_MILESTONES" ] && \
       [ "$COMPLETED_FEATURES" -eq "$TOTAL_FEATURES" ] && \
       [ "$IN_PROGRESS_FEATURES" -eq 0 ] && \
       [ "$PENDING_FEATURES" -eq 0 ]; then
        echo "✅ Mission 真实完成！所有 $TOTAL_MILESTONES 个 Milestones 和 $TOTAL_FEATURES 个 Features 已完成。"
        CAN_COMPLETE=true
    else
        echo "⚠️  警告：状态为 completed 但实际未完成！"
        echo "   已完成：$COMPLETED_MILESTONES/$TOTAL_MILESTONES Milestones"
        echo "   待执行：$PENDING_FEATURES Features"
        echo "   进行中：$IN_PROGRESS_FEATURES Features"
        echo "   强制修正状态为 in-progress..."
        
        # 修正状态
        jq '.status = "in-progress"' "$STATE" > "${STATE}.tmp" && mv "${STATE}.tmp" "$STATE"
        EXIT_CODE=1
    fi
elif [ "$STATUS" = "in-progress" ]; then
    # 检查是否应该标记为 completed
    if [ "$COMPLETED_MILESTONES" -eq "$TOTAL_MILESTONES" ] && \
       [ "$COMPLETED_FEATURES" -eq "$TOTAL_FEATURES" ] && \
       [ "$IN_PROGRESS_FEATURES" -eq 0 ] && \
       [ "$PENDING_FEATURES" -eq 0 ]; then
        echo "✅ 所有 Milestones 和 Features 已完成，Mission 可以结束！"
        CAN_COMPLETE=true
    else
        echo "⏳ Mission 仍在进行中，不能结束会话。"
        echo ""
        
        # 显示待完成任务
        if [ "$PENDING_FEATURES" -gt 0 ] || [ "$IN_PROGRESS_FEATURES" -gt 0 ]; then
            echo "📋 待完成任务:"
            echo "   - Pending Features: $PENDING_FEATURES"
            echo "   - In-Progress Features: $IN_PROGRESS_FEATURES"
            echo ""
            
            # 获取下一个待执行的 Feature
            NEXT_FEATURE=$(jq -r '
                .milestones[]
                | select(.status == "in-progress" or .status == "pending")
                | .features[]
                | select(.status == "pending" or .status == "in-progress")
                | "\(.id): \(.name)"
            ' "$STATE" | head -1)
            
            if [ -n "$NEXT_FEATURE" ]; then
                echo "🚀 下一个任务：$NEXT_FEATURE"
                echo ""
                echo "💡 建议：继续执行剩余 Features，直到完成度达到 100%"
            fi
        fi
        
        # 如果有停滞的 Features，需要处理
        if [ "$STAGNATED_FEATURES" -gt 0 ]; then
            echo ""
            echo "⚠️  警告：检测到 $STAGNATED_FEATURES 个停滞的 Features！"
            echo "   需要 Backbone 进行干预和重新调度。"
        fi
        
        EXIT_CODE=1
    fi
elif [ "$STATUS" = "paused" ]; then
    echo "⏸️  Mission 已暂停，需要用户确认后恢复。"
    echo ""
    echo "💡 使用 /mission-resume 恢复执行"
    EXIT_CODE=1
else
    echo "⚠️  未知状态：$STATUS"
    EXIT_CODE=1
fi

echo ""

# 输出守卫结论
if [ "$CAN_COMPLETE" = true ]; then
    echo "✅ 守卫检查通过：Mission 可以安全结束"
    echo ""
    echo "📊 最终统计:"
    echo "   - Milestones: $COMPLETED_MILESTONES/$TOTAL_MILESTONES (100%)"
    echo "   - Features: $COMPLETED_FEATURES/$TOTAL_FEATURES (100%)"
    echo "   - 完成度：100%"
    echo ""
    echo "🎉 恭喜！Mission 成功完成！"
    exit 0
else
    echo "🛡️  守卫拦截：Mission 未完成，禁止结束会话"
    echo ""
    echo "建议行动:"
    echo "  1. 继续执行剩余的 Features"
    echo "  2. 处理停滞的 Features（如有）"
    echo "  3. 确保所有 Milestones 验收通过"
    echo "  4. 运行 /mission-status 查看详细进度"
    echo ""
    exit $EXIT_CODE
fi
