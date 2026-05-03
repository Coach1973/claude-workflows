#!/bin/bash
# Kimi 帳單監控腳本
# 使用方法: ./kimi_bill_monitor.sh

API_KEY="sk-ZX4Dqp08vtgsgq5FfZLMJ1zlFQxzXAvMheB3Si2XeJckcsTw"
LOG_FILE="/Users/bymyway/.openclaw/workspace/logs/kimi_usage.log"
ALERT_THRESHOLD=50  # 餘額低於 50 元時告警

# 取得當前用量
echo "=== Kimi 用量查詢 $(date '+%Y-%m-%d %H:%M:%S') ==="

curl -s -X GET "https://api.moonshot.ai/v1/usage" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" | tee -a "$LOG_FILE"

echo -e "\n" >> "$LOG_FILE"

# 也可以查帳戶餘額
curl -s -X GET "https://api.moonshot.ai/v1/balance" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" | tee -a "$LOG_FILE"

echo -e "\n---" >> "$LOG_FILE"

echo "查詢完成，記錄已寫入 $LOG_FILE"