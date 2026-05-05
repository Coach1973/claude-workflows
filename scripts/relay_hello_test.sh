#!/bin/bash
# 測試腳本：確認小龍蝦可以觸發終端機執行任務
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
OUTPUT_FILE="/Users/bymyway/.openclaw/workspace/terminal-notes/relay_test_output.md"

echo "## 測試結果" >> "$OUTPUT_FILE"
echo "執行時間：$TIMESTAMP" >> "$OUTPUT_FILE"
echo "狀態：✅ 成功 — 小龍蝦成功觸發終端機執行腳本" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"

echo "✅ relay_hello_test.sh 執行完成，時間：$TIMESTAMP"
