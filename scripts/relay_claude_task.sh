#!/bin/bash
# 用法：bash relay_claude_task.sh "任務描述"
# 說明：將任務交給 Claude 執行，結果寫入 relay_output.md

TASK="$1"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
OUTPUT="/Users/bymyway/.openclaw/workspace/terminal-notes/relay_output.md"

if [ -z "$TASK" ]; then
    echo "❌ 請提供任務描述"
    echo "用法：bash relay_claude_task.sh \"任務內容\""
    exit 1
fi

echo "## [$TIMESTAMP] 任務：$TASK" >> "$OUTPUT"
claude --print "$TASK" >> "$OUTPUT"
echo "---" >> "$OUTPUT"
echo "✅ 完成：$TASK"
