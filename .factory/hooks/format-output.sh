#!/bin/bash
# Format Output Hook
# 在文件编辑后自动格式化代码
# PostToolUse hook 通过 stdin 传递 JSON 数据，包含 tool_input.file_path
# 兼容 Windows (Git Bash)、Linux 和 macOS

set -e

# 获取调试模式
DEBUG_MODE=false
if [[ "$*" == *"--debug"* ]]; then
    DEBUG_MODE=true
fi

log_debug() {
    if [ "$DEBUG_MODE" = true ]; then
        echo "[DEBUG] $1" >&2
    fi
}

# 从 stdin 读取 JSON 数据
if ! command -v jq >/dev/null 2>&1; then
    log_debug "jq not found. Skipping formatting."
    exit 0
fi

INPUT=$(cat)

# 提取文件路径
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# 如果没有文件路径或文件不存在，退出
if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    log_debug "No file path provided or file does not exist: $FILE_PATH"
    exit 0
fi

# 转换 Windows 路径为 Git Bash 兼容格式
FILE_PATH="${FILE_PATH//\\//}"

# 根据文件扩展名选择格式化工具
EXT="${FILE_PATH##*.}"
FORMATTED=false

case "$EXT" in
    md|mdx)
        if command -v npx >/dev/null 2>&1; then
            log_debug "Formatting Markdown: $FILE_PATH"
            npx markdownlint --fix "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Markdown formatting failed"
        fi
        ;;
    py)
        if command -v black >/dev/null 2>&1; then
            log_debug "Formatting Python (black): $FILE_PATH"
            black "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Black formatting failed"
        elif command -v autopep8 >/dev/null 2>&1; then
            log_debug "Formatting Python (autopep8): $FILE_PATH"
            autopep8 --in-place "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Autopep8 formatting failed"
        fi
        ;;
    js|jsx|ts|tsx)
        if command -v npx >/dev/null 2>&1; then
            log_debug "Formatting JS/TS (prettier): $FILE_PATH"
            npx prettier --write "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Prettier formatting failed"
        fi
        ;;
    json)
        if command -v npx >/dev/null 2>&1; then
            log_debug "Formatting JSON (prettier): $FILE_PATH"
            npx prettier --write "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Prettier formatting failed"
        elif command -v jq >/dev/null 2>&1; then
            log_debug "Formatting JSON (jq): $FILE_PATH"
            TMP_FILE="${FILE_PATH}.tmp"
            if jq '.' "$FILE_PATH" > "$TMP_FILE" 2>/dev/null; then
                mv "$TMP_FILE" "$FILE_PATH"
                FORMATTED=true
            else
                log_debug "jq formatting failed"
                rm -f "$TMP_FILE"
            fi
        fi
        ;;
    go)
        if command -v gofmt >/dev/null 2>&1; then
            log_debug "Formatting Go: $FILE_PATH"
            gofmt -w "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Gofmt failed"
        fi
        ;;
    java)
        if command -v google-java-format >/dev/null 2>&1; then
            log_debug "Formatting Java: $FILE_PATH"
            google-java-format -i "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "google-java-format failed"
        fi
        ;;
    css|scss|less)
        if command -v npx >/dev/null 2>&1; then
            log_debug "Formatting CSS: $FILE_PATH"
            npx prettier --write "$FILE_PATH" 2>/dev/null && FORMATTED=true || log_debug "Prettier (CSS) failed"
        fi
        ;;
esac

if [ "$FORMATTED" = true ]; then
    echo "✓ 已格式化: $FILE_PATH"
else
    log_debug "No changes made to $FILE_PATH"
fi
