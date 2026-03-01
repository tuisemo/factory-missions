#!/bin/bash
# Notify Milestone Hook
# 在Milestone完成时发送桌面通知
# 兼容 Windows (Git Bash)、Linux 和 macOS

set -e

# 尝试不同的通知方法
notify() {
    local message="$1"

    # Windows (PowerShell) - 优先在 Windows 环境
    if command -v powershell >/dev/null 2>&1; then
        # 使用 Toast 通知（更现代，非阻塞）
        powershell -Command "Add-Type -AssemblyName Windows.UI.Notifications; [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier('Factory Droid Mission').Show([Windows.UI.Notifications.ToastNotification]::new([Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime]::new().LoadXml(\"<toast><visual><binding template='ToastGeneric'><text>Factory Droid Mission</text><text>$message</text></binding></visual></toast>\")))" 2>/dev/null || \
        # 回退到 Windows 通知 API
        powershell -Command "[void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]; \$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(Windows.UI.Notifications.ToastTemplateType::ToastText02); \$textNodes = \$template.GetElementsByTagName('text'); \$textNodes.Item(0).AppendChild(\$template.CreateTextNode('Factory Droid Mission')); \$textNodes.Item(1).AppendChild(\$template.CreateTextNode('$message')); \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$template); [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Factory Droid Mission').Show(\$toast)" 2>/dev/null || \
        # 回退到简单的消息框
        echo -e "\a$message"
    # macOS
    elif command -v osascript >/dev/null 2>&1; then
        osascript -e "display notification \"$message\" with title \"Factory Droid Mission\""
    # Linux (notify-send)
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "Factory Droid Mission" "$message"
    # Terminal bell (跨平台)
    elif [ -t 1 ]; then
        echo -e "\a$message"
        # Windows 不支持 tput，但命令行铃声会工作
        if command -v tput >/dev/null 2>&1; then
            tput bel 2>/dev/null || true
        fi
    fi
}

# 读取Mission状态以获取当前进度
if [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
fi

STATE="$PROJECT_DIR/mission-state.json"

message="Milestone 完成！"

if [ -f "$STATE" ] && command -v jq >/dev/null 2>&1; then
    current=$(jq -r '.current_milestone + 1' "$STATE" 2>/dev/null)
    total=$(jq -r '.milestones | length' "$STATE" 2>/dev/null)
    milestone_name=$(jq -r '.milestones[.current_milestone].name // "Unknown"' "$STATE" 2>/dev/null)

    if [ "$current" != "null" ] && [ "$total" != "null" ] && [ "$current" != "null+1" ]; then
        message="Milestone $current/$total 完成: $milestone_name"
    fi
fi

# 发送通知
notify "$message"

echo ""
echo "========================================"
echo "  🎉 $message"
echo "========================================"
echo ""
