#!/bin/bash
# relay_poll.sh - 三機跨 bot  relay 輪詢腳本
# 由 cron 每分鐘執行一次（* * * * *）
# 讀取 shared-context/BOT_RELAY.json，檢查是否有留給自己的新任務

WORKSPACE="$1"  # 自己的工作區（optional，預設走 1號機）
RELAY_FILE="/Users/bymyway/.openclaw/workspace/shared-context/BOT_RELAY.json"
BOT_ID="$2"     # 自己的 bot ID（例如 "2" 或 "3"）

if [ -z "$BOT_ID" ]; then
  echo "用法: relay_poll.sh <bot_id>  (bot_id: 1=學長, 2=學妹, 3=學弟)"
  exit 1
fi

# 讀取目前 relay 狀態
if [ ! -f "$RELAY_FILE" ]; then
  echo "[relay] 找不到 $RELAY_FILE，忽略"
  exit 0
fi

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%S.000Z)
BOT_NUM=$(basename "$0" | sed 's/relay_poll_bot//' 2>/dev/null || echo "$BOT_ID")

# 使用 python3 讀 JSON（macOS 友善）
python3 -c "
import json, sys, os

BOT_ID = '$BOT_ID'
RELAY_FILE = '$RELAY_FILE'

with open(RELAY_FILE) as f:
    relay = json.load(f)

last = relay.get('last_processed', {}).get(BOT_ID, '0')
messages = relay.get('messages', [])

for msg in messages:
    msg_id = str(msg.get('id', '0'))
    target_bot = str(msg.get('bot', ''))
    if msg_id > last and target_bot == BOT_ID:
        # 這是留給自己的新任務
        content = msg.get('content', '')
        from_bot = msg.get('from', 'unknown')
        print(f'[relay] 收到來自 {from_bot} 的任務（id={msg_id}）: {content[:80]}')
        print(f'[relay] 任務觸發成功，標記已處理')
        # 更新 last_processed
        relay['last_processed'][BOT_ID] = msg_id
        with open(RELAY_FILE, 'w') as f:
            json.dump(relay, f, ensure_ascii=False)
        sys.exit(0)  # 找到新任務，agent 處理
" 2>/dev/null

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "[relay] 新任務抵達，agent 將處理"
else
  echo "[relay] 沒有新任務（idempotent check 正常）"
fi

exit 0