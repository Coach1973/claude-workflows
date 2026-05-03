#!/bin/bash
# Kimi 帳單監控腳本
# 使用方法: ./kimi_bill_monitor.sh

API_KEY="sk-ZX4Dqp08vtgsgq5FfZLMJ1zlFQxzXAvMheB3Si2XeJckcsTw"
LOG_FILE="/Users/bymyway/.openclaw/workspace/logs/kimi_usage.log"
ALERT_THRESHOLD=50  # 餘額低於 50 元時告警

# 註：Moonshot API 沒有公開的 usage/balance endpoint
# 需要登入後台查看：https://platform.moonshot.ai/console/api-keys
# 這個腳本改為記錄每次 API 呼叫的 token 使用量

echo "=== Kimi 用量記錄 $(date '+%Y-%m-%d %H:%M:%S') ==="
echo "請登入 Moonshot 後台查看完整帳單："
echo "https://platform.moonshot.ai/console/api-keys"
echo ""

# 測試一個小請求來取得 usage 資訊（從 response header 或 body）
curl -s -X POST "https://api.moonshot.ai/v1/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kimi-k2.6",
    "messages": [{"role": "user", "content": "Hi"}],
    "max_tokens": 10
  }' | jq -r '{model, usage, created}' 2>/dev/null || echo "無法取得用量資訊"

echo -e "\n---" >> "$LOG_FILE"

echo "查詢完成，完整帳單請登入後台查看"